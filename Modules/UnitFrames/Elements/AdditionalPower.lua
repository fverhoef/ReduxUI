local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAdditionalPower()
    self.AdditionalPowerHolder = CreateFrame("Frame", "$parentAdditionalPowerHolder", self)
    self.AdditionalPowerHolder:CreateBorder()
    self.AdditionalPowerHolder:CreateShadow()
    self.AdditionalPowerHolder:CreateGlossOverlay()
    self.AdditionalPowerHolder:SetFrameLevel(self.Power:GetFrameLevel())

    self.AdditionalPower = CreateFrame("StatusBar", "$parentPower", self)
    self.AdditionalPower:SetStatusBarTexture(UF.config.statusbars.additionalPower)
    self.AdditionalPower:SetFrameLevel(self.Power:GetFrameLevel())
    self.AdditionalPower:SetBackdrop({bgFile = R.Libs.SharedMedia:Fetch("background", "Solid")})
    self.AdditionalPower:SetBackdropColor(0, 0, 0, 0.70)
    self.AdditionalPower:SetHeight(12)
    self.AdditionalPower:SetScript("OnShow", function()
        local config = self.config.additionalPower
        self.AdditionalPowerHolder.Border:SetShown(config.border.enabled)
        self.AdditionalPowerHolder.Shadow:SetShown(config.shadow.enabled)
        self.AdditionalPowerHolder.Gloss:SetShown(config.gloss.enabled)
    end)
    self.AdditionalPower:SetScript("OnHide", function()
        self.AdditionalPowerHolder.Border:SetShown(false)
        self.AdditionalPowerHolder.Shadow:SetShown(false)
        self.AdditionalPowerHolder.Gloss:SetShown(false)
    end)

    self.AdditionalPower.Value = self:CreateFontString("$parentAdditionalPowerText", "OVERLAY", nil, 7)
    self.AdditionalPower.Value:SetParent(self.AdditionalPower)
    self.AdditionalPower.Value:SetFont(UF.config.font, 10)

    self.AdditionalPower.Smooth = true

    return self.AdditionalPower
end

oUF:RegisterMetaFunction("CreateAdditionalPower", UF.CreateAdditionalPower)

function UF:UpdateAdditionalPower()
    if not self.AdditionalPower then
        return
    end

    local config = self.config.additionalPower

    if config.enabled then
        self:EnableElement("AdditionalPower")

        self.AdditionalPower:SetStatusBarTexture(UF.config.statusbars.additionalPower)
        self.AdditionalPower:SetStatusBarColor(unpack(UF.config.colors.mana))

        if config.value.enabled then
            self.AdditionalPower.Value:Show()
            self.AdditionalPower.Value:SetFont(config.value.font or UF.config.font, config.value.fontSize or 10, config.value.fontOutline)
            self.AdditionalPower.Value:SetShadowOffset(config.value.fontShadow and 1 or 0, config.value.fontShadow and -1 or 0)

            if config.value.tag then
                self:Tag(self.AdditionalPower.Value, config.value.tag)
            end

            self.AdditionalPower.Value:ClearAllPoints()
            self.AdditionalPower.Value:Point(unpack(config.value.point))
        else
            self.Power.Value:Hide()
        end

        self.AdditionalPowerHolder:SetSize(unpack(config.size))
        self.AdditionalPowerHolder:ClearAllPoints()
        if config.detached then
            self.AdditionalPowerHolder:Point(unpack(config.point))
        else
            self.AdditionalPowerHolder:Point(unpack(config.attachedPoint))
            self.AdditionalPowerHolder:SetFrameLevel(self:GetFrameLevel() + 2)
        end

        self.AdditionalPowerHolder.Border:SetShown(self.AdditionalPower:IsShown() and config.border.enabled)
        self.AdditionalPowerHolder.Border:SetSize(config.border.size)
        self.AdditionalPowerHolder.Border:SetTexture(config.border.texture)
        self.AdditionalPowerHolder.Border:SetVertexColor(unpack(config.border.color))

        self.AdditionalPowerHolder.Shadow:SetShown(self.AdditionalPower:IsShown() and config.shadow.enabled)
        self.AdditionalPowerHolder.Shadow:SetBackdropBorderColor(unpack(config.shadow.color))
        
        self.AdditionalPowerHolder.Gloss:SetShown(self.AdditionalPower:IsShown() and config.gloss.enabled)
        self.AdditionalPowerHolder.Gloss:SetTexture(config.gloss.texture)
        self.AdditionalPowerHolder.Gloss:SetVertexColor(unpack(config.gloss.color))

        local xOffset = config.border.enabled and config.border.size / 2 or 0
        local yOffset = config.border.enabled and config.border.size / 2 or 0
        self.AdditionalPower:SetInside(self.AdditionalPowerHolder, xOffset, yOffset)
    else
        self:DisableElement("AdditionalPower")
    end
end

oUF:RegisterMetaFunction("UpdateAdditionalPower", UF.UpdateAdditionalPower)
