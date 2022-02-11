local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePower()
    if not self.config.power.enabled then return end

    self.Power = CreateFrame("StatusBar", "$parentPower", self, BackdropTemplateMixin and "BackdropTemplate")
    self.Power:SetStatusBarTexture(UF.config.statusbars.power)
    self.Power:SetFrameLevel(self:GetFrameLevel() - 1)
    self.Power:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Power:SetBackdropColor(0, 0, 0, 0.70)
    self.Power:SetPoint("BOTTOMLEFT")
    self.Power:SetPoint("BOTTOMRIGHT")
    self.Power:CreateBorder(nil, 10, 2)

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

    self.Power:CreateSeparator()

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

    if unit ~= "player" then config.detached = false end

    self.Power:SetSize(unpack(config.size))
    self.Power:ClearAllPoints()
    self.Power.Border:SetShown(config.detached or config.inset)
    if config.inset then
        self.Power:Point(unpack(config.insetPoint))
        self.Power.Border:Show()
        self.Power:SetFrameLevel(self:GetFrameLevel() + 2)
    else
        local bottomLeftOffset = {0, 0}
        local bottomRightOffset = {0, 0}
        if self.config.portrait.enabled then
            if self.config.portrait.point == "LEFT" then
                bottomLeftOffset[1] = self.config.portrait.point == "LEFT" and self.config.portrait.size[1] or 0
            else
                bottomRightOffset[1] = -self.config.portrait.size[1]
            end
        end
        self.Power:SetPoint("BOTTOMLEFT", self.config.portrait.point == "LEFT" and self.config.portrait.size[1] or 0, 0)
        self.Power:SetPoint("BOTTOMRIGHT", self.config.portrait.point ~= "LEFT" and -self.config.portrait.size[1] or 0, 0)
        self.Power.Border:Hide()
        self.Power:SetFrameLevel(self:GetFrameLevel() - 1)
    end

    self.Power:SetStatusBarTexture(UF.config.statusbars.power)
    self.Power:SetFrequentUpdates(config.frequentUpdates)
    self.Power.colorClass = UF.config.colors.colorPowerClass
    self.Power.colorSmooth = UF.config.colors.colorPowerSmooth
    self.Power.colorDisconnected = UF.config.colors.colorPowerDisconnected

    if config.value.enabled then
        self.Power.Value:Show()
        self.Power.Value:SetFont(config.value.font or UF.config.font, config.value.fontSize or 10, config.value.fontOutline)
        self.Power.Value:SetShadowOffset(config.value.fontShadow and 1 or 0, config.value.fontShadow and -1 or 0)

        if config.value.tag then
            self:Tag(self.Power.Value, config.value.tag)
        else
            self:Untag(self.Power.Value)
        end

        self.Power.Value:ClearAllPoints()
        self.Power.Value:Point(unpack(config.value.point))
    else
        self.Power.Value:Hide()
        self:Untag(self.Power.Value)
    end

    if config.smooth then
        R.Libs.SmoothStatusBar:SmoothBar(self.Power)
    else
        R.Libs.SmoothStatusBar:ResetBar(self.Power)
    end

    self.Power.Separator:SetShown(config.showSeparator)
end

oUF:RegisterMetaFunction("ConfigurePower", UF.ConfigurePower)
