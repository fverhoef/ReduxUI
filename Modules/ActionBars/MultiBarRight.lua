local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMultiBarRight()
    local config = AB.config.multiBarRight
    local default = AB.defaults.multiBarRight

    local framesToHide = {_G.MultiBarRight}
    local framesToDisable = {_G.MultiBarRight}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    local frame = CreateFrame("Frame", addonName .. "MultiBarRight", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(36, 498)
    frame:SetPoint("RIGHT", UIParent, "RIGHT", 0, 0)
    frame.buttons = {}

    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarRightButton" .. i]
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

    frame:SetAttribute("actionpage", 3) -- 3 = MultiBarRight

    frame:CreateFader(config.fader, frame.buttons)
    R:CreateDragFrame(frame, "Action Bar 4", default.point)

    return frame
end

function AB:UpdateMultiBarRight()
    local config = AB.config.multiBarRight
    local frame = AB.bars.MultiBarRight

    if config.enabled then
        frame:Show()

        frame:ClearAllPoints()
        frame:Point(config.point)

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
