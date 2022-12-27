local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

local STATUS_REFRESH_RATE = 0.05

function UF:SpawnPlayer()
    if UF.config.player.enabled and UF.config.player.castbar.enabled then
        if EditModeManagerFrame then
            EditModeManagerFrame.AccountSettings.RefreshCastBar = nop
        end
    end
    return UF:SpawnFrame("Player", "player", UF.PlayerMixin, UF.config.player, UF.defaults.player)
end

UF.PlayerMixin = {}

function UF.PlayerMixin:PostInitialize()
    self:CreateAdditionalPower()
    self:CreatePowerPrediction()
    self:CreateCombatIndicator()
    self:CreateRestingIndicator()

    self:CreateClassPower()
    if (R.PlayerInfo.class == "DEATHKNIGHT") then
        self:CreateRunes()
    end
    if (R.PlayerInfo.class == "SHAMAN") then
        self:CreateTotems()
    end
    if (R.PlayerInfo.class == "MONK") then
        self:CreateStagger()
    end

    self.Power:CreateMover("Player Power", self.defaults.power.point)
    self.Castbar:CreateMover("Player Castbar", self.defaults.castbar.point)

    self.isResting = false
    self.inCombat = false
end

function UF.PlayerMixin:PostConfigure()
    self.Castbar:CreateMover("Player Castbar", self.defaults.castbar.point)
    
    self:ConfigureAdditionalPower()
    self:ConfigurePowerPrediction()
    self:ConfigureCombatIndicator()
    self:ConfigureRestingIndicator()

    self:ConfigureClassPower()
    if (R.PlayerInfo.class == "DEATHKNIGHT") then
        self:ConfigureRunes()
    end
    if (R.PlayerInfo.class == "SHAMAN") then
        self:ConfigureTotems()
    end
    if (R.PlayerInfo.class == "MONK") then
        self:ConfigureStagger()
    end

    if self.config.power.detached then
        self.Power.Mover:Unlock()
    else
        self.Power.Mover:Lock(true)
    end    
    if self.config.castbar.detached then
        self.Castbar.Mover:Unlock()
    else
        self.Castbar.Mover:Lock(true)
    end

    if self.config.style == UF.Styles.Vanilla then
        self:SetSize(194, 76)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self.Overlay:CreateTexture("$parentArtwork", "BORDER", nil, 7)
        end
        self.Artwork:ClearAllPoints()
        self.Artwork:SetAllPoints()
        self.Artwork:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.targetingFrame_LargeHealth or R.media.textures.unitFrames.vanilla.targetingFrame)
        self.Artwork:SetTexCoord(438 / 512, 50 / 512, 17 / 256, 169 / 256)
        self.Artwork:Show()

        if not self.Flash then
            self.Flash = self.Overlay:CreateTexture("$parentFlash", "BACKGROUND", nil, 1)
        end
        self.Flash:SetDrawLayer("BACKGROUND")
        self.Flash:SetTexture(R.media.textures.unitFrames.vanilla.targetingFrame_Flash)
        self.Flash:SetTexCoord(1, 0, 0, 205 / 256)
        self.Flash:ClearAllPoints()
        self.Flash:SetPoint("CENTER", self, "CENTER", -6, -4.5)
        self.Flash:SetSize(256, 103)
        self.Flash:Hide()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 13, "OUTLINE")
        self.Name:SetJustifyH(self.config.largeHealth and "LEFT" or "CENTER")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetSize(115, 13)
        if self.config.largeHealth then
            self.Name:SetPoint("TOPLEFT", self, "TOPLEFT", 72, 0)
        else
            self.Name:SetPoint("TOPLEFT", self, "TOPLEFT", 72, -17)
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
        self.Level:SetPoint("CENTER", self, "BOTTOMLEFT", 18, 19)
        self:Tag(self.Level, "[difficultycolor][level]|r")

        self.PortraitHolder.Separator:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.PortraitRound
        self.PortraitHolder:SetSize(60, 60)
        self.PortraitHolder:ClearAllPoints()
        self.PortraitHolder:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -5)
        self:EnableElement("Portrait")

        self.Health:ClearAllPoints()
        if self.config.largeHealth then
            self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", 70, -14)
        else
            self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", 70, -33)
        end
        self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, 32)

        self.Health.Value:SetFont(self.config.health.value.font, 11, "OUTLINE")
        self.Health.Value:SetJustifyH("RIGHT")
        self.Health.Value:ClearAllPoints()
        self.Health.Value:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)

        self.Health.Percent:SetFont(self.config.health.percent.font, 11, "OUTLINE")
        self.Health.Percent:SetJustifyH("LEFT")
        self.Health.Percent:ClearAllPoints()
        self.Health.Percent:SetPoint("LEFT", self.Health, "LEFT", 2, 0)

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPLEFT", self, "TOPLEFT", 70, -45)
        self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, 21)

        self.Power.Value:SetFont(self.config.power.value.font, 11, "OUTLINE")
        self.Power.Value:SetJustifyH("RIGHT")
        self.Power.Value:ClearAllPoints()
        self.Power.Value:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)

        self.Power.Percent:SetFont(self.config.power.percent.font, 11, "OUTLINE")
        self.Power.Percent:SetJustifyH("LEFT")
        self.Power.Percent:ClearAllPoints()
        self.Power.Percent:SetPoint("LEFT", self.Power, "LEFT", 2, 0)

        self.Power.Mover:Lock(true)

        self.Power.Border:Hide()
        self.Power.Separator:Hide()

        if self.AdditionalPower then
            self.AdditionalPower:ClearAllPoints()
            self.AdditionalPower:SetPoint("TOP", self.Power, "BOTTOM", 0, -2)
            self.AdditionalPower:SetSize(104, 10)
            self.AdditionalPower.Border:Hide()

            if not self.AdditionalPower.Background then
                self.AdditionalPower.Background = self.AdditionalPower:CreateTexture("$parentAdditionalPowerBorder", "OVERLAY", nil, 6)
                self.AdditionalPower.Background:SetTexture(R.media.textures.unitFrames.vanilla.additionalPowerBorder)
                self.AdditionalPower.Background:SetTexCoord(0, 232 / 256, 1, 0)
                self.AdditionalPower.Background:SetPoint("TOPLEFT", -6, 0)
                self.AdditionalPower.Background:SetPoint("BOTTOMRIGHT", 6, -6)
            end
            self.AdditionalPower.Background:Show()
        end

        if self.PvPIndicator then
            self.PvPIndicator:SetSize(32, 32)
            self.PvPIndicator:ClearAllPoints()
            self.PvPIndicator:SetPoint("CENTER", self.Portrait, "LEFT", -2, 0)
        end

        if self.LeaderIndicator then
            self.LeaderIndicator:SetSize(16, 16)
            self.LeaderIndicator:ClearAllPoints()
            self.LeaderIndicator:SetPoint("CENTER", self.Portrait, "TOP", -22, -6)
        end

        if self.AssistantIndicator then
            self.AssistantIndicator:SetSize(16, 16)
            self.AssistantIndicator:ClearAllPoints()
            self.AssistantIndicator:SetPoint("CENTER", self.Portrait, "TOP", -22, -6)
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
            self.GroupRoleIndicator:SetPoint("CENTER", self.Portrait, "TOP", 22, -6)
        end

        if self.RaidRoleIndicator then
            self.RaidRoleIndicator:SetSize(16, 16)
            self.RaidRoleIndicator:ClearAllPoints()
            self.RaidRoleIndicator:SetPoint("CENTER", self.Portrait, "TOP", 22, -6)
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

        if self.RestingIndicator then
            self.RestingIndicator:ClearAllPoints()
            self.RestingIndicator:SetPoint("BOTTOM", self, "TOPLEFT", 65, -15)
            self.RestingIndicator:SetSize(32, 32)
        end
    elseif self.config.style == UF.Styles.Modern then
        self:SetSize(192, 67)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self.Overlay:CreateTexture("$parentArtwork", "BORDER", nil, 7)
        end
        self.Artwork:ClearAllPoints()
        self.Artwork:SetAllPoints()
        self.Artwork:SetTexture(R.media.textures.unitFrames.modern.unitFrame)
        self.Artwork:SetTexCoord(0, 0.375, 0, 0.26171875)
        self.Artwork:Show()

        if not self.Flash then
            self.Flash = self.Overlay:CreateTexture("$parentFlash", "OVERLAY", nil, 1)
        end

        self.Flash:SetDrawLayer("OVERLAY")
        self.Flash:SetTexture(R.media.textures.unitFrames.modern.unitFrame)
        self.Flash:SetTexCoord(0, 0.375, 0.5234375, 0.78515625) -- Flash
        --self.Flash:SetTexCoord(0, 0.375, 0.26171875, 0.5234375) -- Status 
        self.Flash:ClearAllPoints()
        self.Flash:SetAllPoints()
        self.Flash:Hide()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 12, "OUTLINE")
        self.Name:SetJustifyH("LEFT")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetPoint("TOPLEFT", 63, -11)
        self.Name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -23, -24)
        self:Tag(self.Name, "[name:sub(20)]")

        if self.NameBackground then
            self.NameBackground:Hide()
        end

        self.Level:Show()
        self.Level:SetFont(self.config.level.font, 12, "OUTLINE")
        self.Level:SetJustifyH("RIGHT")
        self.Level:SetShadowOffset(0, 0)

        self.Level:ClearAllPoints()
        self.Level:SetPoint("TOPLEFT", 165, -11)
        self.Level:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -4, -24)
        self:Tag(self.Level, "[difficultycolor][level]|r")

        self.PortraitHolder.Separator:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.PortraitMasked
        self.PortraitHolder:SetSize(60, 60)
        self.PortraitHolder:ClearAllPoints()
        self.PortraitHolder:SetPoint("TOPLEFT", self, "TOPLEFT", 4, -2)
        self.PortraitHolder.PortraitMaskedCornerIcon:Show()
        self:EnableElement("Portrait")

        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", 61, -24)
        self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, 22)

        self.Health.Value:SetFont(self.config.health.value.font, 11, "OUTLINE")
        self.Health.Value:SetJustifyH("RIGHT")
        self.Health.Value:ClearAllPoints()
        self.Health.Value:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)

        self.Health.Percent:SetFont(self.config.health.percent.font, 11, "OUTLINE")
        self.Health.Percent:SetJustifyH("LEFT")
        self.Health.Percent:ClearAllPoints()
        self.Health.Percent:SetPoint("LEFT", self.Health, "LEFT", 2, 0)

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPLEFT", self, "TOPLEFT", 61, -45)
        self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, 11)

        self.Power.Value:SetFont(self.config.power.value.font, 9, "OUTLINE")
        self.Power.Value:SetJustifyH("RIGHT")
        self.Power.Value:ClearAllPoints()
        self.Power.Value:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)

        self.Power.Percent:SetFont(self.config.power.percent.font, 9, "OUTLINE")
        self.Power.Percent:SetJustifyH("LEFT")
        self.Power.Percent:ClearAllPoints()
        self.Power.Percent:SetPoint("LEFT", self.Power, "LEFT", 2, 0)

        self.Power.Mover:Lock(true)
        
        self.Power.Border:Hide()
        self.Power.Separator:Hide()

        if self.AdditionalPower then
            -- TODO: Style for Modern frames
            self.AdditionalPower:ClearAllPoints()
            self.AdditionalPower:SetPoint("TOP", self.Power, "BOTTOM", 0, -2)
            self.AdditionalPower:SetSize(104, 10)
            self.AdditionalPower.Border:Hide()

            if not self.AdditionalPower.Background then
                self.AdditionalPower.Background = self.AdditionalPower:CreateTexture("$parentAdditionalPowerBorder", "OVERLAY", nil, 6)
                self.AdditionalPower.Background:SetTexture(R.media.textures.unitFrames.vanilla.additionalPowerBorder)
                self.AdditionalPower.Background:SetTexCoord(0, 232 / 256, 1, 0)
                self.AdditionalPower.Background:SetPoint("TOPLEFT", -6, 0)
                self.AdditionalPower.Background:SetPoint("BOTTOMRIGHT", 6, -6)
            end
            self.AdditionalPower.Background:Show()
        end

        if self.PvPIndicator then
            self.PvPIndicator:SetSize(32, 32)
            self.PvPIndicator:ClearAllPoints()
            self.PvPIndicator:SetPoint("CENTER", self.Portrait, "LEFT", -2, 0)
        end

        if self.LeaderIndicator then
            self.LeaderIndicator:SetSize(16, 16)
            self.LeaderIndicator:ClearAllPoints()
            self.LeaderIndicator:SetPoint("CENTER", self.Portrait, "TOP", -22, -6)
        end

        if self.AssistantIndicator then
            self.AssistantIndicator:SetSize(16, 16)
            self.AssistantIndicator:ClearAllPoints()
            self.AssistantIndicator:SetPoint("CENTER", self.Portrait, "TOP", -22, -6)
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
            self.GroupRoleIndicator:SetPoint("CENTER", self.Portrait, "TOP", 22, -6)
        end

        if self.RaidRoleIndicator then
            self.RaidRoleIndicator:SetSize(16, 16)
            self.RaidRoleIndicator:ClearAllPoints()
            self.RaidRoleIndicator:SetPoint("CENTER", self.Portrait, "TOP", 22, -6)
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

        if self.RestingIndicator then
            self.RestingIndicator:ClearAllPoints()
            self.RestingIndicator:SetPoint("BOTTOM", self, "TOPLEFT", 65, -15)
            self.RestingIndicator:SetSize(32, 32)
        end
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
        if self.AdditionalPower then
            if self.AdditionalPower.Background then
                self.AdditionalPower.Background:Hide()
            end
            self.AdditionalPower.Border:Show()
        end
    end
end
