local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupMultiBarBottomRight()
    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarBottomRightButton" .. i]
        if not button then break end

        table.insert(buttonList, button)
    end
    MultiBarBottomRight.config = AB.config.multiBarBottomRight
    MultiBarBottomRight:CreateFader(AB.config.multiBarBottomRight.fader, buttonList)
    -- R:CreateDragFrame(MultiBarBottomRight, L["Bottom Action Bar 1"], AB.defaults.multiBarBottomRight.point)
end

function AB:UpdateMultiBarBottomRight()
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local rightButton = _G["MultiBarBottomRightButton" .. i]
        rightButton:ClearAllPoints()
        if AB.config.mainMenuBar.stackBottomBars then
            if MultiBarBottomLeft:IsShown() then
                rightButton:SetPoint("BOTTOM", _G["MultiBarBottomLeftButton" .. i], "TOP", 0, 5)
            else
                rightButton:SetPoint("BOTTOM", _G["ActionButton" .. i], "TOP", 0, 12)
            end
        else
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

    if R.isRetail then MainMenuBar:ChangeMenuBarSizeAndPosition(not AB.config.mainMenuBar.stackBottomBars and SHOW_MULTI_ACTIONBAR_2 and IsNormalActionBarState()) end

    if AB.config.mainMenuBar.stackBottomBars and (MultiBarBottomLeft:IsShown() or MultiBarBottomRight:IsShown()) then
        UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"]["yOffset"] = 41
        UIPARENT_MANAGED_FRAME_POSITIONS["PETACTIONBAR_YPOS"]["baseY"] = 89 + 41
        UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"]["yOffset"] = 41
    else
        UIPARENT_MANAGED_FRAME_POSITIONS["PETACTIONBAR_YPOS"]["baseY"] = 89
        UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"]["yOffset"] = nil
    end
    UIParent_ManageFramePositions()
end
