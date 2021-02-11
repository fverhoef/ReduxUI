local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

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

oUF:RegisterMetaFunction("CreateRaidTargetIndicator", UF.CreateRaidTargetIndicator)

UF.UpdateRaidTargetIndicator = function(self)
    if not self.RaidTargetIndicator then
        return
    end

    local cfg = self.cfg.raidTargetIndicator
    if cfg.enabled then
        self:EnableElement("RaidTargetIndicator")
    else
        self:DisableElement("RaidTargetIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateRaidTargetIndicator", UF.UpdateRaidTargetIndicator)
