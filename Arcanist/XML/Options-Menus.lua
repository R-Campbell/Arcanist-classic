--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as being the array containing all the existing frames.
local _G = getfenv(0)
local frames = {}

------------------------------------------------------------------------------------------------------
-- CREATION OF THE OPTIONS FRAME
------------------------------------------------------------------------------------------------------
local function SetState(f, state)
	if f then f:SetAttribute("state", state) end
end

local function ConfigureOrientationDropdown(paneNumber, paneName)
	local frame = CreateFrame("Frame", "Arcanist"..paneName.."Vector", frames["ArcanistMenusConfig"..paneNumber], "UIDropDownMenuTemplate")
	frame:Show()
	frame:ClearAllPoints()
	frame:SetPoint("RIGHT", frames["ArcanistMenusConfig"..paneNumber], "BOTTOMRIGHT", 40, 350)

	local FontString = frame:CreateFontString("Arcanist"..paneName.."VectorT", "OVERLAY", "GameFontNormalSmall")
	FontString:Show()
	FontString:ClearAllPoints()
	FontString:SetPoint("LEFT", frames["ArcanistMenusConfig"..paneNumber], "BOTTOMLEFT", 35, 353)
	FontString:SetTextColor(1, 1, 1)

	UIDropDownMenu_SetWidth(frame, 125)
end

local function ConfigureXOffsetSlider(paneNumber, paneName, paneButton)
	frames["Arcanist"..paneName.."Ox"] = CreateFrame("Slider", "Arcanist"..paneName.."Ox", frames["ArcanistMenusConfig"..paneNumber], "OptionsSliderTemplate")
	frames["Arcanist"..paneName.."Ox"]:SetMinMaxValues(-65, 65)
	frames["Arcanist"..paneName.."Ox"]:SetValueStep(1)
	frames["Arcanist"..paneName.."Ox"]:SetObeyStepOnDrag(true)
	frames["Arcanist"..paneName.."Ox"]:SetWidth(140)
	frames["Arcanist"..paneName.."Ox"]:SetHeight(15)
	frames["Arcanist"..paneName.."Ox"]:Show()
	frames["Arcanist"..paneName.."Ox"]:ClearAllPoints()
	frames["Arcanist"..paneName.."Ox"]:SetPoint("LEFT", frames["ArcanistMenusConfig"..paneNumber], "BOTTOMLEFT", 35, 200)

	local state = "closed"
	if ArcanistConfig.BlockedMenu then
		state = "blocked"
	end
	frames["Arcanist"..paneName.."Ox"]:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self:GetValue())
		SetState(_G[Arcanist.Mage_Buttons[paneButton].f], "blocked")
	end)
	frames["Arcanist"..paneName.."Ox"]:SetScript("OnLeave", function()
		GameTooltip:Hide()
		SetState(_G[Arcanist.Mage_Buttons[paneButton].f], state)
	end)
	frames["Arcanist"..paneName.."Ox"]:SetScript("OnValueChanged", function(self)
		GameTooltip:SetText(self:GetValue())
		ArcanistConfig[paneName.."MenuOffset"].x = self:GetValue()
		Arcanist:SetOfxy(paneName)
	end)

	getglobal("Arcanist"..paneName.."OxText"):SetText("Offset X")
	getglobal("Arcanist"..paneName.."OxLow"):SetText("")
	getglobal("Arcanist"..paneName.."OxHigh"):SetText("")
end

local function ConfigureYOffsetSlider(paneNumber, paneName, paneButton)
	frames["Arcanist"..paneName.."Oy"] = CreateFrame("Slider", "Arcanist"..paneName.."Oy", frames["ArcanistMenusConfig"..paneNumber], "OptionsSliderTemplate")
	frames["Arcanist"..paneName.."Oy"]:SetMinMaxValues(-65, 65)
	frames["Arcanist"..paneName.."Oy"]:SetValueStep(1)
	frames["Arcanist"..paneName.."Oy"]:SetObeyStepOnDrag(true)
	frames["Arcanist"..paneName.."Oy"]:SetWidth(140)
	frames["Arcanist"..paneName.."Oy"]:SetHeight(15)
	frames["Arcanist"..paneName.."Oy"]:Show()
	frames["Arcanist"..paneName.."Oy"]:ClearAllPoints()
	frames["Arcanist"..paneName.."Oy"]:SetPoint("RIGHT", frames["ArcanistMenusConfig"..paneNumber], "BOTTOMRIGHT", 40, 200)

	local state = "closed"
	if ArcanistConfig.BlockedMenu then
		state = "blocked"
	end
	frames["Arcanist"..paneName.."Oy"]:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self:GetValue())
		SetState(_G[Arcanist.Mage_Buttons[paneButton].f], "blocked")
	end)
	frames["Arcanist"..paneName.."Oy"]:SetScript("OnLeave", function()
		GameTooltip:Hide()
		SetState(_G[Arcanist.Mage_Buttons[paneButton].f], state)
	end)
	frames["Arcanist"..paneName.."Oy"]:SetScript("OnValueChanged", function(self)
		GameTooltip:SetText(self:GetValue())
		ArcanistConfig[paneName.."MenuOffset"].y = self:GetValue()
		Arcanist:SetOfxy(paneName)
	end)

	getglobal("Arcanist"..paneName.."OyText"):SetText("Offset Y")
	getglobal("Arcanist"..paneName.."OyLow"):SetText("")
	getglobal("Arcanist"..paneName.."OyHigh"):SetText("")
end

local function CreatePane(paneNumber, totalPanes)
	frames["ArcanistMenusConfig"..paneNumber] = CreateFrame("Frame", "ArcanistMenusConfig"..paneNumber, ArcanistMenusConfig)
	frames["ArcanistMenusConfig"..paneNumber]:SetFrameStrata("DIALOG")
	frames["ArcanistMenusConfig"..paneNumber]:SetMovable(false)
	frames["ArcanistMenusConfig"..paneNumber]:EnableMouse(true)
	frames["ArcanistMenusConfig"..paneNumber]:SetWidth(350)
	frames["ArcanistMenusConfig"..paneNumber]:SetHeight(452)
	if (paneNumber == 1) then
		frames["ArcanistMenusConfig"..paneNumber]:Show()
	else
		frames["ArcanistMenusConfig"..paneNumber]:Hide()
	end
	frames["ArcanistMenusConfig"..paneNumber]:ClearAllPoints()
	frames["ArcanistMenusConfig"..paneNumber]:SetAllPoints(ArcanistMenusConfig)

	local FontString = frames["ArcanistMenusConfig"..paneNumber]:CreateFontString(nil, nil, "GameFontNormalSmall")
	FontString:Show()
	FontString:ClearAllPoints()
	FontString:SetPoint("BOTTOM", frames["ArcanistMenusConfig"..paneNumber], "BOTTOM", 50, 130)
	FontString:SetText(paneNumber.." / "..totalPanes)

	FontString = frames["ArcanistMenusConfig"..paneNumber]:CreateFontString("ArcanistMenusConfig"..paneNumber.."Text", nil, "GameFontNormalSmall")
	FontString:Show()
	FontString:ClearAllPoints()
	FontString:SetPoint("BOTTOM", frames["ArcanistMenusConfig"..paneNumber], "BOTTOM", 50, 400)

	local nextButton = CreateFrame("Button", nil, frames["ArcanistMenusConfig"..paneNumber], "OptionsButtonTemplate")
	nextButton:SetText(">>>")
	nextButton:EnableMouse(true)
	nextButton:Show()
	nextButton:ClearAllPoints()
	nextButton:SetPoint("RIGHT", frames["ArcanistMenusConfig"..paneNumber], "BOTTOMRIGHT", 40, 135)

	nextButton:SetScript("OnClick", function()
		nextPane = paneNumber + 1
		if (nextPane > totalPanes) then nextPane = 1 end
		frames["ArcanistMenusConfig"..nextPane]:Show()
		frames["ArcanistMenusConfig"..paneNumber]:Hide()
	end)

	local prevButton = CreateFrame("Button", nil, frames["ArcanistMenusConfig"..paneNumber], "OptionsButtonTemplate")
	prevButton:SetText("<<<")
	prevButton:EnableMouse(true)
	prevButton:Show()
	prevButton:ClearAllPoints()
	prevButton:SetPoint("LEFT", frames["ArcanistMenusConfig"..paneNumber], "BOTTOMLEFT", 40, 135)

	prevButton:SetScript("OnClick", function()
		prevPane = paneNumber - 1
		if (prevPane == 0) then prevPane = totalPanes end
		frames["ArcanistMenusConfig"..prevPane]:Show()
		frames["ArcanistMenusConfig"..paneNumber]:Hide()
	end)
end

function Arcanist:SetMenusConfig()
	local frame = _G["ArcanistMenusConfig"]
	if not frame then
		-- Window creation
		frame = CreateFrame("Frame", "ArcanistMenusConfig", ArcanistGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Variable for setting page numbers
		local numberOfMenuButtons = 1
		for i, v in ipairs(Arcanist.Mage_Lists.on_sphere) do
			if v.menu then
				numberOfMenuButtons = numberOfMenuButtons + 1
			end
		end

		-- Variable for looping when creating panes
		local currentPane = 1

		-- General Options
		CreatePane(currentPane, numberOfMenuButtons)
		currentPane = currentPane + 1

		for i, v in ipairs (Arcanist.Mage_Lists.on_sphere) do
			if (v.menu) then -- All menus have the same options to adjust direction and offset
				CreatePane(currentPane, numberOfMenuButtons)
				ConfigureOrientationDropdown(currentPane, v.name)
				ConfigureXOffsetSlider(currentPane, v.name, v.f_ptr)
				ConfigureYOffsetSlider(currentPane, v.name, v.f_ptr)
				currentPane = currentPane + 1
			end
		end

		-- General Options
		-- Display Menus Permanently
		frame = CreateFrame("CheckButton", "ArcanistBlockedMenu", frames["ArcanistMenusConfig1"], "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", ArcanistMenusConfig, "BOTTOMLEFT", 25, 350)

		frame:SetScript("OnClick", function(self)
			ArcanistConfig.BlockedMenu = self:GetChecked()
			if ArcanistConfig.BlockedMenu then
				local s = "blocked"
				SetState(_G[Arcanist.Mage_Buttons.buffs.f], s)
				SetState(_G[Arcanist.Mage_Buttons.ports.f], s)
				SetState(_G[Arcanist.Mage_Buttons.mana.f], s)
				ArcanistAutoMenu:Disable()
				ArcanistCloseMenu:Disable()
			else
				local s = "closed"
				SetState(_G[Arcanist.Mage_Buttons.buffs.f], s)
				SetState(_G[Arcanist.Mage_Buttons.ports.f], s)
				SetState(_G[Arcanist.Mage_Buttons.mana.f], s)
				ArcanistAutoMenu:Enable()
				ArcanistCloseMenu:Enable()
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Show menus in combat
		frame = CreateFrame("CheckButton", "ArcanistAutoMenu", frames["ArcanistMenusConfig1"], "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", frames["ArcanistMenusConfig1"], "BOTTOMLEFT", 25, 325)

		frame:SetScript("OnClick", function(self)
			ArcanistConfig.AutomaticMenu = self:GetChecked()
			if not ArcanistConfig.AutomaticMenu then
				local s = "closed"
				SetState(_G[Arcanist.Mage_Buttons.buffs.f], s)
				SetState(_G[Arcanist.Mage_Buttons.ports.f], s)
				SetState(_G[Arcanist.Mage_Buttons.mana.f], s)
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Hide menus on a click
		frame = CreateFrame("CheckButton", "ArcanistCloseMenu", frames["ArcanistMenusConfig1"], "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", frames["ArcanistMenusConfig1"], "BOTTOMLEFT", 25, 300)

		frame:SetScript("OnClick", function(self)
			ArcanistConfig.ClosingMenu = self:GetChecked()
			Arcanist:CreateMenu()
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)
        -- End General Options
	end

	UIDropDownMenu_Initialize(ArcanistBuffVector, self.BuffVector_Init)
	UIDropDownMenu_Initialize(ArcanistPortVector, self.PortVector_Init)
	UIDropDownMenu_Initialize(ArcanistManaVector, self.ManaVector_Init)

	ArcanistMenusConfig1Text:SetText(self.Config.Menus["MENU_GENERAL"])
	ArcanistMenusConfig2Text:SetText(self.Config.Menus["MENU_SPELLS"])
	ArcanistMenusConfig3Text:SetText(self.Config.Menus["MENU_PORT"])
	ArcanistMenusConfig4Text:SetText(self.Config.Menus["MENU_MANA"])

	ArcanistBlockedMenu:SetText(self.Config.Menus["MENU_ALWAYS"])
	ArcanistAutoMenu:SetText(self.Config.Menus["MENU_AUTO_COMBAT"])
	ArcanistCloseMenu:SetText(self.Config.Menus["MENU_CLOSE_CLICK"])

	ArcanistBuffVectorT:SetText(self.Config.Menus["MENU_ORIENTATION"])
	ArcanistPortVectorT:SetText(self.Config.Menus["MENU_ORIENTATION"])
	ArcanistManaVectorT:SetText(self.Config.Menus["MENU_ORIENTATION"])

	ArcanistBlockedMenu:SetChecked(ArcanistConfig.BlockedMenu)
	ArcanistAutoMenu:SetChecked(ArcanistConfig.AutomaticMenu)
	ArcanistCloseMenu:SetChecked(ArcanistConfig.ClosingMenu)

	-- BUFF
	-- finding current orientation
	if (ArcanistConfig.BuffMenuPos.x == -1) then -- Left
		UIDropDownMenu_SetSelectedID(ArcanistBuffVector, 1)
		UIDropDownMenu_SetText(ArcanistBuffVector, self.Config.Menus.Orientation[1])
	elseif (ArcanistConfig.BuffMenuPos.y == 1) then -- Up
		UIDropDownMenu_SetSelectedID(ArcanistBuffVector, 2)
		UIDropDownMenu_SetText(ArcanistBuffVector, self.Config.Menus.Orientation[2])
	elseif (ArcanistConfig.BuffMenuPos.x == 1) then -- Right
		UIDropDownMenu_SetSelectedID(ArcanistBuffVector, 3)
		UIDropDownMenu_SetText(ArcanistBuffVector, self.Config.Menus.Orientation[3])
	else -- Down
		UIDropDownMenu_SetSelectedID(ArcanistBuffVector, 4)
		UIDropDownMenu_SetText(ArcanistBuffVector, self.Config.Menus.Orientation[4])
	end

	-- setting current offset
	ArcanistBuffOx:SetValue(ArcanistConfig.BuffMenuOffset.x)
	ArcanistBuffOy:SetValue(ArcanistConfig.BuffMenuOffset.y)
	-- END BUFF

	-- PORT
	-- finding current orientation
	if (ArcanistConfig.PortMenuPos.x == -1) then -- Left
		UIDropDownMenu_SetSelectedID(ArcanistPortVector, 1)
		UIDropDownMenu_SetText(ArcanistPortVector, self.Config.Menus.Orientation[1])
	elseif (ArcanistConfig.PortMenuPos.y == 1) then -- Up
		UIDropDownMenu_SetSelectedID(ArcanistPortVector, 2)
		UIDropDownMenu_SetText(ArcanistPortVector, self.Config.Menus.Orientation[2])
	elseif (ArcanistConfig.PortMenuPos.x == 1) then -- Right
		UIDropDownMenu_SetSelectedID(ArcanistPortVector, 3)
		UIDropDownMenu_SetText(ArcanistPortVector, self.Config.Menus.Orientation[3])
	else -- Down
		UIDropDownMenu_SetSelectedID(ArcanistPortVector, 4)
		UIDropDownMenu_SetText(ArcanistPortVector, self.Config.Menus.Orientation[4])
	end

	-- setting current offset
	ArcanistPortOx:SetValue(ArcanistConfig.PortMenuOffset.x)
	ArcanistPortOy:SetValue(ArcanistConfig.PortMenuOffset.y)
	-- End PORT

	-- MANA
	-- finding current orientation
	if (ArcanistConfig.ManaMenuPos.x == -1) then -- Left
		UIDropDownMenu_SetSelectedID(ArcanistManaVector, 1)
		UIDropDownMenu_SetText(ArcanistManaVector, self.Config.Menus.Orientation[1])
	elseif (ArcanistConfig.ManaMenuPos.y == 1) then -- Up
		UIDropDownMenu_SetSelectedID(ArcanistManaVector, 2)
		UIDropDownMenu_SetText(ArcanistManaVector, self.Config.Menus.Orientation[2])
	elseif (ArcanistConfig.ManaMenuPos.x == 1) then -- Right
		UIDropDownMenu_SetSelectedID(ArcanistManaVector, 3)
		UIDropDownMenu_SetText(ArcanistManaVector, self.Config.Menus.Orientation[3])
	else -- Down
		UIDropDownMenu_SetSelectedID(ArcanistManaVector, 4)
		UIDropDownMenu_SetText(ArcanistManaVector, self.Config.Menus.Orientation[4])
	end

	-- setting current offset
	ArcanistManaOx:SetValue(ArcanistConfig.ManaMenuOffset.x)
	ArcanistManaOy:SetValue(ArcanistConfig.ManaMenuOffset.y)
	-- END MANA finding current orientation

	if ArcanistConfig.BlockedMenu then
		ArcanistAutoMenu:Disable()
		ArcanistCloseMenu:Disable()
	else
		ArcanistAutoMenu:Enable()
		ArcanistCloseMenu:Enable()
	end

	frame:Show()
end



------------------------------------------------------------------------------------------------------
-- FUNCTIONS REQUIRED FOR DROPDOWNS
------------------------------------------------------------------------------------------------------
-- Buff dropdown functions
function Arcanist.BuffVector_Init()
	local element = {}

	for i in ipairs(Arcanist.Config.Menus.Orientation) do
		element.text = Arcanist.Config.Menus.Orientation[i]
		element.checked = false
		element.func = Arcanist.BuffVector_Click
		UIDropDownMenu_AddButton(element)
	end
end

function Arcanist.BuffVector_Click(self)
	local ID = self:GetID()

	-- 1 = Left, 2 = Up, 3 = Right, 4 = Down
	UIDropDownMenu_SetSelectedID(ArcanistBuffVector, ID)
	if ID == 1 then
		ArcanistConfig.BuffMenuPos.x = -1
		ArcanistConfig.BuffMenuPos.y = 0
	elseif ID == 2 then
		ArcanistConfig.BuffMenuPos.x = 0
		ArcanistConfig.BuffMenuPos.y = 1
	elseif ID == 3 then
		ArcanistConfig.BuffMenuPos.x = 1
		ArcanistConfig.BuffMenuPos.y = 0
	else
		ArcanistConfig.BuffMenuPos.x = 0
		ArcanistConfig.BuffMenuPos.y = -1
	end
	Arcanist:CreateMenu()
end

-- Functions for the Port Menu
function Arcanist.PortVector_Init()
	local element = {}

	for i in ipairs(Arcanist.Config.Menus.Orientation) do
		element.text = Arcanist.Config.Menus.Orientation[i]
		element.checked = false
		element.func = Arcanist.PortVector_Click
		UIDropDownMenu_AddButton(element)
	end
end

function Arcanist.PortVector_Click(self)
	local ID = self:GetID()

	-- 1 = Left, 2 = Up, 3 = Right, 4 = Down
	UIDropDownMenu_SetSelectedID(ArcanistPortVector, ID)
	if ID == 1 then
		ArcanistConfig.PortMenuPos.x = -1
		ArcanistConfig.PortMenuPos.y = 0
	elseif ID == 2 then
		ArcanistConfig.PortMenuPos.x = 0
		ArcanistConfig.PortMenuPos.y = 1
	elseif ID == 3 then
		ArcanistConfig.PortMenuPos.x = 1
		ArcanistConfig.PortMenuPos.y = 0
	else
		ArcanistConfig.PortMenuPos.x = 0
		ArcanistConfig.PortMenuPos.y = -1
	end
	Arcanist:CreateMenu()
end

-- Functions for the Mana Menu
function Arcanist.ManaVector_Init()
	local element = {}

	for i in ipairs(Arcanist.Config.Menus.Orientation) do
		element.text = Arcanist.Config.Menus.Orientation[i]
		element.checked = false
		element.func = Arcanist.ManaVector_Click
		UIDropDownMenu_AddButton(element)
	end
end

function Arcanist.ManaVector_Click(self)
	local ID = self:GetID()

	-- 1 = Left, 2 = Up, 3 = Right, 4 = Down
	UIDropDownMenu_SetSelectedID(ArcanistManaVector, ID)
	if ID == 1 then
		ArcanistConfig.ManaMenuPos.x = -1
		ArcanistConfig.ManaMenuPos.y = 0
	elseif ID == 2 then
		ArcanistConfig.ManaMenuPos.x = 0
		ArcanistConfig.ManaMenuPos.y = 1
	elseif ID == 3 then
		ArcanistConfig.ManaMenuPos.x = 1
		ArcanistConfig.ManaMenuPos.y = 0
	else
		ArcanistConfig.ManaMenuPos.x = 0
		ArcanistConfig.ManaMenuPos.y = -1
	end
	Arcanist:CreateMenu()
end
