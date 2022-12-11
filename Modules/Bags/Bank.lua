local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags
local L = R.L

local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER
local REAGENTBANK_SIZE = 98

B.BankMixin = {}
ReduxBankMixin = B.BankMixin

function B.BankMixin:OnLoad()
    self.config = B.config.bank
    self.isBank = true
    self.BagIDs = { -1, 5, 6, 7, 8, 9, 10 }
    if R.isRetail then
        table.insert(self.BagIDs, 11)
    end

    B.BagFrameMixin.OnLoad(self)

    self.Title:SetText(BANK)

    if R.isRetail then
        self.BankTab = CreateFrame("Button", "$parentTab1", self, "PanelTabButtonTemplate")
        self.BankTab:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 11, 2)
        _G.Mixin(self.BankTab, B.BankTabMixin)
        self.ReagentsTab = CreateFrame("Button", "$parentTab2", self, "PanelTabButtonTemplate")
        self.ReagentsTab:SetPoint("LEFT", self.BankTab, "RIGHT", -15, 0)
        _G.Mixin(self.BankTab, B.BankTabMixin)

        local bag = CreateFrame("Frame", addonName .. "ReagentBag", self, "BagTemplate")
        bag:Initialize(self, REAGENTBANK_CONTAINER)
        bag.Hidden = true
        self.Bags[#self.Bags] = bag
        self.BagsById[REAGENTBANK_CONTAINER] = bag

        self.Tabs = { self.BankTab, self.ReagentsTab }
        PanelTemplates_SetNumTabs(self, #self.Tabs)
        PanelTemplates_SetTab(self, 1)
    end

    self.portrait = self.portrait or self.PortraitContainer.portrait
    self.portrait:SetTexture(R.media.textures.icons.bank)

    table.insert(_G.UISpecialFrames, self:GetName())
    BankFrame:SetParent(R.HiddenFrame)

    self:SetNormalizedPoint(self.config.point)
    self:CreateMover(L["Bank"], B.defaults.bank.point)
end

function B.BankMixin:OnHide()
    CloseBankFrame()
end

B.BankTabMixin = {}
ReduxBankTabMixin = B.BankTabMixin

function B.BankTabMixin:OnClick()
    local frame = self:GetParent()
    local tabID = self:GetID()
    PanelTemplates_SetTab(frame, tabID)
    for _, bag in ipairs(frame.Bags) do
        bag.Hidden = (tabID == 1 and bag:GetID() == REAGENTBANK_CONTAINER) or (tabID == 2 and bag:GetID() ~= REAGENTBANK_CONTAINER)
    end
    for _, bagSlot in ipairs(frame.BagSlots) do
        bagSlot:SetShown(tabID == 1)
    end
    frame.Title:SetText(tabID == 1 and BANK or REAGENT_BANK)
    frame.DespositButton:SetShown(tabID == 2)
    frame:Update()
end

function B:ShowBank()
    if not B.Bank:IsShown() then
        B.Bank:Update()
        B.Bank:Show()
        BankFrame:Show()
    end
    B:ShowInventory()
end

function B:HideBank()
    if B.Bank:IsShown() then
        B.Bank:Hide()
        BankFrame:Hide()
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
