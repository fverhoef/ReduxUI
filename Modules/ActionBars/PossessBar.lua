local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupPossessBar()
    local config = AB.config.possessBar

    local buttonList = {}
    for i = 1, _G.NUM_POSSESS_SLOTS do
        local button = _G["PossessButton" .. i]
        if not button then break end

        table.insert(buttonList, button)
    end
    PossessBarFrame.config = AB.config.possessBar
    PossessBarFrame:CreateFader(AB.config.possessBar.fader, buttonList)
    --R:CreateDragFrame(PossessBarFrame, L["Possess Bar"], AB.defaults.possessBar.point)
end

function AB:UpdatePossessBar()
end
