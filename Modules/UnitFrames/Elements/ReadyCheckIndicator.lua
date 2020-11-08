local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateReadyCheckIndicator = function(self)
    self.ReadyCheckIndicator = self:CreateTexture("$parentReadyCheckIcon", "OVERLAY", nil, 7)
    self.ReadyCheckIndicator:SetPoint("TOPRIGHT", self.Portrait, -7, -7)
    self.ReadyCheckIndicator:SetPoint("BOTTOMLEFT", self.Portrait, 7, 7)
    self.ReadyCheckIndicator.delayTime = 2
    self.ReadyCheckIndicator.fadeTime = 0.5

    return self.ReadyCheckIndicator
end