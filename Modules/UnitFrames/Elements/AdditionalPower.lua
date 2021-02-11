local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateAdditionalPower = function(self)
    self.AdditionalPower = CreateFrame("StatusBar", "$parentPower", self)
    self.AdditionalPower:SetStatusBarTexture(UF.config.statusbars.additionalPower)
    self.AdditionalPower:SetStatusBarColor(unpack(UF.config.colors.mana))
    self.AdditionalPower:SetFrameLevel(self.Power:GetFrameLevel())
    self.AdditionalPower:SetBackdrop({bgFile = R.Libs.SharedMedia:Fetch("background", "Solid")})
    self.AdditionalPower:SetBackdropColor(0, 0, 0, 0.70)
    self.AdditionalPower:SetSize(self.Power:GetWidth() - 4, self.Power:GetHeight())
    self.AdditionalPower:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 2, -1)

    self.AdditionalPower.frequentUpdates = true
    self.AdditionalPower.Smooth = true

    self.AdditionalPower:CreateBorder(12)

    return self.AdditionalPower
end

oUF:RegisterMetaFunction("CreateAdditionalPower", UF.CreateAdditionalPower)

UF.UpdateAdditionalPower = function(self)
    if not self.AdditionalPower then
        return
    end
    
    self.AdditionalPower:SetStatusBarTexture(UF.config.statusbars.additionalPower)
end

oUF:RegisterMetaFunction("UpdateAdditionalPower", UF.UpdateAdditionalPower)