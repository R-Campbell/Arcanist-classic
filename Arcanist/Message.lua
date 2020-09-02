--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- One defines G as being the table containing all the existing frames.
local _G = getfenv(0)

------------------------------------------------------------------------------------------------------
-- Message handler (CONSOLE, CHAT, MESSAGE SYSTEM)
------------------------------------------------------------------------------------------------------
--[[ As of Sep 2019, SendChatMessage was made hardware protected to public channels
- SAY/YELL seems hardware event protected while outdoors but not inside instances/raids
- public channels require hw events outdoors/indoors
- WHISPER is unaffected
--]]
function Arcanist:Msg(msg, type)
	if msg then
		inInstance, _ = IsInInstance()

		-- dispatch the message to the appropriate chat channel depending on the message type
		if (type == "WORLD") then
			local groupMembersCount = GetNumGroupMembers()
			if (groupMembersCount > 5) then
				-- send to all raid members
				SendChatMessage(msg, "RAID")
			elseif (groupMembersCount > 0) then
				-- send to party members
				SendChatMessage(msg, "PARTY")
			else
				-- not in a group so lets use the 'say' channel
				if (inInstance) then SendChatMessage(msg, "SAY") end
			end
		elseif (type == "PARTY") then
			SendChatMessage(msg, "PARTY")
		elseif (type == "RAID") then
			SendChatMessage(msg, "RAID")
		elseif (type == "SAY") then
			if (inInstance) then SendChatMessage(msg, "SAY") end
		elseif (type == "EMOTE") then
			if (inInstance) then SendChatMessage(msg, "EMOTE") end
		elseif (type == "YELL") then
			if (inInstance) then SendChatMessage(msg, "YELL") end
		else
			-- Add some color to our message :D
			msg = self:MsgAddColor(msg)
			local Intro = "|CFF1414FFAr|CFF2727FFca|CFF3B3BFFni|CFF4E4EFFst|CFFFFFFFF: "..msg.."|r"
			if ArcanistConfig.ChatType then
				-- ...... on the first chat frame
				ChatFrame1:AddMessage(Intro, 1.0, 0.7, 1.0, 1.0, UIERRORS_HOLD_TIME)
			else
				-- ...... on the middle of the screen
				UIErrorsFrame:AddMessage(Intro, 1.0, 0.7, 1.0, 1.0, UIERRORS_HOLD_TIME)
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Color functions
------------------------------------------------------------------------------------------------------

-- Replace any color strings in the message with its associated value
function Arcanist:MsgAddColor(msg)
	if type(msg) == "string" then
		msg = msg:gsub("<white>", "|CFFFFFFFF")
		msg = msg:gsub("<lightBlue>", "|CFF99CCFF")
		msg = msg:gsub("<brightGreen>", "|CFF00FF00")
		msg = msg:gsub("<lightGreen2>", "|CFF66FF66")
		msg = msg:gsub("<lightGreen1>", "|CFF99FF66")
		msg = msg:gsub("<yellowGreen>", "|CFFCCFF66")
		msg = msg:gsub("<lightYellow>", "|CFFFFFF66")
		msg = msg:gsub("<darkYellow>", "|CFFFFCC00")
		msg = msg:gsub("<lightOrange>", "|CFFFFCC66")
		msg = msg:gsub("<dirtyOrange>", "|CFFFF9933")
		msg = msg:gsub("<darkOrange>", "|CFFFF6600")
		msg = msg:gsub("<redOrange>", "|CFFFF3300")
		msg = msg:gsub("<red>", "|CFFFF0000")
		msg = msg:gsub("<lightRed>", "|CFFFF5555")
		msg = msg:gsub("<lightPurple1>", "|CFFFFC4FF")
		msg = msg:gsub("<lightPurple2>", "|CFFFF99FF")
		msg = msg:gsub("<purple>", "|CFFFF50FF")
		msg = msg:gsub("<darkPurple1>", "|CFFFF00FF")
		msg = msg:gsub("<darkPurple2>", "|CFFB700B7")
		msg = msg:gsub("<close>", "|r")
	end
	return msg
end

-- Adjusts the timer color based on the percentage of time left.
function ArcanistTimerColor(percent)
	local color = "<brightGreen>"
	if (percent < 10) then
		color = "<red>"
	elseif (percent < 20) then
		color = "<redOrange>"
	elseif (percent < 30) then
		color = "<darkOrange>"
	elseif (percent < 40) then
		color = "<dirtyOrange>"
	elseif (percent < 50) then
		color = "<darkYellow>"
	elseif (percent < 60) then
		color = "<lightYellow>"
	elseif (percent < 70) then
		color = "<yellowGreen>"
	elseif (percent < 80) then
		color = "<lightGreen1>"
	elseif (percent < 90) then
		color = "<lightGreen2>"
	end
	return color
end

------------------------------------------------------------------------------------------------------
-- Replace user-friendly string variables in the invocation messages
------------------------------------------------------------------------------------------------------
function Arcanist:MsgReplace(msg, target)
	msg = msg:gsub("<player>", UnitName("player"))
	msg = msg:gsub("<emote>", "")
	msg = msg:gsub("<after>", "")
	msg = msg:gsub("<sacrifice>", "")
	msg = msg:gsub("<yell>", "")
	if target then
		msg = msg:gsub("<target>", target)
	end

	if Arcanist.Debug.speech then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("MsgReplace"
		.." '"..(tostring(msg) or "null").."'"
		)
	end

	return msg
end

local function Out(msg)
	Arcanist:Msg(msg)
end
------------------------------------------------------------------------------------------------------
-- Handles the posting of messages while casting a spell.
------------------------------------------------------------------------------------------------------
-- TODO: Add speech for creating portal
function Arcanist:Speech_It(Spell, Speeches, metatable)
	return
end

------------------------------------------------------------------------------------------------------
-- Handles the posting of messages after a spell has been cast.
------------------------------------------------------------------------------------------------------
-- TODO: Add speech for creating portal
function Arcanist:Speech_Then(Spell, Speech)
	return
end
