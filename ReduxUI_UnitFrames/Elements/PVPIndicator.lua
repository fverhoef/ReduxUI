local AddonName, AddonTable = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames

UF.CreatePvPIndicator = function(self)
    self.PvPIndicatorParent = CreateFrame("Frame", nil, self)
    self.PvPIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.PvPIndicator = self.PvPIndicatorParent:CreateTexture("$parentPvPIcon", "OVERLAY", nil, 7)
    self.PvPIndicator:SetSize(40, 42)

    return self.PvPIndicator
end