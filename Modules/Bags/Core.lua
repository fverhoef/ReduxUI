local addonName, ns = ...
local R = _G.ReduxUI
local B = R:AddModule("Bags", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local CS = R.Modules.CharacterStats

local BACKPACK_CONTAINER = 0
local BANK_CONTAINER = -1
local KEYRING_CONTAINER = -2

function B:Initialize()
    if not B.config.enabled then
        return
    end

    B:DisableBlizzardFrames()
    B.Inventory = B:CreateInventoryFrame()
    B.Bank = B:CreateBankFrame()

    B:RegisterEvent("BAG_SLOT_FLAGS_UPDATED")
    B:RegisterEvent("BAG_UPDATE")
    B:RegisterEvent("BAG_UPDATE_COOLDOWN")
    B:RegisterEvent("BAG_NEW_ITEMS_UPDATED")
    B:RegisterEvent("QUEST_ACCEPTED")
    B:RegisterEvent("QUEST_REMOVED")
    B:RegisterEvent("ITEM_LOCK_CHANGED")
    B:RegisterEvent("BANKFRAME_OPENED")
    B:RegisterEvent("BANKFRAME_CLOSED")
    B:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED")
    B:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
    B:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
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

function B:DisableBlizzardFrames()
    for i = 1, NUM_CONTAINER_FRAMES do
        local frame = _G["ContainerFrame" .. i]
        frame:SetParent(R.HiddenFrame)
    end
    BankFrame:SetParent(R.HiddenFrame)
end

function B:FindBag(bagID)
    for i, id in next, B.Inventory.BagIDs do
        if id == bagID then
            return B.Inventory.Bags[i]
        end
    end
    for i, id in next, B.Bank.BagIDs do
        if id == bagID then
            return B.Bank.Bags[i]
        end
    end
end

function B:CreateContainerFrame(bagID, parent)
    local bag = CreateFrame("Frame", addonName .. "InventoryContainerFrame" .. bagID, parent)
    bag:SetID(bagID)
    bag.Buttons = {}
    bag.Hidden = bagID == KEYRING_CONTAINER
    for slot = 1, MAX_CONTAINER_ITEMS do
        bag.Buttons[slot] = B:CreateContainerButton(bagID, slot, bag)
    end

    return bag
end

function B:CreateContainerButton(bagID, slot, parent)
    local button = CreateFrame("Button", addonName .. "Container" .. bagID .. "Button" .. slot, parent,
                               bagID == -1 and "BankItemButtonGenericTemplate" or "ContainerFrameItemButtonTemplate")
    button:SetSize(37, 37)
    button:SetID(slot)

    return button
end

function B:CreateBagSlotButton(bagID, parent)
    local button = CreateFrame("CheckButton", parent:GetName() .. "_BagSlot" .. bagID, parent, "ItemButtonTemplate")
    button:SetSize(37, 37)
    button:SetID(bagID)
    button:SetScale(0.7)
    button.bagID = bagID
    button.isBank = bagID == BANK_CONTAINER or bagID > 4
    button:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
    button:SetChecked(bagID ~= KEYRING_CONTAINER)

    button.SlotCount = button:CreateFontString(nil, "OVERLAY")
    button.SlotCount:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 4)
    button.SlotCount:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

    if bagID == BACKPACK_CONTAINER then
        SetItemButtonTexture(button, "Interface\\Buttons\\Button-Backpack-Up")
    elseif bagID == BANK_CONTAINER then
        SetItemButtonTexture(button, "Interface\\ICONS\\INV_Misc_EngGizmos_17")
    elseif bagID == KEYRING_CONTAINER then
        SetItemButtonTexture(button, "Interface\\ContainerFrame\\KeyRing-Bag-Icon")
    else
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
        self:SetChecked(not bag.Hidden)
    end
    B:UpdateBagSlotButton(self)
    B:UpdateItemButtons(self:GetParent())
end

function B:BagSlotButton_OnEnter()
    B:UpdateBagSlotButton(self)
    B:HighlightBagButtons(self:GetParent(), self.bagID)

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
    B:UnhighlightBagButtons(self:GetParent())

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
        textureName = select(2, GetInventorySlotInfo("Bag0Slot"))
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

function B:UpdateItemButtons(frame)
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

    frame:SetSize(config.columns * config.slotSize + 20, config.slotSize * row + 94)
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

function B:UnhighlightBagButtons(frame)
    B:HighlightBagButtons(frame, nil)
end

function B:CreateInventoryFrame()
    local frame = CreateFrame("Frame", addonName .. "Inventory", UIParent, "ButtonFrameTemplate")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetFrameStrata("MEDIUM")
    frame:SetSize(356, 88)
    frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -100, 100)
    frame:Hide()

    frame.Title = frame:CreateFontString(nil, "OVERLAY")
    frame.Title:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    frame.Title:SetPoint("TOP", frame, "TOP", 10, -5)
    frame.Title:SetJustifyH("MIDDLE")
    frame.Title:SetText(CS.name .. "'s Inventory") -- TODO: localization

    frame.BagIDs = {0, 1, 2, 3, 4, -2}
    frame.Bags = {}
    frame.BagSlots = {}
    for i, bagID in next, frame.BagIDs do
        frame.Bags[i] = B:CreateContainerFrame(bagID, frame)
        frame.BagSlots[i] = B:CreateBagSlotButton(bagID, frame)
        if i == 1 then
            frame.BagSlots[i]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -16, -42)
        else
            frame.BagSlots[i]:SetPoint("RIGHT", frame.BagSlots[i - 1], "LEFT", 0, 0)
        end
    end

    frame.Money = CreateFrame("Frame", "$parentCurrency", frame, "MoneyFrameTemplate")
    frame.Money:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 5)
    frame.Money:SetScale(0.8)
    _G[frame.Money:GetName() .. "CopperButton"].Text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
    _G[frame.Money:GetName() .. "SilverButton"].Text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
    _G[frame.Money:GetName() .. "GoldButton"].Text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")

    frame.Money:SetScript("OnEnter", B.InventoryMoney_OnEnter)

    frame.SearchBox = CreateFrame("EditBox", "$parentSearchBox", frame, "SearchBoxTemplate")
    frame.SearchBox:SetPoint("LEFT", frame, "TOPLEFT", 70, -42)
    -- frame.SearchBox:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 5)
    frame.SearchBox:SetSize(178, 18)
    frame.SearchBox:SetScript("OnTextChanged", B.InventorySearch_OnTextChanged)

    SetPortraitToTexture(frame.portrait, "Interface\\ICONS\\INV_Misc_Bag_08")

    -- register as a special frame so we can close with ESC key
    tinsert(UISpecialFrames, frame:GetName())

    -- hook open/close functions
    B:SecureHook("OpenAllBags", B.ShowInventory)
    B:SecureHook("CloseAllBags", B.HideInventory)
    B:SecureHook("ToggleBag", "ToggleBag")
    B:SecureHook("ToggleAllBags", B.ToggleBackpack)
    B:SecureHook("ToggleBackpack", B.ToggleBackpack)

    frame:SetScript("OnHide", B.Inventory_OnHide)

    R:CreateDragFrame(frame, "Inventory", {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -100, 100})

    return frame
end

function B:Inventory_OnHide()
    CloseBackpack()
    for i = 1, NUM_BAG_FRAMES do
        CloseBag(i)
    end
    B:UpdateChecked()
end

function B:InventoryMoney_OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
    GameTooltip:AddLine("Money")
    local total = 0
    for i, char in next, R.config.db.realm.inventory do
        if char.money then
            total = total + char.money

            GameTooltip:AddDoubleLine(R:Hex(RAID_CLASS_COLORS[char.class or "MAGE"]) .. i .. "|r:",
                                      R:FormatMoney(char.money, "FULL", false), 1, 1, 1, 1, 1, 1)
        end
    end
    GameTooltip:AddDoubleLine("Total:", R:FormatMoney(total, "FULL", false), 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
end

function B:UpdateInventory()
    B:UpdateItemButtons(B.Inventory)
    if B.Bank:IsShown() then
        B:UpdateBank()
    end
end

function B:UpdateChecked()
    if B.Inventory:IsShown() then
        B:CheckBagButtons(true)
    else
        B:CheckBagButtons(false)
    end
end

function B:CheckBagButtons(state)
    MainMenuBarBackpackButton:SetChecked(state)
    CharacterBag0Slot:SetChecked(state)
    CharacterBag1Slot:SetChecked(state)
    CharacterBag2Slot:SetChecked(state)
    CharacterBag3Slot:SetChecked(state)
    if KeyRingButton then
        KeyRingButton:SetChecked(state)
    end
end

function B:ShowInventory()
    if not B.Inventory:IsShown() then
        B:UpdateInventory()
        B.Inventory:Show()
        PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)

        C_Timer.After(0.05, B.UpdateChecked)
    end
end

function B:HideInventory()
    if B.Inventory:IsShown() then
        B.Inventory:Hide()
        PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)

        C_Timer.After(0.05, B.UpdateChecked)

        B:HideBank()
    end
end

function B:ToggleInventory()
    if B.Inventory:IsShown() then
        B:HideInventory()
    else
        B:ShowInventory()
    end
end

function B:ToggleBackpack()
    if IsOptionFrameOpen() then
        return
    end

    if IsBagOpen(0) then
        B:ShowInventory()
    else
        B:HideInventory()
    end
end

function B:ToggleBag(id)
    if (id and (GetContainerNumSlots(id) == 0)) or id == 0 then
        return
    end

    B:ToggleInventory()
end

function B:InventorySearch_OnTextChanged(userChanged)
    SearchBoxTemplate_OnTextChanged(self)
    B:SetItemSearch(B.Inventory, self:GetText())
end

function B:CreateBankFrame()
    local frame = CreateFrame("Frame", addonName .. "Bank", UIParent, "ButtonFrameTemplate")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetFrameStrata("MEDIUM")
    frame:SetSize(356, 88)
    frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 100, 100)
    frame:Hide()

    frame.Title = frame:CreateFontString(nil, "OVERLAY")
    frame.Title:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    frame.Title:SetPoint("TOP", frame, "TOP", 10, -5)
    frame.Title:SetJustifyH("MIDDLE")
    frame.Title:SetText(CS.name .. "'s Bank") -- TODO: localization

    frame.BagIDs = {-1, 5, 6, 7, 8, 9, 10}
    frame.Bags = {}
    frame.BagSlots = {}
    for i, bagID in next, frame.BagIDs do
        frame.Bags[i] = B:CreateContainerFrame(bagID, frame)
        frame.BagSlots[i] = B:CreateBagSlotButton(bagID, frame)
        if i == 1 then
            frame.BagSlots[i]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -16, -42)
        else
            frame.BagSlots[i]:SetPoint("RIGHT", frame.BagSlots[i - 1], "LEFT", 0, 0)
        end
    end

    frame.SearchBox = CreateFrame("EditBox", "$parentSearchBox", frame, "SearchBoxTemplate")
    frame.SearchBox:SetPoint("LEFT", frame, "TOPLEFT", 70, -42)
    -- frame.SearchBox:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 5)
    frame.SearchBox:SetSize(158, 18)
    frame.SearchBox:SetScript("OnTextChanged", B.BankSearch_OnTextChanged)

    SetPortraitToTexture(frame.portrait, "Interface\\ICONS\\INV_Misc_EngGizmos_17")
    frame.Inset.Bg:SetTexture("Interface\\FrameGeneral\\UI-Background-Rock")

    -- register as a special frame so we can close with ESC key
    tinsert(UISpecialFrames, frame:GetName())

    frame:SetScript("OnHide", function()
        CloseBankFrame()
    end)

    R:CreateDragFrame(frame, "Bank", {"BOTTOMLEFT", UIParent, "BOTTOMLEFT", 100, 100})

    return frame
end

function B:UpdateBank()
    B:UpdateItemButtons(B.Bank)
end

function B:ShowBank()
    if not B.Bank:IsShown() then
        B:UpdateBank()
        B.Bank:Show()
        _G.BankFrame:Show()
    end
    B:ShowInventory()
end

function B:HideBank()
    if B.Bank:IsShown() then
        B.Bank:Hide()
        _G.BankFrame:Hide()
    end
    B:HideInventory()
end

function B:ToggleBank()
    if B.Bank:IsShown() then
        B:ShowBank()
    else
        B:HideBank()
    end
end

function B:BankSearch_OnTextChanged(userChanged)
    SearchBoxTemplate_OnTextChanged(self)
    B:SetItemSearch(B.Bank, self:GetText())
end

