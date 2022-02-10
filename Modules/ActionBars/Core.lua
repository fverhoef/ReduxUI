local addonName, ns = ...
local R = _G.ReduxUI
local AB = R:AddModule("ActionBars", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = R.L

function AB:Initialize()
    if not AB.config.enabled then return end

    AB:SetupMainMenuBar()
    AB:SetupMicroButtonAndBagsBar()
    AB:SetupMultiBarBottomLeft()
    AB:SetupMultiBarBottomRight()
    AB:SetupMultiBarLeft()
    AB:SetupMultiBarRight()
    AB:SetupStanceBar()
    AB:SetupPetActionBar()
    AB:SetupPossessBar()
    AB:SetupExtraActionButtons()

    AB:LoadFlyoutBars()
    
    AB:Update()

    AB:SecureHook("MultiActionBar_Update", AB.Update)
    AB:SecureHook("UIParent_ManageFramePositions", AB.UIParent_ManageFramePositions)
end

function AB:Update()
    AB:UpdateMainMenuBar()
    AB:UpdateMicroButtonAndBagsBar()
    AB:UpdateMultiBarBottomLeft()
    AB:UpdateMultiBarBottomRight()
    AB:UpdateMultiBarLeft()
    AB:UpdateMultiBarRight()
    AB:UpdateStanceBar()
    AB:UpdatePetActionBar()
    AB:UpdatePossessBar()
    AB:UpdateExtraActionButtons()
    
    AB:UpdateFlyoutBars()
end

function AB:UIParent_ManageFramePositions()
    AB:UpdateStanceBarTextures()
    AB:UpdateTrackingBarPositions()
end
