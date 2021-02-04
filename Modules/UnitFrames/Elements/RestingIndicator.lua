local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateRestingIndicator = function(self)
    self.RestingIndicatorParent = CreateFrame("Frame", nil, self)
    self.RestingIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.RestingIndicator = self.RestingIndicatorParent:CreateTexture("$parentRestingIcon", "OVERLAY")
    self.RestingIndicator:SetPoint("TOPLEFT", self.Texture, 39, -50)
    self.RestingIndicator:SetSize(31, 31) -- 31,34

    self.RestingIndicator.Glow = self:CreateTexture("$parentRestingIconGlow", "OVERLAY")
    self.RestingIndicator.Glow:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
    self.RestingIndicator.Glow:SetTexCoord(0.0, 0.5, 0.5, 1.0)
    self.RestingIndicator.Glow:SetBlendMode("ADD")
    self.RestingIndicator.Glow:SetSize(32, 32)
    self.RestingIndicator.Glow:SetPoint("TOPLEFT", self.RestingIndicator)
    self.RestingIndicator.Glow:SetAlpha(0)
    self.RestingIndicator.Glow:Hide()

    return self.RestingIndicator
end

oUF:RegisterMetaFunction("CreateRestingIndicator", UF.CreateRestingIndicator)