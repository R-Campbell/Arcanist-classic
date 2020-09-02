--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as being the array containing all the existing frames.
local _G = getfenv(0)

local function White(str)
	return "|c00FFFFFF"..str.."|r"
end


------------------------------------------------------------------------------------------------------
-- ANCHOR FOR THE GRAPHICS/TEXT TIMER
------------------------------------------------------------------------------------------------------

function Arcanist:CreateTimerAnchor()
	local ft = _G[Arcanist.Mage_Buttons.timer.f]
	if ArcanistConfig.TimerType == 1 then
		-- Create the graphical timer frame
		local f = _G["ArcanistTimerFrame0"]
		if not f then
			f = CreateFrame("Frame", "ArcanistTimerFrame0", UIParent)
			f:SetWidth(150)
			f:SetHeight(10)
			f:Show()
			f:ClearAllPoints()
			f:SetPoint("LEFT", ft, "CENTER", 50, 0)
		end
	elseif ArcanistConfig.TimerType == 2 then
		-- Create the text timer
		local FontString = _G["ArcanistListSpells"]
		if not FontString then
			FontString = ft:CreateFontString(
				"ArcanistListSpells", nil, "GameFontNormalSmall"
			)
		end

		-- Define the attributes
		FontString:SetJustifyH("LEFT")
		FontString:SetPoint("LEFT", ft, "LEFT", 23, 0)
		FontString:SetTextColor(1, 1, 1)
	end
end

function Arcanist:CreateMageUI()
------------------------------------------------------------------------------------------------------
-- TIMER BUTTON
------------------------------------------------------------------------------------------------------

	-- Create the timer button
	local f = Arcanist.Mage_Buttons.timer.f
	local frame = nil
	frame = _G[f]
	if not frame then
		frame = CreateFrame("Button", f, UIParent, "SecureActionButtonTemplate")
	end

	-- Define its attributes
	frame:SetFrameStrata("MEDIUM")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetWidth(34)
	frame:SetHeight(34)
	frame:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\SpellTimerButton-Normal")
	frame:SetPushedTexture("Interface\\AddOns\\Arcanist\\UI\\SpellTimerButton-Pushed")
	frame:SetHighlightTexture("Interface\\AddOns\\Arcanist\\UI\\SpellTimerButton-Highlight")
	frame:RegisterForClicks("AnyUp")

	-- Create the timer anchor
	self:CreateTimerAnchor()
	-- Edit the scripts associated with the button
	frame:SetScript("OnLoad", function(self)
		self:RegisterForDrag("LeftButton")
		self:RegisterForClicks("RightButtonUp")
	end)
	frame:SetScript("OnEnter", function(self) Arcanist:BuildButtonTooltip(self) end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Arcanist:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Arcanist:OnDragStart(self) end)
	frame:SetScript("OnDragStop",  function(self) Arcanist:OnDragStop(self) end)

	-- Place the button window at its saved location
	frame:ClearAllPoints()
	frame:SetPoint(
		ArcanistConfig.FramePosition["ArcanistSpellTimerButton"][1],
		ArcanistConfig.FramePosition["ArcanistSpellTimerButton"][2],
		ArcanistConfig.FramePosition["ArcanistSpellTimerButton"][3],
		ArcanistConfig.FramePosition["ArcanistSpellTimerButton"][4],
		ArcanistConfig.FramePosition["ArcanistSpellTimerButton"][5]
	)
	frame:Show()


------------------------------------------------------------------------------------------------------
-- ARCANIST SPHERE
------------------------------------------------------------------------------------------------------

	-- Create the main Arcanist button
	frame = nil
	frame = _G["ArcanistButton"]
	if not frame then
		frame = CreateFrame("Button", "ArcanistButton", UIParent, "SecureActionButtonTemplate")
		frame:SetNormalTexture("Interface\\AddOns\\Arcanist\\UI\\Shard")
	end

	-- Define its attributes
	frame:SetFrameLevel(1)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetWidth(58)
	frame:SetHeight(58)
	frame:RegisterForDrag("LeftButton")
	frame:RegisterForClicks("AnyUp")
	frame:Show()

	-- Place the button window at its saved location
	frame:ClearAllPoints()
	frame:SetPoint(
		ArcanistConfig.FramePosition["ArcanistButton"][1],
		ArcanistConfig.FramePosition["ArcanistButton"][2],
		ArcanistConfig.FramePosition["ArcanistButton"][3],
		ArcanistConfig.FramePosition["ArcanistButton"][4],
		ArcanistConfig.FramePosition["ArcanistButton"][5]
	)

	frame:SetScale(ArcanistConfig.ArcanistButtonScale / 100)

	-- Create the counter
	local FontString = _G["ArcanistMainCount"]
	if not FontString then
		FontString = frame:CreateFontString("ArcanistMainCount", nil, "GameFontNormal")
	end

	-- Define its attributes
	FontString:SetText("00")
	FontString:SetPoint("CENTER")
	FontString:SetTextColor(1, 1, 1)
end

------------------------------------------------------------------------------------------------------
-- REGULAR BUTTONS (creating/using water/food, mounting, etc)
------------------------------------------------------------------------------------------------------

local function CreateButton(button)
	-- Create the stone button
	local b = button
	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateButton"
		.." i'"..tostring(button).."'"
		.." b'"..tostring(b and b.f).."'"
		--.." tn'"..tostring(b.norm).."'"
		--.." th'"..tostring(b.high).."'"
		)
	end

	local frame = CreateFrame("Button", b.f, UIParent, "SecureActionButtonTemplate")

	-- Define its attributes
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetWidth(34)
	frame:SetHeight(34)
	frame:SetNormalTexture(b.norm)
	frame:SetHighlightTexture(b.high)
	if (b.disabled) then
		frame:SetDisabledTexture(b.disabled)
	end
	frame:RegisterForDrag("LeftButton")
	frame:RegisterForClicks("AnyUp")
	frame:Show()

	-- Edit the scripts associated with the buttons
	frame:SetScript("OnEnter", function(self) Arcanist:BuildButtonTooltip(self) end)
--	frame:SetScript("OnEnter", function(self) Arcanist:BuildTooltip(self, button, "ANCHOR_LEFT") end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Arcanist:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self)
		if not ArcanistConfig.ArcanistLockServ then
			Arcanist:OnDragStart(self)
		end
	end)
	frame:SetScript("OnDragStop", function(self) Arcanist:OnDragStop(self) end)

	-- Create a place for text
	local FontString = _G[b.f.."Text"]
	if not FontString then
		FontString = frame:CreateFontString(b.f, nil, "GameFontNormal")
	end

	-- Hidden but very useful...
	frame.high_of = button
	frame.font_string = FontString

	-- Define its attributes
	FontString:SetText("") -- blank for now
	FontString:SetPoint("CENTER")

	-- Place the button window at its saved location
	if not ArcanistConfig.ArcanistLockServ then
		frame:ClearAllPoints()
		frame:SetPoint(
			ArcanistConfig.FramePosition[frame:GetName()][1],
			ArcanistConfig.FramePosition[frame:GetName()][2],
			ArcanistConfig.FramePosition[frame:GetName()][3],
			ArcanistConfig.FramePosition[frame:GetName()][4],
			ArcanistConfig.FramePosition[frame:GetName()][5]
		)
	end

	return frame
end


------------------------------------------------------------------------------------------------------
-- MENU BUTTONS (buffs menu, ports menu, etc)
------------------------------------------------------------------------------------------------------

local function CreateMenuButton(button)
	-- Create a Menu (Open/Close) button
	local b = button
	local frame = CreateFrame("Button", b.f, UIParent, "SecureHandlerAttributeTemplate SecureHandlerClickTemplate SecureHandlerEnterLeaveTemplate")

	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateMenuButton"
		.." i'"..tostring(button).."'"
		.." b'"..tostring(b.f).."'"
		--.." tn'"..tostring(b.norm).."'"
		--.." th'"..tostring(b.high).."'"
		)
	end

	-- Define its attributes
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetWidth(34)
	frame:SetHeight(34)
	frame:SetNormalTexture(b.norm)
	frame:SetHighlightTexture(b.high)
	frame:RegisterForDrag("LeftButton")
	frame:RegisterForClicks("AnyUp")
	frame:Show()

	-- Edit the scripts associated with the button
	frame:SetScript("OnEnter", function(self) Arcanist:BuildButtonTooltip(self) end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Arcanist:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self)
		--if not ArcanistConfig.ArcanistLockServ then
			Arcanist:OnDragStart(self)
		--end
	end)
	frame:SetScript("OnDragStop", function(self) Arcanist:OnDragStop(self) end)

	-- Place the button window at its saved location
	if not ArcanistConfig.ArcanistLockServ then
		frame:ClearAllPoints()
		frame:SetPoint(
			ArcanistConfig.FramePosition[frame:GetName()][1],
			ArcanistConfig.FramePosition[frame:GetName()][2],
			ArcanistConfig.FramePosition[frame:GetName()][3],
			ArcanistConfig.FramePosition[frame:GetName()][4],
			ArcanistConfig.FramePosition[frame:GetName()][5]
		)
	end

	return frame
end

function Arcanist:CreateMenuItem(i)
	local b = nil
	-- look up the button info
	for idx, v in pairs (Arcanist.Mage_Buttons) do
		if idx == i.f_ptr then
			b = v
			break
		else
		end
	end
	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateMenuItem"
		.." i'"..tostring(i.f_ptr).."'"
		.." b'"..tostring(b.f).."'"
		.." bt'"..tostring(b.tip).."'"
		.." ih'"..tostring(i.high_of).."'"
		.." s'"..tostring(Arcanist:GetSpellName(i.high_of)).."'"
		)
	end

	-- Create the button
	local frame = _G[b.f]
	if not frame then
		frame = CreateFrame("Button", b.f, UIParent, "SecureActionButtonTemplate")

		-- Definition of its attributes
		frame:SetMovable(true)
		frame:EnableMouse(true)
		frame:SetWidth(40)
		frame:SetHeight(40)
		frame:SetHighlightTexture(b.high)
		frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

		-- ======  hidden but effective
		-- Add valuable data to the frame for retrieval later
		frame.high_of = i.high_of

		-- Set the tooltip label to the localized name if not given one already
		Arcanist.TooltipData[b.tip].Label = White(Arcanist.GetSpellName(i.high_of))
	end

	frame:SetNormalTexture(b.norm)
	frame:Hide()

	-- Edit the scripts associated with the button
	frame:SetScript("OnEnter", function(self) Arcanist:BuildButtonTooltip(self) end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)

	--============= Special settings per button
	--
	-- Special attributes for casting certain buffs
	if i == "arcane_intellect" then
		frame:SetScript("PreClick", function(self)
			if not (InCombatLockdown() or UnitIsFriend("player","target")) then
				self:SetAttribute("unit", "player")
			end
		end)
		frame:SetScript("PostClick", function(self)
			if not InCombatLockdown() then
				self:SetAttribute("unit", "target")
			end
		end)
	end

	return frame
end

------------------------------------------------------------------------------------------------------
-- CREATE BUTTONS ON DEMAND
------------------------------------------------------------------------------------------------------
function Arcanist:CreateSphereButtons(button_info)
	if Arcanist.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateSphereButtons"
		.." f'"..tostring(button_info.f).."'"
		)
	end
	if button_info.menu then
		return CreateMenuButton(button_info)
	else
		return CreateButton(button_info)
	end
end
