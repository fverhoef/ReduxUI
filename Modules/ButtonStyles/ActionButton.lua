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

    local buttonName = button:GetName()
    local config = BS.config.actions

    if not button.__styled then
        button.__styled = true
        button.LBFSkinned = true
        BS.actionButtons[button] = true

        local overlay = CreateFrame("Frame", nil, button)
        overlay:SetAllPoints()
        overlay:SetFrameLevel(button:GetFrameLevel() + 1)

        button.icon = button.icon or _G[buttonName .. "Icon"]
        if icon then
            icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
            icon:SetInside(button, 2, 2)
        end

        button.count = _G[buttonName .. "Count"]
        if button.count then
            button.count:SetParent(overlay)
        end

        button.cooldown = _G[buttonName .. "Cooldown"]
        if button.cooldown then
            button.cooldown:SetFrameLevel(button.cooldown:GetParent():GetFrameLevel())
            button.cooldown:SetInside(button, 1, 1)
        end

        button.hotkey = _G[buttonName .. "HotKey"]
        if button.hotkey then
            button.hotkey:SetParent(overlay)
        end

        button.name = _G[buttonName .. "Name"]
        if button.name then
            button.name:SetParent(overlay)
        end

        local floatingBG = _G[buttonName .. "FloatingBG"]
        if floatingBG then
            floatingBG:Hide()
        end

        button:CreateBackdrop({ bgFile = config.backdrop, edgeSize = 2, insets = { left = 2, right = 2, top = 2, bottom = 2 } })
    end

    if button.count then
        button.count:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    if button.hotkey then
        button.hotkey:SetFont(config.font, config.fontSize, config.fontOutline)
        button.hotkey:SetAlpha(not config.hideKeybindText and 1 or 0)
    end

    if button.name then
        button.name:SetFont(config.font, config.fontSize, config.fontOutline)
        button.name:SetAlpha(not config.hideMacroText and 1 or 0)
    end

    button:SetNormalTexture(BS.config.border)
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetOutside(button, 4, 4)
    normalTexture:SetVertexColor(unpack(BS.config.colors.border))
    normalTexture:SetTexCoord(0, 1, 0, 1)

    button:SetPushedTexture(BS.config.border)
    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetOutside(button, 4, 4)
    pushedTexture:SetVertexColor(unpack(BS.config.colors.pushed))
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

    _G.MainMenuBarVehicleLeaveButton:CreateBorder(nil, nil, 0)
end

function BS:UpdateAllActionButtons()
    for button in pairs(BS.actionButtons) do
        BS:StyleActionButton(button)
    end

    _G.MainMenuBarVehicleLeaveButton.Border:SetBackdropBorderColor(unpack(BS.config.colors.border))
end
