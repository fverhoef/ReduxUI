local addonName, ns = ...
local R = _G.ReduxUI
local SD = R:AddModule("SpellDatabase", "AceEvent-3.0")

CreateFrame("GameTooltip", "SpellDatabaseScanningTooltip", nil, "GameTooltipTemplate")

SD.Spells = {}
SD.Ranks = {}
SD.RanksById = {}
SD.KnownSpells = {}

SD.Mage = {
    Portals = {
        10059, -- Stormwind
        11416, -- Ironforge
        11419, -- Darnassus
        32266, -- Exodar
        49360, -- Theramore
        33691, -- Shattrath (Alliance)
        11417, -- Orgrimmar
        11418, -- Undercity
        11420, -- Thunder Bluff
        32267, -- Silvermoon
        49361, -- Stonard
        35717 -- Shattrath (Horde)
    },
    Teleports = {
        3561, -- Stormwind
        3562, -- Ironforge
        3565, -- Darnassus
        32271, -- Exodar
        49359, -- Theramore
        33690, -- Shattrath (Alliance)
        3567, -- Orgrimmar
        3563, -- Undercity
        3566, -- Thunder Bluff
        32272, -- Silvermoon
        49358, -- Stonard
        35715 -- Shattrath (Horde)
    },
    ConjureFood = {587, 597, 990, 6129, 10144, 10145, 28612, 33717},
    ConjureWater = {5504, 5505, 5506, 6127, 10138, 10139, 10140, 37420, 27090},
    ConjureTable = {43987},
    ConjureGem = {759, 3552, 10053, 10054, 27101},
    Polymorph = {118, 12824, 12825, 12826, 28271, 28272},
    Armors = {
        168, 7300, 7301, -- Frost Armor
        7302, 7320, 10219, 10220, 27124, -- Ice Armor
        6117, 22782, 22783, 27125, -- Mage Armor
        30482 -- Molten Armor
    }
}

SD.Shaman = {
    FireTotems = {},
    EarthTotems = {},
    WaterTotems = {},
    AirTotems = {},
    WeaponEnchants = {
        8017, 8018, 8019, 10399, 16314, 16315, 16316, -- Rockbiter Weapon
        8024, 8027, 8030, 16339, 16341, 16342, -- Flametongue Weapon
        8033, 8038, 10456, 16355, 16356, -- Frostbrand Weapon
        8232, 8235, 10486, 16362 -- Windfury Weapon
    }
}

function SD:Initialize()
end

function SD:Enable()
    SD:RegisterEvent("LEARNED_SPELL_IN_TAB", SD.ScanSpellBook)
    SD:RegisterEvent("SPELLS_CHANGED", SD.ScanSpellBook)

    SD:Update()
end

function SD:Update() SD:ScanSpellBook() end

function SD:GetRanks(name) return SD.Ranks[name] end

function SD:GetRanksById(id) return SD.RanksById[id] end

function SD:AddSpellRank(spell)
    local ranks = SD.Ranks[spell.name]
    if not ranks then
        ranks = {}
        SD.Ranks[spell.name] = ranks
    end

    if not SD.RanksById[spell.id] then SD.RanksById[spell.id] = ranks end

    if not ranks[spell.rank] then ranks[spell.rank] = spell end

    return ranks
end

function SD:CreateSpell(id)
    local spell = Spell:CreateFromSpellID(id)
    spell:ContinueOnSpellLoad(function(arg)
        spell.id = spell.spellID
        spell.name = spell.name or spell:GetSpellName()
        spell.description = spell.description or spell:GetSpellDescription()
        spell.subText = spell.subText or spell:GetSpellSubtext()

        -- TODO: Localization
        spell.rank = tonumber(string.find(spell.subText, "Rank ") and string.gsub(spell.subText, "Rank ", "") or "1") or 1

        if not R.isRetail then
            SpellDatabaseScanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")
            SpellDatabaseScanningTooltip:SetSpellByID(spell.id)
            for i = 1, SpellDatabaseScanningTooltip:NumLines() do
                local line = _G["SpellDatabaseScanningTooltipTextLeft" .. i]
                local text = line:GetText()
                if string.find(text, "Tools: Fire Totem") then
                    table.insert(SD.Shaman.FireTotems, spell.id)
                elseif string.find(text, "Tools: Earth Totem") then
                    table.insert(SD.Shaman.EarthTotems, spell.id)
                elseif string.find(text, "Tools: Water Totem") then
                    table.insert(SD.Shaman.WaterTotems, spell.id)
                elseif string.find(text, "Tools: Air Totem") then
                    table.insert(SD.Shaman.AirTotems, spell.id)
                end
            end
            SpellDatabaseScanningTooltip:Hide()
        end

        SD:AddSpellRank(spell)
    end)

    return spell
end

function SD:GetOrCreateSpell(id)
    local spell = SD.Spells[id]
    if not spell then
        spell = SD:CreateSpell(id)
        SD.Spells[id] = spell
    end
    return spell
end

function SD:GetOrCreateKnownSpell(id)
    if not id then return end
    
    local spell = SD.KnownSpells[id]
    if not spell and IsSpellKnown(id) then
        spell = SD:GetOrCreateSpell(id)
        SD.KnownSpells[id] = spell
    end
    return spell
end

function SD:ScanSpellBook()
    local offset, numSlots, spell, spellType, id, flyoutSpellID, numFlyoutSlots, isKnown
    for i = 1, GetNumSpellTabs() do
        _, _, offset, numSlots = GetSpellTabInfo(i)
        for j = offset + 1, offset + numSlots do
            spellType, id = GetSpellBookItemInfo(j, BOOKTYPE_SPELL)

            if spellType == "PETACTION" then
                id = bit.band(id, 0xFFFFFF)
                SD:GetOrCreateKnownSpell(id)
            elseif spellType == "FLYOUT" then
                _, _, numFlyoutSlots, isKnown = GetFlyoutInfo(id)
                if isKnown then
                    for slot = 1, numFlyoutSlots do
                        flyoutSpellID, _, isKnown = GetFlyoutSlotInfo(id, slot)
                        if isKnown then SD:GetOrCreateKnownSpell(flyoutSpellID) end
                    end
                end
            else
                SD:GetOrCreateKnownSpell(id)
            end
        end
    end
end

function R:GetMaxKnownRank(id)
    local ranks = SD:GetRanksById(id)
    if not ranks or #ranks == 0 then return end

    return ranks[#ranks].id
end

function R:IsMaxKnownRank(id) return R:GetMaxKnownRank(id) == id end
