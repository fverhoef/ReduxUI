local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTarget()
    local config = UF.config.target
    local default = UF.defaults.target

    if config.enabled then
        return UF:SpawnFrame("Target", "target", UF.CreateTarget, config, default)
    end
end

function UF:CreateTarget()
    self.config = UF.config.target
    self.defaults = UF.defaults.target

    UF:SetupFrame(self)

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")
    self.Texture:SetSize(232, 100)
    self.Texture:SetPoint("CENTER", self, 20, -7)
    self.EliteTexture = self:CreateTexture("$parentFrameEliteTexture", "ARTWORK")
    self.EliteTexture:SetTexture(R.media.textures.unitFrames.targetFrame_Elite)
    self.EliteTexture:SetTexCoord(0.09375, 1, 0, 0.78125)
    self.EliteTexture:SetSize(232, 100)
    self.EliteTexture:SetAllPoints(self.Texture)
    self.RareTexture = self:CreateTexture("$parentFrameRareTexture", "ARTWORK")
    self.RareTexture:SetTexture(R.media.textures.unitFrames.targetFrame_Rare)
    self.RareTexture:SetTexCoord(0.09375, 1, 0, 0.78125)
    self.RareTexture:SetSize(232, 100)
    self.RareTexture:SetAllPoints(self.Texture)
    self.RareEliteTexture = self:CreateTexture("$parentFrameRareEliteTexture", "ARTWORK")
    self.RareEliteTexture:SetTexture(R.media.textures.unitFrames.targetFrame_RareElite)
    self.RareEliteTexture:SetTexCoord(0.09375, 1, 0, 0.78125)
    self.RareEliteTexture:SetSize(232, 100)
    self.RareEliteTexture:SetAllPoints(self.Texture)

    self:CreateRange()
    self:CreateThreatIndicator()

    if R.isClassic then
        self:CreateComboFrame()
    end

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

    self.Update = UF.UpdateTarget
end

function UF:UpdateTarget()
    if not self then
        return
    end

    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
        self.Border:Hide()
        self.Shadow:Hide()

        self:EnableElement("Power")
        self:EnableElement("Portrait")
        self:EnableElement("LeaderIndicator")
        self:EnableElement("AssistantIndicator")
        self:EnableElement("MasterLooterIndicator")

        self:SetSize(180, 42)

        self.Health:ClearAllPoints()
        self.Health.Value:ClearAllPoints()
        self.Power:ClearAllPoints()
        self.Power.Value:ClearAllPoints()
        if UF.config.theme == UF.themes.Blizzard_LargeHealth then
            self.Health:SetSize(119, 28)
            self.Health:SetPoint("TOPRIGHT", self.Texture, -108, -23)
            self.Health.Value:SetPoint("CENTER", self.Health, 0, -7)
            self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -2)
            self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -2)
            self.Texture:SetTexture(R.media.textures.unitFrames.targetFrame_LargerHealth)
            self.Texture:SetTexCoord(0.09375, 1, 0, 0.78125)
        else
            self.Health:SetSize(119, 12)
            self.Health:SetPoint("TOPRIGHT", self.Texture, -108, -41)
            self.Health.Value:SetPoint("CENTER", self.Health, 0, 1)
            self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, 0)
            self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)
            self.Texture:SetTexture(R.media.textures.unitFrames.targetFrame)
            self.Texture:SetTexCoord(0.09375, 1, 0, 0.78125)
        end

        self.Power:SetHeight(10)
        self.Power.Value:SetPoint("CENTER", self.Power, 0, 0)
        self.Power.Border:Hide()
        self.Power.Shadow:Hide()

        self.Name:ClearAllPoints()
        self.Name:SetWidth(110)
        self.Name:SetPoint("CENTER", self.Texture, -50, 19)
        self.Name:SetJustifyH("CENTER")
        self.Name:Show()

        self.Level:ClearAllPoints()
        self.Level:SetSize(20, 10)
        self.Level:SetPoint("CENTER", self.Texture, "CENTER", 62, -16)
        self.Level:SetJustifyH("CENTER")
        self.Level:Show()

        self.Portrait:ClearAllPoints()
        self.Portrait:SetSize(64, 64)
        self.Portrait:SetPoint("TOPRIGHT", self.Texture, -42, -12)
        self.Portrait:SetTexCoord(0, 1, 0, 1)

        self.OfflineIcon:SetSize(64, 64)
        self.OfflineIcon:ClearAllPoints()
        self.OfflineIcon:SetPoint("CENTER", self.Portrait, 0, 0)

        self.PvPIndicator:SetSize(40, 42)
        self.PvPIndicator:ClearAllPoints()
        self.PvPIndicator:SetPoint("TOPRIGHT", self.Texture, -16, -23)

        self.LeaderIndicator:SetSize(16, 16)
        self.LeaderIndicator:ClearAllPoints()
        self.LeaderIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)

        self.AssistantIndicator:SetSize(16, 16)
        self.AssistantIndicator:ClearAllPoints()
        self.AssistantIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)

        self.MasterLooterIndicator:ClearAllPoints()
        self.MasterLooterIndicator:SetSize(14, 14)
        self.MasterLooterIndicator:SetPoint("TOPLEFT", self.Portrait, 3, 2)

        if not R.isClassic then
            self.GroupRoleIndicator:ClearAllPoints()
            self.GroupRoleIndicator:SetPoint("TOPLEFT", self.Portrait, -10, -2)
        end
        self.RaidRoleIndicator:ClearAllPoints()
        self.RaidRoleIndicator:SetPoint("TOPLEFT", self.Portrait, -10, -2)
        
        self.RaidTargetIndicator:ClearAllPoints()
        self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP", 0, -1)
        
        self.ReadyCheckIndicator:ClearAllPoints()
        self.ReadyCheckIndicator:SetPoint("TOPRIGHT", self.Portrait, -7, -7)
        self.ReadyCheckIndicator:SetPoint("BOTTOMLEFT", self.Portrait, 7, 7)

        self.CastbarParent:ClearAllPoints()
        self.CastbarParent:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, 5)
        self.CastbarParent:SetWidth(122)
        if self.config.auras.enabled and self.config.auras.showDebuffsOnTop then
            self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5 + self.CastbarParent:GetHeight() + 5)
        end
    end

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
    if UF:IsBlizzardTheme() then
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
    else
        self.EliteTexture:Hide()
        self.RareTexture:Hide()
        self.RareEliteTexture:Hide()
    end
end
