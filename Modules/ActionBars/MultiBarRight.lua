local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupMultiBarRight()
    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarRightButton" .. i]
        if not button then break end

        table.insert(buttonList, button)
    end
    MultiBarRight.config = AB.config.multiBarRight
    MultiBarRight:CreateFader(AB.config.multiBarRight.fader, buttonList)
    R:CreateDragFrame(MultiBarRight, L["Right Action Bar 1"], AB.defaults.multiBarRight.point)
end

function AB:UpdateMultiBarRight()
end