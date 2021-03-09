local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateCastbar()
    local config = self.config.castbar

    self.CastbarHolder = CreateFrame("Frame", self:GetName() .. "CastbarHolder", self)
    self.CastbarHolder:SetFrameStrata("MEDIUM")
    self.CastbarHolder.config = config

    -- statusbar
    self.Castbar = CreateFrame("StatusBar", self:GetName() .. "Castbar", self.CastbarHolder)
    self.Castbar.config = config
    self.Castbar:SetFrameStrata("MEDIUM")
    self.Castbar:SetFrameLevel(self.CastbarHolder:GetFrameLevel() - 1)
    self.Castbar:SetOrientation("HORIZONTAL")
    self.Castbar:SetScript("OnShow", function()
        local config = self.config.castbar
        self.CastbarHolder.Border:SetShown(config.border.enabled)
        self.CastbarHolder.Shadow:SetShown(config.shadow.enabled)
        self.CastbarHolder.Gloss:SetShown(config.gloss.enabled)
    end)
    self.Castbar:SetScript("OnHide", function()
        self.CastbarHolder.Border:SetShown(false)
        self.CastbarHolder.Shadow:SetShown(false)
        self.CastbarHolder.Gloss:SetShown(false)
    end)

    -- border
    self.CastbarHolder:CreateBorder()
    self.CastbarHolder:CreateShadow()
    self.CastbarHolder:CreateGlossOverlay()

    -- background
    self.Castbar.bg = self.Castbar:CreateTexture(nil, "BACKGROUND")
    self.Castbar.bg:SetAllPoints()

    -- spark
    self.Castbar.SparkTexture = self.Castbar:CreateTexture(nil, "OVERLAY", nil, 7)
	self.Castbar.SparkTexture:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	self.Castbar.SparkTexture:SetTexCoord(9 / 32, 23 / 32, 5 / 32, 27 / 32)
    self.Castbar.SparkTexture:SetBlendMode("ADD")
	self.Castbar.SparkTexture:SetVertexColor(1, 1, 1)
    self.Castbar.SparkTexture:SetWidth(10)
    self.Castbar.Spark = self.Castbar.SparkTexture

    -- text
    self.Castbar.Text = self.Castbar:CreateFontString(nil, "OVERLAY")
    self.Castbar.Text:SetFont(UF.config.font, config.fontSize or 10)
    self.Castbar.Text:SetPoint("LEFT", self.Castbar, 2, 0)
    self.Castbar.Text:SetPoint("RIGHT", self.Castbar, -15, 0)
    self.Castbar.Text:SetJustifyH("LEFT")
    self.Castbar.Text:SetMaxLines(1)

    -- time
    self.Castbar.Time = self.Castbar:CreateFontString(nil, "OVERLAY")
    self.Castbar.Time:SetFont(UF.config.font, config.fontSize or 10)
    self.Castbar.Time:SetPoint("RIGHT", self.Castbar, -2, 0)

    -- icon
    self.Castbar.Icon = self.Castbar:CreateTexture(nil, "BACKGROUND", nil, -8)
    self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    self.Castbar.IconOverlay = CreateFrame("Frame", "$parentIconOverlay", self.Castbar)
    self.Castbar.IconOverlay:SetAllPoints(self.Castbar.Icon)
    self.Castbar.IconOverlay:CreateBorder()
    self.Castbar.IconOverlay:SetBorderPadding(2)
    self.Castbar.IconOverlay:CreateShadow()
    self.Castbar.IconOverlay:SetShadowPadding(2)
    self.Castbar.IconOverlay:CreateGlossOverlay()

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

function UF:UpdateCastbar()
    if not self.CastbarHolder then
        return
    end

    local config = self.config.castbar
    if config.detached then
        R:UnlockDragFrame(self.CastbarHolder)
    else
        R:LockDragFrame(self.CastbarHolder, true)
    end

    if config.enabled then
        self:EnableElement("Castbar")

        local width, height = unpack(config.size)
        self.Castbar:SetStatusBarTexture(UF.config.statusbars.castbar)
        self.Castbar:SetStatusBarColor(unpack(UF.config.colors.castbar))

        self.Castbar.bg:SetTexture(UF.config.statusbars.castbar)
        self.Castbar.bg:SetVertexColor(0.3 * UF.config.colors.castbar[1], 0.3 * UF.config.colors.castbar[2],
                                       0.3 * UF.config.colors.castbar[3])
        
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

        local leftOffset = config.border.enabled and config.border.size / 2 or 0
        local bottomOffset = config.border.enabled and config.border.size / 2 or 0
        local rightOffset = config.border.enabled and -config.border.size / 2 or 0
        local topOffset = config.border.enabled and -config.border.size / 2 or 0

        if config.showIcon then
            self.Castbar.Icon:Show()

            local iconSize = height - (not config.showIconOutside and (config.border.size / 2 + 1) or 0)
            self.Castbar.Icon:SetSize(iconSize, iconSize)
            self.Castbar.IconOverlay:SetSize(iconSize, iconSize)

            if config.showIconOutside then
                self.Castbar.Icon:SetPoint("RIGHT", self.Castbar, "LEFT", -8, 0)
                self.Castbar.IconOverlay:Show()
                self.Castbar.IconOverlay.Border:SetShown(config.border.enabled)
                self.Castbar.IconOverlay.Shadow:SetShown(config.shadow.enabled)
                self.Castbar.IconOverlay.Gloss:SetShown(config.gloss.enabled)
            else
                leftOffset = leftOffset + iconSize
                self.Castbar.Icon:SetPoint("RIGHT", self.Castbar, "LEFT", 0, 0)
                self.Castbar.IconOverlay:Hide()
            end
        else
            self.Castbar.Icon:Hide()
            self.Castbar.IconOverlay:Hide()
        end

        self.Castbar:ClearAllPoints()
        self.Castbar:SetPoint("BOTTOMLEFT", self.CastbarHolder, "BOTTOMLEFT", leftOffset, bottomOffset)
        self.Castbar:SetPoint("TOPRIGHT", self.CastbarHolder, "TOPRIGHT", rightOffset, topOffset)

        if config.showSafeZone then
            self.Castbar.SafeZone:Show()
        else
            self.Castbar.SafeZone:Hide()
        end

        self.CastbarHolder:SetSize(width, height)
        self.CastbarHolder:ClearAllPoints()
        if config.detached then
            self.CastbarHolder:Point(unpack(config.point))
        else
            self.CastbarHolder:Point(unpack(config.attachedPoint))
        end

        self.CastbarHolder:SetBorderSize(config.border.size)
        self.CastbarHolder.Border:SetShown(self.Castbar:IsShown() and config.border.enabled)
        self.CastbarHolder.Shadow:SetShown(self.Castbar:IsShown() and config.shadow.enabled)
        self.CastbarHolder.Gloss:SetShown(self.Castbar:IsShown() and config.gloss.enabled)
    else
        self:DisableElement("Castbar")
    end
end

oUF:RegisterMetaFunction("UpdateCastbar", UF.UpdateCastbar)
