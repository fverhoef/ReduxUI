local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.itemButtons = {}

function BS:StyleItemButton(button)
    if not button then
        return
    end
    if BS.masque then
        BS.masqueGroups.itemButtons:AddButton(button)
        return
    end

    local buttonName = button:GetName()
    local config = BS.config.items

    if not button.__styled then
        button.__styled = true
        BS.itemButtons[button] = true

        local overlay = CreateFrame("Frame", "$parentOverlay", button)
        overlay:SetAllPoints()
        overlay:SetFrameLevel(button:GetFrameLevel() + 1)

        button.icon = button.icon or _G[buttonName .. "Icon"] or _G[buttonName .. "IconTexture"]
        if icon then
            icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
            icon:SetInside(button, 2, 2)
        end

        button.count = _G[buttonName .. "Count"]
        if button.count then
            button.count:SetParent(overlay)
        end

        button.stock = _G[buttonName .. "Stock"]
        if button.stock then
            button.stock:SetParent(overlay)
        end

        button:SetNormalTexture(BS.config.border)
        local normalTexture = button:GetNormalTexture()
        normalTexture:SetOutside(button, 4, 4)
        normalTexture:SetTexCoord(0, 1, 0, 1)

        button:SetPushedTexture(BS.config.border)
        local pushedTexture = button:GetPushedTexture()
        pushedTexture:SetOutside(button, 4, 4)
    end

    if button.count then
        button.count:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    if button.stock then
        button.stock:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    local color = BS.config.colors.border
    if button.ItemIDOrLink then
        local itemRarity = select(3, GetItemInfo(button.ItemIDOrLink))
        if itemRarity and itemRarity > 1 then
            local r, g, b = GetItemQualityColor(itemRarity)
            color = { r, g, b }
        end
    end

    button:GetNormalTexture():SetVertexColor(color[1], color[2], color[3], color[4] or 1)
end

function BS:StyleCharacterButtons()
    for i, slot in next, R.EquipmentSlots do
        local button = _G["Character" .. slot]
        if button then
            button.isCharacterSlot = true
            button.itemIDOrLink = GetInventoryItemLink("player", GetInventorySlotInfo(slot))
            BS:StyleItemButton(button)
        end
    end
end

function BS:StyleBagSlots()
    local itemButtons = { "MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot" }
    for _, buttonName in next, itemButtons do
        local button = _G[buttonName]
        if button then
            button.isBagSlot = true
            BS:StyleItemButton(button)
        end
    end
end

function BS:StyleAllItemButtons()
    BS:StyleCharacterButtons()
    BS:StyleBagSlots()
end

function BS:UpdateAllItemButtons()
    for button in pairs(BS.itemButtons) do
        BS:StyleItemButton(button)
    end
end
