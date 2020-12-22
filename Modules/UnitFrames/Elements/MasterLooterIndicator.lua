local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateMasterLooterIndicator = function(self)
    self.MasterLooterIndicatorParent = CreateFrame("Frame", nil, self)
    self.MasterLooterIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.MasterLooterIndicator = self.MasterLooterIndicatorParent:CreateTexture(nil, "OVERLAY")
    self.MasterLooterIndicator:SetSize(14, 14)

    return self.MasterLooterIndicator
end