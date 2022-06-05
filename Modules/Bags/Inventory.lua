local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags
local ID = R.Modules.InventoryDatabase

local KEYRING_CONTAINER = KEYRING_CONTAINER or -2

InventoryMixin = {}

function InventoryMixin:OnLoad()
    self.config = B.config.inventory
    self.BagIDs = {0, 1, 2, 3, 4}
    if not R.isRetail then table.insert(self.BagIDs, KEYRING_CONTAINER) end

    BagFrame_OnLoad(self)

    self.Title:SetText(BACKPACK_TOOLTIP)
    self.Money:SetScale(0.8)

    SetPortraitToTexture(self.portrait, "Interface\\ICONS\\INV_Misc_Bag_08")

    table.insert(_G.UISpecialFrames, self:GetName())
    for i = 1, NUM_CONTAINER_FRAMES do _G["ContainerFrame" .. i]:SetParent(R.HiddenFrame) end

    self:SetNormalizedPoint(self.config.point)
    self:CreateMover("Inventory", B.defaults.inventory.point)

    B:SecureHook("OpenAllBags", B.ShowInventory)
    B:SecureHook("CloseAllBags", B.HideInventory)
    B:SecureHook("ToggleBag", "ToggleBag")
    B:SecureHook("ToggleAllBags", B.ToggleBackpack)
    B:SecureHook("ToggleBackpack", B.ToggleBackpack)
    if BackpackTokenFrame then
        B:SecureHook("ManageBackpackTokenFrame", function(backpack)
            if BackpackTokenFrame_IsShown() then
                BackpackTokenFrame:SetParent(self)
                BackpackTokenFrame:ClearAllPoints()
                BackpackTokenFrame:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 9, -28)
                BackpackTokenFrame:Show()
            else
                BackpackTokenFrame:Hide()
            end
        end)
    end
end

function InventoryMixin:OnHide()
    CloseBackpack()
    for i = 1, NUM_BAG_FRAMES do CloseBag(i) end
    B:UpdateBagBarCheckedState()
end

InventoryMoneyMixin = {}

function InventoryMoneyMixin:Money_OnEnter()
    _G.GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
    _G.GameTooltip:AddLine("Money")
    local total = 0
    for i, char in next, R.config.db.realm.inventory do
        if char.money then
            total = total + char.money
            _G.GameTooltip:AddDoubleLine(R:Hex(RAID_CLASS_COLORS[char.class or "MAGE"]) .. i .. "|r:", R:FormatMoney(char.money, "BLIZZARD"), 1, 1, 1, 1, 1, 1)
        end
    end
    _G.GameTooltip:AddDoubleLine("Total:", R:FormatMoney(total, "BLIZZARD"), 1, 1, 1, 1, 1, 1)

    _G.GameTooltip:AddLine("\nStatistics")
    _G.GameTooltip:AddDoubleLine("Earned:", R:FormatMoney(ID.earned, "BLIZZARD"), 1, 1, 1, 1, 1, 1)
    _G.GameTooltip:AddDoubleLine("Spent:", R:FormatMoney(ID.spent, "BLIZZARD"), 1, 1, 1, 1, 1, 1)
    if ID.profit > 0 then
        _G.GameTooltip:AddDoubleLine("Profit:", R:FormatMoney(ID.profit, "BLIZZARD"), 0, 1, 0, 1, 1, 1)
    elseif ID.profit < 0 then
        _G.GameTooltip:AddDoubleLine("Loss:", R:FormatMoney(ID.profit, "BLIZZARD"), 1, 0, 0, 1, 1, 1)
    end
    _G.GameTooltip:Show()
end

function B:UpdateBagBarCheckedState()
    local state = B.Inventory:IsShown()
    if R.isRetail then
        _G.MainMenuBarBackpackButton.SlotHighlightTexture:SetShown(state)
        _G.CharacterBag0Slot.SlotHighlightTexture:SetShown(state)
        _G.CharacterBag1Slot.SlotHighlightTexture:SetShown(state)
        _G.CharacterBag2Slot.SlotHighlightTexture:SetShown(state)
        _G.CharacterBag3Slot.SlotHighlightTexture:SetShown(state)
    else
        _G.MainMenuBarBackpackButton:SetChecked(state)
        _G.CharacterBag0Slot:SetChecked(state)
        _G.CharacterBag1Slot:SetChecked(state)
        _G.CharacterBag2Slot:SetChecked(state)
        _G.CharacterBag3Slot:SetChecked(state)
        if _G.KeyRingButton then _G.KeyRingButton:SetChecked(state) end
    end
end

function B:ShowInventory()
    if not B.Inventory:IsShown() then
        B.Inventory:Update()
        B.Inventory:Show()
        PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)

        C_Timer.After(0.05, B.UpdateBagBarCheckedState)
    end
end

function B:HideInventory()
    if B.Inventory:IsShown() then
        B.Inventory:Hide()
        PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)

        C_Timer.After(0.05, B.UpdateBagBarCheckedState)

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
    if IsOptionFrameOpen() then return end

    if IsBagOpen(0) then
        B:ShowInventory()
    else
        B:HideInventory()
    end
end

function B:ToggleBag(id)
    if (id and (GetContainerNumSlots(id) == 0)) or id == 0 then return end

    B:ToggleInventory()
end
