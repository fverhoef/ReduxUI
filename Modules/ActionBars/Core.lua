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

    AB.bars = {}
    for i = 1, 10 do
        AB.bars[i] = AB:CreateActionBar(i, AB.config["actionBar" .. i])
    end

    AB.experienceBar = AB:CreateExperienceBar()
    AB.statusTrackingBar = AB:CreateStatusTrackingBar()

    AB:CreateModernArt()

    AB.pageUpButton = AB:CreatePageUpButton(AB.bars[1])
    AB.pageDownButton = AB:CreatePageDownButton(AB.bars[1])
    AB.pageNumber = AB:CreatePageNumber()

    AB.petBar = AB:CreatePetBar()
    AB.stanceBar = AB:CreateStanceBar()
    AB.totemBar = AB:CreateTotemBar()
    AB.vehicleExitBar = AB:CreateVehicleExitBar()
    AB.extraActionBar = AB:CreateExtraActionBar()
    AB.zoneBar = AB:CreateZoneBar()

    if AB.config.actionBar1.vanillaArt.enabled then
        AB:CreateVanillaArtFrame()
    end
    AB:CreateMicroButtonAndBagsBar()

    AB:ReassignBindings()
    AB:Update()

    AB:RegisterEvent("ACTIONBAR_PAGE_CHANGED", AB.UpdatePageNumber)
    AB:RegisterEvent("PET_BATTLE_CLOSE", AB.ReassignBindings)
    AB:RegisterEvent("PET_BATTLE_OPENING_DONE", AB.ClearBindings)
    AB:RegisterEvent("UPDATE_BINDINGS", AB.ReassignBindings)

    if not R.isRetail then
        AB:SecureHook("MainMenuBar_UpdateExperienceBars", AB.UpdateExperienceBars)
    end
end

function AB:Update()
    if AB.config.actionBar1.vanillaArt.enabled and not AB.VanillaArtFrame then
        AB:CreateVanillaArtFrame()
    end
    for _, bar in ipairs(AB.bars) do
        bar:Configure()
    end

    AB:UpdateAllowedPages()

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

    AB.bars[1].ArtLeft:SetShown(AB.bars[1].config.modernArt.enabled)
    AB.bars[1].ArtRight:SetShown(AB.bars[1].config.modernArt.enabled)

    AB.pageUpButton:ClearAllPoints()
    AB.pageUpButton:SetPoint("RIGHT", AB.bars[1], "LEFT", -5, 10)
    AB.pageUpButton.style = AB.config.actionBar1.pageButtonStyle
    AB.pageUpButton:Update()

    AB.pageDownButton:ClearAllPoints()
    AB.pageDownButton:SetPoint("RIGHT", AB.bars[1], "LEFT", -5, -10)
    AB.pageDownButton.style = AB.config.actionBar1.pageButtonStyle
    AB.pageDownButton:Update()

    AB.pageNumber:ClearAllPoints()
    AB.pageNumber:SetPoint("RIGHT", AB.bars[1], "LEFT", -2, 0)
    AB.pageNumber:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
    AB.pageNumber:SetTextColor(1, 1, 1)

    AB:UpdateExperienceBars()

    if AB.VanillaArtFrame then
        AB.VanillaArtFrame:Update()
    end
end

function AB:UpdateExperienceBars()
    AB.experienceBar:Update()
    AB.statusTrackingBar:Update()

    if AB.VanillaArtFrame then
        AB.VanillaArtFrame:Update()
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
    R:Disable(MultiBar5)
    R:Disable(MultiBar6)
    R:Disable(MultiBar7)
    R:Disable(PetActionBarFrame or PetActionBar)
    R:Disable(PossessBarFrame or PossessBar)
    R:Disable(StanceBarFrame or StanceBar)
    R:Disable(MainMenuBarVehicleLeaveButton)
    R:Disable(VerticalMultiBarsContainer)
    
    ActionBarActionEventsFrame:UnregisterAllEvents()
    ActionBarButtonEventsFrame:UnregisterAllEvents()
    if R.isRetail then
        PetActionBar.UpdateGridLayout = nop
        StatusTrackingBarManager:UnregisterAllEvents()
        ActionBarController:RegisterEvent("SETTINGS_LOADED")
        ActionBarController:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
    else
        ActionBarController:UnregisterAllEvents()
    end
end

function AB:ReassignBindings()
    if InCombatLockdown() then
        return
    end
    for _, bar in ipairs(AB.bars) do
        ClearOverrideBindings(bar)

        for i, button in next, bar.buttons do
            for _, key in next, { GetBindingKey(bar.config.buttonType .. i) } do
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
