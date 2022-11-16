local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateGroupRoleIndicator()
    if not self.config.groupRoleIndicator.enabled then
        return
    end

    self.GroupRoleIndicator = self:CreateTexture("$parentGroupRoleIcon", "OVERLAY", nil, 7)
    self.GroupRoleIndicator:SetParent(self.Overlay)
    self.GroupRoleIndicator:SetSize(20, 20)

    return self.GroupRoleIndicator
end

oUF:RegisterMetaFunction("CreateGroupRoleIndicator", UF.CreateGroupRoleIndicator)

function UF:ConfigureGroupRoleIndicator()
    local config = self.config.groupRoleIndicator
    if not config.enabled then
        self:DisableElement("GroupRoleIndicator")
        return
    elseif not self.GroupRoleIndicator then
        self:CreateGroupRoleIndicator()
    end

    self:EnableElement("GroupRoleIndicator")

    self.GroupRoleIndicator:SetSize(unpack(config.size))
    self.GroupRoleIndicator:ClearAllPoints()
    self.GroupRoleIndicator:SetNormalizedPoint(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureGroupRoleIndicator", UF.ConfigureGroupRoleIndicator)
