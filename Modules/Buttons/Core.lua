local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local BS = Addon.Modules.Buttons

function BS:OnEnable()
    BS:StyleAllActionButtons()
    BS:StyleAllAuraButtons()
    BS:StyleAllBagButtons()
    BS:StyleAllCharacterSlots()
end

function BS:StyleActionButton(button)
    if not button then
        return
    end
    if button.__styled then
        return
    end
    local buttonName = button:GetName()

    local cfg = BS.config.db.profile.actionBars

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
        bgFile = Addon.media.textures.buttonBackdrop,
        edgeFile = Addon.media.textures.buttonBackdropBorder,
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
    Addon:ApplyVertexColor(icon, {1, 1, 1, 1})
    Addon:ApplyTexCoords(icon, {0.1, 0.9, 0.1, 0.9})

    -- setup normal texture
    Addon:ApplyNormalTexture(button, Addon.media.textures.buttonNormal)
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetPoint("TOPLEFT", 0, 0)
    normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    Addon:ApplyVertexColor(normalTexture, {1, 1, 1, 1})

    -- setup pushed texture
    Addon:ApplyPushedTexture(button, Addon.media.textures.buttonPushed)
    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetPoint("TOPLEFT", 0, 0)
    pushedTexture:SetPoint("BOTTOMRIGHT", 0, 0)

    -- setup highlight texture
    Addon:ApplyHighlightTexture(button, Addon.media.textures.buttonHighlight)
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
        Addon:ApplyCheckedTexture(button, Addon.media.textures.buttonChecked)
    end

    -- setup flash
    local flash = _G[buttonName .. "Flash"]
    -- flash:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    -- flash:SetPoint("TOPLEFT", 1, -1)
    -- flash:SetPoint("BOTTOMRIGHT", -1, 1)
    Addon:ApplyTexture(flash, nil)
    -- SetupTexture(flash, cfg.flash, "SetTexture", flash)

    -- local flyoutBorder = _G[buttonName .. "FlyoutBorder"]
    -- SetupTexture(flyoutBorder, cfg.flyoutBorder, "SetTexture", flyoutBorder)

    -- local flyoutBorderShadow = _G[buttonName .. "FlyoutBorderShadow"]
    -- SetupTexture(flyoutBorderShadow, cfg.flyoutBorderShadow, "SetTexture", flyoutBorderShadow)

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
        count:SetFont(unpack(cfg.font))
    end
    local hotkey = _G[buttonName .. "HotKey"]
    if hotkey then
        hotkey:SetParent(overlay)
        hotkey:SetFont(unpack(cfg.font))
        if cfg.hideKeybindText then
            hotkey:SetAlpha(0)
        end
    end
    local name = _G[buttonName .. "Name"]
    if name then
        name:SetParent(overlay)
        name:SetFont(unpack(cfg.font))
        if cfg.hideMacroText then
            name:SetAlpha(0)
        end
    end

    button.__styled = true
end

function BS:StyleAuraButton(button)
    if not button then
        return
    end
    if button.__styled then
        return
    end
    local buttonName = button:GetName()

    local cfg = BS.config.db.profile.auras

    -- setup icon texture
    local icon = _G[buttonName .. "Icon"]
    if icon then
        icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)
    end

    -- create border if none exists (debuffs have borders)
    local border = _G[buttonName .. "Border"]
    if not border then
        Addon.CreateBorder(button, cfg.borderSize)
    end

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

function BS:StyleBagButton(button)
    if not button then
        return
    end
    if button.__styled then
        return
    end
    local buttonName = button:GetName()

    local cfg = BS.config.db.profile.bags

    -- backdrop
    local bg = CreateFrame("Frame", nil, button)
    bg:SetPoint("TOPLEFT", -3, 3)
    bg:SetPoint("BOTTOMRIGHT", 3, -3)
    bg:SetFrameLevel(button:GetFrameLevel() - 1)
    bg:SetBackdrop({
        bgFile = Addon.media.textures.buttonBackdrop,
        edgeFile = Addon.media.textures.buttonBackdropBorder,
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
        Addon:ApplyTexCoords(icon, {0.1, 0.9, 0.1, 0.9})
    end

    -- setup normal texture
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetPoint("TOPLEFT", 0, 0)
    normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    Addon:ApplyVertexColor(normalTexture, {1, 1, 1, 1})
    Addon:ApplyNormalTexture(button, Addon.media.textures.buttonNormal)

    -- setup pushed texture
    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetPoint("TOPLEFT", 0, 0)
    pushedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    Addon:ApplyPushedTexture(button, Addon.media.textures.buttonPushed)

    -- setup highlight texture
    local highlightTexture = button:GetHighlightTexture()
    highlightTexture:SetPoint("TOPLEFT", 0, 0)
    highlightTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    Addon:ApplyHighlightTexture(button, Addon.media.textures.buttonHighlight)

    -- setup check texture
    local checkedTexture = nil
    if button.GetCheckedTexture then
        checkedTexture = button:GetCheckedTexture()
    end
    if checkedTexture then
        checkedTexture:SetPoint("TOPLEFT", 0, 0)
        checkedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        Addon:ApplyCheckedTexture(button, Addon.media.textures.buttonChecked)
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

function BS:StyleItemButton(button)
    if not button then
        return
    end
    if button.__styled then
        return
    end

    local buttonName = button:GetName()
    local cfg = BS.config.db.profile.items

    -- backdrop
    local bg = CreateFrame("Frame", nil, button)
    bg:SetPoint("TOPLEFT", -3, 3)
    bg:SetPoint("BOTTOMRIGHT", 3, -3)
    bg:SetFrameLevel(button:GetFrameLevel() - 1)
    bg:SetBackdrop({
        bgFile = Addon.media.textures.buttonBackdrop,
        edgeFile = Addon.media.textures.buttonBackdropBorder,
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
        Addon:ApplyTexCoords(icon, {0.1, 0.9, 0.1, 0.9})
    end

    -- setup icon texture
    local iconBorder = _G[buttonName .. "IconBorder"] or button.IconBorder
    if iconBorder then
        iconBorder:SetTexture(Addon.media.textures.buttonBorderWhite)
    end

    -- setup normal texture
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetPoint("TOPLEFT", 0, 0)
    normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    Addon:ApplyVertexColor(normalTexture, {1, 1, 1, 1})
    Addon:ApplyNormalTexture(button, Addon.media.textures.buttonNormal)

    -- setup pushed texture
    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetPoint("TOPLEFT", 0, 0)
    pushedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    Addon:ApplyPushedTexture(button, Addon.media.textures.buttonPushed)

    -- setup highlight texture
    local highlightTexture = button:GetHighlightTexture()
    highlightTexture:SetPoint("TOPLEFT", 0, 0)
    highlightTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    Addon:ApplyHighlightTexture(button, Addon.media.textures.buttonHighlight)

    -- setup check texture
    local checkedTexture = nil
    if button.GetCheckedTexture then
        checkedTexture = button:GetCheckedTexture()
    end
    if checkedTexture then
        checkedTexture:SetPoint("TOPLEFT", 0, 0)
        checkedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        Addon:ApplyCheckedTexture(button, Addon.media.textures.buttonChecked)
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

function BS:StyleMicroButton(button)
    if not button then
        return
    end
    if button.__styled then
        return
    end
    local buttonName = button:GetName()

    local cfg = BS.config.db.profile.microMenu

    button.__styled = true
end

BS.buffButtonIndex = 1
function BS:StyleBuffButtons()
    BS:SecureHook("BuffFrame_UpdateAllBuffAnchors", function()
        if BS.buffButtonIndex > BUFF_MAX_DISPLAY then
            return
        end
        for i = BS.buffButtonIndex, BUFF_MAX_DISPLAY do
            local button = _G["BuffButton" .. i]
            if button then
                BS:StyleAuraButton(button)
                if button.__styled then
                    BS.buffButtonIndex = i + 1
                end
            end
        end
    end)
end

function BS:StyleDebuffButtons()
    BS:SecureHook("DebuffButton_UpdateAnchors", function(buttonName, i)
        BS:StyleAuraButton(_G["DebuffButton" .. i])
    end)
end

function BS:StyleTempEnchants()
    BS:StyleAuraButton(_G["TempEnchant1"])
    BS:StyleAuraButton(_G["TempEnchant2"])
    BS:StyleAuraButton(_G["TempEnchant3"])
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
    local cfg = BS.config.db.profile.actionBars
    Addon.CreateBorder(MainMenuBarVehicleLeaveButton, cfg.borderSize + 6)

    -- show reagent counts for spells
    BS:SecureHook("ActionButton_UpdateCount", BS.ActionBarButton_UpdateCount)
    BS:SecureHook("ActionButton_UpdateUsable", BS.ActionButton_UpdateUsable)
    BS:SecureHook("ActionButton_UpdateRangeIndicator", BS.ActionButton_UpdateRangeIndicator)
end

function BS:StyleAllAuraButtons()
    BS:StyleBuffButtons()
    BS:StyleDebuffButtons()
    BS:StyleTempEnchants()
end

function BS:StyleAllBagButtons()
    local itemButtons = {"MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot"}
    for _, buttonName in next, itemButtons do
        BS:StyleBagButton(_G[buttonName])
    end
end

function BS:StyleAllMicroButtons()
    for _, buttonName in next, MICRO_BUTTONS do
        BS:StyleActionButton(_G[buttonName])
    end
end

function BS:StyleAllCharacterSlots()
    local slots = {
        "HeadSlot",
        "NeckSlot",
        "ShoulderSlot",
        "BackSlot",
        "ChestSlot",
        "ShirtSlot",
        "TabardSlot",
        "WristSlot",
        "HandsSlot",
        "WaistSlot",
        "LegsSlot",
        "FeetSlot",
        "Finger0Slot",
        "Finger1Slot",
        "Trinket0Slot",
        "Trinket1Slot",
        "MainHandSlot",
        "SecondaryHandSlot",
        "RangedSlot"
    }
    for i, slot in next, slots do
        BS:StyleItemButton(_G["Character" .. slot])
    end
end

function BS:ActionButton_UpdateUsable()
    if (self.action or self.spellID) and (self.inRange == nil or self.inRange) then
        BS:Update(self)
    end
end

function BS:ActionButton_UpdateRangeIndicator()
    if BS.config.db.profile.outOfRangeColoring == "button" and (self.action or self.spellID) then
        self.inRange = self.spellID and IsSpellInRange(self.spellID) or IsActionInRange(self.action)
        BS:Update(self)
    end
end

function BS:ActionBarButton_UpdateCount()
    BS:Update(self)
end

function BS:Update(self)
    if self.spellID then
        self.isUsable, self.notEnoughMana = IsUsableSpell(self.spellID)
    elseif self.action then
        self.isUsable, self.notEnoughMana = IsUsableAction(self.action)
    end

    if self.isUsable and UnitOnTaxi("player") then
        self.isUsable = false
    end

    if self.inRange ~= nil and not self.inRange then
        Addon:ApplyVertexColor(self.icon, BS.config.db.profile.colors.outOfRange)
    else
        if self.isUsable then
            Addon:ApplyVertexColor(self.icon, BS.config.db.profile.colors.usable)
        elseif self.notEnoughMana then
            Addon:ApplyVertexColor(self.icon, BS.config.db.profile.colors.notEnoughMana)
        else
            Addon:ApplyVertexColor(self.icon, BS.config.db.profile.colors.notUsable)
        end
    end

    -- update charges
    if self.spellID then
        self.reagentCount = Addon.Libs.ClassicSpellActionCount:GetSpellReagentCount(self.spellID)
    elseif self.action then
        local actionType, id, subType = GetActionInfo(self.action)
        if actionType == "spell" then
            self.reagentCount = Addon.Libs.ClassicSpellActionCount:GetSpellReagentCount(id)
        end
    end
    if self.reagentCount ~= nil then
        self.Count:SetText(self.reagentCount)
    end
end
