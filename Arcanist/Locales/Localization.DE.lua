--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

local L = LibStub("AceLocale-3.0"):NewLocale(ARCANIST_ID,"deDE")
if not L then return end

L["ARCANIST"] = "Arcanist";
L["ARCANIST_ONLY"] = "Arcanist";
L["ARCANIST_DEBUG"] = "<Arcanist>";
L["ARCANIST_PRINT"] = "Arcanist";

-- Configuration
L["HEALTHSTONE_COOLDOWN"] = "Gesundheitsstein Cooldown"
L["USE"] = "Use"
L["TRADE"] = "Trade"
L["ARCANIST_LABEL"] = "|c00FFFFFF".."Arcanist".."|r"
L["YES"] = "Ja"
L["NO"] = "Nein"
L["ON"] = "An"
L["OFF"] = "Aus"
--
L["SOUL_SHARD"] = "Seelensplitter"
L["SOUL_SHARD_LABEL"] = "Seelensplitter: "
L["INFERNAL_STONE"] = "H\195\182llenstein"
L["INFERNAL_STONE_LABEL"] = "H\195\182llensteine: "
L["DEMONIAC_STONE"] = "D\195\164monenstatuette"
L["DEMONIAC_STONE_LABEL"] = "D\195\164monen-Statuetten: "
L["SOUL_STONE"] = "Seelenstein"
L["SOUL_STONE_LABEL"] = "\nSeelenstein: "
L["HEALTH_STONE"] = "Gesundheitsstein"
L["HEALTH_STONE_LABEL"] = "Gesundheitsstein: "
L["SPELL_STONE"] = "Zauberstein"
L["SPELL_STONE_LABEL"] = "Zauberstein: "
L["FIRE_STONE"] = "Feuerstein"
L["FIRE_STONE_LABEL"] = "Feuerstein: "
L["CURRENT_DEMON"] = "D\195\164mon: "
L["ENSLAVED_DEMON"] = "D\195\164mon: Versklavter"
L["NO_CURRENT_DEMON"] = "D\195\164mon: Keiner"
L["HEARTHSTONE"] = "Ruhestein"
--
L["SOULSTONE_TEXT_1"] = "Rechte Maustaste zum herstellen"
L["SOULSTONE_TEXT_2"] = "Linke Maustaste zum benutzten"
L["SOULSTONE_TEXT_3"] = "Benutzt\nRechte Maustaste zum wiederherstellen"
L["SOULSTONE_TEXT_4"] = "Warten"
L["SOULSTONE_RITUAL"] = "|c00FFFFFF".."Shift+Click to cast the Ritual of Summoning".."|r"
L["HEALTHSTONE_TEXT_1_1"] = "Rechte Maustaste zum herstellen"
L["HEALTHSTONE_TEXT_1_2"] = "Linke Maustaste zum benutzten"
L["HEALTHSTONE_TEXT_2"] = "Mittlerer Maustaste oder Strg+rechte Maustaste zum handeln"
L["HEALTHSTONE_RITUAL"] = "|c00FFFFFF".."Shift+Klick um das Ritual der Seelen zu zaubern".."|r"
L["SPELLSTONE_TEXT_1"] = "Rechte Maustaste zum herstellen"
L["SPELLSTONE_TEXT_2"] = "Im Inventar\nLinke Maustaste zum benutzten"
L["SPELLSTONE_TEXT_3"] = "Benutzt"
L["SPELLSTONE_TEXT_4"] = "Benutzt\n Maustaste zum herstellen"
L["FIRESTONE_TEXT_1"] = "Rechte Maustaste zum herstellen"
L["FIRESTONE_TEXT_2"] = "Im Inventar\nLinke Maustaste zum benutzten"
L["FIRESTONE_TEXT_3"] = "Benutzt"
L["FIRESTONE_TEXT_4"] = "Benutzt\n Maustaste zum herstellen"
L["SPELLTIMER_LABEL"] = "|c00FFFFFF".."Spruchdauer".."|r"
L["SPELLTIMER_TEXT"] = "Aktive Spr\195\188che auf dem Ziel"
L["SPELLTIMER_RIGHT"] = "Rechtsklick f\195\188r Ruhestein nach "
L["SHADOW_TRANCE_LABEL"] = "|c00FFFFFF".."Schatten Trance".."|r"
L["BACKLASH_LABEL"] = "|c00FFFFFF".."Heimzahlen".."|r"
L["BANISH_TEXT"] = "Rechtsklick f\195\188r Rang 1"
-- Pets
L["IMP_LABEL"] = "|c00FFFFFF".."Wichtel".."|r"
L["IMP"] = "Wichtel"
L["VOIDWALKER_LABEL"] = "|c00FFFFFF".."Leerwandler".."|r"
L["VOIDWALKER"] = "Leerwandler"
L["SUCCUBUS_LABEL"] = "|c00FFFFFF".."Sukkubus".."|r"
L["SUCCUBUS"] = "Sukkubus"
L["FELHUNTER_LABEL"] = "|c00FFFFFF".."Teufelsj\195\164ger".."|r"
L["FELHUNTER"] = "Teufelsj\195\164ger"
L["FELGUARD_LABEL"] = "|c00FFFFFF".."Teufelswache".."|r"
L["FELGUARD"] = "Teufelswache"
L["INFERNAL_LABEL"] = "|c00FFFFFF".."H\195\182llenbestie".."|r"
L["INFERNAL"] = "H\195\182llenbestie"
L["DOOMGUARD_LABEL"] = "|c00FFFFFF".."Verdammniswache".."|r"
L["DOOMGUARD"] = "Verdammniswache"
--
L["MOUNT_LABEL"] = "|c00FFFFFF".."Mounts".."|r"
L["MOUNT_TEXT"] = "Left click to summon Dreadsteed\nRight click to summon Felsteed"
L["BUFF_MENU_LABEL"] = "|c00FFFFFF".."Spruch Men\195\188|r".."|r"
L["BUFF_MENU_TEXT_1"] = "Rechtsklick um das Men\195\188 zu \195\182ffnen"
L["BUFF_MENU_TEXT_2"] = "Automatischer Modus: Wird beim verlassen des Kampfes geschlossen"
L["PET_MENU_LABEL"] = "|c00FFFFFF".."D\195\164monen Men\195\188".."|r"
L["PET_MENU_TEXT_1"] = "Rechtsklick um das Men\195\188 zu \195\182ffnen"
L["PET_MENU_TEXT_2"] = "Automatischer Modus: Wird beim verlassen des Kampfes geschlossen"
L["CURSE_MENU_LABEL"] = "|c00FFFFFF".."Fluch Men\195\188".."|r"
L["CURSE_MENU_TEXT_1"] = "Rechtsklick um das Men\195\188 zu \195\182ffnen"
L["CURSE_MENU_TEXT_2"] = "Automatischer Modus: Wird beim verlassen des Kampfes geschlossen"
L["DOMINATION_COOLDOWN"] = "Mit der rechten Taste klicken f\195\188r eine schnelle Beschw\195\182rung"
--
L["SOUND_FEAR"] = "Interface\\AddOns\\Arcanist\\sounds\\Fear-En.mp3"
L["SOUND_SOUL_STONE_END"] = "Interface\\AddOns\\Arcanist\\sounds\\SoulstoneEnd-En.mp3"
L["SOUND_ENSLAVE_END"] = "Interface\\AddOns\\Arcanist\\sounds\\EnslaveDemonEnd-En.mp3"
L["SOUND_SHADOW_TRANCE"] = "Interface\\AddOns\\Arcanist\\sounds\\ShadowTrance-En.mp3"
L["SOUND_BACKLASH"] = "Interface\\AddOns\\Arcanist\\sounds\\Backlash-Fr.mp3"
--
L["PROC_SHADOW_TRANCE"] = "<white>S<lightPurple1>c<lightPurple2>h<purple>a<darkPurple1>tt<darkPurple2>en<darkPurple1>tr<purple>a<lightPurple2>n<lightPurple1>c<white>e"
L["PROC_BACKLASH"] = "<white>H<lightPurple1>e<lightPurple2>i<purple>m<darkPurple1>z<darkPurple2>a<darkPurple1>h<purple>l<lightPurple2>e<lightPurple1>n"

L["BAG_FULL_PREFIX"] = "Dein "
L["BAG_FULL_SUFFIX"] = " ist voll !"
L["BAG_FULL_DESTROY_PREFIX"] = " ist voll; folgende Seelensplitter werden zerst\195\182rt !"
L["INTERFACE_WELCOME"] = "<white>/arcanist f\195\188r das Einstellungsmen\195\188"
L["INTERFACE_TOOLTIP_ON"] = "Tooltips an"
L["INTERFACE_TOOLTIP_OFF"] = "Tooltips aus"
L["INTERFACE_MESSAGE_ON"] = "Chat Nachrichten an"
L["INTERFACE_MESSAGE_OFF"] = "Chat Nachrichten aus"
L["INTERFACE_DEFAULT_CONFIG"] = "<lightYellow>Standard-Einstellungen geladen."
L["INTERFACE_USER_CONFIG"] = "<lightYellow>Einstellungen geladen."
L["HELP_1"] = "/arcanist <lightOrange>recall<white> -- <lightBlue>Zentriere Arcanist und alle Buttons in der Mitte des Bildschirms"
L["HELP_2"] = "/arcanist <lightOrange>reset<white> -- <lightBlue>Setzt Arcanist komplett auf Grundeinstellungen zur\195\188ck"
L["INFO_FEAR_PROTECT"] = "Dein Ziel hat Fear-Protection!!!"
L["INFO_ENSLAVE_BREAK"] = "Dein D\195\164mon hat seine Ketten gebrochen..."
L["INFO_SOUL_STONE_END"] = "<lightYellow>Dein Seelenstein ist ausgelaufen."
--
L["CONFIG_MESSAGE"] = "Nachrichten Einstellungen"
L["CONFIG_SPHERE"] = "Sph\195\164re Einstellungen"
L["CONFIG_BUTTON"] = "Buttons Einstellungen"
L["CONFIG_MENU"] = "Men\195\188s Einstellungen"
L["CONFIG_TIMER"] = "Timer Einstellungen"
L["CONFIG_MISC"] = "Sonstiges"
--
L["MSG_POSITION"] = "<- Hier werden Nachrichten von Arcanist erscheinen ->"
L["MSG_SHOW_TIPS"] = "Zeige Tooltips"
L["MSG_SHOW_SYS"] = "Zeige Nachrichten von Arcanist im System Frame"
L["MSG_RANDOM"] = "Zuf\195\164llige Spr\195\188che"
L["MSG_USE_SHORT"] = "Benutzte kurze Nachrichten"
L["MSG_RANDOM_DEMON"] = "Zuf\195\164llige Spr\195\188che f\195\188r D\195\164monen auch"
L["MSG_RANDOM_STEED"] = "Zuf\195\164llige Spr\195\188che f\195\188r Mount auch"
L["MSG_RANDOM_SOULS"] = "Zuf\195\164llige Spr\195\188che f\195\188r das Ritual der Seelen aktivieren"
L["MSG_SOUNDS"] = "Aktiviere Sounds"
L["MSG_WARN_FEAR"] = "Warnung, wenn Ziel immun gegen\195\188ber Fear ist"
L["MSG_WARN_BANISH"] = "Warnung, wenn ein Ziel verbannt\\versklavt werden kann"
L["MSG_WARN_TRANCE"] = "Warnung, wenn Trance eintritt"
--
L["SPHERE_SIZE"] = "Gr\195\182\195\159e der Sph\195\164re"
L["SPHERE_SKIN"] = "Aussehen der Arcanist Sph\195\164re"
L["SPHERE_EVENT"] = "Anzeige in der grafischen Sph\195\164re"
L["SPHERE_SPELL"] = "Zauber der durch Klick auf die\nSph\195\164re gewirkt wird"
L["SPHERE_COUNTER"] = "Zeige die gew\195\164hlte Anzeige in der Sph\195\164re"
L["SPHERE_STONE"] = "Anzeige w\195\164hlen:"
--	Color
L["PINK"] = "Pink"
L["BLUE"] = "Blau"
L["ORANGE"] = "Orange"
L["TURQUOISE"] = "T\195\188rkis"
L["PURPLE"] = "Lila"
-- Count
L["SOUL_SHARDS"] = "Seelensplitter"
L["DEMON_SUMMON_STONES"] = "D\195\164monenen-Beschw\195\182rungs-Stein"
L["REZ_TIMER"] = "Wiederbelebungs-Timer"
L["MANA"] = "Mana"
L["HEALTH"] = "Gesundheit"
-- Buttons
L["BUTTONS_ROTATION"] = "Rotation der Buttons"
L["BUTTONS_STICK"] = "Fixiere die Buttons um die Sph\195\164re"
L["BUTTONS_MOUNT"] = "Use my own mounts"
L["BUTTONS_SELECTION"] = "Selection of buttons to be shown"
L["BUTTONS_LEFT"] = "Left click"
L["BUTTONS_RIGHT"] = "Right click"
--
L["SHOW_FIRE_STONE"] = "Zeige den Feuerstein Button"
L["SHOW_SPELL_STONE"] = "Zeige den Zauberstein Button"
L["SHOW_HEALTH_STONE"] = "Zeige den Gesundheitsstein Button"
L["SHOW_SOUL_STONE"] = "Zeige den Seelenstein Button"
L["SHOW_SPELL"] = "Zeige den Spruch Men\195\188 Button"
L["SHOW_STEED"] = "Zeige den Mount Button"
L["SHOW_DEMON"] = "Zeige den D\195\164monen Men\195\188 Button"
L["SHOW_CURSE"] = "Zeige den Fluch Men\195\188 Button"
--
L["MENU_GENERAL"] = "Allgemeine Einstellungen"
L["MENU_SPELLS"] = "Spruch Men\195\188"
L["MENU_DEMONS"] = "D\195\164monen Men\195\188"
L["MENU_CURSES"] = "Fluch Men\195\188"
L["MENU_ALWAYS"] = "Zeige die Men\195\188s permanent"
L["MENU_AUTO_COMBAT"] = "Men\195\188s im Kampf automatisch \195\182ffnen"
L["MENU_CLOSE_CLICK"] = "Schließe das Men\195\188, sobald ein Button geklickt wurde"
L["MENU_ORIENTATION"] = "Ausrichtung des Men\195\188s"
L["MENU_VERT"] = "Ver\195\164ndert die Vertikale Symmetrie der Buttons"
L["MENU_BANISH"] = "Gr\195\182\195\159e des Verbannen Button"
--
L["HORIZONTAL"] = "Horizontal"
L["UPWARDS"] = "Aufw\195\164rts"
L["DOWNWARDS"] = "Abw\195\164rts"
--
L["TIMER_TYPE"] = "Timer Typ"
L["TIMER_SPELL"] = "Zeige den Timer Button"
L["TIMER_LEFT"] = "Zeige die Timer auf der linken Seite des Knopfes"
L["TIMER_UP"] = "Neue Timer oberhalb der bestehenden Timer anzeigen"
--
L["NO_TIMER"] = "Kein"
L["GRAPHICAL"] = "Graphische"
L["TEXTUAL"] = "Texttimer"
--
L["MISC_SHARDS_BAG"] = "Lege die Seelensplitter in die ausgew\195\164hlte Tasche."
L["MISC_SHARDS_DESTROY"] = "Zerst\195\182re neue Seelensplitter,\nwenn die Tasche voll ist."
L["MISC_BAG"] = "W\195\164hle die Seelensplitter-Tasche"
L["MISC_SHARDS_MAX"] = "Maximale Anzahl der zu behaltenden Splitter:"
L["MISC_LOCK"] = "Sperre Arcanist"
L["MISC_HIDDEN"] = "Zeige versteckte Buttons um sie zu verschieben"
L["MISC_HIDDEN_SIZE"] = "Gr\195\182\195\159e des versteckten Buttons"
-- Functions
L["UNDEAD"] = "Untoter"
L["DEMON"] = "D\195\164mon"
L["ELEMENTAL"] = "Elementar"
--
L["BACKLASH"] = "Heimzahlen"
L["SHADOW_TRANCE"] = "Schattentrance"
--
L["BAG_SOUL_POUCH"] = "Kleiner Seelenbeutel"
L["BAG_SMALL_SOUL_POUCH"] = "Seelenkasten"
L["BAG_BOX_OF_SOULS"] = "Seelenbeutel"
L["BAG_FELCLOTH_BAG"] = "Teufelsstofftasche"
L["BAG_EBON_SHADOW_BAG"] = "Abgr\195\188ndige Tasche"
L["BAG_CORE_FELCLOTH_BAG"] = "Kernteufelsstofftasche"
L["BAG_ABYSSAL_BAG"] = "Schwarzschattentasche"
--
L["MINOR"] = "schwach"
L["MAJOR"] = "gering"
L["LESSER"] = "gro/195/159"
L["GREATER"] = "erheblich"
--
L["COOLDOWN"] = "Cooldown"
L["RANK"] = "Rang"
L["CREATE"] = "herstellen"
--
L["ANTI_FEAR_BUFF_FEAR_WARD"]	= "Furchtzauberschutz"
L["ANTI_FEAR_BUFF_FORSAKEN"]	= "Wille der Verlassenen"
L["ANTI_FEAR_BUFF_FEARLESS"]	= "Furchtlos"
L["ANTI_FEAR_BUFF_BERSERK"]		= "Berserkerwut"
L["ANTI_FEAR_BUFF_RECKLESS"]	= "Tollk\195\188hnheit"
L["ANTI_FEAR_BUFF_WISH"]		= "Todeswunsch"
L["ANTI_FEAR_BUFF_WRATH"]		= "Zorn des Wildtieres"
L["ANTI_FEAR_BUFF_ICE"]			= "Eisblock"
L["ANTI_FEAR_BUFF_PROTECT"]		= "G\195\182ttlicher Schutz"
L["ANTI_FEAR_BUFF_SHIELD"]		= "Gottesschild"
L["ANTI_FEAR_BUFF_TREMOR"]		= "Totem des Erdsto\195\159es"
L["ANTI_FEAR_BUFF_ABOLISH"]		= "Abolish Magic"
L["ANTI_FEAR_DEBUFF_RECKLESS"]	= "Curse of Recklessness"

-- Speech

--
L["ABOUT_VERSION"] = "Version";
L["ABOUT_AUTHOR"] = "Author";
L["ABOUT_CREDITS"] = "Credits";
L["ABOUT_CATEGORY"] = "Category";
L["ABOUT_EMAIL"] = "E-mail";
L["ABOUT_WEB"] = "Website";
L["ABOUT_LICENSE"] = "License";
