local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

R.config.defaults.profile.modules.skins = {
    enabled = true
}

R.config.options.args.skins = {    
    type = "group",
    name = "Skins",
    order = 12,
    args = {
        header = {type = "header", name = R.title .. " > Skins", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if R.config.db.profile.modules.skins.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return R.config.db.profile.modules.skins.enabled
            end,
            set = function(_, val)
                R.config.db.profile.modules.skins.enabled = val
                if not val then
                    ReloadUI()
                else
                    R.Modules.Skins:Initialize()
                end
            end
        },
        lineBreak1 = {type = "header", name = "", order = 2}
    }
}