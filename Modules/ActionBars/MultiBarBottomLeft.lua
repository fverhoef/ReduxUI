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

    for i, button in next, frame.buttons do
        local parent = frame
        local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}

        if i > 1 then
            parent = frame.buttons[i - 1]
            point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
        end

        AB:SetupButton(button, frame, 36, 36, point)
    end

    frame:SetAttribute("actionpage", 6) -- 6 = MultiBarBottomLeft

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
            frame:Point("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 0, -5)
        end
    else
        frame:Hide()
    end
end