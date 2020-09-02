--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- Get a reference to the global env variable containing all the frames
local _G = getfenv(0)

local function OutputGroup(SpellGroup, index, msg)
	if Arcanist.Debug.timers then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("OGroup::"
		.." '"..(tostring(msg) or "null").."'"
		.." i'"..(tostring(index) or "null").."'"
		.." n'"..(tostring(SpellGroup[index].Name) or "null").."'"
		.." sn'"..(tostring(SpellGroup[index].SubName) or "null").."'"
		.." tg'"..(tostring(SpellGroup[index].TargetGUID) or "null").."'"
		.." v'"..(tostring(SpellGroup[index].Visible) or "null").."'"
		.." t'"..(tostring(SpellGroup[index].Text) or "null").."'"
		)
	end
end
------------------------------------------------------------------------------------------------------
-- FUNCTIONS FOR CREATION OF FRAMES
------------------------------------------------------------------------------------------------------

--Creation of headers for timer groups
local function CreateGroup(SpellGroup, index)

	local text = ""
	if _G["ArcanistSpellTimer"..index] then
		local f = _G["ArcanistSpellTimer"..index]
		local FontString = _G["ArcanistSpellTimer"..index.."Text"]
		if SpellGroup[index] and SpellGroup[index].Name then
			text = SpellGroup[index].Name
		else
			text = "?"
		end
		if SpellGroup[index] and SpellGroup[index].SubName then
			text = text.." - "..SpellGroup[index].SubName
		else
			text = text.." - ?"
		end
		if text == "? - ?" then
			f:Hide()
		else
			FontString:SetText(text)
			f:Show()
		end
		return f
	end

	local FrameName = "ArcanistSpellTimer"..index
	local frame = CreateFrame("Frame", FrameName, UIParent)

	--Definition of its attributes
	frame:SetWidth(150)
	frame:SetHeight(10)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 3000, 3000)
	frame:Show()

	-- Definition of the text frame
	local FontString = frame:CreateFontString(FrameName.."Text", "OVERLAY", "TextStatusBarText")

	FontString:SetWidth(150)
	FontString:SetHeight(10)
	FontString:SetJustifyH("CENTER")
	FontString:SetJustifyV("MIDDLE")
	FontString:SetTextColor(1, 1, 1)
	FontString:ClearAllPoints()
	FontString:SetPoint("LEFT", FrameName, "LEFT", 0, 0)
	FontString:Show()

	-- Definition of the text
	if SpellGroup[index] and SpellGroup[index].Name then
		text = SpellGroup[index].Name
	else
		text = "?"
	end
	if SpellGroup[index] and SpellGroup[index].SubName then
		text = text.." - "..SpellGroup[index].SubName
	else
		text = text.." - ?"
	end

	if text == "? - ?" then
		frame:Hide()
	else
		FontString:SetText(text)
		frame:Show()
	end


	OutputGroup(SpellGroup, index, "create")

	return frame
end

-- Creation of the timers
function Arcanist:AddFrame(FrameName)

	if _G[FrameName] then
		f = _G[FrameName]
		f:ClearAllPoints()
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		f:Show()
		return _G[FrameName.."Text"], _G[FrameName.."Bar"]
	end

	-- Creation of the main timer frame
	local frame = CreateFrame("Frame", FrameName, UIParent)

	-- Definition of its attributes
	frame:SetWidth(150)
	frame:SetHeight(10)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 3000, 3000)
	frame:Show()

	-- Definition of its texture
	local texture = frame:CreateTexture(FrameName.."Texture", "BACKGROUND")

	texture:SetWidth(150)
	texture:SetHeight(10)
	texture:SetTexture(0, 0, 0, 0.5)
	texture:ClearAllPoints()
	texture:SetPoint(ArcanistConfig.SpellTimerJust, FrameName, ArcanistConfig.SpellTimerJust, 0, 0)
	texture:Show()

	-- Definition of its texts
	-- Outside
	local FontString = frame:CreateFontString(FrameName.."OutText", "OVERLAY", "TextStatusBarText")

	FontString:SetWidth(150)
	FontString:SetHeight(10)
	FontString:SetTextColor(1, 1, 1)
	FontString:ClearAllPoints()

	if ArcanistConfig.SpellTimerPos == -1 then
		FontString:SetPoint("RIGHT", FrameName, "LEFT", -5, 1)
		FontString:SetJustifyH("RIGHT")
	else
		FontString:SetPoint("LEFT", FrameName, "RIGHT", 5, 1)
		FontString:SetJustifyH("LEFT")
	end
	FontString:Show()


	-- Definition of its texts
	-- Inside
	FontString = frame:CreateFontString(FrameName.."Text", "OVERLAY", "GameFontNormalSmall")

	FontString:SetWidth(150)
	FontString:SetHeight(10)
	FontString:SetJustifyH("LEFT")
	FontString:SetJustifyV("MIDDLE")
	FontString:ClearAllPoints()
	FontString:SetPoint("LEFT", FrameName, "LEFT", 0, 0)
	FontString:Show()

	FontString:SetTextColor(1, 1, 1)

	-- Definition of the colored bar
	local StatusBar = CreateFrame("StatusBar", FrameName.."Bar", frame)

	StatusBar:SetWidth(150)
	StatusBar:SetHeight(10)
	StatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	StatusBar:SetStatusBarColor(1, 1, 0)
	StatusBar:SetFrameLevel(StatusBar:GetFrameLevel() - 1)
	StatusBar:ClearAllPoints()
	StatusBar:SetPoint(ArcanistConfig.SpellTimerJust, FrameName, ArcanistConfig.SpellTimerJust, 0, 0)
	StatusBar:Show()

	-- Definition of the spark at the end of the bar
	texture = StatusBar:CreateTexture(FrameName.."Spark", "OVERLAY")

	texture:SetWidth(32)
	texture:SetHeight(32)
	texture:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	texture:SetBlendMode("ADD")
	texture:ClearAllPoints()
	texture:SetPoint("CENTER", StatusBar, "LEFT", 0, 0)
	texture:Show()

	return FontString, StatusBar
end


------------------------------------------------------------------------------------------------------
-- FUNCTIONS TO UPDATE THE DISPLAY
------------------------------------------------------------------------------------------------------

function ArcanistUpdateTimer(timerTable, Change)
	if not (ArcanistConfig.TimerType == 1 and timerTable[1]) then
		return
	end

	local LastPoint = {}
	LastPoint[1], LastPoint[2], LastPoint[3], LastPoint[4], LastPoint[5] = ArcanistTimerFrame0:GetPoint()
	local LastGroup = 0

	local yPosition = - ArcanistConfig.ListDirection * 12

	-- smooth timers (if selected)
	local Now
	if ArcanistConfig.Smooth then
		Now = GetTime()
	else
		Now = floor(GetTime())
	end

	for index =  1, #timerTable, 1 do
		-- When we switch from text timers to graphic timers
		if not timerTable[index].Gtimer then break end

		-- selection of frames timer that vary with time
		local Frame = _G["ArcanistTimerFrame"..timerTable[index].Gtimer]
		local StatusBar = _G["ArcanistTimerFrame"..timerTable[index].Gtimer.."Bar"]
		local Spark = _G["ArcanistTimerFrame"..timerTable[index].Gtimer.."Spark"]
		local Text = _G["ArcanistTimerFrame"..timerTable[index].Gtimer.."OutText"]

		-- move frames to ensure they dont overlap
		if Change then
			-- if the frame belongs to a mob group, then move the whole group
			if not (timerTable[index].Group == LastGroup) and timerTable[index].Group > 3 then
				local f = CreateGroup(Change, timerTable[index].Group)
				LastPoint[5] = LastPoint[5] + 1.2 * yPosition
				f:ClearAllPoints()
				f:SetPoint(LastPoint[1], LastPoint[2], LastPoint[3], LastPoint[4], LastPoint[5])
				LastPoint[5] = LastPoint[5] + 0.2 * yPosition
				LastGroup = timerTable[index].Group
			end
			Frame:ClearAllPoints()
			LastPoint[5] = LastPoint[5] + yPosition
			Frame:SetPoint(LastPoint[1], LastPoint[2], LastPoint[3], LastPoint[4], LastPoint[5])
		end

		-- creation of color timers
		local r, g
		local b = 37/255
		local b_end = timerTable[index].TimeMax -- timerTable[index].MaxBar timerTable[index].TimeMax
		local PercentColor = (b_end - Now) / timerTable[index].Time
		if PercentColor > 0.5 then
			r = (207/255) - (1 - PercentColor) * 2 * (207/255)
			g = 1
		else
			r = 1
			g = (207/255) - (0.5 - PercentColor) * 2 * (207/255)
		end

		-- calculate the position of the spark on the timer
		local sparkPosition = 150 * (b_end - Now) / timerTable[index].Time
		if sparkPosition < 1 then sparkPosition = 1 end

		-- set the color and determine the portion to be filled
		StatusBar:SetValue(2 * b_end - (timerTable[index].Time + Now))
		StatusBar:SetStatusBarColor(r, g, b)
		Spark:ClearAllPoints()
		Spark:SetPoint("CENTER", StatusBar, "LEFT", sparkPosition, 0)

		-- update the clock value on the timer
		local minutes, seconds, display = 0, 0, nil
		seconds = b_end - floor(GetTime())
		minutes = floor(seconds / 60 )
		seconds = math.fmod(seconds, 60)

		if minutes > 9 then
			display = minutes..":"
		elseif minutes > 0 then
			display = "0"..minutes..":"
		else
			display = "0:"
		end

		if seconds > 9 then
			display = display..seconds
		else
			display = display.."0"..seconds
		end

		if (timerTable[index].Type == 1 or timerTable[index].Type == 3
		and timerTable[index].Target and not (timerTable[index].Target == "")) then
			if ArcanistConfig.SpellTimerPos == 1 then
				display = display.." - "..timerTable[index].Target
			else
				display = timerTable[index].Target.." - "..display
			end
		end

		Text:SetText(display)
	end
end