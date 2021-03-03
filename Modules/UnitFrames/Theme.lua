local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:Player_ApplyTheme(theme)
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

function UF:Target_ApplyTheme(theme)
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
        config.power.size = {150, 12}
        config.power.value.enabled = true
        config.power.value.point = {"CENTER", "CENTER", 0, 0}
        config.power.border.enabled = false
        config.power.shadow.enabled = false

        config.portrait.enabled = true
        config.portrait.round = true
        config.portrait.detached = true
        config.portrait.point = {"RIGHT", "RIGHT", 6, 0}
        config.portrait.size = {64, 64}
        config.portrait.border.enabled = false

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

function UF:TargetTarget_ApplyTheme(theme)
    local config = UF.config.targettarget
    if theme == UF.themes.Blizzard or theme == UF.themes.Blizzard_LargeHealth then
        config.size = {95, 45}
        config.border.enabled = false
        config.shadow.enabled = false

        config.artwork.enabled = true
        config.artwork.background = config.artwork.background or {}
        config.artwork.background.texture = R.media.textures.unitFrames.targetTargetFrame
        config.artwork.background.coords = {0.015625, 0.7265625, 0, 0.703125}
        config.artwork.background.point = {"CENTER", "CENTER", 0, 0}
        config.artwork.background.size = {95, 45}
        config.artwork.background.color = {1, 1, 1, 1}

        config.health.enabled = true
        config.health.padding = {47, 0, -15, 15}
        config.health.value.enabled = false

        config.power.enabled = true
        config.power.padding = {0, 0, 0, 15}
        config.power.detached = false
        config.power.size = {95, 7}
        config.power.value.enabled = false

        config.portrait.enabled = true
        config.portrait.round = true
        config.portrait.detached = true
        config.portrait.point = {"LEFT", "LEFT", 6, 0}
        config.portrait.size = {35, 35}
        config.portrait.border.enabled = false

        config.name.enabled = true
        config.name.size = {120, 10}
        config.name.point = {"TOPLEFT", "TOPLEFT", 48, -4}
        config.name.fontSize = 11
        config.name.justifyH = "LEFT"

        config.level.enabled = false

        config.raidTargetIndicator.enabled = true
        config.raidTargetIndicator.size = {24, 24}
        config.raidTargetIndicator.point = {"CENTER", "TOPRIGHT", -27, 8}

        config.castbar.enabled = false
    end
end

function UF:Pet_ApplyTheme(theme)
    local config = UF.config.pet
    if theme == UF.themes.Blizzard or theme == UF.themes.Blizzard_LargeHealth then
        config.size = {180, 42}
        config.border.enabled = false
        config.shadow.enabled = false

        config.artwork.enabled = true
        config.artwork.background = config.artwork.background or {}
        config.artwork.background.texture = R.media.textures.unitFrames.smallTargetingFrame
        config.artwork.background.coords = {0, 1, 0, 1}
        config.artwork.background.point = {"TOPLEFT", "TOPLEFT", 0, -2}
        config.artwork.background.size = {128, 64}
        config.artwork.background.color = {1, 1, 1, 1}

        config.artwork.highlight = config.artwork.highlight or {}
        config.artwork.highlight.texture = R.media.textures.unitFrames.partyFrame_Flash
        config.artwork.highlight.coords = {0, 1, 1, 0}
        config.artwork.highlight.point = {"TOPLEFT", "TOPLEFT", 0, -2}
        config.artwork.highlight.size = {241, 88}

        config.health.enabled = true
        config.health.padding = {0, -60, -20, 0}
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
        config.portrait.point = {"RIGHT", "RIGHT", 6, 0}
        config.portrait.size = {64, 64}
        config.portrait.border.enabled = false

        config.name.enabled = true
        config.name.size = {120, 10}
        config.name.point = {"TOPLEFT", 0, -4}
        config.name.justifyH = "CENTER"

        config.level.enabled = true
        config.level.size = {20, 10}
        config.level.point = {"CENTER", "CENTER", 84, -23}
        config.level.justifyH = "CENTER"

        config.raidTargetIndicator.enabled = true
        config.raidTargetIndicator.size = {24, 24}
        config.raidTargetIndicator.point = {"CENTER", "TOPRIGHT", -27, 8}

        config.castbar.enabled = true
        config.castbar.detached = false
        config.castbar.size = {122, 20}
        config.castbar.attachedPoint = {"BOTTOMLEFT", "TOPLEFT", -2, 5}
    end
end

function UF:Party_ApplyTheme(theme)
    local config = UF.config.party
    if theme == UF.themes.Blizzard or theme == UF.themes.Blizzard_LargeHealth then
        config.size = {110, 40}
        config.border.enabled = false
        config.shadow.enabled = false

        config.artwork.enabled = true
        config.artwork.background = config.artwork.background or {}
        config.artwork.background.texture = R.media.textures.unitFrames.partyFrame
        config.artwork.background.coords = {0, 1, 0, 1}
        config.artwork.background.point = {"TOPLEFT", "TOPLEFT", -8, 0}
        config.artwork.background.size = {128, 64}
        config.artwork.background.color = {1, 1, 1, 1}

        config.artwork.highlight = config.artwork.highlight or {}
        config.artwork.highlight.texture = R.media.textures.unitFrames.partyFrame_Flash
        config.artwork.highlight.coords = {0, 1, 0, 1}
        config.artwork.highlight.point = {"TOPLEFT", "TOPLEFT", -11, 4}
        config.artwork.highlight.size = {128, 64}

        config.health.enabled = true
        config.health.padding = {40, 0, -10, 14}
        config.health.value.enabled = false

        config.power.enabled = true
        config.power.padding = {0, 0, 0, 15}
        config.power.detached = false
        config.power.size = {150, 7}
        config.power.value.enabled = false
        config.power.border.enabled = false
        config.power.shadow.enabled = false

        config.portrait.enabled = true
        config.portrait.round = true
        config.portrait.detached = true
        config.portrait.point = {"LEFT", "LEFT", 0, -2}
        config.portrait.size = {37, 37}
        config.portrait.border.enabled = false

        config.name.enabled = true
        config.name.size = {120, 10}
        config.name.point = {"TOPLEFT", 40, 0}
        config.name.justifyH = "LEFT"

        config.level.enabled = false

        config.pvpIndicator.enabled = true
        config.pvpIndicator.size = {25, 25}
        config.pvpIndicator.point = {"CENTER", "LEFT", -4, -4}

        config.leaderIndicator.enabled = true
        config.leaderIndicator.size = {14, 14}
        config.leaderIndicator.point = {"CENTER", "TOPLEFT", 0, -6}

        config.assistantIndicator.enabled = true
        config.assistantIndicator.size = {14, 14}
        config.assistantIndicator.point = {"CENTER", "TOPLEFT", 0, -6}

        config.masterLooterIndicator.enabled = true
        config.masterLooterIndicator.size = {12, 12}
        config.masterLooterIndicator.point = {"CENTER", "TOPLEFT", 30, -6}

        config.raidRoleIndicator.enabled = true
        config.raidRoleIndicator.size = {14, 14}
        config.raidRoleIndicator.point = {"CENTER", "BOTTOMLEFT", 32, 6}

        config.groupRoleIndicator.enabled = true
        config.groupRoleIndicator.size = {14, 14}
        config.groupRoleIndicator.point = {"CENTER", "BOTTOMLEFT", 32, 6}

        config.raidTargetIndicator.enabled = true
        config.raidTargetIndicator.size = {24, 24}
        config.raidTargetIndicator.point = {"CENTER", "TOPLEFT", 15, 0}

        config.offlineIcon.enabled = true
        config.offlineIcon.size = {48, 48}
        config.offlineIcon.point = {"LEFT", "LEFT", 0, 0}

        config.readyCheckIndicator.enabled = true
        config.readyCheckIndicator.size = {48, 48}
        config.readyCheckIndicator.point = {"LEFT", "LEFT", 0, 0}

        config.castbar.enabled = true
        config.castbar.detached = false
        config.castbar.size = {100, 16}
        config.castbar.attachedPoint = {"LEFT", "RIGHT", 2, 2}
    end
end
