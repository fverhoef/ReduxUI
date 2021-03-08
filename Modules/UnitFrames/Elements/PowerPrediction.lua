local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePowerPrediction()
    local mainBar = CreateFrame("StatusBar", nil, self.Power)
    mainBar:SetStatusBarTexture(UF.config.statusbars.powerPrediction)
    mainBar:SetFrameLevel(self.Power:GetFrameLevel() + 1)
    mainBar:SetReverseFill(true)
    mainBar:SetSize(self.Power:GetWidth(), 0)

    local altBar
    if self.AdditionalPower then
        altBar = CreateFrame("StatusBar", nil, self.AdditionalPower)
        altBar:SetStatusBarTexture(UF.config.statusbars.additionalPowerPrediction)
        altBar:SetFrameLevel(self.Power:GetFrameLevel() + 1)
        altBar:SetReverseFill(true)
        altBar:SetSize(self.AdditionalPower:GetWidth(), 0)
    end

    self.PowerPrediction = {mainBar = mainBar, altBar = altBar}

    UF:SecureHook(self.Power, "SetStatusBarColor", function(_, r, g, b)
        self.PowerPrediction.mainBar:SetStatusBarColor(r * 1.25, g * 1.25, b * 1.25, 0.8)
    end)

    return self.PowerPrediction
end

oUF:RegisterMetaFunction("CreatePowerPrediction", UF.CreatePowerPrediction)

function UF:UpdatePowerPrediction()
    if not self.PowerPrediction then
        return
    end

    if self.config.power.powerPrediction then
        self:EnableElement("PowerPrediction")

        self.PowerPrediction.mainBar:SetStatusBarTexture(UF.config.statusbars.powerPrediction)
        self.PowerPrediction.mainBar:ClearAllPoints()
        self.PowerPrediction.mainBar:SetPoint("TOP", self.Power, "TOP")
        self.PowerPrediction.mainBar:SetPoint("BOTTOM", self.Power, "BOTTOM")
        self.PowerPrediction.mainBar:SetPoint("RIGHT", self.Power:GetStatusBarTexture(), "RIGHT")
        self.PowerPrediction.mainBar:SetSize(self.Power:GetWidth(), 0)

        if self.PowerPrediction.altBar then
            self.PowerPrediction.altBar:SetStatusBarTexture(UF.config.statusbars.additionalPowerPrediction)
            self.PowerPrediction.altBar:ClearAllPoints()
            self.PowerPrediction.altBar:SetPoint("TOP", self.AdditionalPower, "TOP")
            self.PowerPrediction.altBar:SetPoint("BOTTOM", self.AdditionalPower, "BOTTOM")
            self.PowerPrediction.altBar:SetPoint("RIGHT", self.AdditionalPower:GetStatusBarTexture(), "RIGHT")
            self.PowerPrediction.altBar:SetSize(self.AdditionalPower:GetWidth(), 0)
        end
    else
        self:DisableElement("PowerPrediction")
    end
end

oUF:RegisterMetaFunction("UpdatePowerPrediction", UF.UpdatePowerPrediction)
