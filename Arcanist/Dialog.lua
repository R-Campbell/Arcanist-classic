--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

------------------------------------------------
-- ENGLISH  VERSION TEXTS --
------------------------------------------------
local L = LibStub("AceLocale-3.0"):GetLocale(ARCANIST_ID, true)

function Arcanist:Localization_Dialog()
end


--[[
At initialization, this table will be used to get localized names of items.
The call to GetItemInfo *may* return nil if the local install has not seen these yet *in this session*.
When this occurs, the event GET_ITEM_INFO_RECEIVED is used retrieve the data once
WoW has added it to local cache. https://wow.gamepedia.com/API_GetItemInfo
The lookup is by spell id so SetItem needs to get passed the id from initialization.

This file and Spells.lua are the two places WoW ids are specified. Then short names, localized names, or passed ids are used.
--]]
Arcanist.GetItemsCount = 0 -- used to register / unregister event GET_ITEM_INFO_RECEIVED
local items_to_get = 0
local items_list = {} -- Items to get localized names (strings) for

--[[
At initialization, this table will be filled with localized names.
- index will be the short name from items_list
- value will be the localized name
--]]
local items_by_name = {}

-- helper routines: getters and setters for the localized items list so the list remains hidden
function Arcanist.SetItem(item_id, succ) -- called from event handler
	-- Only process an id we care about!
	local short_name = items_list[item_id]
	local l_name = ""
	if name then
		l_name = name -- have localized name
	else
		l_name = "" -- need to wait for server...
	end
	if short_name then -- safety, do not inflict errors on the player
		items_by_name[short_name] = l_name -- safe to assign
	end

	-- Should always be an id we care about! But have seen the server spam odd ids, some not in Classic
	if succ and items_list[item_id] then
		items_by_name[items_list[item_id]] = Arcanist.Utils.GetItemName(item_id) -- just get the localized name
		items_to_get = items_to_get - 1

		if Arcanist.Debug.init_path then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("SetItem"
			.." i'"..tostring(item_id or "null").."'"
			.." s'"..tostring(succ or "null").."'"
			.." n'"..tostring(items_by_name[items_list[item_id]] or "null").."'"
			.." c'"..tostring(items_to_get or "null").."'"
			)
		end
		-- the info is now in local cache...
	end
end

function Arcanist.GetItemList() -- Debug
	return items_list
end

function Arcanist.GetItemNames() -- Debug
	return items_by_name
end

function Arcanist.GetItem(item_name) -- needs to be string value in items_list
	local res = ""
	if items_by_name[item_name] then
		res = items_by_name[item_name]
	else
		res = "" -- nil would create Lua errors
	end
	return res
end

function Arcanist.InitMageItems()
	items_to_get = 0
	for i,v in pairs(items_list) do
		local name = Arcanist.Utils.GetItemName(i) -- just get the localized name
		if name then
			items_by_name[v] = name -- got the info
		else
			-- rely on GET_ITEM_INFO_RECEIVED to fill in
			items_to_get = items_to_get + 1
		end
		if Arcanist.Debug.init_path then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("InitMageItems"
			.." i'"..tostring(i or "null").."'"
			.." n'"..tostring(name or "null").."'"
			)
		end
	end

	if Arcanist.Debug.init_path then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("InitMageItems"
		.." ic'"..tostring(items_to_get or "null").."'"
		)
	end
end

function Arcanist.MageItemsDone()
	local res = true
	for i,v in pairs(items_list) do
		if items_by_name[v] == ""
		or items_by_name[v] == nil then -- need info
			res = false
			break -- no need to check more
		else
			-- have data
		end
	end
	return res
end

Arcanist.TooltipData = {
	["Main"] = {
		Label = L["ARCANIST_LABEL"],
		Boolean = {
			[true] = YES, --L["YES"], global strings
			[false] = NO, --L["NO"],
		},
		["RuneOfTeleportation"] = L["RUNE_OF_TELEPORTATION_LABEL"],
		["RuneOfPortals"] = L["RUNE_OF_PORTALS_LABEL"],
		["ConjuredFood"] = L["CONJURE_FOOD_LABEL"],
		["ConjuredWater"] = L["CONJURE_WATER_LABEL"],
		["ManaAgate"] = L["MANA_AGATE_LABEL"],
		["ManaJade"] = L["MANA_JADE_LABEL"],
		["ManaCitrine"] = L["MANA_CITRINE_LABEL"],
		["ManaRuby"] = L["MANA_RUBY_LABEL"],
	},
	["ConjureFood"] = {
		Label = L["CONJURE_FOOD"],
		Text = {L["RIGHT_CLICK_CREATE"],L["LEFT_CLICK_USE"]}
	},
	["ConjureWater"] = {
		Label = L["CONJURE_WATER"],
		Text = {L["RIGHT_CLICK_CREATE"],L["LEFT_CLICK_USE"]}
	},
	["PortMenu"] = {
		Label = L["PORT_MENU_LABEL"],
		Text = L["PORT_MENU_TEXT_1"],
		Text2 = L["PORT_MENU_TEXT_2"]
	},
	["TeleportDarnassus"] = {
		Label = L["TELEPORT_DARNASSUS"]
	},
	["TeleportIronforge"] = {
		Label = L["TELEPORT_IRONFORGE"]
	},
	["TeleportStormwind"] = {
		Label = L["TELEPORT_STORMWIND"]
	},
	["TeleportUndercity"] = {
		Label = L["TELEPORT_UNDERCITY"]
	},
	["TeleportOrgrimmar"] = {
		Label = L["TELEPORT_ORGRIMMAR"]
	},
	["TeleportThunderBluff"] = {
		Label = L["TELEPORT_THUNDER_BLUFF"]
	},
	["PortalDarnassus"] = {
		Label = L["PORTAL_DARNASSUS"]
	},
	["PortalIronforge"] = {
		Label = L["PORTAL_IRONFORGE"]
	},
	["PortalStormwind"] = {
		Label = L["PORTAL_STORMWIND"]
	},
	["PortalUndercity"] = {
		Label = L["PORTAL_UNDERCITY"]
	},
	["PortalOrgrimmar"] = {
		Label = L["PORTAL_ORGRIMMAR"]
	},
	["PortalThunderBluff"] = {
		Label = L["PORTAL_THUNDER_BLUFF"]
	},
	["SpellTimer"] = {
		Label = L["SPELLTIMER_LABEL"],
		Text = L["SPELLTIMER_TEXT"],
		Right = L["SPELLTIMER_RIGHT"]
	},
	["Mount"] = {
		Label = L["MOUNT_LABEL"],
		Text = L["MOUNT_TEXT"],
	},
	["ManaMenu"] = {
		Label = L["MANA_MENU_LABEL"],
		Text = L["BUFF_MENU_TEXT_1"],
		Text2 = L["BUFF_MENU_TEXT_2"],
	},
	["ConjureManaAgate"] = {
		Label = L["MANA_AGATE"],
		Text = {L["RIGHT_CLICK_CREATE"],L["LEFT_CLICK_USE"]}
	},
	["ConjureManaJade"] = {
		Label = L["MANA_JADE"],
		Text = {L["RIGHT_CLICK_CREATE"],L["LEFT_CLICK_USE"]}
	},
	["ConjureManaCitrine"] = {
		Label = L["MANA_CITRINE"],
		Text = {L["RIGHT_CLICK_CREATE"],L["LEFT_CLICK_USE"]}
	},
	["ConjureManaRuby"] = {
		Label = L["MANA_RUBY"],
		Text = {L["RIGHT_CLICK_CREATE"],L["LEFT_CLICK_USE"]}
	},
	["BuffMenu"] = {
		Label = L["BUFF_MENU_LABEL"],
		Text = L["BUFF_MENU_TEXT_1"],
		Text2 = L["BUFF_MENU_TEXT_2"],
	},
	["ArcaneIntellect"] = {
		Label = L["ARCANE_INTELLECT"]
	},
	["IceArmor"] = {
		Label = L["ICE_ARMOR"]
	},
	["MageArmor"] = {
		Label = L["MAGE_ARMOR"]
	},
	["ManaShield"] = {
		Label = L["MANA_SHIELD"]
	},
	["AmplifyMagic"] = {
		Label = L["AMPLIFY_MAGIC"]
	},
	["DampenMagic"] = {
		Label = L["DAMPEN_MAGIC"]
	},
	["FrostWard"] = {
		Label = L["FROST_WARD"]
	},
	["FireWard"] = {
		Label = L["FIRE_WARD"]
	},
	["Polymorph"] = {
		Label = L["POLYMORPH"]
	},
}

Arcanist.Sound = {}

Arcanist.ProcText = {}


Arcanist.ChatMessage = {
	["Bag"] = {
		["FullPrefix"] = L["BAG_FULL_PREFIX"],
		["FullSuffix"] = L["BAG_FULL_SUFFIX"],
		["FullDestroySuffix"] = L["BAG_FULL_DESTROY_PREFIX"],
	},
	["Interface"] = {
		["Welcome"] = L["INTERFACE_WELCOME"],
		["TooltipOn"] = L["INTERFACE_TOOLTIP_ON"],
		["TooltipOff"] = L["INTERFACE_TOOLTIP_OFF"],
		["MessageOn"] = L["INTERFACE_MESSAGE_ON"],
		["MessageOff"] = L["INTERFACE_MESSAGE_OFF"],
		["DefaultConfig"] = L["INTERFACE_DEFAULT_CONFIG"],
		["UserConfig"] = L["INTERFACE_USER_CONFIG"],
	},
	["Help"] = {
		L["HELP_1"],
		L["HELP_2"],
	},
	["Information"] = {}
}

-- Management XML - Configuration Menu
Arcanist.Config.Panel = {
	L["CONFIG_MESSAGE"],
	L["CONFIG_SPHERE"],
	L["CONFIG_BUTTON"],
	L["CONFIG_MENU"],
	L["CONFIG_TIMER"],
	L["CONFIG_MISC"],
}

Arcanist.Config.Messages = {
	["MSG_POSITION"] = L["MSG_POSITION"],
	["MSG_SHOW_TIPS"] = L["MSG_SHOW_TIPS"],
	["MSG_SHOW_SYS"] = L["MSG_SHOW_SYS"],
	["MSG_RANDOM"] = L["MSG_RANDOM"],
	["MSG_USE_SHORT"] = L["MSG_USE_SHORT"],
	["MSG_SOUNDS"] = L["MSG_SOUNDS"],
}

Arcanist.Config.Sphere = {
	["SPHERE_SIZE"] = L["SPHERE_SIZE"],
	["SPHERE_SKIN"] = L["SPHERE_SKIN"],
	["SPHERE_EVENT"] = L["SPHERE_EVENT"],
	["SPHERE_SPELL"] = L["SPHERE_SPELL"],
	["SPHERE_COUNTER"] = L["SPHERE_COUNTER"],
	["SPHERE_STONE"] = L["SPHERE_STONE"],
}

Arcanist.Config.Sphere.Color = {
	L["PINK"],
	L["BLUE"],
	L["ORANGE"],
	L["TURQUOISE"],
	L["PURPLE"],
}
Arcanist.Config.Sphere.Count = {
	L["CONJURED_WATER_STACKS"],
	L["CONJURED_FOOD_STACKS"],
	L["MANA"],
	L["HEALTH"],
}

Arcanist.Config.Buttons = {
	["BUTTONS_ROTATION"] = L["BUTTONS_ROTATION"],
	["BUTTONS_STICK"] = L["BUTTONS_STICK"],
	["BUTTONS_MOUNT"] = L["BUTTONS_MOUNT"],
	["BUTTONS_SELECTION"] = L["BUTTONS_SELECTION"],
	["BUTTONS_LEFT"] = L["BUTTONS_LEFT"],
	["BUTTONS_RIGHT"] = L["BUTTONS_RIGHT"],
}
Arcanist.Config.Buttons.Name = {
	["SHOW_BUFF"] = L["SHOW_BUFF"],
	["SHOW_MOUNT"] = L["SHOW_MOUNT"],
	["SHOW_CONJUREFOOD"] = L["SHOW_CONJUREFOOD"],
	["SHOW_CONJUREWATER"] = L["SHOW_CONJUREWATER"],
	["SHOW_PORT"] = L["SHOW_PORT"],
	["SHOW_MANA"] = L["SHOW_MANA"],
}

Arcanist.Config.Menus = {
	["MENU_GENERAL"] = L["MENU_GENERAL"],
	["MENU_SPELLS"] = L["MENU_SPELLS"],
	["MENU_PORT"] = L["MENU_PORTS"],
	["MENU_MANA"] = L["MENU_MANA"],
	["MENU_ALWAYS"] = L["MENU_ALWAYS"],
	["MENU_AUTO_COMBAT"] = L["MENU_AUTO_COMBAT"],
	["MENU_CLOSE_CLICK"] = L["MENU_CLOSE_CLICK"],
	["MENU_ORIENTATION"] = L["MENU_ORIENTATION"],
}
Arcanist.Config.Menus.Orientation = {
	L["LEFT"],
	L["UPWARDS"],
	L["RIGHT"],
	L["DOWNWARDS"],
}

Arcanist.Config.Timers = {
	["TIMER_TYPE"] = L["TIMER_TYPE"],
	["TIMER_SPELL"] = L["TIMER_SPELL"],
	["TIMER_LEFT"] = L["TIMER_LEFT"],
	["TIMER_UP"] = L["TIMER_UP"],
}
Arcanist.Config.Timers.Type = {
	L["NO_TIMER"],
	L["GRAPHICAL"],
	L["TEXTUAL"],
}

Arcanist.Config.Misc = {
	["MISC_LOCK"] = L["MISC_LOCK"],
	["MISC_HIDDEN"] = L["MISC_HIDDEN"],
	["MISC_HIDDEN_SIZE"] = L["MISC_HIDDEN_SIZE"],
}

-- Translations of objects used by Arcanist
Arcanist.Translation.Item = {
	["Hearthstone"] = L["HEARTHSTONE"], -- https://classicdb.ch/?item=6948
}

-- Various Translations
Arcanist.Translation.Misc = {
	["Cooldown"] = L["COOLDOWN"],
	["Rank"] = L["RANK"],
	["Create"] = L["CREATE"],
}
