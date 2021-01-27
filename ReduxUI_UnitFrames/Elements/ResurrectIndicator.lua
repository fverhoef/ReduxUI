local AddonName, AddonTable = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames

UF.CreateResurrectIndicator = function(self)
    self.ResurrectIndicatorParent = CreateFrame("Frame", nil, self)
    self.ResurrectIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.ResurrectIndicator = self.ResurrectIndicatorParent:CreateTexture(nil, "OVERLAY")
    self.ResurrectIndicator:SetSize(16, 16)
    self.ResurrectIndicator:SetPoint("CENTER", self.Health)
end