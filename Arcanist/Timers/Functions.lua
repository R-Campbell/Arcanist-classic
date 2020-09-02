--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]
------------------------------------------------------------------------------------------------------

-- We define _G as being the array containing all the existing frames.
local _G = getfenv(0)

------------------------------------------------------------------------------------------------------
-- FUNCTIONS TO ADD TIMERS
------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
-- Helper routines
------------------------------------------------------------------------------------------------------

-- sort timers according to their group
local function Tri(SpellTimer, clef)
	return SpellTimer:sort(
		function (SubTab1, SubTab2)
			return SubTab1[clef] < SubTab2[clef]
		end)
end

-- defined timer groups
local function Parsing(SpellGroup, SpellTimer)
	for index = 1, #SpellTimer, 1 do
		if SpellTimer[index].Group == 0 then
			local GroupeOK = false
			for i = 1, #SpellGroup, 1 do
				if ((SpellTimer[index].Type == i) and (i <= 3)) or
				   (SpellTimer[index].TargetGUID == SpellGroup[i].TargetGUID)
					then
					GroupeOK = true
					SpellTimer[index].Group = i
					SpellGroup[i].Visible = SpellGroup[i].Visible + 1
					break
				end
			end
			-- Create a new group if it doesnt exist
			if not GroupeOK then
				SpellGroup:insert(
					{
						Name = SpellTimer[index].Target,
						SubName = SpellTimer[index].TargetLevel,
						TargetGUID = SpellTimer[index].TargetGUID,
						Visible = 1
					}
				)
				SpellTimer[index].Group = #SpellGroup
			end
		end
	end

	Tri(SpellTimer, "Group")
	return SpellGroup, SpellTimer
end

local function OutputTimer(reason, usage, index, Timer, note, override)
	if Arcanist.Debug.timers or override then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("OTimer::"
		.." ip'"..(tostring(index) or "null").."'"
		.." rp'"..(reason or "Timer").."'"
		.." up'"..(tostring(usage) or "null").."'"
		.." g'"..(tostring(Timer.SpellTimer[index].Group) or "null").."'"
		.." n'"..(tostring(Timer.SpellTimer[index].Name) or "null").."'"
		.." sec'"..(tostring(Timer.SpellTimer[index].Time) or "null").."'"
		.." T'"..(tostring(Timer.SpellTimer[index].Type) or "null").."'"
		.." u'"..(tostring(Timer.SpellTimer[index].Usage) or "null").."'"
		.." r'"..(tostring(Timer.SpellTimer[index].Remove) or "null").."'"
		.." tl'"..(tostring(Timer.SpellTimer[index].TargetLevel) or "null").."'"
		.." t'"..(tostring(Timer.SpellTimer[index].Target) or "null").."'"
		.." '"..(tostring(Timer.SpellTimer[index].TargetGUID) or "null").."'"
		.." '"..(tostring(note) or "null").."'"
		)
	end
end

------------------------------------------------------------------------------------------------------
-- INSERT FUNCTIONS
------------------------------------------------------------------------------------------------------
--[[
Insert the requested timer(s) for the given spell.
Note: A spell could have ZERO or ONE or TWO timers!
- Zero: Should not get here
- One: such as curses or cool down such as health stones
- Two: Such Curse of Doom or Death Coil have both a use time and a cool down

Note: The way this code is written assumes any buff that WoW tracks on UI
and crosses login / reload does NOT have both a duration AND a cool down in Spells...
--]]
--[[
- Type (of timer)
	-- Type 0 =  no timer
	-- Type 1 = Standing main timer
	-- Type 2 = main timer
	-- Type 3 = cooldown timer
	-- Type 4 = curse timer
	-- Type 5 = corruption timer
	-- Type 6 = combat timer
--]]
local function InsertThisTimer(spell, cast_guid, Target, Timer, start_time, duration, note)
	-- todo: fix these timer inserts
	if Arcanist.Debug.timers then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("InsertThisTimer::"
		.." s'"..(tostring(spell) or "null").."'"
		.." sN'"..(tostring(spell.Name) or "null").."'"
		.." sL'"..(tostring(spell.Length) or "null").."'"
		.." sB'"..(tostring(spell.Buff) or "null").."'"
		.." sC'"..(tostring(spell.Cooldown) or "null").."'"
		.." sU'"..(tostring(spell.Usage) or "null").."'"
		.." sG'"..(tostring(spell.Group) or "null").."'"
		.." cg'"..(tostring(cast_guid) or "null").."'"
		.." tar'"..(tostring(Target) or "null").."'"
		.." tim'"..(tostring(Timer) or "null").."'"
		.." st'"..(tostring(start_time) or "null").."'"
		.." d'"..(tostring(duration) or "null").."'"
		.." n'"..(tostring(note) or "null").."'"
		)
	end
	local target = Target
	local timer_type = 0
	if target == nil or target == {} then
		target = {name = "", lvl = "", guid = "", }
	end

	local length = 0
	local length_max = 0
	if spell.Length and spell.Length > 0 then
		if start_time then
			length = floor(duration - GetTime() + start_time)
			length_max = floor(start_time + duration)
		else
			length = spell.Length
			length_max = floor(GetTime() + spell.Length)
		end

		if spell.Buff then
			timer_type = 2 -- can cancel or lose
		else
			timer_type = 6 -- remove once out of combat
		end

		if Arcanist.Debug.timers then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("RemovingTimer::"
			.." s'"..(tostring(spell) or "null").."'"
			.." sN'"..(tostring(spell.Name) or "null").."'"
			.." tar'"..(tostring(Target.guid) or "null").."'"
			.." tim'"..(tostring(Timer) or "null").."'"
			.." n'"..(tostring(note) or "null").."'"
			)
		end

		-- insert an entry into the table
		Timer.SpellTimer:insert(
			{
				Name = spell.Name,
				Time = length,
				TimeMax = length_max,
				MaxBar = spell.Length,
				Type = timer_type,
				Usage = spell.Usage,
				Target = target.name,
				TargetGUID = target.guid,
				TargetLevel = target.lvl,
				CastGUID = cast_guid,
				Group = spell.Group or 0,
				Gtimer = nil
			}
		)
		OutputTimer("Insert duration", spell.Usage, #Timer.SpellTimer, Timer, note)
	end

	-- check for a cool down to show
	if spell.Cooldown and (spell.Cooldown > 0) then
		if start_time then
			length = floor(duration - GetTime() + start_time)
			length_max = floor(start_time + duration)
		else
			length = spell.Cooldown
			length_max = floor(GetTime() + spell.Cooldown)
		end

		spellName = spell.Name.." Cooldown"

		if Arcanist.Debug.timers then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("Removing::"
			.." sN'"..(tostring(spellName) or "null").."'"
			.." tim'"..(tostring(Timer) or "null").."'"
			)
		end

		-- insert an entry into the table
		Timer.SpellTimer:insert(
			{
				Name = spellName,
				Time = length,
				TimeMax = length_max,
				MaxBar = spell.Cooldown,
				Type = 3, -- spell cool down, cannot cancel
				Usage = spell.Usage,
				Target = "", -- target.name,
				TargetGUID = "", -- target.guid,
				TargetLevel = "", -- target.lvl,
				CastGUID = nil,
				Group = 0, --spell.Group or 0,
				Gtimer = nil
			}
		)
		OutputTimer("Insert cooldown", spell.Usage, #Timer.SpellTimer, Timer, note)
	end

	-- attach a graphical timer if enabled
	-- associate it to the frame (if present)
	if ArcanistConfig.TimerType == 1 then
		local TimerFrame = nil
		for index, valeur in ipairs(Timer.TimerTable) do
			if not valeur then
				TimerFrame = index
				Timer.TimerTable[index] = true
				break
			end
		end
		-- if there is no frame, add one
		if not TimerFrame then
			Timer.TimerTable:insert(true)
			TimerFrame = #Timer.TimerTable
		end
		-- update the timer display
		Timer.SpellTimer[#Timer.SpellTimer].Gtimer = TimerFrame
		local FontString, StatusBar = Arcanist:AddFrame("ArcanistTimerFrame"..TimerFrame)
		FontString:SetText(Timer.SpellTimer[#Timer.SpellTimer].Name)
		StatusBar:SetMinMaxValues(
			Timer.SpellTimer[#Timer.SpellTimer].TimeMax - Timer.SpellTimer[#Timer.SpellTimer].Time,
			Timer.SpellTimer[#Timer.SpellTimer].TimeMax
		)
	end

	if ArcanistConfig.TimerType > 0 then
		-- sort the timers by type
		Tri(Timer.SpellTimer, "Type")

		-- Create timers by mob group
		Timer.SpellGroup, Timer.SpellTimer = Parsing(Timer.SpellGroup, Timer.SpellTimer)

		-- update the display
		ArcanistUpdateTimer(Timer.SpellTimer, Timer.SpellGroup)
	end

	return Timer
end

function Arcanist:TimerInsert(Cast, Target, Timer, note, start_time, duration, maxi)
	local spell = Arcanist.GetSpell(Cast.usage)

	if spell.Timer then
		Timer = Arcanist:RemoveTimerByNameAndGuid(spell.Name, Target.guid, Timer, note)

		Timer = InsertThisTimer(spell, Cast.Guid, Target, Timer, start_time, duration, note)
	end

	return Timer
end

------------------------------------------------------------------------------------------------------
-- FUNCTIONS TO REMOVE TIMERS
------------------------------------------------------------------------------------------------------

-- delete a timer by its index
function Arcanist:RemoveTimerByIndex(index, Timer)

	if ArcanistConfig.TimerType > 0 then
		-- remove the graphical timer
		if ArcanistConfig.TimerType == 1 and Timer.SpellTimer[index] then
			if Timer.SpellTimer[index].Gtimer and Timer.TimerTable[Timer.SpellTimer[index].Gtimer] then
				Timer.TimerTable[Timer.SpellTimer[index].Gtimer] = false
				_G["ArcanistTimerFrame"..Timer.SpellTimer[index].Gtimer]:Hide()
			end
		end

		-- remove the mob group timer
		if Timer.SpellTimer[index] and Timer.SpellGroup[Timer.SpellTimer[index].Group] then
			if Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible  then
				Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible = Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible - 1
				-- Hide the frame groups if empty
				if Timer.SpellGroup[Timer.SpellTimer[index].Group].Visible <= 0 then
					local frameGroup = _G["ArcanistSpellTimer"..Timer.SpellTimer[index].Group]
					if frameGroup then frameGroup:Hide() end
				end
			end
		end
	end

	-- remove the timer from the list
	Timer.SpellTimer:remove(index)

	-- update the display
	ArcanistUpdateTimer(Timer.SpellTimer, Timer.SpellGroup)

	return Timer
end

-- remove a timer by name
function Arcanist:RemoveTimerByName(name, Timer)
	for index = 1, #Timer.SpellTimer, 1 do
		if Timer.SpellTimer[index].Name == name then
			OutputTimer("RemoveTimerByName", "", index, Timer, note)
			Timer = self:RemoveTimerByIndex(index, Timer)
			break
		end
	end
	return Timer
end

function Arcanist:RemoveTimerByGuid(guid, Timer, note)
	for index = 1, #Timer.SpellTimer, 1 do
		if Timer.SpellTimer[index].TargetGUID == guid then
			OutputTimer("RemoveTimerByGuid", "", index, Timer, note)
			Timer = self:RemoveTimerByIndex(index, Timer)
			break
		end
	end
	return Timer
end

function Arcanist:RemoveTimerByCast(guid, Timer, note)
	for index = 1, #Timer.SpellTimer, 1 do
--[[
_G["DEFAULT_CHAT_FRAME"]:AddMessage("RemoveTimer::"
.." g'"..(tostring(guid)).."'"
.." tg'"..(tostring(Timer.SpellTimer[index].CastGUID)).."'"
)
--]]
		if Timer.SpellTimer[index].CastGUID == guid then
			OutputTimer("RemoveTimerByCast", "", index, Timer, note)
			Timer = self:RemoveTimerByIndex(index, Timer)
			break
		end
	end
	return Timer
end

function Arcanist:RemoveTimerByNameAndGuid(name, guid, Timer, note)
	for index = 1, #Timer.SpellTimer, 1 do
		if Timer.SpellTimer[index].Name == name
		and Timer.SpellTimer[index].TargetGUID == guid then
			OutputTimer("RemoveTimerByNameAndGuid", "", index, Timer, note)
			Timer = self:RemoveTimerByIndex(index, Timer)
			break
		end
	end
	return Timer
end

-- remove combat timer
function Arcanist:RemoveCombatTimer(Timer, note)
	local top = #Timer.SpellTimer
	for index = 1, #Timer.SpellTimer, 1 do
		if Timer.SpellTimer[index] then
			-- remove if its a cooldown timer
			if Timer.SpellTimer[index].Type == 3 then
				Timer.SpellTimer[index].Target = ""
				Timer.SpellTimer[index].TargetGUID = ""
				Timer.SpellTimer[index].TargetLevel = ""
			end
			-- other combat timers
			if Timer.SpellTimer[index].Type == 4
				or Timer.SpellTimer[index].Type == 5
				or Timer.SpellTimer[index].Type == 6
				then
					OutputTimer("RemoveCombatTimer", "", index, Timer, note)
					Timer = self:RemoveTimerByIndex(index, Timer)
			end
		end
	end

	if ArcanistConfig.TimerType > 0 then
		local index = 4
		while #Timer.SpellGroup >= 4 do
			if _G["ArcanistSpellTimer"..index] then _G["ArcanistSpellTimer"..index]:Hide() end
			Timer.SpellGroup:remove()

			if Arcanist.Debug.timers then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("RemoveCombatTimer"
				.." Group '"..tostring(index or "null").."'"
				)
			end
			index = index + 1
		end
	end

	return Timer
end

-- Debug
function Arcanist:DumpTimers(Timer)
	_G["DEFAULT_CHAT_FRAME"]:AddMessage("::: Dump Timers start "..tostring(#Timer.SpellTimer))
	for index = 1, #Timer.SpellTimer, 1 do
		OutputTimer("Dump", "", index, Timer, "dump", true)
	end
	_G["DEFAULT_CHAT_FRAME"]:AddMessage("::: Dump Timers end")
end

--[[
if Arcanist.Debug.events then
	_G["DEFAULT_CHAT_FRAME"]:AddMessage("RemoveTimerByGuid "..note
	.." i'"..tostring(index or "null").."'"
	.." g'"..tostring(guid or "null").."'"
	.." tg'"..tostring(Timer.SpellTimer[index].TargetGUID or "null").."'"
	)
end
--]]