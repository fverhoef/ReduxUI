local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

local STATUS_REFRESH_RATE = 0.05

function UF:SpawnPlayer()
    return UF:SpawnFrame("Player", "player", PlayerMixin, UF.config.player, UF.defaults.player)
end

PlayerMixin = {}

function PlayerMixin:PostInitialize()
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

    self.Power:CreateMover("PlayerPower", self.defaults.power.point)
    self.CastbarHolder:CreateMover("PlayerCastbar", self.defaults.castbar.point)

    self.isResting = false
    self.inCombat = false
    self.statusCounter = 0
    self.statusSign = -1
    self.statusTextureTimer = UF:ScheduleRepeatingTimer(PlayerMixin.UpdateStatusTexture, STATUS_REFRESH_RATE, self)
end

function PlayerMixin:PostConfigure()
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
        self.CastbarHolder.Mover:Unlock()
    else
        self.CastbarHolder.Mover:Lock(true)
    end

    if self.config.style == UF.Styles.Blizzard then
        self:SetSize(194, 76)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self:CreateTexture("$parentArtwork", "BORDER", nil, 7)
            self.Artwork:SetTexCoord(438 / 512, 50 / 512, 17 / 256, 169 / 256)
            self.Artwork:SetAllPoints()
        end
        self.Artwork:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.targetingFrame_LargeHealth or R.media.textures.unitFrames.targetingFrame)
        self.Artwork:Show()

        if not self.Flash then
            self.Flash = self:CreateTexture("$parentFlash", "BORDER", nil, 1)
            self.Flash:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
            self.Flash:SetTexCoord(470 / 512, 16 / 512, 0 / 1024, 178 / 1024)
            self.Flash:SetPoint("CENTER", self.Artwork, "CENTER", 0, 2)
            self.Flash:SetSize(227, 89)
        end
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

        if self.PortraitHolder then
            self.PortraitHolder:Hide()
        end

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitRound
        self.Portrait:SetSize(60, 60)
        self.Portrait:ClearAllPoints()
        self.Portrait:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -5)
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

        if self.AdditionalPower then
            self.AdditionalPower:ClearAllPoints()
            self.AdditionalPower:SetPoint("TOP", self.Power, "BOTTOM", 0, -2)
            self.AdditionalPower:SetSize(104, 10)
            self.AdditionalPower.Border:Hide()

            if not self.AdditionalPower.Background then
                self.AdditionalPower.Background = self.AdditionalPower:CreateTexture("$parentAdditionalPowerBorder", "OVERLAY", nil, 6)
                self.AdditionalPower.Background:SetTexture(R.media.textures.unitFrames.additionalPowerBorder)
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
            self.LeaderIndicator:SetSize(14, 14)
            self.LeaderIndicator:ClearAllPoints()
            self.LeaderIndicator:SetPoint("CENTER", self.Portrait, "TOP", -22, -10)
        end

        if self.MasterLooterIndicator then
            self.MasterLooterIndicator:SetSize(14, 14)
            self.MasterLooterIndicator:ClearAllPoints()
            self.MasterLooterIndicator:SetPoint("CENTER", self.Portrait, "TOP", 22, -10)
        end

        if self.RaidTargetIndicator then
            self.RaidTargetIndicator:SetSize(24, 24)
            self.RaidTargetIndicator:ClearAllPoints()
            self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP")
        end

        if self.GroupRoleIndicator then
            self.GroupRoleIndicator:SetSize(18, 18)
            self.GroupRoleIndicator:ClearAllPoints()
            self.GroupRoleIndicator:SetPoint("CENTER", self.Portrait, "TOP", -18, -14)
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
            self.ResurrectIndicator:SetPoint("CENTER", self.Portrait, "CENTER", 0, 0)
        end

        if self.RestingIndicator then
            self.RestingIndicator:ClearAllPoints()
            self.RestingIndicator:SetPoint("BOTTOM", self, "TOPLEFT", 65, -15)
            self.RestingIndicator:SetSize(32, 32)
        end
    elseif self.config.style == UF.Styles.Custom then
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

function PlayerMixin:UpdateStatusTexture()
    if not self.Flash or not self.Flash:IsShown() then
        return
    end

    if self.config.style == UF.Styles.Custom then
        self.Flash:SetAlpha(0)
        self.Flash:Hide()
        return
    end

    local alpha = 255
    local counter = self.statusCounter + STATUS_REFRESH_RATE
    local sign = self.statusSign

    if counter > 0.5 then
        sign = -sign
        self.statusSign = sign
    end
    counter = mod(counter, 0.5)
    self.statusCounter = counter

    if sign == 1 then
        alpha = (55 + (counter * 400)) / 255
    else
        alpha = (255 - (counter * 400)) / 255
    end

    self.Flash:SetAlpha(alpha)
end
