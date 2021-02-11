local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateRaidRoleIndicator = function(self)
    self.RaidRoleIndicatorParent = CreateFrame("Frame", nil, self)
    self.RaidRoleIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.RaidRoleIndicator = self.RaidRoleIndicatorParent:CreateTexture(nil, "OVERLAY")
    self.RaidRoleIndicator:SetSize(14, 14)
    self.RaidRoleIndicator:SetPoint("CENTER")

    return self.RaidRoleIndicator
end

oUF:RegisterMetaFunction("CreateRaidRoleIndicator", UF.CreateRaidRoleIndicator)

UF.UpdateRaidRoleIndicator = function(self)
    if not self.RaidRoleIndicator then
        return
    end

    local cfg = self.cfg.raidRoleIndicator
    if cfg.enabled then
        self:EnableElement("RaidRoleIndicator")
    else
        self:DisableElement("RaidRoleIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateRaidRoleIndicator", UF.UpdateRaidRoleIndicator)
