local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

local BACKPACK_CONTAINER = _G.BACKPACK_CONTAINER
local BANK_CONTAINER = _G.BANK_CONTAINER
local KEYRING_CONTAINER = _G.KEYRING_CONTAINER or -2

function BagSlot_OnLoad(self)
    self:RegisterForDrag("LeftButton")
    self:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    if not R.isRetail then
    end
end

function BagSlot_OnDragStart(self)
    if self.bagID ~= BACKPACK_CONTAINER and self.bagID ~= BANK_CONTAINER and self.bagID ~= KEYRING_CONTAINER then
        PickupBagFromSlot(self.slotID)
    end
end

function BagSlot_OnReceiveDrag(self)
    if CursorHasItem() then
        if self.bagID == BACKPACK_CONTAINER then
            PutItemInBackpack()
        elseif not self.purchaseCost then
            PutItemInBag(self.slotID)
        end
    end
    self:Update()
end

function BagSlot_OnClick(self)
    if not CursorHasItem() and self.purchaseCost then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
        BankFrame.nextSlotCost = self.purchaseCost
        StaticPopup_Show("CONFIRM_BUY_BANK_SLOT")
    else
        local bag = B:FindBag(self.bagID)
        bag.Hidden = not bag.Hidden
        self.SlotHighlightTexture:SetShown(not bag.Hidden)
    end
    self:Update()
    self.frame:Update()
end

function BagSlot_OnEnter(self)
    self:Update()
    self.frame:HighlightBagButtons(self.bagID)

    _G.GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    if self.bagID == BACKPACK_CONTAINER then
        _G.GameTooltip:SetText(BACKPACK_TOOLTIP)
    elseif self.bagID == BANK_CONTAINER then
        _G.GameTooltip:SetText(BANK_BAG)
    elseif self.bagID == KEYRING_CONTAINER then
        _G.GameTooltip:SetText(KEYRING)
    else
        local hasItem = _G.GameTooltip:SetInventoryItem("player", self.slotID)
        if not hasItem then
            if self.purchaseCost then
                _G.GameTooltip:ClearLines()
                _G.GameTooltip:AddLine(BANK_BAG_PURCHASE)
                _G.GameTooltip:AddDoubleLine(COSTS_LABEL, GetCoinTextureString(self.purchaseCost))
            elseif self.isBank then
                if self.bagID > GetNumBankSlots() + 4 then
                    _G.GameTooltip:SetText(BANK_BAG_PURCHASE)
                else
                    _G.GameTooltip:SetText(BANK_BAG)
                end
            else
                _G.GameTooltip:SetText(BAGSLOT)
            end
        end
    end
    _G.GameTooltip:Show()
end

function BagSlot_OnLeave(self)
    self.frame:UnhighlightBagButtons()

    _G.GameTooltip:Hide()
    ResetCursor()
end

BagSlotMixin = {}

function BagSlotMixin:Initialize(frame, bagID)
    self.frame = frame
    self.bagID = bagID
    self.isBank = bagID == BANK_CONTAINER or bagID > 4

    if bagID == BACKPACK_CONTAINER then
        self:SetSize(36, 36)
        self.Background:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, 12)
        self.Background:SetSize(72, 72)

        SetItemButtonTexture(self, "Interface\\Buttons\\Button-Backpack-Up")
    elseif bagID == KEYRING_CONTAINER then
        SetItemButtonTexture(self, "Interface\\ContainerFrame\\KeyRing-Bag-Icon")
    elseif bagID == BANK_CONTAINER then
        self:SetSize(36, 36)
        self.Background:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, 12)
        self.Background:SetSize(72, 72)

        SetItemButtonTexture(self, "Interface\\ICONS\\INV_Misc_EngGizmos_17")
    elseif self.isBank then
        self:SetID(bagID)
        self.slotID = ContainerIDToInventoryID(bagID)
    else    
        self:SetID(GetInventorySlotInfo(string.format("BAG%dSLOT", bagID - 1)))
        self.slotID = ContainerIDToInventoryID(bagID)
    end
end

function BagSlotMixin:Update()
    if self.bagID ~= KEYRING_CONTAINER then
        self.freeSlots = GetContainerNumFreeSlots(self.bagID)
        if self.SlotCount and self.freeSlots ~= nil then
            self.SlotCount:SetText(format("(%d)", self.freeSlots))
        end
    end

    if self.bagID == BACKPACK_CONTAINER or self.bagID == BANK_CONTAINER or self.bagID == KEYRING_CONTAINER then
        return
    end

    local numBankSlots, bankFull = GetNumBankSlots()
    local buyBankSlot = numBankSlots + ITEM_INVENTORY_BANK_BAG_OFFSET + 1

    if self.bagID == buyBankSlot then
        self.purchaseCost = GetBankSlotCost()
    else
        self.purchaseCost = nil
    end

    local textureName = GetInventoryItemTexture("player", self.slotID)
    if textureName then
        SetItemButtonTexture(self, textureName)
    elseif self.purchaseCost then
        SetItemButtonTexture(self, "Interface\\GuildBankFrame\\UI-GuildBankFrame-NewTab")
    else
        textureName = select(2, GetInventorySlotInfo("BAG0SLOT"))
        SetItemButtonTexture(self, textureName)
    end

    if self.isBank and self.bagID > buyBankSlot then
        SetItemButtonTextureVertexColor(self, 1, 0, 0)
    else
        SetItemButtonTextureVertexColor(self, 1, 1, 1)
    end
end