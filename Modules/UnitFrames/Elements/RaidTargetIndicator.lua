local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateRaidTargetIndicator()
    self.RaidTargetIndicator = self:CreateTexture("$parentRaidTargetIcon", "OVERLAY", nil, 7)
    self.RaidTargetIndicator:SetParent(self.Overlay)
    self.RaidTargetIndicator:SetSize(24, 24)

    return self.RaidTargetIndicator
end

oUF:RegisterMetaFunction("CreateRaidTargetIndicator", UF.CreateRaidTargetIndicator)

function UF:UpdateRaidTargetIndicator()
    if not self.RaidTargetIndicator then
        return
    end

    local config = self.config.raidTargetIndicator
    if config.enabled then
        self:EnableElement("RaidTargetIndicator")

        self.RaidTargetIndicator:SetSize(unpack(config.size))
        self.RaidTargetIndicator:ClearAllPoints()
        self.RaidTargetIndicator:Point(unpack(config.point))
    else
        self:DisableElement("RaidTargetIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateRaidTargetIndicator", UF.UpdateRaidTargetIndicator)
