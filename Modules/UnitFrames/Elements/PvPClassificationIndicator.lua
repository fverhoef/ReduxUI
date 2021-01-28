local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames

UF.CreatePvPClassificationIndicator = function(self)
    self.PvPClassificationIndicatorParent = CreateFrame("Frame", nil, self)
    self.PvPClassificationIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.PvPClassificationIndicator = self.PvPClassificationIndicatorParent:CreateTexture(nil, "OVERLAY")
    self.PvPClassificationIndicator:SetSize(24, 24)
    self.PvPClassificationIndicator:SetPoint("CENTER")

    return self.PvPClassificationIndicator
end
