--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as being the array containing all the existing frames.
local _G = getfenv(0)


------------------------------------------------------------------------------------------------------
-- CREATION AND INVOCATION OF THE CONTROL PANEL
------------------------------------------------------------------------------------------------------

-- Open the options menu frame
function Arcanist:OpenConfigPanel()

	-- Help messages are displayed
	if self.ChatMessage.Help[1] then
		for i = 1, #self.ChatMessage.Help, 1 do
			self:Msg(self.ChatMessage.Help[i], "USER")
		end
	end
    local me = self
	local frame = _G["ArcanistGeneralFrame"]
	-- If the windows does not exist, we create it
	if not frame then
		frame = CreateFrame("Frame", "ArcanistGeneralFrame", UIParent)

		--Definition of its attributes
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(true)
		frame:EnableMouse(true)
		frame:SetToplevel(true)
		frame:SetWidth(450)
		frame:SetHeight(512)
		frame:Show()
		frame:ClearAllPoints()
		if ArcanistConfig.FramePosition.ArcanistGeneralFrame then
			frame:SetPoint(
				ArcanistConfig.FramePosition["ArcanistGeneralFrame"][1],
				ArcanistConfig.FramePosition["ArcanistGeneralFrame"][2],
				ArcanistConfig.FramePosition["ArcanistGeneralFrame"][3],
				ArcanistConfig.FramePosition["ArcanistGeneralFrame"][4],
				ArcanistConfig.FramePosition["ArcanistGeneralFrame"][5]
			)
		else
			frame:SetPoint("TOPLEFT", 100, -100)
		end

		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnMouseUp", function(self) Arcanist:OnDragStop(self) end)
		frame:SetScript("OnDragStart", function(self) Arcanist:OnDragStart(self) end)
		frame:SetScript("OnDragStop", function(self) Arcanist:OnDragStop(self) end)

		-- Texture top left : icon
		local texture = frame:CreateTexture("ArcanistGeneralIcon", "BACKGROUND")
		texture:SetWidth(75)
		texture:SetHeight(61)
		texture:SetTexture("Interface\\Spellbook\\Spellbook-Icon")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT", 10, -6)

		-- Frame textures
		texture = frame:CreateTexture(nil, "BORDER")
		texture:SetWidth(322)
		texture:SetHeight(256)
		texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT")

		texture = frame:CreateTexture(nil, "BORDER")
		texture:SetWidth(128)
		texture:SetHeight(256)
		texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("TOPRIGHT")

		texture = frame:CreateTexture(nil, "BORDER")
		texture:SetWidth(322)
		texture:SetHeight(256)
		texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("BOTTOMLEFT")

		texture = frame:CreateTexture(nil, "BORDER")
		texture:SetWidth(128)
		texture:SetHeight(256)
		texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("BOTTOMRIGHT")

		-- Title text
		local FontString = frame:CreateFontString(nil, nil, "GameFontNormal")
		FontString:SetTextColor(1, 0.8, 0)
		FontString:SetText(self.Data.Label)
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("CENTER", 6, 233)

		-- Section title at the bottom of the page
		FontString = frame:CreateFontString("ArcanistGeneralPageText", nil, "GameFontNormal")
		FontString:SetTextColor(1, 0.8, 0)
		FontString:SetWidth(150) -- 102
		FontString:SetHeight(0)
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", 0, 96)

		-- Close window button
		frame = CreateFrame("Button", "ArcanistGeneralCloseButton", ArcanistGeneralFrame, "UIPanelCloseButton")
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", "ArcanistGeneralFrame", "TOPRIGHT", -46, -24)

		-- First tab of the control panel
		frame = CreateFrame("CheckButton", "ArcanistGeneralTab1", ArcanistGeneralFrame)
		frame:SetWidth(32)
		frame:SetHeight(32)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", "ArcanistGeneralFrame", "TOPRIGHT", -32, -65)

		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(me.Config.Panel[1])
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnClick", function() Arcanist:SetPanel(1) end)


		texture = frame:CreateTexture(nil, "BACKGROUND")
		texture:SetWidth(64)
		texture:SetHeight(64)
		texture:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
		texture:Show()
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT", -3, 11)

		frame:SetNormalTexture("Interface\\Icons\\Spell_Frost_FrostArmor")
		frame:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		frame:GetHighlightTexture():SetBlendMode("ADD")
		frame:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
		frame:GetCheckedTexture():SetBlendMode("ADD")

		-- Other tabs
		local tex = {
			"INV_Stone_02",
			"INV_Scroll_05",
			"INV_Staff_13",
			"INV_Misc_Pocketwatch_02",
			"Trade_Engineering",
		}

		for i in ipairs(tex) do
			frame = CreateFrame("CheckButton", "ArcanistGeneralTab"..(i + 1), ArcanistGeneralFrame)
			frame:SetWidth(32)
			frame:SetHeight(32)
			frame:Show()
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", "ArcanistGeneralTab"..i, "BOTTOMLEFT", 0, -17)

			frame:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

				GameTooltip:SetText(me.Config.Panel[i + 1])
			end)
			frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
			frame:SetScript("OnClick", function() Arcanist:SetPanel(i + 1) end)

			texture = frame:CreateTexture(nil, "BACKGROUND")
			texture:SetWidth(64)
			texture:SetHeight(64)
			texture:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")
			texture:Show()
			texture:ClearAllPoints()
			texture:SetPoint("TOPLEFT", -3, 11)

			frame:SetNormalTexture("Interface\\Icons\\"..tex[i])
			frame:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
			frame:GetHighlightTexture():SetBlendMode("ADD")
			frame:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
			frame:GetCheckedTexture():SetBlendMode("ADD")
		end

		self:SetPanel(1)
	else

		if frame:IsVisible() then
			frame:Hide()
		else
			frame:Show()
		end
	end
end

------------------------------------------------------------------------------------------------------
-- FUNCTIONS FOR THE CONTROL PANEL
------------------------------------------------------------------------------------------------------
-- Function to display different pages of the control panel
function Arcanist:SetPanel(PanelID)
	local TabName
	for index=1, 6, 1 do
		TabName = _G["ArcanistGeneralTab"..index]
		if index == PanelID then
			TabName:SetChecked(1)
		else
			TabName:SetChecked(nil)
		end
	end
	ArcanistGeneralPageText:SetText(self.Config.Panel[PanelID])
	if PanelID == 1 then
		HideUIPanel(ArcanistSphereConfig)
		HideUIPanel(ArcanistButtonsConfig)
		HideUIPanel(ArcanistMenusConfig)
		HideUIPanel(ArcanistTimersConfig)
		HideUIPanel(ArcanistMiscConfig)
		self:SetMessagesConfig()
	elseif PanelID == 2 then
		HideUIPanel(ArcanistMessagesConfig)
		HideUIPanel(ArcanistButtonsConfig)
		HideUIPanel(ArcanistMenusConfig)
		HideUIPanel(ArcanistTimersConfig)
		HideUIPanel(ArcanistMiscConfig)
		self:SetSphereConfig()
	elseif PanelID == 3 then
		HideUIPanel(ArcanistMessagesConfig)
		HideUIPanel(ArcanistSphereConfig)
		HideUIPanel(ArcanistMenusConfig)
		HideUIPanel(ArcanistTimersConfig)
		HideUIPanel(ArcanistMiscConfig)
		self:SetButtonsConfig()
	elseif PanelID == 4 then
		HideUIPanel(ArcanistMessagesConfig)
		HideUIPanel(ArcanistSphereConfig)
		HideUIPanel(ArcanistButtonsConfig)
		HideUIPanel(ArcanistTimersConfig)
		HideUIPanel(ArcanistMiscConfig)
		self:SetMenusConfig()
	elseif PanelID == 5 then
		HideUIPanel(ArcanistMessagesConfig)
		HideUIPanel(ArcanistSphereConfig)
		HideUIPanel(ArcanistButtonsConfig)
		HideUIPanel(ArcanistMenusConfig)
		HideUIPanel(ArcanistMiscConfig)
		self:SetTimersConfig()
	elseif PanelID == 6 then
		HideUIPanel(ArcanistMessagesConfig)
		HideUIPanel(ArcanistSphereConfig)
		HideUIPanel(ArcanistButtonsConfig)
		HideUIPanel(ArcanistMenusConfig)
		HideUIPanel(ArcanistTimersConfig)
		self:SetMiscConfig()
	end
end
