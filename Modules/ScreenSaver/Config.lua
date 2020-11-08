local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local SS = Addon.Modules.ScreenSaver

Addon.config.defaults.profile.modules.screenSaver = {
    enabled = true,
    fader = Addon.config.faders.onShow
}

Addon.config.options.args.screenSaver = {    
    type = "group",
    name = "Screen Saver",
    order = 9,
    args = {
        header = {type = "header", name = Addon.title .. " > Screen Saver", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if SS.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return SS.config.db.profile.enabled
            end,
            set = function(_, val)
                SS.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.ScreenSaver:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
}