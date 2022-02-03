local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

local KEYRING_CONTAINER = KEYRING_CONTAINER or -2

function B:CreateInventoryFrame()
    local frame = CreateFrame("Frame", addonName .. "Inventory", UIParent, "ButtonFrameTemplate")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetFrameStrata("MEDIUM")
    frame:SetSize(356, 88)
    frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -100, 100)
    frame:Hide()

    frame.Title = frame:CreateFontString(nil, "OVERLAY")
    frame.Title:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    frame.Title:SetPoint("TOP", frame, "TOP", 10, -5)
    frame.Title:SetJustifyH("MIDDLE")
    frame.Title:SetText(BACKPACK_TOOLTIP) -- TODO: localization

    frame.BagIDs = {0, 1, 2, 3, 4}
    if not R.isRetail then
        table.insert(frame.BagIDs, KEYRING_CONTAINER)
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

    frame.Money = CreateFrame("Frame", "$parentCurrency", frame, "MoneyFrameTemplate")
    frame.Money:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 5)
    frame.Money:SetScale(0.8)
    _G[frame.Money:GetName() .. "CopperButton"].Text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
    _G[frame.Money:GetName() .. "SilverButton"].Text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
    _G[frame.Money:GetName() .. "GoldButton"].Text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")

    frame.Money:SetScript("OnEnter", B.InventoryMoney_OnEnter)

    frame.SearchBox = CreateFrame("EditBox", "$parentSearchBox", frame, "SearchBoxTemplate")
    frame.SearchBox:SetPoint("LEFT", frame, "TOPLEFT", 70, -42)
    frame.SearchBox:SetPoint("RIGHT", frame, "TOPRIGHT", -15, -42)
    frame.SearchBox:SetSize(178, 18)
    frame.SearchBox:SetScript("OnTextChanged", B.InventorySearch_OnTextChanged)

    SetPortraitToTexture(frame.portrait, "Interface\\ICONS\\INV_Misc_Bag_08")

    -- register as a special frame so we can close with ESC key
    table.insert(_G.UISpecialFrames, frame:GetName())

    -- hook open/close functions
    B:SecureHook("OpenAllBags", B.ShowInventory)
    B:SecureHook("CloseAllBags", B.HideInventory)
    B:SecureHook("ToggleBag", "ToggleBag")
    B:SecureHook("ToggleAllBags", B.ToggleBackpack)
    B:SecureHook("ToggleBackpack", B.ToggleBackpack)

    frame:SetScript("OnHide", B.Inventory_OnHide)

    R:CreateDragFrame(frame, "Inventory", {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -100, 100})

    return frame
end

function B:Inventory_OnHide()
    CloseBackpack()
    for i = 1, NUM_BAG_FRAMES do
        CloseBag(i)
    end
    B:UpdateChecked()
end

function B:InventoryMoney_OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
    GameTooltip:AddLine("Money")
    local total = 0
    for i, char in next, R.config.db.realm.inventory do
        if char.money then
            total = total + char.money

            GameTooltip:AddDoubleLine(R:Hex(RAID_CLASS_COLORS[char.class or "MAGE"]) .. i .. "|r:",
                                      R:FormatMoney(char.money, "FULL", false), 1, 1, 1, 1, 1, 1)
        end
    end
    GameTooltip:AddDoubleLine("Total:", R:FormatMoney(total, "FULL", false), 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
end

function B:UpdateInventory()
    B:UpdateBagFrame(B.Inventory)
    if B.Bank:IsShown() then
        B:UpdateBank()
    end
end

function B:UpdateChecked()
    if B.Inventory:IsShown() then
        B:CheckBagButtons(true)
    else
        B:CheckBagButtons(false)
    end
end

function B:CheckBagButtons(state)
    if R.isRetail then
        return
    end

    MainMenuBarBackpackButton:SetChecked(state)
    CharacterBag0Slot:SetChecked(state)
    CharacterBag1Slot:SetChecked(state)
    CharacterBag2Slot:SetChecked(state)
    CharacterBag3Slot:SetChecked(state)
    if KeyRingButton then
        KeyRingButton:SetChecked(state)
    end
end

function B:ShowInventory()
    if not B.Inventory:IsShown() then
        B:UpdateInventory()
        B.Inventory:Show()
        PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)

        C_Timer.After(0.05, B.UpdateChecked)
    end
end

function B:HideInventory()
    if B.Inventory:IsShown() then
        B.Inventory:Hide()
        PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)

        C_Timer.After(0.05, B.UpdateChecked)

        B:HideBank()
    end
end

function B:ToggleInventory()
    if B.Inventory:IsShown() then
        B:HideInventory()
    else
        B:ShowInventory()
    end
end

function B:ToggleBackpack()
    if IsOptionFrameOpen() then
        return
    end

    if IsBagOpen(0) then
        B:ShowInventory()
    else
        B:HideInventory()
    end
end

function B:ToggleBag(id)
    if (id and (GetContainerNumSlots(id) == 0)) or id == 0 then
        return
    end

    B:ToggleInventory()
end

function B:InventorySearch_OnTextChanged(userChanged)
    SearchBoxTemplate_OnTextChanged(self)
    B:SetItemSearch(B.Inventory, self:GetText())
end