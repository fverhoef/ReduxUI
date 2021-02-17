local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateStanceBar()
    local config = AB.config.stanceBar
    local default = AB.defaults.stanceBar

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "StanceBar", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(29, 32)
    frame:SetPoint("BOTTOMLEFT", addonName .. "MainMenuBar", "TOPLEFT", 30, 40)
    frame.__blizzardBar = _G.StanceBarFrame

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    -- reparent the Blizzard bar
    if frame.__blizzardBar then
        frame.__blizzardBar:SetParent(frame)
        frame.__blizzardBar:EnableMouse(false)
        frame.__blizzardBar:ClearAllPoints()
        frame.__blizzardBar:SetAllPoints()
    end

    local buttonList = {}
    for i = 1, _G.NUM_STANCE_SLOTS do
        local button = _G["StanceButton" .. i]
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

        AB:SetupButton(button, parent, 30, 30, point)
    end

    -- hide blizzard textures
    _G.StanceBarLeft:SetTexture(nil)
    _G.StanceBarMiddle:SetTexture(nil)
    _G.StanceBarRight:SetTexture(nil)

    frame:CreateFader(config.fader, buttonList)
    R:CreateDragFrame(frame, "Stance Bar", default.point)

    return frame
end

function AB:UpdateStanceBar()
    local config = AB.config.stanceBar

    AB.bars.StanceBar.__blizzardBar:SetParent(AB.bars.StanceBar)
    AB.bars.StanceBar.__blizzardBar:ClearAllPoints()
    AB.bars.StanceBar.__blizzardBar:SetAllPoints()
    
    if config.enabled then
        AB.bars.StanceBar:ClearAllPoints()
        AB.bars.StanceBar:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 30, 40)
    else
        AB.bars.StanceBar:Hide()
    end
end