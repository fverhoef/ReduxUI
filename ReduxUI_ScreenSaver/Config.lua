local AddonName, AddonTable = ...
local R = _G.ReduxUI
local SS = R.Modules.ScreenSaver

R.config.defaults.profile.modules.screenSaver = {
    enabled = true,
    font = {R.config.defaults.profile.fonts.normal, 20, "OUTLINE"},
    fader = R.config.faders.onShow
}

R.config.options.args.screenSaver = {    
    type = "group",
    name = "Screen Saver",
    order = 11,
    args = {
        header = {type = "header", name = R.title .. " > Screen Saver", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if R.config.db.profile.modules.screenSaver.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return R.config.db.profile.modules.screenSaver.enabled
            end,
            set = function(_, val)
                R.config.db.profile.modules.screenSaver.enabled = val
                if not val then
                    ReloadUI()
                else
                    SS:Initialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
}