local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleObjectiveTrackerFrame()
    if not ObjectiveTrackerFrame or not S.config.objectiveTracker.enabled then return end

    ObjectiveTrackerFrame.config = S.config.objectiveTracker
    ObjectiveTrackerFrame:SetMovable(true)
    ObjectiveTrackerFrame:SetUserPlaced(true)
    ObjectiveTrackerFrame:ClearAllPoints()
    ObjectiveTrackerFrame:SetNormalizedPoint(unpack(ObjectiveTrackerFrame.config.point))
    ObjectiveTrackerFrame:CreateMover("Objective Tracker", ObjectiveTrackerFrame.config.point)
end