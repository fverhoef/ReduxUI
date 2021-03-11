local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPet()
    local config = UF.config.pet
    local default = UF.defaults.pet

    if config.enabled then
        return UF:SpawnFrame("Pet", "pet", UF.CreatePet, config, default)
    end
end

function UF:CreatePet()
    self.config = UF.config.pet
    self.defaults = UF.defaults.pet

    UF:SetupFrame(self)

    self:CreateRange()

    self.Update = UF.UpdatePet
    self.ApplyTheme = UF.Pet_ApplyTheme
end

function UF:UpdatePet()
    if not self then
        return
    end
    
    UF:UpdateFrame(self)
end

function UF:Pet_ApplyTheme()
    local theme = UF.config.theme
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

        config.raidTargetIndicator.enabled = true
        config.raidTargetIndicator.size = {24, 24}
        config.raidTargetIndicator.point = {"CENTER", "TOPRIGHT", -27, 8}

        config.castbar.enabled = true
        config.castbar.detached = false
        config.castbar.size = {122, 20}
        config.castbar.attachedPoint = {"BOTTOMLEFT", "TOPLEFT", -2, 5}
    end
end
