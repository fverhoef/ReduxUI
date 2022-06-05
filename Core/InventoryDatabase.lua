local addonName, ns = ...
local R = _G.ReduxUI
local ID = R:AddModule("InventoryDatabase", "AceEvent-3.0")
ID.earned = 0
ID.spent = 0

local bagIDs = {bags = {0, 1, 2, 3, 4, -2}, bank = {-1, 5, 6, 7, 8, 9, 10}, reagentBank = {}}
if R.isRetail then
    table.insert(bagIDs.bank, 11)
    table.insert(bagIDs.reagentBank, -3)
end

function ID:Initialize() end

function ID:Enable()
    ID:RegisterEvent("BAG_SLOT_FLAGS_UPDATED", ID.Update)
    ID:RegisterEvent("BAG_UPDATE", ID.Update)
    ID:RegisterEvent("BAG_UPDATE_COOLDOWN", ID.Update)
    ID:RegisterEvent("BAG_NEW_ITEMS_UPDATED", ID.Update)
    ID:RegisterEvent("QUEST_ACCEPTED", ID.Update)
    ID:RegisterEvent("QUEST_REMOVED", ID.Update)
    ID:RegisterEvent("PLAYER_MONEY", ID.Update)
    ID:RegisterEvent("PLAYER_TRADE_MONEY", ID.Update)
    ID:RegisterEvent("TRADE_MONEY_CHANGED", ID.Update)
    ID:RegisterEvent("SEND_MAIL_MONEY_CHANGED", ID.Update)
    ID:RegisterEvent("SEND_MAIL_COD_CHANGED", ID.Update)
    ID:RegisterEvent("BANKFRAME_OPENED", ID.Update)
    ID:RegisterEvent("BANKFRAME_CLOSED", ID.Update)
    ID:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED", ID.Update)
    if R.isRetail then ID:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED", ID.Update) end
    ID:Update()
end

function ID:Update()
    local db = ID:GetCharacterDatabase()

    local oldMoney = db.money
    local newMoney = GetMoney()
    local change = newMoney - oldMoney
    if change < 0 then
        ID.spent = ID.spent - change
    else
        ID.earned = ID.earned + change
    end
    ID.profit = ID.earned - ID.spent

    db.money = newMoney

    db.equipped = {}
    ID:StoreEquippedItems(db)

    db.bags = {}
    db.bank = {}
    ID:StoreBagContents(db)
    ID:StoreBankContents(db)
    ID:StoreReagentBankContents(db)
end

function ID:GetCharacterDatabase()
    local db = R.config.db.realm.inventory[R.PlayerInfo.name]
    if not db then
        R.config.db.realm.inventory[R.PlayerInfo.name] = {}
        db = R.config.db.realm.inventory[R.PlayerInfo.name]
    end

    db.class = R.PlayerInfo.class
    db.bags = db.bags or {}
    db.bank = db.bank or {}
    db.equipped = db.equipped or {}

    return db
end

function ID:GetCharacterKeys()
    local keys = {}
    for key, _ in pairs(R.config.db.realm.inventory) do keys[key] = key end

    return keys
end

function ID:ClearCharacterDatabase(name) if name and R.config.db.realm.inventory[name] then R.config.db.realm.inventory[name] = nil end end

function ID:GetItemCount(itemId)
    local chars = {}
    for i, char in next, R.config.db.realm.inventory do
        local bagCount = char.bags and char.bags[itemId] or 0
        local bankCount = char.bank and char.bank[itemId] or 0
        local equippedCount = char.equipped and char.equipped[itemId] or 0
        if bagCount > 0 or bankCount > 0 or equippedCount > 0 then chars[i] = {class = char.class, bag = bagCount, bank = bankCount, equipped = equippedCount} end
    end

    return chars
end

function ID:UpdateItemCount(itemId, db)
    if not itemId then return end
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
            if itemId then db.equipped["" .. itemId] = 1 end
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

function ID:StoreReagentBankContents(db)
    for i, bagID in next, bagIDs.reagentBank do
        local numSlots = GetContainerNumSlots(bagID)
        for slotID = 1, numSlots do
            local itemId = select(10, GetContainerItemInfo(bagID, slotID))
            ID:UpdateItemCount(itemId, db)
        end
    end
end
