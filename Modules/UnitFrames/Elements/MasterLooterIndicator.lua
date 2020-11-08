local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateMasterLooterIndicator = function(self)
    self.MasterLooterIndicator = self:CreateTexture(nil, "ARTWORK")
    self.MasterLooterIndicator:SetSize(14, 14)

    return self.MasterLooterIndicator
end