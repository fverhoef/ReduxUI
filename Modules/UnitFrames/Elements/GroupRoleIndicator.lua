local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateGroupRoleIndicator()
    self.GroupRoleIndicator = self.GroupRoleIndicatorParent:CreateTexture("$parentGroupRoleIcon", "OVERLAY", nil, 7)
    self.GroupRoleIndicator:SetParent(self.Overlay)
    self.GroupRoleIndicator:SetSize(20, 20)

    return self.GroupRoleIndicator
end

oUF:RegisterMetaFunction("CreateGroupRoleIndicator", UF.CreateGroupRoleIndicator)

function UF:UpdateGroupRoleIndicator()
    if not self.GroupRoleIndicator then
        return
    end

    local config = self.config.groupRoleIndicator
    if config.enabled then
        self:EnableElement("GroupRoleIndicator")

        self.GroupRoleIndicator:SetSize(unpack(config.size))
        self.GroupRoleIndicator:ClearAllPoints()
        self.GroupRoleIndicator:Point(unpack(config.point))
    else
        self:DisableElement("GroupRoleIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateGroupRoleIndicator", UF.UpdateGroupRoleIndicator)