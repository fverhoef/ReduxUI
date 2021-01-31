local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTarget()
    local config = R.config.db.profile.modules.unitFrames.target
    local default = R.config.defaults.profile.modules.unitFrames.target

    if config.enabled then
        return UF:SpawnFrame("Target", "target", UF.CreateTarget, config, default)
    end
end

function UF:CreateTarget()
    self.cfg = R.config.db.profile.modules.unitFrames.target

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint(unpack(self.cfg.point))
    self:SetFrameStrata("LOW")
    self:SetFrameLevel(10)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")
    self.EliteTexture = self:CreateTexture("$parentFrameEliteTexture", "ARTWORK")
    self.EliteTexture:SetTexture(R.media.textures.unitFrames.targetFrame_Elite)
    self.RareTexture = self:CreateTexture("$parentFrameRareTexture", "ARTWORK")
    self.RareTexture:SetTexture(R.media.textures.unitFrames.targetFrame_Rare)
    self.RareEliteTexture = self:CreateTexture("$parentFrameRareEliteTexture", "ARTWORK")
    self.RareEliteTexture:SetTexture(R.media.textures.unitFrames.targetFrame_RareElite)

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
    UF.CreateRaidRoleIndicator(self)
    UF.CreateRaidTargetIndicator(self)

    if not R.isClassic then
        UF.CreatePhaseIndicator(self)
    end

    UF.CreateOfflineIcon(self)
    UF.CreateReadyCheckIndicator(self)
    UF.CreateResurrectIndicator(self)

    if not R.isClassic then
        UF.CreateGroupRoleIndicator(self)
    end

    UF.CreateThreatIndicator(self)
    UF.CreateAuras(self)
    UF.CreateCastbar(self)

    self.Range = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
        Update = function(self, inRange, checkedRange, connected)
            if self.fader and not self:IsShown() then
                R:StartFadeIn(self, {
                    fadeInAlpha = self.Range[inRange and "insideAlpha" or "outsideAlpha"],
                    fadeInDuration = self.faderConfig.fadeInDuration,
                    fadeInSmooth = self.faderConfig.fadeInSmooth
                })
            else
                self:SetAlpha(self.Range[inRange and "insideAlpha" or "outsideAlpha"])
            end
        end
    }

    if not R.isClassic then
        UF.CreateQuestIndicator(self)
    end

    if R.isClassic then
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

        if UF:IsBlizzardTheme() then
            self.Health:ClearAllPoints()
            self.Health.Value:ClearAllPoints()
            if R.config.db.profile.modules.unitFrames.theme == UF.themes.Blizzard_LargeHealth then
                self.Health:SetSize(119, 28)
                self.Health:SetPoint("TOPRIGHT", self.Texture, -108, -23)
                self.Health.Value:SetPoint("CENTER", self.Health, 0, -7)
                self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -2)
                self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -2)
                self.Texture:SetTexture(R.media.textures.unitFrames.targetFrame_LargerHealth)
            else
                self.Health:SetSize(119, 12)
                self.Health:SetPoint("TOPRIGHT", self.Texture, -108, -41)
                self.Health.Value:SetPoint("CENTER", self.Health, 0, -7)
                self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, 0)
                self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)
                self.Texture:SetTexture(R.media.textures.unitFrames.targetFrame)
            end

            self.Texture:ClearAllPoints()
            self.Texture:SetTexCoord(0.09375, 1, 0, 0.78125)
            self.Texture:SetSize(232, 100)
            self.Texture:SetPoint("CENTER", self, 20, -7)
            self.RareTexture:ClearAllPoints()
            self.RareTexture:SetTexCoord(0.09375, 1, 0, 0.78125)
            self.RareTexture:SetSize(232, 100)
            self.RareTexture:SetAllPoints(self.Texture)
            self.EliteTexture:ClearAllPoints()
            self.EliteTexture:SetTexCoord(0.09375, 1, 0, 0.78125)
            self.EliteTexture:SetSize(232, 100)
            self.EliteTexture:SetAllPoints(self.Texture)
            self.RareEliteTexture:ClearAllPoints()
            self.RareEliteTexture:SetTexCoord(0.09375, 1, 0, 0.78125)
            self.RareEliteTexture:SetSize(232, 100)
            self.RareEliteTexture:SetAllPoints(self.Texture)

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

            if not R.isClassic then
                self.GroupRoleIndicator:ClearAllPoints()
                self.GroupRoleIndicator:SetPoint("TOPLEFT", self.Portrait, -10, -2)
            end
            self.RaidRoleIndicator:ClearAllPoints()
            self.RaidRoleIndicator:SetPoint("TOPLEFT", self.Portrait, -10, -2)
        
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
    if R.config.db.profile.modules.unitFrames.theme == UF.themes.Blizzard or R.config.db.profile.modules.unitFrames.theme == UF.themes.Blizzard_LargeHealth then
        local classification = UnitClassification(self.unit)
        if (classification == "rare") then
            self.RareTexture:Show()
            self.EliteTexture:Hide()
            self.RareEliteTexture:Hide()
        elseif (classification == "rareelite") then
            self.RareEliteTexture:Show()
            self.EliteTexture:Hide()
            self.RareTexture:Hide()
        elseif (classification == "elite" or classification == "worldboss" or classification == "boss") then
            self.EliteTexture:Show()
            self.RareTexture:Hide()
            self.RareEliteTexture:Hide()
        else
            self.EliteTexture:Hide()
            self.RareTexture:Hide()
            self.RareEliteTexture:Hide()
        end
    end

    local classification = UnitClassification(self.unit)
end
