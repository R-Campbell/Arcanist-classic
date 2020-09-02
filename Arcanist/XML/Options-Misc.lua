--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as being the array containing all the existing frames.
local _G = getfenv(0)

------------------------------------------------------------------------------------------------------
-- CREATION OF THE OPTIONS FRAME
------------------------------------------------------------------------------------------------------

function Arcanist:SetMiscConfig()
	local frame = _G["ArcanistMiscConfig"]
	if not frame then
		-- Window creation
		frame = CreateFrame("Frame", "ArcanistMiscConfig", ArcanistGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Arcanist lockdown
		frame = CreateFrame("CheckButton", "ArcanistLock", ArcanistMiscConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistMiscConfig, "BOTTOMLEFT", 25, 395)

		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				Arcanist:NoDrag()
				ArcanistButton:RegisterForDrag("")
				ArcanistSpellTimerButton:RegisterForDrag("")
				ArcanistConfig.NoDragAll = true
			else
				if not ArcanistConfig.ArcanistLockServ then
					Arcanist:Drag()
				end
				ArcanistButton:RegisterForDrag("LeftButton")
				ArcanistSpellTimerButton:RegisterForDrag("LeftButton")
				ArcanistConfig.NoDragAll = false
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)
	end

	ArcanistLock:SetChecked(ArcanistConfig.NoDragAll)
	ArcanistLock:SetText(self.Config.Misc["MISC_LOCK"])

	frame:Show()
end
