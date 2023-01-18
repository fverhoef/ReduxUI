local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePower()
    self.Power = CreateFrame("StatusBar", "$parentPower", self, BackdropTemplateMixin and "BackdropTemplate")
    self.Power:SetStatusBarTexture(UF.config.statusbars.power)
    self.Power:SetFrameLevel(self:GetFrameLevel() - 1)
    self.Power:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
    self.Power:SetBackdropColor(0, 0, 0, 0.70)
    self.Power:SetPoint("BOTTOMLEFT")
    self.Power:SetPoint("BOTTOMRIGHT")
    self.Power:CreateBorder(nil, 10, 2)
    self.Power:CreateSeparator()

    self.Power.colorPower = true
    self.Power.colorClass = UF.config.colors.colorPowerClass
    self.Power.colorSmooth = UF.config.colors.colorPowerSmooth
    self.Power.colorDisconnected = UF.config.colors.colorPowerDisconnected

    self.Power.Overlay = CreateFrame("Frame", "$parentOverlay", self.Power)
    self.Power.Overlay:SetFrameLevel(self.Overlay:GetFrameLevel())
    self.Power.Overlay:SetAllPoints(self.Power)

    self.Power.Value = self.Power.Overlay:CreateFontString("$parentPowerText", "OVERLAY", nil, 7)
    self.Power.Value:SetParent(self.Power.Overlay)
    self.Power.Value:SetFont(UF.config.font, 10)

    self.Power.Percent = self.Power.Overlay:CreateFontString("$parentPowerPercent", "OVERLAY", nil, 7)
    self.Power.Percent:SetParent(self.Power.Overlay)
    self.Power.Percent:SetFont(UF.config.font, 10)

    return self.Power
end

oUF:RegisterMetaFunction("CreatePower", UF.CreatePower)

function UF:ConfigurePower()
    local config = self.config.power
    if not config.enabled then
        self:DisableElement("Power")
        return
    elseif not self.Power then
        self:CreatePower()
    end

    self:EnableElement("Power")

    if self.unit ~= "player" then
        config.detached = false
    end

    if not config.detached then
        config.point[5] = nil
    end
    self.Power:SetSize(unpack(config.size))
    self.Power:ClearAllPoints()
    self.Power.Border:SetShown(config.detached or config.inset)
    if config.detached then
        self.Power:SetNormalizedPoint(config.point)
    elseif config.inset then
        self.Power:SetNormalizedPoint(config.insetPoint)
        self.Power:SetFrameLevel(self:GetFrameLevel() + 2)
    else
        local bottomLeftOffset = { 0, 0 }
        local bottomRightOffset = { 0, 0 }
        if self.config.portrait.enabled then
            if self.config.portrait.point == "LEFT" then
                bottomLeftOffset[1] = self.config.portrait.point == "LEFT" and self.config.portrait.size[1] or 0
            else
                bottomRightOffset[1] = -self.config.portrait.size[1]
            end
        end
        self.Power:SetPoint("BOTTOMLEFT", bottomLeftOffset[1], 0)
        self.Power:SetPoint("BOTTOMRIGHT", bottomRightOffset[1], 0)
        self.Power:SetFrameLevel(self:GetFrameLevel() - 1)
    end

    self.Power:SetStatusBarTexture(UF.config.statusbars.power)
    self.Power:SetFrequentUpdates(config.frequentUpdates)
    self.Power.colorClass = UF.config.colors.colorPowerClass
    self.Power.colorSmooth = UF.config.colors.colorPowerSmooth
    self.Power.colorDisconnected = UF.config.colors.colorPowerDisconnected

    if config.value.enabled then
        self.Power.Value:Show()
        self.Power.Value:SetFont(config.value.font or UF.config.font, config.value.fontSize or 10, (config.value.fontOutline == "NONE" and "") or config.value.fontOutline)
        self.Power.Value:SetShadowOffset(config.value.fontShadow and 1 or 0, config.value.fontShadow and -1 or 0)

        if config.value.tag then
            self:Tag(self.Power.Value, config.value.tag)
        else
            self:Untag(self.Power.Value)
        end

        self.Power.Value:ClearAllPoints()
        self.Power.Value:SetNormalizedPoint(config.value.point)
        self.Power.Value:CreateFader(config.value.fader, nil, self)
    else
        self.Power.Value:CreateFader(R.config.faders.onShow, nil, self)
        self.Power.Value:Hide()
        self:Untag(self.Power.Value)
    end

    if config.percent.enabled then
        self.Power.Percent:Show()
        self.Power.Percent:SetFont(config.percent.font or UF.config.font, config.percent.fontSize or 10, (config.percent.fontOutline == "NONE" and "") or config.percent.fontOutline)
        self.Power.Percent:SetShadowOffset(config.percent.fontShadow and 1 or 0, config.percent.fontShadow and -1 or 0)

        if config.percent.tag then
            self:Tag(self.Power.Percent, config.percent.tag)
        else
            self:Untag(self.Power.Percent)
        end

        self.Power.Percent:ClearAllPoints()
        self.Power.Percent:SetNormalizedPoint(config.percent.point)
        self.Power.Percent:CreateFader(config.percent.fader, nil, self)
    else
        self.Power.Percent:CreateFader(R.config.faders.onShow, nil, self)
        self.Power.Percent:Hide()
        self:Untag(self.Power.Percent)
    end

    if config.smooth then
        R.Libs.SmoothStatusBar:SmoothBar(self.Power)
    else
        R.Libs.SmoothStatusBar:ResetBar(self.Power)
    end

    self.Power.Separator:SetShown(config.showSeparator)
end

oUF:RegisterMetaFunction("ConfigurePower", UF.ConfigurePower)
