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
    if button.__styled then
        BS:UpdateItemButton(button)
        return
    end

    local buttonName = button:GetName()
    local config = BS.config.items

    if button.Border then
        button.Border:Hide()
        button.Border = nil
    end

    button:CreateShadow()
    button:CreateBackdrop(R.media.textures.backdrops.button)
    button.Backdrop:SetOutside(3, 3)

    button:SetNormalTexture(BS.config.borders.texture)
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetPoint("TOPLEFT", 0, 0)
    normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    normalTexture:SetVertexColor(unpack(BS.config.borders.color))

    button:SetPushedTexture(BS.config.borders.texture)
    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetPoint("TOPLEFT", 0, 0)
    pushedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    pushedTexture:SetVertexColor(unpack(BS.config.borders.pushedColor))

    local icon = _G[buttonName .. "Icon"] or _G[buttonName .. "IconTexture"] or button.icon
    if icon then
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        icon:SetInside(button, 3, 3)
    end

    local iconBorder = _G[buttonName .. "IconBorder"] or button.IconBorder
    if iconBorder then
        iconBorder:Hide()
    end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints()
    overlay:SetFrameLevel(button:GetFrameLevel() + 1)

    local count = _G[buttonName .. "Count"]
    if count then
        count:SetParent(overlay)
        count:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    local stock = _G[buttonName .. "Stock"]
    if stock then
        stock:SetParent(overlay)
        stock:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    BS.itemButtons[button] = true
    button.__styled = true
end

function BS:UpdateItemButton(button)
    if not button or not button.__styled then
        return
    end

    local color = R.config.db.profile.borders.color
    if button.itemIDOrLink then
        local _, _, itemRarity, _, _, _, _, _, _, _, _, itemClassID = GetItemInfo(button.itemIDOrLink)
        if itemClassID == LE_ITEM_CLASS_QUESTITEM then
            color = R.Modules.Bags.config.colors.questItem
        elseif itemRarity and itemRarity > 1 then
            color = {GetItemQualityColor(itemRarity)}
        end
    end

    local normalTexture = button:GetNormalTexture()
    normalTexture:SetVertexColor(unpack(color))
end

function BS:StyleAllItemButtons()
    local itemButtons = {
        "MainMenuBarBackpackButton",
        "CharacterBag0Slot",
        "CharacterBag1Slot",
        "CharacterBag2Slot",
        "CharacterBag3Slot"
    }
    for _, buttonName in next, itemButtons do
        BS:StyleItemButton(_G[buttonName])
    end

    for i, slot in next, R.EquipmentSlots do
        local button = _G["Character" .. slot]
        if button then
            button.itemIDOrLink = GetInventoryItemLink("player", GetInventorySlotInfo(slot))
            BS:StyleItemButton(button)
        end
    end
end

function BS:UpdateAllItemButtons()
    local config = BS.config.items
    for button in pairs(BS.itemButtons) do
        local buttonName = button:GetName()

        button:SetNormalTexture(BS.config.borders.texture)
        local normalTexture = button:GetNormalTexture()
        normalTexture:SetVertexColor(unpack(BS.config.borders.color))

        button:SetPushedTexture(BS.config.borders.texture)
        local pushedTexture = button:GetPushedTexture()
        pushedTexture:SetVertexColor(unpack(BS.config.borders.pushedColor))

        local count = _G[buttonName .. "Count"]
        if count then
            count:SetFont(config.font, config.fontSize, config.fontOutline)
        end
    
        local stock = _G[buttonName .. "Stock"]
        if stock then
            stock:SetFont(config.font, config.fontSize, config.fontOutline)
        end

        BS:UpdateItemButton(button)
    end
end

function BS:SetItemButtonQuality(quality, itemIDOrLink, suppressOverlays)
    self.quality = quality
    self.itemIDOrLink = itemIDOrLink
    BS:StyleItemButton(self)
end

function BS:SetItemButtonNormalTextureVertexColor(r, g, b)
    if not self or not self.__styled then
        return
    end

    if r == 1 and g == 1 and b == 1 then
        BS:UpdateItemButton(self)
    end
end
