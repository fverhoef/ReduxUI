local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateResurrectIndicator = function(self)
    self.ResurrectIndicator = self:CreateTexture(nil, "OVERLAY")
    self.ResurrectIndicator:SetSize(16, 16)
    self.ResurrectIndicator:SetPoint("CENTER", self.Health)
end