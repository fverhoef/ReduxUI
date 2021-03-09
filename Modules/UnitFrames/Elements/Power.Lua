local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePower()
    local config = self.config.power    

    self.PowerHolder = CreateFrame("Frame", "$parentPowerHolder", self)
    self.PowerHolder:CreateBorder()
    self.PowerHolder:CreateShadow()
    self.PowerHolder:CreateGlossOverlay()
    self.PowerHolder.config = config

    self.Power = CreateFrame("StatusBar", "$parentPower", self)
    self.Power:SetStatusBarTexture(UF.config.statusbars.power)
    self.Power:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    self.Power:SetBackdropColor(0, 0, 0, 0.70)
    self.Power.config = config

    self.Power.colorPower = true
    self.Power.colorClass = UF.config.colors.colorPowerClass
    self.Power.colorSmooth = UF.config.colors.colorPowerSmooth
    self.Power.colorDisconnected = UF.config.colors.colorPowerDisconnected
    self.Power.Smooth = true

    self.Power.Value = self:CreateFontString("$parentPowerText", "OVERLAY", nil, 7)
    self.Power.Value:SetParent(self.Power)
    self.Power.Value:SetFont(UF.config.font, 10)

    self:Tag(self.Power.Value, "[curpp]")

    return self.Power
end

oUF:RegisterMetaFunction("CreatePower", UF.CreatePower)

function UF:UpdatePower()
    local config = self.config.power    
    if not self.Power then
        return
    end

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

        local leftOffset = config.padding and config.padding[1] or 0
        local rightOffset = config.padding and config.padding[2] or 0
        local topOffset = config.padding and config.padding[3] or 0
        local bottomOffset = config.padding and config.padding[4] or 0

        self.PowerHolder:SetSize(unpack(config.size))
        self.PowerHolder:ClearAllPoints()
        if config.detached then
            config.inset = false
            self.PowerHolder:Point(unpack(config.point))
        elseif config.inset then
            self.PowerHolder:Point(unpack(config.insetPoint))
            self.PowerHolder:SetFrameLevel(self:GetFrameLevel() + 1)
        else
            bottomOffset = bottomOffset + (self.config.border.enabled and self.config.border.size / 2 or 0)
            self.Power:SetFrameLevel(self:GetFrameLevel() - 1)
            self.PowerHolder:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", leftOffset, topOffset)
            self.PowerHolder:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", rightOffset, topOffset)
            self.PowerHolder:SetPoint("BOTTOM", self, "BOTTOM", 0, bottomOffset)
        end

        self.PowerHolder.Border:SetSize(config.border.size)
        self.PowerHolder.Border:SetShown((config.detached or config.inset) and config.border.enabled)
        self.PowerHolder.Shadow:SetShown((config.detached or config.inset) and config.shadow.enabled)
        self.PowerHolder.Gloss:SetShown((config.detached or config.inset) and config.gloss.enabled)

        xOffset = (config.detached or config.inset) and config.border.enabled and config.border.size / 2 or 0
        yOffset = (config.detached or config.inset) and config.border.enabled and config.border.size / 2 or 0
        self.Power:SetInside(self.PowerHolder, xOffset, yOffset)
    else
        self:DisableElement("Power")
    end
end

oUF:RegisterMetaFunction("UpdatePower", UF.UpdatePower)
