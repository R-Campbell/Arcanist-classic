--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as being the array containing all the existing frames.
local _G = getfenv(0)


------------------------------------------------------------------------------------------------------
-- CREATION OF THE OPTIONS FRAME
------------------------------------------------------------------------------------------------------

function Arcanist:SetMessagesConfig()

	local frame = _G["ArcanistMessagesConfig"]
	if not frame then
		-- Window creation
		frame = CreateFrame("Frame", "ArcanistMessagesConfig", ArcanistGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Activate tooltips
		frame = CreateFrame("CheckButton", "ArcanistShowTooltip", ArcanistMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistMessagesConfig, "BOTTOMLEFT", 25, 395)

		frame:SetScript("OnClick", function(self) ArcanistConfig.ArcanistToolTip = self:GetChecked() end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Move messages to the system area
		frame = CreateFrame("CheckButton", "ArcanistChatType", ArcanistMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistMessagesConfig, "BOTTOMLEFT", 25, 370)

		frame:SetScript("OnClick", function(self)
			ArcanistConfig.ChatType = not self:GetChecked()
			Arcanist:Msg(Arcanist.Config.Messages.Position)
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		--[[
		-- Activate Portal messages
		frame = CreateFrame("CheckButton", "ArcanistSpeech", ArcanistMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistMessagesConfig, "BOTTOMLEFT", 25, 330)

		frame:SetScript("OnClick", function(self)
			ArcanistConfig.ChatMsg = self:GetChecked()
			if not ArcanistConfig.ChatMsg then
				-- todo: add these when speech is added
				-- ArcanistShortMessages:Disable()
				-- ArcanistPortMessages:Disable()
			else
				-- ArcanistShortMessages:Enable()
				-- ArcanistPortMessages:Enable()
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)
		]]--

		--[[
		-- Activate short messages
		frame = CreateFrame("CheckButton", "ArcanistShortMessages", ArcanistMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistMessagesConfig, "BOTTOMLEFT", 50, 305)

		frame:SetScript("OnClick", function(self)
			ArcanistConfig.SM = self:GetChecked()
			if ArcanistConfig.SM then
				-- todo: add these when speech is added
				-- Arcanist.Speech.Portal = Arcanist.Speech.ShortMessage[1]
			else
				-- ArcanistPortMessages:Enable()
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		-- FontString:SetDisabledTextColor(0.75, 0.75, 0.75)
		frame:SetFontString(FontString)
		]]--

		--[[
		-- Sound alerts
		frame = CreateFrame("CheckButton", "ArcanistSound", ArcanistMessagesConfig, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistMessagesConfig, "BOTTOMLEFT", 25, 215)

		frame:SetScript("OnClick", function(self)
			ArcanistConfig.Sound = self:GetChecked()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)
		]]--
	end

	ArcanistShowTooltip:SetChecked(ArcanistConfig.ArcanistToolTip)
	ArcanistChatType:SetChecked(not ArcanistConfig.ChatType)
	-- ArcanistSpeech:SetChecked(ArcanistConfig.ChatMsg)
	-- ArcanistShortMessages:SetChecked(ArcanistConfig.SM)
	-- todo: add this when speech is added
	-- ArcanistPortalMessages:SetChecked(ArcanistConfig.Portal)
	-- ArcanistSound:SetChecked(ArcanistConfig.Sound)


	ArcanistShowTooltip:SetText(self.Config.Messages["MSG_SHOW_TIPS"])
	ArcanistChatType:SetText(self.Config.Messages["MSG_SHOW_SYS"])
	-- ArcanistSpeech:SetText(self.Config.Messages["MSG_RANDOM"])
	-- ArcanistShortMessages:SetText(self.Config.Messages["MSG_USE_SHORT"])
	-- todo: add this when speech is added
	-- ArcanistPortalMessages:SetText(self.Config.Messages["MSG_RANDOM_PORTAL"])
	-- ArcanistSound:SetText(self.Config.Messages["MSG_SOUNDS"])

	if not ArcanistConfig.ChatMsg then
		-- ArcanistShortMessages:Disable()
		-- ArcanistPortalMessages:Disable()
	elseif ArcanistConfig.SM then
		-- ArcanistShortMessages:Enable()
		-- ArcanistPortalMessages:Disable()
	else
		-- ArcanistShortMessages:Enable()
		-- ArcanistPortalMessages:Enable()
	end

	frame:Show()
end
