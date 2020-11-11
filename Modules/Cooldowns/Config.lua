local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local CD = Addon.Modules.Cooldowns

Addon.config.defaults.profile.modules.cooldowns = {
    enabled = true,
    font = Addon.Libs.SharedMedia:Fetch("font", "Expressway Free"),
}

Addon.config.options.args.cooldowns = {
    type = "group",
    name = "Cooldowns",
    order = 8,
    args = {
        header = {type = "header", name = Addon.title .. " > Cooldowns", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                return "Disabling this module requires a UI reload. Proceed?"
            end,
            get = function()
                return UF.config.db.profile.enabled
            end,
            set = function(_, val)
                UF.config.db.profile.enabled = val
                ReloadUI()
            end
        }
    }
}