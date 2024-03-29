local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTarget()
    if UF.config.target.enabled then
        if EditModeManagerFrame and EditModeManagerFrame.AccountSettings then
            EditModeManagerFrame.AccountSettings.RefreshTargetAndFocus = nop
            EditModeManagerFrame.AccountSettings.ResetTargetAndFocus = nop
        end
    end

    return UF:SpawnFrame("Target", "target", UF.TargetMixin, UF.config.target, UF.defaults.target)
end

UF.TargetMixin = {}

function UF.TargetMixin:PostInitialize()
    self:RegisterEvent("PLAYER_TARGET_CHANGED", UF.TargetMixin.UpdateArtwork, true)
end

function UF.TargetMixin:PostConfigure()
    if self.config.style == UF.Styles.Vanilla then
        self:SetSize(194, 76)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self.Overlay:CreateTexture("$parentArtwork", "BORDER", nil, 7)
        end
        self.Artwork:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.targetingFrame_LargeHealth or R.media.textures.unitFrames.vanilla.targetingFrame)
        self.Artwork:SetTexCoord(50 / 512, 1, 0, 200 / 256)
        self.Artwork:ClearAllPoints()
        self.Artwork:SetPoint("TOPLEFT", 0, 8.5)
        self.Artwork:SetPoint("BOTTOMRIGHT", 37, -15.5)
        self.Artwork:Show()

        if self.ArtworkChain then
            self.ArtworkChain:Hide()
        end

        if not self.Flash then
            self.Flash = self.Overlay:CreateTexture("$parentFlash", "BACKGROUND", nil, 1)
        end
        self.Flash:SetDrawLayer("BACKGROUND")
        self.Flash:SetTexture(R.media.textures.unitFrames.vanilla.targetingFrame_Flash)
        self.Flash:SetTexCoord(0, 1, 0, 205 / 256)
        self.Flash:ClearAllPoints()
        self.Flash:SetPoint("CENTER", self, "CENTER", 6, -4.5)
        self.Flash:SetSize(256, 103)
        self.Flash:Hide()
        self:UpdateArtwork()

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
        self.Level:SetSize(24, 20)
        self.Level:SetPoint("CENTER", self, "BOTTOMRIGHT", -15, 19)
        self:Tag(self.Level, "[difficultycolor][level]|r")

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

        if not self.config.castbar.overrideStylePosition then
            self.Castbar:ClearAllPoints()
            self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, -5)
            self.Castbar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, -16)
        end

        if self.ComboPointBar then
            self.ComboPointBar:ClearAllPoints()
            self.ComboPointBar:SetPoint("TOP", self.Power, "BOTTOM", 0, 5)
        end
    elseif self.config.style == UF.Styles.Redux or self.config.style == UF.Styles.Modern then
        self:SetSize(192, 67)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self.Overlay:CreateTexture("$parentArtwork", "BORDER", nil, 6)
        end
        self.Artwork:ClearAllPoints()
        self.Artwork:SetAllPoints()
        if self.config.style == UF.Styles.Redux then
            self.Artwork:SetTexture(R.media.textures.unitFrames.redux.unitFrame)
            self.Artwork:SetTexCoord(0, 0.75, 0, 0.26171875)
        else
            self.Artwork:SetTexture(R.media.textures.unitFrames.modern.unitFrame)
            self.Artwork:SetTexCoord(0.375, 0.75, 0, 0.26171875)
        end
        self.Artwork:Show()

        if not self.ArtworkChain then
            self.ArtworkChain = self.Overlay:CreateTexture("$parentChain", "OVERLAY", nil, 2)
            self.ArtworkChain:SetSize(100, 82)
            self.ArtworkChain:SetPoint("RIGHT", 31, 2)
            self.ArtworkChain:SetTexture(R.media.textures.unitFrames.modern.unitFrame)
            self.ArtworkChain:SetTexCoord(0.375, 0.75, 0, 0.26171875)
        end
        self.ArtworkChain:Hide()

        if not self.Flash then
            self.Flash = self.Overlay:CreateTexture("$parentFlash", "OVERLAY", nil, 1)
        end
        self.Flash:SetDrawLayer("OVERLAY")
        if self.config.style == UF.Styles.Redux then
            self.Flash:SetTexture(R.media.textures.unitFrames.redux.unitFrame)
            self.Flash:SetTexCoord(0, 0.75, 0.5234375, 0.78515625)
        else
            self.Flash:SetTexture(R.media.textures.unitFrames.modern.unitFrame)
            self.Flash:SetTexCoord(0.375, 0.75, 0.5234375, 0.78515625)
        end
        self.Flash:ClearAllPoints()
        self.Flash:SetAllPoints()
        self.Flash:Hide()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 12, "OUTLINE")
        self.Name:SetJustifyH("RIGHT")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetPoint("TOPRIGHT", -62, -11)
        self.Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 23, -24)
        self:Tag(self.Name, "[name:sub(20)]")

        if self.NameBackground then
            self.NameBackground:Hide()
        end

        self.Level:Show()
        self.Level:SetFont(self.config.level.font, 12, "OUTLINE")
        self.Level:SetJustifyH("LEFT")
        self.Level:SetShadowOffset(0, 0)

        self.Level:ClearAllPoints()
        self.Level:SetPoint("TOPRIGHT", -165, -11)
        self.Level:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 6, -24)
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

        self.Power.Value:SetFont(self.config.power.value.font, 9, "OUTLINE")
        self.Power.Value:SetJustifyH("LEFT")
        self.Power.Value:ClearAllPoints()
        self.Power.Value:SetPoint("LEFT", self.Power, "LEFT", 2, 0)

        self.Power.Percent:SetFont(self.config.power.percent.font, 9, "OUTLINE")
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

        if not self.config.castbar.overrideStylePosition then
            self.Castbar:ClearAllPoints()
            self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, -5)
            self.Castbar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, -16)
        end

        if self.ComboPointBar then
            self.ComboPointBar:ClearAllPoints()
            self.ComboPointBar:SetPoint("TOP", self.Power, "BOTTOM", 0, 5)
        end
    else
        if self.Artwork then
            self.Artwork:Hide()
        end
        if self.ArtworkChain then
            self.ArtworkChain:Hide()
        end
        if self.Flash then
            self.Flash:Hide()
        end
        if self.NameBackground then
            self.NameBackground:Hide()
        end
    end
end

function UF.TargetMixin:PostUpdate()
    self:UpdateArtwork()
end

function UF.TargetMixin:UpdateArtwork()
    if self.config.style == UF.Styles.Vanilla then
        local classification = UnitClassification("target")
        if classification == "rare" then
            self.Artwork:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.targetingFrame_LargeHealth_Rare or R.media.textures.unitFrames.vanilla.targetingFrame_Rare)
            self.Flash:SetTexture(R.media.textures.unitFrames.vanilla.targetingFrame_Flash)
        elseif classification == "rareelite" then
            self.Artwork:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.targetingFrame_LargeHealth_RareElite or R.media.textures.unitFrames.vanilla.targetingFrame_RareElite)
            self.Flash:SetTexture(R.media.textures.unitFrames.vanilla.targetingFrame_Elite_Flash)
        elseif classification == "elite" then
            self.Artwork:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.targetingFrame_LargeHealth_Elite or R.media.textures.unitFrames.vanilla.targetingFrame_Elite)
            self.Flash:SetTexture(R.media.textures.unitFrames.vanilla.targetingFrame_Elite_Flash)
        else
            self.Artwork:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.targetingFrame_LargeHealth or R.media.textures.unitFrames.vanilla.targetingFrame)
            self.Flash:SetTexture(R.media.textures.unitFrames.vanilla.targetingFrame_Flash)
        end
    elseif self.config.style == UF.Styles.Modern then
        local classification = UnitClassification("target")
        if classification == "rare" then
            self.Artwork:SetTexCoord(0.375, 0.75, 0.26171875, 0.5234375)
            self.ArtworkChain:SetSize(84, 82)
            self.ArtworkChain:SetPoint("RIGHT", 14, 2)
            self.ArtworkChain:SetTexCoord(0.84765625, 0.9296875, 0.34765625, 0.5078125)
            self.ArtworkChain:Show()
        elseif classification == "rareelite" then
            self.Artwork:SetTexCoord(0.375, 0.75, 0.26171875, 0.5234375)
            self.ArtworkChain:SetSize(100, 82)
            self.ArtworkChain:SetPoint("RIGHT", 31, 2)
            self.ArtworkChain:SetTexCoord(0.75, 0.84765625, 0.509765625, 0.669921875)
            self.ArtworkChain:Show()
        elseif classification == "elite" then
            self.Artwork:SetTexCoord(0.375, 0.75, 0, 0.26171875)
            self.ArtworkChain:SetSize(100, 82)
            self.ArtworkChain:SetPoint("RIGHT", 31, 2)
            self.ArtworkChain:SetTexCoord(0.75, 0.84765625, 0.34765625, 0.5078125)
            self.ArtworkChain:Show()
        else
            self.Artwork:SetTexCoord(0.375, 0.75, 0, 0.26171875)
            self.ArtworkChain:Hide()
        end
    elseif self.Artwork and self:IsCustomStyled() then
        self.Artwork:Hide()
    end
end
