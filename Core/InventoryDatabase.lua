local addonName, ns = ...
local R = _G.ReduxUI
local ID = R:AddModule("InventoryDatabase", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local CS = R.Modules.CharacterStats

local bagIDs = {bags = {0, 1, 2, 3, 4, -2}, bank = {-1, 5, 6, 7, 8, 9, 10}}

function ID:Initialize()
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
    local db = R.config.db.realm.inventory[CS.name]
    if not db then
        R.config.db.realm.inventory[CS.name] = {}
        db = R.config.db.realm.inventory[CS.name]
    end

    db.class = CS.class
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
    for i, slot in next, R.EquipmentSlots do
        local link = GetInventoryItemLink("player", GetInventorySlotInfo(slot))
        if link then
            local itemId = R:GetItemIdFromLink(link)
            if itemId then
                db.equipped["" .. itemId] = 1
            end
        end
    end
end

function ID:StoreBagContents(db)
    for i, bagID in next, bagIDs.bags do
        local numSlots = GetContainerNumSlots(bagID)
        for slotID = 1, numSlots do
            local itemId = select(10, GetContainerItemInfo(bagID, slotID))
            ID:UpdateItemCount(itemId, db)
        end
    end
end

function ID:StoreBankContents(db)
    for i, bagID in next, bagIDs.bank do
        local numSlots = GetContainerNumSlots(bagID)
        for slotID = 1, numSlots do
            local itemId = select(10, GetContainerItemInfo(bagID, slotID))
            ID:UpdateItemCount(itemId, db)
        end
    end
end
