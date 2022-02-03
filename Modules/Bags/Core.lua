local addonName, ns = ...
local R = _G.ReduxUI
local B = R:AddModule("Bags", "AceEvent-3.0", "AceHook-3.0")

local BACKPACK_CONTAINER = _G.BACKPACK_CONTAINER
local BANK_CONTAINER = _G.BANK_CONTAINER
local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER
local KEYRING_CONTAINER = _G.KEYRING_CONTAINER or -2
local MAX_CONTAINER_ITEMS = _G.MAX_CONTAINER_ITEMS or 36
local REAGENTBANK_SIZE = 98

function B:Initialize()
    if not B.config.enabled then
        return
    end

    B:DisableBlizzardFrames()
    B.Inventory = B:CreateInventoryFrame()
    B.Bank = B:CreateBankFrame()

    B:RegisterEvent("BAG_SLOT_FLAGS_UPDATED")
    B:RegisterEvent("BAG_UPDATE")
    B:RegisterEvent("BAG_NEW_ITEMS_UPDATED")
    B:RegisterEvent("QUEST_ACCEPTED")
    B:RegisterEvent("QUEST_REMOVED")
    B:RegisterEvent("ITEM_LOCK_CHANGED")
    B:RegisterEvent("BANKFRAME_OPENED")
    B:RegisterEvent("BANKFRAME_CLOSED")
    B:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED")
    B:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
    B:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
    B:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED")
end

function B:BAG_SLOT_FLAGS_UPDATED(event, slot)
    -- TODO: only update one slot
    B:UpdateInventory()
end

function B:BAG_UPDATE(event, bagID)
    -- TODO: only update one bag
    B:UpdateInventory()
end

function B:BAG_UPDATE_COOLDOWN(event)
    B:UpdateInventory()
end

function B:BAG_NEW_ITEMS_UPDATED(event)
    B:UpdateInventory()
end

function B:ITEM_LOCK_CHANGED(event, bagID, slotIndex)
    B:UpdateLocked(bagID, slotIndex)
end

function B:QUEST_ACCEPTED(event)
    B:UpdateInventory()
end

function B:QUEST_REMOVED(event)
    B:UpdateInventory()
end

function B:BANKFRAME_OPENED(event)
    B:ShowBank()
end

function B:BANKFRAME_CLOSED(event)
    B:HideBank()
end

function B:BANK_BAG_SLOT_FLAGS_UPDATED(event, slot)
    -- TODO: only update one slot
    B:UpdateBank()
end

function B:PLAYERBANKSLOTS_CHANGED(event, slot)
    -- TODO: only update one slot
    B:UpdateBank()
end

function B:PLAYERBANKBAGSLOTS_CHANGED(event)
    B:UpdateBank()
end

function B:PLAYERREAGENTBANKSLOTS_CHANGED(event)
    B:UpdateBank()
end

function B:DisableBlizzardFrames()
    for i = 1, NUM_CONTAINER_FRAMES do
        local frame = _G["ContainerFrame" .. i]
        frame:SetParent(R.HiddenFrame)
    end
    BankFrame:SetParent(R.HiddenFrame)
end

function B:FindBag(bagID)
    return B.Inventory.BagsById[bagID] or B.Bank.BagsById[bagID]
end

function B:CreateContainerFrame(bagID, parent)
    local bag = CreateFrame("Frame", addonName .. "ContainerFrame" .. bagID, parent)
    bag:SetID(bagID)
    bag.Buttons = {}
    bag.Hidden = bagID == KEYRING_CONTAINER
    local numItems = bagID == REAGENTBANK_CONTAINER and REAGENTBANK_SIZE or MAX_CONTAINER_ITEMS
    for slot = 1, numItems do
        bag.Buttons[slot] = B:CreateContainerButton(bagID, slot, bag)
    end

    return bag
end

function B:CreateContainerButton(bagID, slot, parent)
    local template = (bagID == BANK_CONTAINER and "BankItemButtonGenericTemplate") or (bagID == REAGENTBANK_CONTAINER and "ReagentBankItemButtonGenericTemplate") or "ContainerFrameItemButtonTemplate"
    local button = CreateFrame(R.isRetail and "ItemButton" or "CheckButton", addonName .. "Container" .. bagID .. "Button" .. slot, parent, template)
    button:SetSize(37, 37)
    button:SetID(slot)

    return button
end

function B:CreateBagSlotButton(bagID, parent, frame)
    local bagNumber = isBank and (bagID == BANK_CONTAINER and 0 or (bagID - 4)) or (bagID - (R.isRetail and 0 or 1))
    local name = bagID == BACKPACK_CONTAINER and "Backpack" or bagID == KEYRING_CONTAINER and "KeyRing" or string.format("ReduxUI__BAG%d%s", bagNumber, R.isRetail and "" or "SLOT")

    local button = CreateFrame(R.isRetail and "ItemButton" or "CheckButton", name, parent)
    button.frame = frame
    button.bagID = bagID
    button.isBank = bagID == BANK_CONTAINER or bagID > 4
    button:SetID(bagID)
    if not R.isRetail then
        button:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
        button:SetChecked(bagID ~= KEYRING_CONTAINER)
    else
        button.SlotHighlightTexture = button:CreateTexture(nil, "OVERLAY")
        button.SlotHighlightTexture:SetTexture("Interface\\Buttons\\CheckButtonHilight")
        button.SlotHighlightTexture:SetAllPoints()
        button.SlotHighlightTexture:SetBlendMode("ADD")
        button.SlotHighlightTexture:SetShown(bagID ~= KEYRING_CONTAINER)
    end

    button.SlotCount = button:CreateFontString(nil, "OVERLAY")
    button.SlotCount:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 4)
    button.SlotCount:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

    local backgroundSize = bagID == BACKPACK_CONTAINER and 72 or 64
    button.Background = button:CreateTexture(nil, "BACKGROUND")
    button.Background:SetTexture([[Interface\SpellBook\SpellBook-SkillLineTab]])
    button.Background:SetTexCoord(1, 0, 0, 1)

    if bagID == BACKPACK_CONTAINER then
        button:SetSize(36, 36)
        button.Background:SetPoint("TOPRIGHT", button, "TOPRIGHT", 2, 12)
        button.Background:SetSize(72, 72)
    else
        button:SetSize(34, 34)
        button.Background:SetPoint("TOPRIGHT", button, "TOPRIGHT", 2, 10)
        button.Background:SetSize(64, 64)
    end

    if bagID == BACKPACK_CONTAINER then
        SetItemButtonTexture(button, "Interface\\Buttons\\Button-Backpack-Up")
    elseif bagID == KEYRING_CONTAINER then
        SetItemButtonTexture(button, "Interface\\ContainerFrame\\KeyRing-Bag-Icon")
    elseif bagID == BANK_CONTAINER then
        SetItemButtonTexture(button, "Interface\\ICONS\\INV_Misc_EngGizmos_17")
    elseif button.isBank then
        button:SetID(bagID)
        button.slotID = ContainerIDToInventoryID(bagID)
    else    
        button:SetID(GetInventorySlotInfo(string.format("BAG%dSLOT", bagID - 1)))
        button.slotID = ContainerIDToInventoryID(bagID)
    end

    button:RegisterForDrag("LeftButton")
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnDragStart", B.BagSlotButton_OnDragStart)
    button:SetScript("OnReceiveDrag", B.BagSlotButton_OnReceiveDrag)
    button:SetScript("OnClick", B.BagSlotButton_OnClick)
    button:SetScript("OnEnter", B.BagSlotButton_OnEnter)
    button:SetScript("OnLeave", B.BagSlotButton_OnLeave)

    B:UpdateBagSlotButton(button)

    return button
end

function B:BagSlotButton_OnDragStart()
    if self.bagID ~= BACKPACK_CONTAINER and self.bagID ~= BANK_CONTAINER and self.bagID ~= KEYRING_CONTAINER then
        PickupBagFromSlot(self.slotID)
    end
end

function B:BagSlotButton_OnReceiveDrag()
    if CursorHasItem() then
        if self.bagID == BACKPACK_CONTAINER then
            PutItemInBackpack()
        elseif not self.purchaseCost then
            PutItemInBag(self.slotID)
        end
    end
    B:UpdateBagSlotButton(self)
end

function B:BagSlotButton_OnClick()
    if not CursorHasItem() and self.purchaseCost then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
        BankFrame.nextSlotCost = self.purchaseCost
        StaticPopup_Show("CONFIRM_BUY_BANK_SLOT")
    else
        local bag = B:FindBag(self.bagID)
        bag.Hidden = not bag.Hidden
        if not R.isRetail then
            self:SetChecked(not bag.Hidden)
        else
            self.SlotHighlightTexture:SetShown(not bag.Hidden)
        end
    end
    B:UpdateBagSlotButton(self)
    B:UpdateBagFrame(self.frame)
end

function B:BagSlotButton_OnEnter()
    B:UpdateBagSlotButton(self)
    B:HighlightBagButtons(self.frame, self.bagID)

    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    if self.bagID == BACKPACK_CONTAINER then
        GameTooltip:SetText(BACKPACK_TOOLTIP)
    elseif self.bagID == BANK_CONTAINER then
        GameTooltip:SetText(BANK_BAG)
    elseif self.bagID == KEYRING_CONTAINER then
        GameTooltip:SetText(KEYRING)
    else
        local hasItem = GameTooltip:SetInventoryItem("player", self.slotID)
        if not hasItem then
            if self.purchaseCost then
                GameTooltip:ClearLines()
                GameTooltip:AddLine(BANK_BAG_PURCHASE)
                GameTooltip:AddDoubleLine(COSTS_LABEL, GetCoinTextureString(self.purchaseCost))
            elseif self.isBank then
                if self.bagID > GetNumBankSlots() + 4 then
                    GameTooltip:SetText(BANK_BAG_PURCHASE)
                else
                    GameTooltip:SetText(BANK_BAG)
                end
            else
                GameTooltip:SetText(BAGSLOT)
            end
        end
    end
    GameTooltip:Show()
end

function B:BagSlotButton_OnLeave()
    B:UnhighlightBagButtons(self.frame)

    GameTooltip:Hide()
    ResetCursor()
end

function B:UpdateBagSlotButton(button)
    if button.bagID ~= KEYRING_CONTAINER then
        button.freeSlots = GetContainerNumFreeSlots(button.bagID)
        if button.SlotCount and button.freeSlots ~= nil then
            button.SlotCount:SetText(format("(%d)", button.freeSlots))
        end
    end

    if button.bagID == BACKPACK_CONTAINER or button.bagID == BANK_CONTAINER or button.bagID == KEYRING_CONTAINER then
        return
    end

    local numBankSlots, bankFull = GetNumBankSlots()
    local buyBankSlot = numBankSlots + ITEM_INVENTORY_BANK_BAG_OFFSET + 1

    if button.bagID == buyBankSlot then
        button.purchaseCost = GetBankSlotCost()
    else
        button.purchaseCost = nil
    end

    local textureName = GetInventoryItemTexture("player", button.slotID)
    if textureName then
        SetItemButtonTexture(button, textureName)
    elseif button.purchaseCost then
        SetItemButtonTexture(button, "Interface\\GuildBankFrame\\UI-GuildBankFrame-NewTab")
    else
        textureName = select(2, GetInventorySlotInfo("BAG0SLOT"))
        SetItemButtonTexture(button, textureName)
    end

    if button.isBank and button.bagID > buyBankSlot then
        SetItemButtonTextureVertexColor(button, 1, 0, 0)
    else
        SetItemButtonTextureVertexColor(button, 1, 1, 1)
    end
end

function B:UpdateLocked(bagID, slot)
    local bag = B:FindBag(bagID)
    if bag then
        local button = bag.Buttons[slot]
        if button then
            local _, _, locked = GetContainerItemInfo(bagID, slot)
            SetItemButtonDesaturated(button, locked)
        end
    end
end

function B:UpdateItemButton(bag, slot)
    local bagID = bag:GetID()
    local button = bag.Buttons[slot]
    if not button then
        return
    end

    local texture, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemId =
        GetContainerItemInfo(bagID, slot)

    SetItemButtonTexture(button, texture)
    SetItemButtonQuality(button, quality, itemId)
    SetItemButtonCount(button, itemCount)
    SetItemButtonDesaturated(button, locked)

    button.readable = readable
    if texture then
        ContainerFrame_UpdateCooldown(bagID, button);
        button.hasItem = 1;
    else
        _G[button:GetName() .. "Cooldown"]:Hide();
        button.hasItem = nil;
    end

    local questTexture = _G[button:GetName() .. "IconQuestTexture"]
    if questTexture then
        local itemClassID = itemId and select(12, GetItemInfo(itemId)) or nil
        questTexture:SetShown(itemClassID == LE_ITEM_CLASS_QUESTITEM)
    end
    local battlepayItemTexture = button.BattlepayItemTexture
    if battlepayItemTexture then
        battlepayItemTexture:Hide()
    end
    local newItemTexture = button.NewItemTexture
    if newItemTexture then
        newItemTexture:Hide()
    end
    local junkIcon = button.JunkIcon
    if junkIcon then
        junkIcon:SetShown(quality == 0)
    end

    if button == GameTooltip:GetOwner() then
        if button.hasItem then
            button:UpdateTooltip()
        else
            GameTooltip:Hide()
        end
    end

    if R.Modules.ButtonStyles then
        R.Modules.ButtonStyles:StyleItemButton(button)
    end
end

function B:UpdateBagFrame(frame)
    local isBank = frame == B.Bank
    local config = isBank and B.config.bank or B.config.inventory
    local column = 1
    local row = 1
    for _, bag in ipairs(frame.Bags) do
        local bagID = bag:GetID()
        local slots = GetContainerNumSlots(bagID)
        for slot, button in ipairs(bag.Buttons) do
            if slot <= slots and not bag.Hidden then
                if column > config.columns then
                    row = row + 1
                    column = 1
                end

                local x = (column - 1) * config.slotSize + 11
                local y = -1 * (row - 1) * config.slotSize - 67
                button:ClearAllPoints()
                button:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)

                column = column + 1

                B:UpdateItemButton(bag, slot)
                button:Show()
            else
                button:Hide()
            end
        end
    end
    for _, bagSlot in ipairs(frame.BagSlots) do
        B:UpdateBagSlotButton(bagSlot)
    end

    local width = math.max(0, config.columns * config.slotSize + 20)
    local height = math.max(isBank and 500 or 300, config.slotSize * row + 94)
    frame:SetSize(width, height)
end

function B:HighlightBagButtons(frame, highlightID)
    for _, bag in ipairs(frame.Bags) do
        local bagID = bag:GetID()
        local slots = GetContainerNumSlots(bagID)
        for slot, button in ipairs(bag.Buttons) do
            if slot <= slots then
                if bagID == highlightID and not bag.Hidden then
                    button:LockHighlight()
                else
                    button:UnlockHighlight()
                end
            end
        end
    end
end

function B:UnhighlightBagButtons(frame)
    B:HighlightBagButtons(frame, nil)
end

function B:SetItemSearch(frame, query)
    local empty = #(query:gsub(" ", "")) == 0
    local method = R.Libs.ItemSearch.Matches
    if R.Libs.ItemSearch.Filters.tipPhrases.keywords[query] then
        method = R.Libs.ItemSearch.TooltipPhrase
        query = R.Libs.ItemSearch.Filters.tipPhrases.keywords[query]
    end
    
    for _, bag in ipairs(frame.Bags) do
        local bagID = bag:GetID()
        local slots = GetContainerNumSlots(bagID)
        for slot, button in ipairs(bag.Buttons) do
            if slot <= slots then
                local link = select(7, GetContainerItemInfo(bagID, slot))
                local success, result = pcall(method, R.Libs.ItemSearch, link, query)
                if empty or (success and result) then
                    SetItemButtonDesaturated(button, button.locked)
                    button.searchOverlay:Hide()
                    button:SetAlpha(1)
                else
                    SetItemButtonDesaturated(button, 1)
                    button.searchOverlay:Show()
                    button:SetAlpha(0.5)
                end
            end
        end
    end
end