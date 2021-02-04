local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateLeaderIndicator = function(self)
    self.LeaderIndicatorParent = CreateFrame("Frame", nil, self)
    self.LeaderIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.LeaderIndicator = self.LeaderIndicatorParent:CreateTexture("$parentLeaderIcon", "OVERLAY")
    self.LeaderIndicator:SetSize(16, 16)

    return self.LeaderIndicator
end

oUF:RegisterMetaFunction("CreateLeaderIndicator", UF.CreateLeaderIndicator)