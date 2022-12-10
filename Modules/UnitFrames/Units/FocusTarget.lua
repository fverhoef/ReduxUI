local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocusTarget()
    if not UF.config.focus.enabled then
        return
    end
    return UF:SpawnFrame("FocusTarget", "focustarget", UF.FocusTargetMixin, UF.config.focustarget, UF.defaults.focustarget)
end

UF.FocusTargetMixin = {}

function UF.FocusTargetMixin:PostConfigure()
    if self.config.style == UF.Styles.Vanilla then
        self:SetSize(93, 45)
        self:ClearAllPoints()
        self:SetPoint("LEFT", UF.frames.focus, "RIGHT", 2, 2)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self.Overlay:CreateTexture("$parentArtwork", "BORDER", nil, 7)
            self.Artwork:SetTexture(R.media.textures.unitFrames.vanilla.targetOfTargetFrame)
            self.Artwork:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
            self.Artwork:SetAllPoints()
        end
        self.Artwork:Show()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 11, "OUTLINE")
        self.Name:SetJustifyH("CENTER")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetSize(50, 13)
        self.Name:SetPoint("TOPLEFT", self, "TOPLEFT", 42, -1)
        self:Tag(self.Name, "[name:sub(10)]")

        self.Level:Hide()

        self.PortraitHolder.Separator:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.PortraitRound
        self.PortraitHolder:SetSize(35, 35)
        self.PortraitHolder:ClearAllPoints()
        self.PortraitHolder:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
        self:EnableElement("Portrait")

        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", 42, -15)
        self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 23)

        self.Health.Value:Hide()
        self.Health.Percent:Hide()

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPLEFT", self, "TOPLEFT", 42, -23)
        self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 15)

        self.Power.Value:Hide()
        self.Power.Percent:Hide()

        if self.RaidTargetIndicator then
            self.RaidTargetIndicator:SetSize(18, 18)
            self.RaidTargetIndicator:ClearAllPoints()
            self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP")
        end
    elseif self.config.style == UF.Styles.Modern then
        self:SetSize(115, 44)
        self:ClearAllPoints()
        self:SetPoint("LEFT", UF.frames.focus, "RIGHT", 5, 0)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self.Overlay:CreateTexture("$parentArtwork", "BORDER", nil, 7)
        end
        self.Artwork:SetTexture(R.media.textures.unitFrames.modern.unitFrame)
        self.Artwork:SetTexCoord(0.75, 0.9794921875, 0, 0.173828125)
        self.Artwork:ClearAllPoints()
        self.Artwork:SetAllPoints()
        self.Artwork:Show()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 11, "OUTLINE")
        self.Name:SetJustifyH("LEFT")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetPoint("TOPLEFT", 42, -3)
        self.Name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -6, -12)
        self:Tag(self.Name, "[name:sub(15)]")

        self.Level:Hide()

        self.PortraitHolder.Separator:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.PortraitRound
        self.PortraitHolder:SetSize(35, 35)
        self.PortraitHolder:ClearAllPoints()
        self.PortraitHolder:SetPoint("TOPLEFT", 5, -4)
        self:EnableElement("Portrait")

        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPLEFT", 40, -14)
        self.Health:SetPoint("BOTTOMRIGHT", -7, 20)

        self.Health.Value:Hide()
        self.Health.Percent:Hide()

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPLEFT", 40, -24)
        self.Power:SetPoint("BOTTOMRIGHT", -7, 12)

        self.Power.Border:Hide()
        self.Power.Separator:Hide()
        self.Power.Value:Hide()
        self.Power.Percent:Hide()

        if self.RaidTargetIndicator then
            self.RaidTargetIndicator:SetSize(18, 18)
            self.RaidTargetIndicator:ClearAllPoints()
            self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP")
        end
    else
        if self.Artwork then
            self.Artwork:Hide()
        end
    end
end

