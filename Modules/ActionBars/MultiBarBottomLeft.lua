local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMultiBarBottomLeft()
    local config = AB.config.multiBarBottomLeft
    local default = AB.defaults.multiBarBottomLeft

    local framesToHide = {_G.MultiBarBottomLeft}
    local framesToDisable = {_G.MultiBarBottomLeft}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    local frame = CreateFrame("Frame", addonName .. "MultiBarBottomLeft", AB.bars.MainMenuBar, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(506, 36)
    frame:Point("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 0, -5)
    frame.buttons = {}

    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarBottomLeftButton" .. i]
        if not button then
            break
        end
        table.insert(frame.buttons, button)
    end

    AB:UpdateBar(frame)

    frame:SetAttribute("actionpage", 6) -- 6 = MultiBarBottomLeft

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    frame:CreateFader(config.fader, frame.buttons)
    R:CreateDragFrame(frame, "Action Bar 2", default.point)

    return frame
end

function AB:UpdateMultiBarBottomLeft()
    local config = AB.config.multiBarBottomLeft
    local frame = AB.bars.MultiBarBottomLeft

    if config.enabled then
        frame:Show()

        frame:ClearAllPoints()
        if config.detached then
            frame:Point(config.point)
        else
            config.columnDirection = AB.COLUMN_DIRECTIONS.Right
            config.rowDirection = AB.ROW_DIRECTIONS.Down
            config.buttons = 12
            config.buttonsPerRow = 12
            config.buttonSize = 36
            config.columnSpacing = 6
            config.rowSpacing = 6

            frame:Point("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 0, 8)
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
