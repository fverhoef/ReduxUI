local addonName, ns = ...
local R = _G.ReduxUI
local AB = R:AddModule("ActionBars", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local L = R.L

function AB:Initialize()
end

function AB:Enable()
    if not AB.config.enabled then
        return
    end

    AB:DisableBlizzardBars()
    if AB.config.mainMenuBarArt.enabled then
        AB:CreateMainMenuBarArtFrame()
    end
    AB:CreateMicroButtonAndBagsBar()

    AB.bars = {}
    for i = 1, 10 do
        AB.bars[i] = AB:CreateActionBar(i, AB.config["actionBar" .. i])
    end

    AB.petBar = AB:CreatePetBar()
    AB.stanceBar = AB:CreateStanceBar()
    AB.totemBar = AB:CreateTotemBar()
    AB.vehicleExitBar = AB:CreateVehicleExitBar()
    AB.extraActionBar = AB:CreateExtraActionBar()
    AB.zoneBar = AB:CreateZoneBar()

    -- AB.experienceBar = AB:CreateExperienceBar()
    -- AB.reputationBar = AB:CreateReputationBar()

    AB:ReassignBindings()
    AB:Update()

    AB:RegisterEvent("PET_BATTLE_CLOSE", AB.ReassignBindings)
    AB:RegisterEvent("PET_BATTLE_OPENING_DONE", AB.ClearBindings)
    AB:RegisterEvent("UPDATE_BINDINGS", AB.ReassignBindings)
end

function AB:Update()
    if AB.config.mainMenuBarArt.enabled and not AB.MainMenuBarArtFrame then
        AB:CreateMainMenuBarArtFrame()
    end
    if AB.MainMenuBarArtFrame then
        AB.MainMenuBarArtFrame:Update()
    end
    for _, bar in ipairs(AB.bars) do
        bar:Configure()
    end

    AB.petBar:Configure()
    AB.stanceBar:Configure()
    if AB.totemBar then
        AB.totemBar:Configure()
    end
    AB.vehicleExitBar:Configure()
    if AB.extraActionBar then
        AB.extraActionBar:Configure()
    end
    if AB.zoneBar then
        AB.zoneBar:Configure()
    end

    if AB.config.mainMenuBarArt.enabled then
        for i, button in ipairs(AB.bars[1].buttons) do
            button:SetSize(36, 36)
            button:ClearAllPoints()
            if i == 1 then
                button:SetPoint("BOTTOMLEFT", AB.MainMenuBarArtFrame, "BOTTOMLEFT", 8, 4)
            else
                button:SetPoint("LEFT", AB.bars[1].buttons[i - 1], "RIGHT", 6, 0)
            end
        end
        AB.bars[1].Backdrop:SetShown(false)
        AB.bars[1].Border:SetShown(false)
        AB.bars[1].Shadow:SetShown(false)
        AB.bars[1].Mover:Lock(true)

        for i, button in ipairs(AB.bars[2].buttons) do
            button:SetSize(36, 36)
            button:ClearAllPoints()
            if i == 1 then
                button:SetPoint("BOTTOMLEFT", AB.bars[1].buttons[1], "TOPLEFT", 0, 10)
            else
                button:SetPoint("LEFT", AB.bars[2].buttons[i - 1], "RIGHT", 6, 0)
            end
        end
        AB.bars[2].Backdrop:SetShown(false)
        AB.bars[2].Border:SetShown(false)
        AB.bars[2].Shadow:SetShown(false)
        AB.bars[2].Mover:Lock(true)

        for i, button in ipairs(AB.bars[3].buttons) do
            button:SetSize(36, 36)
            button:ClearAllPoints()

            if AB.config.mainMenuBarArt.stackBottomBars then
                if i == 1 then
                    button:SetPoint("BOTTOMLEFT", AB.bars[2].buttons[1], "TOPLEFT", 0, 5)
                else
                    button:SetPoint("LEFT", AB.bars[3].buttons[i - 1], "RIGHT", 6, 0)
                end
            else
                if i == 1 then
                    button:SetPoint("BOTTOMLEFT", AB.bars[1].buttons[12], "BOTTOMRIGHT", 45, 0)
                elseif i == 7 then
                    button:SetPoint("BOTTOMLEFT", AB.bars[3].buttons[1], "TOPLEFT", 0, 10)
                else
                    button:SetPoint("LEFT", AB.bars[3].buttons[i - 1], "RIGHT", 6, 0)
                end
            end
        end
        AB.bars[3].Backdrop:SetShown(false)
        AB.bars[3].Border:SetShown(false)
        AB.bars[3].Shadow:SetShown(false)
        AB.bars[3].Mover:Lock(true)

        for i, button in ipairs(AB.petBar.buttons) do
            button:SetSize(32, 32)
            button:ClearAllPoints()

            if i == 1 then
                button:SetPoint("BOTTOMLEFT", AB.config.mainMenuBarArt.stackBottomBars and AB.bars[3].buttons[1] or AB.bars[2].buttons[1], "TOPLEFT", 18, 5)
            else
                button:SetPoint("LEFT", AB.petBar.buttons[i - 1], "RIGHT", 6, 0)
            end
        end
        AB.petBar.Backdrop:SetShown(false)
        AB.petBar.Border:SetShown(false)
        AB.petBar.Shadow:SetShown(false)
        AB.petBar.Mover:Lock(true)

        for i, button in ipairs(AB.stanceBar.buttons) do
            button:SetSize(32, 32)
            button:ClearAllPoints()

            if i == 1 then
                button:SetPoint("BOTTOMLEFT", AB.config.mainMenuBarArt.stackBottomBars and AB.bars[3].buttons[1] or AB.bars[2].buttons[1], "TOPLEFT", 18, 5)
            else
                button:SetPoint("LEFT", AB.stanceBar.buttons[i - 1], "RIGHT", 6, 0)
            end
        end
        AB.stanceBar.Backdrop:SetShown(false)
        AB.stanceBar.Border:SetShown(false)
        AB.stanceBar.Shadow:SetShown(false)
        AB.stanceBar.Mover:Lock(true)

        if AB.totemBar then
            AB.totemBar:ClearAllPoints()
            AB.totemBar:SetPoint("BOTTOMLEFT", AB.config.mainMenuBarArt.stackBottomBars and AB.bars[3].buttons[1] or AB.bars[2].buttons[1], "TOPLEFT", 18, 5)
            AB.totemBar.Backdrop:SetShown(false)
            AB.totemBar.Border:SetShown(false)
            AB.totemBar.Shadow:SetShown(false)
            AB.totemBar.Mover:Lock(true)
        end
    end
end

function AB:DisableBlizzardBars()
    R:Disable(MainMenuBarArtFrame, true)
    R:Disable(MainMenuBarArtFrameBackground)
    R:Disable(MainMenuBar)
    R:Disable(MultiBarBottomLeft)
    R:Disable(MultiBarBottomRight)
    R:Disable(MultiBarLeft)
    R:Disable(MultiBarRight)
    R:Disable(PetActionBarFrame)
    R:Disable(PossessBarFrame)
    R:Disable(StanceBarFrame)
    R:Disable(MainMenuBarVehicleLeaveButton)
    R:Disable(VerticalMultiBarsContainer)

    ActionBarActionEventsFrame:UnregisterAllEvents()
    ActionBarController:UnregisterAllEvents()

    if R.isRetail then
        ActionBarController:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
    end
end

function AB:ReassignBindings()
    if InCombatLockdown() then
        return
    end
    for _, bar in ipairs(AB.bars) do
        ClearOverrideBindings(bar)

        for i, button in next, bar.buttons do
            for _, key in next, { GetBindingKey(bar.config.keyBoundTarget .. i) } do
                if key and key ~= "" then
                    SetOverrideBindingClick(bar, false, key, button:GetName())
                end
            end
        end
    end
end

function AB:ClearBindings()
    if InCombatLockdown() then
        return
    end
    for _, bar in ipairs(AB.bars) do
        ClearOverrideBindings(bar)
    end
end
