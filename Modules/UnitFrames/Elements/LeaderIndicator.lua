local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateLeaderIndicator = function(self)
    self.LeaderIndicatorParent = CreateFrame("Frame", nil, self)
    self.LeaderIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.LeaderIndicator = self.LeaderIndicatorParent:CreateTexture("$parentLeaderIcon", "OVERLAY")
    self.LeaderIndicator:SetSize(16, 16)

    return self.LeaderIndicator
end