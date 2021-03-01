local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAdditionalPower()
    self.AdditionalPower = CreateFrame("StatusBar", "$parentPower", self)
    self.AdditionalPower:SetStatusBarTexture(UF.config.statusbars.additionalPower)
    self.AdditionalPower:SetStatusBarColor(unpack(UF.config.colors.mana))
    self.AdditionalPower:SetFrameLevel(self.Power:GetFrameLevel())
    self.AdditionalPower:SetBackdrop({bgFile = R.Libs.SharedMedia:Fetch("background", "Solid")})
    self.AdditionalPower:SetBackdropColor(0, 0, 0, 0.70)
    self.AdditionalPower:SetHeight(12)
    self.AdditionalPower:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 2, -1)
    self.AdditionalPower:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", -2, -1)

    self.AdditionalPower.Smooth = true

    self.AdditionalPower:CreateBorder(4)

    return self.AdditionalPower
end

oUF:RegisterMetaFunction("CreateAdditionalPower", UF.CreateAdditionalPower)

function UF:UpdateAdditionalPower()
    if not self.AdditionalPower then
        return
    end

    self.AdditionalPower:SetStatusBarTexture(UF.config.statusbars.additionalPower)
end

oUF:RegisterMetaFunction("UpdateAdditionalPower", UF.UpdateAdditionalPower)
