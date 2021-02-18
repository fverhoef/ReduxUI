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

    for i, button in next, frame.buttons do
        local parent = frame
        local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}

        if i == 7 then
            parent = frame.buttons[1]
            point = {"TOPLEFT", parent, "BOTTOMLEFT", 0, -10}
        elseif i > 1 then
            parent = frame.buttons[i - 1]
            point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
        end

        AB:SetupButton(button, frame, 36, 36, point)
    end

    frame:SetAttribute("actionpage", 5) -- 5 = MultiBarBottomRight

    frame:CreateFader(config.fader, frame.buttons)
    R:CreateDragFrame(frame, "Action Bar 3", default.point)

    return frame
end

function AB:UpdateMultiBarBottomRight()
    local config = AB.config.multiBarBottomRight
    local leftBarConfig = AB.config.multiBarBottomLeft
    local frame = AB.bars.MultiBarBottomRight

    if config.enabled then
        frame:Show()

        frame:ClearAllPoints()
        if config.detached then
            frame:Point(config.point)
        else
            if config.attachedPoint == AB.ATTACHMENT_POINTS.Center then
                frame:SetSize(506, 36)
                frame:Point("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 0,
                            -5 + (leftBarConfig.enabled and not leftBarConfig.detached and 40 or 0))
            elseif config.attachedPoint == AB.ATTACHMENT_POINTS.Right then
                frame:SetSize(253, 72)
                frame:Point("BOTTOMRIGHT", AB.bars.MainMenuBar, "TOPRIGHT", -10, -5)
            end
        end

        local buttonsPerRow = config.detached and config.buttonsPerRow or
                                  (config.attachedPoint == AB.ATTACHMENT_POINTS.Center and 12 or 6)
        for i, button in next, frame.buttons do
            local parent = frame

            local point
            if i == 1 then
                point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}
            elseif (i - 1) % buttonsPerRow == 0 then
                parent = frame.buttons[1]
                point = {"TOPLEFT", parent, "BOTTOMLEFT", 0, -10}
            else
                parent = frame.buttons[i - 1]
                point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
            end

            AB:SetupButton(button, frame, 36, 36, point)
        end
    else
        frame:Hide()
    end

    AB:UpdateExperienceBarTextures()
    AB:UpdateMaxLevelBarTextures()
    AB:UpdateReputationBarTextures()
end
