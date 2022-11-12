local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

local BANK_CONTAINER = _G.BANK_CONTAINER
local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER
local KEYRING_CONTAINER = _G.KEYRING_CONTAINER or -2
local MAX_CONTAINER_ITEMS = _G.MAX_CONTAINER_ITEMS or 36
local REAGENTBANK_SIZE = 98

function BagFrame_OnLoad(self)
    self.BagIDs = self.BagIDs or {}
    self.Bags = {}
    self.BagsById = {}
    self.BagSlots = {}
    self.BagSlotsById = {}
    for i, bagID in next, self.BagIDs do
        local bag = CreateFrame("Frame", addonName .. "Bag" .. bagID, self, "BagTemplate")
        bag:Initialize(bagID)
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
end

function BagFrame_SearchBox_OnTextChanged(self)
    SearchBoxTemplate_OnTextChanged(self)
    self:GetParent():SetItemSearch(self:GetText())
end

BagFrameMixin = {}

function BagFrameMixin:Update()
    local config = self.isBank and B.config.bank or B.config.inventory
    local column = 1
    local row = 1
    for _, bag in ipairs(self.Bags) do row, column = bag:Layout(config, row, column) end
    for _, bagSlot in ipairs(self.BagSlots) do bagSlot:Update() end

    local width = math.max(0, config.columns * config.slotSize + 20)
    local height = math.max(self.isBank and 500 or 300, config.slotSize * row + 94)
    self:SetSize(width, height)
end

function BagFrameMixin:UpdateCooldowns()
    for _, bag in ipairs(self.Bags) do
        bag:UpdateCooldowns()
    end
end

function BagFrameMixin:HighlightBagButtons(highlightID)
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

function BagFrameMixin:UnhighlightBagButtons()
    self:HighlightBagButtons(nil)
end

function BagFrameMixin:SetItemSearch(query)
    local empty = #(query:gsub(" ", "")) == 0
    local method = R.Libs.ItemSearch.Matches
    if R.Libs.ItemSearch.Filters.tipPhrases.keywords[query] then
        method = R.Libs.ItemSearch.TooltipPhrase
        query = R.Libs.ItemSearch.Filters.tipPhrases.keywords[query]
    end

    for _, bag in ipairs(self.Bags) do
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
