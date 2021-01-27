local AddonName, AddonTable = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

local function InspectByGUID(guid)
    if guid then
        local _, _, _, _, _, name, server = GetPlayerInfoByGUID(guid)
        if name and CanInspect(name) then
            NotifyInspect(name)
        end
    end
end

local function GetDruidTalents(unitGUID)
    local talents = {reflection = 0, giftOfNature = 0}

    if (S.Stats.class == "DRUID") then
        -- Reflection (5, 10, 15)%
        local lookup = {5, 10, 15}
        local spellRank = select(5, GetTalentInfo(3, 6))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.reflection = lookup[spellRank]
        end

        -- Gift of Nature (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(3, 12))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.giftOfNature = lookup[spellRank];
        end
    end

    return talents
end

local function GetMageTalents(unitGUID)
    local talents = {arcaneInstability = 0, criticalMass = 0, firePower = 0, arcaneFocus = 0, elementalPrecision = 0, piercingIce = 0, arcaneMeditation = 0}

    if (S.Stats.class == "MAGE") then
        -- Arcane Instability (1, 2, 3)%
        local lookup = {1, 2, 3}
        local spellRank = select(5, GetTalentInfo(1, 15))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.arcaneInstability = lookup[spellRank]
        end

        -- Critical Mass (2, 4, 6)%
        lookup = {2, 4, 6}
        spellRank = select(5, GetTalentInfo(2, 13))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.criticalMass = lookup[spellRank]
        end

        -- Fire Power (2, 4, 6)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(2, 15))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.firePower = lookup[spellRank]
        end

        -- Arcane Focus  (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(1, 2))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.arcaneFocus = lookup[spellRank]
        end

        -- Elemental Precision  (2, 4, 6)%
        lookup = {2, 4, 6}
        spellRank = select(5, GetTalentInfo(3, 3))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.elementalPrecision = lookup[spellRank]
        end

        -- Piercing Ice (2, 4, 6)%
        lookup = {2, 4, 6}
        spellRank = select(5, GetTalentInfo(3, 8))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.piercingIce = lookup[spellRank]
        end

        -- Arcane Meditation (5, 10, 15)%
        lookup = {5, 10, 15}
        spellRank = select(5, GetTalentInfo(1, 12))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.arcaneMeditation = lookup[spellRank]
        end
    end

    return talents
end

local function GetPaladinTalents(unitGUID)
    local talents = {healingLight = 0, holyPower = 0, anticipation = 0}

    if (S.Stats.class == "PALADIN") then
        -- Healing Light (4, 8, 12)%
        local lookup = {4, 8, 12}
        local spellRank = select(5, GetTalentInfo(1, 5))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.healingLight = lookup[spellRank];
        end

        -- Holy Power (1, 2, 3, 4, 5)%
        lookup = {1, 2, 3, 4, 5}
        spellRank = select(5, GetTalentInfo(1, 13))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.holyPower = lookup[spellRank];
        end

        -- Anticipation (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(2, 9))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.anticipation = lookup[spellRank];
        end
    end

    return talents
end

local function GetPriestTalents(unitGUID)
    local talents = {holySpecialization = 0, forceOfWill = 0, meditation = 0, improvedPowerWordShield = 0}

    if (S.Stats.class == "PRIEST") then
        -- Holy Specialization (1, 2, 3, 4, 5)%
        local lookup = {1, 2, 3, 4, 5}
        local spellRank = select(5, GetTalentInfo(2, 3))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.holySpecialization = lookup[spellRank]
        end

        -- Force of Will (1, 2, 3, 4, 5)%
        lookup = {1, 2, 3, 4, 5}
        spellRank = select(5, GetTalentInfo(1, 14))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.forceOfWill = lookup[spellRank]
        end

        -- Meditation (5, 10, 15)%
        lookup = {5, 10, 15}
        spellRank = select(5, GetTalentInfo(1, 8))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.meditation = lookup[spellRank]
        end

        -- Improved Power Word: Shield (5, 10, 15)%
        lookup = {5, 10, 15}
        spellRank = select(5, GetTalentInfo(1, 5))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.improvedPowerWordShield = lookup[spellRank]
        end
    end

    return talents
end

local function GetShamanTalents(unitGUID)
    local talents = {concussion = 0, callOfFlame = 0, callOfThunder = 0, naturesGuidance = 0, tidalMastery = 0, purification = 0}

    if (S.Stats.class == "SHAMAN") then
        -- Concussion (1, 2, 3, 4, 5)%
        local lookup = {1, 2, 3, 4, 5}
        local spellRank = select(5, GetTalentInfo(1, 2))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.concussion = lookup[spellRank]
        end

        -- Call of Flame (5, 10, 15)%
        lookup = {5, 10, 15}
        spellRank = select(5, GetTalentInfo(1, 5))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.callOfFlame = lookup[spellRank]
        end

        -- Call of Thunder (1, 2, 3, 4, 6)%
        lookup = {1, 2, 3, 4, 6}
        spellRank = select(5, GetTalentInfo(1, 8))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.callOfThunder = lookup[spellRank]
        end

        -- Nature's Guidance (1, 2, 3)%
        lookup = {1, 2, 3}
        spellRank = select(5, GetTalentInfo(3, 6))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.naturesGuidance = lookup[spellRank]
        end

        -- Tidal Mastery (1, 2, 3, 4, 5)%
        lookup = {1, 2, 3, 4, 5}
        spellRank = select(5, GetTalentInfo(3, 11))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.tidalMastery = lookup[spellRank]
        end

        -- Purification (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(3, 14))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.purification = lookup[spellRank]
        end
    end

    return talents
end

local function GetWarlockTalents(unitGUID)
    local talents = {
        improvedAgony = 0,
        shadowMastery = 0,
        improvedVoidwalker = 0,
        improvedSpellstone = 0,
        devastation = 0,
        improvedSearingPain = 0,
        improvedImmolate = 0,
        emberstorm = 0
    }

    if (S.Stats.class == "WARLOCK") then
        -- Improved Curse of Agony (2, 4, 6)%
        lookup = {2, 4, 6}
        spellRank = select(5, GetTalentInfo(1, 7))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.improvedAgony = lookup[spellRank];
        end

        -- Shadow Mastery (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(1, 16))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.shadowMastery = lookup[spellRank];
        end

        -- Improved Voidwalker (10, 20, 30)%
        local lookup = {10, 20, 30}
        local spellRank = select(5, GetTalentInfo(2, 5))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.improvedVoidwalker = lookup[spellRank];
        end

        -- Improved Spellstone (15, 30)%
        lookup = {15, 30}
        spellRank = select(5, GetTalentInfo(2, 17))
        if (spellRank > 0) and (spellRank <= 2) then
            talents.improvedSpellstone = lookup[spellRank];
        end

        -- Devestation (1, 2, 3, 4, 5)%
        lookup = {1, 2, 3, 4, 5}
        spellRank = select(5, GetTalentInfo(3, 7))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.devastation = lookup[spellRank];
        end

        -- Improved Searing Pain (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(3, 11))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.improvedSearingPain = lookup[spellRank];
        end

        -- Improved Immolate (5, 10, 15, 20, 25)%
        lookup = {5, 10, 15, 20, 25}
        spellRank = select(5, GetTalentInfo(3, 13))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.improvedImmolate = lookup[spellRank];
        end

        -- Emberstorm (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(3, 15))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.emberstorm = lookup[spellRank];
        end
    end

    return talents
end

local function PlayerHasAura(auraId)
    local i = 1
    local spellId = select(10, UnitAura("player", i))
    while spellId do
        if spellId == auraId then
            return true
        end

        i = i + 1
        spellId = select(10, UnitAura("player", i))
    end

    return false
end

local function GetMP2FromSpirit(spirit)
    local mp2 = 0
    if S.Stats.class == "MAGE" or S.Stats.class == "PRIEST" then
        mp2 = 13 + spirit / 4
    elseif S.Stats.class == "DRUID" or S.Stats.class == "SHAMAN" or S.Stats.class == "PALADIN" or S.Stats.class == "HUNTER" then
        mp2 = 15 + spirit / 5
    elseif S.Stats.class == "WARLOCK" then
        mp2 = 8 + spirit / 4
    end
    return mp2
end

local function GetMP5FromGear()
    local mp5 = 0
    for i = 1, 18 do
        local itemLink = GetInventoryItemLink("player", i)
        if itemLink then
            local stats = GetItemStats(itemLink)
            if stats then
                -- For some reason this returns (mp5 - 1)
                local statMP5 = stats["ITEM_MOD_POWER_REGEN0_SHORT"];
                if (statMP5) then
                    mp5 = mp5 + statMP5 + 1
                end
            end
        end
    end

    return mp5
end

local function GetRegenCastingModifierFromSetBonus()
    local modifier = 0

    -- not Druid (11) or Priest (5)
    if S.Stats.class ~= "DRUID" and S.Stats.class ~= "PRIEST" then
        return modifier
    end

    local firstItemslotIndex = 1
    local lastItemslotIndex = 18

    local vestmentsOfTranscendenceIDs = {[16925] = 16925, [16926] = 16926, [16919] = 16919, [16921] = 16921, [16920] = 16920, [16922] = 16922, [16924] = 16924, [16923] = 16923}
    local stormrageRaimentIDs = {[16897] = 16897, [16898] = 16898, [16899] = 16899, [16900] = 16900, [16901] = 16901, [16902] = 16902, [16903] = 16903, [16904] = 16904}

    local equippedSetItems = 0
    for itemSlot = firstItemslotIndex, lastItemslotIndex do
        local itemId = GetInventoryItemID("player", itemslot)

        if (itemId) then
            if (itemId == vestmentsOfTranscendenceIDs[itemId] or itemId == stormrageRaimentIDs[itemId]) then
                equippedSetItems = equippedSetItems + 1
            end
        end
    end

    if equippedSetItems >= 3 then
        modifier = 0.15
    end

    return modifier
end

local function GetRegenCastingModifierFromBuffs()
    local modifier = 0

    if PlayerHasAura(12051) then -- Evocation
        modifier = 1
    elseif PlayerHasAura(29166) then -- Innervate
        modifier = 1
    elseif PlayerHasAura(23684) or PlayerHasAura(23688) then -- Aura of the Blue Dragon (23684/23688)
        modifier = 1
    elseif PlayerHasAura(6117) or PlayerHasAura(22782) or PlayerHasAura(22783) then -- Mage Armor
        modifier = 0.3
    end

    return modifier
end

local function GetSpiritRegenModifierFromBuffs()
    local modifier = 1

    -- TODO: do these stack?
    if PlayerHasAura(12051) then -- Evocation
        modifier = modifier + 15
    end
    if PlayerHasAura(29166) then -- Innervate
        modifier = modifier + 4
    end

    return modifier
end

local function GetHitFromBiznicksAccurascope()
    local itemLink = GetInventoryItemLink("player", 18)
    if itemLink then
        local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
        if enchantId then
            if tonumber(enchantId) == 2523 then
                return 3
            end
        end
    end

    return 0;
end

local function GetSpellPowerFromTotem()
    local spellPower = {shocks = 0, lightning = 0, lesserHealingWave = 0}
    if S.Stats.class == "SHAMAN" then
        for itemSlot = 1, 18 do
            local itemId = GetInventoryItemID("player", itemSlot)

            if (itemId) then
                if (itemId == 23199) then -- Totem of the Storm
                    spellPower.lightning = 33
                    break
                elseif (itemId == 22395) then -- Totem of Rage
                    spellPower.shocks = 30
                    break
                elseif (itemId == 23200) then -- Totem of Sustaining
                    spellPower.lesserHealingWave = 53
                    break
                elseif (itemId == 22396) then -- Totem of Sustaining
                    spellPower.lesserHealingWave = 80
                    break
                end
            end
        end
    end

    return spellPower
end

local function GetShapeshiftForm()
    for i = 1, GetNumShapeshiftForms() do
        if select(2, GetShapeshiftFormInfo(i)) then
            return i
        end
    end

    return 0
end

local function GetPlayerItemLevel()
    local totalItemLevel = 0
    local count = 0
    local hasTwoHander = false
    for i, slot in next, R.EquipmentSlots do
        local link = GetInventoryItemLink("player", GetInventorySlotInfo(slot))
        if link then
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon = GetItemInfo(link)
            if itemEquipLoc == "INVTYPE_2HWEAPON" then
                hasTwoHander = true
            end
            if itemLevel then
                totalItemLevel = totalItemLevel + itemLevel
            end
            count = count + 1
        elseif slot ~= "SecondaryHandSlot" and hasTwoHander then
            count = count + 1
        end
    end

    return math.floor((count and totalItemLevel / count) or 0)
end

local function GetAttribute(attribute)
    local base, stat, posBuff, negBuff = UnitStat("player", attribute)
    return {base = base, stat = stat, posBuff = posBuff, negBuff = negBuff}
end

local function GetArmor()
    local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player")
    return {base = base, effectiveArmor = effectiveArmor, armor = armor, posBuff = posBuff, negBuff = negBuff}
end

local function GetSpellDamage()
    local spellDamage = {holy = 1, fire = 1, nature = 1, frost = 1, shadow = 1, arcane = 1}
    if S.Stats.class == "MAGE" then
        local talents = GetMageTalents()
        spellDamage.holy = spellDamage.holy + (talents.arcaneInstability) / 100
        spellDamage.fire = spellDamage.fire + (talents.arcaneInstability + talents.firePower) / 100
        spellDamage.nature = spellDamage.nature + (talents.arcaneInstability) / 100
        spellDamage.frost = spellDamage.frost + (talents.arcaneInstability + talents.piercingIce) / 100
        spellDamage.shadow = spellDamage.shadow + (talents.arcaneInstability) / 100
        spellDamage.arcane = spellDamage.arcane + (talents.arcaneInstability) / 100
    elseif S.Stats.class == "PRIEST" then
        local talents = GetPriestTalents()
        spellDamage.holy = spellDamage.holy + (talents.forceOfWill) / 100
        spellDamage.fire = spellDamage.fire + (talents.forceOfWill) / 100
        spellDamage.nature = spellDamage.nature + (talents.forceOfWill) / 100
        spellDamage.frost = spellDamage.frost + (talents.forceOfWill) / 100
        spellDamage.shadow = spellDamage.shadow + (talents.forceOfWill) / 100
        spellDamage.arcane = spellDamage.arcane + (talents.forceOfWill) / 100
    elseif S.Stats.class == "SHAMAN" then
        local talents = GetShamanTalents()
        spellDamage.lightning = 1 + (talents.concussion) / 100
        spellDamage.shock = 1 + (talents.concussion) / 100
        spellDamage.fireTotem = 1 + (talents.callOfFlame) / 100
    elseif S.Stats.class == "WARLOCK" then
        local talents = GetWarlockTalents()
        spellDamage.fire = 1 + (talents.emberstorm) / 100
        spellDamage.shadow = 1 + (talents.shadowMastery) / 100
        spellDamage.curseOfAgony = 1 + (talents.improvedAgony) / 100
        spellDamage.immolateDirect = 1 + (talents.improvedImmolate) / 100
    end

    -- TODO: check damage done from buffs (DMF, Master Demonologist, Demonic Sacrifice)

    return spellDamage
end

local function GetSpellPower()
    local totemPower = GetSpellPowerFromTotem()
    local spellPower = {
        holy = GetSpellBonusDamage(2),
        fire = GetSpellBonusDamage(3),
        nature = GetSpellBonusDamage(4),
        frost = GetSpellBonusDamage(5),
        shadow = GetSpellBonusDamage(6),
        arcane = GetSpellBonusDamage(7),
        shocks = totemPower.shocks,
        lightning = totemPower.lightning
    }
    spellPower.max = math.max(spellPower.holy, spellPower.fire, spellPower.nature, spellPower.frost, spellPower.shadow, spellPower.arcane, spellPower.nature + spellPower.lightning)

    return spellPower
end

local function GetSpellCrit()
    local spellCrit = {
        holy = GetSpellCritChance(2),
        fire = GetSpellCritChance(3),
        nature = GetSpellCritChance(4),
        frost = GetSpellCritChance(5),
        shadow = GetSpellCritChance(6),
        arcane = GetSpellCritChance(7)
    }

    if S.Stats.class == "MAGE" then
        local talents = GetMageTalents()
        spellCrit.holy = spellCrit.holy + talents.arcaneInstability
        spellCrit.fire = spellCrit.fire + talents.arcaneInstability + talents.criticalMass
        spellCrit.nature = spellCrit.nature + talents.arcaneInstability
        spellCrit.frost = spellCrit.frost + talents.arcaneInstability
        spellCrit.shadow = spellCrit.shadow + talents.arcaneInstability
        spellCrit.arcane = spellCrit.arcane + talents.arcaneInstability
    elseif S.Stats.class == "PRIEST" then
        local talents = GetPriestTalents()
        spellCrit.holy = spellCrit.holy + talents.forceOfWill + talents.holySpecialization
        spellCrit.fire = spellCrit.fire + talents.forceOfWill
        spellCrit.nature = spellCrit.nature + talents.forceOfWill
        spellCrit.frost = spellCrit.frost + talents.forceOfWill
        spellCrit.shadow = spellCrit.shadow + talents.forceOfWill
        spellCrit.arcane = spellCrit.arcane + talents.forceOfWill
    elseif S.Stats.class == "PALADIN" then
        local talents = GetPaladinTalents()
        spellCrit.holy = spellCrit.holy + talents.holyPower
    elseif S.Stats.class == "SHAMAN" then
        local talents = GetShamanTalents()
        spellCrit.lightning = spellCrit.nature + talents.callOfThunder + talents.tidalMastery
        spellCrit.healing = spellCrit.nature + talents.tidalMastery
    elseif S.Stats.class == "WARLOCK" then
        local talents = GetWarlockTalents()
        spellCrit.destruction = 0 + talents.devastation
        spellCrit.searingPain = 0 + talents.improvedSearingPain
    end

    spellCrit.max = math.max(spellCrit.holy, spellCrit.fire, spellCrit.nature, spellCrit.frost, spellCrit.shadow, spellCrit.arcane, spellCrit.healing or 0,
                             spellCrit.lightning or 0, spellCrit.destruction or 0, spellCrit.searingPain or 0)

    return spellCrit
end

local function GetSpellHit()
    local baseSpellHit = GetSpellHitModifier() or 0
    local spellHit = {holy = baseSpellHit, fire = baseSpellHit, nature = baseSpellHit, frost = baseSpellHit, shadow = baseSpellHit, arcane = baseSpellHit}

    if S.Stats.class == "MAGE" then
        local talents = GetMageTalents()
        spellHit.arcane = spellHit.arcane + talents.arcaneFocus
        spellHit.fire = spellHit.fire + talents.elementalPrecision
        spellHit.frost = spellHit.frost + talents.elementalPrecision
    end

    spellHit.max = math.max(spellHit.holy, spellHit.fire, spellHit.nature, spellHit.frost, spellHit.shadow, spellHit.arcane)

    return spellHit
end

local function GetHealingDone()
    local healingDone = 1
    if S.Stats.class == "PRIEST" then
        local talents = GetPriestTalents()
    elseif S.Stats.class == "DRUID" then
        local talents = GetDruidTalents()
        healingDone = healingDone + talents.giftOfNature / 100
    elseif S.Stats.class == "SHAMAN" then
        local talents = GetShamanTalents()
        healingDone = healingDone + talents.purification / 100
    elseif S.Stats.class == "PALADIN" then
        local talents = GetPaladinTalents()
    end

    return healingDone
end

local function GetManaRegen()
    local regenCastingModifier = 0
    if S.Stats.class == "MAGE" then
        local talents = GetMageTalents()
        regenCastingModifier = regenCastingModifier + talents.arcaneMeditation / 100
    elseif S.Stats.class == "PRIEST" then
        local talents = GetPriestTalents()
        regenCastingModifier = regenCastingModifier + talents.meditation / 100
    elseif S.Stats.class == "DRUID" then
        local talents = GetDruidTalents()
        regenCastingModifier = regenCastingModifier + talents.reflection / 100
    end

    -- fix mana regen (GetManaRegen returns base for both base and casting)
    local regenFromSpirit = GetMP2FromSpirit(S.Stats.spirit.stat) / 2
    local regenModifier = GetSpiritRegenModifierFromBuffs()
    regenFromSpirit = regenFromSpirit * regenModifier
    local regenFromGear = GetMP5FromGear() / 5
    regenCastingModifier = math.min(1, regenCastingModifier + GetRegenCastingModifierFromBuffs() + GetRegenCastingModifierFromSetBonus())

    -- TODO: mana regen from buffs?

    return {base = regenFromSpirit + regenFromGear, gear = regenFromGear, casting = regenFromSpirit * regenCastingModifier + regenFromGear}
end

local function GetMelee()
    local mainhandSpeed, offhandSpeed = UnitAttackSpeed("player")
    local minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, bonusPos, bonusNeg, percent = UnitDamage("player")
    local base, posBuff, negBuff = UnitAttackPower("player")
    local mainhandBase, mainhandModifier, offhandBase, offhandModifier = UnitAttackBothHands("player")
    local melee = {
        mainhandSpeed = mainhandSpeed,
        offhandSpeed = offhandSpeed,
        minDamage = minDamage,
        maxDamage = maxDamage,
        minOffHandDamage = minOffHandDamage,
        maxOffHandDamage = maxOffHandDamage,
        bonusPos = bonusPos,
        bonusNeg = bonusNeg,
        percent = percent,
        attackPower = {base = base, posBuff = posBuff, negBuff = negBuff},
        attackRating = {mainhandBase = mainhandBase, mainhandModifier = mainhandModifier, offhandBase = offhandBase, offhandModifier = offhandModifier},
        crit = GetCritChance() or 0,
        hit = GetHitModifier() or 0
    }

    -- TODO: check damage done from buffs
    -- TODO: check attack power from buffs

    -- calculate miss chance
    local missChanceVsNPC = 5 -- Level 60 npcs with 300 def
    local missChanceVsBoss = 9
    local missChanceVsPlayer = 5 -- Level 60 player def is 300 base

    if S.Stats.weaponSkill then
        local bossDefense = 315 -- level 63
        local playerBossDeltaSkill = bossDefense - S.Stats.weaponSkill

        if playerBossDeltaSkill > 10 then
            if melee.hit >= 1 then
                melee.hit = melee.hit - 1
            end

            missChanceVsBoss = 5 + (playerBossDeltaSkill * 0.2)
        else
            missChanceVsBoss = 5 + (playerBossDeltaSkill * 0.1)
        end
    end

    melee.miss = {
        missChanceVsNPC = math.max(0, missChanceVsNPC - melee.hit),
        missChanceVsBoss = math.max(0, missChanceVsBoss - melee.hit),
        missChanceVsPlayer = math.max(0, missChanceVsPlayer - melee.hit),
        dwMissChanceVsNpc = math.max(0, (missChanceVsNPC * 0.8 + 20) - melee.hit),
        dwMissChanceVsBoss = math.max(0, (missChanceVsBoss * 0.8 + 20) - melee.hit),
        dwMissChanceVsPlayer = math.max(0, (missChanceVsPlayer * 0.8 + 20) - melee.hit)
    }

    return melee
end

local function GetRanged()
    local speed, minDamage, maxDamage, bonusPos, bonusNeg, percent = UnitRangedDamage("player")
    local attackPowerBase, posBuff, negBuff = UnitRangedAttackPower("player")
    local attackRatingBase, modifier = UnitRangedAttack("player")
    local ranged = {
        speed = speed,
        minDamage = minDamage,
        maxDamage = maxDamage,
        bonusPos = bonusPos,
        bonusNeg = bonusNeg,
        percent = percent,
        attackPower = {base = base, posBuff = posBuff, negBuff = negBuff},
        attackRating = {base = attackRatingBase, modifier = modifier},
        crit = GetRangedCritChance() or 0,
        hit = (GetHitModifier() or 0) + GetHitFromBiznicksAccurascope()
    }

    -- TODO: check attack power from buffs

    -- calculate miss chance
    local missChanceVsNPC = 5 -- Level 60 npcs with 300 def
    local missChanceVsBoss = 9
    local missChanceVsPlayer = 5 -- Level 60 player def is 300 base

    if S.Stats.weaponSkill then
        local bossDefense = 315 -- level 63
        local playerBossDeltaSkill = bossDefense - S.Stats.weaponSkill

        if playerBossDeltaSkill > 10 then
            if ranged.hit >= 1 then
                ranged.hit = ranged.hit - 1
            end

            missChanceVsBoss = 5 + (playerBossDeltaSkill * 0.2)
        else
            missChanceVsBoss = 5 + (playerBossDeltaSkill * 0.1)
        end
    end

    ranged.miss = {
        missChanceVsNPC = math.max(0, missChanceVsNPC - ranged.hit),
        missChanceVsBoss = math.max(0, missChanceVsBoss - ranged.hit),
        missChanceVsPlayer = math.max(0, missChanceVsPlayer - ranged.hit)
    }

    return ranged
end

local function GetArmorReduction()
    local armorReduction = S.Stats.armor.effectiveArmor / ((85 * S.Stats.level) + 400)
    armorReduction = 100 * (armorReduction / (armorReduction + 1))

    return armorReduction
end

local function GetSkillRankAndModifier(skill)
    local numSkills = GetNumSkillLines()
    local skillIndex = 0

    local skillRank, skillModifier = 0, 0
    for i = 1, numSkills do
        local skillName, isHeader, isExpanded, numTempPoints
        skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier = GetSkillLineInfo(i)
        if not isHeader and skillName == skill then
            break
        end
    end

    local posBuff = 0
    local negBuff = 0
    if (skillModifier > 0) then
        posBuff = skillModifier
    elseif (skillModifier < 0) then
        negBuff = skillModifier
    end

    return skillRank, skillModifier
end

local function GetDefense()
    local skillRank, skillModifier = GetSkillRankAndModifier(DEFENSE)

    local posBuff = 0
    local negBuff = 0
    if (skillModifier > 0) then
        posBuff = skillModifier
    elseif (skillModifier < 0) then
        negBuff = skillModifier
    end

    local baseDefense, armorDefense = UnitDefense("player")
    return {baseDefense = baseDefense, armorDefense = armorDefense, defense = skillRank, posBuff = posBuff, negBuff = negBuff}
end

local function GetPlayerWeaponSkill()
    local totalWeaponSkill = nil
    local mainHandItemId = 16

    if (S.Stats.class == "DRUID") and (S.Stats.stance > 0) then
        totalWeaponSkill = UnitLevel("player") * 5
    else
        local itemId = GetInventoryItemID("player", mainHandItemId)
        if (itemId) then
            local _, _, _, _, _, itemClassId, itemSubClassId = GetItemInfoInstant(itemId)
            if itemSubClassId then
                local weaponString = GetItemSubClassInfo(itemClassId, itemSubClassId)
                if weaponString then
                    local skillRank, skillModifier = GetSkillRankAndModifier(weaponString)
                    if skillRank and skillModifier then
                        totalWeaponSkill = skillRank + skillModifier
                    end
                end
            end
        end
    end

    return totalWeaponSkill
end

S.Stats = {}

function S.Stats:Update()
    S.Stats.guid = UnitGUID("player")
    S.Stats.class = select(2, UnitClass("player"))
    S.Stats.faction = UnitFactionGroup("player")
    S.Stats.name = UnitName("player")
    S.Stats.level = UnitLevel("player")
    S.Stats.itemLevel = GetPlayerItemLevel()

    S.Stats.hasRangedWeapon = IsRangedWeapon()
    S.Stats.hasWand = HasWandEquipped()

    S.Stats.strength = GetAttribute(1)
    S.Stats.agility = GetAttribute(2)
    S.Stats.stamina = GetAttribute(3)
    S.Stats.intellect = GetAttribute(4)
    S.Stats.spirit = GetAttribute(5)
    S.Stats.armor = GetArmor()
    S.Stats.armorReduction = GetArmorReduction()

    S.Stats.spellDamage = GetSpellDamage()
    S.Stats.spellPower = GetSpellPower()
    S.Stats.spellCrit = GetSpellCrit()
    S.Stats.spellHit = GetSpellHit()

    S.Stats.healingPower = GetSpellBonusHealing()
    S.Stats.lesserHealingWave = GetSpellPowerFromTotem().lesserHealingWave
    S.Stats.healingDone = GetHealingDone()
    S.Stats.manaRegen = GetManaRegen()

    S.Stats.dodge = GetDodgeChance()
    S.Stats.parry = GetParryChance()
    S.Stats.block = GetBlockChance()
    S.Stats.blockValue = GetShieldBlock()
    S.Stats.defense = GetDefense()

    S.Stats.stance = GetShapeshiftForm()
    S.Stats.weaponSkill = GetPlayerWeaponSkill() or 0
    S.Stats.melee = GetMelee()
    S.Stats.ranged = GetRanged()
end
