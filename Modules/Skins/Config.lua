local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local S = Addon.Modules.Skins

Addon.config.defaults.profile.modules.skins = {
    enabled = true,
    colors = {
        normalFont = {255 / 255, 209 / 255, 0 / 255}, -- GameFontNormal
        highlightFont = {255 / 255, 255 / 255, 255 / 255}, -- GameFontHighlight
        greenFont = {25 / 255, 255 / 255, 25 / 255}, -- GameFontGreen
        redFont = {255 / 255, 25 / 255, 25 / 255}, -- GameFontRed
        grayFont = {127 / 255, 127 / 255, 127 / 255}, -- GameFontGray
        darkGrayFont = {89 / 255, 89 / 255, 89 / 255}, -- GameFontDarkGray

        guild = {0 / 255, 230 / 255, 0 / 255},

        holy = {255 / 255, 255 / 255, 160 / 255},
        fire = {255 / 255, 107 / 255, 107 / 255},
        frost = {77 / 255, 133 / 255, 230 / 255},
        arcane = {181 / 255, 255 / 255, 235 / 255},
        shadow = {128 / 255, 82 / 255, 140 / 255},
        nature = {133 / 255, 255 / 255, 133 / 255}
    },
    itemLevels = {poor = 0, common = 15, uncommon = 25, rare = 45, epic = 60, legendary = 80},
    enhancementIndex = 1,
    worldMap = {
        scale = 0.7,
        movingOpacity = 0.5,
        stationaryOpacity = 1.0
    }
}

Addon.config.options.args.skins = {    
    type = "group",
    name = "Skins",
    order = 10,
    args = {
        header = {type = "header", name = Addon.title .. " > Skins", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if S.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return S.config.db.profile.enabled
            end,
            set = function(_, val)
                S.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.Skins:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
}