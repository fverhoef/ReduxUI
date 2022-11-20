local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateCastbar()
    if not self.config.castbar.enabled then
        return
    end

    self.CastbarHolder = CreateFrame("Frame", "$parentCastbarHolder", self)
    self.CastbarHolder:CreateBorder(nil, nil, nil, self.CastbarHolder:GetFrameLevel() + 3)
    self.CastbarHolder.Border:SetOutside(nil, 0, 0)

    self.Castbar = CreateFrame("StatusBar", "$parentCastbar", self)
    self.Castbar:SetOrientation("HORIZONTAL")
    self.Castbar:SetInside(self.CastbarHolder, 3, 3)
    self.Castbar.Holder = self.CastbarHolder
    UF:SecureHookScript(self.Castbar, "OnShow", UF.Castbar_OnShow)
    UF:SecureHookScript(self.Castbar, "OnHide", UF.Castbar_OnHide)

    self.Castbar.bg = self.Castbar:CreateTexture("$parentBackground", "BACKGROUND")
    self.Castbar.bg:SetAllPoints()

    self.Castbar.SparkTexture = self.Castbar:CreateTexture("$parentSpark", "OVERLAY", nil, 7)
    self.Castbar.SparkTexture:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
    self.Castbar.SparkTexture:SetTexCoord(9 / 32, 23 / 32, 5 / 32, 27 / 32)
    self.Castbar.SparkTexture:SetBlendMode("ADD")
    self.Castbar.SparkTexture:SetVertexColor(1, 1, 1)
    self.Castbar.SparkTexture:SetWidth(6)
    self.Castbar.Spark = self.Castbar.SparkTexture

    self.Castbar.Text = self.Castbar:CreateFontString("$parentText", "OVERLAY")
    self.Castbar.Text:SetFont(UF.config.font, 10)
    self.Castbar.Text:SetPoint("LEFT", self.Castbar, 2, 0)
    self.Castbar.Text:SetPoint("RIGHT", self.Castbar, -15, 0)
    self.Castbar.Text:SetJustifyH("LEFT")
    self.Castbar.Text:SetMaxLines(1)

    self.Castbar.Time = self.Castbar:CreateFontString("$parentTime", "OVERLAY")
    self.Castbar.Time:SetFont(UF.config.font, 10)
    self.Castbar.Time:SetPoint("RIGHT", self.Castbar, -2, 0)

    self.Castbar.IconHolder = CreateFrame("Frame", "$parentIconHolder", self.Castbar)
    self.Castbar.IconHolder:CreateBorder(nil, nil, nil, self.Castbar.IconHolder:GetFrameLevel() + 1)
    self.Castbar.IconHolder.Border:SetOutside(nil, 0, 0)
    self.Castbar.IconHolder:CreateSeparator(nil, nil, 3, self.Castbar.IconHolder:GetFrameLevel() + 1, "RIGHT")
    self.Castbar.Icon = self.Castbar:CreateTexture("$parentIcon", "BACKGROUND", nil, -7)
    self.Castbar.Icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    self.Castbar.Icon:SetInside(self.Castbar.IconHolder, 3, 3)

    self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "OVERLAY")
    self.Castbar.SafeZone:SetAlpha(0.4)

    self.Castbar.Shield = self.Castbar:CreateTexture(nil, "BACKGROUND", nil, -8)
    self.Castbar.Shield:SetTexture(R.media.textures.unitFrames.shield)
    self.Castbar.Shield:SetSize(32, 32)
    self.Castbar.Shield:SetPoint("RIGHT", self.CastbarHolder, "LEFT", -2, 0)

    return self.Castbar
end

function UF:Castbar_OnShow()
    self.Holder:Show()
end

function UF:Castbar_OnHide()
    self.Holder:Hide()
end

oUF:RegisterMetaFunction("CreateCastbar", UF.CreateCastbar)

function UF:ConfigureCastbar()
    local config = self.config.castbar
    if not config.enabled then
        self:DisableElement("Castbar")
        return
    elseif not self.Castbar then
        self:CreateCastbar()
    end

    self:EnableElement("Castbar")

    if not config.detached then
        config.point[5] = nil
    end
    self.CastbarHolder:SetSize(config.detached and config.size[1] or self:GetWidth(), config.size[2])
    self.CastbarHolder:ClearAllPoints()
    self.CastbarHolder:SetNormalizedPoint(config.point)
    self.CastbarHolder:SetShown(self.Castbar:IsShown())

    self.Castbar:SetPoint("TOPLEFT", self.CastbarHolder, "TOPLEFT", 3 + (config.showIcon and not config.showIconOutside and (config.size[2] - 3) or 0), -3)

    self.Castbar:SetStatusBarTexture(UF.config.statusbars.castbar)
    self.Castbar:SetStatusBarColor(unpack(UF.config.colors.castbar))

    self.Castbar.bg:SetTexture(UF.config.statusbars.castbar)
    self.Castbar.bg:SetVertexColor(0.3 * UF.config.colors.castbar[1], 0.3 * UF.config.colors.castbar[2], 0.3 * UF.config.colors.castbar[3])

    self.Castbar.Text:SetFont(config.font or UF.config.font, config.fontSize or 10, config.fontOutline)
    self.Castbar.Text:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)

    self.Castbar.Time:SetFont(config.font or UF.config.font, config.fontSize or 10, config.fontOutline)
    self.Castbar.Time:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)

    if config.showSpark then
        self.Castbar.Spark = self.Castbar.SparkTexture
        self.Castbar.Spark:SetPoint("TOP", self.Castbar:GetStatusBarTexture(), "TOPRIGHT")
        self.Castbar.Spark:SetPoint("BOTTOM", self.Castbar:GetStatusBarTexture(), "BOTTOMRIGHT")
    else
        self.Castbar.Spark:Hide()
        self.Castbar.Spark = nil
    end

    if config.showIcon then
        self.Castbar.Icon:Show()
        self.Castbar.Icon:SetInside(self.Castbar.IconHolder, config.showIconOutside and 3 or 0, config.showIconOutside and 3 or 0)
        self.Castbar.IconHolder.Border:SetShown(config.showIconOutside)
        self.Castbar.IconHolder.Separator:SetShown(not config.showIconOutside)
        self.Castbar.IconHolder:Show()
        self.Castbar.IconHolder:SetSize(config.size[2] - (not config.showIconOutside and 3 or 0), config.size[2] - (not config.showIconOutside and 3 or 0))

        self.Castbar.IconHolder:ClearAllPoints()
        if config.showIconOutside then
            self.Castbar.IconHolder:SetPoint("CENTER", self.Castbar.Shield, "CENTER", 0, 0)
        else
            self.Castbar.IconHolder:SetPoint("RIGHT", self.Castbar, "LEFT", 0, 0)
        end
    else
        self.Castbar.Icon:Hide()
        self.Castbar.IconHolder:Hide()
    end

    if config.showSafeZone then
        self.Castbar.SafeZone:Show()
    else
        self.Castbar.SafeZone:Hide()
    end

    self.Castbar.Shield:SetAlpha(config.showShield and 1 or 0)
    self.Castbar.Shield:SetNormalizedSize(config.shieldSize)
    self.Castbar.Shield:SetPoint("RIGHT", self.CastbarHolder, "LEFT", -2, 0)
end

oUF:RegisterMetaFunction("ConfigureCastbar", UF.ConfigureCastbar)
