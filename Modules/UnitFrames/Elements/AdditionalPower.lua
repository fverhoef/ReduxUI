local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAdditionalPower()
    if not self.config.additionalPower.enabled then
        return
    end

    self.AdditionalPower = CreateFrame("StatusBar", "$parentPower", self, BackdropTemplateMixin and "BackdropTemplate")
    self.AdditionalPower:SetStatusBarTexture(UF.config.statusbars.additionalPower)
    self.AdditionalPower:SetFrameLevel(self.Power:GetFrameLevel() - 1)
    self.AdditionalPower:SetBackdrop({ bgFile = R.Libs.SharedMedia:Fetch("background", "Solid") })
    self.AdditionalPower:SetBackdropColor(0, 0, 0, 0.70)
    self.AdditionalPower:CreateBorder(nil, 8, 2, self.AdditionalPower:GetFrameLevel() + 1)

    self.AdditionalPower.Overlay = CreateFrame("Frame", "$parentOverlay", self.AdditionalPower)
    self.AdditionalPower.Overlay:SetFrameLevel(self.Overlay:GetFrameLevel())
    self.AdditionalPower.Overlay:SetAllPoints(self.AdditionalPower)

    self.AdditionalPower.Value = self:CreateFontString("$parentAdditionalPowerText", "OVERLAY", nil, 7)
    self.AdditionalPower.Value:SetParent(self.AdditionalPower.Overlay)
    self.AdditionalPower.Value:SetFont(UF.config.font, 10)

    return self.AdditionalPower
end

oUF:RegisterMetaFunction("CreateAdditionalPower", UF.CreateAdditionalPower)

function UF:ConfigureAdditionalPower()
    local config = self.config.additionalPower
    if not config.enabled then
        self:DisableElement("AdditionalPower")
        return
    elseif not self.AdditionalPower then
        self:CreateAdditionalPower()
    end

    self:EnableElement("AdditionalPower")

    self.AdditionalPower:ClearAllPoints()
    self.AdditionalPower:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 10, -1)
    self.AdditionalPower:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -10, -1)
    self.AdditionalPower:SetSize(unpack(config.size))

    self.AdditionalPower:SetStatusBarTexture(UF.config.statusbars.additionalPower)
    self.AdditionalPower:SetStatusBarColor(unpack(UF.config.colors.mana))
    self.AdditionalPower:SetFrequentUpdates(config.frequentUpdates)

    if config.value.enabled then
        self.AdditionalPower.Value:Show()
        self.AdditionalPower.Value:SetFont(config.value.font or UF.config.font, config.value.fontSize or 10, (config.value.fontOutline == "NONE" and "") or config.value.fontOutline)
        self.AdditionalPower.Value:SetShadowOffset(config.value.fontShadow and 1 or 0, config.value.fontShadow and -1 or 0)

        if config.value.tag then
            self:Tag(self.AdditionalPower.Value, config.value.tag)
        end

        self.AdditionalPower.Value:ClearAllPoints()
        self.AdditionalPower.Value:SetNormalizedPoint(config.value.point)
    else
        self.AdditionalPower.Value:Hide()
    end

    if config.smooth then
        R.Libs.SmoothStatusBar:SmoothBar(self.AdditionalPower)
    else
        R.Libs.SmoothStatusBar:ResetBar(self.AdditionalPower)
    end
end

oUF:RegisterMetaFunction("ConfigureAdditionalPower", UF.ConfigureAdditionalPower)
