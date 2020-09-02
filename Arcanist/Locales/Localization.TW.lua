--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

local L = LibStub("AceLocale-3.0"):NewLocale(ARCANIST_ID,"zhTW")
if not L then return end

L["ARCANIST"] = "Arcanist";
L["ARCANIST_ONLY"] = "Arcanist";
L["ARCANIST_DEBUG"] = "<Arcanist>";
L["ARCANIST_PRINT"] = "Arcanist";

-- Configuration
L["HEALTHSTONE_COOLDOWN"] = "治療石冷卻時間"
L["USE"] = "使用"
L["TRADE"] = "交易"
L["ARCANIST_LABEL"] = "|c00FFFFFF".."Arcanist".."|r"
L["YES"] = "是"
L["NO"] = "否"
L["ON"] = "開"
L["OFF"] = "關"
--
L["SOUL_SHARD"] = "靈魂裂片"
L["SOUL_SHARD_LABEL"] = "靈魂碎片: "
L["INFERNAL_STONE"] = "地獄火石"
L["INFERNAL_STONE_LABEL"] = "地獄火石: "
L["DEMONIAC_STONE"] = "惡魔雕像"
L["DEMONIAC_STONE_LABEL"] = "惡魔雕像: "
L["SOUL_STONE"] = "靈魂石"
L["SOUL_STONE_LABEL"] = "\n靈魂石: "
L["HEALTH_STONE"] = "治療石"
L["HEALTH_STONE_LABEL"] = "治療石: "
L["SPELL_STONE"] = "法術石"
L["SPELL_STONE_LABEL"] = "法術石: "
L["FIRE_STONE"] = "火焰石"
L["FIRE_STONE_LABEL"] = "火焰石: "
L["CURRENT_DEMON"] = "惡魔: "
L["ENSLAVED_DEMON"] = "惡魔: 奴役"
L["NO_CURRENT_DEMON"] = "惡魔: 無"
L["HEARTHSTONE"] = "爐石"
--
L["SOULSTONE_TEXT_1"] = "製造"
L["SOULSTONE_TEXT_2"] = "使用"
L["SOULSTONE_TEXT_3"] = "已使用"
L["SOULSTONE_TEXT_4"] = "等待中"
L["SOULSTONE_RITUAL"] = "|c00FFFFFF".."Shift+Click to cast the Ritual of Summoning".."|r"
L["HEALTHSTONE_TEXT_1_1"] = "製造"
L["HEALTHSTONE_TEXT_1_2"] = "使用"
L["HEALTHSTONE_TEXT_2"] = "按中鍵或是Ctrl-左鍵交易"
L["HEALTHSTONE_RITUAL"] = "|c00FFFFFF".."Shift+左鍵施放靈魂儀式".."|r"
L["SPELLSTONE_TEXT_1"] = "按右鍵製造"
L["SPELLSTONE_TEXT_2"] = "按左鍵使用"
L["SPELLSTONE_TEXT_3"] = "已使用"
L["SPELLSTONE_TEXT_4"] = "已使用\點擊製造"
L["FIRESTONE_TEXT_1"] = "按右鍵製造"
L["FIRESTONE_TEXT_2"] = "按左鍵使用"
L["FIRESTONE_TEXT_3"] = "已使用"
L["FIRESTONE_TEXT_4"] = "已使用\點擊製造"
L["SPELLTIMER_LABEL"] = "|c00FFFFFF".."法術持續時間".."|r"
L["SPELLTIMER_TEXT"] = "啟用對目標的法術計時"
L["SPELLTIMER_RIGHT"] = "右鍵使用爐石到 "
L["SHADOW_TRANCE_LABEL"] = "|c00FFFFFF".."暗影冥思".."|r"
L["BACKLASH_LABEL"] = "|c00FFFFFF".."反衝".."|r"
L["BANISH_TEXT"] = "按右鍵施放等級1"
-- Pets
L["IMP_LABEL"] = "|c00FFFFFF".."小鬼".."|r"
L["IMP"] = "小鬼"
L["VOIDWALKER_LABEL"] = "|c00FFFFFF".."虛空行者".."|r"
L["VOIDWALKER"] = "虛無行者"
L["SUCCUBUS_LABEL"] = "|c00FFFFFF".."魅魔".."|r"
L["SUCCUBUS"] = "魅魔"
L["FELHUNTER_LABEL"] = "|c00FFFFFF".."地獄獵犬".."|r"
L["FELHUNTER"] = "惡魔獵犬"
L["FELGUARD_LABEL"] = "|c00FFFFFF".."地獄守衛".."|r"
L["FELGUARD"] = "惡魔守衛"
L["INFERNAL_LABEL"] = "|c00FFFFFF".."地獄火".."|r"
L["INFERNAL"] = "地獄火"
L["DOOMGUARD_LABEL"] = "|c00FFFFFF".."末日守衛".."|r"
L["DOOMGUARD"] = "末日守衛"
--
L["MOUNT_LABEL"] = "|c00FFFFFF".."坐騎".."|r"
L["MOUNT_TEXT"] = "右鍵施放等級1"
L["BUFF_MENU_LABEL"] = "|c00FFFFFF".."法術選單".."|r"
L["BUFF_MENU_TEXT_1"] = "右鍵保持選單開啟"
L["BUFF_MENU_TEXT_2"] = "自動模式：脫離戰鬥後自動關閉"
L["PET_MENU_LABEL"] = "|c00FFFFFF".."惡魔選單".."|r"
L["PET_MENU_TEXT_1"] = "右鍵保持選單開啟"
L["PET_MENU_TEXT_2"] = "自動模式：脫離戰鬥後自動關閉"
L["CURSE_MENU_LABEL"] = "|c00FFFFFF".."詛咒選單".."|r"
L["CURSE_MENU_TEXT_1"] = "右鍵保持選單開啟"
L["CURSE_MENU_TEXT_2"] = "自動模式：脫離戰鬥後自動關閉"
L["DOMINATION_COOLDOWN"] = "右鍵快速召喚"
--
L["SOUND_FEAR"] = "Interface\\AddOns\\Arcanist\\sounds\\Fear-En.mp3"
L["SOUND_SOUL_STONE_END"] = "Interface\\AddOns\\Arcanist\\sounds\\SoulstoneEnd-En.mp3"
L["SOUND_ENSLAVE_END"] = "Interface\\AddOns\\Arcanist\\sounds\\EnslaveDemonEnd-En.mp3"
L["SOUND_SHADOW_TRANCE"] = "Interface\\AddOns\\Arcanist\\sounds\\ShadowTrance-En.mp3"
L["SOUND_BACKLASH"] = "Interface\\AddOns\\Arcanist\\sounds\\Backlash-Fr.mp3"
--
L["PROC_SHADOW_TRANCE"] = "你沒有任何的暗影箭法術。"
L["PROC_BACKLASH"] = "<white>暗<lightPurple1>影<lightPurple2>冥<purple>思<darkPurple1>！<darkPurple2>暗<darkPurple1>影<purple>冥<lightPurple2>思<lightPurple1>！<white>！"

L["BAG_FULL_PREFIX"] = "你的 "
L["BAG_FULL_SUFFIX"] = " 滿了!"
L["BAG_FULL_DESTROY_PREFIX"] = " 滿了; 下個碎片將被摧毀!"
L["INTERFACE_WELCOME"] = "<white>/arcanist 顯示設定功能表!"
L["INTERFACE_TOOLTIP_ON"] = "打開提示"
L["INTERFACE_TOOLTIP_OFF"] = "關閉提示"
L["INTERFACE_MESSAGE_ON"] = "打開聊天訊息通知"
L["INTERFACE_MESSAGE_OFF"] = "關閉聊天訊息通知"
L["INTERFACE_DEFAULT_CONFIG"] = "<lightYellow>預設配置已載入."
L["INTERFACE_USER_CONFIG"] = "<lightYellow>配置已載入."
L["HELP_1"] = "/arcanist <lightOrange>recall<white> -- <lightBlue>將Arcanist置於螢幕中央"
L["HELP_2"] = "/arcanist <lightOrange>reset<white> -- <lightBlue>重置所有設定"
L["INFO_FEAR_PROTECT"] = "你的目標對恐懼免疫!"
L["INFO_ENSLAVE_BREAK"] = "惡魔擺脫奴役..."
L["INFO_SOUL_STONE_END"] = "<lightYellow>你的靈魂石已失效."
--
L["CONFIG_MESSAGE"] = "資訊設定"
L["CONFIG_SPHERE"] = "球體設定"
L["CONFIG_BUTTON"] = "按鈕設定"
L["CONFIG_MENU"] = "選單設定"
L["CONFIG_TIMER"] = "計時器設定"
L["CONFIG_MISC"] = "雜項設定"
--
L["MSG_POSITION"] = "<- 這裡將顯示Arcanist的系統訊息 ->"
L["MSG_SHOW_TIPS"] = "顯示提示"
L["MSG_SHOW_SYS"] = "宣告Arcanist訊息為系統訊息"
L["MSG_RANDOM"] = "顯示隨機訊息"
L["MSG_USE_SHORT"] = "採用簡短訊息"
L["MSG_RANDOM_DEMON"] = "啟用招喚惡魔的隨機訊息"
L["MSG_RANDOM_STEED"] = "啟用招喚坐騎的隨機訊息"
L["MSG_RANDOM_SOULS"] = "啟用靈魂儀式的隨機訊息"
L["MSG_SOUNDS"] = "開啟音效"
L["MSG_WARN_FEAR"] = "提醒目標為免疫恐懼"
L["MSG_WARN_BANISH"] = "提醒目標為可放逐或可奴役"
L["MSG_WARN_TRANCE"] = "提醒獲得暗影冥思效果"
--
L["SPHERE_SIZE"] = "Arcanist按鈕的大小"
L["SPHERE_SKIN"] = "Arcanist球體的外觀"
L["SPHERE_EVENT"] = "球體事件顯示"
L["SPHERE_SPELL"] = "球體施放的法術"
L["SPHERE_COUNTER"] = "顯示碎片數量"
L["SPHERE_STONE"] = "計算石頭類型"
--	Color
L["PINK"] = "粉紅色"
L["BLUE"] = "藍色"
L["ORANGE"] = "橘色"
L["TURQUOISE"] = "青綠色"
L["PURPLE"] = "紫色"
-- Count
L["SOUL_SHARDS"] = "靈魂碎片"
L["DEMON_SUMMON_STONES"] = "惡魔召喚石"
L["REZ_TIMER"] = "靈魂石冷卻計時"
L["MANA"] = "魔力"
L["HEALTH"] = "體力"
-- Buttons
L["BUTTONS_ROTATION"] = "旋轉按鈕"
L["BUTTONS_STICK"] = "將按鈕固定於球體週圍"
L["BUTTONS_MOUNT"] = "使用自己的坐騎"
L["BUTTONS_SELECTION"] = "顯示選擇的按鈕"
L["BUTTONS_LEFT"] = "坐騎 - 左鍵"
L["BUTTONS_RIGHT"] = "坐騎 - 右鍵"
--
L["SHOW_FIRE_STONE"] = "顯示火焰石按鈕"
L["SHOW_SPELL_STONE"] = "顯示法術石按鈕"
L["SHOW_HEALTH_STONE"] = "顯示治療石按鈕"
L["SHOW_SOUL_STONE"] = "顯示靈魂石按鈕"
L["SHOW_SPELL"] = "顯示法術功能表按鈕"
L["SHOW_STEED"] = "顯示戰馬按鈕"
L["SHOW_DEMON"] = "顯示惡魔召喚功能表按鈕"
L["SHOW_CURSE"] = "顯示詛咒功能表按鈕"
--
L["MENU_GENERAL"] = "一般選單"
L["MENU_SPELLS"] = "法術增益選單"
L["MENU_DEMONS"] = "惡魔選單"
L["MENU_CURSES"] = "詛咒選單"
L["MENU_ALWAYS"] = "永遠顯示選單"
L["MENU_AUTO_COMBAT"] = "當戰鬥時自動顯示選單"
L["MENU_CLOSE_CLICK"] = "點擊後關閉選單"
L["MENU_ORIENTATION"] = "選單方向"
L["MENU_VERT"] = "改變按鈕對稱性"
L["MENU_BANISH"] = "放逐按鈕大小"
--
L["HORIZONTAL"] = "水平"
L["UPWARDS"] = "往上"
L["DOWNWARDS"] = "往下"
--
L["TIMER_TYPE"] = "計時器種類"
L["TIMER_SPELL"] = "顯示計時器按鈕"
L["TIMER_LEFT"] = "計時器在按鈕左邊"
L["TIMER_UP"] = "計時器向上增加"
--
L["NO_TIMER"] = "無計時器"
L["GRAPHICAL"] = "圖型"
L["TEXTUAL"] = "文字"
--
L["MISC_SHARDS_BAG"] = "將碎片放入選擇的包包."
L["MISC_SHARDS_DESTROY"] = "如果包包滿了，摧毀所有新的碎片."
L["MISC_BAG"] = "選擇靈魂碎片包包"
L["MISC_SHARDS_MAX"] = "靈魂碎片最大保存量"
L["MISC_LOCK"] = "鎖定Arcanist主體及周圍的按鈕"
L["MISC_HIDDEN"] = "顯示隱藏的按鈕以便能拖曳它"
L["MISC_HIDDEN_SIZE"] = "暗影冥思和反恐按鈕的大小"
-- Functions
L["UNDEAD"] = "不死族"
L["DEMON"] = "惡魔"
L["ELEMENTAL"] = "元素"
--
L["BACKLASH"] = "反衝"
L["SHADOW_TRANCE"] = "暗影冥思"
--
L["BAG_SOUL_POUCH"] = "靈魂袋"
L["BAG_SMALL_SOUL_POUCH"] = "惡魔布包"
L["BAG_BOX_OF_SOULS"] = "熔火惡魔布包"
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
L["COOLDOWN"] = "冷卻時間"
L["RANK"] = "等級"
L["CREATE"] = "製造"
--
L["ANTI_FEAR_BUFF_FEAR_WARD"]	= "防護恐懼結界"
L["ANTI_FEAR_BUFF_FORSAKEN"]	= "亡靈意志"
L["ANTI_FEAR_BUFF_FEARLESS"]	= "無畏"
L["ANTI_FEAR_BUFF_BERSERK"]		= "狂怒"
L["ANTI_FEAR_BUFF_RECKLESS"]	= "魯莽"
L["ANTI_FEAR_BUFF_WISH"]		= "死亡之願"
L["ANTI_FEAR_BUFF_WRATH"]		= "狂野怒火"
L["ANTI_FEAR_BUFF_ICE"]			= "寒冰屏障"
L["ANTI_FEAR_BUFF_PROTECT"]		= "聖佑術"
L["ANTI_FEAR_BUFF_SHIELD"]		= "聖盾術"
L["ANTI_FEAR_BUFF_TREMOR"]		= "戰慄圖騰"
L["ANTI_FEAR_BUFF_ABOLISH"]		= "廢除魔法"
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
