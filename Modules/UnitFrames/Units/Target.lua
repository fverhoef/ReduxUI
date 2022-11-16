local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTarget()
    return UF:SpawnFrame("Target", "target", TargetMixin, UF.config.target, UF.defaults.target)
end

TargetMixin = {}

function TargetMixin:PostConfigure()
    if self.config.style == UF.Styles.Blizzard then
        self:SetSize(194, 76)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self:CreateTexture("$parentArtwork", "BORDER", nil, 7)
            self.Artwork:SetTexCoord(50 / 512, 438 / 512, 17 / 256, 169 / 256)
            self.Artwork:SetAllPoints()
        end
        if self.config.largeHealth then
            self.Artwork:SetTexture(R.media.textures.unitFrames.targetingFrame_LargeHealth)
        else
            self.Artwork:SetTexture(R.media.textures.unitFrames.targetingFrame)
        end
        self.Artwork:Show()

        if not self.Flash then
            self.Flash = self:CreateTexture("$parentFlash", "BORDER", nil, 1)
            self.Flash:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
            self.Flash:SetTexCoord(16 / 512, 470 / 512, 0 / 1024, 178 / 1024)
            self.Flash:SetPoint("CENTER", self.Artwork, "CENTER", 0, 2)
            self.Flash:SetSize(227, 89)
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

        self.Level:Show()
        self.Level:SetFont(self.config.level.font, 13, "OUTLINE")
        self.Level:SetJustifyH("CENTER")
        self.Level:SetShadowOffset(1, -1)

        self.Level:ClearAllPoints()
        self.Level:SetSize(20, 20)
        self.Level:SetPoint("CENTER", self, "BOTTOMRIGHT", -15, 19)
        self:Tag(self.Level, "[difficultycolor][level][shortclassification]|r")

        if self.PortraitHolder then
            self.PortraitHolder:Hide()
        end

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitRound
        self.Portrait:SetSize(60, 60)
        self.Portrait:ClearAllPoints()
        self.Portrait:SetPoint("TOPRIGHT", self, "TOPRIGHT", -6, -5)
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

        if self.CastbarHolder then
            self.CastbarHolder:SetSize(121, 18)
            self.CastbarHolder:ClearAllPoints()
            self.CastbarHolder:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 4, 12)
        end

        if self.PvPIndicator then
            self.PvPIndicator:SetSize(32, 32)
            self.PvPIndicator:ClearAllPoints()
            self.PvPIndicator:SetPoint("CENTER", self.Portrait, "RIGHT", 2, 0)
        end

        if self.LeaderIndicator then
            self.LeaderIndicator:SetSize(14, 14)
            self.LeaderIndicator:ClearAllPoints()
            self.LeaderIndicator:SetPoint("CENTER", self.Portrait, "TOP", 22, -10)
        end

        if self.MasterLooterIndicator then
            self.MasterLooterIndicator:SetSize(14, 14)
            self.MasterLooterIndicator:ClearAllPoints()
            self.MasterLooterIndicator:SetPoint("CENTER", self.Portrait, "TOP", -22, -10)
        end

        if self.RaidTargetIndicator then
            self.RaidTargetIndicator:SetSize(24, 24)
            self.RaidTargetIndicator:ClearAllPoints()
            self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP")
        end

        if self.GroupRoleIndicator then
            self.GroupRoleIndicator:SetSize(18, 18)
            self.GroupRoleIndicator:ClearAllPoints()
            self.GroupRoleIndicator:SetPoint("CENTER", self.Portrait, "TOP", 18, -14)
        end

        if self.ReadyCheckIndicator then
            self.ReadyCheckIndicator:SetSize(32, 32)
            self.ReadyCheckIndicator:ClearAllPoints()
            self.ReadyCheckIndicator:SetPoint("CENTER", self.Portrait, "CENTER", 0, 0)
        end

        if self.ResurrectIndicator then
            self.ResurrectIndicator:SetSize(32, 32)
            self.ResurrectIndicator:ClearAllPoints()
            self.ResurrectIndicator:SetPoint("CENTER", self.Portrait, "CENTER", 0, 0)
        end

        if self.SummonIndicator then
            self.SummonIndicator:SetSize(32, 32)
            self.SummonIndicator:ClearAllPoints()
            self.SummonIndicator:SetPoint("CENTER", self.Portrait, "CENTER", 0, 0)
        end
    elseif self.configstyle == UF.Styles.Custom then
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
