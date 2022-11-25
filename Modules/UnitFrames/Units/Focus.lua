local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocus()
    return UF:SpawnFrame("Focus", "focus", FocusMixin, UF.config.focus, UF.defaults.focus)
end

FocusMixin = {}

function FocusMixin:PostConfigure()
    if self.config.style == UF.Styles.Vanilla then
        self:SetSize(194, 76)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self:CreateTexture("$parentArtwork", "BORDER", nil, 7)
            self.Artwork:SetTexCoord(50 / 512, 1, 0, 200 / 256)
            self.Artwork:SetPoint("TOPLEFT", 0, 8.5)
            self.Artwork:SetPoint("BOTTOMRIGHT", 37, -15.5)
        end
        self.Artwork:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.focusFrame_LargeHealth or R.media.textures.unitFrames.vanilla.focusFrame)
        self.Artwork:Show()

        if not self.Flash then
            self.Flash = self:CreateTexture("$parentFlash", "BACKGROUND", nil, 1)
            self.Flash:SetTexture(R.media.textures.unitFrames.vanilla.focusFrame_Flash)
            self.Flash:SetTexCoord(0, 1, 0, 205 / 256)
            self.Flash:SetPoint("CENTER", self, "CENTER", 6, -4.5)
            self.Flash:SetSize(256, 103)
        end
        self.Flash:Hide()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 13, "OUTLINE")
        self.Name:SetJustifyH(self.config.largeHealth and "RIGHT" or "CENTER")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetSize(115, 13)
        if self.config.largeHealth then
            self.Name:SetPoint("TOPRIGHT", self, "TOPRIGHT", -72, 0)
        else
            self.Name:SetPoint("TOPRIGHT", self, "TOPRIGHT", -72, -17)
        end
        self:Tag(self.Name, "[name:sub(20)]")

        if not self.NameBackground then
            self.NameBackground = self:CreateTexture("$parentNameBackground", "BACKGROUND")
            self.NameBackground:SetTexture(R.media.textures.blank)
            self.NameBackground:SetOutside(self.Name, 2, 2)
            self.NameBackground:SetVertexColor(0, 0, 0, 0.7)
        end
        self.NameBackground:SetShown(not self.config.largeHealth)

        self.Level:Hide()
        self:Untag(self.Level)

        self.PortraitHolder.Separator:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.PortraitRound
        self.PortraitHolder:SetSize(60, 60)
        self.PortraitHolder:ClearAllPoints()
        self.PortraitHolder:SetPoint("TOPRIGHT", self, "TOPRIGHT", -6, -5)
        self:EnableElement("Portrait")

        self.Health:ClearAllPoints()
        if self.config.largeHealth then
            self.Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", -70, -14)
        else
            self.Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", -70, -33)
        end
        self.Health:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 5, 32)

        self.Health.Value:SetFont(self.config.health.value.font, 11, "OUTLINE")
        self.Health.Value:SetJustifyH("LEFT")
        self.Health.Value:ClearAllPoints()
        self.Health.Value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)

        self.Health.Percent:SetFont(self.config.health.percent.font, 11, "OUTLINE")
        self.Health.Percent:SetJustifyH("RIGHT")
        self.Health.Percent:ClearAllPoints()
        self.Health.Percent:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPRIGHT", self, "TOPRIGHT", -70, -45)
        self.Power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 5, 21)

        self.Power.Value:SetFont(self.config.power.value.font, 11, "OUTLINE")
        self.Power.Value:SetJustifyH("LEFT")
        self.Power.Value:ClearAllPoints()
        self.Power.Value:SetPoint("LEFT", self.Power, "LEFT", 2, 0)

        self.Power.Percent:SetFont(self.config.power.percent.font, 11, "OUTLINE")
        self.Power.Percent:SetJustifyH("RIGHT")
        self.Power.Percent:ClearAllPoints()
        self.Power.Percent:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)

        self.Power.Border:Hide()
        self.Power.Separator:Hide()

        if self.PvPIndicator then
            self.PvPIndicator:SetSize(32, 32)
            self.PvPIndicator:ClearAllPoints()
            self.PvPIndicator:SetPoint("CENTER", self.Portrait, "RIGHT", 2, 0)
        end

        if self.LeaderIndicator then
            self.LeaderIndicator:SetSize(16, 16)
            self.LeaderIndicator:ClearAllPoints()
            self.LeaderIndicator:SetPoint("CENTER", self.Portrait, "TOP", 22, -6)
        end

        if self.AssistantIndicator then
            self.AssistantIndicator:SetSize(16, 16)
            self.AssistantIndicator:ClearAllPoints()
            self.AssistantIndicator:SetPoint("CENTER", self.Portrait, "TOP", 22, -6)
        end

        if self.MasterLooterIndicator then
            self.MasterLooterIndicator:SetSize(16, 16)
            self.MasterLooterIndicator:ClearAllPoints()
            self.MasterLooterIndicator:SetPoint("CENTER", self.Portrait, "BOTTOM", 0, 0)
        end

        if self.RaidTargetIndicator then
            self.RaidTargetIndicator:SetSize(24, 24)
            self.RaidTargetIndicator:ClearAllPoints()
            self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP")
        end

        if self.GroupRoleIndicator then
            self.GroupRoleIndicator:SetSize(16, 16)
            self.GroupRoleIndicator:ClearAllPoints()
            self.GroupRoleIndicator:SetPoint("CENTER", self.Portrait, "TOP", -22, -6)
        end

        if self.RaidRoleIndicator then
            self.RaidRoleIndicator:SetSize(16, 16)
            self.RaidRoleIndicator:ClearAllPoints()
            self.RaidRoleIndicator:SetPoint("CENTER", self.Portrait, "TOP", -22, -6)
        end

        if self.ReadyCheckIndicator then
            self.ReadyCheckIndicator:SetSize(32, 32)
            self.ReadyCheckIndicator:ClearAllPoints()
            self.ReadyCheckIndicator:SetPoint("CENTER", self.Portrait, "CENTER", 0, 0)
        end

        if self.SummonIndicator then
            self.SummonIndicator:SetSize(32, 32)
            self.SummonIndicator:ClearAllPoints()
            self.SummonIndicator:SetPoint("CENTER", self.Portrait, "CENTER", 0, 0)
        end

        if self.ResurrectIndicator then
            self.ResurrectIndicator:SetSize(32, 32)
            self.ResurrectIndicator:ClearAllPoints()
            self.ResurrectIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
        end

        self.Castbar:ClearAllPoints()
        self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, -5)
        self.Castbar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, -16)
    elseif self.config.style == UF.Styles.Dragonflight then
        self:SetSize(192, 67)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self:CreateTexture("$parentArtwork", "BORDER", nil, 7)
        end
        self.Artwork:ClearAllPoints()
        self.Artwork:SetAllPoints()
        self.Artwork:SetTexture(R.media.textures.unitFrames.dragonflight.unitFrame)
        self.Artwork:SetTexCoord(0.375, 0.75, 0, 0.26171875)
        self.Artwork:Show()

        if not self.Flash then
            self.Flash = self:CreateTexture("$parentFlash", "BACKGROUND", nil, 1)
        end
        self.Flash:SetTexture(R.media.textures.unitFrames.dragonflight.unitFrame)
        self.Flash:SetTexCoord(0.375, 0.75, 0.5234375, 0.78515625)
        self.Flash:ClearAllPoints()
        self.Flash:SetAllPoints()
        self.Flash:Hide()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 13, "OUTLINE")
        self.Name:SetJustifyH("RIGHT")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetPoint("TOPRIGHT", -62, -11)
        self.Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 23, -22)
        self:Tag(self.Name, "[name:sub(20)]")

        if self.NameBackground then
            self.NameBackground:Hide()
        end

        self.Level:Show()
        self.Level:SetFont(self.config.level.font, 13, "OUTLINE")
        self.Level:SetJustifyH("CENTER")
        self.Level:SetShadowOffset(0, 0)

        self.Level:ClearAllPoints()
        self.Level:SetPoint("TOPRIGHT", -161, -11)
        self.Level:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 6, -22)
        self:Tag(self.Level, "[difficultycolor][level]|r")

        self.PortraitHolder.Separator:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.PortraitRound
        self.PortraitHolder:SetSize(60, 60)
        self.PortraitHolder:ClearAllPoints()
        self.PortraitHolder:SetPoint("TOPRIGHT", self, "TOPRIGHT", -3, -2)
        self:EnableElement("Portrait")

        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", -59, -24)
        self.Health:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 5, 22)

        self.Health.Value:SetFont(self.config.health.value.font, 11, "OUTLINE")
        self.Health.Value:SetJustifyH("LEFT")
        self.Health.Value:ClearAllPoints()
        self.Health.Value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)

        self.Health.Percent:SetFont(self.config.health.percent.font, 11, "OUTLINE")
        self.Health.Percent:SetJustifyH("RIGHT")
        self.Health.Percent:ClearAllPoints()
        self.Health.Percent:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPRIGHT", self, "TOPRIGHT", -52, -45)
        self.Power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 5, 11)

        self.Power.Value:SetFont(self.config.power.value.font, 10, "OUTLINE")
        self.Power.Value:SetJustifyH("LEFT")
        self.Power.Value:ClearAllPoints()
        self.Power.Value:SetPoint("LEFT", self.Power, "LEFT", 2, 0)

        self.Power.Percent:SetFont(self.config.power.percent.font, 10, "OUTLINE")
        self.Power.Percent:SetJustifyH("RIGHT")
        self.Power.Percent:ClearAllPoints()
        self.Power.Percent:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)

        self.Power.Border:Hide()
        self.Power.Separator:Hide()

        if self.PvPIndicator then
            self.PvPIndicator:SetSize(32, 32)
            self.PvPIndicator:ClearAllPoints()
            self.PvPIndicator:SetPoint("CENTER", self.Portrait, "RIGHT", 2, 0)
        end

        if self.LeaderIndicator then
            self.LeaderIndicator:SetSize(16, 16)
            self.LeaderIndicator:ClearAllPoints()
            self.LeaderIndicator:SetPoint("CENTER", self.Portrait, "TOP", 22, -6)
        end

        if self.AssistantIndicator then
            self.AssistantIndicator:SetSize(16, 16)
            self.AssistantIndicator:ClearAllPoints()
            self.AssistantIndicator:SetPoint("CENTER", self.Portrait, "TOP", 22, -6)
        end

        if self.MasterLooterIndicator then
            self.MasterLooterIndicator:SetSize(16, 16)
            self.MasterLooterIndicator:ClearAllPoints()
            self.MasterLooterIndicator:SetPoint("CENTER", self.Portrait, "BOTTOM", 0, 0)
        end

        if self.RaidTargetIndicator then
            self.RaidTargetIndicator:SetSize(24, 24)
            self.RaidTargetIndicator:ClearAllPoints()
            self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP")
        end

        if self.GroupRoleIndicator then
            self.GroupRoleIndicator:SetSize(16, 16)
            self.GroupRoleIndicator:ClearAllPoints()
            self.GroupRoleIndicator:SetPoint("CENTER", self.Portrait, "TOP", -22, -6)
        end

        if self.RaidRoleIndicator then
            self.RaidRoleIndicator:SetSize(16, 16)
            self.RaidRoleIndicator:ClearAllPoints()
            self.RaidRoleIndicator:SetPoint("CENTER", self.Portrait, "TOP", -22, -6)
        end

        if self.ReadyCheckIndicator then
            self.ReadyCheckIndicator:SetSize(32, 32)
            self.ReadyCheckIndicator:ClearAllPoints()
            self.ReadyCheckIndicator:SetPoint("CENTER", self.Portrait, "CENTER", 0, 0)
        end

        if self.SummonIndicator then
            self.SummonIndicator:SetSize(32, 32)
            self.SummonIndicator:ClearAllPoints()
            self.SummonIndicator:SetPoint("CENTER", self.Portrait, "CENTER", 0, 0)
        end

        if self.ResurrectIndicator then
            self.ResurrectIndicator:SetSize(32, 32)
            self.ResurrectIndicator:ClearAllPoints()
            self.ResurrectIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
        end

        self.Castbar:ClearAllPoints()
        self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, -5)
        self.Castbar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, -16)
    else
        if self.Artwork then
            self.Artwork:Hide()
        end
        if self.Flash then
            self.Flash:Hide()
        end
        if self.NameBackground then
            self.NameBackground:Hide()
        end
    end
end
