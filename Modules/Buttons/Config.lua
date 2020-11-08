local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local BS = Addon.Modules.Buttons

Addon.config.defaults.profile.modules.buttons = {
    outOfRangeColoring = "button",
    colors = {
        outOfRange = {0.8, 0.1, 0.1},
        usable = {1.0, 1.0, 1.0},
        notEnoughMana = {0.5, 0.5, 1.0},
        notUsable = {0.4, 0.4, 0.4}
    },
    actionBars = {
        font = {Addon.config.defaults.profile.fonts.normal, 11, "OUTLINE"},
        borderSize = 6,
        hideKeybindText = false,
        hideMacroText = true
    },
    auras = {
        font = {Addon.config.defaults.profile.fonts.normal, 10, "OUTLINE"},
        borderSize = 6
    },
    bags = {
        font = {Addon.config.defaults.profile.fonts.normal, 10, "OUTLINE"},
        borderSize = 6
    },
    items = {
        font = {Addon.config.defaults.profile.fonts.normal, 12, "OUTLINE"},
        borderSize = 6
    },
    microMenu = {
        font = {Addon.config.defaults.profile.fonts.normal, 10, "OUTLINE"},
        borderSize = 6
    }
}

Addon.config.options.args.buttons = {    
    type = "group",
    name = "Buttons",
    order = 5,
    args = {
        header = {type = "header", name = Addon.title .. " > Buttons", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if BS.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return BS.config.db.profile.enabled
            end,
            set = function(_, val)
                BS.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.Buttons:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 1}
    }
}

function BS:SetupConfig()
    BS.config = {}
    BS.config.db = {
        profile = Addon.config.db.profile.modules.buttons
    }
end