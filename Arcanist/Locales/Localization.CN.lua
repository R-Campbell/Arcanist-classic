--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

local L = LibStub("AceLocale-3.0"):NewLocale(ARCANIST_ID,"zhCN")
if not L then return end

L["ARCANIST"] = "Arcanist";
L["ARCANIST_ONLY"] = "Arcanist";
L["ARCANIST_DEBUG"] = "<Arcanist>";
L["ARCANIST_PRINT"] = "Arcanist";

-- Configuration
L["HEALTHSTONE_COOLDOWN"] = "治疗石冷却时间"
L["USE"] = "Use"
L["TRADE"] = "Trade"
L["ARCANIST_LABEL"] = "|c00FFFFFF".."Arcanist".."|r"
L["YES"] = "是"
L["NO"] = "否"
L["ON"] = "开"
L["OFF"] = "关"
--
L["SOUL_SHARD"] = "灵魂碎片"
L["SOUL_SHARD_LABEL"] = "灵魂碎片: "
L["INFERNAL_STONE"] = "地狱火石"
L["INFERNAL_STONE_LABEL"] = "地狱火石: "
L["DEMONIAC_STONE"] = "恶魔雕像"
L["DEMONIAC_STONE_LABEL"] = "恶魔雕像: "
L["SOUL_STONE"] = "灵魂石"
L["SOUL_STONE_LABEL"] = "灵魂石: "
L["HEALTH_STONE"] = "治疗石"
L["HEALTH_STONE_LABEL"] = "治疗石: "
L["SPELL_STONE"] = "法术石"
L["SPELL_STONE_LABEL"] = "法术石: "
L["FIRE_STONE"] = "火焰石"
L["FIRE_STONE_LABEL"] = "火焰石: "
L["CURRENT_DEMON"] = "恶魔: "
L["ENSLAVED_DEMON"] = "恶魔: 奴役"
L["NO_CURRENT_DEMON"] = "恶魔: 无"
L["HEARTHSTONE"] = "炉石"
--
L["SOULSTONE_TEXT_1"] = "制造"
L["SOULSTONE_TEXT_2"] = "可使用"
L["SOULSTONE_TEXT_3"] = "已使用"
L["SOULSTONE_TEXT_4"] = "等待"
L["SOULSTONE_RITUAL"] = "|c00FFFFFF".."Shift+Click to cast the Ritual of Summoning".."|r"
L["HEALTHSTONE_TEXT_1_1"] = "制造"
L["HEALTHSTONE_TEXT_1_2"] = "使用"
L["HEALTHSTONE_TEXT_2"] = "按中键或是Ctrl-左键交易"
L["HEALTHSTONE_RITUAL"] = "|c00FFFFFF".."Shift+Click to cast the Ritual of Souls".."|r"
L["SPELLSTONE_TEXT_1"] = "Right click to create"
L["SPELLSTONE_TEXT_2"] = "In Inventory\nLeft click to use"
L["SPELLSTONE_TEXT_3"] = "Used"
L["SPELLSTONE_TEXT_4"] = "Used\nClick to create"
L["FIRESTONE_TEXT_1"] = "Right click to create"
L["FIRESTONE_TEXT_2"] = "In Inventory\nLeft click to use"
L["FIRESTONE_TEXT_3"] = "Used"
L["FIRESTONE_TEXT_4"] = "Used\nClick to create"
L["SPELLTIMER_LABEL"] = "|c00FFFFFF".."Spell Durations".."|r"
L["SPELLTIMER_TEXT"] = "启用对目标的法术计时"
L["SPELLTIMER_RIGHT"] = "右键使用炉石到 "
L["SHADOW_TRANCE_LABEL"] = "|c00FFFFFF".."暗影冥思".."|r"
L["BACKLASH_LABEL"] = "|c00FFFFFF".."反冲".."|r"
L["BANISH_TEXT"] = "按右键施放等级1"
-- Pets
L["IMP_LABEL"] = "|c00FFFFFF".."小鬼".."|r"
L["IMP"] = "小鬼"
L["VOIDWALKER_LABEL"] = "|c00FFFFFF".."虚空行者".."|r"
L["VOIDWALKER"] = "虚空行者"
L["SUCCUBUS_LABEL"] = "|c00FFFFFF".."魅魔".."|r"
L["SUCCUBUS"] = "魅魔"
L["FELHUNTER_LABEL"] = "|c00FFFFFF".."地狱猎犬".."|r"
L["FELHUNTER"] = "地狱猎犬"
L["FELGUARD_LABEL"] = "|c00FFFFFF".."地狱守卫".."|r"
L["FELGUARD"] = "地狱火"
L["INFERNAL_LABEL"] = "|c00FFFFFF".."地狱火".."|r"
L["INFERNAL"] = "末日守卫"
L["DOOMGUARD_LABEL"] = "|c00FFFFFF".."末日守卫".."|r"
L["DOOMGUARD"] = "厄运守卫"
--
L["MOUNT_LABEL"] = "|c00FFFFFF".."坐骑".."|r"
L["MOUNT_TEXT"] = "右键施放等级1"
L["BUFF_MENU_LABEL"] = "|c00FFFFFF".."法术菜单".."|r"
L["BUFF_MENU_TEXT_1"] = "右键保持菜单开启"
L["BUFF_MENU_TEXT_2"] = "自动模式：脱离战斗后自动关闭"
L["PET_MENU_LABEL"] = "|c00FFFFFF".."恶魔菜单".."|r"
L["PET_MENU_TEXT_1"] = "右键保持菜单开启"
L["PET_MENU_TEXT_2"] = "自动模式：脱离战斗后自动关闭"
L["CURSE_MENU_LABEL"] = "|c00FFFFFF".."诅咒菜单".."|r"
L["CURSE_MENU_TEXT_1"] = "右键保持菜单开启"
L["CURSE_MENU_TEXT_2"] = "自动模式：脱离战斗后自动关闭"
L["DOMINATION_COOLDOWN"] = "右键快速召唤"
--
L["SOUND_FEAR"] = "Interface\\AddOns\\Arcanist\\sounds\\Fear-En.mp3"
L["SOUND_SOUL_STONE_END"] = "Interface\\AddOns\\Arcanist\\sounds\\SoulstoneEnd-En.mp3"
L["SOUND_ENSLAVE_END"] = "Interface\\AddOns\\Arcanist\\sounds\\EnslaveDemonEnd-En.mp3"
L["SOUND_SHADOW_TRANCE"] = "Interface\\AddOns\\Arcanist\\sounds\\ShadowTrance-En.mp3"
L["SOUND_BACKLASH"] = "Interface\\AddOns\\Arcanist\\sounds\\Backlash-Fr.mp3"
--
L["PROC_SHADOW_TRANCE"] = "<white>S<lightPurple1>h<lightPurple2>a<purple>d<darkPurple1>o<darkPurple2>w T<darkPurple1>r<purple>a<lightPurple2>n<lightPurple1>c<white>e"
L["PROC_BACKLASH"] = "<white>B<lightPurple1>a<lightPurple2>c<purple>k<darkPurple1>l<darkPurple2>a<darkPurple1>s<purple>h"

L["BAG_FULL_PREFIX"] = "你的 "
L["BAG_FULL_SUFFIX"] = " 满了 !"
L["BAG_FULL_DESTROY_PREFIX"] = " 满了; 下个碎片将被摧毁!"
L["INTERFACE_WELCOME"] = "<white>/arcanist 显示设置菜单!"
L["INTERFACE_TOOLTIP_ON"] = "打开提示"
L["INTERFACE_TOOLTIP_OFF"] = "关闭提示"
L["INTERFACE_MESSAGE_ON"] = "打开聊天信息通知"
L["INTERFACE_MESSAGE_OFF"] = "关闭聊天信息通知"
L["INTERFACE_DEFAULT_CONFIG"] = "<lightYellow>默认配置已加载。."
L["INTERFACE_USER_CONFIG"] = "<lightYellow>配置已加载。."
L["HELP_1"] = "/arcanist <lightOrange>recall<white> -- <lightBlue>将Arcanist和所有按钮置于屏幕中间"
L["HELP_2"] = "/arcanist <lightOrange>reset<white> -- <lightBlue>Reset Arcanist entirely"
L["INFO_FEAR_PROTECT"] = "你的目标对恐惧免疫!"
L["INFO_ENSLAVE_BREAK"] = "恶魔摆脱奴役..."
L["INFO_SOUL_STONE_END"] = "<lightYellow>你的灵魂石失效。."
--
L["CONFIG_MESSAGE"] = "信息设置"
L["CONFIG_SPHERE"] = "Sphere Settings"
L["CONFIG_BUTTON"] = "按钮设置"
L["CONFIG_MENU"] = "Menu Settings"
L["CONFIG_TIMER"] = "计时器设置"
L["CONFIG_MISC"] = "Miscellaneous Settings"
--
L["MSG_POSITION"] = "<- 这儿将显示Arcanist的信息 ->"
L["MSG_SHOW_TIPS"] = "显示提示"
L["MSG_SHOW_SYS"] = "宣告Arcanist信息作为系统信息"
L["MSG_RANDOM"] = "随机显示召唤的信息"
L["MSG_USE_SHORT"] = "Use short messages"
L["MSG_RANDOM_DEMON"] = "激活随机语言 (恶魔"
L["MSG_RANDOM_STEED"] = "激活随机语言 (坐骑)"
L["MSG_RANDOM_SOULS"] = "激活灵魂仪式的随机信息"
L["MSG_SOUNDS"] = "开启声音"
L["MSG_WARN_FEAR"] = "当我的目标免疫恐惧时提醒我。"
L["MSG_WARN_BANISH"] = "Warn when the target is banishable or enslavable"
L["MSG_WARN_TRANCE"] = "当我获得暗影冥思效果时提醒我。"
--
L["SPHERE_SIZE"] = "Arcanist按钮的大小"
L["SPHERE_SKIN"] = "Arcanist球体的皮肤"
L["SPHERE_EVENT"] = "图形显示"
L["SPHERE_SPELL"] = "Spell casted by the Sphere"
L["SPHERE_COUNTER"] = "显示碎片数量"
L["SPHERE_STONE"] = "石头类型"
--	Color
L["PINK"] = "粉红色"
L["BLUE"] = "蓝色"
L["ORANGE"] = "橙色"
L["TURQUOISE"] = "青绿色"
L["PURPLE"] = "紫色"
-- Count
L["SOUL_SHARDS"] = "灵魂碎片"
L["DEMON_SUMMON_STONES"] = "恶魔召唤石"
L["REZ_TIMER"] = "灵魂石冷却计时"
L["MANA"] = "Mana"
L["HEALTH"] = "Health"
-- Buttons
L["BUTTONS_ROTATION"] = "Buttons rotation"
L["BUTTONS_STICK"] = "Stick buttons around the Sphere"
L["BUTTONS_MOUNT"] = "Use my own mounts"
L["BUTTONS_SELECTION"] = "Selection of buttons to be shown"
L["BUTTONS_LEFT"] = "Left click"
L["BUTTONS_RIGHT"] = "Right click"
--
L["SHOW_FIRE_STONE"] = "显示火焰石按钮"
L["SHOW_SPELL_STONE"] = "显示法术石按钮"
L["SHOW_HEALTH_STONE"] = "显示治疗石按钮"
L["SHOW_SOUL_STONE"] = "显示灵魂石按钮"
L["SHOW_SPELL"] = "显示buff菜单按钮"
L["SHOW_STEED"] = "显示战马按钮"
L["SHOW_DEMON"] = "显示恶魔召唤菜单按钮"
L["SHOW_CURSE"] = "显示诅咒菜单按钮"
--
L["MENU_GENERAL"] = "General Options"
L["MENU_SPELLS"] = "法术菜单"
L["MENU_DEMONS"] = "恶魔菜单"
L["MENU_CURSES"] = "诅咒菜单"
L["MENU_ALWAYS"] = "Always show menus"
L["MENU_AUTO_COMBAT"] = "Automatically display menus while in combat"
L["MENU_CLOSE_CLICK"] = "Close a menu whenever you click on one of its items"
L["MENU_ORIENTATION"] = "Menu orientation"
L["MENU_VERT"] = "Change the vertical symmetry of buttons"
L["MENU_BANISH"] = "放逐按钮大小"
--
L["HORIZONTAL"] = "Horizontal"
L["UPWARDS"] = "Upwards"
L["DOWNWARDS"] = "Downwards"
--
L["TIMER_TYPE"] = "Timer type"
L["TIMER_SPELL"] = "Show the Spell Timer Button"
L["TIMER_LEFT"] = "计时器在按钮左边"
L["TIMER_UP"] = "计时器向上升"
--
L["NO_TIMER"] = "No Timer"
L["GRAPHICAL"] = "Graphical"
L["TEXTUAL"] = "Textual"
--
L["MISC_SHARDS_BAG"] = "将碎片放入选择的包。."
L["MISC_SHARDS_DESTROY"] = "如果包满摧毁所有新的碎片。."
L["MISC_BAG"] = "选择灵魂碎片包"
L["MISC_SHARDS_MAX"] = "Maximum number of shards to keep"
L["MISC_LOCK"] = "锁定 Arcanist球体及周围的按钮。"
L["MISC_HIDDEN"] = "显示隐藏的按钮以拖动它。"
L["MISC_HIDDEN_SIZE"] = "暗影冥思和反恐按钮的大小"
-- Functions
L["UNDEAD"] = "亡灵"
L["DEMON"] = "恶魔"
L["ELEMENTAL"] = "元素"
--
L["BACKLASH"] = "反冲"
L["SHADOW_TRANCE"] = "暗影冥思"
--
L["BAG_SOUL_POUCH"] = "灵魂袋"
L["BAG_SMALL_SOUL_POUCH"] = "恶魔布包"
L["BAG_BOX_OF_SOULS"] = "熔火恶魔布包"
L["BAG_FELCLOTH_BAG"] = "Felcloth Bag"
L["BAG_EBON_SHADOW_BAG"] = "Ebon Shadowbag"
L["BAG_CORE_FELCLOTH_BAG"] = "Core Felcloth Bag"
L["BAG_ABYSSAL_BAG"] = "Abyssal Bag"
--
L["MINOR"] = "Minor"
L["MAJOR"] = "Major"
L["LESSER"] = "Lesser"
L["GREATER"] = "Greater"
--
L["COOLDOWN"] = "冷却时间"
L["RANK"] = "等级"
L["CREATE"] = ""
--
L["ANTI_FEAR_BUFF_FEAR_WARD"]	= "恐惧防护结界"
L["ANTI_FEAR_BUFF_FORSAKEN"]	= "亡灵意志"
L["ANTI_FEAR_BUFF_FEARLESS"]	= "反恐惧"
L["ANTI_FEAR_BUFF_BERSERK"]		= "狂怒"
L["ANTI_FEAR_BUFF_RECKLESS"]	= "鲁莽"
L["ANTI_FEAR_BUFF_WISH"]		= "死亡之愿"
L["ANTI_FEAR_BUFF_WRATH"]		= "狂野怒火"
L["ANTI_FEAR_BUFF_ICE"]			= "寒冰屏障"
L["ANTI_FEAR_BUFF_PROTECT"]		= "圣佑术"
L["ANTI_FEAR_BUFF_SHIELD"]		= "圣盾术"
L["ANTI_FEAR_BUFF_TREMOR"]		= "战栗图腾"
L["ANTI_FEAR_BUFF_ABOLISH"]		= "废除魔法"
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
