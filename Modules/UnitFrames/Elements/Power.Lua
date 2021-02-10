local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreatePower = function(self)
    self.Power = CreateFrame("StatusBar", "$parentPower", self)
    self.Power:SetStatusBarTexture(UF.config.statusbars.power)
    self.Power:SetFrameLevel(self:GetFrameLevel() - 2)
    self.Power:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Power:SetBackdropColor(0, 0, 0, 0.70)

    self.Power.colorPower = true
    self.Power.colorClass = UF.config.colors.colorPowerClass
    self.Power.colorSmooth = UF.config.colors.colorPowerSmooth
    self.Power.colorDisconnected = UF.config.colors.colorPowerDisconnected
    self.Power.Smooth = true

    self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, 0)
    self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)

    self.Power.Value = self:CreateFontString("$parentPowerText", "OVERLAY")
    self.Power.Value:SetParent(self.Power)
    self.Power.Value:SetFont(UF.config.font, 10)

    self.Power:CreateBorder(self.cfg.power.border.size)
    self.Power:CreateShadow()

    self:Tag(self.Power.Value, "[curpp]")

    return self.Power
end

oUF:RegisterMetaFunction("CreatePower", UF.CreatePower)

UF.UpdatePower = function(self)
    if not self.Power then
        return
    end

    local cfg = self.cfg.power
    if cfg.enabled then
        self:EnableElement("Power")

        self.Power:SetStatusBarTexture(UF.config.statusbars.power)
        self.Power:SetFrequentUpdates(self.cfg.power.frequentUpdates)
        self.Power.colorClass = UF.config.colors.colorPowerClass
        self.Power.colorSmooth = UF.config.colors.colorPowerSmooth
        self.Power.colorDisconnected = UF.config.colors.colorPowerDisconnected

        if cfg.value.enabled then
            self.Power.Value:Show()
            self.Power.Value:SetFont(cfg.value.font or UF.config.font, cfg.value.fontSize or 10, cfg.value.fontOutline)
            self.Power.Value:SetShadowOffset(cfg.value.fontShadow and 1 or 0, cfg.value.fontShadow and -1 or 0)

            if cfg.value.tag then
                self:Tag(self.Power.Value, cfg.value.tag)
            end

            self.Power.Value:ClearAllPoints()
            self.Power.Value:SetPoint(unpack(cfg.value.point))
        else
            self.Power.Value:Hide()
        end

        self.Power:SetSize(unpack(cfg.size))
        self.Power:ClearAllPoints()
        if cfg.detached then
            self.Power:SetPoint(unpack(cfg.point))
        else
            self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT")
            self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", self.cfg.border.enabled and -2 or 0, 0)
        end

        self.Power.Border:SetShown(cfg.detached and cfg.border.enabled)
        self.Power:SetBorderPadding(cfg.border.enabled and 1 or 0, cfg.border.enabled and 1 or 0, 0, 0)
    
        self.Power.Shadow:SetShown(cfg.detached and cfg.shadow.enabled)
        self.Power:SetShadowPadding(cfg.border.enabled and 1 or 0, cfg.border.enabled and 1 or 1, 0, 0)
    else
        self:DisableElement("Power")
    end
end

oUF:RegisterMetaFunction("UpdatePower", UF.UpdatePower)
