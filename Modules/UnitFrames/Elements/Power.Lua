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
    self.Power.config = self.config.power

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

    self.Power:CreateBorder(self.config.power.border.size)
    self.Power:CreateShadow()

    self:Tag(self.Power.Value, "[curpp]")

    return self.Power
end

oUF:RegisterMetaFunction("CreatePower", UF.CreatePower)

UF.UpdatePower = function(self)
    if not self.Power then
        return
    end

    local config = self.config.power
    if config.detached then
        R:UnlockDragFrame(self.Power)
    else
        R:LockDragFrame(self.Power, true)
    end

    if config.enabled then
        self:EnableElement("Power")

        self.Power:SetStatusBarTexture(UF.config.statusbars.power)
        self.Power:SetFrequentUpdates(self.config.power.frequentUpdates)
        self.Power.colorClass = UF.config.colors.colorPowerClass
        self.Power.colorSmooth = UF.config.colors.colorPowerSmooth
        self.Power.colorDisconnected = UF.config.colors.colorPowerDisconnected

        if config.value.enabled then
            self.Power.Value:Show()
            self.Power.Value:SetFont(config.value.font or UF.config.font, config.value.fontSize or 10, config.value.fontOutline)
            self.Power.Value:SetShadowOffset(config.value.fontShadow and 1 or 0, config.value.fontShadow and -1 or 0)

            if config.value.tag then
                self:Tag(self.Power.Value, config.value.tag)
            end

            self.Power.Value:ClearAllPoints()
            self.Power.Value:Point(unpack(config.value.point))
        else
            self.Power.Value:Hide()
        end

        self.Power:SetSize(unpack(config.size))
        self.Power:ClearAllPoints()
        if config.detached then
            self.Power:Point(unpack(config.point))
        else
            if self.config.portrait and self.config.portrait.enabled and not self.config.portrait.detached and
                self.config.portrait.attachedPoint == "RIGHT" then
                self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT")
                self.Power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT",
                                    self.config.border.enabled and self.config.border.size / 2 or 0, 0)
            else
                self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT")
                self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT",
                                    self.config.border.enabled and -self.config.border.size / 2 or 0, 0)
            end
        end

        self.Power.Border:SetShown(config.detached and config.border.enabled)
        self.Power:SetBorderPadding(config.border.enabled and 1 or 0, config.border.enabled and 1 or 0, 0, 0)

        self.Power.Shadow:SetShown(config.detached and config.shadow.enabled)
        self.Power:SetShadowPadding(config.border.enabled and 1 or 0, config.border.enabled and 1 or 1, 0, 0)
    else
        self:DisableElement("Power")
    end
end

oUF:RegisterMetaFunction("UpdatePower", UF.UpdatePower)
