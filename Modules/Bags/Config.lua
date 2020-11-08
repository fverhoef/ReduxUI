local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local B = Addon.Modules.Bags

Addon.config.defaults.profile.modules.bags = {
    enabled = true,
    inventory = {slotSize = 40, columns = 8}, 
    bank = {slotSize = 40, columns = 8}, 
    colors = {
        questItem = {1, 1, 0}
    }
}

Addon.config.options.args.bags = {    
    type = "group",
    name = "Bags",
    order = 4,
    args = {
        header = {type = "header", name = Addon.title .. " > Bags", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if B.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return B.config.db.profile.enabled
            end,
            set = function(_, val)
                B.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.Bags:OnInitialize()
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
                        return B.config.db.profile.inventory.slotSize
                    end,
                    set = function(_, val)
                        B.config.db.profile.inventory.slotSize = val
                        Addon.Modules.Bags:UpdateInventory()
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
                        return B.config.db.profile.inventory.columns
                    end,
                    set = function(_, val)
                        B.config.db.profile.inventory.columns = val
                        Addon.Modules.Bags:UpdateInventory()
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
                        return B.config.db.profile.bank.slotSize
                    end,
                    set = function(_, val)
                        B.config.db.profile.bank.slotSize = val
                        Addon.Modules.Bags:UpdateBank()
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
                        return B.config.db.profile.bank.columns
                    end,
                    set = function(_, val)
                        B.config.db.profile.bank.columns = val
                        Addon.Modules.Bags:UpdateBank()
                    end
                }
            }
        }
    }
}