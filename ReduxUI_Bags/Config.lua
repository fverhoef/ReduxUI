local AddonName, AddonTable = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

R.config.defaults.profile.modules.bags = {
    enabled = true,
    inventory = {slotSize = 40, columns = 10}, 
    bank = {slotSize = 40, columns = 10}, 
    colors = {
        questItem = {1, 1, 0}
    }
}

R.config.options.args.bags = {    
    type = "group",
    name = "Bags",
    order = 4,
    args = {
        header = {type = "header", name = R.title .. " > Bags", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if R.config.db.profile.modules.bags.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return R.config.db.profile.modules.bags.enabled
            end,
            set = function(_, val)
                R.config.db.profile.modules.bags.enabled = val
                if not val then
                    ReloadUI()
                else
                    R.Modules.Bags:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2},
        inventory = {
            type = "group",
            name = "Inventory",
            inline = true,
            order = 10,
            args = {
                slotSize = {
                    type = "range",
                    name = "Slot Size",
                    order = 1,
                    min = 20,
                    softMax = 60,
                    step = 1,
                    get = function()
                        return R.config.db.profile.modules.bags.inventory.slotSize
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.bags.inventory.slotSize = val
                        R.Modules.Bags:UpdateInventory()
                    end
                },
                columns = {
                    type = "range",
                    name = "Number of Columns",
                    order = 2,
                    min = 4,
                    softMax = 12,
                    step = 1,
                    get = function()
                        return R.config.db.profile.modules.bags.inventory.columns
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.bags.inventory.columns = val
                        R.Modules.Bags:UpdateInventory()
                    end
                }
            }
        },
        bank = {
            type = "group",
            name = "Bank",
            inline = true,
            order = 20,
            args = {
                slotSize = {
                    type = "range",
                    name = "Slot Size",
                    order = 1,
                    min = 20,
                    softMax = 60,
                    step = 1,
                    get = function()
                        return R.config.db.profile.modules.bags.bank.slotSize
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.bags.bank.slotSize = val
                        R.Modules.Bags:UpdateBank()
                    end
                },
                columns = {
                    type = "range",
                    name = "Number of Columns",
                    order = 2,
                    min = 4,
                    softMax = 12,
                    step = 1,
                    get = function()
                        return R.config.db.profile.modules.bags.bank.columns
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.bags.bank.columns = val
                        R.Modules.Bags:UpdateBank()
                    end
                }
            }
        }
    }
}