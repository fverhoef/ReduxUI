local addonName, ns = ...
local R = _G.ReduxUI
local BS = R:AddModule("ButtonStyles", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function BS:Initialize()
    BS.config = R.config.db.profile.modules.buttonStyles
    BS.colors = BS.config.colors
    if not BS.config.enabled then
        return
    end

    BS:StyleAllActionButtons()
    BS:StyleAllAuraButtons()
    BS:StyleAllBagButtons()
    BS:StyleAllCharacterSlots()
    BS:SecureHook(nil, "SetItemButtonQuality", function(button, quality, itemIDOrLink, suppressOverlays)
        button.quality = quality
        button.itemIDOrLink = itemIDOrLink
        BS:StyleItemButton(button)
    end)
end

function BS:StyleAllActionButtons()
    -- action bar buttons
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        BS:StyleActionButton(_G["ActionButton" .. i])
        BS:StyleActionButton(_G["MultiBarBottomLeftButton" .. i])
        BS:StyleActionButton(_G["MultiBarBottomRightButton" .. i])
        BS:StyleActionButton(_G["MultiBarRightButton" .. i])
        BS:StyleActionButton(_G["MultiBarLeftButton" .. i])
    end

    -- petbar buttons
    for i = 1, NUM_PET_ACTION_SLOTS do
        BS:StyleActionButton(_G["PetActionButton" .. i])
    end

    -- stancebar buttons
    for i = 1, NUM_STANCE_SLOTS do
        BS:StyleActionButton(_G["StanceButton" .. i])
    end

    -- vehicle leave
    MainMenuBarVehicleLeaveButton:CreateBorder(BS.config.borderSize)

    -- show reagent counts for spells
    BS:SecureHook("ActionButton_UpdateCount", BS.ActionBarButton_UpdateCount)
    BS:SecureHook("ActionButton_UpdateUsable", BS.ActionButton_UpdateUsable)
    BS:SecureHook("ActionButton_UpdateRangeIndicator", BS.ActionButton_UpdateRangeIndicator)
end

function BS:StyleActionButton(button)
    if not button then
        return
    end
    if button.__styled then
        BS:UpdateActionButton(button)
        return
    end

    local buttonName = button:GetName()
    button.cfg = BS.config.actionBars

    -- hide floating background
    local floatingBG = _G[buttonName .. "FloatingBG"]
    if floatingBG then
        floatingBG:Hide()
    end

    -- backdrop
    local bg = CreateFrame("Frame", nil, button)
    bg:SetPoint("TOPLEFT", -3, 3)
    bg:SetPoint("BOTTOMRIGHT", 3, -3)
    bg:SetFrameLevel(button:GetFrameLevel() - 1)
    bg:SetBackdrop({
        bgFile = R.media.textures.buttons.buttonBackdrop,
        edgeFile = R.media.textures.buttons.buttonBackdropBorder,
        tile = false,
        tileSize = 32,
        edgeSize = 5,
        insets = {left = 5, right = 5, top = 5, bottom = 5}
    })
    bg:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    bg:SetBackdropBorderColor(0, 0, 0, 1)

    -- setup icon texture
    local icon = _G[buttonName .. "Icon"]
    icon:SetPoint("TOPLEFT", 1, -1)
    icon:SetPoint("BOTTOMRIGHT", -1, 1)
    R:ApplyVertexColor(icon, {1, 1, 1, 1})
    R:ApplyTexCoords(icon, {0.1, 0.9, 0.1, 0.9})

    -- setup normal texture
    R:ApplyNormalTexture(button, R.media.textures.buttons.buttonNormal)
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetPoint("TOPLEFT", 0, 0)
    normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    R:ApplyVertexColor(normalTexture, {1, 1, 1, 1})

    -- setup pushed texture
    R:ApplyPushedTexture(button, R.media.textures.buttons.buttonPushed)
    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetPoint("TOPLEFT", 0, 0)
    pushedTexture:SetPoint("BOTTOMRIGHT", 0, 0)

    -- setup highlight texture
    R:ApplyHighlightTexture(button, R.media.textures.buttons.buttonHighlight)
    local highlightTexture = button:GetHighlightTexture()
    highlightTexture:SetPoint("TOPLEFT", 0, 0)
    highlightTexture:SetPoint("BOTTOMRIGHT", 0, 0)

    -- setup check texture
    local checkedTexture = nil
    if button.GetCheckedTexture then
        checkedTexture = button:GetCheckedTexture()
    end
    if checkedTexture then
        checkedTexture:SetPoint("TOPLEFT", 0, 0)
        checkedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        R:ApplyCheckedTexture(button, R.media.textures.buttons.buttonChecked)
    end

    -- setup flash
    local flash = _G[buttonName .. "Flash"]
    -- flash:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    -- flash:SetPoint("TOPLEFT", 1, -1)
    -- flash:SetPoint("BOTTOMRIGHT", -1, 1)
    R:ApplyTexture(flash, nil)
    -- SetupTexture(flash, button.cfg.flash, "SetTexture", flash)

    -- local flyoutBorder = _G[buttonName .. "FlyoutBorder"]
    -- SetupTexture(flyoutBorder, button.cfg.flyoutBorder, "SetTexture", flyoutBorder)

    -- local flyoutBorderShadow = _G[buttonName .. "FlyoutBorderShadow"]
    -- SetupTexture(flyoutBorderShadow, button.cfg.flyoutBorderShadow, "SetTexture", flyoutBorderShadow)

    -- local flyoutArrow = _G[buttonName .. "FlyoutArrow"]
    -- local NewActionTexture = button.NewActionTexture

    -- setup cooldown
    local cooldown = _G[buttonName .. "Cooldown"]
    cooldown:SetFrameLevel(cooldown:GetParent():GetFrameLevel())
    cooldown:SetPoint("TOPLEFT", 0, 0)
    cooldown:SetPoint("BOTTOMRIGHT", 0, 0)

    -- reparent texts and set fonts
    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints()

    local count = _G[buttonName .. "Count"]
    if count then
        count:SetParent(overlay)
        count:SetFont(unpack(button.cfg.font))
    end
    local hotkey = _G[buttonName .. "HotKey"]
    if hotkey then
        hotkey:SetParent(overlay)
        hotkey:SetFont(unpack(button.cfg.font))
        if button.cfg.hideKeybindText then
            hotkey:SetAlpha(0)
        end
    end
    local name = _G[buttonName .. "Name"]
    if name then
        name:SetParent(overlay)
        name:SetFont(unpack(button.cfg.font))
        if button.cfg.hideMacroText then
            name:SetAlpha(0)
        end
    end

    button.__styled = true
end

function BS:UpdateActionButton(button)
    if not button then
        return
    end
    if not button.__styled then
        BS:StyleActionButton(button)
        return
    end

    if button.checksRange and not button.inRange then
        R:ApplyVertexColor(button.icon, BS.colors.outOfRange)
    else
        if button.isUsable then
            R:ApplyVertexColor(button.icon, BS.colors.usable)
        elseif button.notEnoughMana then
            R:ApplyVertexColor(button.icon, BS.colors.notEnoughMana)
        else
            R:ApplyVertexColor(button.icon, BS.colors.notUsable)
        end
    end

    if button.reagentCount ~= button.previousReagentCount then
        button.Count:SetText(button.reagentCount)
    end
end

function BS:StyleAllAuraButtons()
    BS:SecureHook("BuffFrame_Update", function()
        local button
        for i = 1, BUFF_MAX_DISPLAY do
            BS:StyleAuraButton(_G["BuffButton" .. i])
        end
        for i = 1, DEBUFF_MAX_DISPLAY do
            BS:StyleAuraButton(_G["DebuffButton" .. i])
        end
        for i = 1, NUM_TEMP_ENCHANT_FRAMES do
            button = _G["TempEnchant" .. i]
            button.isTempEnchant = true
            BS:StyleAuraButton(button)
        end
    end)
end

function BS:StyleAuraButton(button)
    if not button then
        return
    end
    if button.__styled then
        BS:UpdateAuraButton(button)
        return
    end
    local buttonName = button:GetName()

    local cfg = R.config.db.profile.modules.buttonStyles.auras

    -- setup icon texture
    local icon = _G[buttonName .. "Icon"]
    if icon then
        icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)
        icon:SetInside(button, 2, 2)
    end

    -- create border, hiding any none existing one (debuffs have borders)
    local border = _G[buttonName .. "Border"]
    if border then
        border:Hide()
    end
    button:CreateBorder(cfg.borderSize)

    -- shadow
    button:CreateShadow()

    -- reparent texts and set fonts
    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints()

    local count = _G[buttonName .. "Count"]
    if count then
        count:SetParent(overlay)
        count:SetFont(unpack(cfg.font))
    end

    local duration = _G[buttonName .. "Duration"]
    if duration then
        duration:SetParent(overlay)
        duration:SetFont(unpack(cfg.font))
    end

    local symbol = button.symbol
    if symbol then
        symbol:SetFont(unpack(cfg.font))
    end

    button.__styled = true
end

function BS:UpdateAuraButton(button)
    if not button then
        return
    end
    if not button.__styled then
        BS:StyleAuraButton(button)
    end

    local borderColor = R.config.db.profile.borders.color
    if button.isDebuff then
        local debuffColor = button.filter == "HARMFUL" and _G.DebuffTypeColor[button.debuffType]
        if debuffColor then
            borderColor = {debuffColor.r, debuffColor.g, debuffColor.b, debuffColor.a or 1}
        end
    end
    if button.isTempEnchant then
        local quality = GetInventoryItemQuality("player", button:GetID())
        if quality and quality > 1 then
            borderColor = {GetItemQualityColor(quality)}
        end
    end
    button:SetBorderColor(unpack(borderColor))
end

function BS:StyleAllBagButtons()
    local itemButtons = {
        "MainMenuBarBackpackButton",
        "CharacterBag0Slot",
        "CharacterBag1Slot",
        "CharacterBag2Slot",
        "CharacterBag3Slot"
    }
    for _, buttonName in next, itemButtons do
        BS:StyleBagButton(_G[buttonName])
    end
end

function BS:StyleBagButton(button)
    if not button then
        return
    end
    if button.__styled then
        BS:UpdateBagButton(button)
        return
    end
    local buttonName = button:GetName()

    local cfg = R.config.db.profile.modules.buttonStyles.bags

    -- backdrop
    local bg = CreateFrame("Frame", nil, button)
    bg:SetPoint("TOPLEFT", -3, 3)
    bg:SetPoint("BOTTOMRIGHT", 3, -3)
    bg:SetFrameLevel(button:GetFrameLevel() - 1)
    bg:SetBackdrop({
        bgFile = R.media.textures.buttons.buttonBackdrop,
        edgeFile = R.media.textures.buttons.buttonBackdropBorder,
        tile = false,
        tileSize = 32,
        edgeSize = 5,
        insets = {left = 5, right = 5, top = 5, bottom = 5}
    })
    bg:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    bg:SetBackdropBorderColor(0, 0, 0, 1)

    -- setup icon texture
    local icon = _G[buttonName .. "IconTexture"]
    if icon then
        icon:SetPoint("TOPLEFT", 1, -1)
        icon:SetPoint("BOTTOMRIGHT", -1, 1)
        R:ApplyTexCoords(icon, {0.1, 0.9, 0.1, 0.9})
    end

    -- setup normal texture
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetPoint("TOPLEFT", 0, 0)
    normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    R:ApplyVertexColor(normalTexture, {1, 1, 1, 1})
    R:ApplyNormalTexture(button, R.media.textures.buttons.buttonNormal)

    -- setup pushed texture
    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetPoint("TOPLEFT", 0, 0)
    pushedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    R:ApplyPushedTexture(button, R.media.textures.buttons.buttonPushed)

    -- setup highlight texture
    local highlightTexture = button:GetHighlightTexture()
    highlightTexture:SetPoint("TOPLEFT", 0, 0)
    highlightTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    R:ApplyHighlightTexture(button, R.media.textures.buttons.buttonHighlight)

    -- setup check texture
    local checkedTexture = nil
    if button.GetCheckedTexture then
        checkedTexture = button:GetCheckedTexture()
    end
    if checkedTexture then
        checkedTexture:SetPoint("TOPLEFT", 0, 0)
        checkedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        R:ApplyCheckedTexture(button, R.media.textures.buttons.buttonChecked)
    end

    local count = _G[buttonName .. "Count"]
    if count then
        count:SetFont(unpack(cfg.font))
    end

    local stock = _G[buttonName .. "Stock"]
    if stock then
        stock:SetFont(unpack(cfg.font))
    end

    button.__styled = true
end

function BS:UpdateBagButton(button)
    if not button then
        return
    end
    if not button.__styled then
        BS:StyleBagButton(button)
        return
    end
end

function BS:StyleAllCharacterSlots()
    for i, slot in next, R.EquipmentSlots do
        BS:StyleItemButton(_G["Character" .. slot])
    end

    BS:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", BS.UpdateAllCharacterSlots)
    _G.CharacterFrame:HookScript("OnShow", BS.UpdateAllCharacterSlots)
end

function BS:UpdateAllCharacterSlots()
    for i, slot in next, R.EquipmentSlots do
        local button = _G["Character" .. slot]
        if button then
            button.itemIDOrLink = GetInventoryItemLink("player", GetInventorySlotInfo(slot))
            BS:UpdateItemButton(button)
        end
    end
end

function BS:StyleItemButton(button)
    if not button then
        return
    end
    if button.__styled then
        BS:UpdateItemButton(button)
        return
    end

    local buttonName = button:GetName()
    local cfg = R.config.db.profile.modules.buttonStyles.items

    -- backdrop
    local bg = CreateFrame("Frame", nil, button)
    bg:SetPoint("TOPLEFT", -3, 3)
    bg:SetPoint("BOTTOMRIGHT", 3, -3)
    bg:SetFrameLevel(button:GetFrameLevel() - 1)
    bg:SetBackdrop({
        bgFile = R.media.textures.buttons.buttonBackdrop,
        edgeFile = R.media.textures.buttons.buttonBackdropBorder,
        tile = false,
        tileSize = 32,
        edgeSize = 5,
        insets = {left = 5, right = 5, top = 5, bottom = 5}
    })
    bg:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    bg:SetBackdropBorderColor(0, 0, 0, 1)

    -- setup icon texture
    local icon = _G[buttonName .. "IconTexture"]
    if icon then
        icon:SetPoint("TOPLEFT", 1, -1)
        icon:SetPoint("BOTTOMRIGHT", -1, 1)
        R:ApplyTexCoords(icon, {0.1, 0.9, 0.1, 0.9})
    end

    -- setup icon border texture
    local iconBorder = _G[buttonName .. "IconBorder"] or button.IconBorder
    if iconBorder then
        iconBorder:SetTexture(R.media.textures.buttons.buttonBorderWhite)
    end

    -- setup normal texture
    local normalTexture = button:GetNormalTexture()
    if normalTexture then
        normalTexture:SetPoint("TOPLEFT", 0, 0)
        normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        R:ApplyVertexColor(normalTexture, {1, 1, 1, 1})
        R:ApplyNormalTexture(button, R.media.textures.buttons.buttonNormal)
    end

    -- setup pushed texture
    local pushedTexture = button:GetPushedTexture()
    if pushedTexture then
        pushedTexture:SetPoint("TOPLEFT", 0, 0)
        pushedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        R:ApplyPushedTexture(button, R.media.textures.buttons.buttonPushed)
    end

    -- setup highlight texture
    local highlightTexture = button:GetHighlightTexture()
    if highlightTexture then
        highlightTexture:SetPoint("TOPLEFT", 0, 0)
        highlightTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        R:ApplyHighlightTexture(button, R.media.textures.buttons.buttonHighlight)
    end

    -- setup check texture
    local checkedTexture = nil
    if button.GetCheckedTexture then
        checkedTexture = button:GetCheckedTexture()
    end
    if checkedTexture then
        checkedTexture:SetPoint("TOPLEFT", 0, 0)
        checkedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        R:ApplyCheckedTexture(button, R.media.textures.buttons.buttonChecked)
    end

    local count = _G[buttonName .. "Count"]
    if count then
        count:SetFont(unpack(cfg.font))
    end

    local stock = _G[buttonName .. "Stock"]
    if stock then
        stock:SetFont(unpack(cfg.font))
    end

    button.__styled = true
end

function BS:UpdateItemButton(button)
    if not button then
        return
    end
    if not button.__styled then
        BS:StyleItemButton(button)
    end

    local border = R:FindButtonBorder(button)
    if border then
        if button.itemIDOrLink then
            local _, _, itemRarity, _, _, _, _, _, _, _, _, itemClassID = GetItemInfo(button.itemIDOrLink)
            if itemClassID == LE_ITEM_CLASS_QUESTITEM then
                border:SetVertexColor(unpack(R.config.db.profile.modules.bags.colors.questItem))
                border:SetTexture(R.media.textures.buttons.buttonBorderWhite)
                border:Show()
            elseif itemRarity and itemRarity > 1 then
                border:SetVertexColor(GetItemQualityColor(itemRarity))
                border:SetTexture(R.media.textures.buttons.buttonBorderWhite)
                border:Show()
            else
                border:SetVertexColor(1, 1, 1)
                border:SetTexture(R.media.textures.buttons.buttonBorder)
                border:Show()
            end
        else
            border:Hide()
        end
    end
end

function BS:StyleAllMicroButtons()
    for _, buttonName in next, MICRO_BUTTONS do
        BS:StyleActionButton(_G[buttonName])
    end
end

function BS:StyleMicroButton(button)
    if not button then
        return
    end
    if button.__styled then
        return
    end
    local buttonName = button:GetName()

    local cfg = R.config.db.profile.modules.buttonStyles.microMenu

    button.__styled = true
end

function BS:ActionButton_UpdateUsable()
    if (self.action or self.spellID) and (not self.checksRange or self.inRange) then
        if self.spellID then
            self.isUsable, self.notEnoughMana = IsUsableSpell(self.spellID)
        elseif self.action then
            self.isUsable, self.notEnoughMana = IsUsableAction(self.action)
        end

        if self.isUsable and UnitOnTaxi("player") then
            self.isUsable = false
        end

        BS:UpdateActionButton(self)
    end
end

function BS:ActionButton_UpdateRangeIndicator(checksRange, inRange)
    if BS.config.outOfRangeColoring == "button" and (self.action or self.spellID) then
        self.checksRange = checksRange
        self.inRange = inRange

        BS:UpdateActionButton(self)
    end
end

function BS:ActionBarButton_UpdateCount()
    if self.spellID then
        self.reagentCount = R.Libs.ClassicSpellActionCount:GetSpellReagentCount(self.spellID)
    elseif self.action then
        local actionType, id, subType = GetActionInfo(self.action)
        if actionType == "spell" then
            self.reagentCount = R.Libs.ClassicSpellActionCount:GetSpellReagentCount(id)
        end
    end

    BS:UpdateActionButton(self)
end
