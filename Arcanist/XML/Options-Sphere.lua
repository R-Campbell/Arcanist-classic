--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as being the array containing all the existing frames.
local _G = getfenv(0)


------------------------------------------------------------------------------------------------------
-- CREATION OF THE OPTIONS FRAME
------------------------------------------------------------------------------------------------------

-- We create or display the sphere's configuration panel
function Arcanist:SetSphereConfig()
	local frame = _G["ArcanistSphereConfig"]
	if not frame then
		-- Window creation
		frame = CreateFrame("Frame", "ArcanistSphereConfig", ArcanistGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Creation of the Arcanist scale slider
		frame = CreateFrame("Slider", "ArcanistSphereSize", ArcanistSphereConfig, "OptionsSliderTemplate")
		frame:SetMinMaxValues(50, 200)
		frame:SetValueStep(5)
		frame:SetObeyStepOnDrag(true)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", ArcanistSphereConfig, "BOTTOMLEFT", 225, 400)

		local f = _G[Arcanist.Mage_Buttons.main.f]
		local point, relativeTo, relativePoint, NBx, NBy = f:GetPoint()

		if Arcanist.Debug.frames then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage(
				"SetSphereConfig"
				.." p'"..tostring(point).."'"
				.." rt'"..tostring(relativeTo).."'"
				.." rp'"..tostring(relativePoint).."'"
				.." nbx'"..tostring(NBx).."'"
				.." nby'"..tostring(NBy).."'"
			)
		end
		NBx = NBx * (ArcanistConfig.ArcanistButtonScale / 100) -- undo the scaling
		NBy = NBy * (ArcanistConfig.ArcanistButtonScale / 100)

		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self:GetValue().." %")
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnValueChanged", function(self)
			if not (self:GetValue() == ArcanistConfig.ArcanistButtonScale) then
				GameTooltip:SetText(self:GetValue().." %")
				oldScale = ArcanistConfig.ArcanistButtonScale
				oldNBx = ArcanistConfig.FramePosition["ArcanistButton"][4]
				oldNBy = ArcanistConfig.FramePosition["ArcanistButton"][5]

				newScale = self:GetValue()
				newNBx = oldNBx / (newScale / oldScale)
				newNBy = oldNBy / (newScale / oldScale)

				if Arcanist.Debug.frames then
					_G["DEFAULT_CHAT_FRAME"]:AddMessage(
						"ArcanistSphereSize>>OnValueChanged"
						.." abs'"..tostring(ArcanistConfig.ArcanistButtonScale).."'"
						.." oldNBx'"..tostring(oldNBx).."'"
						.." oldNBy'"..tostring(oldNBy).."'"
						.." newNBx'"..tostring(newNBx).."'"
						.." newNBy'"..tostring(newNBy).."'"
					)
				end

				ArcanistConfig.FramePosition["ArcanistButton"][4] = newNBx
				ArcanistConfig.FramePosition["ArcanistButton"][5] = newNBy
				ArcanistConfig.ArcanistButtonScale = newScale

				f:ClearAllPoints()
				f:SetPoint(
					ArcanistConfig.FramePosition["ArcanistButton"][1],
					ArcanistConfig.FramePosition["ArcanistButton"][2],
					ArcanistConfig.FramePosition["ArcanistButton"][3],
					ArcanistConfig.FramePosition["ArcanistButton"][4],
					ArcanistConfig.FramePosition["ArcanistButton"][5]
				)
				f:SetScale(ArcanistConfig.ArcanistButtonScale / 100)
				Arcanist:ButtonSetup()
			end
		end)

		ArcanistSphereSizeLow:SetText("50 %")
		ArcanistSphereSizeHigh:SetText("200 %")

		-------------------------------------------------
		-- Sphere skin
		frame = CreateFrame("Frame", "ArcanistSkinSelection", ArcanistSphereConfig, "UIDropDownMenuTemplate")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", ArcanistSphereConfig, "BOTTOMRIGHT", 40, 325)

		local FontString = frame:CreateFontString("ArcanistSkinSelectionT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", ArcanistSphereConfig, "BOTTOMLEFT", 35, 328)
		FontString:SetTextColor(1, 1, 1)

		UIDropDownMenu_SetWidth(frame, 125)

		-------------------------------------------------
		-- Event shown by the sphere
		frame = CreateFrame("Frame", "ArcanistEventSelection", ArcanistSphereConfig, "UIDropDownMenuTemplate")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", ArcanistSphereConfig, "BOTTOMRIGHT", 40, 300)

		FontString = frame:CreateFontString("ArcanistEventSelectionT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", ArcanistSphereConfig, "BOTTOMLEFT", 35, 303)
		FontString:SetTextColor(1, 1, 1)

		UIDropDownMenu_SetWidth(frame, 125)

		------------------------------------------------- https://wow.gamepedia.com/Using_UIDropDownMenu
		-- Spell associated with the sphere
		frame = CreateFrame("Frame", "ArcanistSpellSelection", ArcanistSphereConfig, "UIDropDownMenuTemplate")
		if ArcanistConfig.MainSpell == "showhide" then
			UIDropDownMenu_SetText(ArcanistSpellSelection, Arcanist.Config.Sphere["SPHERE_SHOW_HIDE"])
		else
			UIDropDownMenu_SetText(ArcanistSpellSelection, Arcanist.GetSpellName(ArcanistConfig.MainSpell))
		end
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", ArcanistSphereConfig, "BOTTOMRIGHT", 40, 275)

		FontString = frame:CreateFontString("ArcanistSpellSelectionT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", ArcanistSphereConfig, "BOTTOMLEFT", 35, 278)
		FontString:SetTextColor(1, 1, 1)

		UIDropDownMenu_SetWidth(frame, 125)

		-------------------------------------------------
		-- Show or hide the digital counter
		frame = CreateFrame("CheckButton", "ArcanistShowCount", ArcanistSphereConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistSphereConfig, "BOTTOMLEFT", 25, 200)

		frame:SetScript("OnClick", function(self)
			ArcanistConfig.ShowCount = self:GetChecked()
			Arcanist:UpdateHealth()
			Arcanist:UpdateMana()
			Arcanist:BagExplore()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Event shown by the counter
		frame = CreateFrame("Frame", "ArcanistCountSelection", ArcanistSphereConfig, "UIDropDownMenuTemplate")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", ArcanistSphereConfig, "BOTTOMRIGHT", 40, 175)

		FontString = frame:CreateFontString("ArcanistCountSelectionT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", ArcanistSphereConfig, "BOTTOMLEFT", 35, 178)
		FontString:SetTextColor(1, 1, 1)

		UIDropDownMenu_SetWidth(frame, 125)

	end

	UIDropDownMenu_Initialize(ArcanistSkinSelection, Arcanist.Skin_Init)
	UIDropDownMenu_Initialize(ArcanistEventSelection, Arcanist.Event_Init)
	UIDropDownMenu_Initialize(ArcanistSpellSelection, Arcanist.Spell_Init)
	UIDropDownMenu_Initialize(ArcanistCountSelection, Arcanist.Count_Init)

	ArcanistSphereSizeText:SetText(self.Config.Sphere["SPHERE_SIZE"])
	ArcanistSkinSelectionT:SetText(self.Config.Sphere["SPHERE_SKIN"])
	ArcanistEventSelectionT:SetText(self.Config.Sphere["SPHERE_EVENT"])
	ArcanistSpellSelectionT:SetText(self.Config.Sphere["SPHERE_SPELL"])
	ArcanistShowCount:SetText(self.Config.Sphere["SPHERE_COUNTER"])
	ArcanistCountSelectionT:SetText(self.Config.Sphere["SPHERE_STONE"])

	ArcanistSphereSize:SetValue(ArcanistConfig.ArcanistButtonScale)
	ArcanistShowCount:SetChecked(ArcanistConfig.ShowCount)

	local color = {"Pink", "Blue", "Orange", "Turquoise", "Violet"}
	for i in ipairs(color) do
		if color[i] == ArcanistConfig.ArcanistColor then
			UIDropDownMenu_SetSelectedID(ArcanistSkinSelection, i)
			UIDropDownMenu_SetText(ArcanistSkinSelection, self.Config.Sphere.Color[i])
			break
		end
	end

	UIDropDownMenu_SetSelectedID(ArcanistEventSelection, ArcanistConfig.Circle)
	UIDropDownMenu_SetText(ArcanistEventSelection, self.Config.Sphere.Count[ArcanistConfig.Circle])

	UIDropDownMenu_SetSelectedID(ArcanistCountSelection, ArcanistConfig.CountType)
	UIDropDownMenu_SetText(ArcanistCountSelection, self.Config.Sphere.Count[ArcanistConfig.CountType])

	frame:Show()
end


------------------------------------------------------------------------------------------------------
-- FUNCTIONS REQUIRED FOR DROPDOWNS
------------------------------------------------------------------------------------------------------

-- Skin dropdown functions
function Arcanist.Skin_Init()
	local element = {}

	for i in ipairs(Arcanist.Config.Sphere.Color) do
		element.text = Arcanist.Config.Sphere.Color[i]
		element.checked = false
		element.func = Arcanist.Skin_Click
		UIDropDownMenu_AddButton(element)
	end
end

function Arcanist.Skin_Click(self)
	local ID = self:GetID()
	local color = {"Pink", "Blue", "Orange", "Turquoise", "Violet"}
	UIDropDownMenu_SetSelectedID(ArcanistSkinSelection, ID)
	ArcanistConfig.ArcanistColor = color[ID]
	local f = _G[Arcanist.Mage_Buttons.main.f]
	f:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\"..color[ID].."\\Shard16")
end

-- Sphere border dropdown functions
function Arcanist.Event_Init()
	local element = {}
	for i in pairs(Arcanist.Config.Sphere.Count) do
		element.text = Arcanist.Config.Sphere.Count[i]
		element.checked = false
		element.func = Arcanist.Event_Click
		UIDropDownMenu_AddButton(element)
	end
end

function Arcanist.Event_Click(self)
	local ID = self:GetID()

	UIDropDownMenu_SetSelectedID(ArcanistEventSelection, ID)
	ArcanistConfig.Circle = ID
	Arcanist:UpdateHealth()
	Arcanist:UpdateMana()
	Arcanist:BagExplore()
end

-- Spell dropdown functions
function Arcanist.Spell_Init()
	local element = UIDropDownMenu_CreateInfo()
	local selected = ""
	local main_spell = Arcanist.GetMainSpellList()
	local color = ""

	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Spell_Init"
			.." '"..tostring(ArcanistConfig.MainSpell).."'"
		)
	end

	-- Give the ability to toggle buttons with main sphere click
	color = "|CFFFFFFFF"
	element.func = Arcanist.Spell_Click
	spell = color..Arcanist.Config.Sphere["SPHERE_SHOW_HIDE"]
	element.text = spell
	element.arg1 = 1

	if (ArcanistConfig.MainSpell == "showhide") then
		if Arcanist.Debug.buttons then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("Spell_Init"
				.." 'showhide checked'"
				.." spell' "..spell
			)
		end
		element.checked = true
		selected = spell
	else
		element.checked = false
	end
	UIDropDownMenu_AddButton(element)

	for i = 2, #main_spell, 1 do
		if Arcanist.IsSpellKnown(main_spell[i]) then  -- known
			color = "|CFFFFFFFF"
			element.func = Arcanist.Spell_Click
		else
			color = "|CFF808080"
		end
		spell = color..Arcanist.GetSpellName(main_spell[i]).."|r"
		element.text = spell
		element.arg1 = i

		if (ArcanistConfig.MainSpell == main_spell[i]) then
			element.checked = true
			selected = spell
		else
			element.checked = false
		end
		UIDropDownMenu_AddButton(element)
	end
end

function Arcanist.Spell_Click(self, arg1, arg2, checked)
	local main_spell = Arcanist.GetMainSpellList()
	local ID = self:GetID()

	UIDropDownMenu_SetSelectedID(ArcanistSpellSelection, arg1)
	if arg1 == 1 then
		ArcanistConfig.MainSpell = "showhide"
	else
		ArcanistConfig.MainSpell = main_spell[arg1]
	end
	Arcanist.MainButtonAttribute()
end

-- Digital counter dropdown functions
function Arcanist.Count_Init()
	local element = {}
	for i in pairs(Arcanist.Config.Sphere.Count) do
		element.text = Arcanist.Config.Sphere.Count[i]
		element.checked = false
		element.func = Arcanist.Count_Click
		UIDropDownMenu_AddButton(element)
	end
end

function Arcanist.Count_Click(self)
	local ID = self:GetID()
	UIDropDownMenu_SetSelectedID(ArcanistCountSelection, ID)
	ArcanistConfig.CountType = ID
	Arcanist:UpdateHealth()
	Arcanist:UpdateMana()
	Arcanist:BagExplore()
end
