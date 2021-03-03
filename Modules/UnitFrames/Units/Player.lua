local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local CS = R.Modules.CharacterStats
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

    self:CreateAdditionalPower()
    self:CreatePowerPrediction()
    self:CreateEnergyManaRegen()
    
    -- TODO: optionally hide level when combat/resting shows?
    --self:CreateTab()

    -- TODO: replace with oUF class power?
    if not R.isClassic then
        self:CreateComboFrame()
    end

    self:RegisterEvent("GROUP_ROSTER_UPDATE", UF.Player_OnEvent, true)
    self:RegisterEvent("PLAYER_TARGET_CHANGED", UF.Player_OnEvent, true)

    R:CreateDragFrame(self.Power, "Player Power", UF.defaults.player.power.point)
    R:CreateDragFrame(self.CastbarParent, "Player Castbar", UF.defaults.player.castbar.point)

    self.Update = UF.UpdatePlayer
    self.ApplyTheme = UF.Player_ApplyTheme
end

function UF:UpdatePlayer()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end

UF.Player_OnEvent = function(self, event, ...)
    local arg1 = ...
    if event == "GROUP_ROSTER_UPDATE" then
        UF.UpdateTab(self)
    elseif event == "PLAYER_TARGET_CHANGED" then
        UF.frames.target:UpdateArtwork()
    end
end

function UF:Player_ApplyTheme()
    local theme = UF.config.theme
    local config = UF.config.player
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
        config.artwork.background.coords = {1, 0.09375, 0, 0.78125}
        config.artwork.background.point = {"TOPLEFT", "TOPLEFT", -47, 22}
        config.artwork.background.size = {232, 100}
        config.artwork.background.color = {1, 1, 1, 1}

        config.artwork.highlight = config.artwork.highlight or {}
        config.artwork.highlight.texture = R.media.textures.unitFrames.targetFrame_Flash
        config.artwork.highlight.coords = {0.9453125, 0, 0, 0.181640625}
        config.artwork.highlight.point = {"TOPLEFT", "TOPLEFT", -33, 21}
        config.artwork.highlight.size = {241, 88}

        config.health.enabled = true
        if theme == UF.themes.Blizzard_LargeHealth then
            config.health.padding = {60, 0, 0, 0}
        else
            config.health.padding = {60, 0, -20, 0}
        end
        config.health.value.enabled = true
        config.health.value.point = {"BOTTOM", "BOTTOM", 0, 0}

        config.power.enabled = true
        config.power.detached = false
        config.power.size = {150, 12}
        config.power.value.enabled = true
        config.power.value.point = {"CENTER", "CENTER", 0, 0}
        config.power.border.enabled = false
        config.power.shadow.enabled = false

        config.portrait.enabled = true
        config.portrait.round = true
        config.portrait.detached = true
        config.portrait.point = {"LEFT", "LEFT", -6, 0}
        config.portrait.size = {64, 64}
        config.portrait.border.enabled = false

        config.name.enabled = true
        config.name.size = {120, 10}
        config.name.point = {"TOPRIGHT", "TOPRIGHT", 0, -4}
        config.name.justifyH = "CENTER"

        config.level.enabled = true
        config.level.size = {20, 10}
        config.level.point = {"CENTER", "CENTER", -80, -23}
        config.level.justifyH = "CENTER"

        config.pvpIndicator.enabled = true
        config.pvpIndicator.size = {34, 36}
        config.pvpIndicator.point = {"CENTER", "LEFT", -4, 0}

        config.leaderIndicator.enabled = true
        config.leaderIndicator.size = {16, 16}
        config.leaderIndicator.point = {"CENTER", "TOPLEFT", 2, 4}

        config.assistantIndicator.enabled = true
        config.assistantIndicator.size = {16, 16}
        config.assistantIndicator.point = {"CENTER", "TOPLEFT", 2, 4}

        config.masterLooterIndicator.enabled = true
        config.masterLooterIndicator.size = {14, 14}
        config.masterLooterIndicator.point = {"CENTER", "TOPLEFT", 52, 4}

        config.raidRoleIndicator.enabled = true
        config.raidRoleIndicator.size = {16, 16}
        config.raidRoleIndicator.point = {"CENTER", "BOTTOMLEFT", 52, 4}

        config.groupRoleIndicator.enabled = true
        config.groupRoleIndicator.size = {16, 16}
        config.groupRoleIndicator.point = {"CENTER", "BOTTOMLEFT", 52, 4}

        config.raidTargetIndicator.enabled = true
        config.raidTargetIndicator.size = {24, 24}
        config.raidTargetIndicator.point = {"CENTER", "TOPLEFT", 27, 8}

        config.readyCheckIndicator.enabled = true
        config.readyCheckIndicator.size = {64, 64}
        config.readyCheckIndicator.point = {"RIGHT", "RIGHT", 0, 0}

        config.restingIndicator.enabled = true
        config.restingIndicator.size = {31, 31}
        config.restingIndicator.point = {"CENTER", "CENTER", -82, -23}

        config.combatIndicator.enabled = true
        config.combatIndicator.size = {32, 31}
        config.combatIndicator.point = {"CENTER", "CENTER", -80, -23}
    end
end
