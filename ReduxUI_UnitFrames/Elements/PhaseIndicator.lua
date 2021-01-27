local AddonName, AddonTable = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames

UF.CreatePhaseIndicator = function(self)
    self.PhaseIndicatorParent = CreateFrame("Frame", nil, self)
    self.PhaseIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.PhaseIndicator = self.PhaseIndicatorParent:CreateTexture("$parentPhaseIcon", "OVERLAY")
    self.PhaseIndicator:SetPoint("CENTER", self.Portrait, "BOTTOM")

    if self.IsMainFrame then
        self.PhaseIndicator:SetSize(26, 26)
    else
        self.PhaseIndicator:SetSize(18, 18)
    end

    return self.PhaseIndicator
end