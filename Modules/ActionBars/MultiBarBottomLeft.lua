local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupMultiBarBottomLeft()
    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarBottomLeftButton" .. i]
        if not button then break end

        table.insert(buttonList, button)
    end
    MultiBarBottomLeft.config = AB.config.multiBarBottomLeft
    MultiBarBottomLeft:CreateFader(AB.config.multiBarBottomLeft.fader, buttonList)
    --R:CreateDragFrame(MultiBarBottomLeft, L["Bottom Action Bar 1"], AB.defaults.multiBarBottomLeft.point)

    UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"]["watchBar"] = 0
    UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"]["baseY"] = 13
end

function AB:UpdateMultiBarBottomLeft()
end
