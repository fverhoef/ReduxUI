local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateGroupRoleIndicator = function(self)
    self.GroupRoleIndicator = self:CreateTexture("$parentGroupRoleIcon", "OVERLAY", nil, 7)
    self.GroupRoleIndicator:SetSize(20, 20)

    if unit == "player" then
        self.GroupRoleIndicator:SetPoint("BOTTOMRIGHT", self.Portrait, -2, -3)
    elseif unit == "target" then
        self.GroupRoleIndicator:SetPoint("TOPLEFT", self.Portrait, -10, -2)
    else
        self.GroupRoleIndicator:SetPoint("BOTTOMLEFT", self.Portrait, -5, -5)
    end

    return self.GroupRoleIndicator
end