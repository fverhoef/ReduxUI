local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames

UF.CreateRaidTargetIndicator = function(self)
    self.RaidTargetIndicatorParent = CreateFrame("Frame", nil, self)
    self.RaidTargetIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.RaidTargetIndicator = self.RaidTargetIndicatorParent:CreateTexture("$parentRaidTargetIcon", "OVERLAY")
    if self.Portrait then
        self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP", 0, -1)
    else
        self.RaidTargetIndicator:SetPoint("RIGHT", self.Health, "LEFT", -5, 0)
    end
    self.RaidTargetIndicator:SetSize(24, 24)

    return self.RaidTargetIndicator
end
