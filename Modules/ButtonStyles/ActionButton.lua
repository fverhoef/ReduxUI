local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.actionButtons = {}

function BS:StyleActionButton(button, replace)
    if not button then return end
    if BS.masque then
        BS.masqueGroups.actionButtons:AddButton(button)
        return
    end
    if button.__styled then
        BS:UpdateActionButton(button)
        return
    end

    button.LBFSkinned = true
    local buttonName = button:GetName()
    local config = BS.config.actions

    -- button:CreateShadow()
    button:CreateBackdrop({bgFile = config.backdrop, edgeSize = 2, insets = {left = 2, right = 2, top = 2, bottom = 2}})
    -- button:CreateGlossOverlay(nil, nil, nil, 0, 0, -1, 0)

    local icon = _G[buttonName .. "Icon"] or button.icon
    if icon then
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        icon:SetInside(button, 1, 1)
    end

    local cooldown = _G[buttonName .. "Cooldown"]
    if cooldown then
        cooldown:SetFrameLevel(cooldown:GetParent():GetFrameLevel())
        cooldown:SetInside(button, 1, 1)
    end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints()
    overlay:SetFrameLevel(button:GetFrameLevel() + 1)

    local count = _G[buttonName .. "Count"]
    if count then count:SetParent(overlay) end

    local hotkey = _G[buttonName .. "HotKey"]
    if hotkey then hotkey:SetParent(overlay) end

    local name = _G[buttonName .. "Name"]
    if name then name:SetParent(overlay) end

    local floatingBG = _G[buttonName .. "FloatingBG"]
    if floatingBG then floatingBG:Hide() end

    BS.actionButtons[button] = true
    button.__styled = true

    BS:UpdateActionButton(button)
end

function BS:UpdateActionButton(button)
    if not button or not button.__styled then return end
    if not button.__styled then
        BS:StyleActionButton(button)
        return
    end

    local config = BS.config.actions
    local buttonName = button:GetName()

    local icon = _G[buttonName .. "Icon"] or button.icon
    if config.replaceBorders then
        button:SetNormalTexture(BS.config.border)
        local normalTexture = button:GetNormalTexture()
        normalTexture:SetPoint("TOPLEFT", 0, 0)
        normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        normalTexture:SetVertexColor(unpack(BS.config.colors.border))
        normalTexture:SetTexCoord(0, 1, 0, 1)

        button:SetPushedTexture(BS.config.border)
        local pushedTexture = button:GetPushedTexture()
        pushedTexture:SetPoint("TOPLEFT", 0, 0)
        pushedTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        pushedTexture:SetVertexColor(unpack(BS.config.colors.pushed))

        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        icon:SetInside(button, 2, 2)
    else
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        icon:SetInside(button, 0, 0)
    end

    local count = _G[buttonName .. "Count"]
    if count then count:SetFont(config.font, config.fontSize, config.fontOutline) end

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

    -- button.Gloss:SetShown(config.gloss)

    BS.ActionButton_UpdateUsable(button)
end

function BS:StyleAllActionButtons()
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        BS:StyleActionButton(_G["ActionButton" .. i])
        BS:StyleActionButton(_G["MultiBarBottomLeftButton" .. i])
        BS:StyleActionButton(_G["MultiBarBottomRightButton" .. i])
        BS:StyleActionButton(_G["MultiBarRightButton" .. i])
        BS:StyleActionButton(_G["MultiBarLeftButton" .. i])
    end

    for i = 1, _G.NUM_PET_ACTION_SLOTS do BS:StyleActionButton(_G["PetActionButton" .. i]) end
    for i = 1, _G.NUM_STANCE_SLOTS do BS:StyleActionButton(_G["StanceButton" .. i]) end

    _G.MainMenuBarVehicleLeaveButton:CreateBorder(nil, nil, 0)
    -- _G.MainMenuBarVehicleLeaveButton:CreateShadow()

    BS:SecureHook("ActionButton_UpdateUsable", BS.ActionButton_UpdateUsable)
    BS:SecureHook("ActionButton_UpdateRangeIndicator", BS.ActionButton_UpdateRangeIndicator)
    -- R.Libs.ActionButton:RegisterCallback("OnUpdateRange", function(event, button) BS.ActionButton_UpdateUsable(button) end)
    -- R.Libs.ActionButton:RegisterCallback("OnButtonUsable", function(event, button) BS.ActionButton_UpdateUsable(button) end)
    R.Libs.ActionButton:RegisterCallback("OnButtonUpdate", function(event, button)
        button:SetNormalTexture(BS.config.border)
        local normalTexture = button:GetNormalTexture()
        normalTexture:SetPoint("TOPLEFT", 0, 0)
        normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
        normalTexture:SetTexCoord(0, 1, 0, 1)
    end)
end

function BS:UpdateAllActionButtons()
    for button in pairs(BS.actionButtons) do BS:UpdateActionButton(button) end

    _G.MainMenuBarVehicleLeaveButton.Border:SetBackdropBorderColor(unpack(BS.config.colors.border))
end

function BS:ActionButton_ShowGrid() self:GetNormalTexture():SetVertexColor(unpack(self.action and IsEquippedAction(self.action) and {0, 1.0, 0, 1} or BS.config.colors.border)) end

function BS:ActionButton_UpdateUsable()
    if not self.__styled then
        BS:StyleActionButton(self)
        return
    end

    if (self.action or self.spellID) and (not self.checksRange or self.inRange) then
        if self.spellID then
            self.isUsable, self.notEnoughMana = IsUsableSpell(self.spellID)
        elseif self.action then
            self.isUsable, self.notEnoughMana = IsUsableAction(self.action)
        end

        if self.isUsable and UnitOnTaxi("player") then self.isUsable = false end

        if self.checksRange and not self.inRange then
            self.icon:SetVertexColor(unpack(BS.config.colors.outOfRange))
        else
            if self.isUsable then
                self.icon:SetVertexColor(unpack(BS.config.colors.usable))
            elseif self.notEnoughMana then
                self.icon:SetVertexColor(unpack(BS.config.colors.notEnoughMana))
            else
                self.icon:SetVertexColor(unpack(BS.config.colors.notUsable))
            end
        end
    end

    self:GetNormalTexture():SetVertexColor(unpack(self.action and IsEquippedAction(self.action) and {0, 1.0, 0, 1} or BS.config.colors.border))
end

function BS:ActionButton_UpdateRangeIndicator(checksRange, inRange)
    if (self.action or self.spellID) then
        self.checksRange = checksRange
        self.inRange = inRange

        if self.checksRange and not self.inRange then
            self.icon:SetVertexColor(unpack(BS.config.colors.outOfRange))
        else
            if self.isUsable then
                self.icon:SetVertexColor(unpack(BS.config.colors.usable))
            elseif self.notEnoughMana then
                self.icon:SetVertexColor(unpack(BS.config.colors.notEnoughMana))
            else
                self.icon:SetVertexColor(unpack(BS.config.colors.notUsable))
            end
        end
    end
end
