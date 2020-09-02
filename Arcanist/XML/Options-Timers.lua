--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as being the array containing all the existing frames.
local _G = getfenv(0)


------------------------------------------------------------------------------------------------------
-- CREATION OF THE OPTIONS FRAME
------------------------------------------------------------------------------------------------------

function Arcanist:SetTimersConfig()

	local frame = _G["ArcanistTimersConfig"]
	if not frame then
		-- Window creation
		frame = CreateFrame("Frame", "ArcanistTimersConfig", ArcanistGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Create page 1
		frame = CreateFrame("Frame", "ArcanistTimersConfig1", ArcanistTimersConfig)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Choice of graphic timer
		frame = CreateFrame("Frame", "ArcanistTimerSelection", ArcanistTimersConfig1, "UIDropDownMenuTemplate")
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", ArcanistTimersConfig1, "BOTTOMRIGHT", 40, 400)

		local FontString = frame:CreateFontString("ArcanistTimerSelectionT", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", ArcanistTimersConfig1, "BOTTOMLEFT", 35, 403)
		FontString:SetTextColor(1, 1, 1)

		UIDropDownMenu_SetWidth(frame, 125)

		-- Show or hide the timers button
		frame = CreateFrame("CheckButton", "ArcanistShowSpellTimerButton", ArcanistTimersConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistTimersConfig1, "BOTTOMLEFT", 25, 325)

		local f = _G[Arcanist.Mage_Buttons.timer.f]
		frame:SetScript("OnClick", function(self)
			ArcanistConfig.ShowSpellTimers = self:GetChecked()
			if ArcanistConfig.ShowSpellTimers then
				f:Show()
			else
				f:Hide()
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)
		-- frame:SetDisabledTextColor(0.75, 0.75, 0.75)

		-- Show timers on the left of the button
		frame = CreateFrame("CheckButton", "ArcanistTimerOnLeft", ArcanistTimersConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistTimersConfig1, "BOTTOMLEFT", 25, 300)

		frame:SetScript("OnClick", function(self)
			Arcanist:TimerSymmetry(self:GetChecked())
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)
		-- frame:SetDisabledTextColor(0.75, 0.75, 0.75)

		-- Display timers from bottom to top
		frame = CreateFrame("CheckButton", "ArcanistTimerUpward", ArcanistTimersConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistTimersConfig1, "BOTTOMLEFT", 25, 275)

		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				ArcanistConfig.ListDirection = -1
			else
				ArcanistConfig.ListDirection = 1
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)
	end

	UIDropDownMenu_Initialize(ArcanistTimerSelection, Arcanist.Timer_Init)

	ArcanistTimerSelectionT:SetText(self.Config.Timers["TIMER_TYPE"])
	ArcanistShowSpellTimerButton:SetText(self.Config.Timers["TIMER_SPELL"])
	ArcanistTimerOnLeft:SetText(self.Config.Timers["TIMER_LEFT"])
	ArcanistTimerUpward:SetText(self.Config.Timers["TIMER_UP"])

	UIDropDownMenu_SetSelectedID(ArcanistTimerSelection, (ArcanistConfig.TimerType + 1))
	UIDropDownMenu_SetText(ArcanistTimerSelection, Arcanist.Config.Timers.Type[ArcanistConfig.TimerType + 1])

	ArcanistShowSpellTimerButton:SetChecked(ArcanistConfig.ShowSpellTimers)
	ArcanistTimerOnLeft:SetChecked(ArcanistConfig.SpellTimerPos == -1)
	ArcanistTimerUpward:SetChecked(ArcanistConfig.ListDirection == -1)

	if ArcanistConfig.TimerType == 0 then
		ArcanistTimerUpward:Disable()
		ArcanistTimerOnLeft:Disable()
	elseif ArcanistConfig.TimerType == 2 then
		ArcanistTimerUpward:Disable()
		ArcanistTimerOnLeft:Enable()
	else
		ArcanistTimerOnLeft:Enable()
		ArcanistTimerUpward:Enable()
	end

	local frame = _G["ArcanistTimersConfig"]
	frame:Show()
end


------------------------------------------------------------------------------------------------------
-- FUNCTIONS REQUIRED FOR DROPDOWNS
------------------------------------------------------------------------------------------------------

-- Timer dropdown functions
function Arcanist.Timer_Init()
	local element = {}

	for i in ipairs(Arcanist.Config.Timers.Type) do
		element.text = Arcanist.Config.Timers.Type[i]
		element.checked = false
		element.func = Arcanist.Timer_Click
		UIDropDownMenu_AddButton(element)
	end
end

function Arcanist.Timer_Click(self)
	local ID = self:GetID()
	UIDropDownMenu_SetSelectedID(ArcanistTimerSelection, ID)
	ArcanistConfig.TimerType = ID - 1
	if not (ID == 1) then Arcanist:CreateTimerAnchor() end
	if ID == 1 then
		ArcanistTimerUpward:Disable()
		ArcanistTimerOnLeft:Disable()
		if _G["ArcanistListSpells"] then ArcanistListSpells:SetText("") end
		local index = 1
		while _G["ArcanistTimerFrame"..index] do
			_G["ArcanistTimerFrame"..index]:Hide()
			index = index + 1
		end
	elseif ID == 3 then
		ArcanistTimerUpward:Disable()
		ArcanistTimerOnLeft:Enable()
		local index = 1
		while _G["ArcanistTimerFrame"..index] do
			_G["ArcanistTimerFrame"..index]:Hide()
			index = index + 1
		end
	else
		ArcanistTimerUpward:Enable()
		ArcanistTimerOnLeft:Enable()
		if _G["ArcanistListSpells"] then ArcanistListSpells:SetText("") end
	end
end
