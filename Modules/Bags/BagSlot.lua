local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

local GetContainerNumFreeSlots = GetContainerNumFreeSlots or C_Container.GetContainerNumFreeSlots
local ContainerIDToInventoryID = ContainerIDToInventoryID or C_Container.ContainerIDToInventoryID

local BACKPACK_CONTAINER = _G.BACKPACK_CONTAINER
local BANK_CONTAINER = _G.BANK_CONTAINER
local KEYRING_CONTAINER = _G.KEYRING_CONTAINER or -2

B.BagSlotMixin = {}
ReduxBagSlotMixin = B.BagSlotMixin

function B.BagSlotMixin:OnLoad()
    self:RegisterForDrag("LeftButton")
    self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
end

function B.BagSlotMixin:OnDragStart()
    if self.bagID ~= BACKPACK_CONTAINER and self.bagID ~= BANK_CONTAINER and self.bagID ~= KEYRING_CONTAINER then
        PickupBagFromSlot(self.slotID)
    end
end

function B.BagSlotMixin:OnReceiveDrag()
    if CursorHasItem() then
        if self.bagID == BACKPACK_CONTAINER then
            PutItemInBackpack()
        elseif not self.purchaseCost then
            PutItemInBag(self.slotID)
        end
    end
    self:Update()
end

function B.BagSlotMixin:OnClick()
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

function B.BagSlotMixin:OnEnter()
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

function B.BagSlotMixin:OnLeave()
    self.frame:UnhighlightBagButtons()

    _G.GameTooltip:Hide()
    ResetCursor()
end

function B.BagSlotMixin:Initialize(frame, bagID)
    self.frame = frame
    self.bagID = bagID
    self.isBank = bagID == BANK_CONTAINER or bagID > 4

    if bagID == BACKPACK_CONTAINER then
        self:SetSize(36, 36)
        self.Background:SetPoint("TOPRIGHT", self, "TOPRIGHT", 3, 11)
        self.Background:SetSize(72, 70)

        SetItemButtonTexture(self, "Interface\\Buttons\\Button-Backpack-Up")
    elseif bagID == KEYRING_CONTAINER then
        SetItemButtonTexture(self, "Interface\\ContainerFrame\\KeyRing-Bag-Icon")
    elseif bagID == BANK_CONTAINER then
        self:SetSize(36, 36)
        self.Background:SetPoint("TOPRIGHT", self, "TOPRIGHT", 3, 11)
        self.Background:SetSize(72, 70)

        SetItemButtonTexture(self, "Interface\\ICONS\\INV_Misc_EngGizmos_17")
    elseif self.isBank then
        self:SetID(bagID)
        self.slotID = ContainerIDToInventoryID(bagID)
    else
        self:SetID(GetInventorySlotInfo(string.format("BAG%dSLOT", bagID - 1)))
        self.slotID = ContainerIDToInventoryID(bagID)
    end

    self.icon = self.icon or _G[self:GetName() .. "Icon"] or _G[self:GetName() .. "IconTexture"]
    self.SlotCount = self.SlotCount or _G[self:GetName() .. "SlotCount"]
    
    self:ApplyStyle()
end

function B.BagSlotMixin:Update()
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

    self:ApplyStyle()
end

function B.BagSlotMixin:ApplyStyle()
    if not self.__styled then
        self.__styled = true

        self.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        self.icon:SetInside(self, 2, 2)

        self:SetNormalTexture(R.media.textures.buttons.border)
        local normalTexture = self:GetNormalTexture()
        normalTexture:SetOutside(self, 4, 4)
        normalTexture:SetTexCoord(0, 1, 0, 1)

        self:SetPushedTexture(R.media.textures.buttons.border)
        local pushedTexture = self:GetPushedTexture()
        pushedTexture:SetOutside(self, 4, 4)
    end

    local config = self.frame.config
    if config then
        self.SlotCount:SetFont(config.slotStyle.font, config.slotStyle.fontSize, config.slotStyle.fontOutline)
        self.SlotCount:SetShadowOffset(config.slotStyle.fontShadow and 1 or 0, config.slotStyle.fontShadow and -1 or 0)
    end

    local r, g, b = 0.7, 0.7, 0.7
    if self.ItemIDOrLink then
        local itemRarity = select(3, GetItemInfo(self.ItemIDOrLink))
        if itemRarity and itemRarity > 1 then
            r, g, b = GetItemQualityColor(itemRarity)
        end
    end

    self:GetNormalTexture():SetVertexColor(r, g, b, 1)
end
