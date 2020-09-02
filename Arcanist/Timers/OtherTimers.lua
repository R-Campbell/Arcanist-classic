--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]

-- We define _G as being the array containing all the existing frames.
local _G = getfenv(0)

------------------------------------------------------------------------------------------------------
-- NON-GRAPHICAL TIMERS FUNCTIONS
------------------------------------------------------------------------------------------------------
-- Allows the viewing of recorded timers
-- and other textual timers
-- Allows the posting of text timers
function Arcanist:TextTimerUpdate(SpellTimer, SpellGroup)
	if not SpellTimer[1] then
		ArcanistListSpells:SetText("")
		return
	end

	local Now = floor(GetTime())
	local minutes = 0
	local seconds = 0
	local display = ""

	local LastGroup = 0

	for index in ipairs(SpellTimer) do
		-- Change color according to the remaining time
		local percent = (floor(SpellTimer[index].TimeMax - Now) / SpellTimer[index].Time)*100
		local color = ArcanistTimerColor(percent)

		-- Display of the header if we change group
		if not (SpellTimer[index].Group == LastGroup) and SpellTimer[index].Group > 3 then
			if SpellTimer[index].Group and SpellGroup[SpellTimer[index].Group] then
				if SpellGroup[SpellTimer[index].Group].Name then
					display = display.."<purple>-------------------------------\n"
					display = display..SpellGroup[SpellTimer[index].Group].Name
					display = display.." - "
					display = display..SpellGroup[SpellTimer[index].Group].SubName
					display = display.."\n-------------------------------<close>\n<white>"
				end
			end
			LastGroup = SpellTimer[index].Group
		end

		-- Display of the remaining time
		seconds = SpellTimer[index].TimeMax - Now
		minutes = floor(seconds/60);
		seconds = mod(seconds, 60)
		if (minutes > 0) then
			if (minutes > 9) then
				display = display..minutes..":"
			else
				display = display.."0"..minutes..":"
			end
		else
			display = display.."0:"
		end
		if (seconds > 9) then
			display = display..seconds
		else
			display = display.."0"..seconds
		end
		display = display.." - <close>"..color..SpellTimer[index].Name.."<close>"

		if (SpellTimer[index].Target == nil) then
			SpellTimer[index].Target = "";
		end

		if (SpellTimer[index].Type == 1)
			and not (SpellTimer[index].Target == "")
			then
				display = display.."<white> - "..SpellTimer[index].Target.."<close>\n";
		else
			display = display.."\n";
		end
	end
	display = self:MsgAddColor(display)
	ArcanistListSpells:SetText(display)
end