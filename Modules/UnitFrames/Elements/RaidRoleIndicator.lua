local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateRaidRoleIndicator()
    if not self.config.raidRoleIndicator.enabled then return end

    self.RaidRoleIndicator = self:CreateTexture(nil, "OVERLAY")
    self.RaidRoleIndicator:SetParent(self.Overlay)
    self.RaidRoleIndicator:SetSize(14, 14)

    return self.RaidRoleIndicator
end

oUF:RegisterMetaFunction("CreateRaidRoleIndicator", UF.CreateRaidRoleIndicator)

function UF:ConfigureRaidRoleIndicator()
    local config = self.config.raidRoleIndicator
    if not config.enabled then
        self:DisableElement("RaidRoleIndicator")
        return
    elseif not self.RaidRoleIndicator then
        self:CreateRaidRoleIndicator()
    end

    self:EnableElement("RaidRoleIndicator")

    self.RaidRoleIndicator:SetSize(unpack(config.size))
    self.RaidRoleIndicator:ClearAllPoints()
    R:SetPoint(self.RaidRoleIndicator, unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureRaidRoleIndicator", UF.ConfigureRaidRoleIndicator)
