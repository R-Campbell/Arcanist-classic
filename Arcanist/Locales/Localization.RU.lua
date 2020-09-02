--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

local L = LibStub("AceLocale-3.0"):NewLocale(ARCANIST_ID,"ruRU")
if not L then return end

L["ARCANIST"] = "Arcanist";
L["ARCANIST_ONLY"] = "Arcanist";
L["ARCANIST_DEBUG"] = "<Arcanist>";
L["ARCANIST_PRINT"] = "Arcanist";

-- Configuration
L["HEALTHSTONE_COOLDOWN"] = "Healthstone Cooldown"
L["USE"] = "Use"
L["TRADE"] = "Trade"
L["ARCANIST_LABEL"] = "|c00FFFFFF".."Arcanist".."|r"
L["YES"] = "Есть"
L["NO"] = "Нет"
L["ON"] = "Вкл"
L["OFF"] = "Выкл"
--
L["SOUL_SHARD"] = "Осколок души"
L["SOUL_SHARD_LABEL"] = "Осколки душ: "
L["INFERNAL_STONE"] = "Камень инфернала"
L["INFERNAL_STONE_LABEL"] = "Камни инфернала: "
L["DEMONIAC_STONE"] = "Демоническая статуэтка"
L["DEMONIAC_STONE_LABEL"] = "Demonic Figurine(s): "
L["SOUL_STONE"] = "[Кк]амень души"
L["SOUL_STONE_LABEL"] = "Камень души: "
L["HEALTH_STONE"] = "[Кк]амень здоровья"
L["HEALTH_STONE_LABEL"] = "Камень огня: "
L["SPELL_STONE"] = "[Кк]амень чар"
L["SPELL_STONE_LABEL"] = "Spellstone: "
L["FIRE_STONE"] = "[Кк]амень огня"
L["FIRE_STONE_LABEL"] = "Камень огня: "
L["CURRENT_DEMON"] = "Демон: "
L["ENSLAVED_DEMON"] = "Демон: Порабощенный"
L["NO_CURRENT_DEMON"] = "Демон: Отсутствует"
L["HEARTHSTONE"] = "Камень возвращения"
--
L["SOULSTONE_TEXT_1"] = "[Правый Клик] Создать"
L["SOULSTONE_TEXT_2"] = "[Левый Клик] Использовать"
L["SOULSTONE_TEXT_3"] = "[Правый Клик] Повторное создание"
L["SOULSTONE_TEXT_4"] = "Ожидание"
L["SOULSTONE_RITUAL"] = "|c00FFFFFF".."[Shift]+[Клик] начало выполнения Ритуала призыва".."|r"
L["HEALTHSTONE_TEXT_1_1"] = "Правый Клик] Создать"
L["HEALTHSTONE_TEXT_1_2"] = "[Левый Клик] Использовать"
L["HEALTHSTONE_TEXT_2"] = "[Средний Клик] или [Ctrl]+[Левый Клик] для передачи"
L["HEALTHSTONE_RITUAL"] = "|c00FFFFFF".."[Shift]+[Клик] Начать Ритуал Душ".."|r"
L["SPELLSTONE_TEXT_1"] = "[Правый Клик] Создать камень"
L["SPELLSTONE_TEXT_2"] = "Камень у Вас в сумке\n[Левый Клик] Нанести на оружие"
L["SPELLSTONE_TEXT_3"] = "Нанесено на оружие\n[Клик] Для замены/обновления"
L["SPELLSTONE_TEXT_4"] = "Созданный ранее камень полностью использован\n[Клик] Создать новый камень"
L["FIRESTONE_TEXT_1"] = "[Правый Клик] Создать камень"
L["FIRESTONE_TEXT_2"] = "Камень у Вас в сумке\n[Левый Клик] Нанести на оружие"
L["FIRESTONE_TEXT_3"] = "Нанесено на оружие\n[Клик] Для замены/обновления"
L["FIRESTONE_TEXT_4"] = "Созданный ранее камень полностью использован\n[Клик] Создать новый камень"
L["SPELLTIMER_LABEL"] = "|c00FFFFFF".."Таймер заклинаний".."|r"
L["SPELLTIMER_TEXT"] = "Активное заклинание на цели"
L["SPELLTIMER_RIGHT"] = "[Правый Клик] Использовать Камень Возвращения в "
L["SHADOW_TRANCE_LABEL"] = "|c00FFFFFF".."Теневой транс".."|r"
L["BACKLASH_LABEL"] = "|c00FFFFFF".."Ответный Удар".."|r"
L["BANISH_TEXT"] = "[Правый Клик] для применения Уровня 1"
-- Pets
L["IMP_LABEL"] = "|c00FFFFFF".."Бес".."|r"
L["IMP"] = "Бес"
L["VOIDWALKER_LABEL"] = "|c00FFFFFF".."Демон Бездны".."|r"
L["VOIDWALKER"] = "Демон Бездны"
L["SUCCUBUS_LABEL"] = "|c00FFFFFF".."Суккуба".."|r"
L["SUCCUBUS"] = "Суккуба"
L["FELHUNTER_LABEL"] = "|c00FFFFFF".."Охотник Скверны".."|r"
L["FELHUNTER"] = "Охотник Скверны"
L["FELGUARD_LABEL"] = "|c00FFFFFF".."Страж Скверны".."|r"
L["FELGUARD"] = "Страж Скверны"
L["INFERNAL_LABEL"] = "|c00FFFFFF".."Инфернал".."|r"
L["INFERNAL"] = "Инферно"
L["DOOMGUARD_LABEL"] = "|c00FFFFFF".."Стражник Ужаса".."|r"
L["DOOMGUARD"] = "Привратник Скверны"
--
L["MOUNT_LABEL"] = "|c00FFFFFF".."Конь".."|r"
L["MOUNT_TEXT"] = "[Левый Клик] Призыв коня погибели\n[Правый Клик] Призыв коня Скверны"
L["BUFF_MENU_LABEL"] = "|c00FFFFFF".."Меню заклинаний".."|r"
L["BUFF_MENU_TEXT_1"] = "[Правый Клик] Для удержания меню открытым"
L["BUFF_MENU_TEXT_2"] = "Авто-Режим: Закрытие при выходе из боя"
L["PET_MENU_LABEL"] = "|c00FFFFFF".."Меню демонов".."|r"
L["PET_MENU_TEXT_1"] = "[Правый Клик] Для удержания меню открытым"
L["PET_MENU_TEXT_2"] = "Авто-Режим: Закрытие при выходе из боя"
L["CURSE_MENU_LABEL"] = "|c00FFFFFF".."Меню проклятий".."|r"
L["CURSE_MENU_TEXT_1"] = "[Правый Клик] Для удержания меню открытым"
L["CURSE_MENU_TEXT_2"] = "Авто-Режим: Закрытие при выходе из боя"
L["DOMINATION_COOLDOWN"] = "[Правый Клик] Быстрый вызов"
--
L["SOUND_FEAR"] = "Interface\\AddOns\\Arcanist\\sounds\\Fear-Ru.mp3"
L["SOUND_SOUL_STONE_END"] = "Interface\\AddOns\\Arcanist\\sounds\\SoulstoneEnd-Ru.mp3"
L["SOUND_ENSLAVE_END"] = "Interface\\AddOns\\Arcanist\\sounds\\EnslaveDemonEnd-Ru.mp3"
L["SOUND_SHADOW_TRANCE"] = "Interface\\AddOns\\Arcanist\\sounds\\ShadowTrance-Ru.mp3"
L["SOUND_BACKLASH"] = "Interface\\AddOns\\Arcanist\\sounds\\Backlash-Ru.mp3"
--
L["PROC_SHADOW_TRANCE"] = "<white>Т<lightPurple1>е<lightPurple2>н<purple>е<darkPurple1>в<darkPurple2>о<darkPurple1>й Т<purple>р<lightPurple2>а<lightPurple1>н<white>с"
L["PROC_BACKLASH"] = "<white>О<lightPurple1>т<lightPurple2>в<purple>е<darkPurple1>т<darkPurple2>н<darkPurple1>ы<darkPurple2>й У<purple>д<lightPurple2>а<lightPurple1>р"

L["BAG_FULL_PREFIX"] = "Ваша "
L["BAG_FULL_SUFFIX"] = " полна!"
L["BAG_FULL_DESTROY_PREFIX"] = " полна. Следующий осколок души будет уничтожен!"
L["INTERFACE_WELCOME"] = "<white>Введите /arcanist для отображения окна настроек!"
L["INTERFACE_TOOLTIP_ON"] = "[+] Всплывающие подсказки включены"
L["INTERFACE_TOOLTIP_OFF"] = "[-] Всплывающие подскажки выключены"
L["INTERFACE_MESSAGE_ON"] = "[+] Оповещения в окне чата - включены"
L["INTERFACE_MESSAGE_OFF"] = "[-] Оповещения в окне чата - выключены"
L["INTERFACE_DEFAULT_CONFIG"] = "<lightYellow>Загружена стандартная конфигурация."
L["INTERFACE_USER_CONFIG"] = "<lightYellow>Конфигурация успешно загружена."
L["HELP_1"] = "/arcanist <lightOrange>recall<white> -- <lightBlue>Команда для размещение окна Arcanist и его кнопок в центре экрана"
L["HELP_2"] = "/arcanist <lightOrange>reset<white> -- <lightBlue>Команда полностью сбрасывает все настройки Arcanist до настроек по умолчанию"
L["INFO_FEAR_PROTECT"] = "Ваша цель не поддается страху!"
L["INFO_ENSLAVE_BREAK"] = "Ваш демон разорвал цепи!"
L["INFO_SOUL_STONE_END"] = "<lightYellow>Ваш Камень Души выдохся!"
--
L["CONFIG_MESSAGE"] = "Настройки Сообщений"
L["CONFIG_SPHERE"] = "Настройки Сферы"
L["CONFIG_BUTTON"] = "Настройки Кнопок"
L["CONFIG_MENU"] = "Настройки Меню"
L["CONFIG_TIMER"] = "Настройки Таймера"
L["CONFIG_MISC"] = "Разное"
--
L["MSG_POSITION"] = "<- Сообщения Arcanist будут расположены здесь ->"
L["MSG_SHOW_TIPS"] = "Показывать подсказки"
L["MSG_SHOW_SYS"] = "Показывать сообщения Arcanist в системном окне"
L["MSG_RANDOM"] = "Включить различные оповещения"
L["MSG_USE_SHORT"] = "Использовать только 'короткие' сообщения"
L["MSG_RANDOM_DEMON"] = "Показывать сообщения для демонов"
L["MSG_RANDOM_STEED"] = "Показывать сообщения для коней"
L["MSG_RANDOM_SOULS"] = "Показывать сообщения для Ритуала Душ"
L["MSG_SOUNDS"] = "Воспроизводить звуковые эффекты"
L["MSG_WARN_FEAR"] = "Предупреждать, если цель не поддается страху"
L["MSG_WARN_BANISH"] = "Предупреждать, если цель изгнана или порабощена"
L["MSG_WARN_TRANCE"] = "Предупреждать о наступлении Теневого Транса"
--
L["SPHERE_SIZE"] = "Размер кнопок Arcanist"
L["SPHERE_SKIN"] = "Вид Сферы"
L["SPHERE_EVENT"] = "На Сфере отображать"
L["SPHERE_SPELL"] = "Заклинание Сферы"
L["SPHERE_COUNTER"] = "Показывать отсчет цифрами"
L["SPHERE_STONE"] = "Показывать количество камней"
--	Color
L["PINK"] = "Розовый"
L["BLUE"] = "Синий"
L["ORANGE"] = "Оранжевый"
L["TURQUOISE"] = "Бирюзовый"
L["PURPLE"] = "Пурпурный"
-- Count
L["SOUL_SHARDS"] = "Осколки душ"
L["DEMON_SUMMON_STONES"] = "Камни призыва демонов"
L["REZ_TIMER"] = "Таймер оживления"
L["MANA"] = "Мана"
L["HEALTH"] = "Здоровье"
-- Buttons
L["BUTTONS_ROTATION"] = "Вращение кнопок"
L["BUTTONS_STICK"] = "Закрепить кнопки вокруг Сферы"
L["BUTTONS_MOUNT"] = "Использовать мой транспорт"
L["BUTTONS_SELECTION"] = "Выбор кнопок, которые будут показаны"
L["BUTTONS_LEFT"] = "[Левый Клик]"
L["BUTTONS_RIGHT"] = "[Правый Клик]"
--
L["SHOW_FIRE_STONE"] = "Показывать кнопку Камня огня"
L["SHOW_SPELL_STONE"] = "Показывать кнопку Камня чар"
L["SHOW_HEALTH_STONE"] = "Показывать кнопку Камня здоровья"
L["SHOW_SOUL_STONE"] = "Показывать кнопку Камня Души"
L["SHOW_SPELL"] = "Показывать кнопку Заклинаний"
L["SHOW_STEED"] = "Показывать кнопку вызова Коня"
L["SHOW_DEMON"] = "Показывать кнопку Демонов"
L["SHOW_CURSE"] = "Показывать кнопку Проклятий"
--
L["MENU_GENERAL"] = "Основные настройки"
L["MENU_SPELLS"] = "Меню заклинаний"
L["MENU_DEMONS"] = "Меню Демонов"
L["MENU_CURSES"] = "Меню Проклятий"
L["MENU_ALWAYS"] = "Всегда показывать меню"
L["MENU_AUTO_COMBAT"] = "Показывать меню автоматически во время боя"
L["MENU_CLOSE_CLICK"] = "Закрывать меню тогда, когда Вы нажали на его элемент"
L["MENU_ORIENTATION"] = "Размещение меню"
L["MENU_VERT"] = "Изменить вертикальную симметрию кнопок (зеркальное\nотражение при выбранном размещении меню: Горизонтально)"
L["MENU_BANISH"] = "Размер кнопки Изгнания"
--
L["HORIZONTAL"] = "Горизонтально"
L["UPWARDS"] = "Вверх"
L["DOWNWARDS"] = "Вниз"
--
L["TIMER_TYPE"] = "Тип таймера"
L["TIMER_SPELL"] = "Показывать кнопку таймера заклинаний"
L["TIMER_LEFT"] = "Показывать строки таймера слева от кнопки таймера"
L["TIMER_UP"] = "Таймер растёт вверх"
--
L["NO_TIMER"] = "Нет таймера"
L["GRAPHICAL"] = "Графический"
L["TEXTUAL"] = "Текстовый"
--
L["MISC_SHARDS_BAG"] = "Размещать осколки душ в выбранной сумке"
L["MISC_SHARDS_DESTROY"] = "Разрушать все новые осколки, если сумка полна"
L["MISC_BAG"] = "Выбор контейнера для осколков душ"
L["MISC_SHARDS_MAX"] = "Максимальное кол-во хранимых осколков душ"
L["MISC_LOCK"] = "Заблокировать Arcanist"
L["MISC_HIDDEN"] = "Показать скрытые кнопки для их перемещения"
L["MISC_HIDDEN_SIZE"] = "Размер скрытых кнопок"
-- Functions
L["UNDEAD"] = "Нежить"
L["DEMON"] = "Демон"
L["ELEMENTAL"] = "Дух стихии"
--
L["BACKLASH"] = "Ответный удар"
L["SHADOW_TRANCE"] = "Теневой транс"
--
L["BAG_SOUL_POUCH"] = "Мешок душ"
L["BAG_SMALL_SOUL_POUCH"] = "Сума душ"
L["BAG_BOX_OF_SOULS"] = "Коробка душ"
L["BAG_FELCLOTH_BAG"] = "Сумка из ткани Скверны"
L["BAG_EBON_SHADOW_BAG"] = "Черная сумка теней"
L["BAG_CORE_FELCLOTH_BAG"] = "Сумка Бездны"
L["BAG_ABYSSAL_BAG"] = "Черная сумка теней"
--
L["MINOR"] = "Minor"
L["MAJOR"] = "Major"
L["LESSER"] = "Lesser"
L["GREATER"] = "Greater"
--
L["COOLDOWN"] = "Восстановление"
L["RANK"] = "Уровень"
L["CREATE"] = "Создание"
--
L["ANTI_FEAR_BUFF_FEAR_WARD"]	= "Защита от страха"
L["ANTI_FEAR_BUFF_FORSAKEN"]	= "Воля отрекшихся"
L["ANTI_FEAR_BUFF_FEARLESS"]	= "Бесстрашие"
L["ANTI_FEAR_BUFF_BERSERK"]		= "Ярость берсерка"
L["ANTI_FEAR_BUFF_RECKLESS"]	= "Безрассудство"
L["ANTI_FEAR_BUFF_WISH"]		= "Жажда смерти"
L["ANTI_FEAR_BUFF_WRATH"]		= "Звериный гнев"
L["ANTI_FEAR_BUFF_ICE"]			= "Ледяная преграда"
L["ANTI_FEAR_BUFF_PROTECT"]		= "Божественная защита"
L["ANTI_FEAR_BUFF_SHIELD"]		= "Божественный щит"
L["ANTI_FEAR_BUFF_TREMOR"]		= "Тотем трепета"
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
