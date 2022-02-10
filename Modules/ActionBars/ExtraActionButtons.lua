local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupExtraActionButtons()
    if not ExtraActionBarFrame then return end
    ExtraActionBarFrame.config = AB.config.extraActionButton
    R:CreateDragFrame(ExtraActionBarFrame, L["Extra Action Button"], AB.defaults.extraActionButton.point)
end

function AB:UpdateExtraActionButtons()
end