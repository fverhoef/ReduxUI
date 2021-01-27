local AddonName, AddonTable = ...
local R = _G.ReduxUI
local CB = R.Modules.ClassicClassBars

CB.dockLocations = {
    None = 0,
    MainActionBar_Left = 1,
    MainActionBar_Right = 2
}

R.config.defaults.profile.modules.classicClassBars = {
    enabled = true,
    mageBar = {
        enabled = true,
        buttonSize = 36,
        buttonSpacing = 6,
        dock = CB.dockLocations.MainActionBar_Left,
        fader = R.config.faders.OnShow
    },
    shamanBar = {
        enabled = true,
        buttonSize = 36,
        buttonSpacing = 6,
        dock = CB.dockLocations.MainActionBar_Left,
        fader = R.config.faders.OnShow
    }
}

R.config.options.args.classicClassBars = {    
    type = "group",
    name = "Classic Class Bars",
    order = 7,
    hidden = R.IsRetail,
    args = {
        header = {type = "header", name = R.title .. " > Classic Class Bars", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if R.config.db.profile.modules.classicClassBars.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return R.config.db.profile.modules.classicClassBars.enabled
            end,
            set = function(_, val)
                R.config.db.profile.modules.classicClassBars.enabled = val
                if not val then
                    ReloadUI()
                else
                    CB:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
}
