local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

local REAGENTBANK_SIZE = 98

function B:CreateBankFrame()
    local frame = CreateFrame("Frame", addonName .. "Bank", UIParent, "ButtonFrameTemplate")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetFrameStrata("MEDIUM")
    frame:SetSize(356, 88)
    frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 100, 100)
    frame:Hide()

    frame.Title = frame:CreateFontString(nil, "OVERLAY")
    frame.Title:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    frame.Title:SetPoint("TOP", frame, "TOP", 10, -5)
    frame.Title:SetJustifyH("MIDDLE")
    frame.Title:SetText(BANK)

    frame.BagIDs = {-1, 5, 6, 7, 8, 9, 10}
    if R.isRetail then
        table.insert(frame.BagIDs, 11)
    end
    frame.Bags = {}
    frame.BagsById = {}
    frame.BagSlots = {}
    for i, bagID in next, frame.BagIDs do
        frame.Bags[i] = B:CreateContainerFrame(bagID, frame)
        frame.BagsById[bagID] = frame.Bags[i]
        frame.BagSlots[i] = B:CreateBagSlotButton(bagID, frame, frame)
        if i == 1 then
            frame.BagSlots[i]:SetPoint("TOPRIGHT", frame, "TOPLEFT", 0, -50)
        else
            frame.BagSlots[i]:SetPoint("TOP", frame.BagSlots[i - 1], "BOTTOM", 0, -12)
        end
    end

    frame.Bags[#frame.Bags + 1] = B:CreateContainerFrame(REAGENTBANK_CONTAINER, frame)
    frame.Bags[#frame.Bags].Hidden = true

    frame.SearchBox = CreateFrame("EditBox", "$parentSearchBox", frame, "SearchBoxTemplate")
    frame.SearchBox:SetPoint("LEFT", frame, "TOPLEFT", 70, -42)
    frame.SearchBox:SetPoint("RIGHT", frame, "TOPRIGHT", -15, -42)
    frame.SearchBox:SetSize(158, 18)
    frame.SearchBox:SetScript("OnTextChanged", B.BankSearch_OnTextChanged)

    frame.BankTab = CreateFrame("Button", "$parentBankTab", frame, "CharacterFrameTabButtonTemplate")
    frame.BankTab:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 11, 2)
    frame.BankTab:SetText(BANK)
    frame.BankTab:SetID(1)
    frame.BankTab:SetScript("OnClick", function()
        PanelTemplates_SetTab(frame, 1)
        for _, bag in ipairs(frame.Bags) do
            bag.Hidden = bag:GetID() == REAGENTBANK_CONTAINER
        end
        for _, bagSlot in ipairs(frame.BagSlots) do
            bagSlot:Show()
        end
        frame.Title:SetText(BANK)
        frame.DepositReagentsButton:Hide()
        B:UpdateBagFrame(frame)
    end)

    frame.ReagentsTab = CreateFrame("Button", "$parentReagentsTab", frame, "CharacterFrameTabButtonTemplate")
    frame.ReagentsTab:SetPoint("LEFT", frame.BankTab, "RIGHT", -15, 0)
    frame.ReagentsTab:SetText(REAGENT_BANK)
    frame.ReagentsTab:SetID(2)
    frame.ReagentsTab:SetScript("OnClick", function()
        PanelTemplates_SetTab(frame, 2)
        for bagID, bag in ipairs(frame.Bags) do
            bag.Hidden = bag:GetID() ~= REAGENTBANK_CONTAINER
        end
        for _, bagSlot in ipairs(frame.BagSlots) do
            bagSlot:Hide()
        end
        frame.Title:SetText(REAGENT_BANK)
        frame.DepositReagentsButton:Show()
        B:UpdateBagFrame(frame)
    end)
    frame.DepositReagentsButton = CreateFrame("Button", "$parentDepositReagentsButton", frame, "UIPanelButtonTemplate")
    frame.DepositReagentsButton:SetScript("OnClick", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
        DepositReagentBank()
    end)
    frame.DepositReagentsButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)
    frame.DepositReagentsButton:SetSize(256, 18)
    frame.DepositReagentsButton:SetText(REAGENTBANK_DEPOSIT)
    frame.DepositReagentsButton:Hide()

    frame.Tabs = { frame.BankTab, frame.ReagentsTab }
    PanelTemplates_SetNumTabs(frame, #frame.Tabs)
    PanelTemplates_SetTab(frame, 1)

    SetPortraitToTexture(frame.portrait, "Interface\\ICONS\\INV_Misc_EngGizmos_17")
    frame.Inset.Bg:SetTexture("Interface\\FrameGeneral\\UI-Background-Rock")

    -- register as a special frame so we can close with ESC key
    table.insert(_G.UISpecialFrames, frame:GetName())

    frame:SetScript("OnHide", function()
        CloseBankFrame()
    end)

    R:CreateDragFrame(frame, "Bank", {"BOTTOMLEFT", UIParent, "BOTTOMLEFT", 100, 100})

    return frame
end

function B:UpdateBank()
    B:UpdateBagFrame(B.Bank)
end

function B:ShowBank()
    if not B.Bank:IsShown() then
        B:UpdateBank()
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

function B:BankSearch_OnTextChanged(userChanged)
    SearchBoxTemplate_OnTextChanged(self)
    B:SetItemSearch(B.Bank, self:GetText())
end