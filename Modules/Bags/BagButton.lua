local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

local GetContainerItemInfo = GetContainerItemInfo or (C_Container and C_Container.GetContainerItemInfo)
local GetContainerItemCooldown = GetContainerItemCooldown or (C_Container and C_Container.GetContainerItemCooldown)
local GetContainerItemQuestInfo = GetContainerItemQuestInfo or (C_Container and C_Container.GetContainerItemQuestInfo)

B.BagButtonMixin = {}
ReduxBagButtonMixin = B.BagButtonMixin

function B.BagButtonMixin:Initialize(id)
    self:SetID(id)

    self.IconQuestTexture = self.IconQuestTexture or _G[self:GetName() .. "IconQuestTexture"]
    if self.IconQuestTexture then
        self.IconQuestTexture:SetTexture("Interface\\ContainerFrame\\UI-Icon-QuestBang")
    end

    self.cooldown = self.cooldown or self.Cooldown or _G[self:GetName() .. "Cooldown"]
    self.icon = self.icon or _G[self:GetName() .. "Icon"] or _G[self:GetName() .. "IconTexture"]
    self.Count = self.Count or _G[self:GetName() .. "Count"]
    self.Stock = self.Stock or _G[self:GetName() .. "Stock"]

    self:ApplyStyle()
    self:SetScript("OnEvent", B.BagButtonMixin.OnEvent)
end

function B.BagButtonMixin:OnEvent(event)
    if event == "INVENTORY_SEARCH_UPDATE" then
        self:UpdateSearchOverlay()
    end
end

function B.BagButtonMixin:Update()
    local texture, itemCount, locked, quality, readable, itemId

    local info = GetContainerItemInfo(self:GetParent():GetID(), self:GetID())
    if info then
        texture, itemCount, locked, quality, readable, itemId = info.iconFileID, info.stackCount, info.isLocked, info.quality, info.IsReadable, info.itemID
    end

    self.readable = readable

    SetItemButtonTexture(self, texture)
    SetItemButtonQuality(self, quality, itemId)
    SetItemButtonCount(self, itemCount)
    SetItemButtonDesaturated(self, locked)

    self.Quality = quality
    self.ItemIDOrLink = itemId

    if texture then
        self.hasItem = 1
        self:RegisterEvent("INVENTORY_SEARCH_UPDATE")
    else
        self.hasItem = nil
        self:UnregisterEvent("INVENTORY_SEARCH_UPDATE")
    end

    if self.IconQuestTexture then
        local questInfo = GetContainerItemQuestInfo(self:GetParent():GetID(), self:GetID())
        self.IconQuestTexture:SetShown(questInfo.isQuestItem)
    end
    local battlepayItemTexture = self.BattlepayItemTexture
    if battlepayItemTexture then
        battlepayItemTexture:Hide()
    end
    local newItemTexture = self.NewItemTexture
    if newItemTexture then
        newItemTexture:Hide()
    end
    local junkIcon = self.JunkIcon
    if junkIcon then
        junkIcon:SetShown(quality == 0)
    end

    if self == _G.GameTooltip:GetOwner() then
        if self.hasItem then
            self:UpdateTooltip()
        else
            _G.GameTooltip:Hide()
        end
    end

    self:UpdateCooldown()
    self:UpdateSearchOverlay()
    self:ApplyStyle()
end

function B.BagButtonMixin:ApplyStyle()
    if not self.__styled then
        self.__styled = true

        self.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        self.icon:SetInside(self, 2, 2)

        self.raisedContainer = CreateFrame("Frame", nil, self)
        self.raisedContainer:SetAllPoints()
        self.raisedContainer:SetFrameLevel(self:GetFrameLevel() + 1)

        self.cooldown:SetInside(self, 2, 2)
        self.cooldown:SetSwipeColor(0, 0, 0)

        self.Count:SetParent(self.raisedContainer)
        self.Stock:SetParent(self.raisedContainer)

        self:SetNormalTexture(R.media.textures.buttons.border)
        local normalTexture = self:GetNormalTexture()
        normalTexture:SetOutside(self, 4, 4)
        normalTexture:SetTexCoord(0, 1, 0, 1)

        self:SetPushedTexture(R.media.textures.buttons.border)
        local pushedTexture = self:GetPushedTexture()
        pushedTexture:SetOutside(self, 4, 4)
    end

    local config = self:GetParent().frame.config
    if config then
        self.Count:SetFont(config.buttonStyle.font, config.buttonStyle.fontSize, config.buttonStyle.fontOutline)
        self.Count:SetShadowOffset(config.buttonStyle.fontShadow and 1 or 0, config.buttonStyle.fontShadow and -1 or 0)
        self.Stock:SetFont(config.buttonStyle.font, config.buttonStyle.fontSize, config.buttonStyle.fontOutline)
        self.Stock:SetShadowOffset(config.buttonStyle.fontShadow and 1 or 0, config.buttonStyle.fontShadow and -1 or 0)
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

function B.BagButtonMixin:UpdateCooldown()
    if self.hasItem then
        local start, duration, enable = GetContainerItemCooldown(self:GetParent():GetID(), self:GetID())
        CooldownFrame_Set(self.cooldown, start, duration, enable)

        if (duration > 0 and enable == 0) then
            SetItemButtonTextureVertexColor(self, 0.4, 0.4, 0.4)
        else
            SetItemButtonTextureVertexColor(self, 1, 1, 1)
        end
    else
        self.cooldown:Hide();
    end
end

function B.BagButtonMixin:UpdateContainerButtonLockedState(bagID, slot)
    if not self then
        return
    end

    SetItemButtonDesaturated(self, select(3, GetContainerItemInfo(bagID, slot)))
end

function B.BagButtonMixin:UpdateSearchOverlay()
    local itemInfo = GetContainerItemInfo(self:GetParent():GetID(), self:GetID())
    if itemInfo and itemInfo.isFiltered then
        SetItemButtonDesaturated(self, 1)
        self.searchOverlay:Show()
        self:SetAlpha(0.5)
    else
        SetItemButtonDesaturated(self, self.locked)
        self.searchOverlay:Hide()
        self:SetAlpha(1)
    end
end
