local addonName, ns = ...
local R = _G.ReduxUI
local L = R.L

R.GearScore = CreateFrame("Frame")
R.GearScore:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, event, ...)
end)

local GUIDIsPlayer = C_PlayerInfo.GUIDIsPlayer

local BRACKET_SIZE = 1000
local MAX_SCORE = BRACKET_SIZE * 6 - 1

R.GearScore.ItemTypes = {
    ["INVTYPE_RELIC"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
    ["INVTYPE_TRINKET"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 33, ["Enchantable"] = false },
    ["INVTYPE_2HWEAPON"] = { ["SlotMOD"] = 2.000, ["ItemSlot"] = 16, ["Enchantable"] = true },
    ["INVTYPE_WEAPONMAINHAND"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 16, ["Enchantable"] = true },
    ["INVTYPE_WEAPONOFFHAND"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = true },
    ["INVTYPE_RANGED"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = true },
    ["INVTYPE_THROWN"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
    ["INVTYPE_RANGEDRIGHT"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
    ["INVTYPE_SHIELD"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = true },
    ["INVTYPE_WEAPON"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 36, ["Enchantable"] = true },
    ["INVTYPE_HOLDABLE"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = false },
    ["INVTYPE_HEAD"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 1, ["Enchantable"] = true },
    ["INVTYPE_NECK"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 2, ["Enchantable"] = false },
    ["INVTYPE_SHOULDER"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 3, ["Enchantable"] = true },
    ["INVTYPE_CHEST"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 5, ["Enchantable"] = true },
    ["INVTYPE_ROBE"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 5, ["Enchantable"] = true },
    ["INVTYPE_WAIST"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 6, ["Enchantable"] = false },
    ["INVTYPE_LEGS"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 7, ["Enchantable"] = true },
    ["INVTYPE_FEET"] = { ["SlotMOD"] = 0.75, ["ItemSlot"] = 8, ["Enchantable"] = true },
    ["INVTYPE_WRIST"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 9, ["Enchantable"] = true },
    ["INVTYPE_HAND"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 10, ["Enchantable"] = true },
    ["INVTYPE_FINGER"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 31, ["Enchantable"] = false },
    ["INVTYPE_CLOAK"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 15, ["Enchantable"] = true },
    ["INVTYPE_BODY"] = { ["SlotMOD"] = 0, ["ItemSlot"] = 4, ["Enchantable"] = false }
}

R.GearScore.Formula = {
    ["A"] = { [4] = { ["A"] = 91.4500, ["B"] = 0.6500 }, [3] = { ["A"] = 81.3750, ["B"] = 0.8125 }, [2] = { ["A"] = 73.0000, ["B"] = 1.0000 } },
    ["B"] = { [4] = { ["A"] = 26.0000, ["B"] = 1.2000 }, [3] = { ["A"] = 0.7500, ["B"] = 1.8000 }, [2] = { ["A"] = 8.0000, ["B"] = 2.0000 }, [1] = { ["A"] = 0.0000, ["B"] = 2.2500 } }
}

R.GearScore.Quality = {
    [BRACKET_SIZE * 6] = {
        ["Red"] = { ["A"] = 0.94, ["B"] = BRACKET_SIZE * 5, ["C"] = 0.00006, ["D"] = 1 },
        ["Blue"] = { ["A"] = 0.47, ["B"] = BRACKET_SIZE * 5, ["C"] = 0.00047, ["D"] = -1 },
        ["Green"] = { ["A"] = 0, ["B"] = 0, ["C"] = 0, ["D"] = 0 },
        ["Description"] = L["Legendary"]
    },
    [BRACKET_SIZE * 5] = {
        ["Red"] = { ["A"] = 0.69, ["B"] = BRACKET_SIZE * 4, ["C"] = 0.00025, ["D"] = 1 },
        ["Blue"] = { ["A"] = 0.28, ["B"] = BRACKET_SIZE * 4, ["C"] = 0.00019, ["D"] = 1 },
        ["Green"] = { ["A"] = 0.97, ["B"] = BRACKET_SIZE * 4, ["C"] = 0.00096, ["D"] = -1 },
        ["Description"] = L["Epic"]
    },
    [BRACKET_SIZE * 4] = {
        ["Red"] = { ["A"] = 0.0, ["B"] = BRACKET_SIZE * 3, ["C"] = 0.00069, ["D"] = 1 },
        ["Blue"] = { ["A"] = 0.5, ["B"] = BRACKET_SIZE * 3, ["C"] = 0.00022, ["D"] = -1 },
        ["Green"] = { ["A"] = 1, ["B"] = BRACKET_SIZE * 3, ["C"] = 0.00003, ["D"] = -1 },
        ["Description"] = L["Superior"]
    },
    [BRACKET_SIZE * 3] = {
        ["Red"] = { ["A"] = 0.12, ["B"] = BRACKET_SIZE * 2, ["C"] = 0.00012, ["D"] = -1 },
        ["Blue"] = { ["A"] = 1, ["B"] = BRACKET_SIZE * 2, ["C"] = 0.00050, ["D"] = -1 },
        ["Green"] = { ["A"] = 0, ["B"] = BRACKET_SIZE * 2, ["C"] = 0.001, ["D"] = 1 },
        ["Description"] = L["Uncommon"]
    },
    [BRACKET_SIZE * 2] = {
        ["Red"] = { ["A"] = 1, ["B"] = BRACKET_SIZE, ["C"] = 0.00088, ["D"] = -1 },
        ["Blue"] = { ["A"] = 1, ["B"] = 000, ["C"] = 0.00000, ["D"] = 0 },
        ["Green"] = { ["A"] = 1, ["B"] = BRACKET_SIZE, ["C"] = 0.001, ["D"] = -1 },
        ["Description"] = L["Common"]
    },
    [BRACKET_SIZE] = {
        ["Red"] = { ["A"] = 0.55, ["B"] = 0, ["C"] = 0.00045, ["D"] = 1 },
        ["Blue"] = { ["A"] = 0.55, ["B"] = 0, ["C"] = 0.00045, ["D"] = 1 },
        ["Green"] = { ["A"] = 0.55, ["B"] = 0, ["C"] = 0.00045, ["D"] = 1 },
        ["Description"] = L["Trash"]
    }
}

function R.GearScore:GetQuality(score)
    score = tonumber(score)
    if not score then
        return 0, 0, 0, L["Trash"]
    end
    if score > MAX_SCORE then
        score = MAX_SCORE
    end

    local r = 0.1
    local g = 0.1
    local b = 0.1
    local description = L["Legendary"]

    for i = 0, 6 do
        if (score > i * BRACKET_SIZE) and (score <= ((i + 1) * BRACKET_SIZE)) then
            local r = R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Red["A"] +
                          (((score - R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Red["B"]) * R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Red["C"]) *
                              R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Red["D"])
            local g = R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Green["A"] +
                          (((score - R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Green["B"]) * R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Green["C"]) *
                              R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Green["D"])
            local b = R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Blue["A"] +
                          (((score - R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Blue["B"]) * R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Blue["C"]) *
                              R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Blue["D"])
            return r, g, b, R.GearScore.Quality[(i + 1) * BRACKET_SIZE].Description
        end
    end

    return 0.1, 0.1, 0.1, "Trash"
end

function R.GearScore:GetItemScore(itemLink)
    if not itemLink then
        return 0, 0, 0.1, 0.1, 0.1
    end

    local _, itemLink, rarity, itemLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
    if itemLink and rarity and itemLevel and itemEquipLoc and R.GearScore.ItemTypes[itemEquipLoc] then
        local qualityScale = 1
        local score = 0
        local scale = 1.8618
        if rarity == 5 then
            qualityScale = 1.3
            rarity = 4
        elseif rarity == 1 then
            qualityScale = 0.005
            rarity = 2
        elseif rarity == 0 then
            qualityScale = 0.005
            rarity = 2
        elseif rarity == 7 then
            rarity = 3
            itemLevel = 187.05
        end

        if itemLevel > 120 then
            formula = R.GearScore.Formula["A"]
        else
            formula = R.GearScore.Formula["B"]
        end

        if rarity >= 2 and rarity <= 4 then
            local r, g, b = R.GearScore:GetQuality((floor(((itemLevel - formula[rarity].A) / formula[rarity].B) * 1 * scale)) * 11.25)
            score = floor(((itemLevel - formula[rarity].A) / formula[rarity].B) * R.GearScore.ItemTypes[itemEquipLoc].SlotMOD * scale * qualityScale)
            if (itemLevel == 187.05) then
                itemLevel = 0
            end
            if score < 0 then
                score = 0
                r, g, b = R.GearScore:GetQuality(1)
            end
            return score, itemLevel, r, g, b, itemEquipLoc
        end
    end

    return 0, 0, 0.1, 0.1, 0.1, 0
end

function R.GearScore:GetScore(unitOrGuid, callback)
    local guid
    if unitOrGuid then
        if GUIDIsPlayer(unitOrGuid) then
            guid = unitOrGuid
        elseif UnitIsPlayer(unitOrGuid) then
            guid = UnitGUID(unitOrGuid)
        end
    end

    if not guid then
        return 0, 0
    end

    local items
    local class
    local gearScore = 0
    local totalItemLevel = 0
    local itemCount = 0

    if guid ~= R.PlayerInfo.guid then
        local inspectItems = R.Inspect.InventoryCache[guid]
        if not inspectItems then
            R.Inspect:StartInspect(guid, callback)
            return 0, 0, 0, true, false
        else
            items = {}
            local cacheComplete = true
            for slot, itemId in pairs(inspectItems) do
                if slot ~= "ShirtSlot" and slot ~= "TabardSlot" then
                    local item = Item:CreateFromItemID(itemId)
                    if not item:IsItemDataCached() then
                        item:ContinueOnItemLoad(callback)
                        cacheComplete = false
                    end

                    items[slot] = itemId
                end
            end

            if not cacheComplete then
                return 0, 0, 0, false, true
            end

            class = select(2, UnitClass(R:PlayerGUIDToUnitToken(guid)))
        end
    else
        items = R:GetPlayerEquippedItems()
        class = R.PlayerInfo.class
    end

    local titanGrip = 1
    if items["MainHandSlot"] and items["SecondaryHandSlot"] then
        local itemEquipLoc = select(9, GetItemInfo(items["MainHandSlot"]))
        if itemEquipLoc == "INVTYPE_2HWEAPON" then
            titanGrip = 0.5
        end
    end

    if items["SecondaryHandSlot"] then
        local itemEquipLoc = select(9, GetItemInfo(items["SecondaryHandSlot"]))
        if itemEquipLoc == "INVTYPE_2HWEAPON" then
            titanGrip = 0.5
        end

        local itemScore, itemLevel = R.GearScore:GetItemScore(items["SecondaryHandSlot"])
        if class == "HUNTER" then
            itemScore = itemScore * 0.3164
        end
        gearScore = itemScore * titanGrip
        itemCount = itemCount + 1
        totalItemLevel = totalItemLevel + itemLevel
    end

    for slot, itemId in pairs(items) do
        if slot ~= "ShirtSlot" and slot ~= "TabardSlot" and slot ~= "SecondaryHandSlot" then
            local itemScore, itemLevel = R.GearScore:GetItemScore(itemId)
            if class == "HUNTER" then
                if slot == "MainHandSlot" then
                    itemScore = itemScore * 0.3164
                elseif slot == "RangedSlot" then
                    itemScore = itemScore * 5.3224
                end
            end
            if slot == "MainHandSlot" then
                itemScore = itemScore * titanGrip
            end

            gearScore = gearScore + itemScore
            itemCount = itemCount + 1
            totalItemLevel = totalItemLevel + itemLevel
        end
    end

    if gearScore > 0 and itemCount > 0 then
        return math.floor(gearScore), math.floor(totalItemLevel / itemCount), R:GetMinimumItemQuality(items)
    end

    return 0, 0, 0
end
