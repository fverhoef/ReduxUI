local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateCombatIndicator = function(self)
    self.CombatIndicatorParent = CreateFrame("Frame", nil, self)
    self.CombatIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.CombatIndicator = self.CombatIndicatorParent:CreateTexture("$parentCombatIcon", "OVERLAY")
    self.CombatIndicator:SetDrawLayer("OVERLAY", 7)
    self.CombatIndicator:SetPoint("TOPLEFT", self.RestingIndicator, 1, 1)
    self.CombatIndicator:SetSize(32, 31)

    self.CombatIndicator.Glow = self:CreateTexture("$parentCombatIconGlow", "OVERLAY")
    self.CombatIndicator.Glow:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
    self.CombatIndicator.Glow:SetTexCoord(0.5, 1.0, 0.5, 1.0)
    self.CombatIndicator.Glow:SetVertexColor(1.0, 0.0, 0.0)
    self.CombatIndicator.Glow:SetBlendMode("ADD")
    self.CombatIndicator.Glow:SetSize(32, 32)
    self.CombatIndicator.Glow:SetPoint("TOPLEFT", self.RestingIndicator, 1, 1)
    self.CombatIndicator.Glow:SetAlpha(0)
    self.CombatIndicator.Glow:Hide()

    return self.CombatIndicator
end