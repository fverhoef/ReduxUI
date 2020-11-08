local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreatePvPIndicator = function(self)
    self.PvPIndicator = self:CreateTexture("$parentPvPIcon", "OVERLAY", nil, 7)
    self.PvPIndicator:SetSize(40, 42)

    return self.PvPIndicator
end