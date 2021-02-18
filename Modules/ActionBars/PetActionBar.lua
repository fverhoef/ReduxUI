local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreatePetActionBar()
    local config = AB.config.petActionBar
    local default = AB.defaults.petActionBar

    local frame = CreateFrame("Frame", addonName .. "StanceBar", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(509, 43)
    frame:SetPoint("BOTTOMLEFT", addonName .. "MainMenuBar", "TOPLEFT", 40, 40)
    frame.__blizzardBar = _G.PetActionBarFrame
    frame.buttons = {}

    if frame.__blizzardBar then
        frame.__blizzardBar:SetParent(frame)
        frame.__blizzardBar:EnableMouse(false)
        frame.__blizzardBar:ClearAllPoints()
        frame.__blizzardBar:SetAllPoints()
    end

    for i = 1, _G.NUM_PET_ACTION_SLOTS do
        local button = _G["PetActionButton" .. i]
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

    frame:CreateFader(config.fader, frame.buttons)
    R:CreateDragFrame(frame, "Pet Action Bar", default.point)

    return frame
end

function AB:UpdatePetActionBar()
    local config = AB.config.petActionBar
    local leftConfig = AB.config.multiBarBottomLeft
    local rightConfig = AB.config.multiBarBottomRight
    local frame = AB.bars.PetActionBar

    frame.__blizzardBar:SetParent(frame)
    frame.__blizzardBar:ClearAllPoints()
    frame.__blizzardBar:SetAllPoints()

    if config.enabled then
        frame:Show()

        frame:ClearAllPoints()
        if config.detached then
            frame:Point(unpack(config.point))
        else
            local leftBarEnabledAndAttached = leftConfig.enabled and not leftConfig.detached
            local rightBarEnabledAndAttachedToCenter = rightConfig.enabled and not rightConfig.detached and
                                                           rightConfig.attachedPoint == AB.ATTACHMENT_POINTS.Center

            if leftBarEnabledAndAttached and rightBarEnabledAndAttachedToCenter then
                frame:Point("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 40, 85)
            elseif leftBarEnabledAndAttached or rightBarEnabledAndAttachedToCenter then
                frame:Point("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 40, 45)
            else
                frame:Point("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 40, 5)
            end
        end

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
