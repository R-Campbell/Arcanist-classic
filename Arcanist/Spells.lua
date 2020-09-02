--[[
    Arcanist
    Copyright (C) - copyright file included in this release
--]]
local L = LibStub("AceLocale-3.0"):GetLocale(ARCANIST_ID, true)

local new, del
do
	local cache = setmetatable({}, {__mode='k'})
	function new(populate, ...)
		local tbl
		local t = next(cache)
		if ( t ) then
			cache[t] = nil
			tbl = t
		else
			tbl = {}
		end
		if ( populate ) then
			local num = select("#", ...)
			if ( populate == "hash" ) then
				assert(math.fmod(num, 2) == 0)
				local key
				for i = 1, num do
					local v = select(i, ...)
					if not ( math.fmod(i, 2) == 0 ) then
						key = v
					else
						tbl[key] = v
						key = nil
					end
				end
			elseif ( populate == "array" ) then
				for i = 1, num do
					local v = select(i, ...)
					table.insert(tbl, i, v)
				end
			end
		end
		return tbl
	end
	function del(t)
		for k in next, t do
			t[k] = nil
		end
		cache[t] = true
	end
end
--[==[ Arcanist tables
Translation items are in Dialog.lua!

This file and Dialog.lua are the two places WoW ids are specified. Then short names, localized names, or passed ids are used.

These include item names and labels set manual and programmatic.
Notes:
- Translation strings are held via a mix of variables in Dialog and Spells (this file).
   The rule of thumb is items, labels, and 'dialog' to the player are in Dialog; spell info in Spells
- The code to set them is in Arcanist as part of the initialization code.

There are 4 main tables that form the basis of Arcanist:
- Mage_Spells
- Mage_Buttons
- Mage_Lists
- Mage_Spell_Use

Note: Spell lists are in this file. This keeps them in one, maintainable place.

::: Mage_Spells
Specifies all the mage spells we process (and more).

::: Mage_Lists
This table hold various lists needed; importantly it specifies the button order and grouping of the Arcanist buttons;
it also holds other lists that are explained in comments inside the table.

::: Mage_Buttons
Holds the frame information of the Arcanist buttons

::: Mage_Spell_Use
This table holds ALL the mage spells listed in Mage_Spells. Names of some spells are needed even if not known by the mage.
This table is created on the fly at initialization and rebuilt when spells are learned or changed.
Use IsSpellKnown below to determine if a spell is known / in the spell book.

======
The set of tables allows the highest spells of a type to be gathered and referenced easily using a 'usage' string id, such as "armor".
There is no need to remember spell ids or table indexes.

A group of helper routines are at the bottom of this file to get get spell info, see if a spell is known, and more.
These encapsulates the rather long statements to get data.

Basing the spells on WoW ids and 'usage' allows spell info to be localized automatically without relying on manual translations.
The UsageRank abstracts what highest means and eliminates a lot of hard coding. An example is Demon Skin becoming Demon Armor.

--]==]
--[===[ ::: Add a new spell to existing list
To add a new spell do the following:

Mage_Spells
- Add the spell by id, including all its levels
- Set the UsageRank and SpellRank manually
- Set Usage to link to lists (Mage_Lists)
- Set the Type depending on what, if any timer, is needed.
- Set Length and Cooldown if Timer

Mage_Buttons
- Create a button entry for the spell
- Set the index (short name) which will be used in Mage_Lists
- Set Tip for tool tip in Arcanist.lua
- Set anchor, relative to its
- Set the texture norm; high / push if needed; New files in /UI may need to created

Mage_Lists
- Determine which list it will be in
- Set f_ptr to the button short name
- Set high_of the same as Usage in Mage_Spells

TooltipData (Dialog.lua)
- Add an entry whose index is the same as tip in Mage_Buttons
- Add a Label entry under index
- Add Text / Text2 / Ritual as needed; these are hard coded into BuildButtonTooltip in Arcanist.lua
   Update localization files for any new strings

Other
- Look at Attributes.lua to see if the right attributes would be set for the new spell.
--]===]

--[===[ ::: Add a new menu
To add a new menu do the following:
- Follow steps to add new spell(s) (above) for the new menu - Mage_Spells / Mage_Buttons / TooltipData

Mage_Buttons
- Create a button entry for the menu
- Set the index (short name) which will be used in Warlok_Lists
- Set f to the frame name to use. This needs to unique across all frames. using Arcanist as a prefix is a good start.
   This is NOT used for any logic, that the names include numbers is a hold over to original coding.
- Set Tip for tool tip in Arcanist.lua
- Set anchor, relative to its
- Set the texture norm; high / push if needed; New files in UI may need to be created for graphics
- Set menu so any special logic can be added
   Check other menu values to see where the logic needs to be, especially XML.lua

Mage_Lists:
- Add an entry to "on_sphere" for the new menu; set menu to new entry in Mage_Lists
- Add a entry to hold spells (copy buffs as an example)
- Add an entry for each spell in the menu
- For each spell in the menu - Set f_ptr to the button short name
- For each spell in the menuSet high_of the same as Usage in Mage_Spells

Arcanist.TooltipData (Dialog.lua)
- Add an entry whose index is the same as tip for the menu in Mage_Buttons
- Add a Label entry under index
- Add Text / Text2 / Ritual as needed; these are hard coded into BuildButtonTooltip in Arcanist.lua
   Update localization files for any new strings

Other
- Look at Attributes.lua to see if the right attributes would be set for the new spell buttons and menu button.
   New routines may be needed.
- Look at Local.DefaultConfig- add the new buttons with default positions
- Look at option code in XML folder. Likely new options or check boxes will be needed
--]===]

--========================================================
--[[ Mage_Spell_Use
Fields
- index is string and are the same values as Usage in Mage_Spells.

Built on the fly on at initialize / spell change.
By 'Usage', will contain highest id of each 'Usage' known by the mage or the 'lowest' if not known
--]]
Arcanist.Mage_Spell_Use = {}

--[[ Mage_Spells
 This table lists the spells used by Arcanist with rank. To Get Ids Use: https://classicdb.ch and GetItemInfo.

 The API to return spell info does NOT return the rank which sucks BIG time so this table will
 hard code them.
 This is the overall list, the player spell book will also be parsed.

Fields:
- The index is the spell ID. GetSpellInfo is used to pull the localized name.
- SpellRank: The spell rank was added by hand based on the spell id. NOTE: The rank returned by GetSpellInfo is always nil...
- UsageRank: allows spells of different names to ranked appropriately. Creating mana stones and frost / ice armor
- Usage: is the link to the other tables.
- Timer: true / false whether a timer is desired
Note: As of 7.2, some timers were made selectable (optional) by users. They are in the config / saved variables
- Length / Cooldown / Group are used to create timers
Added fields by code:
- Name: localized spell name from GetSpellBookItemName
- Rank: localized spell rank from GetSpellBookItemName
- CastName: made from <Name>(<Rank>)
- Mana: Cost from GetSpellPowerCost
- InSpellBook: true if found in the player spell book

Notes:
- Created stones are looked for by localized name. The name does NOT include the rank / quality of the stone.
  The stone ids & links are provided but may not be used in the code

Timers:
Spell timers have different aspects:
- Cool down: Can NOT be canceled
- Duration - Buff: Can be canceled manually or by losing aura
- Duration - Spell: Can be canceled by losing aura or dropping out of combat
- Removal - casting: When cast what needs to be removed?
   - Always remove a timer with same Usage AND same target
- Removal - aura:
   - Always remove a timer with same Usage AND same target
   - This will handle curses (one per target)

Notes:
- Banish could be treated as spell or buff duration. WoW calls it a buff.
- For cross spell interaction such as curses (one per target)
  rely on events to remove the spell by name (SPELL_AURA_REMOVED);
  meaning the addon does not have to code this!


--]]
Arcanist.Mage_Spells = {
	-- Conjure Food
	[587] = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "conjure_food"}, -- muffins - https://classicdb.ch/?spell=587 - https://classicdb.ch/?item=5349
	[8736] = {UsageRank = 2, SpellRank = 1, Timer = false, Usage = "conjure_food"}, -- muffins - https://classicdb.ch/?spell=8736 - https://classicdb.ch/?item=5349
	[597] = {UsageRank = 3, SpellRank = 2, Timer = false, Usage = "conjure_food"}, -- bread - https://classicdb.ch/?spell=597 - https://classicdb.ch/?item=1113
	[990] = {UsageRank = 4, SpellRank = 3, Timer = false, Usage = "conjure_food"}, -- rye - https://classicdb.ch/?spell=990 - https://classicdb.ch/?item=1114
	[6129] = {UsageRank = 5, SpellRank = 4, Timer = false, Usage = "conjure_food"}, -- pumpernickel - https://classicdb.ch/?spell=6129 - https://classicdb.ch/?item=1487
	[10144] = {UsageRank = 6, SpellRank = 5, Timer = false, Usage = "conjure_food"}, -- sourdough - https://classicdb.ch/?spell=10144 - https://classicdb.ch/?item=8075
	[10145] = {UsageRank = 7, SpellRank = 6, Timer = false, Usage = "conjure_food"}, -- sweet roll - https://classicdb.ch/?spell=10145 - https://classicdb.ch/?item=8076
	[28612] = {UsageRank = 8, SpellRank = 7, Timer = false, Usage = "conjure_food"}, -- cinnamon roll - https://classicdb.ch/?spell=28612 - https://classicdb.ch/?item=22895

	-- Conjure Water
	[5504] = {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "conjure_water"}, -- water - https://classicdb.ch/?spell=5504 - https://classicdb.ch/?item=5350
	[5505] = {UsageRank = 2, SpellRank = 2, Timer = false, Usage = "conjure_water"}, -- fresh water - https://classicdb.ch/?spell=5505 - https://classicdb.ch/?item=2288
	[5506] = {UsageRank = 3, SpellRank = 3, Timer = false, Usage = "conjure_water"}, -- purified water - https://classicdb.ch/?spell=5506 - https://classicdb.ch/?item=2136
	[6127] = {UsageRank = 4, SpellRank = 4, Timer = false, Usage = "conjure_water"}, -- spring water - https://classicdb.ch/?spell=6127 - https://classicdb.ch/?item=3772
	[10138] = {UsageRank = 5, SpellRank = 5, Timer = false, Usage = "conjure_water"}, -- mineral water - https://classicdb.ch/?spell=10138 - https://classicdb.ch/?item=8077
	[10139] = {UsageRank = 6, SpellRank = 6, Timer = false, Usage = "conjure_water"}, -- sparkling water - https://classicdb.ch/?spell=10139 - https://classicdb.ch/?item=8078
	[10140] = {UsageRank = 7, SpellRank = 7, Timer = false, Usage = "conjure_water"}, -- crystal water - https://classicdb.ch/?spell=10140 - https://classicdb.ch/?item=8079

	-- Conjure Mana *
	[759] = { UsageRank = 1, SpellRank = 1, Timer = false, Usage = "conjure_mana_agate" }, -- mana agate - https://classicdb.ch/?spell=759 - https://classicdb.ch/?item=5514
	[3552] = { UsageRank = 1, SpellRank = 1, Timer = false, Usage = "conjure_mana_jade" }, -- mana jade - https://classicdb.ch/?spell=3552 - https://classicdb.ch/?item=5513
	[10053] = { UsageRank = 1, SpellRank = 1, Timer = false, Usage = "conjure_mana_citrine" }, -- mana citrine - https://classicdb.ch/?spell=10053 - https://classicdb.ch/?item=8007
	[10054] = { UsageRank = 1, SpellRank = 1, Timer = false, Usage = "conjure_mana_ruby" }, -- mana ruby - https://classicdb.ch/?spell=10054 - https://classicdb.ch/?item=8008

	-- Ports
	[3565]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "teleport_darnassus", reagent = "rune_of_teleportation"}, -- teleport: darnassus - https://classicdb.ch/?spell=3565 - https://classicdb.ch/?item=17031
	[3562]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "teleport_ironforge", reagent = "rune_of_teleportation"}, -- teleport: ironforge - https://classicdb.ch/?spell=3562 - https://classicdb.ch/?item=17031
	[3561]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "teleport_stormwind", reagent = "rune_of_teleportation"}, -- teleport: stormwind - https://classicdb.ch/?spell=3561 - https://classicdb.ch/?item=17031
	[3563]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "teleport_undercity", reagent = "rune_of_teleportation"}, -- teleport: undercity - https://classicdb.ch/?spell=3563 - https://classicdb.ch/?item=17031
	[3567]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "teleport_orgrimmar", reagent = "rune_of_teleportation"}, -- teleport: orgrimmar - https://classicdb.ch/?spell=3567 - https://classicdb.ch/?item=17031
	[3566]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "teleport_thunder_bluff", reagent = "rune_of_teleportation"}, -- teleport: thunder bluff - https://classicdb.ch/?spell=3566 - https://classicdb.ch/?item=17031
	[11419]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "portal_darnassus", reagent = "rune_of_portals"}, -- portal: darnassus - https://classicdb.ch/?spell=11419 - https://classicdb.ch/?item=17032
	[11416]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "portal_ironforge", reagent = "rune_of_portals"}, -- portal: ironforge - https://classicdb.ch/?spell=11416 - https://classicdb.ch/?item=17032
	[10059]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "portal_stormwind", reagent = "rune_of_portals"}, -- portal: stormwind - https://classicdb.ch/?spell=10059 - https://classicdb.ch/?item=17032
	[11418]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "portal_undercity", reagent = "rune_of_portals"}, -- portal: undercity - https://classicdb.ch/?spell=11418 - https://classicdb.ch/?item=17032
	[11417]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "portal_orgrimmar", reagent = "rune_of_portals"}, -- portal: orgrimmar - https://classicdb.ch/?spell=11417 - https://classicdb.ch/?item=17032
	[11420]	= {UsageRank = 1, SpellRank = 1, Timer = false, Usage = "portal_thunder_bluff", reagent = "rune_of_portals"}, -- portal: thunder bluff - https://classicdb.ch/?spell=11420 - https://classicdb.ch/?item=17032

	-- ::: Buffs
	[168] = { name = "Frost Armor", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "ice_armor", Length = 1800, Buff = true },
	[7300] = { name = "Frost Armor", UsageRank = 2, SpellRank = 2, Timer = true, Usage = "ice_armor", Length = 1800, Buff = true },
	[7301] = { name = "Frost Armor", UsageRank = 3, SpellRank = 3, Timer = true, Usage = "ice_armor", Length = 1800, Buff = true },
	[7302] = { name = "Ice Armor", UsageRank = 4, SpellRank = 1, Timer = true, Usage = "ice_armor", Length = 1800, Buff = true },
	[7320] = { name = "Ice Armor", UsageRank = 5, SpellRank = 2, Timer = true, Usage = "ice_armor", Length = 1800, Buff = true },
	[10219] = { name = "Ice Armor", UsageRank = 6, SpellRank = 3, Timer = true, Usage = "ice_armor", Length = 1800, Buff = true },
	[10220] = { name = "Ice Armor", UsageRank = 7, SpellRank = 4, Timer = true, Usage = "ice_armor", Length = 1800, Buff = true },

	[1463] = { name = "Mana Shield", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "mana_shield", Length = 60, Buff = true },
	[8494] = { name = "Mana Shield", UsageRank = 2, SpellRank = 2, Timer = true, Usage = "mana_shield", Length = 60, Buff = true },
	[8495] = { name = "Mana Shield", UsageRank = 3, SpellRank = 3, Timer = true, Usage = "mana_shield", Length = 60, Buff = true },
	[10191] = { name = "Mana Shield", UsageRank = 4, SpellRank = 4, Timer = true, Usage = "mana_shield", Length = 60, Buff = true },
	[10192] = { name = "Mana Shield", UsageRank = 5, SpellRank = 5, Timer = true, Usage = "mana_shield", Length = 60, Buff = true },
	[10193] = { name = "Mana Shield", UsageRank = 6, SpellRank = 6, Timer = true, Usage = "mana_shield", Length = 60, Buff = true },

	[1008] = { name = "Amplify Magic", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "amplify_magic", Length = 600, Buff = true },
	[8455] = { name = "Amplify Magic", UsageRank = 2, SpellRank = 2, Timer = true, Usage = "amplify_magic", Length = 600, Buff = true },
	[10169] = { name = "Amplify Magic", UsageRank = 3, SpellRank = 3, Timer = true, Usage = "amplify_magic", Length = 600, Buff = true },
	[10170] = { name = "Amplify Magic", UsageRank = 4, SpellRank = 4, Timer = true, Usage = "amplify_magic", Length = 600, Buff = true },

	[604] = { name = "Dampen Magic", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "dampen_magic", Length = 600, Buff = true },
	[8450] = { name = "Dampen Magic", UsageRank = 2, SpellRank = 2, Timer = true, Usage = "dampen_magic", Length = 600, Buff = true },
	[8451] = { name = "Dampen Magic", UsageRank = 3, SpellRank = 3, Timer = true, Usage = "dampen_magic", Length = 600, Buff = true },
	[10173] = { name = "Dampen Magic", UsageRank = 4, SpellRank = 4, Timer = true, Usage = "dampen_magic", Length = 600, Buff = true },
	[10174] = { name = "Dampen Magic", UsageRank = 5, SpellRank = 5, Timer = true, Usage = "dampen_magic", Length = 600, Buff = true },

	[1459] = { name = "Arcane Intellect", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "arcane_intellect", Length = 1800, Buff = true },
	[1460] = { name = "Arcane Intellect", UsageRank = 2, SpellRank = 2, Timer = true, Usage = "arcane_intellect", Length = 1800, Buff = true },
	[1461] = { name = "Arcane Intellect", UsageRank = 3, SpellRank = 3, Timer = true, Usage = "arcane_intellect", Length = 1800, Buff = true },
	[10156] = { name = "Arcane Intellect", UsageRank = 4, SpellRank = 4, Timer = true, Usage = "arcane_intellect", Length = 1800, Buff = true },
	[10157] = { name = "Arcane Intellect", UsageRank = 5, SpellRank = 5, Timer = true, Usage = "arcane_intellect", Length = 1800, Buff = true },

	[23028] = { name = "Arcane Brilliance", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "arcane_brilliance", Length = 3600, Buff = true, reagent = "arcane_powder" },

	[6117] = { name = "Mage Armor", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "mage_armor", Length = 1800, Buff = true },
	[22782] = { name = "Mage Armor", UsageRank = 2, SpellRank = 2, Timer = true, Usage = "mage_armor", Length = 1800, Buff = true },
	[22783] = { name = "Mage Armor", UsageRank = 3, SpellRank = 3, Timer = true, Usage = "mage_armor", Length = 1800, Buff = true },

	[6143] = { name = "Frost Ward", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "frost_ward", Length = 30, Cooldown = 30 },
	[8461] = { name = "Frost Ward", UsageRank = 2, SpellRank = 2, Timer = true, Usage = "frost_ward", Length = 30, Cooldown = 30 },
	[8462] = { name = "Frost Ward", UsageRank = 3, SpellRank = 3, Timer = true, Usage = "frost_ward", Length = 30, Cooldown = 30 },
	[10177] = { name = "Frost Ward", UsageRank = 4, SpellRank = 4, Timer = true, Usage = "frost_ward", Length = 30, Cooldown = 30 },
	[28609] = { name = "Frost Ward", UsageRank = 5, SpellRank = 5, Timer = true, Usage = "frost_ward", Length = 30, Cooldown = 30 },

	[543] = { name = "Fire Ward", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "fire_ward", Length = 30, Cooldown = 30 },
	[8457] = { name = "Fire Ward", UsageRank = 2, SpellRank = 2, Timer = true, Usage = "fire_ward", Length = 30, Cooldown = 30 },
	[8458] = { name = "Fire Ward", UsageRank = 3, SpellRank = 3, Timer = true, Usage = "fire_ward", Length = 30, Cooldown = 30 },
	[10223] = { name = "Fire Ward", UsageRank = 4, SpellRank = 4, Timer = true, Usage = "fire_ward", Length = 30, Cooldown = 30 },
	[10225] = { name = "Fire Ward", UsageRank = 5, SpellRank = 5, Timer = true, Usage = "fire_ward", Length = 30, Cooldown = 30 },

	[1953] = { name = "Blink", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "blink", Cooldown = 15 },

	[118] = { name = "Polymorph", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "polymorph", Length = 20, Buff = true },
	[12824] = { name = "Polymorph", UsageRank = 2, SpellRank = 2, Timer = true, Usage = "polymorph", Length = 30, Buff = true },
	[12825] = { name = "Polymorph", UsageRank = 3, SpellRank = 3, Timer = true, Usage = "polymorph", Length = 40, Buff = true },
	[12826] = { name = "Polymorph", UsageRank = 4, SpellRank = 4, Timer = true, Usage = "polymorph", Length = 50, Buff = true },

	[11958] = { name = "Ice Block", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "ice_block", Length = 10, Cooldown = 300 },
	[27619] = { name = "Ice Block", UsageRank = 2, SpellRank = 1, Timer = true, Usage = "ice_block", Length = 10, Cooldown = 300 },

	[12472] = { name = "Cold Snap", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "cold_snap", Cooldown = 600 },

	[11426] = { name = "Ice Barrier", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "ice_barrier", Length = 60, Cooldown = 30 },
	[13031] = { name = "Ice Barrier", UsageRank = 2, SpellRank = 2, Timer = true, Usage = "ice_barrier", Length = 60, Cooldown = 30 },
	[13032] = { name = "Ice Barrier", UsageRank = 3, SpellRank = 3, Timer = true, Usage = "ice_barrier", Length = 60, Cooldown = 30 },
	[13033] = { name = "Ice Barrier", UsageRank = 4, SpellRank = 4, Timer = true, Usage = "ice_barrier", Length = 60, Cooldown = 30 },

	[12051] = { name = "Evocation", UsageRank = 1, SpellRank = 1, Timer = true, Usage = "evocation", Cooldown = 480 },

	-- TODO: figure out what to do with these
	--[[

		[130] = { name = "Slow Fall", reagents = "light_feather" },

		[2855] = { name = "Detect Magic" },

		[28270] = { name = "Polymorph: Cow" },
		[28271] = { name = "Polymorph: Turtle", SpellRank = "Turtle" },
		[28272] = { name = "Polymorph: Pig", SpellRank = "Pig" },
	]]

	-- ::: Spells from using objects: These are spells we look for to create timers. They are not assigned to buttons.
	-- Blizzard has several ids in the DB for each, not sure which are used for Classic...
	-- However, when capturing the event, only the name will used so pick one of listed ids to get the right localized name

	-- Mana gem
	-- When a mana gem is used it could be one of several spells because each gives different mana amounts
	[5514] = { UsageRank = 1, SpellRank = 1, Timer = true, Usage = "mana_agate_used", Result = true, Cooldown = 120, Group = 2 },
	[5513] = { UsageRank = 1, SpellRank = 1, Timer = true, Usage = "mana_jade_used", Result = true, Cooldown = 120, Group = 2 },
	[8007] = { UsageRank = 1, SpellRank = 1, Timer = true, Usage = "mana_citrine_used", Result = true, Cooldown = 120, Group = 2 },
	[8008] = { UsageRank = 1, SpellRank = 1, Timer = true, Usage = "mana_ruby_used", Result = true, Cooldown = 120, Group = 2 },
}
--[[ Mage_Buttons
Frames for the various buttons created and used.
Does NOT include timers and config!

Fields
- index is the same string used for Usage in Mage_Spells.
- f: is the frame name to use. The intent is isolate frame names from usage (such as ...Menu1 through ...Menu9).
- tip: the string reference to the tool tip table.
- menu: The menu 'name', exists only if the frame is used as a menu of buttons.
- anchor: where to anchor the tool tip frame relative to the button.
- norm / high / push: holds the textures to use when creating the frame.

Note: Button name - as a string - are in:
- Initialize.lua to prevent a catch-22 to reference them
- Arcanist.lua config / saved variables for proper referencing
- in config /XML routines as part of anonymous functions

The intention is to use the index to reference the frames rather than coding indexes into the names.
This allows a more flexible scheme and should reduce maintenance and impact if WoW Classic changes over time.
--]]
Arcanist.Mage_Buttons = {
	timer = {
		f = "ArcanistSpellTimerButton",
		tip = "SpellTimer",
		menu = "Timer",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\SpellTimerButton-Normal",
		high = "Interface\\AddOns\\Arcanist\\UI\\SpellTimerButton-Highlight",
		push = "Interface\\AddOns\\Arcanist\\UI\\SpellTimerButton-Pushed",
	},
	main = {
		f = "ArcanistButton",
		tip = "Main",
		anchor = "ANCHOR_LEFT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\Shard",
	},
	hearthstone = {
		f = "ArcanistHearthstoneButton",
		tip = "Hearthstone",
		anchor = "ANCHOR_LEFT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\INV_Misc_Rune_01",
		high = "Interface\\AddOns\\Arcanist\\UI\\INV_Misc_Rune_01",
	},
	conjure_food = {
		f = "ArcanistFoodButton",
		tip = "ConjureFood",
		anchor = "ANCHOR_LEFT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\Food-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\Food-High",
	},
	conjure_water = {
		f = "ArcanistWaterButton",
		tip = "ConjureWater",
		anchor = "ANCHOR_LEFT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\Water-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\Water-High",
	},
	mana = {
		f = "ArcanistManaMenuButton",
		tip = "ManaMenu",
		menu = "Mana",
		norm = "Interface\\AddOns\\Arcanist\\UI\\ManaMenu-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\ManaMenu-High",
	},
	conjure_mana_agate = {
		f = "ArcanistManaMenu01",
		tip = "ConjureManaAgate",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\ManaAgate-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\ManaAgate-High",
	},
	conjure_mana_jade = {
		f = "ArcanistManaMenu02",
		tip = "ConjureManaJade",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\ManaJade-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\ManaJade-High",
	},
	conjure_mana_citrine = {
		f = "ArcanistManaMenu03",
		tip = "ConjureManaCitrine",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\ManaCitrine-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\ManaCitrine-High",
	},
	conjure_mana_ruby = {
		f = "ArcanistManaMenu04",
		tip = "ConjureManaRuby",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\ManaRuby-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\ManaRuby-High",
	},
	ports = {
		f = "ArcanistPortMenuButton",
		tip = "PortMenu",
		menu = "Port",
		norm = "Interface\\AddOns\\Arcanist\\UI\\PortMenu-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\PortMenu-High",
	},
	teleport_darnassus = {
		f = "ArcanistPortMenu01",
		tip = "TeleportDarnassus",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\TeleportDarnassus-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\TeleportDarnassus-High",
	},
	teleport_ironforge = {
		f = "ArcanistPortMenu02",
		tip = "TeleportIronforge",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\TeleportIronforge-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\TeleportIronforge-High",
	},
	teleport_stormwind = {
		f = "ArcanistPortMenu03",
		tip = "TeleportStormwind",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\TeleportStormwind-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\TeleportStormwind-High",
	},
	teleport_undercity = {
		f = "ArcanistPortMenu04",
		tip = "TeleportUndercity",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\TeleportUndercity-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\TeleportUndercity-High",
	},
	teleport_orgrimmar = {
		f = "ArcanistPortMenu05",
		tip = "TeleportOrgrimmar",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\TeleportOrgrimmar-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\TeleportOrgrimmar-High",
	},
	teleport_thunder_bluff = {
		f = "ArcanistPortMenu06",
		tip = "TeleportThunderBluff",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\TeleportThunderBluff-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\TeleportThunderBluff-High",
	},
	portal_darnassus = {
		f = "ArcanistPortMenu07",
		tip = "PortalDarnassus",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\PortalDarnassus-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\PortalDarnassus-High",
	},
	portal_ironforge = {
		f = "ArcanistPortMenu08",
		tip = "PortalIronforge",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\PortalIronforge-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\PortalIronforge-High",
	},
	portal_stormwind = {
		f = "ArcanistPortMenu09",
		tip = "PortalStormwind",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\PortalStormwind-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\PortalStormwind-High",
	},
	portal_undercity = {
		f = "ArcanistPortMenu10",
		tip = "PortalUndercity",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\PortalUndercity-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\PortalUndercity-High",
	},
	portal_orgrimmar = {
		f = "ArcanistPortMenu11",
		tip = "PortalOrgrimmar",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\PortalOrgrimmar-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\PortalOrgrimmar-High",
	},
	portal_thunder_bluff = {
		f = "ArcanistPortMenu12",
		tip = "PortalThunderBluff",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\PortalThunderBluff-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\PortalThunderBluff-High",
	},
	mount = {
		f = "ArcanistMountButton",
		tip = "Mount",
		anchor = "ANCHOR_LEFT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\Mount-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\Mount-High",
	},
	-- Buffs Menu and Buffs
	buffs = {
		f = "ArcanistBuffMenuButton",
		tip = "BuffMenu",
		menu = "Buff",
		norm = "Interface\\AddOns\\Arcanist\\UI\\BuffsMenu-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\BuffsMenu-High",
	},
	arcane_intellect = {
		f = "ArcanistBuffMenu01",
		tip = "ArcaneIntellect",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\ArcaneIntellect-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\ArcaneIntellect-High",
	},
	ice_armor = {
		f = "ArcanistBuffMenu02",
		tip = "IceArmor",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\IceArmor-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\IceArmor-High",
	},
	mage_armor = {
		f = "ArcanistBuffMenu03",
		tip = "MageArmor",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\MageArmor-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\MageArmor-High",
	},
	mana_shield = {
		f = "ArcanistBuffMenu04",
		tip = "ManaShield",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\ManaShield-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\ManaShield-High",
	},
	amplify_magic = {
		f = "ArcanistBuffMenu05",
		tip = "AmplifyMagic",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\AmplifyMagic-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\AmplifyMagic-High",
	},
	dampen_magic = {
		f = "ArcanistBuffMenu06",
		tip = "DampenMagic",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\DampenMagic-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\DampenMagic-High",
	},
	frost_ward = {
		f = "ArcanistBuffMenu07",
		tip = "FrostWard",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\FrostWard-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\FrostWard-High",
	},
	fire_ward = {
		f = "ArcanistBuffMenu08",
		tip = "FireWard",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\FireWard-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\FireWard-High",
	},
	polymorph = {
		f = "ArcanistBuffMenu09",
		tip = "Polymorph",
		anchor = "ANCHOR_RIGHT",
		norm = "Interface\\AddOns\\Arcanist\\UI\\Polymorph-Norm",
		high = "Interface\\AddOns\\Arcanist\\UI\\Polymorph-High",
	},
}

--[=[
This table contains various lists, some that need to ordered.
We could have created the Arcanist buttons via tables IF the buttons had similar actions and structure.
It seemed better to collect the various lists in one place for ease of change.

: Button lists : on_sphere | buffs | ports
- index is numeric and specifies the order frames should be in.
- f_ptr: The frame to use (index to Mage_Buttons)
- high_of: Use the highest of the referenced spell(s). Same values as Usage in Mage_Spells.

--]=]
Arcanist.Mage_Lists = {
	["on_sphere"] = {
		{ f_ptr = "buffs",	menu = "buffs", name = "Buff" },
		{ f_ptr = "mount", item = "mount", name = "Mount" },
		{ f_ptr = "conjure_food", high_of = "conjure_food", name = "ConjureFood" },
		{ f_ptr = "conjure_water", high_of = "conjure_water", name = "ConjureWater" },
		{ f_ptr = "ports", menu = "ports", name = "Port" },
		{ f_ptr = "mana", menu = "mana", name = "Mana" }
	},
	["buffs"] = {
		[1] = { f_ptr = "arcane_intellect", high_of = "arcane_intellect" },
		[2] = { f_ptr = "ice_armor", high_of = "ice_armor" },
		[3] = { f_ptr = "mage_armor", high_of = "mage_armor" },
		[4] = { f_ptr = "mana_shield", high_of = "mana_shield" },
		[5] = { f_ptr = "amplify_magic", high_of = "amplify_magic" },
		[6] = { f_ptr = "dampen_magic", high_of = "dampen_magic" },
		[7] = { f_ptr = "frost_ward", high_of = "frost_ward" },
		[8] = { f_ptr = "fire_ward", high_of = "fire_ward" },
		[9] = { f_ptr = "polymorph", high_of = "polymorph" },
	},
	["ports"] = {
		{ f_ptr = "teleport_darnassus", high_of = "teleport_darnassus", type = "teleport" },
		{ f_ptr = "teleport_ironforge", high_of = "teleport_ironforge", type = "teleport" },
		{ f_ptr = "teleport_stormwind", high_of = "teleport_stormwind", type = "teleport" },
		{ f_ptr = "teleport_undercity", high_of = "teleport_undercity", type = "teleport" },
		{ f_ptr = "teleport_orgrimmar", high_of = "teleport_orgrimmar", type = "teleport" },
		{ f_ptr = "teleport_thunder_bluff", high_of = "teleport_thunder_bluff", type = "teleport" },
		{ f_ptr = "portal_darnassus", high_of = "portal_darnassus", type = "portal" },
		{ f_ptr = "portal_ironforge", high_of = "portal_ironforge", type = "portal" },
		{ f_ptr = "portal_stormwind", high_of = "portal_stormwind", type = "portal" },
		{ f_ptr = "portal_undercity", high_of = "portal_undercity", type = "portal" },
		{ f_ptr = "portal_orgrimmar", high_of = "portal_orgrimmar", type = "portal" },
		{ f_ptr = "portal_thunder_bluff", high_of = "portal_thunder_bluff", type = "portal" },
	},
	["config_main_spell"] = {
		[1] = { high_of = "arcane_intellect" },
		[2] = { high_of = "ice_armor" },
		[3] = { high_of = "mage_armor" },
		[4] = { high_of = "blink" },
		[5] = { high_of = "polymorph" },
	},
	-- Only using ids for comparison. Dialog contains localized strings
	["reagents"] = {
		rune_of_teleportation = { id = 17031, count = 0 }, -- https://classicdb.ch/?item=17031
		rune_of_portals = { id = 17032, count = 0 }, -- https://classicdb.ch/?item=17032
		light_feather = { id = 17056, count = 0 }, -- https://classicdb.ch/?item=17056
		arcane_powder = { id = 17020, count = 0 }, -- https://classicdb.ch/?item=17020
	},
	["conjured_food"] = {
		{ id = 5349, name = "Conjured Muffin" },
		{ id = 1113, name = "Conjured Bread" },
		{ id = 1114, name = "Conjured Rye" },
		{ id = 1487, name = "Conjured Pumpernickel" },
		{ id = 8075, name = "Conjured Sourdough" },
		{ id = 8076, name = "Conjured Sweet Roll" },
		{ id = 22895, name = "Conjured Cinnamon Roll" },
	},
	["conjured_water"] = {
		{ id = 5350, name = "Conjured Water" },
		{ id = 2288, name = "Conjured Fresh Water" },
		{ id = 2136, name = "Conjured Purified Water" },
		{ id = 3772, name = "Conjured Spring Water" },
		{ id = 8077, name = "Conjured Mineral Water" },
		{ id = 8078, name = "Conjured Sparkling Water" },
		{ id = 8079, name = "Conjured Crystal Water" },
	},
	["mana_gems"] = {
		{ f_ptr = "conjure_mana_agate", high_of = "conjure_mana_agate", item_name = "mana_agate" },
		{ f_ptr = "conjure_mana_jade", high_of = "conjure_mana_jade", item_name = "mana_jade" },
		{ f_ptr = "conjure_mana_citrine", high_of = "conjure_mana_citrine", item_name = "mana_citrine" },
		{ f_ptr = "conjure_mana_ruby", high_of = "conjure_mana_ruby", item_name = "mana_ruby" },
	},
	["mounts"] = {
		{ id = 21176, name = "Black Qiraji Resonating Crystal" },
		{ id = 13335, name = "Deathcharger's Reins" },
		{ id = 19902, name = "Swift Zulian Tiger" },
		{ id = 13086, name = "Reins of the Winterspring Frostsaber" },
		{ id = 21321, name = "Red Qiraji Resonating Crystal" },
		{ id = 19029, name = "Horn of the Frostwolf Howler" },
		{ id = 19872, name = "Swift Razzashi Raptor" },
		{ id = 20221, name = "Foror's Fabled Steed" },
		{ id = 21218, name = "Blue Qiraji Resonating Crystal" },
		{ id = 19030, name = "Stormpike Battle Charger" },
		{ id = 23720, name = "Riding Turtle" },
		{ id = 2411, name = "Black Stallion Bridle" },
		{ id = 21324, name = "Yellow Qiraji Resonating Crystal" },
		{ id = 21323, name = "Green Qiraji Resonating Crystal" },
		{ id = 18242, name = "Reins of the Black War Tiger" },
		{ id = 18766, name = "Reins of the Swift Frostsaber" },
		{ id = 2414, name = "Pinto Bridle" },
		{ id = 18776, name = "Swift Palomino" },
		{ id = 18902, name = "Reins of the Swift Stormsaber" },
		{ id = 18767, name = "Reins of the Swift Mistsaber" },
		{ id = 5656, name = "Brown Horse Bridle" },
		{ id = 18778, name = "Swift White Steed" },
		{ id = 5655, name = "Chestnut Mare Bridle" },
		{ id = 18241, name = "Black War Steed Bridle" },
		{ id = 18777, name = "Swift Brown Steed" },
		{ id = 18246, name = "Whistle of the Black War Raptor" },
		{ id = 8629, name = "Reins of the Striped Nightsaber" },
		{ id = 18791, name = "Purple Skeletal Warhorse" },
		{ id = 13317, name = "Whistle of the Ivory Raptor" },
		{ id = 18796, name = "Horn of the Swift Brown Wolf" },
		{ id = 18785, name = "Swift White Ram" },
		{ id = 18793, name = "Great White Kodo" },
		{ id = 1132, name = "Horn of the Timber Wolf" },
		{ id = 18788, name = "Swift Blue Raptor" },
		{ id = 5665, name = "Horn of the Dire Wolf" },
		{ id = 8631, name = "Reins of the Striped Frostsaber" },
		{ id = 8632, name = "Reins of the Spotted Frostsaber" },
		{ id = 18248, name = "Red Skeletal Warhorse" },
		{ id = 13334, name = "Green Skeletal Warhorse" },
		{ id = 18245, name = "Horn of the Black War Wolf" },
		{ id = 5668, name = "Horn of the Brown Wolf" },
		{ id = 18243, name = "Black Battlestrider" },
		{ id = 8588, name = "Whistle of the Emerald Raptor" },
		{ id = 18244, name = "Black War Ram" },
		{ id = 18789, name = "Swift Olive Raptor" },
		{ id = 18790, name = "Swift Orange Raptor" },
		{ id = 8630, name = "Reins of the Bengal Tiger" },
		{ id = 12303, name = "Reins of the Nightsaber" },
		{ id = 18797, name = "Horn of the Swift Timber Wolf" },
		{ id = 5873, name = "White Ram" },
		{ id = 8595, name = "Blue Mechanostrider" },
		{ id = 18786, name = "Swift Brown Ram" },
		{ id = 18772, name = "Swift Green Mechanostrider" },
		{ id = 8592, name = "Whistle of the Violet Raptor" },
		{ id = 13332, name = "Blue Skeletal Horse" },
		{ id = 18247, name = "Black War Kodo" },
		{ id = 12353, name = "White Stallion Bridle" },
		{ id = 18798, name = "Horn of the Swift Gray Wolf" },
		{ id = 5864, name = "Gray Ram" },
		{ id = 13331, name = "Red Skeletal Horse" },
		{ id = 18773, name = "Swift White Mechanostrider" },
		{ id = 5872, name = "Brown Ram" },
		{ id = 13322, name = "Unpainted Mechanostrider" },
		{ id = 12354, name = "Palomino Bridle" },
		{ id = 8591, name = "Whistle of the Turquoise Raptor" },
		{ id = 18787, name = "Swift Gray Ram" },
		{ id = 13333, name = "Brown Skeletal Horse" },
		{ id = 12351, name = "Horn of the Arctic Wolf" },
		{ id = 12302, name = "Reins of the Frostsaber" },
		{ id = 13325, name = "Fluorescent Green Mechanostrider" },
		{ id = 8563, name = "Red Mechanostrider" },
		{ id = 18794, name = "Great Brown Kodo" },
		{ id = 18795, name = "Great Gray Kodo" },
		{ id = 15277, name = "Gray Kodo" },
		{ id = 18774, name = "Swift Yellow Mechanostrider" },
		{ id = 8586, name = "Whistle of the Mottled Red Raptor" },
		{ id = 23193, name = "Skeletal Steed Reins" },
		{ id = 15290, name = "Brown Kodo" },
		{ id = 13321, name = "Green Mechanostrider" },
		{ id = 18768, name = "Reins of the Swift Dawnsaber" },
		{ id = 13328, name = "Black Ram" },
		{ id = 21736, name = "Riding Gryphon Reins" },
		{ id = 13327, name = "Icy Blue Mechanostrider Mod A" },
		{ id = 15292, name = "Green Kodo" },
		{ id = 14062, name = "Kodo Mount" },
		{ id = 13329, name = "Frost Ram" },
		{ id = 12330, name = "Horn of the Red Wolf" },
		{ id = 15293, name = "Teal Kodo" },
		{ id = 13326, name = "White Mechanostrider Mod A" },
		{ id = 8628, name = "Reins of the Spotted Nightsaber" },
		{ id = 8583, name = "Horn of the Skeletal Mount" },
		{ id = 2415, name = "White Stallion" },
		{ id = 16339, name = "Commander's Steed" },
		{ id = 12327, name = "Reins of the Golden Sabercat" },
		{ id = 16344, name = "Lieutenant General's Mount" },
		{ id = 12326, name = "Reins of the Tawny Sabercat" },
		{ id = 8627, name = "Reins of the Night saber" },
		{ id = 8589, name = "Old Whistle of the Ivory Raptor" },
		{ id = 16338, name = "Knight-Lieutenant's Steed" },
		{ id = 2413, name = "Palomino" },
		{ id = 1041, name = "Horn of the Black Wolf" },
		{ id = 8590, name = "Old Whistle of the Obsidian Raptor" },
		{ id = 12325, name = "Reins of the Primal Leopard" },
		{ id = 13323, name = "Purple Mechanostrider" },
		{ id = 8633, name = "Reins of the Leopard" },
		{ id = 1133, name = "Horn of the Winter Wolf" },
		{ id = 16343, name = "Blood Guard's Mount" },
		{ id = 875, name = "Brown Horse Summoning" },
		{ id = 901, name = "Deptecated White Stallion Summoning (Mount)" },
		{ id = 1134, name = "Horn of the Gray Wolf" },
		{ id = 5663, name = "Horn of the Red Wolf" },
		{ id = 13324, name = "Red & Blue Mechanostrider" },
		{ id = 5874, name = "Harness: Black Ram" },
		{ id = 5875, name = "Harness: Blue Ram" }
	},
	["recall"] = {
		main				= {f_ptr = "main", x = 0, y = -100, show = true,}, --
		timer				= {f_ptr = "timer", x = 0, y = 100, show = true,}, --
	},
}

-- helper routines for config screens
--[[
This fills the drop down in config to set the main spell to use on the sphere.
Only known spells will be selectable. Unknown spells will be shown as gray and not selectable.
--]]
function Arcanist.GetMainSpellList()
	local main_spell =  {} -- {19, 31, 37, 41, 43, 44, 55}

	for i = 1, #Arcanist.Mage_Lists.config_main_spell, 1 do -- build as needed
		main_spell[i] = Arcanist.Mage_Lists.config_main_spell[i].high_of
	end

	return main_spell
end

--[[
This updates a spell timer value AND the user config.
--]]
function Arcanist.UpdateSpellTimer(index, show)
	ArcanistConfig.Timers[index].show = show

	for i, v in pairs(Arcanist.Mage_Spells) do
		if Arcanist.Mage_Spells[i].Usage == ArcanistConfig.Timers[index].usage then
			local t = Arcanist.Mage_Spells[i].Timer
			Arcanist.Mage_Spells[i].Timer = show
			end
	end
end

--[[
This updates the spell timer value based on the user selection list from options.
--]]
function Arcanist.UpdateSpellTimers(list)
	for j = 1, #list, 1 do
		for i, v in pairs(Arcanist.Mage_Spells) do
			if Arcanist.Mage_Spells[i].Usage == list[j].usage then
				local t = Arcanist.Mage_Spells[i].Timer
				Arcanist.Mage_Spells[i].Timer = list[j].show
			end
		end
	end
end

-- helper routines to get spell info / determine if a spell is usable
function Arcanist.IsSpellKnown(usage)
	if Arcanist.Mage_Spell_Use[usage] -- get spell id
	then
		return
			Arcanist.Mage_Spells[Arcanist.Mage_Spell_Use[usage]].InSpellBook
	else
		return false -- safety
	end
end

function Arcanist.IsSpellKnownId(id)
	if Arcanist.Mage_Spells[id] -- get spell id
	then
		return
			Arcanist.Mage_Spells[id].InSpellBook or false
	else
		return false -- safety
	end
end

function Arcanist.GetSpellByName(name)
	local s_id = nil
	local s_usage = ""
	local s_timer = false
	for i, v in pairs(Arcanist.Mage_Spells) do
		if Arcanist.Mage_Spells[i].Name == name then
			s_id = Arcanist.Mage_Spell_Use[Arcanist.Mage_Spells[i].Usage] -- spell determined by spell setup
			s_usage = Arcanist.Mage_Spells[i].Usage
			s_timer = (Arcanist.Mage_Spells[i].Timer) -- if has timer
			s_buff = (Arcanist.Mage_Spells[i].Buff and true or false)
			s_cool = (Arcanist.Mage_Spells[i].Buff and true or false)
			break
		end
	end

	return s_id, s_usage, s_timer, s_buff, s_cool
end

function Arcanist.GetSpellMana(usage)
	if Arcanist.Mage_Spell_Use[usage] --
	then
		return
			Arcanist.Mage_Spells[Arcanist.Mage_Spell_Use[usage]].Mana
	else
		return ""
	end
end

function Arcanist.GetSpellRank(usage)
	if Arcanist.Mage_Spell_Use[usage] --
	then
		return
			Arcanist.Mage_Spells[Arcanist.Mage_Spell_Use[usage]].SpellRank
	else
		return ""
	end
end

function Arcanist.GetSpellName(usage)
	if Arcanist.Mage_Spell_Use[usage] --
	then
		return
			Arcanist.Mage_Spells[Arcanist.Mage_Spell_Use[usage]].Name
	else
		return ""
	end
end

function Arcanist.GetSpell(usage) -- return the Mage_Spells table (pointer)
	if Arcanist.Mage_Spell_Use[usage] then
		return Arcanist.Mage_Spells[Arcanist.Mage_Spell_Use[usage]]
	else
		return nil
	end
end

function Arcanist.GetSpellById(id) -- return the Mage_Spells table (pointer)
	return Arcanist.Mage_Spells[id] or nil
end

function Arcanist.GetSpellCastName(usage)
	if Arcanist.Mage_Spell_Use[usage] then
		return
			Arcanist.Mage_Spells[Arcanist.Mage_Spell_Use[usage]].CastName
	else
		return ""
	end
end

-- helper routines to determine if a spell is within a list
function Arcanist.IsFood(id)
	local res = false
	for i, v in pairs (Arcanist.Mage_Lists.conjured_food) do
		if id == v.id then
			res = true
			break
		end
	end

	return res
end

function Arcanist.IsWater(id)
	local res = false
	for i, v in pairs (Arcanist.Mage_Lists.conjured_water) do
		if id == v.id then
			res = true
			break
		end
	end

	return res
end

function Arcanist.IsMount(id)
	local res = false
	for i, v in pairs (Arcanist.Mage_Lists.mounts) do
		if id == v.id then
			res = true
			break
		end
	end

	return res
end

function Arcanist.IsManaAgate(id)
	if (id == 5514) then
		return true
	else
		return false
	end
end

function Arcanist.IsManaJade(id)
	if (id == 5513) then
		return true
	else
		return false
	end
end

function Arcanist.IsManaCitrine(id)
	if (id == 8007) then
		return true
	else
		return false
	end
end

function Arcanist.IsManaRuby(id)
	if (id == 8008) then
		return true
	else
		return false
	end
end

function Arcanist.IsHearthstone(id)
	if (id == 6948) then
		return true
	else
		return false
	end
end

--[[
Create a cast name to use on buttons.
There are two types of names - those with {} and those without.
The ones with, such as create stones, include the 'rank'.
--]]
local function CreateNames(spell, rank)
	local cast = ""
	local name = ""
	local s = spell
	local r = rank or ""
	if string.find(s, "%(") then -- literal paren
		-- make the names match across the 'ranks' for spells that have () in the name
		s = string.match(s, "(.+)%(")           -- grab everything up to the "("
--		s,r = string.match(s, "(.+)(%(.*%))")   -- grab everything up to the "(" & from ( to )
		s = string.gsub(s, "^s*(.-)%s*$", "%1") -- trim white space on either side
		cast = spell -- ok for cast by name
		name = s -- stripped for the lookups
	else
		if r == "" then -- safety
			cast = s
		else
			cast = s.."("..r..")"
		end
		name = spell -- unchanged for the lookups
	end
	return name, cast -- should now be the full spell to cast!
end

local function getManaCost(spellID) -- assume only the first mana cost found is needed for now
    if not spellID then return end
	local cost = 0
	local costTable = GetSpellPowerCost(spellID);
	if costTable == nil then
		return false
	end
	return table.foreach(costTable, function(k,v)
		if v.name  == "MANA" then
			return v.cost;
		end
	end )

end

-- My favourite feature! Create a list of spells known by the mage sorted by name & rank
-- Select the highest available spell in the case of stones.
function Arcanist:SpellSetup(reason)
--    print("SpellSetup")
	Arcanist.Mage_Spell_Use = {}

	local spellID = 1
	local Invisible = 0
	local InvisibleID = 0
	-- local totalSpellTabs = GetNumSpellTabs();

	if Arcanist.Debug.spells_init then
		DEFAULT_CHAT_FRAME:AddMessage(""
		.."::: SpellSetup :::"
		.." "..tostring(reason or "null")
		)
	end

	-- helper routine to fill Mage_Spell_Use fields
	-- we need access to the local variables in SpellSetup
	local function Update(id, sub_name, spell)
		str = ""

		-- update usage rank, if needed
		local str1 = "exists"
		if not Arcanist.Mage_Spell_Use[self.Mage_Spells[id].Usage] then
			Arcanist.Mage_Spell_Use[self.Mage_Spells[id].Usage] = id
			str1 = "new"
		else
			if self.Mage_Spells[id].UsageRank
				> self.Mage_Spells[Arcanist.Mage_Spell_Use[self.Mage_Spells[id].Usage]].UsageRank then
				Arcanist.Mage_Spell_Use[self.Mage_Spells[id].Usage] = id
				str1 = "update"
			else
				-- nothing to do
			end
		end
		if Arcanist.Debug.spells_init then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage(">> rank "..str1
			.." '"..id.."'"
			.." N:'"..self.Mage_Spells[id].Name.."'"
			.." r:'"..self.Mage_Spells[id].SpellRank.."'"
			.." u:'"..self.Mage_Spells[id].Usage.."'"
			)
		end
	end

	--[=[ Step 1
	Go through the mage spells we are interested: add the localized name, rank, and mana cost
	--]=]
--	Arcanist:CreateSpellList()
	for id, v in pairs(Arcanist.Mage_Spells) do
		local spell_name = GetSpellInfo(id) -- localized, rank is BROKEN (always nil)
		if Arcanist.Debug.spells_init then
			_G["DEFAULT_CHAT_FRAME"]:AddMessage("SpellSetup "
			.." i"..tostring(id).."'"
			.." s'"..(tostring(spell_name) or "null").."'"
			--.." n'"..(tostring(spell_name) or "null").."'"
			)
		end
		Arcanist.Mage_Spells[id].Name = spell_name
		Arcanist.Mage_Spells[id].ID = id -- redundant to the 'id' but allows the spell to be self contained if returned as a table

		-- Add the name by usage even if the mage does not know the spell.
		-- Use the 'lowest' usage. Will be updated to highest if known by mage
		local usage = Arcanist.Mage_Spells[id].Usage
		if Arcanist.Mage_Spell_Use[usage] then
			if Arcanist.Mage_Spells[id].UsageRank
			< Arcanist.Mage_Spells[Arcanist.Mage_Spell_Use[usage]].UsageRank then
				Arcanist.Mage_Spell_Use[usage] = id
			else
			end
		else
			Arcanist.Mage_Spell_Use[usage] = id
		end

--		local start, duration, enabled = GetSpellCooldown(id)
		-- For timers, the API appears to return 'valid' values once cast
--		Arcanist.Mage_Spells[id].Length = 0 -- For timers, although the API appears to return values once cast

		local cost = getManaCost(id) or 0 -- populate the mage spells we are interested in
		Arcanist.Mage_Spells[id].Mana = cost

		Arcanist.Mage_Spells[id].InSpellBook = false -- later routine will fill this

		if Arcanist.Mage_Spells[id].Result then
			-- This spell is the result of another spell and will NOT be in spell book
			Update(id, Arcanist.Mage_Spells[id].SpellRank, Arcanist.Mage_Spells[id].Name)
		end
	end
	if Arcanist.Debug.spells_init then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage(">> Search Spell Book")
	end

	--[=[ Step 2
	Go through the spell book for spells we are interested:
	- add to temp array; set 'in spell book'
	--]=]
	local str = ""
	-- Search through the spell book (abilities)
	for i = 1, MAX_SKILLLINE_TABS do
	   local name, texture, offset, numSpells = GetSpellTabInfo(i);

		if name then -- tab exists
			for s = offset + 1, offset + numSpells do
				local spell, sub_name, id = GetSpellBookItemName(s, BOOKTYPE_SPELL)
				-- spell and sub_name / rank are localized

				if self.Mage_Spells[id] then -- a mage spell we care about
					local n, c  = CreateNames(spell, sub_name)
					self.Mage_Spells[id].CastName = c
					spell = n
					if Arcanist.Debug.spells_init then
						_G["DEFAULT_CHAT_FRAME"]:AddMessage(tostring(name)..":"
						.." id "..tostring(id)..""
						.." s'"..(spell or "null").."'"
						.." r'"..(sub_name or "null").."'"
						.." m'"..tostring(self.Mage_Spells[id].Mana).."'"
						--.." off'"..tostring(s).."'"
						.."' c'"..tostring(self.Mage_Spells[id].CastName)
						.."' n'"..tostring(self.Mage_Spells[id].Name)
						.."' u'"..tostring(self.Mage_Spells[id].Usage)
						)
					end

					if sub_name == nil then
						sub_name = "" -- ensure not nil for later checks
					end

					self.Mage_Spells[id].Name = spell -- localized name without rank
					self.Mage_Spells[id].InSpellBook = true
					self.Mage_Spells[id].Rank = sub_name -- localized

					Update(id, sub_name, spell)

				end

			end
		else
			-- No tab found
		end
	end

	if Arcanist.Debug.spells_init then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage(">> Other localized strings")
	end
	--[=[ Step 3
	Fill other items that we can get localized names for.
	--]=]
	for i,v in pairs(Arcanist.Mage_Lists.reagents) do
		v.name = GetItemInfo(v.id) -- just the name
	end

	if Arcanist.Debug.spells_init then
		DEFAULT_CHAT_FRAME:AddMessage(""
		.."::: SpellSetup ::: end"
		)
	end
end
