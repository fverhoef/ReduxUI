local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateOfflineIcon = function(self)
    self.OfflineIcon = self:CreateTexture("$parentOfflineIcon", "OVERLAY")
    self.OfflineIcon:SetPoint("CENTER", self.Portrait, 0, 0)
    self.OfflineIcon:SetSize(64, 64)

    return self.OfflineIcon
end