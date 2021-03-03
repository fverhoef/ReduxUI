local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTargetTarget()
    local config = UF.config.targettarget
    local default = UF.defaults.targettarget

    if config.enabled then
        return UF:SpawnFrame("TargetTarget", "targettarget", UF.CreateTargetTarget, config, default)
    end
end

function UF:CreateTargetTarget()
    self.config = UF.config.targettarget
    self.defaults = UF.defaults.targettarget

    UF:SetupFrame(self)

    self:CreateRange()

    self.Update = UF.UpdateTargetTarget
    self.ApplyTheme = UF.TargetTarget_ApplyTheme
end

function UF:UpdateTargetTarget()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end

function UF:TargetTarget_ApplyTheme()
    local theme = UF.config.theme
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
