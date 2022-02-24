local addonName, ns = ...
local R = _G.ReduxUI
local B = R:AddModule("Bags", "AceEvent-3.0", "AceHook-3.0")

local BANK_CONTAINER = _G.BANK_CONTAINER
local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER

function B:Initialize()
end

function B:Enable()
    if not B.config.enabled then return end

    B.Inventory = CreateFrame("Frame", addonName .. "InventoryFrame", UIParent, "InventoryFrameTemplate")
    B.Bank = CreateFrame("Frame", addonName .. "BankFrame", UIParent, "BankFrameTemplate")
    B:RegisterEvent("BANKFRAME_OPENED")
    B:RegisterEvent("BANKFRAME_CLOSED")

    B:RegisterEvent("BAG_NEW_ITEMS_UPDATED")
    B:RegisterEvent("BAG_SLOT_FLAGS_UPDATED")
    B:RegisterEvent("BAG_UPDATE")
    B:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED")
    B:RegisterEvent("ITEM_LOCK_CHANGED")
    B:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
    B:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
    B:RegisterEvent("QUEST_ACCEPTED")
    B:RegisterEvent("QUEST_REMOVED")
    if R.isRetail then B:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED") end
end

function B:BAG_SLOT_FLAGS_UPDATED(event, slot)
    if B.Inventory:IsShown() then B.Inventory:Update() end
    if B.Bank:IsShown() then B.Bank:Update() end
end

function B:BAG_UPDATE(event, bagID)
    if B.Inventory:IsShown() then
        local bag = B:FindBag(bagID)
        if bag then bag:Update() end
        local bagSlot = B:FindBagSlot(bagID)
        if bagSlot then bagSlot:Update() end
    end
end

function B:BAG_UPDATE_COOLDOWN(event)
    if B.Inventory:IsShown() then B.Inventory:Update() end
    if B.Bank:IsShown() then B.Bank:Update() end
end

function B:BAG_NEW_ITEMS_UPDATED(event)
    if B.Inventory:IsShown() then B.Inventory:Update() end
    if B.Bank:IsShown() then B.Bank:Update() end
end

function B:ITEM_LOCK_CHANGED(event, bagID, slotIndex)
    if B.Inventory:IsShown() then
        local button = B:FindBagButton(bagID, slotIndex)
        if button then button:UpdateContainerButtonLockedState(bagID, slotIndex) end
    end
end

function B:QUEST_ACCEPTED(event)
    if B.Inventory:IsShown() then B.Inventory:Update() end
    if B.Bank:IsShown() then B.Bank:Update() end
end

function B:QUEST_REMOVED(event)
    if B.Inventory:IsShown() then B.Inventory:Update() end
    if B.Bank:IsShown() then B.Bank:Update() end
end

function B:BANKFRAME_OPENED(event) B:ShowBank() end

function B:BANKFRAME_CLOSED(event) B:HideBank() end

function B:BANK_BAG_SLOT_FLAGS_UPDATED(event, slot) if B.Bank:IsShown() then B.Bank:Update() end end

function B:PLAYERBANKSLOTS_CHANGED(event, slot)
    if B.Bank:IsShown() then
        B:FindBag(BANK_CONTAINER):Update()
        B:FindBagSlot(BANK_CONTAINER):Update()
    end
end

function B:PLAYERBANKBAGSLOTS_CHANGED(event) if B.Bank:IsShown() then B.Bank:Update() end end

function B:PLAYERREAGENTBANKSLOTS_CHANGED(event) if B.Bank:IsShown() then B:FindBag(REAGENTBANK_CONTAINER):Update() end end

function B:FindBag(bagID) return B.Inventory.BagsById[bagID] or B.Bank.BagsById[bagID] end

function B:FindBagSlot(bagID) return B.Inventory.BagSlotsById[bagID] or B.Bank.BagSlotsById[bagID] end

function B:FindBagButton(bagID, slotIndex)
    local bag = B:FindBag(bagID)
    if bag then return bag.Buttons[slotIndex] end
end
