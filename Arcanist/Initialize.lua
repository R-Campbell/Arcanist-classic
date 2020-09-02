--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as the being the array containing all the existing frames.
local _G = getfenv(0)

Arcanist = {}
ARCANIST_ID = "Arcanist"

Arcanist.Data = {
	Version = GetAddOnMetadata("Arcanist", "Version"),
	AppName = "Arcanist",
	LastConfig = 20200819,
	Enabled = false,
}

Arcanist.Data.Label = Arcanist.Data.AppName.." "..Arcanist.Data.Version

Arcanist.Speech = {}
Arcanist.Unit = {}
Arcanist.Translation = {}

Arcanist.Config = {}

ArcanistConfig = {}

-- Any of these could generate a lot of output
Arcanist.Debug = {
	init_path 		= false, -- notable points as Arcanist starts
	events 			= false, -- various events tracked, chatty but informative; overlap with spells_cast
	spells_init 	= false, -- setting spell data and highest and helper tables
	spells_cast 	= false, -- spells as they are cast and some resulting actions and auras; overlap with events
	timers 			= false, -- track as they are created and removed
	buttons 		= false, -- buttons and menus as they are created and updated
	bags			= false, -- what is found in bags and shard management - could be very chatty on large, full bags
	tool_tips		= false, -- spell info that goes into tool tips
	speech			= false, -- steps to produce the 'speech' when summoning
	options         = false, -- option creation
	frames			= true,  -- frames positioning
	}

local ntooltip = CreateFrame("Frame", "ArcanistTooltip", UIParent, "GameTooltipTemplate");
local nbutton  = CreateFrame("Button", "ArcanistButton", UIParent, "SecureActionButtonTemplate")

-- Edit the scripts associated with the button
ArcanistButton:SetScript("OnEvent", function(self,event, ...)
	 Arcanist:OnEvent(self, event,...)
	end)

ArcanistButton:RegisterEvent("PLAYER_LOGIN")
ArcanistButton:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Events utilised by Arcanist
local Events = {
	"BAG_UPDATE",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_DEAD",
	"PLAYER_ALIVE",
	"PLAYER_UNGHOST",
	"UNIT_SPELLCAST_FAILED",
	"UNIT_SPELLCAST_INTERRUPTED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_SPELLCAST_SENT",
	"UNIT_POWER_UPDATE",
	"UNIT_HEALTH",
	"LEARNED_SPELL_IN_TAB",
	"PLAYER_TARGET_CHANGED",
	"TRADE_REQUEST",
	"TRADE_REQUEST_CANCEL",
	"TRADE_ACCEPT_UPDATE",
	"TRADE_SHOW",
	"TRADE_CLOSED",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"SKILL_LINES_CHANGED",
	"PLAYER_LEAVING_WORLD",
	"SPELLS_CHANGED",
	-- "BAG_UPDATE_DELAYED"
}

------------------------------------------------------------------------------------------------------
-- INITIALIZATION FUNCTION
------------------------------------------------------------------------------------------------------

function Arcanist:Initialize_Speech()
	self.Localization_Dialog()

	-- Speech could not be done using Ace...
	self.Speech.TP = {}
	local lang = ""
	lang = GetLocale()
	Arcanist.Data.Lang = lang
	if lang == "frFR" then
		self:Localization_Speech_Fr()
	elseif lang == "deDE" then
		self:Localization_Speech_De()
	elseif lang == "zhTW" then
		self:Localization_Speech_Tw()
	elseif lang == "zhCN" then
		self:Localization_Speech_Cn()
	elseif lang == "esES" then
		self:Localization_Speech_Es()
	elseif lang == "ruRU" then
		self:Localization_Speech_Ru()
	else
		Arcanist:Localization_Speech_En()
	end
end

function Arcanist:Initialize(Config)
	local f = Arcanist.Mage_Buttons.main.f
	if Arcanist.Debug.init_path then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Arcanist - Initialize - Start"
		.." f:'"..(tostring(f) or "null").."'"
		)
	end

	f = _G[f]

	-- Now ready to activate Arcanist
	f:SetScript("OnUpdate",    function(self, arg1) Arcanist:OnUpdate(self, arg1) end)
	f:SetScript("OnEnter", 	   function(self) Arcanist:BuildButtonTooltip(self) end)
	f:SetScript("OnLeave", 	   function() GameTooltip:Hide() end)
	f:SetScript("OnMouseUp",   function(self) Arcanist:OnDragStop(self) end)
	f:SetScript("OnDragStart", function(self) Arcanist:OnDragStart(self) end)
	f:SetScript("OnDragStop",  function(self) Arcanist:OnDragStop(self) end)

	-- Register the events used
	for i in ipairs(Events) do
		f:RegisterEvent(Events[i])
	end

	Arcanist:Initialize_Speech()
	-- On change (or we create the configuration for the player and we display it on the console)
	if not ArcanistConfig.Version or type(ArcanistConfig.Version) == "string" or Arcanist.Data.LastConfig > ArcanistConfig.Version then
		ArcanistConfig = {}
		ArcanistConfig = Config
		ArcanistConfig.Version = Arcanist.Data.LastConfig
		self:Msg(self.ChatMessage.Interface.DefaultConfig, "USER")
	else
		self:Msg(self.ChatMessage.Interface.UserConfig, "USER")
	end

	if ArcanistConfig.Timers then -- just in case... was added in 7.2
	else
		ArcanistConfig.Timers = Config.Timers
	end
	Arcanist.UpdateSpellTimers(ArcanistConfig.Timers)

	self:CreateMageUI()
	-----------------------------------------------------------
	-- Performing start-up functions
	-----------------------------------------------------------
	-- Displaying a Message on the Console
	self:Msg(self.ChatMessage.Interface.Welcome, "USER")
	-- Creation of the list of available spells
	self:SpellSetup("Initialize")

    -- Recording the console command
	SlashCmdList["ArcanistCommand"] = Arcanist.SlashHandler
	SLASH_ArcanistCommand1 = "/arcanist"

	local ftb = _G[Arcanist.Mage_Buttons.timer.f]

	-- We define the display of Graphic Timers to the left or right of the button
	if _G["ArcanistTimerFrame0"] then
		ArcanistTimerFrame0:ClearAllPoints()
		ArcanistTimerFrame0:SetPoint(
			ArcanistConfig.SpellTimerJust,
			ftb,
			"CENTER",
			ArcanistConfig.SpellTimerPos * 20,
			0
		)
	end
	-- We define the display of Text Timers to the left or right of the button
	if _G["ArcanistListSpells"] then
		ArcanistListSpells:ClearAllPoints()
		ArcanistListSpells:SetJustifyH(ArcanistConfig.SpellTimerJust)
		ArcanistListSpells:SetPoint(
			"TOP"..ArcanistConfig.SpellTimerJust,
			ftb,
			"CENTER",
			ArcanistConfig.SpellTimerPos * 23,
			5
		)
	end

	-- We show or hide the button
	if not ArcanistConfig.ShowSpellTimers then ftb:Hide() end
	-- Is the Shard locked on the interface
	if ArcanistConfig.NoDragAll then
		self:NoDrag()
		f:RegisterForDrag("")
		ftb:RegisterForDrag("")
	else
		self:Drag()
		f:RegisterForDrag("LeftButton")
		ftb:RegisterForDrag("LeftButton")
	end

	-- If the sphere must indicate life or mana, we go there
	Arcanist:UpdateHealth()
	Arcanist:UpdateMana()

	if Arcanist.Debug.init_path then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Arcanist - Initialize - End")
	end
end

------------------------------------------------------------------------------------------------------
-- Function managing the console /arcanist command
------------------------------------------------------------------------------------------------------

function Arcanist.SlashHandler(arg1)
	if arg1:lower():find("recall") then
		Arcanist:Recall()
	elseif arg1:lower():find("reset") and not InCombatLockdown() then
		ArcanistConfig = {}
		ReloadUI()
	elseif arg1:lower():find("glasofruix") then
		ArcanistConfig.Smooth = not ArcanistConfig.Smooth
		Arcanist:Msg("SpellTimer smoothing  : <lightBlue>Toggled")
	else
		Arcanist:OpenConfigPanel()
	end
end
