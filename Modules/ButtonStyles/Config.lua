local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

R:RegisterModuleConfig(BS, {
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
        borderSize = 4,
        hideKeybindText = false,
        hideMacroText = true
    },
    auras = {font = {R.config.defaults.profile.fonts.normal, 10, "OUTLINE"}, borderSize = 4},
    bags = {font = {R.config.defaults.profile.fonts.normal, 10, "OUTLINE"}, borderSize = 4},
    items = {font = {R.config.defaults.profile.fonts.normal, 12, "OUTLINE"}, borderSize = 4},
    microMenu = {font = {R.config.defaults.profile.fonts.normal, 10, "OUTLINE"}, borderSize = 4}
})

R:RegisterModuleOptions(BS, {
    type = "group",
    name = "Button Styles",
    args = {
        header = {type = "header", name = R.title .. " > Button Styles", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if BS.config.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return BS.config.enabled
            end,
            set = function(_, val)
                BS.config.enabled = val
                if not val then
                    ReloadUI()
                else
                    BS:Initialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
})
