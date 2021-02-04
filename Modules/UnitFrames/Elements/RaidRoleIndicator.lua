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
