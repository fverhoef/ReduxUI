local addonName, ns = ...
local R = _G.ReduxUI
local B = R.Modules.Bags
local L = R.L

R:RegisterModuleOptions(B, {
    type = "group",
    name = L["Bags"],
    args = {
        header = { type = "header", name = R.title .. " > Bags", order = 0 },
        enabled = R:CreateModuleEnabledOption(1, nil, "Bags"),
        lineBreak = { type = "header", name = "", order = 2 },
        inventory = {
            type = "group",
            name = L["Inventory"],
            inline = true,
            order = 10,
            args = {
                slotSize = {
                    type = "range",
                    name = L["Slot Size"],
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
                    name = L["Number of Columns"],
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
                },
                font = {
                    type = "group",
                    name = L["Item Count Font"],
                    order = 3,
                    inline = true,
                    args = {
                        font = R:CreateFontOption(L["Font"], L["The font to use for count text."], 1, nil, function()
                            return B.config.inventory.buttonStyle.font
                        end, function(value)
                            B.config.inventory.buttonStyle.font = value
                        end, function()
                            B.Inventory:Update()
                        end),
                        size = R:CreateRangeOption(L["Font Size"], L["The size of count text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                            return B.config.inventory.buttonStyle.fontSize
                        end, function(value)
                            B.config.inventory.buttonStyle.fontSize = value
                        end, function()
                            B.Inventory:Update()
                        end),
                        outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of count text."], 3, nil, R.FONT_OUTLINES, function()
                            return B.config.inventory.buttonStyle.fontOutline
                        end, function(value)
                            B.config.inventory.buttonStyle.fontOutline = value
                        end, function()
                            B.Inventory:Update()
                        end),
                        shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for count text."], 4, nil, nil, function()
                            return B.config.inventory.buttonStyle.fontShadow
                        end, function(value)
                            B.config.inventory.buttonStyle.fontShadow = value
                        end, function()
                            B.Inventory:Update()
                        end)
                    }
                },
                slotFont = {
                    type = "group",
                    name = L["Empty Slot Count Font"],
                    order = 4,
                    inline = true,
                    args = {
                        font = R:CreateFontOption(L["Font"], L["The font to use for empty slot count text on bag slot buttons."], 1, nil, function()
                            return B.config.inventory.buttonStyle.font
                        end, function(value)
                            B.config.inventory.buttonStyle.font = value
                        end, function()
                            B.Inventory:Update()
                        end),
                        size = R:CreateRangeOption(L["Font Size"], L["The size of empty slot count text on bag slot buttons."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                            return B.config.inventory.buttonStyle.fontSize
                        end, function(value)
                            B.config.inventory.buttonStyle.fontSize = value
                        end, function()
                            B.Inventory:Update()
                        end),
                        outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of empty slot count text on bag slot buttons."], 3, nil, R.FONT_OUTLINES, function()
                            return B.config.inventory.buttonStyle.fontOutline
                        end, function(value)
                            B.config.inventory.buttonStyle.fontOutline = value
                        end, function()
                            B.Inventory:Update()
                        end),
                        shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for empty slot count text on bag slot buttons."], 4, nil, nil, function()
                            return B.config.inventory.buttonStyle.fontShadow
                        end, function(value)
                            B.config.inventory.buttonStyle.fontShadow = value
                        end, function()
                            B.Inventory:Update()
                        end)
                    }
                }
            }
        },
        bank = {
            type = "group",
            name = L["Bank"],
            inline = true,
            order = 20,
            args = {
                slotSize = {
                    type = "range",
                    name = L["Slot Size"],
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
                    name = L["Number of Columns"],
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
                },
                font = {
                    type = "group",
                    name = L["Item Count Font"],
                    order = 3,
                    inline = true,
                    args = {
                        font = R:CreateFontOption(L["Font"], L["The font to use for count text."], 1, nil, function()
                            return B.config.bank.buttonStyle.font
                        end, function(value)
                            B.config.bank.buttonStyle.font = value
                        end, function()
                            B.Bank:Update()
                        end),
                        size = R:CreateRangeOption(L["Font Size"], L["The size of count text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                            return B.config.bank.buttonStyle.fontSize
                        end, function(value)
                            B.config.bank.buttonStyle.fontSize = value
                        end, function()
                            B.Bank:Update()
                        end),
                        outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of count text."], 3, nil, R.FONT_OUTLINES, function()
                            return B.config.bank.buttonStyle.fontOutline
                        end, function(value)
                            B.config.bank.buttonStyle.fontOutline = value
                        end, function()
                            B.Bank:Update()
                        end),
                        shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for count text."], 4, nil, nil, function()
                            return B.config.bank.buttonStyle.fontShadow
                        end, function(value)
                            B.config.bank.buttonStyle.fontShadow = value
                        end, function()
                            B.Bank:Update()
                        end)
                    }
                },
                slotFont = {
                    type = "group",
                    name = L["Empty Slot Count Font"],
                    order = 4,
                    inline = true,
                    args = {
                        font = R:CreateFontOption(L["Font"], L["The font to use for empty slot count text on bag slot buttons."], 1, nil, function()
                            return B.config.bank.buttonStyle.font
                        end, function(value)
                            B.config.bank.buttonStyle.font = value
                        end, function()
                            B.Bank:Update()
                        end),
                        size = R:CreateRangeOption(L["Font Size"], L["The size of empty slot count text on bag slot buttons."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                            return B.config.bank.buttonStyle.fontSize
                        end, function(value)
                            B.config.bank.buttonStyle.fontSize = value
                        end, function()
                            B.Bank:Update()
                        end),
                        outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of empty slot count text on bag slot buttons."], 3, nil, R.FONT_OUTLINES, function()
                            return B.config.bank.buttonStyle.fontOutline
                        end, function(value)
                            B.config.bank.buttonStyle.fontOutline = value
                        end, function()
                            B.Bank:Update()
                        end),
                        shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for empty slot count text on bag slot buttons."], 4, nil, nil, function()
                            return B.config.bank.buttonStyle.fontShadow
                        end, function(value)
                            B.config.bank.buttonStyle.fontShadow = value
                        end, function()
                            B.Bank:Update()
                        end)
                    }
                }
            }
        }
    }
})
