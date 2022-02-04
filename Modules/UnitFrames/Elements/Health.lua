local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateHealth()
    self.Health = CreateFrame("StatusBar", "$parentHealth", self, BackdropTemplateMixin and "BackdropTemplate")
    self.Health:SetStatusBarTexture(UF.config.statusbars.health)
    self.Health:SetFrameLevel(self:GetFrameLevel() - 1)
    self.Health:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Health:SetBackdropColor(0, 0, 0, 0.70)
    self.Health:SetPoint("TOPLEFT", self, "TOPLEFT")
    self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")

    self.Health.colorHealth = true
    self.Health.colorClass = UF.config.colors.colorHealthClass
    self.Health.colorSmooth = UF.config.colors.colorHealthSmooth
    self.Health.colorDisconnected = UF.config.colors.colorHealthDisconnected
    self.Health.colorTapping = true
    self.Health.colorReaction = true
    self.Health.colorHappiness = false

    self.Health.Overlay = CreateFrame("Frame", "$parentOverlay", self.Health)
    self.Health.Overlay:SetAllPoints(self.Health)

    self.Health.Value = self.Health.Overlay:CreateFontString("$parentHealthValue", "OVERLAY")
    self.Health.Value:SetParent(self.Health.Overlay)
    self.Health.Percent = self.Health.Overlay:CreateFontString("$parentHealthPercent", "OVERLAY")
    self.Health.Percent:SetParent(self.Health.Overlay)

    local myBar = CreateFrame("StatusBar", "$parentPredictionMine", self.Health)
    myBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    myBar:SetPoint("TOP")
    myBar:SetPoint("BOTTOM")
    myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
    myBar:SetWidth(125)
    myBar:Hide()

    local otherBar = CreateFrame("StatusBar", "$parentPredictionOther", self.Health)
    otherBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    otherBar:SetPoint("TOP")
    otherBar:SetPoint("BOTTOM")
    otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
    otherBar:SetWidth(125)
    otherBar:Hide()

    local absorbBar = CreateFrame("StatusBar", "$parentPredictionAbsorb", self.Health)
    absorbBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    absorbBar:SetPoint("TOP")
    absorbBar:SetPoint("BOTTOM")
    absorbBar:SetPoint("LEFT", otherBar:GetStatusBarTexture(), "RIGHT")
    absorbBar:SetWidth(125)
    absorbBar:Hide()

    local healAbsorbBar = CreateFrame("StatusBar", "$parentPredictionHealAbsorb", self.Health)
    healAbsorbBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    healAbsorbBar:SetPoint("TOP")
    healAbsorbBar:SetPoint("BOTTOM")
    healAbsorbBar:SetPoint("LEFT", otherBar:GetStatusBarTexture(), "RIGHT")
    healAbsorbBar:SetWidth(125)
    healAbsorbBar:Hide()

    self.HealthPrediction = {myBar = myBar, otherBar = otherBar, absorbBar = absorbBar, healAbsorbBar = healAbsorbBar, maxOverflow = 1}

    if not R.isRetail then self:RegisterEvent("UNIT_HEALTH_FREQUENT", UF.Health_ForceUpdate) end

    return self.Health
end

function UF:Health_ForceUpdate(event, ...)
    self.Health:ForceUpdate()
end

oUF:RegisterMetaFunction("CreateHealth", UF.CreateHealth)

function UF:ConfigureHealth()
    if not self.Health then return end

    local config = self.config.health
    self.Health:SetStatusBarTexture(UF.config.statusbars.health)
    self.Health.colorClass = UF.config.colors.colorHealthClass
    self.Health.colorSmooth = UF.config.colors.colorHealthSmooth
    self.Health.colorDisconnected = UF.config.colors.colorHealthDisconnected

    self.HealthPrediction.myBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    self.HealthPrediction.otherBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    self.HealthPrediction.absorbBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    self.HealthPrediction.healAbsorbBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)

    local topLeftOffset = {0, 0}
    local bottomRightOffset = {0, 0}
    if self.config.portrait.enabled then
        if self.config.portrait.point == "LEFT" then
            topLeftOffset[1] = self.config.portrait.size[1]
        else
            bottomRightOffset[1] = -self.config.portrait.size[1]
        end
    end
    if self.config.power.enabled and not self.config.power.detached then bottomRightOffset[2] = self.config.power.size[2] end
    self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", topLeftOffset[1], topLeftOffset[2])
    self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", bottomRightOffset[1], bottomRightOffset[2])

    if config.value.enabled then
        self.Health.Value:Show()
        self.Health.Value:SetFont(config.value.font or UF.config.font, config.value.fontSize or 11, config.value.fontOutline)
        self.Health.Value:SetShadowOffset(config.value.fontShadow and 1 or 0, config.value.fontShadow and -1 or 0)

        if config.value.tag then
            self:Tag(self.Health.Value, config.value.tag)
        else
            self:Untag(self.Health.Value)
        end

        self.Health.Value:ClearAllPoints()
        self.Health.Value:Point(unpack(config.value.point))
    else
        self.Health.Value:Hide()
        self:Untag(self.Health.Value)
    end

    if config.percent and config.percent.enabled then
        self.Health.Percent:Show()
        self.Health.Percent:SetFont(config.percent.font or UF.config.font, config.percent.fontSize or 11, config.percent.fontOutline)
        self.Health.Percent:SetShadowOffset(config.percent.fontShadow and 1 or 0, config.percent.fontShadow and -1 or 0)

        if config.percent.tag then
            self:Tag(self.Health.Percent, config.percent.tag)
        else
            self:Untag(self.Health.Percent)
        end

        self.Health.Percent:ClearAllPoints()
        self.Health.Percent:Point(unpack(config.percent.point))
    else
        self.Health.Percent:Hide()
        self:Untag(self.Health.Percent)
    end

    if config.smooth then
        R.Libs.SmoothStatusBar:SmoothBar(self.Health)
        R.Libs.SmoothStatusBar:SmoothBar(self.HealthPrediction.myBar)
        R.Libs.SmoothStatusBar:SmoothBar(self.HealthPrediction.otherBar)
        R.Libs.SmoothStatusBar:SmoothBar(self.HealthPrediction.absorbBar)
        R.Libs.SmoothStatusBar:SmoothBar(self.HealthPrediction.healAbsorbBar)
    else
        R.Libs.SmoothStatusBar:ResetBar(self.Health)
        R.Libs.SmoothStatusBar:ResetBar(self.HealthPrediction.myBar)
        R.Libs.SmoothStatusBar:ResetBar(self.HealthPrediction.otherBar)
        R.Libs.SmoothStatusBar:ResetBar(self.HealthPrediction.absorbBar)
        R.Libs.SmoothStatusBar:ResetBar(self.HealthPrediction.healAbsorbBar)
    end
end

oUF:RegisterMetaFunction("ConfigureHealth", UF.ConfigureHealth)
