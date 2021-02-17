local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMultiBarRight()
    local config = AB.config.multiBarRight
    local default = AB.defaults.multiBarRight

    local framesToHide = {_G.MultiBarRight}
    local framesToDisable = {_G.MultiBarRight}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "MultiBarRight", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(36, 498)
    frame:SetPoint("RIGHT", UIParent, "RIGHT", 0, 0)

    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarRightButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"TOPLEFT", frame, "TOPLEFT", 0, 0}

        if i > 1 then
            parent = buttonList[i - 1]
            point = {"TOPLEFT", parent, "BOTTOMLEFT", 0, -2}
        end

        AB:SetupButton(button, frame, 36, 36, point)
    end

    frame:SetAttribute("actionpage", 3) -- 3 = MultiBarRight

    frame:CreateFader(config.fader, buttonList)
    R:CreateDragFrame(frame, "Action Bar 4", default.point)

    return frame
end

function AB:UpdateMultiBarRight()
    local config = AB.config.multiBarRight

    if config.enabled then
        AB.bars.MultiBarRight:Show()
    else
        AB.bars.MultiBarRight:Hide()
    end
end