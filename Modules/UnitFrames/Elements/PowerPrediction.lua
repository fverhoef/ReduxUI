local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePowerPrediction()
    if not self.config.power.powerPrediction then return end

    local mainBar = CreateFrame("StatusBar", nil, self.Power)
    mainBar:SetStatusBarTexture(UF.config.statusbars.powerPrediction)
    mainBar:SetFrameLevel(self.Power:GetFrameLevel() + 1)
    mainBar:SetReverseFill(true)

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

function UF:ConfigurePowerPrediction()
    local config = self.config.power
    if not config.powerPrediction then
        self:DisableElement("PowerPrediction")
        return
    elseif not self.PowerPrediction then
        self:CreatePowerPrediction()
    end

    self:EnableElement("PowerPrediction")

    self.PowerPrediction.mainBar:SetStatusBarTexture(UF.config.statusbars.powerPrediction)
    self.PowerPrediction.mainBar:ClearAllPoints()
    self.PowerPrediction.mainBar:SetPoint("TOP", self.Power, "TOP")
    self.PowerPrediction.mainBar:SetPoint("BOTTOM", self.Power, "BOTTOM")
    self.PowerPrediction.mainBar:SetPoint("RIGHT", self.Power:GetStatusBarTexture(), "RIGHT")
    self.PowerPrediction.mainBar:SetWidth(self.Power:GetWidth())

    if config.smooth then
        R.Libs.SmoothStatusBar:SmoothBar(self.PowerPrediction.mainBar)
    else
        R.Libs.SmoothStatusBar:ResetBar(self.PowerPrediction.mainBar)
    end

    if self.PowerPrediction.altBar then
        self.PowerPrediction.altBar:SetStatusBarTexture(UF.config.statusbars.additionalPowerPrediction)
        self.PowerPrediction.altBar:ClearAllPoints()
        self.PowerPrediction.altBar:SetPoint("TOP", self.AdditionalPower, "TOP")
        self.PowerPrediction.altBar:SetPoint("BOTTOM", self.AdditionalPower, "BOTTOM")
        self.PowerPrediction.altBar:SetPoint("RIGHT", self.AdditionalPower:GetStatusBarTexture(), "RIGHT")
        self.PowerPrediction.altBar:SetWidth(self.AdditionalPower:GetWidth())

        if config.smooth then
            R.Libs.SmoothStatusBar:SmoothBar(self.PowerPrediction.altBar)
        else
            R.Libs.SmoothStatusBar:ResetBar(self.PowerPrediction.altBar)
        end
    end
end

oUF:RegisterMetaFunction("ConfigurePowerPrediction", UF.ConfigurePowerPrediction)
