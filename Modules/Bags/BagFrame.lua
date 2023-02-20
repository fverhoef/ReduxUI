local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags
local L = R.L

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

    self.PortraitButton:SetPoint("CENTER", self.portrait or self:GetPortrait(), "CENTER", 3, -3)
    self.SearchBox:SetScript("OnTextChanged", self.SearchBox_OnTextChanged)
    UIDropDownMenu_SetInitializeFunction(self.FilterDropDown, self.InitializeFilterDropdown)
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

local bagNames = {
    [0] = BAG_NAME_BACKPACK or L["Backpack"],
    [1] = BAG_NAME_BAG_1 or L["Bag 1"],
    [2] = BAG_NAME_BAG_2 or L["Bag 2"],
    [3] = BAG_NAME_BAG_3 or L["Bag 3"],
    [4] = BAG_NAME_BAG_4 or L["Bag 4"]
}

local bagGearFilters = {
    Enum.BagSlotFlags.PriorityEquipment, Enum.BagSlotFlags.PriorityConsumables, Enum.BagSlotFlags.PriorityTradeGoods, Enum.BagSlotFlags.PriorityJunk, Enum.BagSlotFlags.PriorityQuestItems
}

local bagFilterLabels = {
    [Enum.BagSlotFlags.PriorityEquipment] = BAG_FILTER_EQUIPMENT,
    [Enum.BagSlotFlags.PriorityConsumables] = BAG_FILTER_CONSUMABLES,
    [Enum.BagSlotFlags.PriorityTradeGoods] = BAG_FILTER_TRADE_GOODS,
    [Enum.BagSlotFlags.PriorityJunk] = BAG_FILTER_JUNK,
    [Enum.BagSlotFlags.PriorityQuestItems] = BAG_FILTER_QUEST_ITEMS or AUCTION_CATEGORY_QUEST_ITEMS
}

function B.BagFrameMixin:InitializeFilterDropdown(level)
    local bag = self:GetParent()

    if level == 1 then
        local info = UIDropDownMenu_CreateInfo()
        info.text = BAG_FILTER_TITLE_SORTING or L["Sorting"]
        info.isTitle = 1
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)

        for i = 0, Constants.InventoryConstants.NumBagSlots do
            local info = UIDropDownMenu_CreateInfo()
            info.text = bagNames[i]
            info.hasArrow = true
            info.notCheckable = true
            info.value = i
            UIDropDownMenu_AddButton(info, level)
        end
    elseif level == 2 then
        local bagID = UIDROPDOWNMENU_MENU_VALUE
        local sortingConfig = bag.config.sorting[bagID]
        if not sortingConfig then
            bag.config.sorting[bagID] = {}
            sortingConfig = bag.config.sorting[bagID]
        end
        if not sortingConfig.filter then
            sortingConfig.filter = {}
        end

        local info = UIDropDownMenu_CreateInfo()
        info.text = BAG_FILTER_ASSIGN_TO
        info.isTitle = 1
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)

        info = UIDropDownMenu_CreateInfo()

        for i, flag in ipairs(bagGearFilters) do
            info.text = bagFilterLabels[flag]
            info.checked = sortingConfig.filter[flag]
            info.func = function(_, _, _, value)
                sortingConfig.filter[flag] = not value
            end

            UIDropDownMenu_AddButton(info, level)
        end

        info = UIDropDownMenu_CreateInfo()
        info.text = BAG_FILTER_CLEANUP
        info.isTitle = 1
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)

        info = UIDropDownMenu_CreateInfo()
        info.text = BAG_FILTER_IGNORE
        info.func = function(_, _, _, value)
            sortingConfig.ignored = not value
        end
        info.checked = sortingConfig.ignored

        UIDropDownMenu_AddButton(info, level)
    end
end

function B.BagFrameMixin:Sort()
    B:Sort(self)
end

B.BagFrameSortButtonMixin = {}
ReduxBagFrameSortButtonMixin = B.BagFrameSortButtonMixin

function B.BagFrameSortButtonMixin:OnClick()
    PlaySound(SOUNDKIT.UI_BAG_SORTING_01)
    self:GetParent():Sort()
end

function B.BagFrameSortButtonMixin:OnEnter()
    GameTooltip:SetOwner(self)
    GameTooltip_SetTitle(GameTooltip, BAG_CLEANUP_BAGS, HIGHLIGHT_FONT_COLOR)
    GameTooltip_AddNormalLine(GameTooltip, BAG_CLEANUP_BAGS_DESCRIPTION or L["Auto-sorts your inventory to make room for new items.\nYou can assign an item type to a specific bag by clicking the bag's top-left icon."])
    GameTooltip:Show()
end

function B.BagFrameSortButtonMixin:OnLeave()
    GameTooltip_Hide()
end

B.BagFramePortraitButtonMixin = {}
ReduxBagFramePortraitButtonMixin = B.BagFramePortraitButtonMixin

function B.BagFramePortraitButtonMixin:OnMouseDown()
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    ToggleDropDownMenu(1, nil, self:GetParent().FilterDropDown, self, 0, 0)
end
