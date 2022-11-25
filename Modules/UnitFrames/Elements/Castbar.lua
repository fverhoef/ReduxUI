local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateCastbar()
    if not self.config.castbar.enabled then
        return
    end

    self.Castbar = CreateFrame("StatusBar", "$parentCastbar", self, "CastbarTemplate")
    self.Castbar.Spark:SetPoint("CENTER", self.Castbar.Texture, "RIGHT")

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
    self.Castbar:SetSize(config.detached and config.size[1] or self:GetWidth(), config.size[2])
    self.Castbar:ClearAllPoints()
    self.Castbar:SetNormalizedPoint(config.point)

    --self.Castbar:SetStatusBarTexture(UF.config.statusbars.castbar)
    --self.Castbar:SetStatusBarColor(unpack(UF.config.colors.castbar))

    self.Castbar.Spark:SetAlpha(config.showSpark and 1 or 0)

    self.Castbar.Text:SetFont(config.font or UF.config.font, config.fontSize or 10, config.fontOutline)
    self.Castbar.Text:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)

    self.Castbar.Time:SetFont(config.font or UF.config.font, config.fontSize or 10, config.fontOutline)
    self.Castbar.Time:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)

    self.Castbar.Icon:SetShown(config.showIcon)
    self.Castbar.SafeZone:SetShown(config.showSafeZone)

    self.Castbar.Shield:SetAlpha(config.showShield and 1 or 0)
    self.Castbar.Shield:SetNormalizedSize(config.shieldSize)
    self.Castbar.Shield:SetPoint("RIGHT", self.Castbar, "LEFT", -2, 0)
end

oUF:RegisterMetaFunction("ConfigureCastbar", UF.ConfigureCastbar)
