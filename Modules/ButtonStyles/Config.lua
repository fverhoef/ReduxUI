local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

R.config.defaults.profile.modules.buttonStyles = {
    enabled = true,
    outOfRangeColoring = "button",
    colors = {
        outOfRange = {0.8, 0.1, 0.1},
        usable = {1.0, 1.0, 1.0},
        notEnoughMana = {0.5, 0.5, 1.0},
        notUsable = {0.4, 0.4, 0.4}
    },
    actionBars = {
        font = {R.config.defaults.profile.fonts.normal, 11, "OUTLINE"},
        borderSize = 12,
        hideKeybindText = false,
        hideMacroText = true
    },
    auras = {
        font = {R.config.defaults.profile.fonts.normal, 10, "OUTLINE"},
        borderSize = 12
    },
    bags = {
        font = {R.config.defaults.profile.fonts.normal, 10, "OUTLINE"},
        borderSize = 12
    },
    items = {
        font = {R.config.defaults.profile.fonts.normal, 12, "OUTLINE"},
        borderSize = 12
    },
    microMenu = {
        font = {R.config.defaults.profile.fonts.normal, 10, "OUTLINE"},
        borderSize = 12
    }
}

R.config.options.args.buttons = {    
    type = "group",
    name = "Buttons",
    order = 5,
    args = {
        header = {type = "header", name = R.title .. " > Buttons", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if R.config.db.profile.modules.buttonStyles.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return R.config.db.profile.modules.buttonStyles.enabled
            end,
            set = function(_, val)
                R.config.db.profile.modules.buttonStyles.enabled = val
                if not val then
                    ReloadUI()
                else
                    R.Modules.ButtonStyles:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
}