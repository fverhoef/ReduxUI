local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMultiBarLeft()
    local config = AB.config.multiBarLeft
    local default = AB.defaults.multiBarLeft

    local framesToHide = {_G.MultiBarLeft}
    local framesToDisable = {_G.MultiBarLeft}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    local frame = CreateFrame("Frame", addonName .. "MultiBarLeft", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(36, 498)
    frame:SetPoint("RIGHT", UIParent, "RIGHT", -38, 0)
    frame.buttons = {}

    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarLeftButton" .. i]
        if not button then
            break
        end
        table.insert(frame.buttons, button)
    end

    AB:SetupButtons(frame)
        
    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    frame:SetAttribute("actionpage", 4) -- 4 = MultiBarLeft

    frame:CreateFader(config.fader, frame.buttons)
    R:CreateDragFrame(frame, "Action Bar 5", default.point)

    return frame
end

function AB:UpdateMultiBarLeft()
    local config = AB.config.multiBarLeft
    local frame = AB.bars.MultiBarLeft

    if config.enabled then
        frame:Show()

        frame:ClearAllPoints()
        frame:Point(config.point)

        AB:SetupButtons(frame)

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