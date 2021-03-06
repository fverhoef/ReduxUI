local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.actionButtons = {}

function BS:StyleActionButton(button)
    if not button then
        return
    end
    if BS.masque then
        BS.masqueGroups.actionButtons:AddButton(button)
        return
    end
    if button.__styled then
        BS:UpdateActionButton(button)
        return
    end

    local buttonName = button:GetName()
    local config = BS.config.actionBars

    if button.Border then
        button.Border:Hide()
        button.Border = nil
    end

    button:CreateShadow()
    button:CreateBackdrop(R.media.textures.backdrops.button, nil, nil, 2, 2)
    button:CreateGlossOverlay(nil, nil, nil, 0, 0, -1, 0)

    button:SetNormalTexture(BS.config.borders.texture)
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetPoint("TOPLEFT", 0, 0)
    normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    normalTexture:SetVertexColor(unpack(BS.config.borders.color))

    -- null the reference to the normal texture to prevent Blizz code from overriding its color
    button.NormalTexture = nil

    button:SetPushedTexture(BS.config.borders.texture)
    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetPoint("TOPLEFT", 0, 0)
    pushedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    pushedTexture:SetVertexColor(unpack(BS.config.borders.pushedColor))

    local icon = _G[buttonName .. "Icon"] or button.icon
    if icon then
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        icon:SetInside(button, 3, 3)
    end

    local cooldown = _G[buttonName .. "Cooldown"]
    if cooldown then
        cooldown:SetFrameLevel(cooldown:GetParent():GetFrameLevel())
        cooldown:SetPoint("TOPLEFT", 0, 0)
        cooldown:SetPoint("BOTTOMRIGHT", 0, 0)
    end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints()
    overlay:SetFrameLevel(button:GetFrameLevel() + 1)

    local count = _G[buttonName .. "Count"]
    if count then
        count:SetParent(overlay)
        count:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    local hotkey = _G[buttonName .. "HotKey"]
    if hotkey then
        hotkey:SetParent(overlay)
        hotkey:SetFont(config.font, config.fontSize, config.fontOutline)
        hotkey:SetAlpha(not config.hideKeybindText and 1 or 0)
    end

    local name = _G[buttonName .. "Name"]
    if name then
        name:SetParent(overlay)
        name:SetFont(config.font, config.fontSize, config.fontOutline)
        name:SetAlpha(not config.hideMacroText and 1 or 0)
    end

    local floatingBG = _G[buttonName .. "FloatingBG"]
    if floatingBG then
        floatingBG:Hide()
    end

    BS.actionButtons[button] = true
    button.__styled = true

    BS:UpdateActionButton(button)
end

function BS:UpdateActionButton(button)
    if not button or not button.__styled then
        return
    end
    if not button.__styled then
        BS:StyleActionButton(button)
        return
    end

    if button.checksRange and not button.inRange then
        button.icon:SetVertexColor(unpack(BS.config.colors.outOfRange))
    else
        if button.isUsable then
            button.icon:SetVertexColor(unpack(BS.config.colors.usable))
        elseif button.notEnoughMana then
            button.icon:SetVertexColor(unpack(BS.config.colors.notEnoughMana))
        else
            button.icon:SetVertexColor(unpack(BS.config.colors.notUsable))
        end
    end
end

function BS:StyleAllActionButtons()
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        BS:StyleActionButton(_G["ActionButton" .. i])
        BS:StyleActionButton(_G["MultiBarBottomLeftButton" .. i])
        BS:StyleActionButton(_G["MultiBarBottomRightButton" .. i])
        BS:StyleActionButton(_G["MultiBarRightButton" .. i])
        BS:StyleActionButton(_G["MultiBarLeftButton" .. i])
    end

    for i = 1, _G.NUM_PET_ACTION_SLOTS do
        BS:StyleActionButton(_G["PetActionButton" .. i])
    end

    for i = 1, _G.NUM_STANCE_SLOTS do
        BS:StyleActionButton(_G["StanceButton" .. i])
    end

    _G.MainMenuBarVehicleLeaveButton:CreateBorder(BS.config.borderSize, BS.config.borders.texture, BS.config.borders.color)
    _G.MainMenuBarVehicleLeaveButton:CreateShadow()

    BS:SecureHook("ActionButton_UpdateUsable", BS.ActionButton_UpdateUsable)
    BS:SecureHook("ActionButton_UpdateRangeIndicator", BS.ActionButton_UpdateRangeIndicator)
    BS:SecureHook("ActionButton_UpdateCount", BS.ActionBarButton_UpdateCount)
end

function BS:UpdateAllActionButtons()
    local config = BS.config.actionBars
    for button in pairs(BS.actionButtons) do
        local buttonName = button:GetName()

        button:SetNormalTexture(BS.config.borders.texture)
        local normalTexture = button:GetNormalTexture()
        if button.action and IsEquippedAction(button.action) then
            normalTexture:SetVertexColor(0, 1.0, 0, 1)
        else
            normalTexture:SetVertexColor(unpack(BS.config.borders.color))
        end

        button:SetPushedTexture(BS.config.borders.texture)
        local pushedTexture = button:GetPushedTexture()
        pushedTexture:SetVertexColor(unpack(BS.config.borders.pushedColor))

        local count = _G[buttonName .. "Count"]
        if count then
            count:SetFont(config.font, config.fontSize, config.fontOutline)
        end

        local hotkey = _G[buttonName .. "HotKey"]
        if hotkey then
            hotkey:SetFont(config.font, config.fontSize, config.fontOutline)
            hotkey:SetAlpha(not config.hideKeybindText and 1 or 0)
        end

        local name = _G[buttonName .. "Name"]
        if name then
            name:SetFont(config.font, config.fontSize, config.fontOutline)
            name:SetAlpha(not config.hideMacroText and 1 or 0)
        end

        button.Gloss:SetShown(config.glow)

        BS:UpdateActionButton(button)
    end

    _G.MainMenuBarVehicleLeaveButton.Border:SetSize(config.borderSize)
    _G.MainMenuBarVehicleLeaveButton.Border:SetTexture(BS.config.borders.texture)
    _G.MainMenuBarVehicleLeaveButton.Border:SetVertexColor(unpack(BS.config.borders.color))
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

    if self.action and IsEquippedAction(self.action) then
        self:GetNormalTexture():SetVertexColor(0, 1.0, 0, 1)
    end
end

function BS:ActionButton_UpdateRangeIndicator(checksRange, inRange)
    if BS.config.outOfRangeColoring == BS.OUT_OF_RANGE_MODES.Button and (self.action or self.spellID) then
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

    if self.reagentCount ~= nil then
        self.Count:SetText(self.reagentCount)
    end
end
