local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateHealth = function(self)
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Health:SetStatusBarTexture(UF.config.db.profile.statusbars.health)
    self.Health:SetFrameLevel(self:GetFrameLevel() - 1)
    self.Health:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Health:SetBackdropColor(0, 0, 0, 0.70)

    self.Health.frequentUpdates = true
    self.Health.colorHealth = true
    self.Health.colorClass = UF.config.db.profile.colors.colorHealthClass
    self.Health.colorSmooth = UF.config.db.profile.colors.colorHealthSmooth
    self.Health.colorDisconnected = UF.config.db.profile.colors.colorHealthDisconnected
    self.Health.colorTapping = true
    self.Health.colorReaction = true
    self.Health.colorHappiness = false
    self.Health.Smooth = true

    self.Health.Value = self:CreateFontString("$parentHealthText", "OVERLAY")
    self.Health.Value:SetFont(UF.config.db.profile.font, 11)
    self.Health.Value:SetShadowOffset(1, -1)
    self.Health.Value:SetPoint("CENTER", self.Health, 0, 1)

    local myBar = CreateFrame("StatusBar", nil, self.Health)
    myBar:SetStatusBarTexture(UF.config.db.profile.statusbars.healthPrediction)
    myBar:SetPoint("TOP")
    myBar:SetPoint("BOTTOM")
    myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
    myBar:SetWidth(125)
    myBar:Hide()

    local otherBar = CreateFrame("StatusBar", nil, self.Health)
    otherBar:SetStatusBarTexture(UF.config.db.profile.statusbars.healthPrediction)
    otherBar:SetPoint("TOP")
    otherBar:SetPoint("BOTTOM")
    otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
    otherBar:SetWidth(125)
    otherBar:Hide()

    local absorbBar = CreateFrame("StatusBar", nil, self.Health)
    absorbBar:SetStatusBarTexture(UF.config.db.profile.statusbars.healthPrediction)
    absorbBar:SetPoint("TOP")
    absorbBar:SetPoint("BOTTOM")
    absorbBar:SetPoint("LEFT", otherBar:GetStatusBarTexture(), "RIGHT")
    absorbBar:SetWidth(125)
    absorbBar:Hide()

    local healAbsorbBar = CreateFrame("StatusBar", nil, self.Health)
    healAbsorbBar:SetStatusBarTexture(UF.config.db.profile.statusbars.healthPrediction)
    healAbsorbBar:SetPoint("TOP")
    healAbsorbBar:SetPoint("BOTTOM")
    healAbsorbBar:SetPoint("LEFT", otherBar:GetStatusBarTexture(), "RIGHT")
    healAbsorbBar:SetWidth(125)
    healAbsorbBar:Hide()

    self.HealthPrediction = {myBar = myBar, otherBar = otherBar, absorbBar = absorbBar, healAbsorbBar = healAbsorbBar, maxOverflow = 1}
    self.HealthPrediction.frequentUpdates = true

    self:Tag(self.Health.Value, "[curhp_status]")

    return self.Health
end

UF.UpdateHealth = function(self)
    if self.Health then
        self.Health:SetStatusBarTexture(UF.config.db.profile.statusbars.health)
        self.Health.colorClass = UF.config.db.profile.colors.colorHealthClass
        self.Health.colorSmooth = UF.config.db.profile.colors.colorHealthSmooth
        self.Health.colorDisconnected = UF.config.db.profile.colors.colorHealthDisconnected

        self.HealthPrediction.myBar:SetStatusBarTexture(UF.config.db.profile.statusbars.healthPrediction)
        self.HealthPrediction.otherBar:SetStatusBarTexture(UF.config.db.profile.statusbars.healthPrediction)
        self.HealthPrediction.absorbBar:SetStatusBarTexture(UF.config.db.profile.statusbars.healthPrediction)
        self.HealthPrediction.healAbsorbBar:SetStatusBarTexture(UF.config.db.profile.statusbars.healthPrediction)

        self.Health.Value:SetFont(UF.config.db.profile.font, 11)
        if self.cfg.health.value and self.cfg.health.value.tag ~= nil then
            self:Tag(self.Health.Value, self.cfg.health.value.tag)
        end
    end
end
