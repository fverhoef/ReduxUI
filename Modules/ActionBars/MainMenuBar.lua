local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupMainMenuBar()
    if R.isRetail then
        MainMenuBar:ChangeMenuBarSizeAndPosition(false)
        AB:SecureHook(MainMenuBar, "ChangeMenuBarSizeAndPosition", AB.ChangeMenuBarSizeAndPosition)
    else
        MainMenuBarTexture0:Hide()
        MainMenuBarTexture1:Hide()
        MainMenuBarTexture2:Hide()
        MainMenuBarTexture3:Hide()

        MainMenuBarArtFrame:ClearAllPoints()
        MainMenuBarArtFrame:SetPoint("TOPLEFT", 0, 10)
        MainMenuBarArtFrame:SetPoint("BOTTOMRIGHT", 0, 10)
        MainMenuBarArtFrame.Background = CreateFrame("Frame", "$parentBackground", MainMenuBarArtFrame, "MainMenuBarArtFrameBackgroundTemplate")
        MainMenuBarArtFrame.LeftEndCap = MainMenuBarLeftEndCap
        MainMenuBarArtFrame.LeftEndCap:ClearAllPoints()
        MainMenuBarArtFrame.LeftEndCap:SetPoint("BOTTOMLEFT", -98, -10)
        MainMenuBarArtFrame.RightEndCap = MainMenuBarRightEndCap
        MainMenuBarArtFrame.RightEndCap:ClearAllPoints()
        MainMenuBarArtFrame.RightEndCap:SetPoint("BOTTOMRIGHT", 98, -10)

        MainMenuBarPerformanceBarFrame:Hide()

        ActionButton1:ClearAllPoints()
        ActionButton1:SetPoint("BOTTOMLEFT", MainMenuBarArtFrameBackground, "BOTTOMLEFT", 8, 4)

        ActionBarUpButton:ClearAllPoints()
        ActionBarUpButton:SetPoint("RIGHT", ActionButton12, "RIGHT", 31, 7)
        ActionBarDownButton:ClearAllPoints()
        ActionBarDownButton:SetPoint("TOP", ActionBarUpButton, "BOTTOM", 0, 15)

        MultiBarBottomLeft:ClearAllPoints()
        MultiBarBottomLeft:SetPoint("TOP", MainMenuBarArtFrame, "TOP", 0, 16)

        MultiBarBottomRight:ClearAllPoints()
        MultiBarBottomRight:SetPoint("TOPLEFT", ActionButton12, "TOPRIGHT", 45, 2)

        MainMenuBarExpText:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        ReputationWatchBar.OverlayFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        
        AB:CreateTrackingBarTextures()

        AB:UpdateMainMenuBar()
        AB:SecureHook("MainMenuBar_UpdateExperienceBars", AB.UpdateMainMenuBar)
    end
end

function AB:UpdateMainMenuBar()
    AB:UpdateMainMenuBarArt()
    AB:UpdateTrackingBarPositions()
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

function AB:UpdateMainMenuBarArt()
    if R.isRetail then return end

    local isLarge = not AB.config.mainMenuBar.stackBottomBars and (MultiBarBottomRight:IsShown())

    local width = isLarge and 804 or 550
    local height = 49

    MainMenuBar:SetSize(width, height)
    MainMenuBarArtFrame:SetSize(width, height)
    MainMenuBarArtFrameBackground:SetSize(width, height)

    MainMenuBarArtFrameBackground.BackgroundLarge:SetShown(isLarge)
    MainMenuBarArtFrameBackground.BackgroundSmall:SetShown(not isLarge)

    MainMenuBarArtFrame.PageNumber = MainMenuBarPageNumber
    MainMenuBarArtFrame.PageNumber:ClearAllPoints()
    if isLarge then
        MainMenuBarArtFrame.PageNumber:SetPoint("CENTER", MainMenuBarArtFrameBackground, "CENTER", 138, -3)
    else
        MainMenuBarArtFrame.PageNumber:SetPoint("RIGHT", MainMenuBarArtFrameBackground, "RIGHT", -6, -3)
    end

    local numBars = (MainMenuExpBar:IsShown() and 1 or 0) + (ReputationWatchBar:IsShown() and 1 or 0)
    MainMenuBar:ClearAllPoints()
    MainMenuBarArtFrame.LeftEndCap:ClearAllPoints()
    MainMenuBarArtFrame.RightEndCap:ClearAllPoints()
    if numBars >= 2 then
        MainMenuBar:SetPoint("BOTTOM", UIParent, 0, 19)
        MainMenuBarArtFrame.LeftEndCap:SetPoint("BOTTOMLEFT", MainMenuBar, -97, -19)
        MainMenuBarArtFrame.RightEndCap:SetPoint("BOTTOMRIGHT", MainMenuBar, 97, -19)
    elseif numBars == 1 then
        MainMenuBar:SetPoint("BOTTOM", UIParent, 0, 14)
        MainMenuBarArtFrame.LeftEndCap:SetPoint("BOTTOMLEFT", MainMenuBar, -97, -14)
        MainMenuBarArtFrame.RightEndCap:SetPoint("BOTTOMRIGHT", MainMenuBar, 97, -14)
    else
        MainMenuBar:SetPoint("BOTTOM", UIParent, 0, 0)
        MainMenuBarArtFrame.LeftEndCap:SetPoint("BOTTOMLEFT", MainMenuBar, -97, 0)
        MainMenuBarArtFrame.RightEndCap:SetPoint("BOTTOMRIGHT", MainMenuBar, 97, 0)
    end

    local isDouble = numBars >= 2
    MainMenuBar.SingleBarLarge:SetHeight(isDouble and 10 or 14)
    MainMenuBar.SingleBarLarge:SetShown(numBars > 0 and isLarge)
    MainMenuBar.SingleBarLarge:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
    MainMenuBar.SingleBarLargeUpper:SetHeight(isDouble and 10 or 14)
    MainMenuBar.SingleBarLargeUpper:SetShown(numBars > 0 and isDouble and isLarge)
    MainMenuBar.SingleBarSmall:SetShown(numBars > 0 and not isLarge)
    MainMenuBar.SingleBarSmall:SetHeight(isDouble and 10 or 14)
    MainMenuBar.SingleBarSmall:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
    MainMenuBar.SingleBarSmallUpper:SetShown(numBars > 0 and isDouble and not isLarge)
    MainMenuBar.SingleBarSmallUpper:SetHeight(isDouble and 10 or 14)
    
	ReputationWatchBar.OverlayFrame.Text:SetPoint("CENTER", ReputationWatchBar.OverlayFrame, "CENTER", 0, 0)
end

function AB:UpdateTrackingBarPositions()
    if R.isRetail then return end

    MainMenuExpBar:ClearAllPoints()
    ReputationWatchBar:ClearAllPoints()
    ReputationWatchBar.StatusBar:SetAllPoints()

    local height = {11, 11}
    local yOffset = {-13, -13}
    if MainMenuExpBar:IsShown() and ReputationWatchBar:IsShown() then
        height[2] = 9
        yOffset[1] = -19
        yOffset[2] = -8
    end

    MainMenuExpBar:SetHeight(height[1])
    MainMenuExpBar:SetPoint("BOTTOMLEFT", MainMenuBar, 0, yOffset[1])
    MainMenuExpBar:SetPoint("BOTTOMRIGHT", MainMenuBar, 0, yOffset[1])

    ReputationWatchBar:SetHeight(height[2])
    ReputationWatchBar:SetPoint("BOTTOMLEFT", MainMenuBar, 0, yOffset[2])
    ReputationWatchBar:SetPoint("BOTTOMRIGHT", MainMenuBar, 0, yOffset[2])

    for i = 0, 3 do
        _G["MainMenuXPBarTexture" .. i]:Hide()
        ReputationWatchBar.StatusBar["WatchBarTexture" .. i]:Hide()
        ReputationWatchBar.StatusBar["XPBarTexture" .. i]:Hide()
    end

    MainMenuBarMaxLevelBar:Hide()
end

function AB:CreateTrackingBarTextures()
    MainMenuBar.SingleBarLarge = MainMenuBar:CreateTexture("OVERLAY")
    MainMenuBar.SingleBarLarge:SetTexture(R.media.textures.actionBars.mainMenuBar)
    MainMenuBar.SingleBarLarge:SetTexCoord(0.0820312, 0.867188, 0.00390625, 0.0585938)
    MainMenuBar.SingleBarLarge:SetSize(804, 14)

    MainMenuBar.SingleBarLargeUpper = MainMenuBar:CreateTexture("OVERLAY")
    MainMenuBar.SingleBarLargeUpper:SetTexture(R.media.textures.actionBars.mainMenuBar)
    MainMenuBar.SingleBarLargeUpper:SetTexCoord(0.0820312, 0.867188, 0.00390625, 0.0585938)
    MainMenuBar.SingleBarLargeUpper:SetSize(804, 14)
    MainMenuBar.SingleBarLargeUpper:SetPoint("TOP", MainMenuBar.SingleBarLarge, "TOP", 0, 9)

    MainMenuBar.SingleBarSmall = MainMenuBar:CreateTexture("OVERLAY")
    MainMenuBar.SingleBarSmall:SetTexture(R.media.textures.actionBars.mainMenuBar)
    MainMenuBar.SingleBarSmall:SetTexCoord(0.111328, 0.648438, 0.191406, 0.246094)
    MainMenuBar.SingleBarSmall:SetSize(550, 14)

    MainMenuBar.SingleBarSmallUpper = MainMenuBar:CreateTexture("OVERLAY")
    MainMenuBar.SingleBarSmallUpper:SetTexture(R.media.textures.actionBars.mainMenuBar)
    MainMenuBar.SingleBarSmallUpper:SetTexCoord(0.111328, 0.648438, 0.191406, 0.246094)
    MainMenuBar.SingleBarSmallUpper:SetSize(550, 14)
    MainMenuBar.SingleBarSmallUpper:SetPoint("TOP", MainMenuBar.SingleBarSmall, "TOP", 0, 9)
end
