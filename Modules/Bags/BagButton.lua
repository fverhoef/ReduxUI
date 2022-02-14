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
end

function BagButtonMixin:Update()
    local texture, itemCount, locked, quality, readable, _, _, _, _, itemId = GetContainerItemInfo(self.bagID, self.slot)

    SetItemButtonTexture(self, texture)
    SetItemButtonQuality(self, quality, itemId)
    SetItemButtonCount(self, itemCount)
    SetItemButtonDesaturated(self, locked)

    self.readable = readable
    if texture then
        ContainerFrame_UpdateCooldown(self.bagID, self);
        self.hasItem = 1;
    else
        _G[self:GetName() .. "Cooldown"]:Hide();
        self.hasItem = nil;
    end

    if self.IconQuestTexture then
        local itemClassID = itemId and select(12, GetItemInfo(itemId)) or nil
        self.IconQuestTexture:SetShown(itemClassID == LE_ITEM_CLASS_QUESTITEM)
    end
    local battlepayItemTexture = self.BattlepayItemTexture
    if battlepayItemTexture then battlepayItemTexture:Hide() end
    local newItemTexture = self.NewItemTexture
    if newItemTexture then newItemTexture:Hide() end
    local junkIcon = self.JunkIcon
    if junkIcon then junkIcon:SetShown(quality == 0) end

    if self == _G.GameTooltip:GetOwner() then
        if self.hasItem then
            self:UpdateTooltip()
        else
            _G.GameTooltip:Hide()
        end
    end

    R.Modules.ButtonStyles:StyleItemButton(self)
end

function BagButtonMixin:UpdateContainerButtonLockedState(bagID, slot)
    if not self then return end

    SetItemButtonDesaturated(self, select(3, GetContainerItemInfo(bagID, slot)))
end
