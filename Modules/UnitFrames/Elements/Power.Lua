local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreatePower = function(self)
    self.Power = CreateFrame("StatusBar", "$parentPower", self)
    self.Power:SetStatusBarTexture(UF.config.db.profile.statusbars.power)
    self.Power:SetFrameLevel(self:GetFrameLevel() - 2)
    self.Power:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Power:SetBackdropColor(0, 0, 0, 0.70)

    self.Power.frequentUpdates = true
    self.Power.colorPower = true
    self.Power.colorClass = false
    self.Power.colorSmooth = false
    self.Power.Smooth = true

    self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, 0)
    self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)

    self.Power.Value = self:CreateFontString("$parentPowerText", "OVERLAY")
    self.Power.Value:SetFont(UF.config.db.profile.font, 10)
    self.Power.Value:SetShadowOffset(1, -1)
    self.Power.Value:SetPoint("CENTER", self.Power, 0, 0)

    self:Tag(self.Power.Value, "[curpp]")

    return self.Power
end

UF.UpdatePower = function(self)
    if self.Power then
        self.Power:SetStatusBarTexture(UF.config.db.profile.statusbars.power)
    end
end

UF.CreateEnergyManaRegen = function(self)
    self.EnergyManaRegen = CreateFrame("StatusBar", nil, self.Power)
    self.EnergyManaRegen:SetFrameLevel(self.Power:GetFrameLevel() + 3)
    self.EnergyManaRegen:SetAllPoints()
    self.EnergyManaRegen.Spark = self.EnergyManaRegen:CreateTexture(nil, "OVERLAY")

    return self.EnergyManaRegen
end

UF.CreateAdditionalPower = function(self)
    self.AdditionalPower = CreateFrame("StatusBar", "$parentPower", self)
    self.AdditionalPower:SetStatusBarTexture(UF.config.db.profile.statusbars.additionalPower)
    self.AdditionalPower:SetStatusBarColor(unpack(UF.config.db.profile.colors.mana))
    self.AdditionalPower:SetFrameLevel(self.Power:GetFrameLevel())
    self.AdditionalPower:SetBackdrop({bgFile = Addon.Libs.SharedMedia:Fetch("background", "Solid")})
    self.AdditionalPower:SetBackdropColor(0, 0, 0, 0.70)
    self.AdditionalPower:SetSize(self.Power:GetWidth() - 4, self.Power:GetHeight())
    self.AdditionalPower:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 2, -1)

    self.AdditionalPower.frequentUpdates = true
    self.AdditionalPower.Smooth = true

    Addon.CreateBorder(self.AdditionalPower, 6)

    return self.AdditionalPower
end

UF.UpdateAdditionalPower = function(self)
    if self.AdditionalPower then
        self.AdditionalPower:SetStatusBarTexture(UF.config.db.profile.statusbars.additionalPower)
    end
end

UF.CreatePowerPrediction = function(self)
    local mainBar = CreateFrame("StatusBar", nil, self.Power)
    mainBar:SetStatusBarTexture(UF.config.db.profile.statusbars.additionalPowerPrediction)
    mainBar:SetFrameLevel(self:GetFrameLevel() - 1)
    mainBar:SetReverseFill(true)
    mainBar:SetPoint("TOP")
    mainBar:SetPoint("BOTTOM")
    mainBar:SetPoint("RIGHT", self.Power:GetStatusBarTexture(), "RIGHT")
    mainBar:SetWidth(self.Power:GetWidth())

    if self.AdditionalPower then
        local altBar = CreateFrame("StatusBar", nil, self.AdditionalPower)
        altBar:SetStatusBarTexture(UF.config.db.profile.statusbars.additionalPowerPrediction)
        altBar:SetFrameLevel(self:GetFrameLevel())
        altBar:SetReverseFill(true)
        altBar:SetPoint("TOP")
        altBar:SetPoint("BOTTOM")
        altBar:SetPoint("RIGHT", self.AdditionalPower:GetStatusBarTexture(), "RIGHT")
        altBar:SetWidth(self.AdditionalPower:GetWidth())
    end

    self.PowerPrediction = {mainBar = mainBar, altBar = altBar}

    return self.PowerPrediction
end

UF.UpdatePowerPrediction = function(self)
    if self.PowerPrediction then
        self.PowerPrediction.mainBar:SetStatusBarTexture(UF.config.db.profile.statusbars.additionalPowerPrediction)
        self.PowerPrediction.mainBar:SetWidth(self.Power:GetWidth())

        if self.PowerPrediction.altBar then
            self.PowerPrediction.altBar:SetStatusBarTexture(UF.config.db.profile.statusbars.additionalPowerPrediction)
            self.PowerPrediction.altBar:SetWidth(self.Power:GetWidth())
        end
    end
end
