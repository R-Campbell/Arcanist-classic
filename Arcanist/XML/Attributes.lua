--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as being the array containing all the existing frames
local _G = getfenv(0)
local L = LibStub("AceLocale-3.0"):GetLocale(ARCANIST_ID, true)

------------------------------------------------------------------------------------------------------
-- DEFINITION OF INITIAL MENU ATTRIBUTES
------------------------------------------------------------------------------------------------------

-- We create secure menus for the different buff / port / etc spells
function Arcanist:MenuAttribute(menu)
	if InCombatLockdown() then
		return
	end

	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("MenuAttribute"
		.." m'"..(tostring(menu) or "null")..'"'
		)
	end

	local menuButton = _G[menu]

	if not menuButton:GetAttribute("state") then
		menuButton:SetAttribute("state", "closed")
	end

	if not menuButton:GetAttribute("lastClick") then
		menuButton:SetAttribute("lastClick", "LeftButton")
	end

	if not menuButton:GetAttribute("close") then
		menuButton:SetAttribute("close", 0)
	end

	-- run at OnLoad of button
	menuButton:Execute([[
		ButtonList = table.new(self:GetChildren())
		if self:GetAttribute("state") == "blocked" then
			for i, button in ipairs(ButtonList) do
				button:Show()
			end
		else
			for i, button in ipairs(ButtonList) do
				button:Hide()
			end
		end
	]])

	menuButton:SetAttribute("_onclick", [[
		self:SetAttribute("lastClick", button)
		local State = self:GetAttribute("state")
		if  State == "closed" then
			if button == "RightButton" then
				self:SetAttribute("state", "rightClick")
			else
				self:SetAttribute("state", "open")
			end
		elseif State == "open" then
			if button == "RightButton" then
				self:SetAttribute("state", "rightClick")
			else
				self:SetAttribute("state", "closed")
			end
		elseif State == "combat" then
			for i, button in ipairs(ButtonList) do
				if button:IsShown() then
					--button:Hide()
				else
					--button:Show()
				end
			end
		elseif State == "rightClick" and button == "LeftButton" then
			self:SetAttribute("state", "closed")
		end
	]])

	menuButton:SetAttribute("_onattributechanged", [[
		if name == "state" then
			if value == "closed" then
				for i, button in ipairs(ButtonList) do
					button:Hide()
				end
			elseif value == "open" then
				for i, button in ipairs(ButtonList) do
					button:Show()
				end

				self:SetAttribute("close", self:GetAttribute("close") + 1)
				-- control:SetTimer(6, self:GetAttribute("close"))
			elseif value == "combat" or value == "blocked" then
				for i, button in ipairs(ButtonList) do
					button:Show()
				end
			elseif value == "Refresh" then
				self:SetAttribute("state", "open")
			elseif value == "rightClick" then
				for i, button in ipairs(ButtonList) do
					button:Show()
				end
			end
		end
	]])

	menuButton:SetAttribute("_ontimer", [[
		if self:GetAttribute("close") <= message and not self:GetAttribute("mousehere") then
			self:SetAttribute("state", "closed")
		end
	]])
end

------------------------------------------------------------------------------------------------------
-- INITIAL DEFINITION OF SPELL ATTRIBUTES
------------------------------------------------------------------------------------------------------

-- We associate buffs with the click on the button
function Arcanist:SetBuffSpellAttribute(button)
	if InCombatLockdown() then
		return
	end

	local f = _G[button]
	if f then
		if Arcanist.Debug.buttons then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("SetBuffSpellAttribute"
			.." f'"..tostring(button).."'"
			.." h'"..tostring(f.high_of).."'"
			.." c'"..tostring(Arcanist.GetSpellCastName(f.high_of) or "null").."'"
			)
		end

		f:SetAttribute("type", "spell")
		f:SetAttribute("spell", Arcanist.GetSpellCastName(f.high_of))

		if f.can_target then
			f:SetAttribute("unit", "target")
		end
	end
end

-- We associate buffs with the click on the button
function Arcanist:BuffSpellAttribute()
	if InCombatLockdown() then
		return
	end

	for index = 1, #Arcanist.Mage_Lists.buffs, 1 do
		local v = Arcanist.Mage_Lists.buffs[index]
		local f = Arcanist.Mage_Buttons[v.f_ptr].f
		if Arcanist.Debug.buttons then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("BuffSpellAttribute"
			.." f'"..tostring(f).."'"
			.." v'"..tostring(v).."'"
			.." p'"..tostring(v.f_ptr).."'"
			.." h'"..tostring(v.high_of).."'"
			.." k'"..tostring(Arcanist.IsSpellKnown(v.high_of) or "null").."'"
			)
		end
		if Arcanist.IsSpellKnown(v.high_of) then
			Arcanist:SetBuffSpellAttribute(f)
		end
	end
end

-- Port Spell Attributes
function Arcanist:SetPortSpellAttribute(button)
	if InCombatLockdown() then
		return
	end

	local f = _G[button]
	if f then
		if Arcanist.Debug.buttons then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("SetPortSpellAttribute"
			.." f'"..tostring(button).."'"
			.." h'"..tostring(f.high_of).."'"
			.." c'"..tostring(Arcanist.GetSpellCastName(f.high_of) or "null").."'"
			)
		end

		f:SetAttribute("type", "spell")
		f:SetAttribute("spell", Arcanist.GetSpellCastName(f.high_of))
	end
end

function Arcanist:PortSpellAttribute()
	if InCombatLockdown() then
		return
	end

	for index = 1, #Arcanist.Mage_Lists.ports, 1 do
		local v = Arcanist.Mage_Lists.ports[index]
		local f = Arcanist.Mage_Buttons[v.f_ptr].f
		if Arcanist.IsSpellKnown(v.high_of) then
			Arcanist:SetPortSpellAttribute(f)
		end
	end
end

-- Mana Gem Attributes
function Arcanist:SetManaSpellAttribute(button)
	if InCombatLockdown() then
		return
	end

	local f = _G[button]
	if f then
		if Arcanist.Debug.buttons then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("SetManaSpellAttribute"
			.." f'"..tostring(button).."'"
			.." h'"..tostring(f.high_of).."'"
			.." c'"..tostring(Arcanist.GetSpellCastName(f.high_of) or "null").."'"
			)
		end

		f:SetAttribute("type2", "spell")
		f:SetAttribute("spell*", Arcanist.GetSpellCastName(f.high_of))

		f:SetAttribute("type1", "item")
		f:SetAttribute("item1", ArcanistConfig.ItemLocation[f.high_of])
	end
end

function Arcanist:ManaSpellAttribute()
	if InCombatLockdown() then
		return
	end

	for index = 1, #Arcanist.Mage_Lists.mana_gems, 1 do
		local v = Arcanist.Mage_Lists.mana_gems[index]
		local f = Arcanist.Mage_Buttons[v.f_ptr].f
		if Arcanist.IsSpellKnown(v.high_of) then
			Arcanist:SetManaSpellAttribute(f)
		end
	end
end

-- Associating the frames to buttons, and creating stones on right-click.
function Arcanist:StoneAttribute()
	if InCombatLockdown() then
		return
	end

	local f = Arcanist.Mage_Buttons.timer.f
	f = _G[f]
	if f then
		-- hearthstone
		f:SetAttribute("unit1", "target")
		f:SetAttribute("type1", "macro")
		f:SetAttribute("macrotext", "/focus")
		f:SetAttribute("type2", "item")
		f:SetAttribute("item", self.Translation.Item.Hearthstone)
	end
---[[
	local f = Arcanist.Mage_Buttons.hearthstone.f
	f = _G[f]
	if f then
		f:SetAttribute("unit1", "target")
		f:SetAttribute("type1", "macro")
		f:SetAttribute("macrotext", "/focus")
		f:SetAttribute("type2", "item")
		f:SetAttribute("item", self.Translation.Item.Hearthstone)
	end
--]]
end

-- Connection Association to the central button if the spell is available
function Arcanist:MainButtonAttribute()
	local f = Arcanist.Mage_Buttons.main.f
	f = _G[f]
	if not f then return end

	-- Left click casts the main spell
	if ArcanistConfig.MainSpell == "showhide" then
		f:SetAttribute("type1", "togglebuttons")
		f:SetAttribute("_togglebuttons", function(self, unit, button, actionType)
			ArcanistConfig.HideAllButtons = not ArcanistConfig.HideAllButtons
			Arcanist:ButtonSetup()
		end)
	else
		local main_cast = Arcanist.GetSpellCastName(ArcanistConfig.MainSpell)

		if main_cast ~= "" then
			f:SetAttribute("type1", "spell")
			f:SetAttribute("spell", main_cast)
		end
	end

	-- Right click opens the Options menu
	f:SetAttribute("type2", "Open")
	f.Open = function()
		if not InCombatLockdown() then
			Arcanist:OpenConfigPanel()
		end
	end
end


------------------------------------------------------------------------------------------------------
-- DEFINITION OF SPELL ATTRIBUTES ACCORDING TO COMBAT / REGEN
------------------------------------------------------------------------------------------------------

function Arcanist:NoCombatAttribute(Buff, Ports, Mana)
	-- If we want the menu to automatically engage in combat
	-- And disengages at the end

	if ArcanistConfig.AutomaticMenu and not ArcanistConfig.BlockedMenu then
		-- buffs
		local f = _G[Arcanist.Mage_Buttons.buffs.f]
		if f then
			if f:GetAttribute("lastClick") == "RightButton" then
				f:SetAttribute("state", "rightClick")
			else
				f:SetAttribute("state", "closed")
			end
			if ArcanistConfig.ClosingMenu then
				for i = 1, #Buff, 1 do
					f:WrapScript(Buff[i], "OnClick", [[
						if self:GetParent():GetAttribute("state") == "open" then
							self:GetParent():SetAttribute("state", "closed")
						end
					]])
				end
			end
		end

		-- ports
		local f = _G[Arcanist.Mage_Buttons.ports.f]
		if f then
			if f:GetAttribute("lastClick") == "RightButton" then
				f:SetAttribute("state", "rightClick")
			else
				f:SetAttribute("state", "closed")
			end
			if ArcanistConfig.ClosingMenu then
				for i = 1, #Ports, 1 do
					f:WrapScript(Ports[i], "OnClick", [[
						if self:GetParent():GetAttribute("state") == "open" then
							self:GetParent():SetAttribute("state", "closed")
						end
					]])
				end
			end
		end

		-- mana
		local f = _G[Arcanist.Mage_Buttons.mana.f]
		if f then
			if f:GetAttribute("lastClick") == "RightButton" then
				f:SetAttribute("state", "rightClick")
			else
				f:SetAttribute("state", "closed")
			end
			if ArcanistConfig.ClosingMenu then
				for i = 1, #Mana, 1 do
					f:WrapScript(Mana[i], "OnClick", [[
						if self:GetParent():GetAttribute("state") == "open" then
							self:GetParent():SetAttribute("state", "closed")
						end
					]])
				end
			end
		end
	end
end

function Arcanist:InCombatAttribute(Buff, Ports, Mana)
	-- If we want the menu to automatically engage in combat
	if ArcanistConfig.AutomaticMenu and not ArcanistConfig.BlockedMenu then
		-- buffs
		local f = Arcanist.Mage_Buttons.buffs.f
		f = _G[f]
		if f and ArcanistConfig.Buttons.Buff then
			f:SetAttribute("state", "combat")
			if ArcanistConfig.ClosingMenu then
				for i = 1, #Buff, 1 do
					f:UnwrapScript(Buff[i], "OnClick")
				end
			end
		end

		-- ports
		local f = Arcanist.Mage_Buttons.ports.f
		f = _G[f]
		if f and ArcanistConfig.Buttons.Port then
			f:SetAttribute("state", "combat")
			if ArcanistConfig.ClosingMenu then
				for i = 1, #Ports, 1 do
					f:UnwrapScript(Ports[i], "OnClick")
				end
			end
		end

		-- mana
		local f = Arcanist.Mage_Buttons.mana.f
		f = _G[f]
		if f and ArcanistConfig.Buttons.Mana then
			f:SetAttribute("state", "combat")
			if ArcanistConfig.ClosingMenu then
				for i = 1, #Mana, 1 do
					f:UnwrapScript(Mana[i], "OnClick")
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Situational definition of spell attributes
------------------------------------------------------------------------------------------------------

function Arcanist:ConjureFoodUpdateAttribute()
	local f = Arcanist.Mage_Buttons.conjure_food.f
	f = _G[f]

	if not f then
		return
	end

	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("ConjureFoodUpdateAttribute"
		.." s'"..(ArcanistConfig.ItemLocation["food"] or "null")..'"'
		)
	end

	f:SetAttribute("type2", "spell")
	f:SetAttribute("spell*", Arcanist.GetSpellCastName("conjure_food"))

	f:SetAttribute("type1", "item")
	f:SetAttribute("item1", ArcanistConfig.ItemLocation["food"])
end

function Arcanist:ConjureWaterUpdateAttribute()
	local f = Arcanist.Mage_Buttons.conjure_water.f
	f = _G[f]

	if not f then
		return
	end

	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("ConjureWaterUpdateAttribute"
		.." s'"..(ArcanistConfig.ItemLocation["water"] or "null")..'"'
		)
	end

	f:SetAttribute("type2", "spell")
	f:SetAttribute("spell*", Arcanist.GetSpellCastName("conjure_water"))

	f:SetAttribute("type1", "item")
	f:SetAttribute("item1", ArcanistConfig.ItemLocation["water"])
end

function Arcanist:MountUpdateAttribute()
	local f = Arcanist.Mage_Buttons.mount.f
	f = _G[f]

	if not f then
		return
	end

	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("MountUpdateAttribute"
		.." IL'"..(ArcanistConfig.ItemLocation["mount"] or "null")..'"'
		)
	end

	f:SetAttribute("type", "item")
	f:SetAttribute("item", ArcanistConfig.ItemLocation["mount"])
end

function Arcanist:PortUpdateAttribute()
	for i, v in ipairs(Arcanist.Mage_Lists.ports) do
		local b = Arcanist.Mage_Buttons[v.f_ptr]
		local f = _G[b.f]
		local spell = Arcanist.GetSpell(v.high_of)

		if not f then return end
		if Arcanist.Debug.buttons then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("PortUpdateAttribute"
				.." b'"..(b or "null")..'"'
				.." f'"..(f or "null")..'"'
				.." spell'"..(spell or "null")..'"'
			)
		end

		if spell and f then
			if spell.reagent then
				if Arcanist.Mage_Lists.reagents[spell.reagent].count <= 0 then
					SetSat(f, 1)
				end
			end
		end
	end
end

--[[ https://wowwiki.fandom.com/wiki/SecureActionButtonTemplate
"type"					Any clicks.
"*type1"				Any left click.
"*type2"				Any right click.
"type1"					Unmodified left click.
"type2"					Unmodified right click.
"shift-type2"			Shift+right click. (But not Alt+Shift+right click)
"shift-type*"			Shift+any button click.
"alt-ctrl-shift-type*"	Alt+Control+Shift+any button click.
"ctrl-alt-shift-type*"	Invalid, as modifiers are in the wrong order.
===
For example, suppose we wanted to create a button that would alter behavior based on whether you can attack your target.
Setting the following attributes has the desired effect:
"unit"				"target"				Make all actions target the player's target.
"*harmbutton1"		"nuke1"					Remap any left clicks to "nuke1" clicks when target is hostile.
"*harmbutton2"		"nuke2"					Remap any right clicks to "nuke2" clicks when target is hostile.
"helpbutton1"		"heal1"					Remap unmodified left clicks to "heal1" clicks when target is friendly.
"type"				"spell"					Make all clicks cast a spell.
"spell-nuke1"		"Mind Flay"				Cast Mind Flay on "hostile" left click.
"spell-nuke2"		"Shadow Word: Death"	Cast Shadow Word: Death on "hostile" right click.
"alt-spell-nuke2"	"Mind Blast"			Cast Mind Blast on "hostile" alt-right click.
"spell-heal1"		"Flash Heal"			Cast Flash Heal on "friendly" left click.

:::SecureActionButtonTemplate "type" attributes:::
Type			Used attributes		Behavior
"actionbar"		"action"			Switches the current action bar depending on the value of the "action" attribute:
									A number: switches to a the bar specified by the number.
									"increment" or "decrement": move one bar up/down.
									"a, b", where a, and b are numeric, switches between bars a and b.
"action"		"unit", "action"
				["actionpage"]		Performs an action specified by the "action" attribute (a number).
									If the button:GetID() > 0, paging behavior is supported;
									see the ActionButton_CalculateAction FrameXML function.
"pet"			"unit", "action"	Calls CastPetAction(action, unit);
"spell"			"unit", "spell"		Calls CastSpellByName(spell, unit);
"item"			"unit"
				"item" OR
				["bag", "slot"]		Equips or uses the specified item, as resolved by SecureCmdItemParse.
									"item" attribute value may be a macro conditioned string, item name, or "bag slot" string (i.e. "1 3").
									If "item" is nil, the "bag" and "slot" attributes are used; those are deprecated -- use a "bag slot" item string.
"macro"			"macro" OR
				"macrotext"			If "macro" attribute is specified, calls RunMacro(macro, button); otherwise, RunMacroText(macrotext, button);
"cancelaura"	"unit"
				"index" OR
				"spell"[, "rank"]	Calls either CancelUnitBuff(unit, index) or CancelUnitBuff(unit, spell, rank). The first version
									Note: the value of the "index" attribute must resolve to nil/false for the "spell", "rank" attributes to be considered.

"stop"	 							Calls SpellStopTargeting().
"target"		"unit"				Changes target, targets a unit for a spell, or trades unit an item on the cursor.
									If "unit" attribute value is "none", your target is cleared.
"focus"			"unit"				Calls FocusUnit(unit).
"assist"		"unit"				Calls AssistUnit(unit).
"mainassist"	"action", "unit"	Performs a main assist status on the unit based on the value of the "action" attribute:
									nil or "set": the unit is assigned main assist status. (SetPartyAssignment)
									"clear": the unit is stripped main assist status. (ClearPartyAssignment)
									"toggle": the main assist status of the unit is inverted.
"maintank"		"action", "unit"	As "mainassist", but for main tank status.
"click"			"clickbutton"		Calls clickbutton:Click(button)
"attribute"		["attribute-frame",]
				"attribute-name"
				"attribute-value"	Calls frame:SetAttribute(attributeName, attributeValue).
									If "attribute-frame" is not specified, the button itself is assumed.
									Any other value	"_type"	Action depends on the value of the modified ("_" .. type) attribute, or rawget(button, type), in that order.
									If the value is a function, it is called with (self, unit, button, actionType) arguments
									If the value is a string, a restricted snippet stored in the attribute specified by the value on the button is executed as if it was OnClick.
--]]
