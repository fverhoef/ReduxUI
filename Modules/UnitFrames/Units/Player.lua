local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPlayer()
    local config = UF.config.player
    local default = UF.defaults.player

    if config.enabled then
        return UF:SpawnFrame("Player", "player", UF.CreatePlayer, config, default)
    end
end

function UF:CreatePlayer()
    self.config = UF.config.player
    self.defaults = UF.defaults.player

    UF:SetupFrame(self)

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")

    self:CreateAdditionalPower()
    self:CreatePowerPrediction()
    self:CreateEnergyManaRegen()

    self.RestingIndicator.PostUpdate = function()
        self.RestingIndicator.Glow:SetShown(self.RestingIndicator:IsShown())
        if UF:IsBlizzardTheme() and (self.RestingIndicator:IsShown() or self.CombatIndicator:IsShown()) then
            self.Level:SetAlpha(0.01)
        else
            self.Level:SetAlpha(1)
        end
    end
    self.CombatIndicator.PostUpdate = function()
        self.CombatIndicator.Glow:SetShown(self.CombatIndicator:IsShown())
        if UF:IsBlizzardTheme() and (self.RestingIndicator:IsShown() or self.CombatIndicator:IsShown()) then
            self.Level:SetAlpha(0.01)
        else
            self.Level:SetAlpha(1)
        end
    end
    
    -- UF.CreateStatusFlash(self)
    self:CreateTab()
    self:CreateThreatIndicator()

    -- TODO: replace with oUF class power?
    if not R.isClassic then
        self:CreateComboFrame()
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD", UF.Player_OnEvent, true)
    self:RegisterEvent("PLAYER_REGEN_ENABLED", UF.Player_OnEvent, true)
    self:RegisterEvent("PLAYER_REGEN_DISABLED", UF.Player_OnEvent, true)
    self:RegisterEvent("PLAYER_UPDATE_RESTING", UF.Player_OnEvent, true)
    self:RegisterEvent("PLAYER_TARGET_CHANGED", UF.Player_OnEvent, true)
    self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", UF.Player_OnEvent, true)
    self:RegisterEvent("GROUP_ROSTER_UPDATE", UF.Player_OnEvent, true)
    self:RegisterEvent("CINEMATIC_STOP", UF.Player_OnEvent, true)

    R:CreateDragFrame(self.Power, "Player Power", UF.defaults.player.power.point)
    R:CreateDragFrame(self.CastbarParent, "Player Castbar", UF.defaults.player.castbar.point)

    self.Update = UF.UpdatePlayer
end

function UF:UpdatePlayer()
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
            self.Health:SetPoint("TOPLEFT", self.Texture, 107, -23)
            self.Health.Value:SetPoint("CENTER", self.Health, 0, -7)
            self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -2)
            self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -2)
            self.Power.Value:SetPoint("CENTER", self.Power, 0, 0)
            self.Texture:SetTexture(R.media.textures.unitFrames.targetFrame_LargerHealth)
            if self.StatusFlash then
                self.StatusFlash:SetTexture(R.media.textures.unitFrames.playerStatus_LargerHealth)
            end
        else
            self.Health:SetSize(119, 12)
            self.Health:SetPoint("TOPLEFT", self.Texture, 107, -41)
            self.Health.Value:SetPoint("CENTER", self.Health, 0, 1)
            self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, 0)
            self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)
            self.Power.Value:SetPoint("CENTER", self.Power, 0, 0)
            self.Texture:SetTexture(R.media.textures.unitFrames.targetFrame)
            if self.StatusFlash then
                self.StatusFlash:SetTexture(R.media.textures.unitFrames.playerStatus)
            end
        end

        self.Texture:ClearAllPoints()
        self.Texture:SetTexCoord(1, 0.09375, 0, 0.78125)
        self.Texture:SetSize(232, 100)
        self.Texture:SetPoint("CENTER", self, -20, -7)

        self.Power:SetHeight(10)
        self.Power.Border:Hide()
        self.Power.Shadow:Hide()
        UF.UpdatePowerPrediction(self)

        self.Name:ClearAllPoints()
        self.Name:SetWidth(110)
        self.Name:SetPoint("CENTER", self.Texture, 50, 19)
        self.Name:SetJustifyH("CENTER")
        self.Name:Show()

        self.Level:ClearAllPoints()
        self.Level:SetSize(20, 10)
        self.Level:SetPoint("CENTER", self.Texture, "CENTER", -60, -16)
        self.Level:SetJustifyH("CENTER")
        self.Level:Show()

        self.Portrait:ClearAllPoints()
        self.Portrait:SetSize(64, 64)
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 42, -12)
        self.Portrait:SetTexCoord(0, 1, 0, 1)

        self.PvPIndicator:SetSize(40, 42)
        self.PvPIndicator:ClearAllPoints()
        self.PvPIndicator:SetPoint("TOPLEFT", self.Texture, 18, -20)

        self.LeaderIndicator:SetSize(16, 16)
        self.LeaderIndicator:ClearAllPoints()
        self.LeaderIndicator:SetPoint("TOPLEFT", self.Portrait, 3, 2)

        self.AssistantIndicator:SetSize(16, 16)
        self.AssistantIndicator:ClearAllPoints()
        self.AssistantIndicator:SetPoint("TOPLEFT", self.Portrait, 3, 2)

        self.MasterLooterIndicator:SetSize(14, 14)
        self.MasterLooterIndicator:ClearAllPoints()
        self.MasterLooterIndicator:SetPoint("TOPRIGHT", self.Portrait, -3, 2)

        if not R.isClassic then
            self.GroupRoleIndicator:ClearAllPoints()
            self.GroupRoleIndicator:SetPoint("TOPRIGHT", self.Portrait, 10, -2)
        end
        self.RaidRoleIndicator:ClearAllPoints()
        self.RaidRoleIndicator:SetPoint("TOPRIGHT", self.Portrait, 10, -2)
        
        self.RaidTargetIndicator:ClearAllPoints()
        self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP", 0, -1)
        
        self.ReadyCheckIndicator:ClearAllPoints()
        self.ReadyCheckIndicator:SetPoint("TOPRIGHT", self.Portrait, -7, -7)
        self.ReadyCheckIndicator:SetPoint("BOTTOMLEFT", self.Portrait, 7, 7)
        
        self.RestingIndicator:ClearAllPoints()
        self.RestingIndicator:SetPoint("TOPLEFT", self.Texture, 39, -50)
        self.RestingIndicator:SetSize(31, 31)
        
        self.CombatIndicator:ClearAllPoints()
        self.CombatIndicator:SetPoint("TOPLEFT", self.RestingIndicator, 1, 1)
        self.CombatIndicator:SetSize(32, 31)
    end
end

UF.Player_OnEvent = function(self, event, ...)
    -- in classic, hide additional mana bar in caster form
    if R.isClassic and R.PlayerClass == "DRUID" and self.AdditionalPower then
        local form = GetShapeshiftForm()
        if form == 1 or form == 3 then
            self.AdditionalPower:Show()
        else
            self.AdditionalPower:Hide()
        end
    end

    local arg1 = ...
    if event == "UNIT_LEVEL" and arg1 == self.unit then
        UF.UpdateStatusFlashVisibility(self)
    elseif event == "PLAYER_ENTERING_WORLD" then
        self.inCombat = nil
        self.onHateList = nil
        UF.UpdateStatusFlashVisibility(self)
    elseif event == "PLAYER_ENTER_COMBAT" then
        self.inCombat = 1
        UF.UpdateStatusFlashVisibility(self)
    elseif event == "PLAYER_LEAVE_COMBAT" then
        self.inCombat = nil
        UF.UpdateStatusFlashVisibility(self)
    elseif event == "PLAYER_REGEN_DISABLED" then
        self.onHateList = 1
        UF.UpdateStatusFlashVisibility(self)
    elseif event == "PLAYER_REGEN_ENABLED" then
        self.onHateList = nil
        UF.UpdateStatusFlashVisibility(self)
    elseif event == "PLAYER_UPDATE_RESTING" then
        UF.UpdateStatusFlashVisibility(self)
    elseif event == "CINEMATIC_STOP" then
        UF.UpdateStatusFlashVisibility(self)
    elseif event == "GROUP_ROSTER_UPDATE" then
        UF.UpdateTab(self)
    elseif event == "PLAYER_TARGET_CHANGED" then
        UF.UpdateTargetFrameTexture(UF.frames.target)
    end
end
