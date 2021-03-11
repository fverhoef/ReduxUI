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

    self:CreateRange()

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

    self.Update = UF.UpdateTarget
    self.ApplyTheme = UF.Target_ApplyTheme
end

function UF:UpdateTarget()
    if not self then
        return
    end
    
    UF:UpdateFrame(self)
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

    self:UpdateArtwork()
end

function UF:Target_ApplyTheme()
    local theme = UF.config.theme
    local config = UF.config.target
    if theme == UF.themes.Blizzard or theme == UF.themes.Blizzard_LargeHealth then
        config.size = {180, 42}
        config.border.enabled = false
        config.shadow.enabled = false

        config.artwork.enabled = true
        config.artwork.background = config.artwork.background or {}
        if theme == UF.themes.Blizzard_LargeHealth then
            config.artwork.background.texture = R.media.textures.unitFrames.targetFrame_LargerHealth
        else
            config.artwork.background.texture = R.media.textures.unitFrames.targetFrame
        end
        config.artwork.background.coords = {0.09375, 1, 0, 0.78125}
        config.artwork.background.point = {"TOPRIGHT", "TOPRIGHT", 47, 22}
        config.artwork.background.size = {232, 100}
        config.artwork.background.color = {1, 1, 1, 1}

        config.artwork.highlight = config.artwork.highlight or {}
        config.artwork.highlight.texture = R.media.textures.unitFrames.targetFrame_Flash
        config.artwork.highlight.coords = {0, 0.9453125, 0, 0.181640625}
        config.artwork.highlight.point = {"TOPRIGHT", "TOPRIGHT", 33, 21}
        config.artwork.highlight.size = {241, 88}

        config.health.enabled = true
        if theme == UF.themes.Blizzard_LargeHealth then
            config.health.padding = {0, -60, 0, 0}
        else
            config.health.padding = {0, -60, -20, 0}
        end
        config.health.value.enabled = true
        config.health.value.point = {"BOTTOM", "BOTTOM", 0, 0}

        config.power.enabled = true
        config.power.detached = false
        config.power.inset = false
        config.power.size = {150, 12}
        config.power.value.enabled = true
        config.power.value.point = {"CENTER", "CENTER", 0, 0}
        config.power.border.enabled = false
        config.power.shadow.enabled = false
        config.power.gloss.enabled = false

        config.portrait.enabled = true
        config.portrait.round = true
        config.portrait.detached = true
        config.portrait.point = {"RIGHT", "RIGHT", 6, 0}
        config.portrait.size = {64, 64}
        config.portrait.border.enabled = false
        config.portrait.shadow.enabled = false
        config.portrait.gloss.enabled = false

        config.name.enabled = true
        config.name.size = {120, 10}
        config.name.point = {"TOPLEFT", 0, -4}
        config.name.justifyH = "CENTER"

        config.level.enabled = true
        config.level.size = {20, 10}
        config.level.point = {"CENTER", "CENTER", 84, -23}
        config.level.justifyH = "CENTER"

        config.pvpIndicator.enabled = true
        config.pvpIndicator.size = {34, 36}
        config.pvpIndicator.point = {"CENTER", "RIGHT", 4, 0}

        config.leaderIndicator.enabled = true
        config.leaderIndicator.size = {16, 16}
        config.leaderIndicator.point = {"CENTER", "TOPRIGHT", -2, 4}

        config.assistantIndicator.enabled = true
        config.assistantIndicator.size = {16, 16}
        config.assistantIndicator.point = {"CENTER", "TOPRIGHT", -2, 4}

        config.masterLooterIndicator.enabled = true
        config.masterLooterIndicator.size = {14, 14}
        config.masterLooterIndicator.point = {"CENTER", "TOPRIGHT", -52, 4}

        config.raidRoleIndicator.enabled = true
        config.raidRoleIndicator.size = {16, 16}
        config.raidRoleIndicator.point = {"CENTER", "BOTTOMRIGHT", -52, 4}

        config.groupRoleIndicator.enabled = true
        config.groupRoleIndicator.size = {16, 16}
        config.groupRoleIndicator.point = {"CENTER", "BOTTOMRIGHT", -52, 4}

        config.raidTargetIndicator.enabled = true
        config.raidTargetIndicator.size = {24, 24}
        config.raidTargetIndicator.point = {"CENTER", "TOPRIGHT", -27, 8}

        config.offlineIcon.enabled = true
        config.offlineIcon.size = {64, 64}
        config.offlineIcon.point = {"RIGHT", "RIGHT", 0, 0}

        config.readyCheckIndicator.enabled = true
        config.readyCheckIndicator.size = {64, 64}
        config.readyCheckIndicator.point = {"RIGHT", "RIGHT", 0, 0}

        config.castbar.enabled = true
        config.castbar.detached = false
        config.castbar.size = {122, 20}
        config.castbar.attachedPoint = {"BOTTOMLEFT", "TOPLEFT", -2, 5}
    end
end
