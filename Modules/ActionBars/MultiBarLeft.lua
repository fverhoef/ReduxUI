local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMultiBarLeft()
    local config = AB.config.multiBarLeft
    local default = AB.defaults.multiBarLeft

    local framesToHide = {_G.MultiBarLeft}
    local framesToDisable = {_G.MultiBarLeft}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "MultiBarLeft", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(36, 498)
    frame:SetPoint("RIGHT", addonName .. "MultiBarRight", "LEFT", -2, 0)

    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarLeftButton" .. i]
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

    frame:SetAttribute("actionpage", 4) -- 4 = MultiBarLeft

    frame:CreateFader(config.fader, buttonList)
    R:CreateDragFrame(frame, "Action Bar 5", default.point)

    return frame
end

function AB:UpdateMultiBarLeft()
    local config = AB.config.multiBarLeft

    if config.enabled then
        AB.bars.MultiBarLeft:Show()
    else
        AB.bars.MultiBarLeft:Hide()
    end
end