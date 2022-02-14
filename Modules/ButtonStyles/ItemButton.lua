local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.itemButtons = {}
BS.tags = {AuctionBrowse = 1, SendMail = 2}

function BS:StyleItemButton(button)
    if not button then return end
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

    local nameFrame = _G[buttonName .. "NameFrame"] or button.NameFrame
    button.isLargeItemButton = nameFrame ~= nil

    if TODO then
        if button.Border then
            button.Border:Hide()
            button.Border = nil
        end
        if button.isLargeItemButton then
            button:CreateBorder(nil, nil, 0)
            button:CreateBackdrop({bgFile = R.media.textures.blank, edgeSize = 3, insets = {left = 3, right = 3, top = 3, bottom = 3}})
            nameFrame:SetTexture(nil)
        else
            -- button:CreateBackdrop({bgFile = config.backdrop, edgeSize = 3, insets = {left = 3, right = 3, top = 3, bottom = 3}})

            if string.match(buttonName, "SendMailAttachment") then
                button.tag = BS.tags.SendMail
                button:CreateBorder(nil, nil, 0)
            end
        end
    end

    local icon = _G[buttonName .. "Icon"] or _G[buttonName .. "IconTexture"] or button.icon
    if icon then
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

        if button.isLargeItemButton then
            icon:SetPoint("TOPLEFT", 3, -3)
            icon:SetSize(icon:GetWidth() - 3, icon:GetHeight() - 3)
        else
            icon:SetInside(button, 3, 3)
        end
    end

    local iconBorder = _G[buttonName .. "IconBorder"] or button.IconBorder
    if iconBorder then iconBorder:Hide() end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints()
    overlay:SetFrameLevel(button:GetFrameLevel() + 1)

    local count = _G[buttonName .. "Count"]
    if count then count:SetParent(overlay) end

    local stock = _G[buttonName .. "Stock"]
    if stock then stock:SetParent(overlay) end

    BS.itemButtons[button] = true
    button.__styled = true

    BS:UpdateItemButton(button)
end

function BS:UpdateItemButton(button)
    if not button then return end
    if not button.__styled then
        BS:StyleItemButton(button)
        return
    end

    local config = BS.config.items
    local buttonName = button:GetName()

    local count = _G[buttonName .. "Count"]
    if count then count:SetFont(config.font, config.fontSize, config.fontOutline) end

    local stock = _G[buttonName .. "Stock"]
    if stock then stock:SetFont(config.font, config.fontSize, config.fontOutline) end

    if not button.isLargeItemButton then
        local normalTexture = button:GetNormalTexture()
        local pushedTexture = button:GetPushedTexture()
        if config.replaceBorders then
            button:SetNormalTexture(BS.config.border)
            normalTexture = button:GetNormalTexture()
            normalTexture:SetPoint("TOPLEFT", 0, 0)
            normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)

            button:SetPushedTexture(BS.config.border)
            pushedTexture = button:GetPushedTexture()
            pushedTexture:SetPoint("TOPLEFT", 0, 0)
            pushedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        end

        normalTexture:SetVertexColor(unpack(BS.config.colors.border))
        pushedTexture:SetVertexColor(unpack(BS.config.colors.pushed))

        local color = BS.config.colors.border
        if button.itemIDOrLink then
            local _, _, itemRarity, _, _, _, _, _, _, _, _, itemClassID = GetItemInfo(button.itemIDOrLink)
            if itemRarity and itemRarity > 1 then
                color = {GetItemQualityColor(itemRarity)}
            end
        end

        if button.Border then button.Border:SetBackdropBorderColor(unpack(color)) end
        normalTexture:SetVertexColor(unpack(color))
    end

    -- button.Gloss:SetShown(config.gloss and (button.isBagSlot or button.isCharacterSlot))
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
    local itemButtons = {"MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot"}
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

function BS:UpdateAllItemButtons() for button in pairs(BS.itemButtons) do BS:UpdateItemButton(button) end end

function BS:SetItemButtonCount(count, itemCount)
    if not self then return end

    BS:StyleItemButton(self)
end

function BS:SetItemButtonQuality(quality, itemIDOrLink, suppressOverlays)
    if not self then return end

    self.quality = quality
    self.itemIDOrLink = itemIDOrLink
    BS:StyleItemButton(self)
end

function BS:SetItemButtonTexture(texture)
    if not self then return end

    BS:StyleItemButton(self)
end

function BS:SetItemButtonNormalTextureVertexColor(r, g, b)
    if not self or not self.__styled then return end

    if r == 1 and g == 1 and b == 1 then BS:UpdateItemButton(self) end
end
