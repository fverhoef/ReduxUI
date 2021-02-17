local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMultiBarBottomRight()
    local config = AB.config.multiBarBottomRight
    local default = AB.defaults.multiBarBottomRight

    local framesToHide = {_G.MultiBarBottomRight}
    local framesToDisable = {_G.MultiBarBottomRight}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "MultiBarBottomRight", AB.bars.MainMenuBar, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(506, 36)
    frame:SetPoint("BOTTOMLEFT", AB.bars.MultiBarBottomLeft, "BOTTOMRIGHT", 38, 0)

    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarBottomRightButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}

        if i == 7 then
            parent = buttonList[1]
            point = {"TOPLEFT", parent, "BOTTOMLEFT", 0, -10}
        elseif i > 1 then
            parent = buttonList[i - 1]
            point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
        end

        AB:SetupButton(button, frame, 36, 36, point)
    end

    frame:SetAttribute("actionpage", 5) -- 5 = MultiBarBottomRight

    frame:CreateFader(config.fader, buttonList)
    R:CreateDragFrame(frame, "Action Bar 3", default.point)

    return frame
end

function AB:UpdateMultiBarBottomRight()
    local config = AB.config.multiBarBottomRight

    if config.enabled then
        AB.bars.MultiBarBottomRight:Show()
    else
        AB.bars.MultiBarBottomRight:Hide()
    end

    AB:UpdateExperienceBarTextures()
    AB:UpdateMaxLevelBarTextures()
    AB:UpdateReputationBarTextures()
end
