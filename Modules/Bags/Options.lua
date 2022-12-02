local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags

R:RegisterModuleOptions(B, {
    type = "group",
    name = "Bags",
    args = {
        header = { type = "header", name = R.title .. " > Bags", order = 0 },
        enabled = R:CreateModuleEnabledOption(1, nil, "Bags"),
        lineBreak = { type = "header", name = "", order = 2 },
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
                        return B.config.inventory.slotSize
                    end,
                    set = function(_, val)
                        B.config.inventory.slotSize = val
                        B.Inventory:Update()
                    end
                },
                columns = {
                    type = "range",
                    name = "Number of Columns",
                    order = 2,
                    min = 4,
                    softMax = 20,
                    step = 1,
                    get = function()
                        return B.config.inventory.columns
                    end,
                    set = function(_, val)
                        B.config.inventory.columns = val
                        B.Inventory:Update()
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
                        return B.config.bank.slotSize
                    end,
                    set = function(_, val)
                        B.config.bank.slotSize = val
                        B.Bank:Update()
                    end
                },
                columns = {
                    type = "range",
                    name = "Number of Columns",
                    order = 2,
                    min = 4,
                    softMax = 20,
                    step = 1,
                    get = function()
                        return B.config.bank.columns
                    end,
                    set = function(_, val)
                        B.config.bank.columns = val
                        B.Bank:Update()
                    end
                }
            }
        }
    }
})
