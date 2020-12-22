local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local B = Addon.Modules.Bags
local ID = Addon.Modules.InventoryDatabase

function ID:OnEnable()
    ID:RegisterEvent("BAG_SLOT_FLAGS_UPDATED", ID.Update)
    ID:RegisterEvent("BAG_UPDATE", ID.Update)
    ID:RegisterEvent("BAG_UPDATE_COOLDOWN", ID.Update)
    ID:RegisterEvent("BAG_NEW_ITEMS_UPDATED", ID.Update)
    ID:RegisterEvent("QUEST_ACCEPTED", ID.Update)
    ID:RegisterEvent("QUEST_REMOVED", ID.Update)
    ID:RegisterEvent("PLAYER_MONEY", ID.Update)
    ID:RegisterEvent("PLAYER_TRADE_MONEY", ID.Update)
    ID:RegisterEvent("BANKFRAME_OPENED", ID.Update)
    ID:RegisterEvent("BANKFRAME_CLOSED", ID.Update)
    ID:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED", ID.Update)
    ID:Update()
end

function ID:Update()
    local db = ID:GetCharacterDatabase()
    db.money = GetMoney()

    db.equipped = {}
    ID:StoreEquippedItems(db)

    db.bags = {}
    db.bank = {}
    ID:StoreBagContents(db)
    ID:StoreBankContents(db)
end

function ID:GetCharacterDatabase()
    local db = Addon.config.db.realm.inventory[Addon.PlayerName]
    if not db then
        Addon.config.db.realm.inventory[Addon.PlayerName] = {}
        db = Addon.config.db.realm.inventory[Addon.PlayerName]
    end

    db.class = Addon.PlayerClass
    db.bags = db.bags or {}
    db.bank = db.bank or {}
    db.equipped = db.equipped or {}

    return db
end

function ID:UpdateItemCount(itemId, db)
    if not itemId then
        return
    end
    db = db or ID:GetCharacterDatabase()

    local equippedCount = db.equipped["" .. itemId] or 0
    local inventoryCount = GetItemCount(itemId, false) - equippedCount
    local allCount = GetItemCount(itemId, true) - equippedCount
    local bankCount = allCount - inventoryCount

    db.bags["" .. itemId] = inventoryCount
    db.bank["" .. itemId] = bankCount
end

function ID:StoreEquippedItems(db)
    for i, slot in next, Addon.EquipmentSlots do
        local link = GetInventoryItemLink("player", GetInventorySlotInfo(slot))
        if link then
            local itemId = Addon:GetItemIdFromLink(link)
            if itemId then
                db.equipped["" .. itemId] = 1
            end
        end
    end
end

function ID:StoreBagContents(db)
    for _, bag in ipairs(B.Inventory.Bags) do
        local bagID = bag:GetID()
        local numSlots = GetContainerNumSlots(bagID)
        for slotID = 1, numSlots do
            local itemId = select(10, GetContainerItemInfo(bagID, slotID))
            ID:UpdateItemCount(itemId, db)
        end
    end
end

function ID:StoreBankContents(db)
    for _, bag in ipairs(B.Bank.Bags) do
        local bagID = bag:GetID()
        local numSlots = GetContainerNumSlots(bagID)
        for slotID = 1, numSlots do
            local itemId = select(10, GetContainerItemInfo(bagID, slotID))
            ID:UpdateItemCount(itemId, db)
        end
    end
end