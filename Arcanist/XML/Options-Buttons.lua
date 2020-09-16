--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as being the array containing all the existing frames.
local _G = getfenv(0)

------------------------------------------------------------------------------------------------------
-- CREATING THE FRAME OF THE OPTIONS
------------------------------------------------------------------------------------------------------

--We create or display the configuration panel of the sphere
function Arcanist:SetButtonsConfig()

	local frame = _G["ArcanistButtonsConfig"]
	if not frame then
		-- Window creation
		frame = CreateFrame("Frame", "ArcanistButtonsConfig", ArcanistGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Creating pane 1
		frame = CreateFrame("Frame", "ArcanistButtonsConfig1", ArcanistButtonsConfig)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetAllPoints(ArcanistButtonsConfig)

		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 130)
		FontString:SetText("1 / 2")

		FontString = frame:CreateFontString("ArcanistButtonsConfig1Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 420)

		-- Buttons
		frame = CreateFrame("Button", nil, ArcanistButtonsConfig1, "OptionsButtonTemplate")
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", ArcanistButtonsConfig1, "BOTTOMRIGHT", 40, 135)

		frame:SetScript("OnClick", function()
			ArcanistButtonsConfig2:Show()
			ArcanistButtonsConfig1:Hide()
		end)

		frame = CreateFrame("Button", nil, ArcanistButtonsConfig1, "OptionsButtonTemplate")
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistButtonsConfig1, "BOTTOMLEFT", 40, 135)

		frame:SetScript("OnClick", function()
			ArcanistButtonsConfig2:Show()
			ArcanistButtonsConfig1:Hide()
		end)

		-- Creating pane 2
		frame = CreateFrame("Frame", "ArcanistButtonsConfig2", ArcanistButtonsConfig)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Hide()
		frame:ClearAllPoints()
		frame:SetAllPoints(ArcanistButtonsConfig)

		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 130)
		FontString:SetText("2 / 2")

		FontString = frame:CreateFontString("ArcanistButtonsConfig2Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 50, 420)

		-- Buttons
		frame = CreateFrame("Button", nil, ArcanistButtonsConfig2, "OptionsButtonTemplate")
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", ArcanistButtonsConfig2, "BOTTOMRIGHT", 40, 135)

		frame:SetScript("OnClick", function()
			ArcanistButtonsConfig1:Show()
			ArcanistButtonsConfig2:Hide()
		end)

		frame = CreateFrame("Button", nil, ArcanistButtonsConfig2, "OptionsButtonTemplate")
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistButtonsConfig2, "BOTTOMLEFT", 40, 135)

		frame:SetScript("OnClick", function()
			ArcanistButtonsConfig1:Show()
			ArcanistButtonsConfig2:Hide()
		end)

		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Sub Menu 1
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Attach or detach the arcanist buttons
		frame = CreateFrame("CheckButton", "ArcanistLockButtons", ArcanistButtonsConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistButtonsConfig1, "BOTTOMLEFT", 25, 395)

		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				ArcanistConfig.ArcanistLockServ = true
				Arcanist:ClearAllPoints()
				Arcanist:ButtonSetup()
				Arcanist:NoDrag()
				if not ArcanistConfig.NoDragAll then
					ArcanistButton:RegisterForDrag("LeftButton")
					ArcanistSpellTimerButton:RegisterForDrag("LeftButton")
				end
			else
				ArcanistConfig.ArcanistLockServ = false
				Arcanist:ClearAllPoints()
				local ButtonName = {
					Arcanist.Mage_Buttons.buffs.f, --"ArcanistBuffMenuButton",
					Arcanist.Mage_Buttons.mount.f, --"ArcanistMountButton",
					Arcanist.Mage_Buttons.conjure_food.f, --"ArcanistFoodButton",
					Arcanist.Mage_Buttons.conjure_water.f, --"ArcanistWaterButton",
					Arcanist.Mage_Buttons.ports.f, --"ArcanistPortButton",
					Arcanist.Mage_Buttons.mana.f, --"ArcanistConjureManaButton",
				}
				local startingLoc = -119
				local offset = 34
				for i in ipairs(ButtonName) do
					if _G[ButtonName[i]] then
						_G[ButtonName[i]]:SetPoint(
							"CENTER",
							"UIParent",
							"CENTER",
							startingLoc + (offset * i),
							-100
						)
						ArcanistConfig.FramePosition[ButtonName[i]] = {
							"CENTER",
							"UIParent",
							"CENTER",
							startingLoc + (offset * i),
							-100
						}
					end
				end
				Arcanist:Drag()
				ArcanistConfig.NoDragAll = false
				ArcanistButton:RegisterForDrag("LeftButton")
				ArcanistSpellTimerButton:RegisterForDrag("LeftButton")
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Show or hide buttons around Arcanist
		local initY = 380
		local offset = 0
		if Arcanist.Debug.options then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("ConfigButtons"
			.." b'"..tostring(ArcanistConfig.Buttons).."'"
			)
		end

		for i, v in pairs(ArcanistConfig.Buttons) do
			offset = offset + 1
			if Arcanist.Debug.options then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("ConfigButtons"
				.." i'"..tostring(i).."'"
				.." v'"..tostring(v).."'"
				.." show'"..tostring(v).."'"
				)
			end
			frame = CreateFrame("CheckButton", "ArcanistShow"..i, ArcanistButtonsConfig1, "UICheckButtonTemplate")
			frame:EnableMouse(true)
			frame:SetWidth(24)
			frame:SetHeight(24)
			frame:Show()
			frame:ClearAllPoints()
			frame:SetPoint("LEFT", ArcanistButtonsConfig1, "BOTTOMLEFT", 25, initY - (25 * offset))

			frame:SetScript("OnClick", function(self)
				if (self:GetChecked()) then
					ArcanistConfig.Buttons[i] = true
				else
					ArcanistConfig.Buttons[i] = false
				end
				Arcanist:ButtonSetup()
			end)

			FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
			FontString:Show()
			FontString:ClearAllPoints()
			FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
			FontString:SetTextColor(1, 1, 1)
			frame:SetFontString(FontString)

			if Arcanist.Debug.options then
				_G["DEFAULT_CHAT_FRAME"]:AddMessage("ConfigButtons"
				.." i'"..tostring(i).."'"
				.." iupper'"..tostring(i:upper()).."'"
				)
			end
			_G["ArcanistShow"..i]:SetChecked(ArcanistConfig.Buttons[i])
			_G["ArcanistShow"..i]:SetText(self.Config.Buttons.Name["SHOW_"..i:upper()])
		end

		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Sub Menu 2
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Create a slider control for rotating the buttons around the sphere
		frame = CreateFrame("Slider", "ArcanistRotation", ArcanistButtonsConfig2, "OptionsSliderTemplate")
		frame:SetMinMaxValues(0, 360)
		frame:SetValueStep(5)
		frame:SetObeyStepOnDrag(true)
		frame:SetWidth(150)
		frame:SetHeight(15)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", ArcanistButtonsConfig2, "BOTTOMLEFT", 225, 380)

		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self:GetValue())
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnValueChanged", function(self)
			ArcanistConfig.ArcanistAngle = self:GetValue()
			GameTooltip:SetText(self:GetValue())
			Arcanist:ButtonSetup()
		end)

		ArcanistRotationLow:SetText("0")
		ArcanistRotationHigh:SetText("360")

		-- Create buttons for showing count of food on the button
		frame = CreateFrame("CheckButton", "ArcanistShowFoodCount", ArcanistButtonsConfig2, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistButtonsConfig2, "BOTTOMLEFT", 25, initY - 50)

		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				ArcanistConfig.ShowFoodCount = true
			else
				ArcanistConfig.ShowFoodCount = false
			end
			Arcanist:ButtonSetup()
			Arcanist:BagExplore()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		if Arcanist.Debug.options then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("ConfigButtons"
			.." sfc'"..tostring(ArcanistConfig.ShowFoodCount).."'"
			)
		end

		_G["ArcanistShowFoodCount"]:SetChecked(ArcanistConfig.ShowFoodCount)
		_G["ArcanistShowFoodCount"]:SetText(self.Config.Buttons.Name["SHOW_FOOD_COUNT"])

		-- Create buttons for showing count of water on the button
		frame = CreateFrame("CheckButton", "ArcanistShowWaterCount", ArcanistButtonsConfig2, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistButtonsConfig2, "BOTTOMLEFT", 25, initY - 75)

		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				ArcanistConfig.ShowWaterCount = true
			else
				ArcanistConfig.ShowWaterCount = false
			end
			Arcanist:ButtonSetup()
			Arcanist:BagExplore()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		if Arcanist.Debug.options then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("ConfigButtons"
			.." swc'"..tostring(ArcanistConfig.ShowWaterCount).."'"
			)
		end

		_G["ArcanistShowWaterCount"]:SetChecked(ArcanistConfig.ShowWaterCount)
		_G["ArcanistShowWaterCount"]:SetText(self.Config.Buttons.Name["SHOW_WATER_COUNT"])
	end

	ArcanistRotation:SetValue(ArcanistConfig.ArcanistAngle)
	ArcanistLockButtons:SetChecked(ArcanistConfig.ArcanistLockServ)

	ArcanistButtonsConfig1Text:SetText(self.Config.Buttons["BUTTONS_SELECTION"])
	ArcanistButtonsConfig2Text:SetText(self.Config.Menus["MENU_GENERAL"])
	ArcanistRotationText:SetText(self.Config.Buttons["BUTTONS_ROTATION"])
	ArcanistLockButtons:SetText(self.Config.Buttons["BUTTONS_STICK"])

	local frame = _G["ArcanistButtonsConfig"]
	frame:Show()
end
