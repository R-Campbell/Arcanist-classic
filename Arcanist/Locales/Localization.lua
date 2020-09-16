--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

local L = LibStub("AceLocale-3.0"):NewLocale(ARCANIST_ID,"enUS",true)

L["ARCANIST"] = "Arcanist";
L["ARCANIST_ONLY"] = "Arcanist";
L["ARCANIST_DEBUG"] = "<Arcanist>";
L["ARCANIST_PRINT"] = "Arcanist";

-- Configuration
L["USE"] = "Use"
L["TRADE"] = "Trade"
L["ARCANIST_LABEL"] = "|c00FFFFFF".."Arcanist".."|r"
L["YES"] = "Yes"
L["NO"] = "No"
L["ON"] = "On"
L["OFF"] = "Off"
--
L["RUNE_OF_TELEPORTATION_LABEL"] = "Runes of Teleportation: "
L["RUNE_OF_PORTALS_LABEL"] = "Runes of Portals: "
L["CONJURE_FOOD"] = "|c00FFFFFF".."Conjure Food".."|r"
L["CONJURE_FOOD_LABEL"] = "Conjured Food: "
L["CONJURE_WATER"] = "|c00FFFFFF".."Conjure Water".."|r"
L["CONJURE_WATER_LABEL"] = "Conjured Water: "
L["MANA_AGATE_LABEL"] = "Mana Agate: "
L["MANA_JADE_LABEL"] = "Mana Jade: "
L["MANA_CITRINE_LABEL"] = "Mana Citrine: "
L["MANA_RUBY_LABEL"] = "Mana Ruby: "
L["HEARTHSTONE"] = "Hearthstone"
--
L["RIGHT_CLICK_CREATE"] = "Right click to create"
L["LEFT_CLICK_USE"] = "Left click to use"
--
L["TELEPORT_DARNASSUS"] = "Teleport: Darnassus"
L["TELEPORT_IRONFORGE"] = "Teleport: Ironforge"
L["TELEPORT_STORMWIND"] = "Teleport: Stormwind"
L["TELEPORT_UNDERCITY"] = "Teleport: Undercity"
L["TELEPORT_ORGRIMMAR"] = "Teleport: Orgrimmar"
L["TELEPORT_THUNDER_BLUFF"] = "Teleport: Thunder Bluff"
L["PORTAL_DARNASSUS"] = "Portal: Darnassus"
L["PORTAL_IRONFORGE"] = "Portal: Ironforge"
L["PORTAL_STORMWIND"] = "Portal: Stormwind"
L["PORTAL_UNDERCITY"] = "Portal: Undercity"
L["PORTAL_ORGRIMMAR"] = "Portal: Orgrimmar"
L["PORTAL_THUNDER_BLUFF"] = "Portal: Thunder Bluff"
--
L["SPELLTIMER_LABEL"] = "|c00FFFFFF".."Spell Durations".."|r"
L["SPELLTIMER_TEXT"] = "Active Spells on the target"
L["SPELLTIMER_RIGHT"] = "Right click for Hearthstone to "
--
L["MOUNT_LABEL"] = "|c00FFFFFF".."Mount".."|r"
L["MOUNT_TEXT"] = "Click to summon mount"
--
L["BUFF_MENU_LABEL"] = "|c00FFFFFF".."Buff Menu".."|r"
L["BUFF_MENU_TEXT_1"] = "Right click to keep the menu open"
L["BUFF_MENU_TEXT_2"] = "Automatic Mode : Closing when leave combat"
--
L["PORT_MENU_LABEL"] = "|c00FFFFFF".."Port Menu".."|r"
L["PORT_MENU_TEXT_1"] = "Right click to keep the menu open"
L["PORT_MENU_TEXT_2"] = "Automatic Mode : Closing when leave combat"
--
L["MANA_MENU_LABEL"] = "|c00FFFFFF".."Mana Menu".."|r"
L["MANA_MENU_TEXT_1"] = "Right click to keep the menu open"
L["MANA_MENU_TEXT_2"] = "Automatic Mode : Closing when leave combat"
L["MANA_AGATE"] = "Mana Agate"
L["MANA_JADE"] = "Mana Jade"
L["MANA_CITRINE"] = "Mana Citrine"
L["MANA_RUBY"] = "Mana Ruby"
--
L["BAG_FULL_PREFIX"] = "Your "
L["BAG_FULL_SUFFIX"] = " is full!"
L["BAG_FULL_DESTROY_PREFIX"] = " is full; New shards will be destroyed!"
L["INTERFACE_WELCOME"] = "<white>/arcanist to show the settings menu!"
L["INTERFACE_TOOLTIP_ON"] = "Tooltips turned on"
L["INTERFACE_TOOLTIP_OFF"] = "Tooltips turned off"
L["INTERFACE_MESSAGE_ON"] = "Chat messaging turned on"
L["INTERFACE_MESSAGE_OFF"] = "Chat messaging turned off"
L["INTERFACE_DEFAULT_CONFIG"] = "<lightYellow>Default configuration loaded."
L["INTERFACE_USER_CONFIG"] = "<lightYellow>Configuration loaded."
L["HELP_1"] = "/arcanist <lightOrange>recall<white> -- <lightBlue>Center Arcanist and all buttons in the middle of the screen"
L["HELP_2"] = "/arcanist <lightOrange>reset<white> -- <lightBlue>Reset Arcanist entirely"
--
L["CONFIG_MESSAGE"] = "Message Settings"
L["CONFIG_SPHERE"] = "Sphere Settings"
L["CONFIG_BUTTON"] = "Button Settings"
L["CONFIG_MENU"] = "Menu Settings"
L["CONFIG_TIMER"] = "Timer Settings"
L["CONFIG_MISC"] = "Miscellaneous Settings"
--
L["MSG_POSITION"] = "<- Arcanist system messages will appear here ->"
L["MSG_SHOW_TIPS"] = "Show tooltips"
L["MSG_SHOW_SYS"] = "Show Arcanist messages in the system frame"
L["MSG_RANDOM"] = "Activate random speeches"
L["MSG_USE_SHORT"] = "Use short messages"
L["MSG_RANDOM_DEMON"] = "Activate random speeches for demons too"
L["MSG_RANDOM_STEED"] = "Activate random speeches for steeds too"
L["MSG_RANDOM_SOULS"] = "Activate random speeches for Ritual of Souls"
L["MSG_SOUNDS"] = "Activate sounds"
L["MSG_WARN_FEAR"] = "Warn when the target cannot be feared"
L["MSG_WARN_BANISH"] = "Warn when the target is banishable or enslavable"
L["MSG_WARN_TRANCE"] = "Warn me when I enter a Trance State"
--
L["SPHERE_SIZE"] = "Size of the Arcanist button"
L["SPHERE_SKIN"] = "Skin of the sphere"
L["SPHERE_EVENT"] = "Thing shown by the sphere border"
L["SPHERE_SPELL"] = "Spell cast by the sphere"
L["SPHERE_SHOW_HIDE"] = "Show/Hide buttons"
L["SPHERE_COUNTER"] = "Show the digital counter"
L["SPHERE_STONE"] = "Thing shown by digital counter"
-- Color
L["PINK"] = "Pink"
L["BLUE"] = "Blue"
L["ORANGE"] = "Orange"
L["TURQUOISE"] = "Turquoise"
L["PURPLE"] = "Purple"
-- Count
L["CONJURED_WATER_STACKS"] = "Conjured Food Stacks"
L["CONJURED_FOOD_STACKS"] = "Conjured Water Stacks"
L["MANA"] = "Mana"
L["HEALTH"] = "Health"
-- Buttons
L["BUTTONS_ROTATION"] = "Buttons rotation"
L["BUTTONS_STICK"] = "Stick buttons around the sphere"
L["BUTTONS_MOUNT"] = "Use my own mounts"
L["BUTTONS_SELECTION"] = "Selection of buttons to be shown"
L["BUTTONS_LEFT"] = "Left click"
L["BUTTONS_RIGHT"] = "Right click"
--
L["SHOW_BUFF"] = "Show Buff menu button"
L["SHOW_MOUNT"] = "Show Mount button"
L["SHOW_CONJUREFOOD"] = "Show Conjure Food button"
L["SHOW_CONJUREWATER"] = "Show Conjure Water button"
L["SHOW_PORT"] = "Show Port menu button"
L["SHOW_MANA"] = "Show Mana menu button"
L["SHOW_FOOD_COUNT"] = "Show the amount of Conjured Food on the button"
L["SHOW_WATER_COUNT"] = "Show the amount of Conjured Water on the button"
-- Buffs
L["ARCANE_INTELLECT"] = "Arcane Intellect"
L["ICE_ARMOR"] = "Ice Armor"
L["MAGE_ARMOR"] = "Mage Armor"
L["MANA_SHIELD"] = "Mana Shield"
L["AMPLIFY_MAGIC"] = "Amplify Magic"
L["DAMPEN_MAGIC"] = "Dampen Magic"
L["FROST_WARD"] = "Frost Ward"
L["FIRE_WARD"] = "Fire Ward"
L["POLYMORPH"] = "Polymorph"
--
L["MENU_GENERAL"] = "General Options"
L["MENU_SPELLS"] = "Buff Menu"
L["MENU_PORTS"] = "Ports Menu"
L["MENU_MANA"] = "Mana Menu"
L["MENU_ALWAYS"] = "Always show menus"
L["MENU_AUTO_COMBAT"] = "Automatically display menus while in combat"
L["MENU_CLOSE_CLICK"] = "Close a menu whenever you click on one of its items"
L["MENU_ORIENTATION"] = "Menu orientation"
--
L["LEFT"] = "Left"
L["UPWARDS"] = "Upwards"
L["RIGHT"] = "Right"
L["DOWNWARDS"] = "Downwards"
--
L["TIMER_TYPE"] = "Timer type"
L["TIMER_SPELL"] = "Show the Spell Timer Button"
L["TIMER_LEFT"] = "Show timers on the left side of the button"
L["TIMER_UP"] = "Timers grow upwards"
--
L["NO_TIMER"] = "No Timer"
L["GRAPHICAL"] = "Graphical"
L["TEXTUAL"] = "Textual"
--
L["MISC_LOCK"] = "Lock Arcanist"
L["MISC_HIDDEN"] = "Let me see hidden buttons to drag them"
L["MISC_HIDDEN_SIZE"] = "Size of hidden buttons"
--
L["COOLDOWN"] = "Cooldown"
L["RANK"] = "Rank"
L["CREATE"] = "Create"
--
L["ABOUT_VERSION"] = "Version";
L["ABOUT_AUTHOR"] = "Author";
L["ABOUT_CREDITS"] = "Credits";
L["ABOUT_CATEGORY"] = "Category";
L["ABOUT_EMAIL"] = "E-mail";
L["ABOUT_WEB"] = "Website";
L["ABOUT_LICENSE"] = "License";
