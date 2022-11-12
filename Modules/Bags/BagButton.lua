local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

BagButtonMixin = {}

function BagButtonMixin:Initialize(bagID, slot)
    self:SetID(slot)
    self.bagID = bagID
    self.slot = slot

    self.IconQuestTexture = self.IconQuestTexture or _G[self:GetName() .. "IconQuestTexture"]
    if self.IconQuestTexture then
        self.IconQuestTexture:SetTexture("Interface\\ContainerFrame\\UI-Icon-QuestBang")
    end

    self.Cooldown = self.Cooldown or _G[self:GetName() .. "Cooldown"]
end

function BagButtonMixin:Update()
    local texture, itemCount, locked, quality, readable, _, _, _, _, itemId = GetContainerItemInfo(self.bagID, self.slot)
    self.readable = readable

    SetItemButtonTexture(self, texture)
    SetItemButtonQuality(self, quality, itemId)
    SetItemButtonCount(self, itemCount)
    SetItemButtonDesaturated(self, locked)

    self.Quality = quality
    self.ItemIDOrLink = itemId

    if texture then
        self.hasItem = 1
    else
        self.hasItem = nil
    end

    if self.IconQuestTexture then
        local itemClassID = itemId and select(12, GetItemInfo(itemId)) or nil
        self.IconQuestTexture:SetShown(itemClassID == LE_ITEM_CLASS_QUESTITEM)
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

    R.Modules.ButtonStyles:StyleItemButton(self)
end

function BagButtonMixin:UpdateCooldown()
    if self.hasItem then
        local start, duration, enable = GetContainerItemCooldown(self.bagID, self.slot)
        CooldownFrame_Set(self.Cooldown, start, duration, enable)

        if (duration > 0 and enable == 0) then
            SetItemButtonTextureVertexColor(self, 0.4, 0.4, 0.4)
        else
            SetItemButtonTextureVertexColor(self, 1, 1, 1)
        end
    else
        self.Cooldown:Hide();
    end
end

function BagButtonMixin:UpdateContainerButtonLockedState(bagID, slot)
    if not self then
        return
    end

    SetItemButtonDesaturated(self, select(3, GetContainerItemInfo(bagID, slot)))
end
