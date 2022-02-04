local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateCastbar()
    if not self.config.castbar.enabled then return end

    self.Castbar = CreateFrame("StatusBar", self:GetName() .. "Castbar", self)
    self.Castbar:SetOrientation("HORIZONTAL")
    self.Castbar:CreateBackdrop({edgeFile = R.media.textures.edgeFiles.borderThickTooltip, edgeSize = 12})
    self.Castbar.Backdrop:SetOutside(self.Castbar, 3, 3)
    self.Castbar.Backdrop:SetFrameLevel(self.Castbar:GetFrameLevel() + 1)

    self.Castbar.bg = self.Castbar:CreateTexture("$parentBackground", "BACKGROUND")
    self.Castbar.bg:SetAllPoints()

    self.Castbar.SparkTexture = self.Castbar:CreateTexture("$parentSpark", "OVERLAY", nil, 7)
    self.Castbar.SparkTexture:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
    self.Castbar.SparkTexture:SetTexCoord(9 / 32, 23 / 32, 5 / 32, 27 / 32)
    self.Castbar.SparkTexture:SetBlendMode("ADD")
    self.Castbar.SparkTexture:SetVertexColor(1, 1, 1)
    self.Castbar.SparkTexture:SetWidth(10)
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
    self.Castbar.IconHolder:CreateBackdrop({edgeFile = R.media.textures.edgeFiles.borderThickTooltip, edgeSize = 12})
    self.Castbar.IconHolder.Backdrop:SetOutside(self.Castbar.IconHolder, 3, 3)
    self.Castbar.IconHolder.Backdrop:SetFrameLevel(self.Castbar.IconHolder:GetFrameLevel() + 1)
    self.Castbar.Icon = self.Castbar:CreateTexture("$parentIcon", "BACKGROUND", nil, -8)
    self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    self.Castbar.Icon:SetAllPoints(self.Castbar.IconHolder)

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

function UF:ConfigureCastbar()
    local config = self.config.castbar
    if not config.enabled then
        self:DisableElement("Castbar")
        return
    elseif not self.Castbar then
        self:CreateCastbar()
    end

    self:EnableElement("Castbar")

    self.Castbar:SetSize(unpack(config.size))

    self.Castbar:ClearAllPoints()
    self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
    self.Castbar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -5)

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
        self.Castbar.IconHolder:Show()
        self.Castbar.IconHolder:SetSize(config.size[2], config.size[2])
        self.Castbar.IconHolder:SetPoint("RIGHT", self.Castbar, "LEFT", -6, 0)
    else
        self.Castbar.IconHolder:Hide()
    end

    if config.showSafeZone then
        self.Castbar.SafeZone:Show()
    else
        self.Castbar.SafeZone:Hide()
    end
end

oUF:RegisterMetaFunction("ConfigureCastbar", UF.ConfigureCastbar)
