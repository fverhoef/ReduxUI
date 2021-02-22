local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.itemButtons = {}
BS.tags = {AuctionBrowse = 1, SendMail = 2}

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

    local icon = _G[buttonName .. "Icon"] or _G[buttonName .. "IconTexture"] or button.icon
    local iconBorder = _G[buttonName .. "IconBorder"] or button.IconBorder
    local nameFrame = _G[buttonName .. "NameFrame"] or button.NameFrame
    local count = _G[buttonName .. "Count"]
    local stock = _G[buttonName .. "Stock"]

    local isLargeItemButton = nameFrame ~= nil
    if isLargeItemButton then
        button:CreateBorder(4, BS.config.borders.texture)
        button:CreateBackdrop()
        button.Backdrop:SetInside(5, 5)
        nameFrame:SetTexture(nil)
    else
        button:CreateBackdrop(R.media.textures.backdrops.button)
        button.Backdrop:SetOutside(3, 3)

        if string.match(buttonName, "SendMailAttachment") then
            button.tag = BS.tags.SendMail
            button:CreateBorder()
        else
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
        end
    end

    if icon then
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

        if isLargeItemButton then
            icon:SetPoint("TOPLEFT", 3, -3)
            icon:SetSize(icon:GetWidth() - 3, icon:GetHeight() - 3)

            -- TODO: support only having a border around the icon of large item buttons
            if TODO then
                icon.Container = CreateFrame("Frame", nil, button)
                icon.Container:SetAllPoints(icon)
                icon.Container:CreateBorder()
                icon.Container:SetBorderPadding(1)
                button.Border = icon.Container.Border
            end
        else
            icon:SetInside(button, 3, 3)
        end
    end

    if iconBorder then
        iconBorder:Hide()
    end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints()
    overlay:SetFrameLevel(button:GetFrameLevel() + 1)

    if count then
        count:SetParent(overlay)
        count:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    if stock then
        stock:SetParent(overlay)
        stock:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    BS.itemButtons[button] = true
    button.__styled = true

    BS:UpdateItemButton(button)
end

function BS:UpdateItemButton(button)
    if not button then
        return
    end
    if not button.__styled then
        BS:StyleItemButton(button)
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

    if button.Border then
        button.Border:SetVertexColor(unpack(color))
    else
        local normalTexture = button:GetNormalTexture()
        if normalTexture then
            normalTexture:SetVertexColor(unpack(color))
        end
    end
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

function BS:SetItemButtonCount(count, abbreviate)
    if not self then
        return
    end

    BS:StyleItemButton(self)
end

function BS:SetItemButtonQuality(quality, itemIDOrLink, suppressOverlays)
    if not self then
        return
    end

    self.quality = quality
    self.itemIDOrLink = itemIDOrLink
    BS:StyleItemButton(self)
end

function BS:SetItemButtonTexture(texture)
    if not self then
        return
    end

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
