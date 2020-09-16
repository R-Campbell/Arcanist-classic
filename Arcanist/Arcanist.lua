--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]
local L = LibStub("AceLocale-3.0"):GetLocale(ARCANIST_ID, true)

-- Local variables
local Local = {}
local _G = getfenv(0)
local NU = Arcanist.Utils -- save typing

------------------------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
------------------------------------------------------------------------------------------------------

-- Creating two functions, new and del
-- New creates a temporary array, del destroys it
-- These temporary tables are stored for reuse without having to recreate them.
local new, del
do
	local cache = setmetatable({}, {__mode='k'})
	function new(populate, ...)
		local tbl
		local t = next(cache)
		if ( t ) then
			cache[t] = nil
			tbl = t
		else
			tbl = {}
		end
		if ( populate ) then
			local num = select("#", ...)
			if ( populate == "hash" ) then
				assert(math.fmod(num, 2) == 0)
				local key
				for i = 1, num do
					local v = select(i, ...)
					if not ( math.fmod(i, 2) == 0 ) then
						key = v
					else
						tbl[key] = v
						key = nil
					end
				end
			elseif ( populate == "array" ) then
				for i = 1, num do
					local v = select(i, ...)
					table.insert(tbl, i, v)
				end
			end
		end
		return tbl
	end
	function del(t)
		for k in next, t do
			t[k] = nil
		end
		cache[t] = true
	end
end

-- Define a metatable which will be applied to any table object that uses it.
-- Common functions = :insert, :remove & :sort
-- Any table declared as follows "a = setmetatable({}, metatable)" will be able to use the common functions.
local metatable = {
	__index = {
		["insert"] = table.insert,
		["remove"] = table.remove,
		["sort"] = table.sort,
	}
}

-- Create the spell metatable.
Arcanist.Spell = setmetatable({}, metatable)

------------------------------------------------------------------------------------------------------
-- DECLARATION OF VARIABLES
------------------------------------------------------------------------------------------------------

-- Detection of initialisation
Local.LoggedIn = true
Local.InWorld = false -- as addon id loaded / parsed

-- Configuration defaults
-- To be used if the configuration savedvariables is missing, or if the ArcanistConfig.Version number is changed.
Local.DefaultConfig = {
	ShowSpellTimers = true,
	CreatureAlert = true,
	ArcanistLockServ = true,
	ArcanistAngle = 180,
	HideAllButtons = false,
	Buttons = {
		Buff = true,
		Mount = true,
		ConjureFood = true,
		ConjureWater = true,
		Port = true,
		Mana = true,
	},
	ShowFoodCount = false,
	ShowWaterCount = false,
	ArcanistToolTip = true,

	MainSpell = "blink",

	PortMenuPos = {x=1, y=0},
	PortMenuOffset = {x=0, y=0},

	BuffMenuPos = {x=1, y=0},
	BuffMenuOffset = {x=0, y=0},

	ManaMenuPos = {x=1, y=0},
	ManaMenuOffset = {x=0, y=0},

	ChatMsg = true,
	ChatType = true,
	Language = GetLocale(),
	ShowCount = false,
	CountType = 3,
	ArcanistButtonScale = 90,
	ArcanistColor = "Pink",
	Sound = true,
	SpellTimerPos = 1,
	SpellTimerJust = "LEFT",
	Circle = 3,
	TimerType = 1,
	ListDirection = 1,
	ItemLocation = {},
	DestroyCount = 6,
	FramePosition = {
		["ArcanistSpellTimerButton"] = {"CENTER", "UIParent", "CENTER", 100, 300},
		["ArcanistButton"] = {"CENTER", "UIParent", "CENTER", 0, -200},
		["ArcanistFoodButton"] = {"CENTER", "UIParent", "CENTER", -34,-100},
		["ArcanistWaterButton"] = {"CENTER", "UIParent", "CENTER", -17,-100},
		["ArcanistBuffMenuButton"] = {"CENTER", "UIParent", "CENTER", 17,-100},
		["ArcanistMountButton"] = {"CENTER", "UIParent", "CENTER", 51,-100},
		["ArcanistPortMenuButton"] = {"CENTER", "UIParent", "CENTER", 85,-100},
		["ArcanistManaMenuButton"] = {"CENTER", "UIParent", "CENTER", 119,-100},
	},
	Timers = { -- Order is for options screen; overrides Mage_Spells Timer

	},
}

-- Casted spell variables (name, rank, target, target level)
Local.SpellCasted = {}

-- Timers variables
Local.TimerManagement = {
	-- Spells to timer
	SpellTimer = setmetatable({}, metatable),
	-- Association of timers to Frames
	TimerTable = setmetatable({}, metatable),
	-- Groups of timers by mobs
	SpellGroup = setmetatable(
		{
			{Name = "Main", SubName = " ", Visible = 0},
			{Name = "Cooldown", SubName = " ", Visible = 0}
		},
		metatable
	),
	-- Last cast spell
	LastSpell = {}
}

Arcanist.TimerManagement = Local.TimerManagement -- debug

-- Variables of the invocation messages
Local.SpeechManagement = {
	-- Latest messages selected
	LastSpeech = {},
	-- Messages to use after the spell succeeds
	SpellSucceed = {
		Portal = setmetatable({}, metatable)
	},
}

-- Variables used for managing hearthstone
Local.Hearthstone = { Location = {} }

Local.SomethingOnHand = "Truc"

-- Variables for managing reagents
Local.Reagent = {RuneOfTeleportation = 0, RuneOfPortals = 0}

-- Variables for managing consumables
Local.Consumables = {
	ConjuredFood = {
		count = 0,
		name = ''
	},
	ConjuredWater = {
		count = 0,
		name = ''
	},
	ManaAgate = false,
	ManaJade = false,
	ManaCitrine = false,
	ManaRuby = false,
}

-- List of buttons available in each menu
Local.Menu = {
	Buff = setmetatable({}, metatable),
	Port = setmetatable({}, metatable),
	Mana = setmetatable({}, metatable),
}

-- Active Buffs Variable
Local.BuffActif = {}

-- Variable of the state of the buttons (grayed or not)
Local.Desatured = {}

-- Last image used for the sphere
Local.LastSphereSkin = "Any"

-- Time elapsed between two OnUpdate events
Local.LastUpdate = {0, 0}

-- Use these to get buffs via OnUpdate on init
Local.buff_needed = false
Local.buff_attempts = 0

LocalZZYY = Local
------------------------------------------------------------------------------------------------------
-- ARCANIST helper routines
------------------------------------------------------------------------------------------------------
local function BagNamesKnown()
	local res = true
	for container = 0, NUM_BAG_SLOTS, 1 do
		local name, id = NU.GetBagName(container)
		if name then
			-- bag name is in cache
		else
			res = false
			break
		end
	end

	return res
end

-- Function to check the presence of a buff on the unit.
-- Strictly identical to UnitHasEffect, but as WoW distinguishes Buff and DeBuff, so we have to.
function UnitHasBuff(unit, effect)
	local res = false
	for i=1,40 do
	  local name, icon, count, debuffType, duration,
		expirationTime, source, isStealable, nameplateShowPersonal, spellId,
		canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod
		= UnitBuff(unit,i)
		if name then
			if name == effect then
				res = true
				break
			else
				-- continue
			end
		else
			break -- no more
		end
	end

	return res
end

-- Function to check the presence of a debuff on the unit
-- F(string, string)->bool
function UnitHasEffect(unit, effect)
	local res = false
	for i=1,40 do
		local name, icon, count, debuffType, duration,
			expirationTime, source, isStealable, nameplateShowPersonal, spellId,
			canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod
			= UnitDebuff(unit,i)
		if name then
			if name == effect then
				res = true
				break
			else
				-- continue
			end
		else
			break -- no more
		end
	end

	return res
end

-- Function updating the Arcanist buttons
function Arcanist.UpdateIcons()
	-- Set up Conjure Food Button
	Arcanist:ConjureFoodUpdateAttribute()

	-- Set up Conjure Water Button
	Arcanist:ConjureWaterUpdateAttribute()

	-- Set up Mount Button
	Arcanist:MountUpdateAttribute()

	-- Set up Teleport buttons
	Arcanist:PortUpdateAttribute()

	-- Set up Mana Gem buttons
	Arcanist:ManaSpellAttribute()
end

-- Event : UNIT_SPELLCAST_SUCCEEDED
-- Manages everything related to successful spell casts
function Arcanist.SpellManagement(SpellCasted)
	local SortActif = false
	local cast_spell = SpellCasted
	if (cast_spell.Name) then
		-- Messages Post Cast
		-- Local.SpeechManagement.SpellSucceed = Arcanist:Speech_Then(cast_spell, Local.SpeechManagement.SpellSucceed)

		local spell = Arcanist.GetSpellById(cast_spell.Id)
		if spell.Timer then
			local target = {
				name = cast_spell.TargetName,
				lvl  = cast_spell.TargetLevel,
				guid = cast_spell.TargetGUID,
			}

			local cast_info = {
				usage = spell.Usage,
				spell_id  = cast_spell.Id,
				guid = cast_spell.Guid,
			}

			if Arcanist.Debug.spells_cast then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("Arcanist.SpellManagement"
				.." s'"..tostring(cast_spell.Name or "null").."'"
				.." u'"..tostring(cast_info.usage or "null").."'"
				.." tn'"..tostring(target.name or "null").."'"
				.." tl'"..tostring(target.lvl or "null").."'"
				.." tg'"..tostring(target.guid or "null").."'"
				)
			end

			Local.TimerManagement = Arcanist:TimerInsert(cast_info, target, Local.TimerManagement, "spell cast")
		end
	end

	return
end

-- Events : CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS, CHAT_MSG_SPELL_AURA_GONE_SELF et CHAT_MSG_SPELL_BREAK_AURA
-- Manage the appearing and disappearing effects on the mage
-- Based on CombatLog
function SelfEffect(action, name)
	if action == "BUFF" then
		-- todo: do I need to add buffs here?
	else
		-- todo: ?
	end
	Arcanist:UpdateMana()
	return
end

------------------------------------------------------------------------------------------------------
-- ARCANIST FUNCTIONS
------------------------------------------------------------------------------------------------------
local function SatList(list, val)
	for i, v in pairs(list) do
		menuVariable = _G[Arcanist.Mage_Buttons[v.f_ptr].f]
		if menuVariable then
			menuVariable:GetNormalTexture():SetDesaturated(val)
		end
	end
end

local function SetupSpells(reason)
	Arcanist:SpellSetup(reason)

	if not InCombatLockdown() then
		Arcanist:MainButtonAttribute()
		Arcanist:BuffSpellAttribute()
	end

	-- (re)create the icons around the main sphere
	Arcanist:CreateMenu()
	Arcanist:ButtonSetup()

	-- Check for stones - the buttons can be updated as needed
	Arcanist:BagExplore()
end

--[[ SetupBuffTimers
This routine is invoked during initialization to get mage buffs, if any.
However, it seems buffs are not available until after Arcanist initializes on a login.
Use variables above and OnUpdate to get them, if needed.
--]]
local function SetupBuffTimers()
	if Arcanist.Debug.init_path then
		print("SetupBuffTimers"
			.." bn'"..tostring(Local.buff_needed).."'"
			.." ba'"..tostring(Local.buff_attempts).."'"
			)
	end
	local buffs_found = false
	local res = false
	for i=1,40 do -- hate hard coded numbers! Forums suggest the max buffs is 32 but no one is sure...
	  local name, icon, count, debuffType, duration,
		expirationTime, source, isStealable, nameplateShowPersonal, spellId,
		canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod
		= UnitBuff("player", i)

		if name then
			buffs_found = true
			if Arcanist.Debug.init_path then
				print("SetupBuffTimers"
					.." '"..name.."'"
					.." "..Arcanist.Utils.TimeLeft(expirationTime-GetTime())
					)
			end

			local s_id, s_usage, s_timer, s_buff, s_cool = Arcanist.GetSpellByName(name)
			if s_timer and s_buff then
				local target = {
						name = UnitName("player"),
						lvl  = UnitLevel("player"),
						guid = UnitGUID("player"),
						}
				local cast_info = {
					usage = s_usage,
					spell_id  = s_id,
					guid = "",
					}
				Local.TimerManagement = Arcanist:TimerInsert(cast_info, target, Local.TimerManagement, "buff found", expirationTime-duration, duration, s_cool)
			else
			end
		else
			break -- no more
		end
	end

	if buffs_found or (Local.buff_attempts >= 5) then
		-- we are ok
		Local.buff_needed = false
		Local.buff_attempts = 0
	else
		-- There could be no buffs or they are not ready yet
		-- Check every second up to the max attempts above
		Local.buff_needed = true
		Local.buff_attempts = Local.buff_attempts + 1
	end
end

local function StartInit(fm)
	-- unregister, server can spam unrelated ids  !?
	fm:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
	-- Initialization of the mod
	Arcanist:Initialize(Local.DefaultConfig)
	-- Set timers if any buffs are on
	SetupBuffTimers()

	--[[ Once the localized strings are known, build the buttons.
	--]]
	Local.InWorld = true
end

-- Function started when updating the interface (main) - every 0.1 seconds
function Arcanist:OnUpdate(something, elapsed)
	Local.LastUpdate[1] = Local.LastUpdate[1] + elapsed
	Local.LastUpdate[2] = Local.LastUpdate[2] + elapsed

	-- If smooth scroll timers, we update them as soon as possible
	if ArcanistConfig.Smooth then
		ArcanistUpdateTimer(Local.TimerManagement.SpellTimer)
	end

	-- If timers texts, we update them very quickly also
	if ArcanistConfig.TimerType == 2 then
		Arcanist:TextTimerUpdate(Local.TimerManagement.SpellTimer, Local.TimerManagement.SpellGroup)
	end

	-- Every second
	if Local.LastUpdate[1] > 1 then
		-- Timers Table Course
		if Local.TimerManagement.SpellTimer[1] then
			for index = 1, #Local.TimerManagement.SpellTimer, 1 do
				if Local.TimerManagement.SpellTimer[index] then
					-- We remove the completed timers
					local TimeLocal = GetTime()
					if TimeLocal >= (Local.TimerManagement.SpellTimer[index].TimeMax - 0.5) then
						local StoneFade = false
						if Local.TimerManagement.SpellTimer[index].Name == Arcanist.GetSpellName("polymorph") then
							Local.TimerManagement.Polymorph = false
						end
						Local.TimerManagement = Arcanist:RemoveTimerByIndex(index, Local.TimerManagement)
						index = 0
					end
				end
			end
		end

		if Local.buff_needed then
			SetupBuffTimers()
		end

		Local.LastUpdate[1] = 0
	-- Every half second
	elseif Local.LastUpdate[2] > 0.5 then
		-- If normal graphical timers scroll, then we update every 0.5 seconds
		if not ArcanistConfig.Smooth then
			ArcanistUpdateTimer(Local.TimerManagement.SpellTimer)
		end
		Local.LastUpdate[2] = 0
	end
end

------------------------------------------------------------------------------------------------------
-- FUNCTIONS ARCANIST "ON EVENT"
------------------------------------------------------------------------------------------------------
--[[ Function started according to the intercepted event
NOTE: At entering world AND a mage, this attempts to get localized strings from WoW.
This may take calls to the server on first session login of a mage. The init of Arcanist is delayed until those strings are done.
This *should* happen quickly. Waiting avoids issues by ensuring localized strings are known before used.
--]]
function Arcanist:OnEvent(self, event,...)
	local arg1,arg2,arg3,arg4,arg5,arg6 = ...

	local fm = _G[Arcanist.Mage_Buttons.main.f]
	local ev = {} -- debug

	if (event == "PLAYER_LOGIN") then
		if Arcanist.Debug.init_path or Arcanist.Debug.events then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("Init ::: PLAYER_LOGIN"
			)
		end
	elseif (event == "PLAYER_LEAVING_WORLD") then
		if Arcanist.Debug.init_path or Arcanist.Debug.events then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("Init ::: PLAYER_LEAVING_WORLD"
			)
		end
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		local _, Class = UnitClass("player")
		if Arcanist.Debug.events then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("Init ::: PLAYER_ENTERING_WORLD"
			.." '"..tostring(done or "null").."'"
			.." '"..tostring(Local.InWorld or "null").."'"
			)
		end
		if Class == "MAGE" then
			if Local.InWorld then
			else
				if Arcanist.Debug.init_path then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage("Init ::: Prepare Arcanist"
					.." '"..tostring(done or "null").."'"
					)
				end
				-- get localized names for mage items, this may require calls to WoW server
				fm:RegisterEvent("GET_ITEM_INFO_RECEIVED")
				BagNamesKnown() -- need the localized names...
				Arcanist.InitMageItems()
				if Arcanist.MageItemsDone() then --and BagNamesKnown() then
					StartInit(fm)
				else -- safe to start up
					-- need to wait for server - GET_ITEM_INFO_RECEIVED
				end
			end
		end
	elseif event == "GET_ITEM_INFO_RECEIVED" then
		-- Process the server response: arg1 is item id; arg2 is success / fail
		Arcanist.SetItem(arg1, arg2)
		if Arcanist.MageItemsDone() then --and BagNamesKnown() then
			if Arcanist.Debug.init_path or Arcanist.Debug.events then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("Init ::: GET_ITEM_INFO_RECEIVED"
				.." '"..tostring(Arcanist.MageItemsDone() or "null").."'"
				)
			end
			StartInit(fm)
		else -- safe to start up
			-- need to wait for server to give more localized strings
		end
	end

	-- Is the game well loaded?
	-- Allow a full initialize before events start being processed
	if not Local.InWorld then
		return
	end

	if (event == "SPELLS_CHANGED") then
		if InCombatLockdown() then
			-- should not get these in combat but ...
		else
			-- safe to process new spells and rebuild buttons
			SetupSpells("SPELLS_CHANGED")
		end
	end

	-- If the contents of the bags have changed
	if (event == "BAG_UPDATE") then
		Arcanist:BagExplore(arg1)
	-- If the player gains or loses mana
	elseif (event == "UNIT_POWER_UPDATE") and arg1 == "player" then
		Arcanist:UpdateMana()
	-- If the player gains or loses life
	elseif (event == "UNIT_HEALTH") and arg1 == "player" then
		Arcanist:UpdateHealth()
	-- If the player dies
	elseif (event == "PLAYER_DEAD") then
		-- It may hide the Twilight or Backlit buttons.
		Local.Dead = true
		-- We gray all the spell buttons
		local f = _G[Arcanist.Mage_Buttons.mount.f]
		if f then
			f:GetNormalTexture():SetDesaturated(1)
		end
		SatList(Arcanist.Mage_Lists.buffs, 1)
		SatList(Arcanist.Mage_Lists.ports, 1)
		SatList(Arcanist.Mage_Lists.mana_gems, 1)
	-- If the player resurrects
	elseif 	(event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST") then
		-- We are sobering all the spell buttons
		local f = _G[Arcanist.Mage_Buttons.mount.f]
		if f then
			f:GetNormalTexture():SetDesaturated(nil)
		end
		SatList(Arcanist.Mage_Lists.buffs, nil)
		SatList(Arcanist.Mage_Lists.ports, nil)
		SatList(Arcanist.Mage_Lists.mana_gems, nil)
		-- We reset the gray button list
		Local.Desatured = {}
		Local.Dead = false
	-- Successful spell casting management
	elseif (event == "UNIT_SPELLCAST_SUCCEEDED") and arg1 == "player" then
		-- UNIT_SPELLCAST_SUCCEEDED: "unitTarget", "castGUID", spellID - https://wow.gamepedia.com/UNIT_SPELLCAST_SUCCEEDED
		-- This can get chatty as other 'casts' are sent such as enchanting / skinning / ...
		local target, cast_guid, spell_id = arg1, arg2, arg3
		if Arcanist.Debug.events or Arcanist.Debug.spells_cast then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("UNIT_SPELLCAST_SUCCEEDED"
			.." sid'"..tostring(spell_id or "null").."'"
			.." t'"..tostring(target or "null").."'"
			.." cg'"..tostring(cast_guid or "null").."'"
			)
		end
		if Local.SpellCasted[cast_guid] then -- processing this one
			local sc = Local.SpellCasted[cast_guid]

			if (target == nil or target == "")
			then -- some spells only have the target on success
				Local.SpellCasted[cast_guid].TargetName = UnitName("player")
				Local.SpellCasted[cast_guid].TargetGUID = UnitGUID("target")
				Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("target")
			end
			if Arcanist.Debug.spells_cast then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("UNIT_SPELLCAST_SUCCEEDED"
				.." a1'"..tostring(arg1).."'"
				.." a2'"..tostring(arg2).."'"
				.." a3'"..tostring(arg3).."'"
				.." '"..tostring(GetSpellInfo(arg3)).."'"
				)
				_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>>>_SPELLCAST_SUCCEEDED"
				.." "..tostring((sc.Guid == cast_guid) and "ok" or "!?")..""
				.." g'"..tostring(sc.Guid or "null").."'"
				.." i'"..tostring(sc.Id or "null").."'"
				.." n'"..tostring(sc.Name or "null").."'"
				.." u'"..tostring(sc.Unit or "null").."'"
				)
				_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>>>_SPELLCAST_SUCCEEDED"
				.." tn'"..tostring(sc.TargetName or "null").."'"
				.." tl'"..tostring(sc.TargetLevel or "null").."'"
				)
				_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>>>_SPELLCAST_SUCCEEDED"
				.." g'"..tostring(sc.Guid or "null").."'"
				.." tg'"..tostring(sc.TargetGUID or "null").."'"
				)
			end
			sc = nil

			Arcanist.SpellManagement(Local.SpellCasted[cast_guid])
			Local.SpellCasted[cast_guid] = {} -- processed so clear
		end
		target, cast_guid, spell_id = nil, nil, nil

	-- When the mage begins to cast a spell, we get the spell name and id
	elseif (event == "UNIT_SPELLCAST_SENT") then
		-- UNIT_SPELLCAST_SENT: "unit", "target", "castGUID", spellID - https://wow.gamepedia.com/UNIT_SPELLCAST_SENT
		-- Example:   player Starving Dire Wolf Cast-3-4379-0-140-6223-0005C729D2 6223
		-- Expect a SUCCESS or FAILED or INTERRUPTED after this
		-- Rely on castGUID to be unique. This allows the exact timer, if any, to added or removed as needed

		local unit, target, cast_guid, spell_id = arg1, arg2, arg3, arg4
		if Arcanist.Debug.events or Arcanist.Debug.spells_cast then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("UNIT_SPELLCAST_SENT"
			.." sid'"..tostring(spell_id or "null").."'"
			.." sg'"..tostring(cast_guid or "null").."'"
			.." u'"..tostring(unit or "null").."'"
			.." t'"..tostring(target or "null").."'"
			)
		end

		Local.SpellCasted[cast_guid] = {} -- start an entry
		if spell_id and Arcanist.GetSpellById(spell_id) then -- it is a spell to process
			local spell = Arcanist.GetSpellById(spell_id)

			if (target == nil or target == "")
			and spell.Buff
			then
				-- Not all UNIT_SPELLCAST_SENT events specify the target (player for Arcane Intellect)...
				Local.SpellCasted[cast_guid].TargetName = UnitName("player")
				Local.SpellCasted[cast_guid].TargetGUID = UnitGUID("player")
				Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("player")
			elseif target == nil or target == "" then
				Local.SpellCasted[cast_guid].TargetName = ""
				Local.SpellCasted[cast_guid].TargetGUID = ""
				Local.SpellCasted[cast_guid].TargetLevel = ""
			else
				Local.SpellCasted[cast_guid].TargetName = target
				Local.SpellCasted[cast_guid].TargetGUID = UnitGUID("target")
				Local.SpellCasted[cast_guid].TargetLevel = UnitLevel("target")
			end
			Local.SpellCasted[cast_guid].Name = spell.Name
			Local.SpellCasted[cast_guid].Id = spell_id
			Local.SpellCasted[cast_guid].Guid = cast_guid
			Local.SpellCasted[cast_guid].Unit = unit

			local sc = Local.SpellCasted[cast_guid]
			if Arcanist.Debug.spells_cast then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>UNIT_SPELLCAST_SENT"
				.." '"..tostring(cast_guid or "null").."'"
				.." '"..tostring(sc.Name or "null").."'"
				.." '"..tostring(sc.TargetName or "null").."'"
				)
			end
			sc = nil

			Local.SpeechManagement = Arcanist:Speech_It(Local.SpellCasted[cast_guid], Local.SpeechManagement, metatable)
		end

		unit, target, cast_guid, spell_id = nil, nil, nil, nil
		-- Wait for a succeed or miss event.
		-- If the spell is resisted it will likely come AFTER a success event so the timer needs to be removed.

	-- When the mage stops his incantation, we release the name of it
	elseif (event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED") and arg1 == "player" then
		-- UNIT_SPELLCAST_FAILED: "unitTarget", "castGUID", spellID
		-- UNIT_SPELLCAST_INTERRUPTED: "unitTarget", "castGUID", spellID

		if Arcanist.Debug.events or Arcanist.Debug.spells_cast then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage(event
				.." a1'"..tostring(arg1).."'"
				.." a2'"..tostring(arg2).."'"
				.." a3'"..tostring(arg3).."'"
				.." '"..tostring(GetSpellInfo(arg3)).."'"
				)
		end

		if Local.SpellCasted[arg2] then -- safety to ensure the spell was sent and we are 'tracking' it
			-- Send to delete any timer that exist...
			Local.TimerManagement = Arcanist:RemoveTimerByCast(arg2, Local.TimerManagement, "UNIT_SPELLCAST_FAILED")
		end
		Local.SpellCasted[arg2] = {}
	-- Flag if a Trade window is open, so you can automatically trade the healing stones
	-- TODO: Change this to water
	elseif event == "TRADE_REQUEST" or event == "TRADE_SHOW" then
		--Local.Trade.Request = true
	elseif event == "TRADE_REQUEST_CANCEL" or event == "TRADE_CLOSED" then
		--Local.Trade.Request = false
	elseif event=="TRADE_ACCEPT_UPDATE" then
		--if Local.Trade.Request and Local.Trade.Complete then
		--	AcceptTrade()
		--	Local.Trade.Request = false
		--	Local.Trade.Complete = false
		--end
	elseif event == "PLAYER_TARGET_CHANGED" then

	-- If the Mage learns a new spell / spell, we get the new spells list
	-- If the Mage learns a new buff or summon spell, the buttons are recreated
	elseif (event == "LEARNED_SPELL_IN_TAB") then
		SetupSpells("LEARNED_SPELL_IN_TAB")

	-- At the end of the fight, we stop reporting Twilight
	-- We remove the spell timers and the names of mobs
	elseif (event == "PLAYER_REGEN_ENABLED") then
		Local.PlayerInCombat = false
		Local.TimerManagement = Arcanist:RemoveCombatTimer(Local.TimerManagement, "PLAYER_REGEN_ENABLED")

		-- We are redefining the attributes of spell buttons in a situational way
		Arcanist:NoCombatAttribute(Local.Menu.Buff, Local.Menu.Port, Local.Menu.Mana)
		Arcanist.UpdateIcons()
	-- Reading the combat log
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		-- The parameters differ depending on the event... - https://wow.gamepedia.com/COMBAT_LOG_EVENT
		local a1, a2, a3, a4, a5,
			a6, a7, a8, a9, a10,
			a11, a12, a13, a14, a15
			= CombatLogGetCurrentEventInfo()
		local timestamp = a1
		local subevent = a2
		local sourceGUID = a4
		local sourceName = a5
		local sourceFlags = a6
		local sourceRaidFlags = a7
		local destGUID = a8
		local destName = a9
		local destFlags = a10
		local destRaidFlags = a11
		local spellId = a12
		local Effect = a13
		local spellSchool = a14
		ev={CombatLogGetCurrentEventInfo()}

		-- this will output a lot of spells not processed but it can be informative
		if (UnitName("player") == sourceName)
		or (UnitName("player") == destName)
		then
			if Arcanist.Debug.events then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("COMBAT_LOG"
					.." e'"..tostring(Effect or "null").."'"
					.." se'"..tostring(subevent or "null").."'"
					.." s'"..tostring(sourceName or "null").."'"
					.." d'"..tostring(destName or "null").."'"
					.." sid'"..tostring(spellId or "null").."'"
					.." sp'"..tostring(spellSchool or "null").."'"
					.." a15'"..tostring(a15 or "null").."'"
					.." #'"..tostring(#ev or "null").."'"
					)
			end
		end

		if subevent == "SPELL_AURA_APPLIED" then
			-- This is received for every aura with in range so output only what we process
			if destGUID == UnitGUID("player") then
				if Arcanist.Debug.spells_cast then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage(event
						.." e'"..tostring(Effect or "null").."'"
						.." se'"..tostring(subevent or "null").."'"
						.." s'"..tostring(sourceName or "null").."'"
						.." d'"..tostring(destName or "null").."'"
						.." sid'"..tostring(spellId or "null").."'"
						.." sp'"..tostring(spellSchool or "null").."'"
						.." a15'"..tostring(a15 or "null").."'"
						.." #'"..tostring(#ev or "null").."'"
						)
				end

				SelfEffect("BUFF", Effect)
			end

		elseif subevent == "SPELL_AURA_REMOVED" then
			-- This is received for every aura with in range so output only what we process
			if destGUID == UnitGUID("player") then
				if Arcanist.Debug.spells_cast then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage(event
						.." e'"..tostring(Effect or "null").."'"
						.." se'"..tostring(subevent or "null").."'"
						.." s'"..tostring(sourceName or "null").."'"
						.." d'"..tostring(destName or "null").."'"
						.." sid'"..tostring(spellId or "null").."'"
						.." sp'"..tostring(spellSchool or "null").."'"
						.." a15'"..tostring(a15 or "null").."'"
						.." #'"..tostring(#ev or "null").."'"
						)
				end

				SelfEffect("DEBUFF", Effect)
			end
			if destGUID == UnitGUID("focus")
				and Local.TimerManagement.Polymorph
				and Effect == Arcanist.GetSpellName("polymorph")
			then
				if Arcanist.Debug.spells_cast then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage(event
						.." e'"..tostring(Effect or "null").."'"
						.." se'"..tostring(subevent or "null").."'"
						.." s'"..tostring(sourceName or "null").."'"
						.." d'"..tostring(destName or "null").."'"
						.." sid'"..tostring(spellId or "null").."'"
						.." sp'"..tostring(spellSchool or "null").."'"
						.." a15'"..tostring(a15 or "null").."'"
						.." #'"..tostring(#ev or "null").."'"
						)
				end
				Arcanist:Msg("POLY ! POLY ! POLY !")
				Local.TimerManagement = Arcanist:RemoveTimerByName(
					Arcanist.GetSpellName("polymorph"),
					Local.TimerManagement,
					"SPELL_AURA_REMOVED polymorph"
				)
				Local.TimerManagement.Polymorph = false
			end

			-- Remove any timer with same name on the target
			-- Note: The remove timer is called way more than is needed but this will handle removing timers for mobs that are not current target or focus
			if (UnitName("player") == sourceName) then
				Local.TimerManagement = Arcanist:RemoveTimerByNameAndGuid(Effect, destGUID, Local.TimerManagement, "SPELL_AURA_REMOVED")
			end
		-- Debian Detection
		-- Resist / immune detection
		elseif subevent == "SPELL_MISSED" and sourceGUID == UnitGUID("player") then
			-- The 1st 8 arguments are always timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags
			-- "SPELL_MISSED" spellId, spellName, spellSchool, missType
			-- Will cleanup timers even if not target or focus

			if Arcanist.Debug.spells_cast then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage(event
					.." a1'"..tostring(a1 or "null").."'"
					.." a2'"..tostring(a2 or "null").."'"
					.." a3'"..tostring(a3 or "null").."'"
					.." a4'"..tostring(a4 or "null").."'"
					.." a5'"..tostring(a5 or "null").."'"
					.." a6'"..tostring(a6 or "null").."'"
					.." a7'"..tostring(a7 or "null").."'"
					.." a8'"..tostring(a8 or "null").."'"
					.." a9'"..tostring(a9 or "null").."'"
					.." a10'"..tostring(a10 or "null").."'"
					.." a11'"..tostring(a11 or "null").."'"
					.." a12'"..tostring(a12 or "null").."'"
					.." a13'"..tostring(a13 or "null").."'"
					.." a14'"..tostring(a14 or "null").."'"
					.." a15'"..tostring(a15 or "null").."'"
					.." #'"..tostring(#ev or "null").."'"
					)
			end
			if (UnitName("player") == sourceName) then
				Local.TimerManagement = Arcanist:RemoveTimerByNameAndGuid(Effect, destGUID, Local.TimerManagement, "spell missed")
			end
		elseif subevent == "UNIT_DIED" then
			-- Any unit death within range
			-- Will cleanup timers even if not target or focus

			if Arcanist.Debug.events then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("UNIT_DIED"
				.." e'"..tostring(Effect or "null").."'"
				.." se'"..tostring(subevent or "null").."'"
				.." s'"..tostring(sourceName or "null").."'"
				.." sg'"..tostring(sourceGUID or "null").."'"
				.." d'"..tostring(destName or "null").."'"
				.." dg'"..tostring(destGUID or "null").."'"
				.." #'"..tostring(#ev or "null").."'"
				)
			end

			Local.TimerManagement = Arcanist:RemoveTimerByGuid(destGUID, Local.TimerManagement, "UNIT_DIED")
		end

	-- If we change weapons, we look at whether a spell / fire enchantment is on the new
	elseif event == "PLAYER_REGEN_DISABLED" then
		Local.PlayerInCombat = true
		-- Close the options menu
		if _G["ArcanistGeneralFrame"] and ArcanistGeneralFrame:IsVisible() then
			ArcanistGeneralFrame:Hide()
		end
		-- Spell button attributes are negated situational
		Arcanist:InCombatAttribute(Local.Menu.Buff, Local.Menu.Port)
	end
	return
end

------------------------------------------------------------------------------------------------------
-- INTERFACE FUNCTIONS - XML ​​LINKS
------------------------------------------------------------------------------------------------------

-- Function to move Arcanist elements on the screen
function Arcanist:OnDragStart(button)
	button:StartMoving()
end

-- Function stopping the movement of Arcanist elements on the screen
function Arcanist:OnDragStop(button)
	-- We stop the movement effectively
	button:StopMovingOrSizing()
	-- We save the location of the button
	local ButtonName = button:GetName()
	local AnchorButton, ParentButton, AnchorParent, ButtonX, ButtonY = button:GetPoint()
	if not ParentButton then
		ParentButton = "UIParent"
	else
		ParentButton = ParentButton:GetName()
	end
	if Arcanist.Debug.frames then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage(
			"OnDragStop"
			.." bn'"..tostring(ButtonName).."'"
			.." ab'"..tostring(AnchorButton).."'"
			.." pb'"..tostring(ParentButton).."'"
			.." ap'"..tostring(AnchorParent).."'"
			.." bx'"..tostring(ButtonX).."'"
			.." by'"..tostring(ButtonY).."'"
		)
	end
	ArcanistConfig.FramePosition[ButtonName] = {AnchorButton, ParentButton, AnchorParent, ButtonX, ButtonY}
end

-- For some users, GetSpellCooldown returns nil so ensure there are no 'nil errors', may cause odd quirks elsewhere...
local function Cooldown(usage)
	local start
	local dur

	if Arcanist.IsSpellKnown(usage) then
		start, dur = GetSpellCooldown(Arcanist.Mage_Spell_Use[usage], BOOKTYPE_SPELL) -- grab the spell id
		if not start then start = 1 end
		if not dur then dur = 1 end
	else
		start = 1
		dur = 1
	end

	return start, dur
end

-- helpers to reduce maintenance
local function ManaLocalize(mana)
	if GetLocale() == "ruRU" then
		GameTooltip:AddLine("|c00FFFFFF"..L["MANA"]..": "..mana.."|r")
	else
		GameTooltip:AddLine("|c00FFFFFF"..mana.." "..L["MANA"].."|r")
	end
end

local function AddCost(usage)
	ManaLocalize(Arcanist.GetSpellMana(usage))
end

local function AddCastAndCost(usage)
	GameTooltip:AddLine(Arcanist.GetSpellCastName(usage))
	AddCost(usage)
end

local function SetTitleWithRankAndCost(usage)
	GameTooltip:SetText("|c00FFFFFF"..Arcanist.GetSpellName(usage).."|r |c00999999 (Rank "..Arcanist.GetSpellRank(usage)..")|r")
	AddCost(usage)
end

local function AddRuneOfTeleportationReagent()
	if Local.Reagent.RuneOfTeleportation == 0 then
		GameTooltip:AddLine("|c00FF4444"..Arcanist.TooltipData.Main.RuneOfTeleportation..Local.Reagent.RuneOfTeleportation.."|r")
	else
		GameTooltip:AddLine(Arcanist.TooltipData.Main.RuneOfTeleportation..Local.Reagent.RuneOfTeleportation)
	end
end

local function AddRuneOfPortalsReagent()
	if Local.Reagent.RuneOfPortals == 0 then
		GameTooltip:AddLine("|c00FF4444"..Arcanist.TooltipData.Main.RuneOfPortals..Local.Reagent.RuneOfPortals.."|r")
	else
		GameTooltip:AddLine(Arcanist.TooltipData.Main.RuneOfPortals..Local.Reagent.RuneOfPortals)
	end
end

local function AddMenuTip(Type)
	if Local.PlayerInCombat and ArcanistConfig.AutomaticMenu then
		GameTooltip:AddLine(Arcanist.TooltipData[Type].Text2)
	else
		GameTooltip:AddLine(Arcanist.TooltipData[Type].Text)
	end
end

local function BuildMainButtonTooltip()
	GameTooltip:AddLine(Arcanist.TooltipData.Main.ConjuredFood..Local.Consumables.ConjuredFood.count)
	GameTooltip:AddLine(Arcanist.TooltipData.Main.ConjuredWater..Local.Consumables.ConjuredWater.count)
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(Arcanist.TooltipData.Main.ManaAgate..Arcanist.TooltipData.Main.Boolean[Local.Consumables.ManaAgate])
	GameTooltip:AddLine(Arcanist.TooltipData.Main.ManaJade..Arcanist.TooltipData.Main.Boolean[Local.Consumables.ManaJade])
	GameTooltip:AddLine(Arcanist.TooltipData.Main.ManaCitrine..Arcanist.TooltipData.Main.Boolean[Local.Consumables.ManaCitrine])
	GameTooltip:AddLine(Arcanist.TooltipData.Main.ManaRuby..Arcanist.TooltipData.Main.Boolean[Local.Consumables.ManaRuby])
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(Arcanist.TooltipData.Main.RuneOfTeleportation..Local.Reagent.RuneOfTeleportation)
	GameTooltip:AddLine(Arcanist.TooltipData.Main.RuneOfPortals..Local.Reagent.RuneOfPortals)
end

local function BuildConjureFoodButtonTooltip()
	SetTitleWithRankAndCost("conjure_food")

	-- L click - use
	local str = Arcanist.TooltipData["ConjureFood"].Text[2]

	GameTooltip:AddLine(str)

	-- R click - create
	str = Arcanist.TooltipData["ConjureFood"].Text[1]

	GameTooltip:AddLine(str)
end

local function BuildConjureWaterButtonTooltip()
	SetTitleWithRankAndCost("conjure_water")

	-- L click - use
	local str = Arcanist.TooltipData["ConjureWater"].Text[2]

	GameTooltip:AddLine(str)

	-- R click - create
	str = Arcanist.TooltipData["ConjureWater"].Text[1]

	GameTooltip:AddLine(str)
end

local function BuildConjureManaButtonTooltip(usage)
	AddCost(usage)

	-- L click - use
	local str = Arcanist.TooltipData["ConjureWater"].Text[2]

	GameTooltip:AddLine(str)

	-- R click - create
	str = Arcanist.TooltipData["ConjureWater"].Text[1]

	GameTooltip:AddLine(str)
end

-- Function managing the help bubbles
function Arcanist:BuildButtonTooltip(button)
	-- If the display of help bubbles is disabled, Bye bye!
	if not ArcanistConfig.ArcanistToolTip then
		return
	end

	local f = button:GetName()
	local Type = ""
	local b = nil

	-- look up the button info
	for i, v in pairs (Arcanist.Mage_Buttons) do
		if v.f == f then
			Type = Arcanist.Mage_Buttons[i].tip
			b = v
			break
		else
		end
	end

	if b.tip == nil then
		return -- a button we are not interested in was given
	else
		Type = b.tip
	end

	if Arcanist.Debug.tool_tips then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("BuildButtonTooltip"
		.." b'"..tostring(f).."'"
		.." T'"..tostring(Type).."'"
		.." l'"..tostring(Arcanist.TooltipData[Type].Label).."'"
		.." t'"..tostring(Arcanist.TooltipData[Type].Text).."'"
		)
	end

	anchor = b.anchor or "ANCHOR_RIGHT" -- put to right in case not specified...

	-- Creating help bubbles ....
	GameTooltip:SetOwner(button, anchor)
	GameTooltip:SetText(Arcanist.TooltipData[Type].Label)

	if (Type == "Main") then BuildMainButtonTooltip(f, Type)
	elseif (Type == "ConjureFood") then BuildConjureFoodButtonTooltip(f, Type)
	elseif (Type == "ConjureWater") then BuildConjureWaterButtonTooltip(f, Type)
	elseif (Type == "SpellTimer") then
		GameTooltip:AddLine(Arcanist.TooltipData[Type].Text)
		local cool = ""
		local color = ""
		local str = Arcanist.TooltipData[Type].Right..GetBindLocation()
		if Local.Hearthstone.Location[1] and Local.Hearthstone.Location[2] then
			local startTime, duration, isEnabled = GetContainerItemCooldown(Local.Hearthstone.Location[1], Local.Hearthstone.Location[2])
			if startTime == 0 then
				color = "|CFFFFFFFF"
			else
				color = "|CFF808080"
				cool = " - "..Arcanist.Utils.TimeLeft(((startTime - GetTime()) + duration))
			end
		end
		GameTooltip:AddLine(color..str..cool.."|r")
	-- ..... for other buffs, the rank and mana cost ...
	elseif (Type == "BuffMenu")		then AddMenuTip(Type)
	elseif (Type == "ArcaneIntellect") then SetTitleWithRankAndCost("arcane_intellect")
	elseif (Type == "IceArmor") then SetTitleWithRankAndCost("ice_armor")
	elseif (Type == "MageArmor") then SetTitleWithRankAndCost("mage_armor")
	elseif (Type == "ManaShield") then SetTitleWithRankAndCost("mana_shield")
	elseif (Type == "AmplifyMagic") then SetTitleWithRankAndCost("amplify_magic")
	elseif (Type == "DampenMagic") then SetTitleWithRankAndCost("dampen_magic")
	elseif (Type == "FrostWard") then SetTitleWithRankAndCost("frost_ward")
	elseif (Type == "FireWard") then SetTitleWithRankAndCost("fire_ward")
	elseif (Type == "Polymorph") then SetTitleWithRankAndCost("polymorph")
	elseif (Type == "Mount") then GameTooltip:AddLine(Arcanist.TooltipData[Type].Text)
	-- ..... for ports, the mana cost and reagent requirement ...
	elseif (Type == "PortMenu")		then AddMenuTip(Type)
	elseif (Type == "TeleportDarnassus") then AddCost("teleport_darnassus"); AddRuneOfTeleportationReagent()
	elseif (Type == "TeleportIronforge") then AddCost("teleport_ironforge"); AddRuneOfTeleportationReagent()
	elseif (Type == "TeleportStormwind") then AddCost("teleport_stormwind"); AddRuneOfTeleportationReagent()
	elseif (Type == "TeleportUndercity") then AddCost("teleport_undercity"); AddRuneOfTeleportationReagent()
	elseif (Type == "TeleportOrgrimmar") then AddCost("teleport_orgrimmar"); AddRuneOfTeleportationReagent()
	elseif (Type == "TeleportThunderBluff") then AddCost("teleport_thunder_bluff"); AddRuneOfTeleportationReagent()
	elseif (Type == "PortalDarnassus") then AddCost("portal_darnassus"); AddRuneOfPortalsReagent()
	elseif (Type == "PortalIronforge") then AddCost("portal_ironforge"); AddRuneOfPortalsReagent()
	elseif (Type == "PortalStormwind") then AddCost("portal_stormwind"); AddRuneOfPortalsReagent()
	elseif (Type == "PortalUndercity") then AddCost("portal_orgrimmar"); AddRuneOfPortalsReagent()
	elseif (Type == "PortalOrgrimmar") then AddCost("portal_orgrimmar"); AddRuneOfPortalsReagent()
	elseif (Type == "PortalThunderBluff") then AddCost("portal_thunder_bluff"); AddRuneOfPortalsReagent()
	-- ..... for mana gems, the mana cost ...
	elseif (Type == "ManaMenu")		then AddMenuTip(Type)
	elseif (Type == "ConjureManaAgate") then BuildConjureManaButtonTooltip("conjure_mana_agate")
	elseif (Type == "ConjureManaJade") then BuildConjureManaButtonTooltip("conjure_mana_jade")
	elseif (Type == "ConjureManaCitrine") then BuildConjureManaButtonTooltip("conjure_mana_citrine")
	elseif (Type == "ConjureManaRuby") then BuildConjureManaButtonTooltip("conjure_mana_ruby")
	end

	GameTooltip:Show()
end

-- Update the sphere according to life
function Arcanist:UpdateHealth()
	if Local.Dead then return end

	local health = UnitHealth("player")
	local healthMax = UnitHealthMax("player")

	local fm = _G[Arcanist.Mage_Buttons.main.f]

	-- If the perimeter of the stone shows health
	if ArcanistConfig.Circle == 4 then
		if health == healthMax then
			if not (Local.LastSphereSkin == ArcanistConfig.ArcanistColor.."\\Shard32") then
				Local.LastSphereSkin = ArcanistConfig.ArcanistColor.."\\Shard32"
				fm:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\"..Local.LastSphereSkin)
			end
		else
			local rate = math.floor(health / (healthMax / 16))
			if not (Local.LastSphereSkin == ArcanistConfig.ArcanistColor.."\\Shard"..rate) then
				Local.LastSphereSkin = ArcanistConfig.ArcanistColor.."\\Shard"..rate
				fm:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\"..Local.LastSphereSkin)
			end
		end
	end

	-- If the inside of the stone shows life
	if ArcanistConfig.CountType == 4 and ArcanistConfig.ShowCount then
		ArcanistMainCount:SetText(health)
	end
end

local function SetTexPerMana(f, spell, mana) -- frame and mage spell
	if f and spell and (spell.Mana and spell.Mana > 0) then
		if spell.Mana > mana then
			if not f:GetNormalTexture():IsDesaturated() then
				f:GetNormalTexture():SetDesaturated(1)
			end
		else
			if f:GetNormalTexture():IsDesaturated() then
				f:GetNormalTexture():SetDesaturated(nil)
			end
		end
	end
end
local function SetSat(f, val) -- frame and desaturate value
	if f then
		if val == 1 then
			if not f:GetNormalTexture():IsDesaturated() then
				f:GetNormalTexture():SetDesaturated(1)
			end
		else
			if f:GetNormalTexture():IsDesaturated() then
				f:GetNormalTexture():SetDesaturated(nil)
			end
		end
	end
end
-- Update buttons according to mana
function Arcanist:UpdateMana()
	if Local.Dead then return end

	local ptype = UnitPowerType("player")
	local mana = UnitPower("player",ptype)
	local manaMax = UnitPowerMax("player", ptype)

	local fm = _G[Arcanist.Mage_Buttons.main.f]

	-- If the perimeter of the stone shows the mana
	if ArcanistConfig.Circle == 3 then
		if mana == manaMax then
			if not (Local.LastSphereSkin == ArcanistConfig.ArcanistColor.."\\Shard32") then
				Local.LastSphereSkin = ArcanistConfig.ArcanistColor.."\\Shard32"
				fm:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\"..Local.LastSphereSkin)
			end
		else
			local rate = math.floor(mana / (manaMax / 16))
			if not (Local.LastSphereSkin == ArcanistConfig.ArcanistColor.."\\Shard"..rate) then
				Local.LastSphereSkin = ArcanistConfig.ArcanistColor.."\\Shard"..rate
				fm:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\"..Local.LastSphereSkin)
			end
		end
	end

	-- If the inside of the stone shows mana
	if ArcanistConfig.CountType == 3 and ArcanistConfig.ShowCount then
		ArcanistMainCount:SetText(mana)
	end

	-- Menus - mana only
	-----------------------------------------------
	if mana then
		-- buffs
		for i, v in ipairs(Arcanist.Mage_Lists.buffs) do
			local b = Arcanist.Mage_Buttons[v.f_ptr]
			local f = _G[b.f]
			local spell = Arcanist.GetSpell(v.high_of)

			SetTexPerMana(f, spell, mana)
		end

		-- ports
		for i, v in ipairs(Arcanist.Mage_Lists.ports) do
			local b = Arcanist.Mage_Buttons[v.f_ptr]
			local f = _G[b.f]
			local spell = Arcanist.GetSpell(v.high_of)

			if spell and f then
				SetTexPerMana(f, spell, mana)

				if spell.reagent then
					if Arcanist.Mage_Lists.reagents[spell.reagent].count <= 0 then
						SetSat(f, 1)
					end
				end
			end
		end

		-- mana gems
		for i, v in ipairs(Arcanist.Mage_Lists.mana_gems) do
			local b = Arcanist.Mage_Buttons[v.f_ptr]
			local f = _G[b.f]
			local spell = Arcanist.GetSpell(v.high_of)

			SetTexPerMana(f, spell, mana)
		end
	end

	-- Timers button
	-----------------------------------------------
	if Local.Hearthstone.Location[1] then
		local start, duration, enable = GetContainerItemCooldown(Local.Hearthstone.Location[1], Local.Hearthstone.Location[2])
		local ft = _G[Arcanist.Mage_Buttons.timer.f]
		if duration > 20 and start > 0 then
			if not Local.Hearthstone.Cooldown then
				ft:GetNormalTexture():SetDesaturated(1)
				Local.Hearthstone.Cooldown = true
			end
		else
			if Local.Hearthstone.Cooldown then
				ft:GetNormalTexture():SetDesaturated(nil)
				Local.Hearthstone.Cooldown = false
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- FUNCTIONS MANAGING ITEMS
------------------------------------------------------------------------------------------------------
-- Explore bags for important items
function Arcanist:BagExplore(arg)
	--[[
		This routine will not do well without bag names. The bag update event
		seems to happen a couple times during login / reload so if names are
		not known they should be before the player UI is fully ready.
	--]]
	if not BagNamesKnown() then
		return
	end

	for container = 0, NUM_BAG_SLOTS, 1 do
		local name, id = NU.GetBagName(container)
	end

	local bag_start = 0
	local bag_end = 0

	if arg then -- look at this bag only
		if Local.Hearthstone.OnHand == arg then Local.Hearthstone.OnHand = nil end
		if Local.Consumables.ManaAgate == arg then Local.Consumables.ManaAgate = false end
		if Local.Consumables.ManaJade == arg then Local.Consumables.ManaJade = false end
		if Local.Consumables.ManaCitrine == arg then Local.Consumables.ManaCitrine = false end
		if Local.Consumables.ManaRuby == arg then Local.Consumables.ManaRuby = false end

		bag_start = arg
		bag_end = arg
	else
		Local.Hearthstone.OnHand = nil
		Local.Consumables.ManaAgate = false
		Local.Consumables.ManaJade = false
		Local.Consumables.ManaCitrine = false
		Local.Consumables.ManaRuby = false

		bag_start = 0
		bag_end = NUM_BAG_SLOTS
	end

	-- search bag(s)
	for container = bag_start, bag_end, 1 do
		for slot=1, GetContainerNumSlots(container), 1 do
			local item_link = GetContainerItemLink(container, slot)
			local item_id, itemName = Arcanist.Utils.ParseItemLink(item_link) --GetContainerItemLink(container, slot))
			item_id = tonumber(item_id)

			-- If there is an item located in that bag slot
			if item_id then
				-- Check if its food
				if Arcanist.IsFood(item_id) then
					if Arcanist.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "null").."'"
						.." c'"..(tostring(container) or "null").."'"
						.." s'"..(tostring(slot) or "null").."'"
						.." n'"..(tostring(itemName) or "null").."'"
						)
					end
					ArcanistConfig.ItemLocation["food"] = itemName
				-- Check if its water
				elseif Arcanist.IsWater(item_id) then
					if Arcanist.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "null").."'"
						.." c'"..(tostring(container) or "null").."'"
						.." s'"..(tostring(slot) or "null").."'"
						.." n'"..(tostring(itemName) or "null").."'"
						)
					end
					ArcanistConfig.ItemLocation["water"] = itemName
				-- Check if its a mount
				elseif Arcanist.IsMount(item_id) then
					if Arcanist.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "null").."'"
						.." c'"..(tostring(container) or "null").."'"
						.." s'"..(tostring(slot) or "null").."'"
						.." n'"..(tostring(itemName) or "null").."'"
						)
					end
					ArcanistConfig.ItemLocation["mount"] = itemName
				elseif Arcanist.IsHearthstone(item_id) then
					if Arcanist.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "null").."'"
						.." c'"..(tostring(container) or "null").."'"
						.." s'"..(tostring(slot) or "null").."'"
						.." n'"..(tostring(itemName) or "null").."'"
						)
					end
					Local.Hearthstone.OnHand = container
					Local.Hearthstone.Location = {container,slot}
				elseif Arcanist.IsManaAgate(item_id) then
					if Arcanist.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "null").."'"
						.." c'"..(tostring(container) or "null").."'"
						.." s'"..(tostring(slot) or "null").."'"
						.." n'"..(tostring(itemName) or "null").."'"
						)
					end
					Local.Consumables.ManaAgate = true
					ArcanistConfig.ItemLocation["conjure_mana_agate"] = itemName
				elseif Arcanist.IsManaJade(item_id) then
					if Arcanist.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "null").."'"
						.." c'"..(tostring(container) or "null").."'"
						.." s'"..(tostring(slot) or "null").."'"
						.." n'"..(tostring(itemName) or "null").."'"
						)
					end
					Local.Consumables.ManaJade = true
					ArcanistConfig.ItemLocation["conjure_mana_jade"] = itemName
				elseif Arcanist.IsManaCitrine(item_id) then
					if Arcanist.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "null").."'"
						.." c'"..(tostring(container) or "null").."'"
						.." s'"..(tostring(slot) or "null").."'"
						.." n'"..(tostring(itemName) or "null").."'"
						)
					end
					Local.Consumables.ManaCitrine = true
					ArcanistConfig.ItemLocation["conjure_mana_citrine"] = itemName
				elseif Arcanist.IsManaRuby(item_id) then
					if Arcanist.Debug.bags then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(">>BagExplore"
						.." i'"..(tostring(item_id) or "null").."'"
						.." c'"..(tostring(container) or "null").."'"
						.." s'"..(tostring(slot) or "null").."'"
						.." n'"..(tostring(itemName) or "null").."'"
						)
					end
					Local.Consumables.ManaRuby = true
					ArcanistConfig.ItemLocation["conjure_mana_ruby"] = itemName
				end
			end
		end
	end

	-- Update reagent / food counters
	Local.Reagent.RuneOfTeleportation = GetItemCount(Arcanist.Mage_Lists.reagents.rune_of_teleportation.id)
	Arcanist.Mage_Lists.reagents.rune_of_teleportation.count = GetItemCount(Arcanist.Mage_Lists.reagents.rune_of_teleportation.id)

	Local.Reagent.RuneOfPortals = GetItemCount(Arcanist.Mage_Lists.reagents.rune_of_portals.id)
	Arcanist.Mage_Lists.reagents.rune_of_portals.count = GetItemCount(Arcanist.Mage_Lists.reagents.rune_of_portals.id)

	-- Go through increasing levels of food and only keep the highest found
	for i, v in pairs (Arcanist.Mage_Lists.conjured_food) do
		newCount = GetItemCount(v.id)
		if newCount > 0 then
			Local.Consumables.ConjuredFood.count = newCount
			Local.Consumables.ConjuredFood.name = v.name
		end
	end

	-- Go through increasing levels of water and only keep the highest found
	for i, v in pairs (Arcanist.Mage_Lists.conjured_water) do
		newCount = GetItemCount(v.id)
		if newCount > 0 then
			Local.Consumables.ConjuredWater.count = newCount
			Local.Consumables.ConjuredWater.name = v.name
		end
	end

	local fm = _G[Arcanist.Mage_Buttons.main.f]
	local fullFoodStacks = math.floor(Local.Consumables.ConjuredFood.count / 20)
	local fullWaterStacks = math.floor(Local.Consumables.ConjuredWater.count / 20)

	-- If the perimeter of the stone shows food stacks
	if ArcanistConfig.Circle == 2 then
		if fullFoodStacks >= 16 then
			if not (Local.LastSphereSkin == ArcanistConfig.ArcanistColor.."\\Shard32") then
				Local.LastSphereSkin = ArcanistConfig.ArcanistColor.."\\Shard32"
				fm:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\"..Local.LastSphereSkin)
			end
		else
			if not (Local.LastSphereSkin == ArcanistConfig.ArcanistColor.."\\Shard"..fullFoodStacks) then
				Local.LastSphereSkin = ArcanistConfig.ArcanistColor.."\\Shard"..fullFoodStacks
				fm:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\"..Local.LastSphereSkin)
			end
		end
	end

	-- If the perimeter of the stone shows water stacks
	if ArcanistConfig.Circle == 1 then
		if fullWaterStacks >= 16 then
			if not (Local.LastSphereSkin == ArcanistConfig.ArcanistColor.."\\Shard32") then
				Local.LastSphereSkin = ArcanistConfig.ArcanistColor.."\\Shard32"
				fm:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\"..Local.LastSphereSkin)
			end
		else
			if not (Local.LastSphereSkin == ArcanistConfig.ArcanistColor.."\\Shard"..fullWaterStacks) then
				Local.LastSphereSkin = ArcanistConfig.ArcanistColor.."\\Shard"..fullWaterStacks
				fm:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\"..Local.LastSphereSkin)
			end
		end
	end

	if ArcanistConfig.ShowCount then -- If the digital counter is on
		if ArcanistConfig.CountType == 2 then -- If the inside of the stone shows food stacks
			ArcanistMainCount:SetText(fullFoodStacks)
		elseif ArcanistConfig.CountType == 1 then -- If the inside of the stone shows water stacks
			ArcanistMainCount:SetText(fullWaterStacks)
		end
	else
		ArcanistMainCount:SetText("")
	end

	if ArcanistConjureFoodCount then
		if ArcanistConfig.ShowFoodCount then
			ArcanistConjureFoodCount:SetText(math.min(Local.Consumables.ConjuredFood.count, 99))
		else
			ArcanistConjureFoodCount:SetText("")
		end
	end

	if ArcanistConjureWaterCount then
		if ArcanistConfig.ShowWaterCount then
			ArcanistConjureWaterCount:SetText(math.min(Local.Consumables.ConjuredWater.count, 99))
		else
			ArcanistConjureWaterCount:SetText("")
		end
	end

	-- Update icons and we're done
	Arcanist.UpdateIcons()
end

------------------------------------------------------------------------------------------------------
-- VARIOUS FUNCTIONS
------------------------------------------------------------------------------------------------------

-- Display or Hide buttons depending on spell availability
function Arcanist:ButtonSetup()
	local NBRScale = (100 + (ArcanistConfig.ArcanistButtonScale - 85)) / 100
	local dist = 42

	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("ButtonSetup === Begin")
	end

	local fm = Arcanist.Mage_Buttons.main.f
	local indexScale = -42

	for i, v in ipairs (Arcanist.Mage_Lists.on_sphere) do
		local fr = Arcanist.Mage_Buttons[v.f_ptr].f
		local f = _G[fr]

		if Arcanist.Debug.options then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage(
				"ButtonSetup"
				.." v'"..tostring(v)
				.." fr'"..tostring(fr)
				.." f'"..tostring(f)
			)
		end

		if (Arcanist.IsSpellKnown(v.high_of) -- in spell book
			or v.menu                        -- or on menu of spells
			or v.item)						 -- or item to use
			and ArcanistConfig.Buttons[v.name]
			and not ArcanistConfig.HideAllButtons
		then
			if not f then
				f = Arcanist:CreateSphereButtons(Arcanist.Mage_Buttons[v.f_ptr])
				Arcanist:StoneAttribute()
			end
			f:ClearAllPoints()

			if ArcanistConfig.ArcanistLockServ then
				f:SetPoint(
					"CENTER", fm, "CENTER",
					((dist) * cos(ArcanistConfig.ArcanistAngle - indexScale)),
					((dist) * sin(ArcanistConfig.ArcanistAngle - indexScale))
				)
				indexScale = indexScale + 42
			else
				f:SetPoint(
					ArcanistConfig.FramePosition[fr][1],
					ArcanistConfig.FramePosition[fr][2],
					ArcanistConfig.FramePosition[fr][3],
					ArcanistConfig.FramePosition[fr][4],
					ArcanistConfig.FramePosition[fr][5]
				)
			end
			f:Show()
			f:SetScale(NBRScale)

			if v.name == "ConjureFood" or v.name == "ConjureWater" then
				-- Create the counter
				local FontString = _G["Arcanist"..v.name.."Count"]
				if not FontString then
					FontString = f:CreateFontString("Arcanist"..v.name.."Count", nil, "GameFontNormal")
				end

				-- Define its attributes
				FontString:SetPoint("CENTER")
				FontString:SetTextColor(1, 1, 0)
			end
		else
			if f then
				f:Hide()
			end
		end
	end

	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage(
			"ButtonSetup === Done"
		)
	end
end

------------------------------------------------------------------------------------------------------
-- MISCELLANEOUS FUNCTIONS
------------------------------------------------------------------------------------------------------
local function ClearAll(f)
	if f then f:ClearAllPoints() end
end

-- Function (XML) to restore the default attachment points of the buttons
function Arcanist:ClearAllPoints()
	ClearAll(_G[Arcanist.Mage_Buttons.mount.f])
	ClearAll(_G[Arcanist.Mage_Buttons.conjure_food.f])
	ClearAll(_G[Arcanist.Mage_Buttons.conjure_water.f])
	ClearAll(_G[Arcanist.Mage_Buttons.ports.f])
	ClearAll(_G[Arcanist.Mage_Buttons.buffs.f])
	ClearAll(_G[Arcanist.Mage_Buttons.mana.f])
end

local function SetDrag(f, val)
	if f then f:RegisterForDrag(val) end
end

-- Disable drag functionality
function Arcanist:NoDrag()
	local val = ""

	SetDrag(_G[Arcanist.Mage_Buttons.mount.f], val)
	SetDrag(_G[Arcanist.Mage_Buttons.conjure_food.f], val)
	SetDrag(_G[Arcanist.Mage_Buttons.conjure_water.f], val)
	SetDrag(_G[Arcanist.Mage_Buttons.ports.f], val)
	SetDrag(_G[Arcanist.Mage_Buttons.buffs.f], val)
	SetDrag(_G[Arcanist.Mage_Buttons.mana.f], val)

end

-- Enable drag functionality
function Arcanist:Drag()
	local val = "LeftButton"

	SetDrag(_G[Arcanist.Mage_Buttons.mount.f], val)
	SetDrag(_G[Arcanist.Mage_Buttons.conjure_food.f], val)
	SetDrag(_G[Arcanist.Mage_Buttons.conjure_water.f], val)
	SetDrag(_G[Arcanist.Mage_Buttons.ports.f], val)
	SetDrag(_G[Arcanist.Mage_Buttons.buffs.f], val)
	SetDrag(_G[Arcanist.Mage_Buttons.mana.f], val)
end

local function SetState(f, state)
	if f then f:SetAttribute("state", state) end
end
local function HideList(list, parent)
	for i, v in pairs(list) do
		menuVariable = _G[Arcanist.Mage_Buttons[v.f_ptr].f]
		if menuVariable then
			menuVariable:Hide()
			menuVariable:ClearAllPoints()
			menuVariable:SetPoint("CENTER", parent, "CENTER", 3000, 3000)
		end
	end
end
-- Rebuild the menus at mod startup or when the spellbook changes
function Arcanist:CreateMenu()
	Local.Menu.Buff = setmetatable({}, metatable)
	Local.Menu.Port = setmetatable({}, metatable)
	Local.Menu.Mana = setmetatable({}, metatable)
	local menuVariable = nil
	local BuffButtonPosition = "Button"
	local PortButtonPosition = "Button"
	local ManaButtonPosition = "Button"

	local f = Arcanist.Mage_Buttons.main.f
	HideList(Arcanist.Mage_Lists.ports, f) -- Hide all the port buttons
	HideList(Arcanist.Mage_Lists.buffs, f) -- Hide the general buff spell buttons
	HideList(Arcanist.Mage_Lists.mana_gems, f) -- Hide the mana gem buttons

	-- Buffs
	if ArcanistConfig.Buttons.Buff then
		-- Setup the buttons available on the buffs menu
		local prior_button = Arcanist.Mage_Buttons.buffs.f -- menu button on sphere
		-- Create on demand
		if not _G[prior_button] then
			_ = Arcanist:CreateSphereButtons(Arcanist.Mage_Buttons.buffs)
		end

		for index = 1, #Arcanist.Mage_Lists.buffs, 1 do
			local v = Arcanist.Mage_Lists.buffs[index]
			local f = Arcanist.Mage_Buttons[v.f_ptr].f
			if Arcanist.IsSpellKnown(v.high_of) then
				if Arcanist.Debug.buttons then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateMenu buffs"
						.." f'"..(v.f_ptr or "null")..'"'
						.." pr'"..(prior_button or "null")..'"'
					)
				end
				menuVariable = Arcanist:CreateMenuItem(v)
				menuVariable:ClearAllPoints()
				menuVariable:SetPoint(
					"CENTER", prior_button, "CENTER",
					ArcanistConfig.BuffMenuPos.x * 32,
					ArcanistConfig.BuffMenuPos.y * 32
				)
				prior_button = f -- anchor the next button
				Local.Menu.Buff:insert(menuVariable)
			end
		end

		-- Display the buffs menu button on the sphere
		if Local.Menu.Buff[1] then
			local f = _G[Arcanist.Mage_Buttons.buffs.f]
			local fs = Arcanist.Mage_Buttons.buffs.f
			Local.Menu.Buff[1]:ClearAllPoints()
			Local.Menu.Buff[1]:SetPoint(
				"CENTER", f, "CENTER",
				ArcanistConfig.BuffMenuPos.x * 32 + ArcanistConfig.BuffMenuOffset.x,
				ArcanistConfig.BuffMenuPos.y * 32 + ArcanistConfig.BuffMenuOffset.y
			)
			-- Secure the menu
			for i = 1, #Local.Menu.Buff, 1 do
				Local.Menu.Buff[i]:SetParent(f)
				-- Close the menu upon button Click
				f:WrapScript(Local.Menu.Buff[i], "OnClick", [[
					if self:GetParent():GetAttribute("state") == "open" then
						self:GetParent():SetAttribute("state", "closed")
					end
				]])
				f:WrapScript(Local.Menu.Buff[i], "OnEnter", [[
					self:GetParent():SetAttribute("mousehere", true)
				]])
				f:WrapScript(Local.Menu.Buff[i], "OnLeave", [[
					self:GetParent():SetAttribute("mousehere", false)
					local stateMenu = self:GetParent():GetAttribute("state")
					if not (stateMenu == "blocked" or stateMenu == "combat" or stateMenu == "rightClick") then
						self:GetParent():SetAttribute("state", "Refresh")
					end
				]])
				if ArcanistConfig.BlockedMenu or not ArcanistConfig.ClosingMenu then
					f:UnwrapScript(Local.Menu.Buff[i], "OnClick")
				end
			end
			Arcanist:MenuAttribute(fs)
			Arcanist:BuffSpellAttribute()
		end
	end

	-- Ports
	if ArcanistConfig.Buttons.Port then
		-- Setup the buttons available on the ports menu
		local prior_button = Arcanist.Mage_Buttons.ports.f -- menu button on sphere
		-- Create on demand
		if not _G[prior_button] then
			_ = Arcanist:CreateSphereButtons(Arcanist.Mage_Buttons.ports)
		end

		for index = 1, #Arcanist.Mage_Lists.ports, 1 do
			local v = Arcanist.Mage_Lists.ports[index]
			local f = Arcanist.Mage_Buttons[v.f_ptr].f
			if Arcanist.IsSpellKnown(v.high_of) then
				if Arcanist.Debug.buttons then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateMenu ports"
						.." f'"..(v.f_ptr or "null")..'"'
						.." pr'"..(prior_button or "null")..'"'
					)
				end
				menuVariable = Arcanist:CreateMenuItem(v)
				menuVariable:ClearAllPoints()
				menuVariable:SetPoint(
					"CENTER", prior_button, "CENTER",
					ArcanistConfig.PortMenuPos.x * 32,
					ArcanistConfig.PortMenuPos.y * 32
				)
				prior_button = f -- anchor the next button
				Local.Menu.Port:insert(menuVariable)
			end
		end

		-- Display the ports menu button
		if Local.Menu.Port[1] then
			local f = _G[Arcanist.Mage_Buttons.ports.f]
			local fs = Arcanist.Mage_Buttons.ports.f
			Local.Menu.Port[1]:ClearAllPoints()
			Local.Menu.Port[1]:SetPoint(
				"CENTER", f, "CENTER",
				ArcanistConfig.PortMenuPos.x * 32 + ArcanistConfig.PortMenuOffset.x,
				ArcanistConfig.PortMenuPos.y * 32 + ArcanistConfig.PortMenuOffset.y
			)
			-- Secure the menu
			for i = 1, #Local.Menu.Port, 1 do
				Local.Menu.Port[i]:SetParent(f)
				-- Close the menu when a child button is clicked
				f:WrapScript(Local.Menu.Port[i], "OnClick", [[
					if self:GetParent():GetAttribute("state") == "open" then
						self:GetParent():SetAttribute("state", "closed")
					end
				]])
				f:WrapScript(Local.Menu.Port[i], "OnEnter", [[
					self:GetParent():SetAttribute("mousehere", true)
				]])
				f:WrapScript(Local.Menu.Port[i], "OnLeave", [[
					self:GetParent():SetAttribute("mousehere", false)
					local stateMenu = self:GetParent():GetAttribute("state")
					if not (stateMenu == "blocked" or stateMenu == "combat" or stateMenu == "rightClick") then
						self:GetParent():SetAttribute("state", "Refresh")
					end
				]])
				if ArcanistConfig.BlockedMenu or not ArcanistConfig.ClosingMenu then
					f:UnwrapScript(Local.Menu.Port[i], "OnClick")
				end
			end
			Arcanist:MenuAttribute(fs)
			Arcanist:PortSpellAttribute()
		end
	end

	-- Mana
	if ArcanistConfig.Buttons.Mana then
		-- Setup the buttons available on the mana menu
		local prior_button = Arcanist.Mage_Buttons.mana.f -- menu button on sphere
		-- Create on demand
		if not _G[prior_button] then
			_ = Arcanist:CreateSphereButtons(Arcanist.Mage_Buttons.mana)
		end

		for index = 1, #Arcanist.Mage_Lists.mana_gems, 1 do
			local v = Arcanist.Mage_Lists.mana_gems[index]
			local f = Arcanist.Mage_Buttons[v.f_ptr].f
			if Arcanist.IsSpellKnown(v.high_of) then
				if Arcanist.Debug.buttons then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateMenu mana"
						.." f'"..(v.f_ptr or "null")..'"'
						.." pr'"..(prior_button or "null")..'"'
					)
				end
				menuVariable = Arcanist:CreateMenuItem(v)
				menuVariable:ClearAllPoints()
				menuVariable:SetPoint(
					"CENTER", prior_button, "CENTER",
					ArcanistConfig.ManaMenuPos.x * 32,
					ArcanistConfig.ManaMenuPos.y * 32
				)
				prior_button = f -- anchor the next button
				Local.Menu.Mana:insert(menuVariable)
			end
		end

		-- Display the mana menu button
		if Local.Menu.Mana[1] then
			local f = _G[Arcanist.Mage_Buttons.mana.f]
			local fs = Arcanist.Mage_Buttons.mana.f
			Local.Menu.Mana[1]:ClearAllPoints()
			Local.Menu.Mana[1]:SetPoint(
				"CENTER", f, "CENTER",
				ArcanistConfig.ManaMenuPos.x * 32 + ArcanistConfig.ManaMenuOffset.x,
				ArcanistConfig.ManaMenuPos.y * 32 + ArcanistConfig.ManaMenuOffset.y
			)
			-- Secure the menu
			for i = 1, #Local.Menu.Mana, 1 do
				Local.Menu.Mana[i]:SetParent(f)
				-- Close the menu when a child button is clicked
				f:WrapScript(Local.Menu.Mana[i], "OnClick", [[
					if self:GetParent():GetAttribute("state") == "open" then
						self:GetParent():SetAttribute("state", "closed")
					end
				]])
				f:WrapScript(Local.Menu.Mana[i], "OnEnter", [[
					self:GetParent():SetAttribute("mousehere", true)
				]])
				f:WrapScript(Local.Menu.Mana[i], "OnLeave", [[
					self:GetParent():SetAttribute("mousehere", false)
					local stateMenu = self:GetParent():GetAttribute("state")
					if not (stateMenu == "blocked" or stateMenu == "combat" or stateMenu == "rightClick") then
						self:GetParent():SetAttribute("state", "Refresh")
					end
				]])
				if ArcanistConfig.BlockedMenu or not ArcanistConfig.ClosingMenu then
					f:UnwrapScript(Local.Menu.Mana[i], "OnClick")
				end
			end
			Arcanist:MenuAttribute(fs)
			Arcanist:ManaSpellAttribute()
		end
	end

	-- Always keep menus Open (if enabled)
	if ArcanistConfig.BlockedMenu then
		local s = "blocked"
		SetState(_G[Arcanist.Mage_Buttons.buffs.f], s)
		SetState(_G[Arcanist.Mage_Buttons.ports.f], s)
		SetState(_G[Arcanist.Mage_Buttons.mana.f], s)
	end
end

-- Reset Arcanist to default position
function Arcanist:Recall()
	for i,v in pairs(Arcanist.Mage_Lists.recall) do
		local f = _G[Arcanist.Mage_Buttons[v.f_ptr].f]
		f:ClearAllPoints()
		f:SetPoint("CENTER", "UIParent", "CENTER", v.x, v.y)
		if v.show then
			f:Show()
		else
			f:Hide()
		end
		Arcanist:OnDragStop(f)
	end
end

function Arcanist:SetOfxy(menu)
	local fb = _G[Arcanist.Mage_Buttons.buffs.f]
	local fp = _G[Arcanist.Mage_Buttons.ports.f]
	local fm = _G[Arcanist.Mage_Buttons.mana.f]
	if menu == "Buff" and fb then
		if Local.Menu.Buff[1] then
			Local.Menu.Buff[1]:ClearAllPoints()
			Local.Menu.Buff[1]:SetPoint(
				"CENTER", fb, "CENTER",
				ArcanistConfig.BuffMenuPos.x * 32 + ArcanistConfig.BuffMenuOffset.x,

				ArcanistConfig.BuffMenuPos.y * 32 + ArcanistConfig.BuffMenuOffset.y
			)
		end
	elseif menu == "Port" and fp then
		if Local.Menu.Port[1] then
			Local.Menu.Port[1]:ClearAllPoints()
			Local.Menu.Port[1]:SetPoint(
				"CENTER", fp, "CENTER",
				ArcanistConfig.PortMenuPos.x * 32 + ArcanistConfig.PortMenuOffset.x,
				ArcanistConfig.PortMenuPos.y * 32 + ArcanistConfig.PortMenuOffset.y
			)
		end
	elseif menu == "Mana" and fm then
		if Local.Menu.Mana[1] then
			Local.Menu.Mana[1]:ClearAllPoints()
			Local.Menu.Mana[1]:SetPoint(
				"CENTER", fm, "CENTER",
				ArcanistConfig.ManaMenuPos.x * 32 + ArcanistConfig.ManaMenuOffset.x,
				ArcanistConfig.ManaMenuPos.y * 32 + ArcanistConfig.ManaMenuOffset.y
			)
		end
	end
end

-- Display the timers on the left or right
function Arcanist:TimerSymmetry(bool)
	local num
	if bool then
		ArcanistConfig.SpellTimerPos = -1
		ArcanistConfig.SpellTimerJust = "RIGHT"
		num = 1
		while _G["ArcanistTimerFrame"..num.."OutText"] do
			_G["ArcanistTimerFrame"..num.."OutText"]:ClearAllPoints()
			_G["ArcanistTimerFrame"..num.."OutText"]:SetPoint(
				"RIGHT",
				_G["ArcanistTimerFrame"..num],
				"LEFT",
				-5, 1
			)
			_G["ArcanistTimerFrame"..num.."OutText"]:SetJustifyH("RIGHT")
			num = num + 1
		end
	else
		ArcanistConfig.SpellTimerPos = 1
		ArcanistConfig.SpellTimerJust = "LEFT"
		num = 1
		while _G["ArcanistTimerFrame"..num.."OutText"] do
			_G["ArcanistTimerFrame"..num.."OutText"]:ClearAllPoints()
			_G["ArcanistTimerFrame"..num.."OutText"]:SetPoint(
				"LEFT",
				_G["ArcanistTimerFrame"..num],
				"RIGHT",
				5, 1
			)
			_G["ArcanistTimerFrame"..num.."OutText"]:SetJustifyH("LEFT")
			num = num + 1
		end
	end

	local ft = _G[Arcanist.Mage_Buttons.timer.f]
	if _G["ArcanistTimerFrame0"] then
		ArcanistTimerFrame0:ClearAllPoints()
		ArcanistTimerFrame0:SetPoint(
			ArcanistConfig.SpellTimerJust,
			ft,
			"CENTER",
			ArcanistConfig.SpellTimerPos * 20, 0
		)
	end
	if _G["ArcanistListSpells"] then
		ArcanistListSpells:ClearAllPoints()
		ArcanistListSpells:SetJustifyH(ArcanistConfig.SpellTimerJust)
		ArcanistListSpells:SetPoint(
			"TOP"..ArcanistConfig.SpellTimerJust,
			ft,
			"CENTER",
			ArcanistConfig.SpellTimerPos * 23, 10
		)
	end
end
