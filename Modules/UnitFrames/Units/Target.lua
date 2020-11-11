local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnTarget()
    local config = UF.config.db.profile.target
    local default = Addon.config.defaults.profile.modules.unitFrames.target

    if config.enabled then
        return UF:SpawnFrame("Target", "target", UF.CreateTargetStyle, config, default)
    end
end

function UF:CreateTargetStyle()
    -- config
    self.cfg = UF.config.db.profile.target

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
    self.Texture:SetTexCoord(0.09375, 1, 0, 0.78125)
    self.Texture:SetSize(232, 100)
    self.Texture:SetPoint("CENTER", self, 20, -7)

    -- health
    UF.CreateHealthBar(self)
    if self.cfg.largerHealth then
        self.Health:SetSize(119, 28)
        self.Health:SetPoint("TOPRIGHT", self.Texture, -108, -23)
    else
        self.Health:SetSize(119, 12)
        self.Health:SetPoint("TOPRIGHT", self.Texture, -108, -41)
    end

    -- power
    UF.CreatePowerBar(self)
    self.Power:SetHeight(10)

    -- name
    UF.CreateName(self)
    self.Name:SetWidth(110)
    self.Name:SetPoint("CENTER", self.Texture, -50, 19)

    -- level
    UF.CreateLevel(self)
    self.Level:SetPoint("CENTER", self.Texture, "CENTER", 63, -17)

    -- portrait
    UF.CreatePortrait(self)
    self.Portrait:SetSize(64, 64)
    self.Portrait:SetPoint("TOPRIGHT", self.Texture, -42, -12)

    -- combat feedback
    if self.cfg.combatfeedback.enabled then
        UF.CreateCombatFeedback(self)
    end

    -- pvp
    UF.CreatePvPIndicator(self)
    self.PvPIndicator:SetPoint("TOPRIGHT", self.Texture, -16, -23)

    -- leader
    UF.CreateLeaderIndicator(self)
    self.LeaderIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)

    -- assistant
    UF.CreateAssistantIndicator(self)
    self.AssistantIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)

    -- master loot
    UF.CreateMasterLooterIndicator(self)
    self.MasterLooterIndicator:SetPoint("TOPLEFT", self.Portrait, 3, 2)

    -- raid target
    UF.CreateRaidTargetIndicator(self)

    -- phase
    if not Addon.IsClassic then
        UF.CreatePhaseIndicator(self)
    end

    -- offline
    UF.CreateOfflineIcon(self)

    -- ready check
    UF.CreateReadyCheckIndicator(self)

    -- resurrect
    UF.CreateResurrectIndicator(self)

    -- role
    if not Addon.IsClassic then
        UF.CreateGroupRoleIndicator(self)
        self.GroupRoleIndicator:SetPoint("TOPLEFT", self.Portrait, -10, -2)
    end

    -- threat glow
    UF.CreateThreatIndicator(self)

    -- auras
    if self.cfg.auras.enabled then
        UF.CreateAuras(self)
    end

    -- castbar
    if self.cfg.castbar.enabled then
        UF.CreateCastbar(self)

        local leftPadding = 0
        if self.cfg.castbar.showIcon and not self.cfg.castbar.showIconOutside then
            local _, height = unpack(self.cfg.castbar.size)
            leftPadding = height - self.cfg.castbar.borderSize / 2 - 1
        end

        self.Castbar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", leftPadding, 5)
        if self.cfg.auras.enabled and self.cfg.auras.showDebuffsOnTop then
            self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5 + self.Castbar:GetHeight() + 5)
        end
    end

    -- range check
    self.SpellRange = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
        Update = function(self, inRange)
            if self.fader and not self:IsShown() then
                Addon:StartFadeIn(self, {
                    fadeInAlpha = self.SpellRange[inRange and "insideAlpha" or "outsideAlpha"],
                    fadeInDuration = self.faderConfig.fadeInDuration,
                    fadeInSmooth = self.faderConfig.fadeInSmooth
                })
            else
                self:SetAlpha(self.SpellRange[inRange and "insideAlpha" or "outsideAlpha"])
            end
        end
    }

    -- quest indicator
    if not Addon.IsClassic then
        UF.CreateQuestIndicator(self)
    end

    -- combo points
    UF.CreateComboFrame(self)

    -- register events
    self:RegisterEvent("PLAYER_ENTERING_WORLD", UF.TargetFrame_OnEvent)
    self:RegisterEvent("PLAYER_REGEN_DISABLED", UF.TargetFrame_OnEvent, true)
    self:RegisterEvent("PLAYER_REGEN_ENABLED", UF.TargetFrame_OnEvent, true)
    self:RegisterEvent("PLAYER_TARGET_CHANGED", UF.TargetFrame_OnEvent)
    self:RegisterEvent("UNIT_TARGETABLE_CHANGED", UF.TargetFrame_OnEvent)
    self:RegisterEvent("UNIT_FACTION", UF.TargetFrame_OnEvent)
    self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UF.TargetFrame_OnEvent)
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UF.TargetFrame_OnEvent)
    self:RegisterEvent("UNIT_LEVEL", UF.TargetFrame_OnEvent)
    UF.UpdateTargetFrameTexture(self)
end

UF.TargetFrame_OnEvent = function(self, event)
    if event == "PLAYER_TARGET_CHANGED" then
        if UnitExists(self.unit) and not IsReplacingUnit() then
            if UnitIsEnemy(self.unit, "player") then
                PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
            elseif UnitIsFriend("player", self.unit) then
                PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
            else
                PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
            end
        end
        CloseDropDownMenus()
    end

    UF.UpdateTargetFrameTexture(self)
end

UF.UpdateTargetFrameTexture = function(self)
    local classification = UnitClassification(self.unit)
    if (classification == "rare") then
        if self.cfg.largerHealth then
            self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth_Rare)
        else
            self.Texture:SetTexture(Addon.media.textures.TargetFrame_Rare)
        end
    elseif (classification == "rareelite") then
        if self.cfg.largerHealth then
            self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth_RareElite)
        else
            self.Texture:SetTexture(Addon.media.textures.TargetFrame_RareElite)
        end
    elseif (classification == "elite" or classification == "worldboss" or classification == "boss") then
        if self.cfg.largerHealth then
            self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth_Elite)
        else
            self.Texture:SetTexture(Addon.media.textures.TargetFrame_Elite)
        end
    else
        if self.cfg.largerHealth then
            self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth)
        else
            self.Texture:SetTexture(Addon.media.textures.TargetFrame)
        end
    end
end
