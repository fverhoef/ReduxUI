local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

local L = R.L

function S:StyleWatchFrame()
    if not WatchFrame or not S.config.objectiveTracker.enabled then return end

	local objectiveFrameHeight = WatchFrame:GetHeight()
    WatchFrame.config = S.config.objectiveTracker
    WatchFrame:SetMovable(true)
    WatchFrame:SetUserPlaced(true)
    WatchFrame:ClearAllPoints()
    WatchFrame:SetNormalizedPoint(unpack(WatchFrame.config.point))
    WatchFrame:CreateMover(L["Objective Tracker"], WatchFrame.config.point)
    R:SecureHook(WatchFrame, "SetPoint", function(self, point, anchor, relativePoint, x, y)
        if point ~= self.config.point[1] or anchor ~= self.config.point[2] or relativePoint ~= self.config.point[3] then
            self:ClearAllPoints()
            self:SetNormalizedPoint(self.config.point)
        end
    end)
	WatchFrame:SetClampedToScreen(false)
	WatchFrame:SetHeight(objectiveFrameHeight)
end

function S:StyleQuestWatchFrame()
    if not QuestWatchFrame or not S.config.objectiveTracker.enabled then return end

    QuestWatchFrame.config = S.config.objectiveTracker
    QuestWatchFrame:SetMovable(true)
    QuestWatchFrame:SetUserPlaced(true)
    QuestWatchFrame:ClearAllPoints()
    QuestWatchFrame:SetNormalizedPoint(unpack(QuestWatchFrame.config.point))
    QuestWatchFrame:CreateMover(L["Objective Tracker"], QuestWatchFrame.config.point)
    R:SecureHook(QuestWatchFrame, "SetPoint", function(self, point, anchor, relativePoint, x, y)
        if point ~= self.config.point[1] or anchor ~= self.config.point[2] or relativePoint ~= self.config.point[3] then
            self:ClearAllPoints()
            self:SetNormalizedPoint(self.config.point)
        end
    end)
end

function S:StyleObjectiveTrackerFrame()
    if not ObjectiveTrackerFrame or not S.config.objectiveTracker.enabled then return end

	local objectiveFrameHeight = ObjectiveTrackerFrame:GetHeight()
    ObjectiveTrackerFrame.config = S.config.objectiveTracker
	ObjectiveTrackerFrame:SetClampedToScreen(false)
    ObjectiveTrackerFrame:ClearAllPoints()
    ObjectiveTrackerFrame:SetNormalizedPoint(unpack(ObjectiveTrackerFrame.config.point))
    ObjectiveTrackerFrame:SetMovable(true)
    ObjectiveTrackerFrame:SetUserPlaced(true)
	ObjectiveTrackerFrame:SetHeight(objectiveFrameHeight)
    ObjectiveTrackerFrame:CreateMover("Objective Tracker", ObjectiveTrackerFrame.config.point)
end
