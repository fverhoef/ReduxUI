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

    self.Health.colorHealth = true
    self.Health.colorClass = UF.config.colors.colorHealthClass
    self.Health.colorSmooth = UF.config.colors.colorHealthSmooth
    self.Health.colorDisconnected = UF.config.colors.colorHealthDisconnected
    self.Health.colorTapping = true
    self.Health.colorReaction = true
    self.Health.colorHappiness = false
    self.Health.Smooth = true

    self.Health.Value = self:CreateFontString("$parentHealthText", "OVERLAY")

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

    self:Tag(self.Health.Value, "[curhp_status]")
    self.Health.Value:SetParent(self.Health)
    self.Health.Value:SetFont(UF.config.font, 11)

    self:RegisterEvent("UNIT_HEALTH_FREQUENT", UF.Health_ForceUpdate)

    return self.Health
end

function UF:Health_ForceUpdate(event, ...)
    self.Health:ForceUpdate()
end

oUF:RegisterMetaFunction("CreateHealth", UF.CreateHealth)

UF.UpdateHealth = function(self)
    if not self.Health then
        return
    end

    local config = self.config.health
    self.Health:SetStatusBarTexture(UF.config.statusbars.health)
    self.Health.colorClass = UF.config.colors.colorHealthClass
    self.Health.colorSmooth = UF.config.colors.colorHealthSmooth
    self.Health.colorDisconnected = UF.config.colors.colorHealthDisconnected

    self.HealthPrediction.myBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    self.HealthPrediction.otherBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    self.HealthPrediction.absorbBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)
    self.HealthPrediction.healAbsorbBar:SetStatusBarTexture(UF.config.statusbars.healthPrediction)

    if config.value.enabled then
        self.Health.Value:Show()
        self.Health.Value:SetFont(config.value.font or UF.config.font, config.value.fontSize or 11, config.value.fontOutline)
        self.Health.Value:SetShadowOffset(config.value.fontShadow and 1 or 0, config.value.fontShadow and -1 or 0)

        if config.value.tag then
            self:Tag(self.Health.Value, config.value.tag)
        end

        self.Health.Value:ClearAllPoints()
        self.Health.Value:SetPoint(unpack(config.value.point))
    else
        self.Health.Value:Hide()
    end

    local leftOffset = self.config.border.enabled and 2 or 0
    local rightOffset = self.config.border.enabled and -2 or 0
    local topOffset = self.config.border.enabled and -2 or 0
    local bottomOffset = self.config.border.enabled and 2 or 0

    if self.config.power.enabled and not self.config.power.detached then
        bottomOffset = bottomOffset + (self.config.power.size[2] or 0)
    end

    if self.config.portrait.enabled and not self.config.portrait.detached then
        if self.config.portrait.attachedPoint == "LEFT" then
            leftOffset = leftOffset + (self.config.portrait.size[1] or 0)
        elseif self.config.portrait.attachedPoint == "RIGHT" then
            rightOffset = rightOffset - (self.config.portrait.size[1] or 0)
        end
    end

    self.Health:ClearAllPoints()
    self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", leftOffset, topOffset)
    self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", rightOffset, bottomOffset)
end

oUF:RegisterMetaFunction("UpdateHealth", UF.UpdateHealth)
