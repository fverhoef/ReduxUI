local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateStanceBar()
    local config = AB.config.stanceBar
    local default = AB.defaults.stanceBar

    local frame = CreateFrame("Frame", addonName .. "StanceBar", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(29, 32)
    frame:SetPoint("BOTTOMLEFT", addonName .. "MainMenuBar", "TOPLEFT", 30, 40)
    frame.__blizzardBar = _G.StanceBarFrame
    frame.buttons = {}

    if frame.__blizzardBar then
        frame.__blizzardBar:SetParent(frame)
        frame.__blizzardBar:EnableMouse(false)
        frame.__blizzardBar:ClearAllPoints()
        frame.__blizzardBar:SetAllPoints()
    end

    _G.StanceBarLeft:SetTexture(nil)
    _G.StanceBarMiddle:SetTexture(nil)
    _G.StanceBarRight:SetTexture(nil)

    for i = 1, _G.NUM_STANCE_SLOTS do
        local button = _G["StanceButton" .. i]
        if not button then
            break
        end
        table.insert(frame.buttons, button)
    end

    AB:UpdateBar(frame)

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    frame:CreateFader(config.fader, frame.buttons)
    R:CreateDragFrame(frame, "Stance Bar", default.point)

    return frame
end

function AB:UpdateStanceBar()
    local config = AB.config.stanceBar
    local leftConfig = AB.config.multiBarBottomLeft
    local rightConfig = AB.config.multiBarBottomRight
    local frame = AB.bars.StanceBar

    frame.__blizzardBar:SetParent(frame)
    frame.__blizzardBar:ClearAllPoints()
    frame.__blizzardBar:SetAllPoints()

    if config.enabled then
        frame:Show()

        frame:ClearAllPoints()
        if config.detached then
            frame:Point(unpack(config.point))
        else
            local leftBarEnabledAndAttached = leftConfig.enabled and not leftConfig.detached
            local rightBarEnabledAndAttachedToCenter = rightConfig.enabled and not rightConfig.detached and
                                                           rightConfig.attachedPoint == AB.ATTACHMENT_POINTS.Center

            if leftBarEnabledAndAttached and rightBarEnabledAndAttachedToCenter then
                frame:Point("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 40, 85)
            elseif leftBarEnabledAndAttached or rightBarEnabledAndAttachedToCenter then
                frame:Point("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 40, 45)
            else
                frame:Point("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 40, 5)
            end

            config.columnDirection = AB.COLUMN_DIRECTIONS.Right
            config.rowDirection = AB.ROW_DIRECTIONS.Down
            config.buttons = 12
            config.buttonsPerRow = 12
            config.buttonSize = 30
            config.columnSpacing = 6
            config.rowSpacing = 6
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
end
