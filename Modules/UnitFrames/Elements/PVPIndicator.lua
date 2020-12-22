local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreatePvPIndicator = function(self)
    self.PvPIndicatorParent = CreateFrame("Frame", nil, self)
    self.PvPIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.PvPIndicator = self.PvPIndicatorParent:CreateTexture("$parentPvPIcon", "OVERLAY", nil, 7)
    self.PvPIndicator:SetSize(40, 42)

    return self.PvPIndicator
end