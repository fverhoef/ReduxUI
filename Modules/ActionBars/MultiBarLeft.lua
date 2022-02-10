local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupMultiBarLeft()
    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarLeftButton" .. i]
        if not button then break end

        table.insert(buttonList, button)
    end
    MultiBarLeft.config = AB.config.multiBarLeft
    MultiBarLeft:CreateFader(AB.config.multiBarLeft.fader, buttonList)
    R:CreateDragFrame(MultiBarLeft, L["Right Action Bar 2"], AB.defaults.multiBarLeft.point)
end

function AB:UpdateMultiBarLeft()
end