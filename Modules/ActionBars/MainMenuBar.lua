local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMainMenuBar()
    local config = AB.config.mainMenuBar
    local default = AB.defaults.mainMenuBar

    local framesToHide = {_G.MainMenuBar}
    local framesToDisable = {_G.MainMenuBar, _G.MicroButtonAndBagsBar, _G.MainMenuBarArtFrame}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    local frame = CreateFrame("Frame", addonName .. "MainMenuBar", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(552, 51)
    frame:SetPoint("BOTTOM", _G.UIParent, "BOTTOM", 0, 0)
    frame.buttons = {}

    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["ActionButton" .. i]
        if not button then
            break
        end
        table.insert(frame.buttons, button)
    end

    if _G.ActionBarUpButton then
        _G.ActionBarUpButton:SetParent(frame)
        _G.ActionBarUpButton:ClearAllPoints()
        _G.ActionBarUpButton:SetPoint("LEFT", "ActionButton12", "RIGHT", 0, 7)
    end

    if _G.ActionBarDownButton then
        _G.ActionBarDownButton:SetParent(frame)
        _G.ActionBarDownButton:ClearAllPoints()
        _G.ActionBarDownButton:SetPoint("LEFT", "ActionButton12", "RIGHT", 0, -10)
    end

    frame.PageNumber = frame:CreateFontString(nil, "OVERLAY")
    frame.PageNumber:SetFont(_G.STANDARD_TEXT_FONT, 11, "OUTLINE")
    frame.PageNumber:SetJustifyH("CENTER")
    frame.PageNumber:SetText(GetActionBarPage())
    frame.PageNumber:SetSize(20, 20)
    frame.PageNumber:SetPoint("LEFT", "ActionButton12", "RIGHT", 25, -2)

    -- fix the button grid for actionbar1
    local function UpdateGridVisibility()
        if InCombatLockdown() then
            return
        end
        local showgrid = tonumber(GetCVar("alwaysShowActionBars"))
        for _, button in next, frame.buttons do
            button:SetAttribute("showgrid", showgrid)
            ActionButton_ShowGrid(button)
        end
    end
    AB:SecureHook("MultiActionBar_UpdateGridVisibility", UpdateGridVisibility)

    -- _onstate-page state driver
    for i, button in next, frame.buttons do
        frame:SetFrameRef("ActionButton" .. i, button)
    end

    frame:Execute(([[
        buttons = table.new()
        for i=1, %d do
            table.insert(buttons, self:GetFrameRef("%s"..i))
        end
    ]]):format(_G.NUM_ACTIONBAR_BUTTONS, "ActionButton"))

    frame:SetAttribute("_onstate-page", [[
        --print("_onstate-page","index",newstate)
        self:SetAttribute("actionpage", newstate)
        for i, button in next, buttons do
            button:SetAttribute("actionpage", newstate)
        end
    ]])

    local actionPage =
        "[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1"
    RegisterStateDriver(frame, "page", actionPage)

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    frame:CreateFader(config.fader, frame.buttons)
    R:CreateDragFrame(frame, "Main Action Bar", default.point)

    AB:UpdateBar(frame)

    return frame
end

function AB:UpdateMainMenuBar()
    local config = AB.config.mainMenuBar
    local rightBarConfig = AB.config.multiBarBottomRight
    local frame = AB.bars.MainMenuBar
    local artwork = AB.bars.Artwork

    if config.enabled then
        frame:Show()

        frame:ClearAllPoints()
        if config.detached then
            frame:Point(unpack(config.point))
        else
            local isExpBarShown = _G.MainMenuExpBar:IsShown()
            local isRepBarShown = _G.ReputationWatchBar:IsShown()

            local offset = 0
            if isExpBarShown and isRepBarShown then
                offset = 22
            else
                offset = 10
            end

            config.columnDirection = AB.COLUMN_DIRECTIONS.Right
            config.rowDirection = AB.ROW_DIRECTIONS.Down
            config.buttons = 12
            config.buttonsPerRow = 12
            config.buttonSize = 36
            config.columnSpacing = 6
            config.rowSpacing = 6

            frame:SetPoint("BOTTOMLEFT", artwork, "BOTTOMLEFT", 8, offset + 4)
        end
        frame.PageNumber:SetText(GetActionBarPage())

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
