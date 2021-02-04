local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateReadyCheckIndicator = function(self)
    self.ReadyCheckIndicatorParent = CreateFrame("Frame", nil, self)
    self.ReadyCheckIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.ReadyCheckIndicator = self.ReadyCheckIndicatorParent:CreateTexture("$parentReadyCheckIcon", "OVERLAY", nil, 7)
    self.ReadyCheckIndicator:SetPoint("TOPRIGHT", self.Portrait, -7, -7)
    self.ReadyCheckIndicator:SetPoint("BOTTOMLEFT", self.Portrait, 7, 7)
    self.ReadyCheckIndicator.delayTime = 2
    self.ReadyCheckIndicator.fadeTime = 0.5

    return self.ReadyCheckIndicator
end

oUF:RegisterMetaFunction("CreateReadyCheckIndicator", UF.CreateReadyCheckIndicator)