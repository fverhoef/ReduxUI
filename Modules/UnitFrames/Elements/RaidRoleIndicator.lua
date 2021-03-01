local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateRaidRoleIndicator()
    self.RaidRoleIndicator = self:CreateTexture(nil, "OVERLAY")
    self.RaidRoleIndicator:SetParent(self.Overlay)
    self.RaidRoleIndicator:SetSize(14, 14)

    return self.RaidRoleIndicator
end

oUF:RegisterMetaFunction("CreateRaidRoleIndicator", UF.CreateRaidRoleIndicator)

function UF:UpdateRaidRoleIndicator()
    if not self.RaidRoleIndicator then
        return
    end

    local config = self.config.raidRoleIndicator
    if config.enabled then
        self:EnableElement("RaidRoleIndicator")

        self.RaidRoleIndicator:SetSize(unpack(config.size))
        self.RaidRoleIndicator:ClearAllPoints()
        self.RaidRoleIndicator:Point(unpack(config.point))
    else
        self:DisableElement("RaidRoleIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateRaidRoleIndicator", UF.UpdateRaidRoleIndicator)
