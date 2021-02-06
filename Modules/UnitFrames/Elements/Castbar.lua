local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateCastbar = function(self)
    local cfg = self.cfg.castbar

    -- statusbar
    self.Castbar = CreateFrame("StatusBar", nil, self)
    self.Castbar:SetFrameStrata("MEDIUM")
    self.Castbar:SetOrientation("HORIZONTAL")

    -- border
    self.Castbar:CreateBorder(cfg.borderSize)
    self.Castbar:CreateShadow()

    -- background
    self.Castbar.bg = self.Castbar:CreateTexture(nil, "BACKGROUND")
    self.Castbar.bg:SetAllPoints()

    -- spark
    self.Castbar.Spark = self.Castbar:CreateTexture(nil, "OVERLAY")
    self.Castbar.Spark:SetBlendMode("ADD")
    self.Castbar.Spark:SetPoint("CENTER", self.Castbar:GetStatusBarTexture(), "RIGHT", 0, 0)

    -- text
    self.Castbar.Text = self.Castbar:CreateFontString(nil, "OVERLAY")
    self.Castbar.Text:SetFont(UF.config.font, cfg.fontSize or 10)
    self.Castbar.Text:SetShadowOffset(1, -1)
    self.Castbar.Text:SetPoint("LEFT", self.Castbar, 2, 0)
    self.Castbar.Text:SetPoint("RIGHT", self.Castbar, -15, 0)
    self.Castbar.Text:SetJustifyH("LEFT")
    self.Castbar.Text:SetMaxLines(1)

    -- time
    self.Castbar.Time = self.Castbar:CreateFontString(nil, "OVERLAY")
    self.Castbar.Time:SetFont(UF.config.font, cfg.fontSize or 10)
    self.Castbar.Time:SetShadowOffset(1, -1)
    self.Castbar.Time:SetPoint("RIGHT", self.Castbar, -2, 0)

    -- icon
    self.Castbar.Icon = self.Castbar:CreateTexture(nil, "BACKGROUND", nil, -8)
    self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    self.Castbar.IconOverlay = CreateFrame("Frame", "$parentIconOverlay", self.Castbar)
    self.Castbar.IconOverlay:SetAllPoints(self.Castbar.Icon)
    self.Castbar.IconOverlay:CreateBorder(cfg.borderSize)
    self.Castbar.IconOverlay:SetBorderPadding(2)

    -- safezone/latency
    self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "OVERLAY")
    self.Castbar.SafeZone:SetAlpha(0.4)

    -- TODO: shield
    -- self.Castbar.Shield = self.Castbar:CreateTexture(nil, "BACKGROUND", nil, -8)
    -- self.Castbar.Shield.__owner = self.Castbar
    -- hooksecurefunc(self.Castbar.Shield, "Show", SetCastbarColorShielded)
    -- hooksecurefunc(self.Castbar.Shield, "Hide", SetCastbarColorDefault)

    return self.Castbar
end

oUF:RegisterMetaFunction("CreateCastbar", UF.CreateCastbar)

UF.UpdateCastbar = function(self)
    local cfg = self.cfg.castbar
    if cfg.enabled then
        self:EnableElement("Castbar")
        local width, height = unpack(cfg.size)
        self.Castbar:SetSize(width, height)

        self.Castbar:SetStatusBarTexture(UF.config.statusbars.castbar)
        self.Castbar:SetStatusBarColor(unpack(UF.config.colors.castbar))

        self.Castbar.bg:SetTexture(UF.config.statusbars.castbar)
        self.Castbar.bg:SetVertexColor(0.3 * UF.config.colors.castbar[1], 0.3 * UF.config.colors.castbar[2], 0.3 * UF.config.colors.castbar[3])

        self.Castbar.Spark:SetSize(height - cfg.borderSize, height - cfg.borderSize)

        self.Castbar.Text:SetFont(UF.config.font, cfg.fontSize or 10)
        self.Castbar.Time:SetFont(UF.config.font, cfg.fontSize or 10)

        if cfg.showIcon then
            self.Castbar.Icon:Show()

            local iconSize = height - cfg.borderSize / 2 - 1
            self.Castbar.Icon:SetSize(iconSize, iconSize)
            self.Castbar.IconOverlay:SetSize(iconSize, iconSize)

            if cfg.showIconOutside then
                self.Castbar.Icon:SetPoint("RIGHT", self.Castbar, "LEFT", -8, 0)
                self.Castbar.IconOverlay:Show()
                self.Castbar:SetBorderPadding(0)
                self.Castbar:SetShadowPadding(0)
            else
                self.Castbar:SetWidth(width - iconSize)
                self.Castbar.Icon:SetPoint("RIGHT", self.Castbar, "LEFT", 0, 0)
                self.Castbar.IconOverlay:Hide()
                self.Castbar:SetBorderPadding(iconSize + 2, 2, 0, 0)
                self.Castbar:SetShadowPadding(iconSize + 2, 2, 0, 0)
            end
        else
            self.Castbar.Icon:Hide()
            self.Castbar.IconOverlay:Hide()
        end

        if cfg.showSafeZone then
            self.Castbar.SafeZone:Show()
        else
            self.Castbar.SafeZone:Hide()
        end
    else
        self:DisableElement("Castbar")
    end
end

oUF:RegisterMetaFunction("UpdateCastbar", UF.UpdateCastbar)
