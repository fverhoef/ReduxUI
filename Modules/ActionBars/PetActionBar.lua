local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreatePetActionBar()
    local config = AB.config.petActionBar
    local default = AB.defaults.petActionBar

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "StanceBar", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(509, 43)
    frame:SetPoint("BOTTOMLEFT", addonName .. "MainMenuBar", "TOPLEFT", 40, 40)
    frame.__blizzardBar = _G.PetActionBarFrame

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
    for i = 1, _G.NUM_PET_ACTION_SLOTS do
        local button = _G["PetActionButton" .. i]
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

    frame:CreateFader(config.fader, buttonList)
    R:CreateDragFrame(frame, "Pet Action Bar", default.point)

    return frame
end

function AB:UpdatePetActionBar()
    local config = AB.config.petActionBar

    AB.bars.PetActionBar.__blizzardBar:SetParent(AB.bars.PetActionBar)
    AB.bars.PetActionBar.__blizzardBar:ClearAllPoints()
    AB.bars.PetActionBar.__blizzardBar:SetAllPoints()

    if config.enabled then
        AB.bars.PetActionBar:ClearAllPoints()
        AB.bars.PetActionBar:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 40, 0)
    else
        AB.bars.PetActionBar:Hide()
    end
end
