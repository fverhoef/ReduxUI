local addonName, ns = ...
local R = _G.ReduxUI
local SS = R.Modules.ScreenSaver

R:RegisterModuleConfig(SS, {
    enabled = true,
    font = {R.config.defaults.profile.fonts.normal, 20, "OUTLINE"},
    border = {enabled = true, size = 4, texture = R.media.textures.borders.beautycase, color = {89 / 255, 89 / 255, 89 / 255, 1}},
    fader = R.config.faders.onShow
})

R:RegisterModuleOptions(SS, {
    type = "group",
    name = "Screen Saver",
    args = {
        header = {type = "header", name = R.title .. " > Screen Saver", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if SS.config.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return SS.config.enabled
            end,
            set = function(_, val)
                SS.config.enabled = val
                if not val then
                    ReloadUI()
                else
                    SS:Initialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2}
    }
})
