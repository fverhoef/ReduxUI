local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleQuestWatchFrame()
    if not QuestWatchFrame or not S.config.objectiveTracker.enabled then return end

    QuestWatchFrame.config = S.config.objectiveTracker
    QuestWatchFrame:SetMovable(true)
    QuestWatchFrame:SetUserPlaced(true)
    QuestWatchFrame:ClearAllPoints()
    QuestWatchFrame:SetNormalizedPoint(unpack(QuestWatchFrame.config.point))
    QuestWatchFrame:CreateMover("Quest Watch Frame", QuestWatchFrame.config.point)
    R:SecureHook(QuestWatchFrame, "SetPoint", function(self, point, anchor, relativePoint, x, y)
        if point ~= self.config.point[1] or anchor ~= self.config.point[2] or relativePoint ~= self.config.point[3] then
            self:ClearAllPoints()
            self:SetNormalizedPoint(self.config.point)
        end
    end)
end

function S:StyleObjectiveTrackerFrame()
    if not ObjectiveTrackerFrame or not S.config.objectiveTracker.enabled then return end

    ObjectiveTrackerFrame.config = S.config.objectiveTracker
    ObjectiveTrackerFrame:SetMovable(true)
    ObjectiveTrackerFrame:SetUserPlaced(true)
    ObjectiveTrackerFrame:ClearAllPoints()
    ObjectiveTrackerFrame:SetNormalizedPoint(unpack(ObjectiveTrackerFrame.config.point))
    ObjectiveTrackerFrame:CreateMover("Objective Tracker", ObjectiveTrackerFrame.config.point)
end
