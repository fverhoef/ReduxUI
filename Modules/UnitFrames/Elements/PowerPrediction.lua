local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreatePowerPrediction = function(self)
    local mainBar = CreateFrame("StatusBar", nil, self.Power)
    mainBar:SetStatusBarTexture(UF.config.statusbars.powerPrediction)
    mainBar:SetFrameLevel(self:GetFrameLevel() - 1)
    mainBar:SetReverseFill(true)
    mainBar:SetPoint("TOP", self.Power, "TOP")
    mainBar:SetPoint("BOTTOM", self.Power, "BOTTOM")
    mainBar:SetPoint("RIGHT", self.Power:GetStatusBarTexture(), "RIGHT")
    mainBar:SetSize(self.Power:GetWidth(), 0)

    local altBar
    if self.AdditionalPower then
        altBar = CreateFrame("StatusBar", nil, self.AdditionalPower)
        altBar:SetStatusBarTexture(UF.config.statusbars.additionalPowerPrediction)
        altBar:SetFrameLevel(self:GetFrameLevel() - 1)
        altBar:SetReverseFill(true)
        altBar:SetPoint("TOP", self.AdditionalPower, "TOP")
        altBar:SetPoint("BOTTOM", self.AdditionalPower, "BOTTOM")
        altBar:SetPoint("RIGHT", self.AdditionalPower:GetStatusBarTexture(), "RIGHT")
        altBar:SetSize(self.AdditionalPower:GetWidth(), 0)
    end

    self.PowerPrediction = {mainBar = mainBar, altBar = altBar}

    return self.PowerPrediction
end

oUF:RegisterMetaFunction("CreatePowerPrediction", UF.CreatePowerPrediction)

UF.UpdatePowerPrediction = function(self)
    if not self.PowerPrediction then
        return
    end

    if self.config.power.powerPrediction then
        self:EnableElement("PowerPrediction")

        self.PowerPrediction.mainBar:SetStatusBarTexture(UF.config.statusbars.powerPrediction)
        self.PowerPrediction.mainBar:SetSize(self.Power:GetWidth(), 0)

        if self.PowerPrediction.altBar then
            self.PowerPrediction.altBar:SetStatusBarTexture(UF.config.statusbars.additionalPowerPrediction)
            self.PowerPrediction.altBar:SetSize(self.AdditionalPower:GetWidth(), 0)
        end
    else
        self:DisableElement("PowerPrediction")
    end
end

oUF:RegisterMetaFunction("UpdatePowerPrediction", UF.UpdatePowerPrediction)
