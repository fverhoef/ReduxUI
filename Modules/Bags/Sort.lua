local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags
local L = R.L

local isEquipmentSlot = {
    INVTYPE_HEAD = true,
    INVTYPE_NECK = true,
    INVTYPE_SHOULDER = true,
    INVTYPE_BODY = true,
    INVTYPE_CHEST = true,
    INVTYPE_WAIST = true,
    INVTYPE_LEGS = true,
    INVTYPE_FEET = true,
    INVTYPE_WRIST = true,
    INVTYPE_HAND = true,
    INVTYPE_FINGER = true,
    INVTYPE_TRINKET = true,
    INVTYPE_WEAPON = true,
    INVTYPE_SHIELD = true,
    INVTYPE_RANGED = true,
    INVTYPE_CLOAK = true,
    INVTYPE_2HWEAPON = true,
    INVTYPE_TABARD = true,
    INVTYPE_ROBE = true,
    INVTYPE_WEAPONMAINHAND = true,
    INVTYPE_WEAPONOFFHAND = true,
    INVTYPE_HOLDABLE = true,
    INVTYPE_THROWN = true,
    INVTYPE_RANGEDRIGHT = true
}

local function CanItemGoInBag(itemID, bag)
    local bagID = bag:GetID()
    local sortingConfig = bag.config.sorting[bagID]
    if not sortingConfig then
        bag.config.sorting[bagID] = {}
        sortingConfig = bag.config.sorting[bagID]
    end
    if not sortingConfig.filter then
        sortingConfig.filter = {}
    end

    local _, _, rarity, _, _, _, _, _, equipSlot, _, sellPrice, classID, _, bindType, _, _, isReagent = GetItemInfo(itemID)

    if classID == 0 and sortingConfig.filter[Enum.BagSlotFlags.PriorityConsumables] then
        return true
    elseif classID == 7 and sortingConfig.filter[Enum.BagSlotFlags.PriorityTradeGoods] then
        return true
    elseif (classID == 12 or bindType == 4) and sortingConfig.filter[Enum.BagSlotFlags.PriorityQuestItems] then
        return true
    elseif ((rarity and rarity == ITEMQUALITY_POOR) and sellPrice) and sortingConfig.filter[Enum.BagSlotFlags.PriorityJunk] then
        return true
    elseif isEquipmentSlot[equipSlot] and sortingConfig.filter[Enum.BagSlotFlags.PriorityEquipment] then
        return true
    end

    local itemFamily = (equipSlot == "INVTYPE_BAG" and 1) or GetItemFamily(itemID)
    if itemFamily then
        local bagFamily = select(2, GetContainerNumFreeSlots(bag))
        return (bagFamily == 0) or band(itemFamily, bagFamily) > 0
    else
        return false
    end
end

function B:Sort(container)
    if InCombatLockdown() or UnitIsDead("player") then
        return
    end

    for _, bag in ipairs(container.Bags) do
        for slot = 1, GetContainerNumSlots(bag:GetID()) do

        end
    end
end
