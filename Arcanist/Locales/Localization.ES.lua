--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

local L = LibStub("AceLocale-3.0"):NewLocale(ARCANIST_ID,"esES")
if not L then return end

L["ARCANIST"] = "Arcanist";
L["ARCANIST_ONLY"] = "Arcanist";
L["ARCANIST_DEBUG"] = "<Arcanist>";
L["ARCANIST_PRINT"] = "Arcanist";

-- Configuration
L["HEALTHSTONE_COOLDOWN"] = "Tiempo de regeneraci\195\179n Piedra de Salud"
L["USE"] = "Use"
L["TRADE"] = "Trade"
L["ARCANIST_LABEL"] = "|c00FFFFFF".."Arcanist".."|r"
L["YES"] = "S\195\173"
L["NO"] = "No"
L["ON"] = "Activar"
L["OFF"] = "Desactivar"
--
L["SOUL_SHARD"] = "Fragmento de Alma"
L["SOUL_SHARD_LABEL"] = "Fragmento(s) de Alma: "
L["INFERNAL_STONE"] = "Piedra infernal"
L["INFERNAL_STONE_LABEL"] = "Piedra(s) Infernal(es): "
L["DEMONIAC_STONE"] = "Figura demon\195\173aca"
L["DEMONIAC_STONE_LABEL"] = "Figura(s) Demon\195\173aca(s): "
L["SOUL_STONE"] = "Piedra de alma"
L["SOUL_STONE_LABEL"] = "\nPiedra de Alma: "
L["HEALTH_STONE"] = "Piedra de salud"
L["HEALTH_STONE_LABEL"] = "Piedra de Salud: "
L["SPELL_STONE"] = "Piedra de hechizo"
L["SPELL_STONE_LABEL"] = "Piedra de Hechizo: "
L["FIRE_STONE"] = "Piedra de fuego"
L["FIRE_STONE_LABEL"] = "Piedra de Fuego: "
L["CURRENT_DEMON"] = "Demonio: "
L["ENSLAVED_DEMON"] = "Demonio: Esclavizado"
L["NO_CURRENT_DEMON"] = "Demonio: Ninguno"
L["HEARTHSTONE"] = "Piedra de hogar"
--
L["SOULSTONE_TEXT_1"] = "Click derecho para crear"
L["SOULSTONE_TEXT_2"] = "Click izquierdo para usar"
L["SOULSTONE_TEXT_3"] = "Usada\nClick derecho para recrear"
L["SOULSTONE_TEXT_4"] = "Esperando"
L["SOULSTONE_RITUAL"] = "|c00FFFFFF".."Shift+Click para empezar Ritual de invocaci\195\179n".."|r"
L["HEALTHSTONE_TEXT_1_1"] = "Click derecho para crear"
L["HEALTHSTONE_TEXT_1_2"] = "Click izquierdo para usar"
L["HEALTHSTONE_TEXT_2"] = "Middle click or Ctrl+left click to trade"
L["HEALTHSTONE_RITUAL"] = "|c00FFFFFF".."Shift+Click para empezar el Ritual de Almas".."|r"
L["SPELLSTONE_TEXT_1"] = "Click derecho para crear"
L["SPELLSTONE_TEXT_2"] = "En el inventario\nClick izquierdo para usar"
L["SPELLSTONE_TEXT_3"] = "Usada"
L["SPELLSTONE_TEXT_4"] = "Usada\nClick derecho para crear"
L["FIRESTONE_TEXT_1"] = "Click derecho para crear"
L["FIRESTONE_TEXT_2"] = "En el inventario\nClick izquierdo para usar"
L["FIRESTONE_TEXT_3"] = "Usada"
L["FIRESTONE_TEXT_4"] = "Usada\nClick derecho para crear"
L["SPELLTIMER_LABEL"] = "|c00FFFFFF".."Duraci\195\179n de Hechizos".."|r"
L["SPELLTIMER_TEXT"] = "Hechizos activos en el objetivo"
L["SPELLTIMER_RIGHT"] = "Click derecho para usar Piedra de Hogar a "
L["SHADOW_TRANCE_LABEL"] = "|c00FFFFFF".."Trance de las Sombra".."|r"
L["BACKLASH_LABEL"] = "|c00FFFFFF".."Latigazo".."|r"
L["BANISH_TEXT"] = "Click derecho para invocar Rango 1"
-- Pets
L["IMP_LABEL"] = "|c00FFFFFF".."Diablillo".."|r"
L["IMP"] = "Diablillo"
L["VOIDWALKER_LABEL"] = "|c00FFFFFF".."Abisario".."|r"
L["VOIDWALKER"] = "Abisario"
L["SUCCUBUS_LABEL"] = "|c00FFFFFF".."S\195\186cubo".."|r"
L["SUCCUBUS"] = "S\195\186cubo"
L["FELHUNTER_LABEL"] = "|c00FFFFFF".."Man\195\161fago".."|r"
L["FELHUNTER"] = "Man\195\161fago"
L["FELGUARD_LABEL"] = "|c00FFFFFF".."Guardia maldito".."|r"
L["FELGUARD"] = "Guardia maldito"
L["INFERNAL_LABEL"] = "|c00FFFFFF".."Inferno".."|r"
L["INFERNAL"] = "Inferno"
L["DOOMGUARD_LABEL"] = "|c00FFFFFF".."Guardia Apocal\195\173ptico".."|r"
L["DOOMGUARD"] = "Guardia apocal\195\173ptico"
--
L["MOUNT_LABEL"] = "|c00FFFFFF".."Corcel".."|r"
L["MOUNT_TEXT"] = "Left click to summon Dreadsteed\nRight click to summon Felsteed"
L["BUFF_MENU_LABEL"] = "|c00FFFFFF".."Men\195\186 de Hechizos".."|r"
L["BUFF_MENU_TEXT_1"] = "Click Derecho para mantener el men\195\186 abierto"
L["BUFF_MENU_TEXT_2"] = "Modo autom\195\161tico: Se cierra cuando sales de combate"
L["PET_MENU_LABEL"] = "|c00FFFFFF".."Men\195\186 de Demonio".."|r"
L["PET_MENU_TEXT_1"] = "Click Derecho para mantener el men\195\186 abierto"
L["PET_MENU_TEXT_2"] = "Modo autom\195\161tico: Se cierra cuando sales de combate"
L["CURSE_MENU_LABEL"] = "|c00FFFFFF".."Men\195\186 de Maldici\195\179n".."|r"
L["CURSE_MENU_TEXT_1"] = "Click Derecho para mantener el men\195\186 abierto"
L["CURSE_MENU_TEXT_2"] = "Modo autom\195\161tico: Se cierra cuando sales de combate"
L["DOMINATION_COOLDOWN"] = "Click Derecho para invocaci\195\179n r\195\161pida"
--
L["SOUND_FEAR"] = "Interface\\AddOns\\Arcanist\\sounds\\Fear-En.mp3"
L["SOUND_SOUL_STONE_END"] = "Interface\\AddOns\\Arcanist\\sounds\\SoulstoneEnd-En.mp3"
L["SOUND_ENSLAVE_END"] = "Interface\\AddOns\\Arcanist\\sounds\\EnslaveDemonEnd-En.mp3"
L["SOUND_SHADOW_TRANCE"] = "Interface\\AddOns\\Arcanist\\sounds\\ShadowTrance-En.mp3"
L["SOUND_BACKLASH"] = "Interface\\AddOns\\Arcanist\\sounds\\Backlash-Fr.mp3"
--
L["PROC_SHADOW_TRANCE"] = "<white>Tr<lightPurple1>a<lightPurple2>n<purple>c<darkPurple1>e<darkPurple2> de las S<darkPurple1>o<purple>m<lightPurple2>b<lightPurple1>r<white>as"
L["PROC_BACKLASH"] = "<white>B<lightPurple1>a<lightPurple2>c<purple>k<darkPurple1>l<darkPurple2>a<darkPurple1>s<purple>h"

L["BAG_FULL_PREFIX"] = "\194\161 Tu "
L["BAG_FULL_SUFFIX"] = " est\195\161 llena !"
L["BAG_FULL_DESTROY_PREFIX"] = " est\195\161 llena; \194\161 Los pr\195\179ximos Fragmentos de Alma ser\195\161n destruidos !"
L["INTERFACE_WELCOME"] = "<white>\194\161 /arcanist para mostrar el men\195\186 de preferencias !"
L["INTERFACE_TOOLTIP_ON"] = "Consejos detallados activados"
L["INTERFACE_TOOLTIP_OFF"] = "Consejos detallados desactivados"
L["INTERFACE_MESSAGE_ON"] = "Mensaje Chat activado"
L["INTERFACE_MESSAGE_OFF"] = "Mensaje Chat desactivado"
L["INTERFACE_DEFAULT_CONFIG"] = "<lightYellow>Configuraci\195\179n por defecto cargada."
L["INTERFACE_USER_CONFIG"] = "<lightYellow>Configuraci\195\179n cargada."
L["HELP_1"] = "/arcanist <lightOrange>recall<white> -- <lightBlue>Centrar Arcanist y todos los botones en el medio de la pantalla"
L["HELP_2"] = "/arcanist <lightOrange>reset<white> -- <lightBlue>Reinicia Arcanist entero"
L["INFO_FEAR_PROTECT"] = "\194\161\194\161\194\161 Tu objetivo tiene una protecci\195\179n contra miedo !!!"
L["INFO_ENSLAVE_BREAK"] = "Tu demonio rompi\195\179 sus cadenas..."
L["INFO_SOUL_STONE_END"] = "<lightYellow>Tu Piedra de Alma se ha disipado."
--
L["CONFIG_MESSAGE"] = "Opci\195\179nes de Mensaje"
L["CONFIG_SPHERE"] = "Opci\195\179nes de la Esfera"
L["CONFIG_BUTTON"] = "Opci\195\179nes de Bot\195\179n"
L["CONFIG_MENU"] = "Opci\195\179nes de Men\195\186s"
L["CONFIG_TIMER"] = "Opci\195\179nes de Temporizador"
L["CONFIG_MISC"] = "Miscel\195\161neos"
--
L["MSG_POSITION"] = "<- Los mensajes de Sistema de Arcanist aparecer\195\161n aqu\195\173 ->"
L["MSG_SHOW_TIPS"] = "Mostrar consejos detallados"
L["MSG_SHOW_SYS"] = "Mensajes de Arcanist como mensajes de sistema"
L["MSG_RANDOM"] = "Activar discursos aleatorios"
L["MSG_USE_SHORT"] = "Usar mensajes cortos"
L["MSG_RANDOM_DEMON"] = "Activar discursos aleatorios (demonio)"
L["MSG_RANDOM_STEED"] = "Activar discursos aleatorios (corcel)"
L["MSG_RANDOM_SOULS"] = "Activar discursos aleatorios para el Ritual de las Almas"
L["MSG_SOUNDS"] = "Activar sonidos"
L["MSG_WARN_FEAR"] = "Av\195\173same cuando mi objetivo no pueda ser asustado"
L["MSG_WARN_BANISH"] = "Av\195\173same cuando mi objetivo pueda ser desterrado o esclavizado"
L["MSG_WARN_TRANCE"] = "Al\195\169rtame cuando entre en un Trance"
--
L["SPHERE_SIZE"] = "Tama\195\177o del bot\195\179n Arcanist"
L["SPHERE_SKIN"] = "Color de la Esfera Arcanist"
L["SPHERE_EVENT"] = "Evento mostrado en la Esfera"
L["SPHERE_SPELL"] = "Hechizo lanzado desde la Esfera"
L["SPHERE_COUNTER"] = "Mostrar la contabilizaci\195\179n de Fragmentos en Arcanist"
L["SPHERE_STONE"] = "Tipo de Piedra contabilizada"
--	Color
L["PINK"] = "Rosa"
L["BLUE"] = "Azul"
L["ORANGE"] = "Naranja"
L["TURQUOISE"] = "Turquesa"
L["PURPLE"] = "P\195\186rpura"
-- Count
L["SOUL_SHARDS"] = "Fragmentos de Alma"
L["DEMON_SUMMON_STONES"] = "Piedras de invocaci\195\179n de Demonios"
L["REZ_TIMER"] = "Temporizador de Resurrecci\195\179n"
L["MANA"] = "Man\195\161"
L["HEALTH"] = "Salud"
-- Buttons
L["BUTTONS_ROTATION"] = "Rotaci\195\179n de los botones"
L["BUTTONS_STICK"] = "Fijar los botones alrededor de la Esfera"
L["BUTTONS_MOUNT"] = "Use my own mounts"
L["BUTTONS_SELECTION"] = "Selection of buttons to be shown"
L["BUTTONS_LEFT"] = "Left click"
L["BUTTONS_RIGHT"] = "Right click"
--
L["SHOW_FIRE_STONE"] = "Mostrar bot\195\179n Piedra de Fuego"
L["SHOW_SPELL_STONE"] = "Mostrar bot\195\179n Piedra de Hechizo"
L["SHOW_HEALTH_STONE"] = "Mostrar bot\195\179n Piedra de Salud"
L["SHOW_SOUL_STONE"] = "Mostrar bot\195\179n Piedra de Alma"
L["SHOW_SPELL"] = "Mostrar bot\195\179n del men\195\186 Hechizos"
L["SHOW_STEED"] = "Mostrar bot\195\179n Corcel"
L["SHOW_DEMON"] = "Mostrar bot\195\179n del men\195\186 Demonio"
L["SHOW_CURSE"] = "Mostrar bot\195\179n del men\195\186 Maldici\195\179n"
--
L["MENU_GENERAL"] = "Opciones Generales"
L["MENU_SPELLS"] = "Men\195\186 de Hechizos"
L["MENU_DEMONS"] = "Men\195\186 de Demonios"
L["MENU_CURSES"] = "Men\195\186 de Maldiciones"
L["MENU_ALWAYS"] = "Mostrar los men\195\186s siempre"
L["MENU_AUTO_COMBAT"] = "Abrir autom\195\161ticamente los men\195\186s mientras est\195\169s en combate"
L["MENU_CLOSE_CLICK"] = "Cerrar el men\195\186 cuando pulses uno de sus botones"
L["MENU_ORIENTATION"] = "Orientaci\195\179n de men\195\186s"
L["MENU_VERT"] = "Cambiar la simetr\195\173a vertical de los botones"
L["MENU_BANISH"] = "Tama\195\177o del bot\195\179n Desterrar"
--
L["HORIZONTAL"] = "Horizontal"
L["UPWARDS"] = "Hacia arriba"
L["DOWNWARDS"] = "Hacia abajo"
--
L["TIMER_TYPE"] = "Tipo de temporizadores"
L["TIMER_SPELL"] = "Mostrar el bot\195\179n de los temporizadores"
L["TIMER_LEFT"] = "Mostrar los temporizadores a la izquierda del bot\195\179n"
L["TIMER_UP"] = "Los temporizadores se incrementan ascendentemente"
--
L["NO_TIMER"] = "Ninguno"
L["GRAPHICAL"] = "Modo Gr\195\161fico"
L["TEXTUAL"] = "Modo texto"
--
L["MISC_SHARDS_BAG"] = "Poner los Fragmentos en la bolsa seleccionada."
L["MISC_SHARDS_DESTROY"] = "Destruir nuevos fragmentos si la bolsa est\195\161 llena."
L["MISC_BAG"] = "Selecci\195\179n de Contenedor de Fragmentos de Alma"
L["MISC_SHARDS_MAX"] = "N\195\186mero m\195\161ximo de fragmentos a guardar"
L["MISC_LOCK"] = "Bloquear Arcanist"
L["MISC_HIDDEN"] = "Perm\195\173teme ver los botones ocultos para arrastrarlos"
L["MISC_HIDDEN_SIZE"] = "Tama\195\177o de los botones de aviso"
-- Functions
L["UNDEAD"] = "No-muerto"
L["DEMON"] = "Demon"
L["ELEMENTAL"] = "Elemental"
--
L["BACKLASH"] = "Contragolpe"
L["SHADOW_TRANCE"] = "Trance de las Sombras"
--
L["BAG_SOUL_POUCH"] = "Faltriquera de almas"
L["BAG_SMALL_SOUL_POUCH"] = "Faltriquera de almas"
L["BAG_BOX_OF_SOULS"] = "Caja de almas"
L["BAG_FELCLOTH_BAG"] = "Bolsa de tela vil"
L["BAG_EBON_SHADOW_BAG"] = "Bolsa de tela vil del N\195\186cleo"
L["BAG_CORE_FELCLOTH_BAG"] = "Bolsa abisal"
L["BAG_ABYSSAL_BAG"] = "Bolsa de las Sombras de \195\169bano"
--
L["MINOR"] = "Minor"
L["MAJOR"] = "Major"
L["LESSER"] = "Lesser"
L["GREATER"] = "Greater"
--
L["COOLDOWN"] = "Tiempo de reutilizaci\195\179n restante"
L["RANK"] = "Rango"
L["CREATE"] = "Crear"
--
L["ANTI_FEAR_BUFF_FEAR_WARD"]	= "Custodia de miedo"
L["ANTI_FEAR_BUFF_FORSAKEN"]	= "Voluntad de los Renegados"
L["ANTI_FEAR_BUFF_FEARLESS"]	= "Audacia"
L["ANTI_FEAR_BUFF_BERSERK"]		= "Ira rabiosa"
L["ANTI_FEAR_BUFF_RECKLESS"]	= "Temeridad"
L["ANTI_FEAR_BUFF_WISH"]		= "Deseo de la muerte"
L["ANTI_FEAR_BUFF_WRATH"]		= "C\195\179lera de las bestias"
L["ANTI_FEAR_BUFF_ICE"]			= "Bloqueo de hielo"
L["ANTI_FEAR_BUFF_PROTECT"]		= "Protecci\195\179n divina"
L["ANTI_FEAR_BUFF_SHIELD"]		= "Escudo divino"
L["ANTI_FEAR_BUFF_TREMOR"]		= "T\195\179tem de tremor"
L["ANTI_FEAR_BUFF_ABOLISH"]		= "Suprimir magia"
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
