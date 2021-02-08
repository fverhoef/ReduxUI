local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateHealth = function(self)
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Health:SetStatusBarTexture(UF.config.statusbars.health)
    self.Health:SetFrameLevel(self:GetFrameLevel() - 1)
    self.Health:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Health:SetBackdropColor(0, 0, 0, 0.70)

    self.Health.frequentUpdates = true
    self.Health.colorHealth = true
    self.Health.colorClass = UF.config.colors.colorHealthClass
    self.Health.colorSmooth = UF.config.colors.colorHealthSmooth
    self.Health.colorDisconnected = UF.config.colors.colorHealthDisconnected
    self.Health.colorTapping = true
    self.Health.colorReaction = true
    self.Health.colorHappiness = false
    self.Health.Smooth = true

    self.Health.Value = self:CreateFontString("$parentHealthText", "OVERLAY")
    self.Health.Value:SetFont(UF.config.font, 11)
    self.Health.Value:SetShadowOffset(1, -1)
    self.Health.Value:SetPoint("CENTER", self.Health, 0, 1)

    local myBar = CreateFrame("StatusBar", nil, self.Health)
    myBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    myBar:SetPoint("TOP")
    myBar:SetPoint("BOTTOM")
    myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
    myBar:SetWidth(125)
    myBar:Hide()

    local otherBar = CreateFrame("StatusBar", nil, self.Health)
    otherBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    otherBar:SetPoint("TOP")
    otherBar:SetPoint("BOTTOM")
    otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
    otherBar:SetWidth(125)
    otherBar:Hide()

    local absorbBar = CreateFrame("StatusBar", nil, self.Health)
    absorbBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    absorbBar:SetPoint("TOP")
    absorbBar:SetPoint("BOTTOM")
    absorbBar:SetPoint("LEFT", otherBar:GetStatusBarTexture(), "RIGHT")
    absorbBar:SetWidth(125)
    absorbBar:Hide()

    local healAbsorbBar = CreateFrame("StatusBar", nil, self.Health)
    healAbsorbBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    healAbsorbBar:SetPoint("TOP")
    healAbsorbBar:SetPoint("BOTTOM")
    healAbsorbBar:SetPoint("LEFT", otherBar:GetStatusBarTexture(), "RIGHT")
    healAbsorbBar:SetWidth(125)
    healAbsorbBar:Hide()

    self.HealthPrediction = {
        myBar = myBar,
        otherBar = otherBar,
        absorbBar = absorbBar,
        healAbsorbBar = healAbsorbBar,
        maxOverflow = 1
    }
    self.HealthPrediction.frequentUpdates = true

    self:Tag(self.Health.Value, "[curhp_status]")

    return self.Health
end

oUF:RegisterMetaFunction("CreateHealth", UF.CreateHealth)

UF.UpdateHealth = function(self)
    if not self.Health then
        return
    end

    local cfg = self.cfg.health
    self.Health:SetStatusBarTexture(UF.config.statusbars.health)
    self.Health.colorClass = UF.config.colors.colorHealthClass
    self.Health.colorSmooth = UF.config.colors.colorHealthSmooth
    self.Health.colorDisconnected = UF.config.colors.colorHealthDisconnected

    self.HealthPrediction.myBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    self.HealthPrediction.otherBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    self.HealthPrediction.absorbBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    self.HealthPrediction.healAbsorbBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)

    if cfg.value.enabled then
        self.Health.Value:Show()
        self.Health.Value:SetFont(cfg.value.font or UF.config.font, cfg.value.fontSize or 11, cfg.value.fontOutline)
        if cfg.value.tag then
            self:Tag(self.Health.Value, cfg.value.tag)
        end
        if cfg.value.point then
            self.Health.Value:ClearAllPoints()
            self.Health.Value:SetPoint(unpack(cfg.value.point))
        end
    else
        self.Health.Value:Hide()
    end

    local leftOffset = (self.cfg.border.enabled and 2 or 0) + (self.cfg.portrait.enabled and self.cfg.portrait.size[1] or 0)
    local rightOffset = self.cfg.border.enabled and -2 or 0
    local bottomOffset = self.cfg.power.enabled and self.cfg.power.size[2] or 0
    self.Health:ClearAllPoints()
    self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", leftOffset, 0)
    self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", rightOffset, bottomOffset)
end

oUF:RegisterMetaFunction("UpdateHealth", UF.UpdateHealth)
