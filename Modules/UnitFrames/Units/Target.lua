local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnTarget()
    local config = UF.config.db.profile.target
    local default = Addon.config.defaults.profile.modules.unitFrames.target

    if config.enabled then
        return UF:SpawnFrame("Target", "target", UF.CreateTarget, config, default)
    end
end

function UF:CreateTarget()
    self.cfg = UF.config.db.profile.target

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
    end

    UF.CreateOfflineIcon(self)
    UF.CreateReadyCheckIndicator(self)
    UF.CreateResurrectIndicator(self)

    if not Addon.IsClassic then
        UF.CreateGroupRoleIndicator(self)
        self.GroupRoleIndicator:SetPoint("TOPLEFT", self.Portrait, -10, -2)
    end

    UF.CreateThreatIndicator(self)
    UF.CreateAuras(self)
    UF.CreateCastbar(self)

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

    if not Addon.IsClassic then
        UF.CreateQuestIndicator(self)
    end

    if Addon.IsClassic then
        UF.CreateComboFrame(self)
    end

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

function UF:UpdateTarget()
    local self = UF.frames.target
    if self then
        UF:UpdateFrame(self)

        if UF.config.db.profile.theme == UF.themes.Blizzard or UF.config.db.profile.theme == UF.themes.Blizzard_LargeHealth then
            self.Health:ClearAllPoints()
            self.Health.Value:ClearAllPoints()
            if UF.config.db.profile.theme == UF.themes.Blizzard_LargeHealth then
                self.Health:SetSize(119, 28)
                self.Health:SetPoint("TOPRIGHT", self.Texture, -108, -23)
                self.Health.Value:SetPoint("CENTER", self.Health, 0, -7)
                self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth)
            else
                self.Health:SetSize(119, 12)
                self.Health:SetPoint("TOPRIGHT", self.Texture, -108, -41)
                self.Health.Value:SetPoint("CENTER", self.Health, 0, -7)
                self.Texture:SetTexture(Addon.media.textures.TargetFrame)
            end

            self.Texture:ClearAllPoints()
            self.Texture:SetTexCoord(0.09375, 1, 0, 0.78125)
            self.Texture:SetSize(232, 100)
            self.Texture:SetPoint("CENTER", self, 20, -7)

            self.Power:SetHeight(10)

            self.Name:ClearAllPoints()
            self.Name:SetWidth(110)
            self.Name:SetPoint("CENTER", self.Texture, -50, 19)

            self.Level:ClearAllPoints()
            self.Level:SetPoint("CENTER", self.Texture, "CENTER", 63, -17)

            self.Portrait:ClearAllPoints()
            self.Portrait:SetSize(64, 64)
            self.Portrait:SetPoint("TOPRIGHT", self.Texture, -42, -12)

            self.PvPIndicator:ClearAllPoints()
            self.PvPIndicator:SetPoint("TOPRIGHT", self.Texture, -16, -23)

            self.LeaderIndicator:ClearAllPoints()
            self.LeaderIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)

            self.AssistantIndicator:ClearAllPoints()
            self.AssistantIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)

            self.MasterLooterIndicator:ClearAllPoints()
            self.MasterLooterIndicator:SetPoint("TOPLEFT", self.Portrait, 3, 2)
        
            local leftPadding = 0
            if self.cfg.castbar.showIcon and not self.cfg.castbar.showIconOutside then
                local _, height = unpack(self.cfg.castbar.size)
                leftPadding = height - self.cfg.castbar.borderSize / 2 - 1
            end
        
            self.Castbar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", leftPadding, 5)
            if self.cfg.auras.enabled and self.cfg.auras.showDebuffsOnTop then
                self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5 + self.Castbar:GetHeight() + 5)
            end
        else
            self.Texture:SetTexture(nil)
        end
    end
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
    if UF.config.db.profile.theme == UF.themes.Blizzard or UF.config.db.profile.theme == UF.themes.Blizzard_LargeHealth then
        local classification = UnitClassification(self.unit)

        if UF.config.db.profile.theme == UF.themes.Blizzard_LargeHealth then
            if (classification == "rare") then
                self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth_Rare)
            elseif (classification == "rareelite") then
                self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth_RareElite)
            elseif (classification == "elite" or classification == "worldboss" or classification == "boss") then
                self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth_Elite)
            else
                self.Texture:SetTexture(Addon.media.textures.TargetFrame_LargerHealth)
            end
        else
            if (classification == "rare") then
                self.Texture:SetTexture(Addon.media.textures.TargetFrame_Rare)
            elseif (classification == "rareelite") then
                self.Texture:SetTexture(Addon.media.textures.TargetFrame_RareElite)
            elseif (classification == "elite" or classification == "worldboss" or classification == "boss") then
                self.Texture:SetTexture(Addon.media.textures.TargetFrame_Elite)
            else
                self.Texture:SetTexture(Addon.media.textures.TargetFrame)
            end
        end
    end

    local classification = UnitClassification(self.unit)
end
