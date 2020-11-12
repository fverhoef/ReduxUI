local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local CB = Addon.Modules.ClassBars

CB.dockLocations = {
    None = 0,
    MainActionBar_Left = 1,
    MainActionBar_Right = 2
}

Addon.config.defaults.profile.modules.classBars = {
    enabled = true,
    mageBar = {
        enabled = true,
        buttonSize = 36,
        buttonSpacing = 6,
        dock = CB.dockLocations.MainActionBar_Left,
        fader = Addon.config.faders.OnShow
    },
    shamanBar = {
        enabled = true,
        buttonSize = 36,
        buttonSpacing = 6,
        dock = CB.dockLocations.MainActionBar_Left,
        fader = Addon.config.faders.OnShow
    }
}

Addon.config.options.args.classBars = {    
    type = "group",
    name = "Class Bars",
    order = 7,
    hidden = Addon.IsRetail,
    args = {
        header = {type = "header", name = Addon.title .. " > Class Bars", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if CB.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return CB.config.db.profile.enabled
            end,
            set = function(_, val)
                CB.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.ClassBars:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
}
