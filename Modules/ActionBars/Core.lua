local addonName, ns = ...
local R = _G.ReduxUI
local AB = R:AddModule("ActionBars", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = R.L

function AB:Initialize()
    if not AB.config.enabled then return end

    AB:CreateMainMenuBar()
    AB:CreateMultiBarLeft()
    AB:CreateMultiBarRight()
    AB:CreateMicroButtonAndBagsBar()
    AB:MoveCharacterMicroButton()

    AB:Update()

    AB:SecureHook("MultiActionBar_Update", AB.ConfigureMultiBarBottomRight)
end

function AB:Update() AB:ConfigureMultiBarBottomRight() end

function AB:CreateMainMenuBar()
    MainMenuBar:ChangeMenuBarSizeAndPosition(false)
    AB:SecureHook(MainMenuBar, "ChangeMenuBarSizeAndPosition", AB.ChangeMenuBarSizeAndPosition)
end

AB.ChangeMenuBarSizeAndPosition = function(rightMultiBarShowing)
    if not AB.config.mainMenuBar.stackRightBar then return end

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

function AB:ConfigureMultiBarBottomRight()
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local rightButton = _G["MultiBarBottomRightButton" .. i]
        rightButton:ClearAllPoints()
        if AB.config.mainMenuBar.stackRightBar then
            rightButton.noGrid = false
            if MultiBarBottomLeft:IsShown() then
                rightButton:SetPoint("BOTTOM", _G["MultiBarBottomLeftButton" .. i], "TOP", 0, 5)
            else
                rightButton:SetPoint("BOTTOM", _G["ActionButton" .. i], "TOP", 0, 12)
            end
        else
            rightButton.noGrid = true
            if i == 1 then
                rightButton:SetPoint("BOTTOMLEFT")
            elseif i == 7 then
                rightButton:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton" .. 1], "TOPLEFT", 0, 13)
            else
                rightButton:SetPoint("LEFT", _G["MultiBarBottomRightButton" .. (i - 1)], "RIGHT", 6, 0)
            end
        end
    end
    MultiActionBar_UpdateGridVisibility()
    MainMenuBar:ChangeMenuBarSizeAndPosition(not AB.config.mainMenuBar.stackRightBar and SHOW_MULTI_ACTIONBAR_2 and IsNormalActionBarState())
end

function AB:CreateMultiBarLeft()
    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarLeftButton" .. i]
        if not button then break end

        table.insert(buttonList, button)
    end
    MultiBarLeft:CreateFader(AB.config.multiBarLeft.fader, buttonList)
    R:CreateDragFrame(MultiBarLeft, L["Right Action Bar 2"], AB.defaults.multiBarLeft.point)
end

function AB:CreateMultiBarRight()
    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarRightButton" .. i]
        if not button then break end

        table.insert(buttonList, button)
    end
    MultiBarRight:CreateFader(AB.config.multiBarRight.fader, buttonList)
    R:CreateDragFrame(MultiBarRight, L["Right Action Bar 1"], AB.defaults.multiBarRight.point)
end
