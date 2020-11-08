local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnPlayer()
    local config = UF.config.db.profile.player
    local default = Addon.config.defaults.profile.modules.unitFrames.player

    if config.enabled then
        return UF:SpawnFrame("Player", "player", UF.CreatePlayerStyle, config, default)
    end
end

function UF:CreatePlayerStyle()
    -- config
    self.cfg = UF.config.db.profile.player

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint(unpack(self.cfg.point))
    self:SetFrameStrata("LOW")
    self:SetFrameLevel(10)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    -- texture
    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")
    if self.cfg.largerHealth then
        self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth)
    else
        self.Texture:SetTexture(Addon.media.textures.TargetFrame)
    end
    self.Texture:SetTexCoord(1, 0.09375, 0, 0.78125)
    self.Texture:SetSize(232, 100)
    self.Texture:SetPoint("CENTER", self, -20, -7)

    -- health
    UF.CreateHealthBar(self)
    if self.cfg.largerHealth then
        self.Health:SetSize(119, 28)
        self.Health:SetPoint("TOPLEFT", self.Texture, 107, -23)
    else
        self.Health:SetSize(119, 12)
        self.Health:SetPoint("TOPLEFT", self.Texture, 107, -41)
    end

    -- power
    UF.CreatePowerBar(self)
    self.Power:SetHeight(10)

    -- additional power (druid mana)
    if Addon.PlayerClass == "DRUID" then
        UF.CreateAdditionalPowerBar(self)
    end

    -- regen
    UF.CreateEnergyManaRegen(self)

    -- name
    UF.CreateName(self)
    self.Name:SetWidth(110)
    self.Name:SetPoint("CENTER", self.Texture, 50, 19)

    -- level
    UF.CreateLevel(self)
    self.Level:SetPoint("CENTER", self.Texture, "CENTER", -60, -17)

    -- portrait
    UF.CreatePortrait(self)
    self.Portrait:SetSize(64, 64)
    self.Portrait:SetPoint("TOPLEFT", self.Texture, 42, -12)

    -- combat feedback
    if self.cfg.combatfeedback.enabled then
        UF.CreateCombatFeedback(self)
    end

    -- pvp
    UF.CreatePvPIndicator(self)
    self.PvPIndicator:SetPoint("TOPLEFT", self.Texture, 18, -20)

    -- leader
    UF.CreateLeaderIndicator(self)
    self.LeaderIndicator:SetPoint("TOPLEFT", self.Portrait, 3, 2)

    -- assistant
    UF.CreateAssistantIndicator(self)
    self.AssistantIndicator:SetPoint("TOPLEFT", self.Portrait, 3, 2)

    -- master loot
    UF.CreateMasterLooterIndicator(self)
    self.MasterLooterIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)

    -- raid target
    UF.CreateRaidTargetIndicator(self)

    -- phase
    if not UF.IsClassic then
        UF.CreatePhaseIndicator(self)
    end

    -- offline
    UF.CreateOfflineIcon(self)

    -- ready check
    UF.CreateReadyCheckIndicator(self)

    -- role
    if not UF.IsClassic then
        UF.CreateGroupRoleIndicator(self)
        self.GroupRoleIndicator:SetPoint("BOTTOMRIGHT", self.Portrait, -2, -3)
    end

    -- resting
    UF.CreateRestingIndicator(self)

    -- combat
    UF.CreateCombatIndicator(self)

    -- resurrect
    UF.CreateResurrectIndicator(self)

    -- status flash
    UF.CreateStatusFlash(self)

    -- threat glow
    UF.CreateThreatIndicator(self)

    -- group indicator tab
    UF.CreateTab(self)

    -- auras
    if self.cfg.auras.enabled then
        UF.CreateAuras(self)
    end

    -- castbar
    if self.cfg.castbar.enabled then
        UF.CreateCastbar(self)
        if self.cfg.castbar.showIcon and not self.cfg.castbar.showIconOutside then
            local _, height = unpack(self.cfg.castbar.size)
            local leftPadding = height - self.cfg.castbar.borderSize / 2 - 1
            self.Castbar:SetPoint("CENTER", UIParent, "BOTTOM", leftPadding / 2, 160)
        else
            self.Castbar:SetPoint("CENTER", UIParent, "BOTTOM", 0, 160)
        end
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

UF.Player_OnEvent = function(self, event, ...)
    -- in classic, hide additional mana bar in caster form
    if UF.IsClassic and Addon.PlayerClass == "DRUID" and UF.frames.player.AdditionalPower then
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
