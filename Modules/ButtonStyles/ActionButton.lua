local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.actionButtons = {}

local function ActionButton_ShowGrid(button) button:GetNormalTexture():SetVertexColor(unpack(button.action and IsEquippedAction(button.action) and {0, 1.0, 0, 1} or BS.config.colors.border)) end

local function ActionButton_UpdateUsable(button)
    if button.action or button.spellID then
        if BS.config.outOfRangeColoring == "Button" and button.outOfRange then
            button.icon:SetVertexColor(unpack(BS.config.colors.outOfRange))
        else
            if button.IsUsable then
                button.isUsable, button.notEnoughMana = button:IsUsable()
            elseif button.spellID then
                button.isUsable, button.notEnoughMana = IsUsableSpell(button.spellID)
            elseif button.action then
                button.isUsable, button.notEnoughMana = IsUsableAction(button.action)
            end

            button.isUsable = button.isUsable and not UnitOnTaxi("player")

            if button.isUsable then
                button.icon:SetVertexColor(unpack(BS.config.colors.usable))
            elseif button.notEnoughMana then
                button.icon:SetVertexColor(unpack(BS.config.colors.notEnoughMana))
            else
                button.icon:SetVertexColor(unpack(BS.config.colors.notUsable))
            end
        end
    end

    ActionButton_ShowGrid(button)
end

local function ActionButton_UpdateRangeIndicator(button, checksRange, inRange)
    if button.action or button.spellID then
        local wasOutOfRange = button.outOfRange
        button.outOfRange = checksRange and not inRange
        if button.outOfRange ~= wasOutOfRange then ActionButton_UpdateUsable(button) end
    end
end

local function LibActionButton_OnButtonUpdate(event, button)
    button:SetNormalTexture(BS.config.border)
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetPoint("TOPLEFT", 0, 0)
    normalTexture:SetPoint("BOTTOMRIGHT", 0, 0)
    normalTexture:SetTexCoord(0, 1, 0, 1)
end

local function LibActionButton_OnCooldownUpdate(event, button) if button.cooldown.currentCooldownType == COOLDOWN_TYPE_NORMAL then button.cooldown:SetSwipeColor(0, 0, 0) end end

local function LibActionButton_OnButtonUsable(event, button)
    ActionButton_UpdateUsable(button)

    local hotkey = button.HotKey
    if hotkey:GetText() == RANGE_INDICATOR then hotkey:SetShown(button.outOfRange) end

    if button.outOfRange then
        hotkey:SetVertexColor(unpack(BS.config.colors.outOfRange))
    else
        hotkey:SetVertexColor(unpack(BS.config.colors.usable))
    end
end

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

    -- R:CreateShadow(button)
    R:CreateBackdrop(button, {bgFile = config.backdrop, edgeSize = 2, insets = {left = 2, right = 2, top = 2, bottom = 2}})
    -- button:CreateGlossOverlay(nil, nil, nil, 0, 0, -1, 0)

    local icon = _G[buttonName .. "Icon"] or button.icon
    if icon then
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        R:SetInside(icon, button, 1, 1)
    end

    local cooldown = _G[buttonName .. "Cooldown"]
    if cooldown then
        cooldown:SetFrameLevel(cooldown:GetParent():GetFrameLevel())
        R:SetInside(cooldown, button, 1, 1)
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

    if button.UpdateUsable then BS:SecureHook(button, "UpdateUsable", ActionButton_UpdateUsable) end
    if button.ShowGrid then BS:SecureHook(button, "ShowGrid", ActionButton_ShowGrid) end

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
        R:SetInside(icon, button, 2, 2)
    else
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        R:SetInside(icon, button, 0, 0)
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

    ActionButton_UpdateUsable(button)
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

    R:CreateBorder(_G.MainMenuBarVehicleLeaveButton, nil, nil, 0)
    -- R:CreateShadow(_G.MainMenuBarVehicleLeaveButton)

    if not R.isRetail then
        BS:SecureHook("ActionButton_ShowGrid", ActionButton_ShowGrid)
        BS:SecureHook("ActionButton_UpdateUsable", ActionButton_UpdateUsable)
    end
    BS:SecureHook("ActionButton_UpdateRangeIndicator", ActionButton_UpdateRangeIndicator)
    R.Libs.ActionButton:RegisterCallback("OnButtonUpdate", LibActionButton_OnButtonUpdate)
    R.Libs.ActionButton:RegisterCallback("OnCooldownUpdate", LibActionButton_OnCooldownUpdate)
    R.Libs.ActionButton:RegisterCallback("OnButtonUsable", LibActionButton_OnButtonUsable)
end

function BS:UpdateAllActionButtons()
    for button in pairs(BS.actionButtons) do BS:UpdateActionButton(button) end

    _G.MainMenuBarVehicleLeaveButton.Border:SetBackdropBorderColor(unpack(BS.config.colors.border))
end
