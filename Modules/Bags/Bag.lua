local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

local GetContainerNumSlots = GetContainerNumSlots or (C_Container and C_Container.GetContainerNumSlots)
local GetContainerItemInfo = GetContainerItemInfo or (C_Container and C_Container.GetContainerItemInfo)

local BANK_CONTAINER = _G.BANK_CONTAINER
local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER
local KEYRING_CONTAINER = _G.KEYRING_CONTAINER or -2
local MAX_CONTAINER_ITEMS = _G.MAX_CONTAINER_ITEMS or 36
local REAGENTBANK_SIZE = 98

local BUTTON_TEMPLATES = {}
BUTTON_TEMPLATES[BANK_CONTAINER] = "BankBagButtonTemplate"
if R.isRetail then
    BUTTON_TEMPLATES[REAGENTBANK_CONTAINER] = "ReagentBankBagButtonTemplate"
end

B.BagMixin = {}
ReduxBagMixin = B.BagMixin

function B.BagMixin:OnLoad()
end

function B.BagMixin:Initialize(frame, bagID)
    self.frame = frame
    self:SetID(bagID)
    self.Buttons = {}
    self.Hidden = bagID == KEYRING_CONTAINER

    local numItems = bagID == REAGENTBANK_CONTAINER and REAGENTBANK_SIZE or MAX_CONTAINER_ITEMS
    for slot = 1, numItems do
        local button = CreateFrame(R.isRetail and "ItemButton" or "CheckButton", addonName .. "Bag" .. bagID .. "Button" .. slot, self, BUTTON_TEMPLATES[bagID] or "InventoryBagButtonTemplate")
        button:Initialize(slot)
        self.Buttons[slot] = button
    end
end

function B.BagMixin:Update()
    for _, button in ipairs(self.Buttons) do
        button:Update()
    end
end

function B.BagMixin:UpdateCooldowns()
    for _, button in ipairs(self.Buttons) do
        button:UpdateCooldown()
    end
end

function B.BagMixin:Layout(config, row, column)
    local parent = self:GetParent()
    local bagID = self:GetID()
    local slots = GetContainerNumSlots(bagID)
    for slot, button in ipairs(self.Buttons) do
        if slot <= slots and not self.Hidden then
            if column > config.columns then
                row = row + 1
                column = 1
            end

            local x = (column - 1) * config.slotSize + 11
            local y = -1 * (row - 1) * config.slotSize - 67
            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)

            column = column + 1

            button:Update()
            button:Show()
        else
            button:Hide()
        end
    end

    return row, column
end
