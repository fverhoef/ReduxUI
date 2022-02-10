local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupMainMenuBar()
    MainMenuBar:ChangeMenuBarSizeAndPosition(false)
    AB:SecureHook(MainMenuBar, "ChangeMenuBarSizeAndPosition", AB.ChangeMenuBarSizeAndPosition)
end

function AB:UpdateMainMenuBar()
end

AB.ChangeMenuBarSizeAndPosition = function(rightMultiBarShowing)
    if not AB.config.mainMenuBar.stackBottomBars then return end

    local atlasInfo = C_Texture.GetAtlasInfo("hud-MainMenuBar-small")

    local width = atlasInfo and atlasInfo.width or 0
    local height = atlasInfo and atlasInfo.height or 0
    MainMenuBar:SetSize(width, height)
    MainMenuBarArtFrame:SetSize(width, height)
    MainMenuBarArtFrameBackground:SetSize(width, height)
    MainMenuBarArtFrameBackground.BackgroundLarge:SetShown(false)
    MainMenuBarArtFrameBackground.BackgroundSmall:SetShown(true)
    MainMenuBarArtFrame.PageNumber:ClearAllPoints()
    MainMenuBarArtFrame.PageNumber:SetPoint("RIGHT", MainMenuBarArtFrameBackground, "RIGHT", -6, -3)

    StatusTrackingBarManager:SetBarSize(false)
end