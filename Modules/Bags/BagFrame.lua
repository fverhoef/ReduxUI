local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

local SetItemSearch = SetItemSearch or (C_Container and C_Container.SetItemSearch)
local GetContainerItemInfo = GetContainerItemInfo or (C_Container and C_Container.GetContainerItemInfo)
local GetContainerNumSlots = GetContainerNumSlots or (C_Container and C_Container.GetContainerNumSlots)

local BANK_CONTAINER = _G.BANK_CONTAINER
local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER
local KEYRING_CONTAINER = _G.KEYRING_CONTAINER or -2
local MAX_CONTAINER_ITEMS = _G.MAX_CONTAINER_ITEMS or 36
local REAGENTBANK_SIZE = 98

B.BagFrameMixin = {}
ReduxBagFrameMixin = B.BagFrameMixin

function B.BagFrameMixin:OnLoad()
    self.BagIDs = self.BagIDs or {}
    self.Bags = {}
    self.BagsById = {}
    self.BagSlots = {}
    self.BagSlotsById = {}
    for i, bagID in next, self.BagIDs do
        local bag = CreateFrame("Frame", addonName .. "Bag" .. bagID, self, "BagTemplate")
        bag:Initialize(self, bagID)
        self.Bags[i] = bag
        self.BagsById[bagID] = bag

        local bagSlot = CreateFrame(R.isRetail and "ItemButton" or "Button", addonName .. "BagSlot" .. bagID, self, (R.isRetail and "" or "ItemButtonTemplate,") .. "BagSlotTemplate")
        bagSlot:Initialize(self, bagID)
        bagSlot:Update()
        if i == 1 then
            bagSlot:SetPoint("TOPRIGHT", self, "TOPLEFT", 0, -50)
        else
            bagSlot:SetPoint("TOP", self.BagSlots[i - 1], "BOTTOM", 0, -12)
        end
        bagSlot.SlotHighlightTexture:SetShown(bagID ~= KEYRING_CONTAINER)
        self.BagSlots[i] = bagSlot
        self.BagSlotsById[bagID] = bagSlot
    end

    self.SearchBox:SetScript("OnTextChanged", self.SearchBox_OnTextChanged)
end

function B.BagFrameMixin:SearchBox_OnTextChanged()
    SearchBoxTemplate_OnTextChanged(self)
    SetItemSearch(self:GetText())
end

function B.BagFrameMixin:Update()
    local config = self.isBank and B.config.bank or B.config.inventory
    local column = 1
    local row = 1
    for _, bag in ipairs(self.Bags) do
        row, column = bag:Layout(config, row, column)
    end
    for _, bagSlot in ipairs(self.BagSlots) do
        bagSlot:Update()
    end

    local width = math.max(0, config.columns * config.slotSize + 20)
    local height = math.max(self.isBank and 500 or 300, config.slotSize * row + 94)
    self:SetSize(width, height)
    SetItemSearch(self.SearchBox:GetText())
end

function B.BagFrameMixin:UpdateCooldowns()
    for _, bag in ipairs(self.Bags) do
        bag:UpdateCooldowns()
    end
end

function B.BagFrameMixin:HighlightBagButtons(highlightID)
    for _, bag in ipairs(self.Bags) do
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

function B.BagFrameMixin:UnhighlightBagButtons()
    self:HighlightBagButtons(nil)
end
