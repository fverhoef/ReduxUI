local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER
local REAGENTBANK_SIZE = 98

function ReduxUI_BankFrame_OnLoad(self)
    self.isBank = true
    self.BagIDs = {-1, 5, 6, 7, 8, 9, 10}
    if R.isRetail then
        table.insert(self.BagIDs, 11)
    end

    BagFrame_OnLoad(self)

    self.Title:SetText(BANK)
    
    if R.isRetail then
        local bag = CreateFrame("Frame", addonName .. "ReagentBag", self, "BagTemplate")
        bag:Initialize(REAGENTBANK_CONTAINER)
        bag.Hidden = true
        self.Bags[#self.Bags] = bag
        self.BagsById[REAGENTBANK_CONTAINER] = bag

        self.Tabs = { self.BankTab, self.ReagentsTab }
        PanelTemplates_SetNumTabs(self, #self.Tabs)
        PanelTemplates_SetTab(self, 1)
    else
        self.BankTab:Hide()
        self.ReagentsTab:Hide()
    end

    SetPortraitToTexture(self.portrait, "Interface\\ICONS\\INV_Misc_EngGizmos_17")
    self.Inset.Bg:SetTexture("Interface\\FrameGeneral\\UI-Background-Rock")

    table.insert(_G.UISpecialFrames, self:GetName())

    R:CreateDragFrame(self, "Bank", {"BOTTOMLEFT", UIParent, "BOTTOMLEFT", 100, 100})
end

function ReduxUI_BankFrame_OnHide(self)
    CloseBankFrame()
end

function ReduxUI_BankFrame_TabOnClick(tab)
    local frame = tab:GetParent()
    local tabID = tab:GetID()
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

BankMixin = {}

function B:ShowBank()
    if not B.Bank:IsShown() then
        B.Bank:Update()
        B.Bank:Show()
        BankFrame:Show()
        ReduxUI_BankFrame:Show()
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