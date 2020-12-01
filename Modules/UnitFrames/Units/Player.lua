local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnPlayer()
    local config = UF.config.db.profile.player
    local default = Addon.config.defaults.profile.modules.unitFrames.player

    if config.enabled then
        return UF:SpawnFrame("Player", "player", UF.CreatePlayer, config, default)
    end
end

function UF:CreatePlayer()
    self.cfg = UF.config.db.profile.player

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint(unpack(self.cfg.point))
    self:SetFrameStrata("LOW")
    self:SetFrameLevel(10)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")

    UF.CreateHealth(self)
    UF.CreatePower(self)

    if Addon.PlayerClass == "DRUID" then
        UF.CreateAdditionalPower(self)
    end

    UF.CreatePowerPrediction(self)
    UF.CreateEnergyManaRegen(self)
    UF.CreateName(self)
    UF.CreateLevel(self)
    UF.CreatePortrait(self)
    UF.CreateCombatFeedback(self)

    UF.CreatePvPIndicator(self)
    UF.CreateLeaderIndicator(self)
    UF.CreateAssistantIndicator(self)
    UF.CreateMasterLooterIndicator(self)
    UF.CreateRaidTargetIndicator(self)

    if not Addon.IsClassic then
        UF.CreatePhaseIndicator(self)
        UF.CreateGroupRoleIndicator(self)
    end

    UF.CreateOfflineIcon(self)
    UF.CreateReadyCheckIndicator(self)

    UF.CreateRestingIndicator(self)
    UF.CreateCombatIndicator(self)
    UF.CreateResurrectIndicator(self)
    UF.CreateStatusFlash(self)
    UF.CreateThreatIndicator(self)
    UF.CreateTab(self)

    UF.CreateAuras(self)
    UF.CreateCastbar(self)

    if not Addon.IsClassic then
        UF.CreateComboFrame(self)
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD", UF.Player_OnEvent, true)
    self:RegisterEvent("PLAYER_REGEN_ENABLED", UF.Player_OnEvent, true)
    self:RegisterEvent("PLAYER_REGEN_DISABLED", UF.Player_OnEvent, true)
    self:RegisterEvent("PLAYER_UPDATE_RESTING", UF.Player_OnEvent, true)
    self:RegisterEvent("PLAYER_TARGET_CHANGED", UF.Player_OnEvent, true)
    self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", UF.Player_OnEvent, true)
    self:RegisterEvent("GROUP_ROSTER_UPDATE", UF.Player_OnEvent, true)
    self:RegisterEvent("CINEMATIC_STOP", UF.Player_OnEvent, true)
end

function UF:UpdatePlayer()
    local self = UF.frames.player
    if self then
        UF:UpdateFrame(self)
        
        if UF:IsBlizzardTheme() then
            self.Health:ClearAllPoints()
            self.Health.Value:ClearAllPoints()
            self.Power:ClearAllPoints()
            if UF.config.db.profile.theme == UF.themes.Blizzard_LargeHealth then
                self.Health:SetSize(119, 28)
                self.Health:SetPoint("TOPLEFT", self.Texture, 107, -23)
                self.Health.Value:SetPoint("CENTER", self.Health, 0, -7)
                self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -2)
                self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -2)
                self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth)
                self.StatusFlash:SetTexture(Addon.media.textures.PlayerStatus_LargerHealth)
            else
                self.Health:SetSize(119, 12)
                self.Health:SetPoint("TOPLEFT", self.Texture, 107, -41)
                self.Health.Value:SetPoint("CENTER", self.Health, 0, 1)
                self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, 0)
                self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)
                self.Texture:SetTexture(Addon.media.textures.TargetFrame)
                self.StatusFlash:SetTexture(Addon.media.textures.PlayerStatus)
            end

            self.Texture:ClearAllPoints()
            self.Texture:SetTexCoord(1, 0.09375, 0, 0.78125)
            self.Texture:SetSize(232, 100)
            self.Texture:SetPoint("CENTER", self, -20, -7)

            self.Power:SetHeight(10)
            UF.UpdatePowerPrediction(self)

            self.Name:ClearAllPoints()
            self.Name:SetWidth(110)
            self.Name:SetPoint("CENTER", self.Texture, 50, 19)

            self.Level:ClearAllPoints()
            self.Level:SetPoint("CENTER", self.Texture, "CENTER", -60, -17)

            self.Portrait:ClearAllPoints()
            self.Portrait:SetSize(64, 64)
            self.Portrait:SetPoint("TOPLEFT", self.Texture, 42, -12)

            self.PvPIndicator:ClearAllPoints()
            self.PvPIndicator:SetPoint("TOPLEFT", self.Texture, 18, -20)

            self.LeaderIndicator:ClearAllPoints()
            self.LeaderIndicator:SetPoint("TOPLEFT", self.Portrait, 3, 2)

            self.AssistantIndicator:ClearAllPoints()
            self.AssistantIndicator:SetPoint("TOPLEFT", self.Portrait, 3, 2)

            self.MasterLooterIndicator:ClearAllPoints()
            self.MasterLooterIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)

            if not Addon.IsClassic then
                self.GroupRoleIndicator:SetPoint("BOTTOMRIGHT", self.Portrait, -2, -3)
            end

            self.Castbar:ClearAllPoints()
            if self.cfg.castbar.showIcon and not self.cfg.castbar.showIconOutside then
                local _, height = unpack(self.cfg.castbar.size)
                local leftPadding = height - self.cfg.castbar.borderSize / 2 - 1
                self.Castbar:SetPoint("CENTER", UIParent, "BOTTOM", leftPadding / 2, 160)
            else
                self.Castbar:SetPoint("CENTER", UIParent, "BOTTOM", 0, 160)
            end
        else
            self.Texture:SetTexture(nil)
        end
    end
end

UF.Player_OnEvent = function(self, event, ...)
    -- in classic, hide additional mana bar in caster form
    if Addon.IsClassic and Addon.PlayerClass == "DRUID" and UF.frames.player.AdditionalPower then
        local form = GetShapeshiftForm()
        if form == 1 or form == 3 then
            UF.frames.player.AdditionalPower:Show()
        else
            UF.frames.player.AdditionalPower:Hide()
        end
    end

    if event == "PLAYER_ENTERING_WORLD" then
        UF.UpdateStatusFlash(self)
    elseif event == "PLAYER_REGEN_ENABLED" then
        UF.UpdateStatusFlash(self)
    elseif event == "PLAYER_REGEN_DISABLED" then
        UF.UpdateStatusFlash(self)
    elseif event == "PLAYER_UPDATE_RESTING" then
        UF.UpdateStatusFlash(self)
    elseif event == "CINEMATIC_STOP" then
        UF.UpdateStatusFlash(self)
    elseif event == "GROUP_ROSTER_UPDATE" then
        UF.UpdateTab(self)
    elseif event == "PLAYER_TARGET_CHANGED" then
        UF.UpdateTargetFrameTexture(UF.frames.target)
        if UF.frames.target.SpellRange.ForceUpdate then
            UF.frames.target.SpellRange:ForceUpdate()
        end
    end

    UF.UpdateStatusFlash(self, elapsed)
end
