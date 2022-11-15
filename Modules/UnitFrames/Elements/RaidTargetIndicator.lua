local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateRaidTargetIndicator()
    self.RaidTargetHolder = CreateFrame("Frame", "$parentRaidTargetIconHolder", self)
    self.RaidTargetHolder:SetAllPoints(self.Overlay)
    self.RaidTargetHolder:SetParent(self.Overlay)
    self.RaidTargetHolder:SetFrameLevel(self.Overlay:GetFrameLevel() + 2)
    
    self.RaidTargetIndicator = self.RaidTargetHolder:CreateTexture("$parentRaidTargetIcon", "OVERLAY")
    self.RaidTargetIndicator:SetSize(24, 24)

    return self.RaidTargetIndicator
end

oUF:RegisterMetaFunction("CreateRaidTargetIndicator", UF.CreateRaidTargetIndicator)

function UF:ConfigureRaidTargetIndicator()
    local config = self.config.raidTargetIndicator
    if not config.enabled then
        self:DisableElement("RaidTargetIndicator")
        return
    elseif not self.RaidTargetIndicator then
        self:CreateRaidTargetIndicator()
    end

    self:EnableElement("RaidTargetIndicator")

    self.RaidTargetIndicator:SetSize(unpack(config.size))
    self.RaidTargetIndicator:ClearAllPoints()
    self.RaidTargetIndicator:SetNormalizedPoint(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureRaidTargetIndicator", UF.ConfigureRaidTargetIndicator)
