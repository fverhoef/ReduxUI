local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMultiBarBottomRight()
    local config = AB.config.multiBarBottomRight
    local default = AB.defaults.multiBarBottomRight

    local framesToHide = {_G.MultiBarBottomRight}
    local framesToDisable = {_G.MultiBarBottomRight}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    local frame = CreateFrame("Frame", addonName .. "MultiBarBottomRight", AB.bars.MainMenuBar, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(253, 72)
    frame:Point("BOTTOMRIGHT", AB.bars.MainMenuBar, "TOPRIGHT", -10, -5)
    frame.buttons = {}

    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarBottomRightButton" .. i]
        if not button then
            break
        end
        table.insert(frame.buttons, button)
    end

    AB:UpdateBar(frame)

    frame:SetAttribute("actionpage", 5) -- 5 = MultiBarBottomRight

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    frame:CreateFader(config.fader, frame.buttons)
    R:CreateDragFrame(frame, "Action Bar 3", default.point)

    return frame
end

function AB:UpdateMultiBarBottomRight()
    local config = AB.config.multiBarBottomRight
    local leftBarConfig = AB.config.multiBarBottomLeft
    local frame = AB.bars.MultiBarBottomRight
    local mainMenuBar = AB.bars.MainMenuBar

    if config.enabled then
        frame:Show()

        frame:ClearAllPoints()
        if config.detached then
            frame:Point(config.point)
        else
            if config.attachedPoint == AB.ATTACHMENT_POINTS.Center then
                frame:Point("BOTTOMLEFT", mainMenuBar, "TOPLEFT", 0,
                            12 + (leftBarConfig.enabled and not leftBarConfig.detached and leftBarConfig.buttonSize or 0))
            elseif config.attachedPoint == AB.ATTACHMENT_POINTS.Right then
                frame:Point("BOTTOMLEFT", mainMenuBar, "BOTTOMRIGHT", 44, 0)
            end

            config.columnDirection = AB.COLUMN_DIRECTIONS.Right
            config.rowDirection = AB.ROW_DIRECTIONS.Down
            config.buttons = 12
            config.buttonsPerRow = config.attachedPoint == AB.ATTACHMENT_POINTS.Center and 12 or 6
            config.buttonSize = 36
            config.columnSpacing = 6
            config.rowSpacing = 8
        end

        AB:UpdateBar(frame)

        if config.frameVisibility then
            frame.frameVisibility = config.frameVisibility
            RegisterStateDriver(frame, "visibility", config.frameVisibility)
        end
    else
        if config.frameVisibility then
            UnregisterStateDriver(frame, "visibility")
        end
        frame:Hide()
    end

    AB:UpdateExperienceBarTextures()
    AB:UpdateMaxLevelBarTextures()
    AB:UpdateReputationBarTextures()
end
