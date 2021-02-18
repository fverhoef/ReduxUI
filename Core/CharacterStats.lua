local addonName, ns = ...
local R = _G.ReduxUI
local CS = R:AddModule("CharacterStats", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

CS.name = UnitName("player")
CS.guid = UnitGUID("player")
CS.class = select(2, UnitClass("player"))
CS.faction = UnitFactionGroup("player")
CS.realm = GetRealmName()
CS.sex = UnitSex("player")
CS.isMale = R.sex == 2
CS.isFemale = R.sex == 3

function CS:Initialize()
    CS:RegisterEvent("PLAYER_DAMAGE_DONE_MODS", CS.OnEvent)
    CS:RegisterEvent("PLAYER_ENTERING_WORLD", CS.OnEvent)
    CS:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", CS.OnEvent)
    CS:RegisterEvent("PLAYER_GUILD_UPDATE", CS.OnEvent)
    CS:RegisterEvent("PLAYER_LEVEL_UP", CS.OnEvent)
    CS:RegisterEvent("PLAYER_UPDATE_RESTING", CS.OnEvent)
    CS:RegisterEvent("PLAYER_XP_UPDATE", CS.OnEvent)
    CS:RegisterEvent("SKILL_LINES_CHANGED", CS.OnEvent)
    CS:RegisterEvent("UNIT_ATTACK", CS.OnEvent)
    CS:RegisterEvent("UNIT_ATTACK_POWER", CS.OnEvent)
    CS:RegisterEvent("UNIT_ATTACK_SPEED", CS.OnEvent)
    CS:RegisterEvent("UNIT_DAMAGE", CS.OnEvent)
    CS:RegisterEvent("UNIT_LEVEL", CS.OnEvent)
    CS:RegisterEvent("UNIT_MODEL_CHANGED", CS.OnEvent)
    CS:RegisterEvent("UNIT_RANGED_ATTACK_POWER", CS.OnEvent)
    CS:RegisterEvent("UNIT_RANGEDDAMAGE", CS.OnEvent)
    CS:RegisterEvent("UNIT_RESISTANCES", CS.OnEvent)
    CS:RegisterEvent("UNIT_STATS", CS.OnEvent)
end

CS.OnEvent = function(event, ...)
    if string.find(event, "UNIT_") then
        local unitTarget = select(1, ...)
        if unitTarget == "player" then
            CS:Update()
        end
    else
        CS:Update()
    end
end

function CS:Update()
    CS.sex = UnitSex("player")
    CS.isMale = R.sex == 2
    CS.isFemale = R.sex == 3
    CS.level = UnitLevel("player")
    CS.itemLevel = CS:GetAverageItemLevel()
    CS.hasRangedWeapon = IsRangedWeapon()
    CS.hasWand = HasWandEquipped()

    CS.talents = CS:GetTalents()

    CS.strength = CS:GetAttribute(1)
    CS.agility = CS:GetAttribute(2)
    CS.stamina = CS:GetAttribute(3)
    CS.intellect = CS:GetAttribute(4)
    CS.spirit = CS:GetAttribute(5)
    CS.armor = CS:GetArmor()
    CS.armorReduction = CS:GetArmorReduction()

    local baseDamage = 1
    local baseHealing = 1

    -- Sayge's Dark Fortune of Damage
    if R:PlayerHasAura(23768) then
        baseDamage = baseDamage * 1.1
    end
    -- Power Infusion 
    if R:PlayerHasAura(10060) then
        baseDamage = baseDamage * 1.2
    end
    -- Arcane Power
    if R:PlayerHasAura(12042) then
        baseDamage = baseDamage * 1.3
    end
    -- Nature Aligned
    if R:PlayerHasAura(23734) then
        baseDamage = baseDamage * 1.2
        baseHealing = baseHealing * 1.2
    end

    CS.spellPower = CS:GetSpellPower()
    CS.spellDamage = CS:GetSpellDamage(baseDamage)
    CS.spellCrit = CS:GetSpellCrit()
    CS.spellHit = CS:GetSpellHit()

    CS.healingPower = GetSpellBonusHealing()
    if CS.class == "SHAMAN" then
        CS.lesserHealingWave = CS.healingPower + CS.spellPower.lesserHealingWave
    end
    CS.healingDone = CS:GetHealingDone(baseHealing)
    if CS.class == "PALADIN" then
        CS.holyLight = CS.healingDone + CS.talents.healingLight / 100
        CS.flashOfLight = CS.healingDone + CS.talents.healingLight / 100
    end

    CS.manaRegen = CS:GetManaRegen()

    CS.dodge = GetDodgeChance()
    CS.parry = GetParryChance()
    CS.block = GetBlockChance()
    CS.blockValue = GetShieldBlock()
    CS.defense = CS:GetDefense()

    CS.stance = CS:GetShapeshiftForm()
    CS.weaponSkill = CS:GetPlayerWeaponSkill() or 0
    CS.melee = CS:GetMelee()
    CS.ranged = CS:GetRanged()
end

function CS:GetAverageItemLevel()
    local totalItemLevel = 0
    local count = 0
    local hasTwoHander = false
    for i, slot in next, R.EquipmentSlots do
        local link = GetInventoryItemLink("player", GetInventorySlotInfo(slot))
        if link then
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc,
                  itemIcon = GetItemInfo(link)
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

function CS:GetAttribute(attribute)
    local base, stat, posBuff, negBuff = UnitStat("player", attribute)
    return {base = base, stat = stat, posBuff = posBuff, negBuff = negBuff}
end

function CS:GetArmor()
    local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player")
    return {base = base, effectiveArmor = effectiveArmor, armor = armor, posBuff = posBuff, negBuff = negBuff}
end

function CS:GetArmorReduction()
    local armorReduction = CS.armor.effectiveArmor / ((85 * CS.level) + 400)
    armorReduction = 100 * (armorReduction / (armorReduction + 1))

    return armorReduction
end

function CS:GetSpellPower()
    local totemPower = CS:GetSpellPowerFromTotem()
    local spellPower = {
        holy = GetSpellBonusDamage(2),
        fire = GetSpellBonusDamage(3),
        nature = GetSpellBonusDamage(4),
        frost = GetSpellBonusDamage(5),
        shadow = GetSpellBonusDamage(6),
        arcane = GetSpellBonusDamage(7),
        shocks = totemPower.shocks,
        lightning = totemPower.lightning,
        lesserHealingWave = totemPower.lesserHealingWave
    }
    spellPower.max = math.max(spellPower.holy, spellPower.fire, spellPower.nature, spellPower.frost, spellPower.shadow,
                              spellPower.arcane, spellPower.nature + spellPower.lightning)

    return spellPower
end

function CS:GetSpellPowerFromTotem()
    local spellPower = {shocks = 0, lightning = 0, lesserHealingWave = 0}
    if CS.class == "SHAMAN" then
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

function CS:GetSpellDamage(baseDamage)
    local spellDamage = {
        holy = baseDamage,
        fire = baseDamage,
        nature = baseDamage,
        frost = baseDamage,
        shadow = baseDamage,
        arcane = baseDamage
    }
    if CS.class == "MAGE" then
        spellDamage.holy = spellDamage.holy + (CS.talents.arcaneInstability) / 100
        spellDamage.fire = spellDamage.fire + (CS.talents.arcaneInstability + CS.talents.firePower) / 100
        spellDamage.nature = spellDamage.nature + (CS.talents.arcaneInstability) / 100
        spellDamage.frost = spellDamage.frost + (CS.talents.arcaneInstability + CS.talents.piercingIce) / 100
        spellDamage.shadow = spellDamage.shadow + (CS.talents.arcaneInstability) / 100
        spellDamage.arcane = spellDamage.arcane + (CS.talents.arcaneInstability) / 100
    elseif CS.class == "PRIEST" then
        spellDamage.holy = spellDamage.holy + (CS.talents.forceOfWill) / 100
        spellDamage.fire = spellDamage.fire + (CS.talents.forceOfWill) / 100
        spellDamage.nature = spellDamage.nature + (CS.talents.forceOfWill) / 100
        spellDamage.frost = spellDamage.frost + (CS.talents.forceOfWill) / 100
        spellDamage.shadow = spellDamage.shadow + (CS.talents.forceOfWill) / 100
        spellDamage.arcane = spellDamage.arcane + (CS.talents.forceOfWill) / 100
    elseif CS.class == "SHAMAN" then
        spellDamage.lightning = 1 + (CS.talents.concussion) / 100
        spellDamage.shock = 1 + (CS.talents.concussion) / 100
        spellDamage.fireTotem = 1 + (CS.talents.callOfFlame) / 100
    elseif CS.class == "WARLOCK" then
        spellDamage.fire = spellDamage.fire + (CS.talents.emberstorm) / 100
        spellDamage.shadow = spellDamage.shadow + (CS.talents.shadowMastery) / 100
        spellDamage.curseOfAgony = 1 + (CS.talents.improvedAgony) / 100
        spellDamage.immolateDirect = 1 + (CS.talents.improvedImmolate) / 100
    end

    -- TODO: check damage done from buffs (DMF, Master Demonologist, Demonic Sacrifice)

    return spellDamage
end

function CS:GetSpellCrit()
    local spellCrit = {
        holy = GetSpellCritChance(2),
        fire = GetSpellCritChance(3),
        nature = GetSpellCritChance(4),
        frost = GetSpellCritChance(5),
        shadow = GetSpellCritChance(6),
        arcane = GetSpellCritChance(7)
    }

    if CS.class == "MAGE" then
        spellCrit.holy = spellCrit.holy + CS.talents.arcaneInstability
        spellCrit.fire = spellCrit.fire + CS.talents.arcaneInstability + CS.talents.criticalMass
        spellCrit.nature = spellCrit.nature + CS.talents.arcaneInstability
        spellCrit.frost = spellCrit.frost + CS.talents.arcaneInstability
        spellCrit.shadow = spellCrit.shadow + CS.talents.arcaneInstability
        spellCrit.arcane = spellCrit.arcane + CS.talents.arcaneInstability
    elseif CS.class == "PRIEST" then
        spellCrit.holy = spellCrit.holy + CS.talents.forceOfWill + CS.talents.holySpecialization
        spellCrit.fire = spellCrit.fire + CS.talents.forceOfWill
        spellCrit.nature = spellCrit.nature + CS.talents.forceOfWill
        spellCrit.frost = spellCrit.frost + CS.talents.forceOfWill
        spellCrit.shadow = spellCrit.shadow + CS.talents.forceOfWill
        spellCrit.arcane = spellCrit.arcane + CS.talents.forceOfWill
    elseif CS.class == "PALADIN" then
        spellCrit.holy = spellCrit.holy + CS.talents.holyPower
    elseif CS.class == "SHAMAN" then
        spellCrit.lightning = spellCrit.nature + CS.talents.callOfThunder + CS.talents.tidalMastery
        spellCrit.healing = spellCrit.nature + CS.talents.tidalMastery
    elseif CS.class == "WARLOCK" then
        spellCrit.destruction = 0 + CS.talents.devastation
        spellCrit.searingPain = 0 + CS.talents.improvedSearingPain
    end

    spellCrit.max = math.max(spellCrit.holy, spellCrit.fire, spellCrit.nature, spellCrit.frost, spellCrit.shadow,
                             spellCrit.arcane, spellCrit.healing or 0, spellCrit.lightning or 0, spellCrit.destruction or 0,
                             spellCrit.searingPain or 0)

    return spellCrit
end

function CS:GetSpellHit()
    local baseSpellHit = GetSpellHitModifier() or 0
    local spellHit = {
        holy = baseSpellHit,
        fire = baseSpellHit,
        nature = baseSpellHit,
        frost = baseSpellHit,
        shadow = baseSpellHit,
        arcane = baseSpellHit
    }

    if CS.class == "MAGE" then
        spellHit.fire = spellHit.fire + CS.talents.elementalPrecision
        spellHit.frost = spellHit.frost + CS.talents.elementalPrecision
        spellHit.arcane = spellHit.arcane + CS.talents.arcaneFocus
    elseif CS.class == "SHAMAN" then
        spellHit.holy = spellHit.holy + CS.talents.naturesGuidance
        spellHit.fire = spellHit.fire + CS.talents.naturesGuidance
        spellHit.nature = spellHit.nature + CS.talents.naturesGuidance
        spellHit.frost = spellHit.frost + CS.talents.naturesGuidance
        spellHit.shadow = spellHit.shadow + CS.talents.naturesGuidance
        spellHit.arcane = spellHit.arcane + CS.talents.naturesGuidance
    elseif CS.class == "WARLOCK" then
        spellHit.affliction = spellHit.shadow + CS.talents.suppression
    end

    spellHit.max = math.max(spellHit.holy, spellHit.fire, spellHit.nature, spellHit.frost, spellHit.shadow, spellHit.arcane)

    return spellHit
end

function CS:GetHealingDone(baseHealing)
    local healingDone = baseHealing

    if CS.class == "PRIEST" then
        healingDone = healingDone + CS.talents.spiritualHealing / 100
    elseif CS.class == "DRUID" then
        healingDone = healingDone + CS.talents.giftOfNature / 100
    elseif CS.class == "SHAMAN" then
        healingDone = healingDone + CS.talents.purification / 100
    elseif CS.class == "PALADIN" then
        -- TODO
    end

    return healingDone
end

function CS:GetManaRegen()
    local regenCastingModifier = 0
    if CS.class == "MAGE" then
        regenCastingModifier = regenCastingModifier + CS.talents.arcaneMeditation / 100
    elseif CS.class == "PRIEST" then
        regenCastingModifier = regenCastingModifier + CS.talents.meditation / 100
    elseif CS.class == "DRUID" then
        regenCastingModifier = regenCastingModifier + CS.talents.reflection / 100
    end

    -- fix mana regen (GetManaRegen returns base for both base and casting)
    local regenFromSpirit = CS:GetMP2FromSpirit(CS.spirit.stat) / 2
    local regenModifier = CS:GetSpiritRegenModifierFromBuffs()
    regenFromSpirit = regenFromSpirit * regenModifier
    local regenFromGear = CS:GetMP5FromGear() / 5
    regenCastingModifier = math.min(1, regenCastingModifier + CS:GetRegenCastingModifierFromBuffs() +
                                        CS:GetRegenCastingModifierFromSetBonus())

    -- TODO: mana regen from buffs?

    return {
        base = regenFromSpirit + regenFromGear,
        gear = regenFromGear,
        casting = regenFromSpirit * regenCastingModifier + regenFromGear
    }
end

function CS:GetMP2FromSpirit(spirit)
    local mp2 = 0
    if CS.class == "MAGE" or CS.class == "PRIEST" then
        mp2 = 13 + spirit / 4
    elseif CS.class == "DRUID" or CS.class == "SHAMAN" or CS.class == "PALADIN" or CS.class == "HUNTER" then
        mp2 = 15 + spirit / 5
    elseif CS.class == "WARLOCK" then
        mp2 = 8 + spirit / 4
    end
    return mp2
end

function CS:GetMP5FromGear()
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

function CS:GetSpiritRegenModifierFromBuffs()
    local modifier = 1

    -- TODO: do these stack?
    if R:PlayerHasAura(12051) then -- Evocation
        modifier = modifier + 15
    end
    if R:PlayerHasAura(29166) then -- Innervate
        modifier = modifier + 4
    end

    return modifier
end

function CS:GetRegenCastingModifierFromSetBonus()
    local modifier = 0

    -- not Druid (11) or Priest (5)
    if CS.class ~= "DRUID" and CS.class ~= "PRIEST" then
        return modifier
    end

    local firstItemslotIndex = 1
    local lastItemslotIndex = 18

    local vestmentsOfTranscendenceIDs = {
        [16925] = 16925,
        [16926] = 16926,
        [16919] = 16919,
        [16921] = 16921,
        [16920] = 16920,
        [16922] = 16922,
        [16924] = 16924,
        [16923] = 16923
    }
    local stormrageRaimentIDs = {
        [16897] = 16897,
        [16898] = 16898,
        [16899] = 16899,
        [16900] = 16900,
        [16901] = 16901,
        [16902] = 16902,
        [16903] = 16903,
        [16904] = 16904
    }

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

function CS:GetRegenCastingModifierFromBuffs()
    local modifier = 0

    if R:PlayerHasAura(12051) then -- Evocation
        modifier = 1
    elseif R:PlayerHasAura(29166) then -- Innervate
        modifier = 1
    elseif R:PlayerHasAura(23684) or R:PlayerHasAura(23688) then -- Aura of the Blue Dragon (23684/23688)
        modifier = 1
    elseif R:PlayerHasAura(6117) or R:PlayerHasAura(22782) or R:PlayerHasAura(22783) then -- Mage Armor
        modifier = 0.3
    end

    return modifier
end

function CS:GetSkillRankAndModifier(skill)
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

function CS:GetDefense()
    local skillRank, skillModifier = CS:GetSkillRankAndModifier(DEFENSE)

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

function CS:GetPlayerWeaponSkill()
    local totalWeaponSkill = nil
    local mainHandItemId = 16

    if (CS.class == "DRUID") and (CS.stance > 0) then
        totalWeaponSkill = UnitLevel("player") * 5
    else
        local itemId = GetInventoryItemID("player", mainHandItemId)
        if (itemId) then
            local _, _, _, _, _, itemClassId, itemSubClassId = GetItemInfoInstant(itemId)
            if itemSubClassId then
                local weaponString = GetItemSubClassInfo(itemClassId, itemSubClassId)
                if weaponString then
                    local skillRank, skillModifier = CS:GetSkillRankAndModifier(weaponString)
                    if skillRank and skillModifier then
                        totalWeaponSkill = skillRank + skillModifier
                    end
                end
            end
        end
    end

    return totalWeaponSkill
end

function CS:GetShapeshiftForm()
    for i = 1, GetNumShapeshiftForms() do
        if select(2, GetShapeshiftFormInfo(i)) then
            return i
        end
    end

    return 0
end

function CS:GetMelee()
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
        attackRating = {
            mainhandBase = mainhandBase,
            mainhandModifier = mainhandModifier,
            offhandBase = offhandBase,
            offhandModifier = offhandModifier
        },
        crit = GetCritChance() or 0,
        hit = GetHitModifier() or 0
    }

    -- TODO: check damage done from buffs
    -- TODO: check attack power from buffs

    -- calculate miss chance
    local missChanceVsNPC = 5 -- Level 60 npcs with 300 def
    local missChanceVsBoss = 9
    local missChanceVsPlayer = 5 -- Level 60 player def is 300 base

    if CS.weaponSkill then
        local bossDefense = 315 -- level 63
        local playerBossDeltaSkill = bossDefense - CS.weaponSkill

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

function CS:GetRanged()
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
        hit = GetHitModifier() or 0
    }

    -- Biznicks Accurascope
    local itemLink = GetInventoryItemLink("player", 18)
    if itemLink then
        local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
        if enchantId then
            if tonumber(enchantId) == 2523 then
                ranged.hit = ranged.hit + 3
            end
        end
    end

    -- TODO: check damage done from buffs
    -- TODO: check attack power from buffs

    -- calculate miss chance
    local missChanceVsNPC = 5 -- Level 60 npcs with 300 def
    local missChanceVsBoss = 9
    local missChanceVsPlayer = 5 -- Level 60 player def is 300 base

    if CS.weaponSkill then
        local bossDefense = 315 -- level 63
        local playerBossDeltaSkill = bossDefense - CS.weaponSkill

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

function CS:GetTalents()
    if CS.class == "DRUID" then
        return CS:GetDruidTalents()
    elseif CS.class == "MAGE" then
        return CS:GetMageTalents()
    elseif CS.class == "PALADIN" then
        return CS:GetPaladinTalents()
    elseif CS.class == "PRIEST" then
        return CS:GetPriestTalents()
    elseif CS.class == "SHAMAN" then
        return CS:GetShamanTalents()
    elseif CS.class == "WARLOCK" then
        return CS:GetWarlockTalents()
    end
end

function CS:GetDruidTalents()
    local talents = {reflection = 0, giftOfNature = 0}

    if (CS.class == "DRUID") then
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

function CS:GetMageTalents()
    local talents = {
        arcaneInstability = 0,
        criticalMass = 0,
        firePower = 0,
        arcaneFocus = 0,
        elementalPrecision = 0,
        piercingIce = 0,
        arcaneMeditation = 0
    }

    if (CS.class == "MAGE") then
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

function CS:GetPaladinTalents()
    local talents = {healingLight = 0, holyPower = 0, anticipation = 0}

    if (CS.class == "PALADIN") then
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

function CS:GetPriestTalents()
    local talents = {
        improvedPowerWordShield = 0,
        meditation = 0,
        forceOfWill = 0,
        improvedRenew = 0,
        holySpecialization = 0,
        spiritualHealing = 0
    }

    if (CS.class == "PRIEST") then
        -- Improved Power Word: Shield (5, 10, 15)%
        local lookup = {5, 10, 15}
        spellRank = select(5, GetTalentInfo(1, 5))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.improvedPowerWordShield = lookup[spellRank]
        end

        -- Meditation (5, 10, 15)%
        lookup = {5, 10, 15}
        spellRank = select(5, GetTalentInfo(1, 8))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.meditation = lookup[spellRank]
        end

        -- Force of Will (1, 2, 3, 4, 5)%
        lookup = {1, 2, 3, 4, 5}
        spellRank = select(5, GetTalentInfo(1, 14))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.forceOfWill = lookup[spellRank]
        end

        -- Improved Renew (5, 10, 15)%
        lookup = {5, 10, 15}
        local spellRank = select(5, GetTalentInfo(2, 2))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.improvedRenew = lookup[spellRank]
        end

        -- Holy Specialization (1, 2, 3, 4, 5)%
        lookup = {1, 2, 3, 4, 5}
        local spellRank = select(5, GetTalentInfo(2, 3))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.holySpecialization = lookup[spellRank]
        end

        -- Spiritual Healing (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        local spellRank = select(5, GetTalentInfo(2, 15))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.spiritualHealing = lookup[spellRank]
        end
    end

    return talents
end

function CS:GetShamanTalents()
    local talents = {concussion = 0, callOfFlame = 0, callOfThunder = 0, naturesGuidance = 0, tidalMastery = 0, purification = 0}

    if (CS.class == "SHAMAN") then
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

function CS:GetWarlockTalents()
    local talents = {
        suppression = 0,
        improvedAgony = 0,
        shadowMastery = 0,
        improvedVoidwalker = 0,
        improvedSpellstone = 0,
        devastation = 0,
        improvedSearingPain = 0,
        improvedImmolate = 0,
        emberstorm = 0
    }

    if (CS.class == "WARLOCK") then
        -- Suppression (2, 4, 6, 8, 10)%
        local lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(1, 1))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.suppression = lookup[spellRank]
        end

        -- Improved Curse of Agony (2, 4, 6)%
        lookup = {2, 4, 6}
        spellRank = select(5, GetTalentInfo(1, 7))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.improvedAgony = lookup[spellRank]
        end

        -- Shadow Mastery (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(1, 16))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.shadowMastery = lookup[spellRank]
        end

        -- Improved Voidwalker (10, 20, 30)%
        lookup = {10, 20, 30}
        local spellRank = select(5, GetTalentInfo(2, 5))
        if (spellRank > 0) and (spellRank <= 3) then
            talents.improvedVoidwalker = lookup[spellRank]
        end

        -- Improved Spellstone (15, 30)%
        lookup = {15, 30}
        spellRank = select(5, GetTalentInfo(2, 17))
        if (spellRank > 0) and (spellRank <= 2) then
            talents.improvedSpellstone = lookup[spellRank]
        end

        -- Devestation (1, 2, 3, 4, 5)%
        lookup = {1, 2, 3, 4, 5}
        spellRank = select(5, GetTalentInfo(3, 7))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.devastation = lookup[spellRank]
        end

        -- Improved Searing Pain (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(3, 11))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.improvedSearingPain = lookup[spellRank]
        end

        -- Improved Immolate (5, 10, 15, 20, 25)%
        lookup = {5, 10, 15, 20, 25}
        spellRank = select(5, GetTalentInfo(3, 13))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.improvedImmolate = lookup[spellRank]
        end

        -- Emberstorm (2, 4, 6, 8, 10)%
        lookup = {2, 4, 6, 8, 10}
        spellRank = select(5, GetTalentInfo(3, 15))
        if (spellRank > 0) and (spellRank <= 5) then
            talents.emberstorm = lookup[spellRank]
        end
    end

    return talents
end
