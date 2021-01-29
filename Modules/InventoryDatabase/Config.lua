local addonName, ns = ...
local R = _G.ReduxUI
local C = R.Modules.Chat

R.config.defaults.profile.modules.inventoryDatabase = {
    enabled = true
}

R.config.options.args.inventoryDatabase = {
    type = "group",
    name = "Inventory Database",
    order = 7,
    args = {
        header = {type = "header", name = R.title .. " > Inventory Database", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if R.config.db.profile.modules.inventoryDatabase.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return R.config.db.profile.modules.inventoryDatabase
            end,
            set = function(_, val)
                R.config.db.profile.modules.inventoryDatabase = val
                if not val then
                    ReloadUI()
                else
                    R.Modules.InventoryDatabase:Initialize()
                end
            end
        }
    }
}