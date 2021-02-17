local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMultiBarBottomLeft()
    local config = AB.config.multiBarBottomLeft
    local default = AB.defaults.multiBarBottomLeft

    local framesToHide = {_G.MultiBarBottomLeft}
    local framesToDisable = {_G.MultiBarBottomLeft}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "MultiBarBottomLeft", AB.bars.MainMenuBar, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(506, 36)
    frame:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 0, -5)

    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarBottomLeftButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}

        if i > 1 then
            parent = buttonList[i - 1]
            point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
        end

        AB:SetupButton(button, frame, 36, 36, point)
    end

    frame:SetAttribute("actionpage", 6) -- 6 = MultiBarBottomLeft

    frame:CreateFader(config.fader, buttonList)
    R:CreateDragFrame(frame, "Action Bar 2", default.point)

    return frame
end

function AB:UpdateMultiBarBottomLeft()
    local config = AB.config.multiBarBottomLeft

    if config.enabled then
        AB.bars.MultiBarBottomLeft:Show()
    else
        AB.bars.MultiBarBottomLeft:Hide()
    end
end