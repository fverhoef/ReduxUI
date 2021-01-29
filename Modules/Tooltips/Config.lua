local addonName, ns = ...
local R = _G.ReduxUI
local TT = R.Modules.Tooltips

local TOOLTIP_ANCHORS = {
    ["ANCHOR_NONE"] = "ANCHOR_NONE",
    ["ANCHOR_CURSOR"] = "ANCHOR_CURSOR",
    ["ANCHOR_TOP"] = "ANCHOR_TOP",
    ["ANCHOR_TOPLEFT"] = "ANCHOR_TOPLEFT",
    ["ANCHOR_TOPRIGHT"] = "ANCHOR_TOPRIGHT",
    ["ANCHOR_BOTTOM"] = "ANCHOR_BOTTOM",
    ["ANCHOR_BOTTOMLEFT"] = "ANCHOR_BOTTOMLEFT",
    ["ANCHOR_BOTTOMRIGHT"] = "ANCHOR_BOTTOMRIGHT",
    ["ANCHOR_LEFT"] = "ANCHOR_LEFT",
    ["ANCHOR_RIGHT"] = "ANCHOR_RIGHT"
}

R.config.defaults.profile.modules.tooltips = {
    enabled = true,
    colors = {
        text = {100 / 255, 100 / 255, 100 / 255},
        boss = {255 / 255, 0 / 255, 0 / 255},
        elite = {255 / 255, 0 / 255, 125 / 255},
        rareElite = {255 / 255, 125 / 255, 0 / 255},
        rare = {255 / 255, 125 / 255, 0 / 255},
        level = {200 / 255, 200 / 255, 125 / 255},
        dead = {125 / 255, 125 / 255, 125 / 255},
        target = {255 / 255, 125 / 255, 125 / 255},
        guild = {0 / 255, 230 / 255, 0 / 255},
        afk = {0 / 255, 255 / 255, 255 / 255},
        pvp = {220 / 255, 120 / 255, 30 / 255},
        itemLevel = {220 / 255, 195 / 255, 30 / 255}
    },
    scale = 1,
    fontFamily = R.config.defaults.profile.fonts.normal,
    fontSize = 12,
    headerFontSize = 14,
    smallFontSize = 11,
    healthFontSize = 12,
    anchor = "ANCHOR_CURSOR",
    offsetX = 20,
    offsetY = 20,
    colorBorderByRarity = true,
    showHealthValues = true,
    showIcons = true,
    showSpellId = false,
    showItemId = false,
    showItemLevel = true,
    showItemCount = true,
    showVendorPrice = true
}

R.config.options.args.tooltips = {    
    type = "group",
    name = "Tooltips",
    order = 14,
    args = {
        header = {type = "header", name = R.title .. " > Spell Info", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if R.config.db.profile.modules.tooltips.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return R.config.db.profile.modules.tooltips.enabled
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.enabled = val
                if not val then
                    ReloadUI()
                else
                    R.Modules.Tooltips:Initialize()
                end
            end
        },
        lineBreak1 = {type = "header", name = "", order = 2},
        showHealthValues = {
            type = "toggle",
            name = "Show Health Values",
            order = 10,
            width = "full",
            get = function()
                return R.config.db.profile.modules.tooltips.showHealthValues
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.showHealthValues = val
            end
        },
        showVendorPrice = {
            type = "toggle",
            name = "Show Vendor Price",
            order = 11,
            width = "full",
            get = function()
                return R.config.db.profile.modules.tooltips.showVendorPrice
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.showVendorPrice = val
            end
        },
        showItemLevel = {
            type = "toggle",
            name = "Show Item Level",
            order = 12,
            width = "full",
            get = function()
                return R.config.db.profile.modules.tooltips.showItemLevel
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.showItemLevel = val
            end
        },
        showItemCount = {
            type = "toggle",
            name = "Show Item Count",
            order = 13,
            width = "full",
            get = function()
                return R.config.db.profile.modules.tooltips.showItemCount
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.showItemCount = val
            end
        },
        showIcons = {
            type = "toggle",
            name = "Show Icons",
            order = 14,
            width = "full",
            get = function()
                return R.config.db.profile.modules.tooltips.showIcons
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.showIcons = val
            end
        },
        showSpellId = {
            type = "toggle",
            name = "Show Spell IDs",
            order = 15,
            width = "full",
            get = function()
                return R.config.db.profile.modules.tooltips.showSpellId
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.showSpellId = val
            end
        },
        showItemId = {
            type = "toggle",
            name = "Show Item IDs",
            order = 16,
            width = "full",
            get = function()
                return R.config.db.profile.modules.tooltips.showItemId
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.showItemId = val
            end
        },
        lineBreak2 = {type = "header", name = "", order = 20},
        font = {
            type = "group",
            name = "Font",
            inline = true,
            order = 21,
            args = {
                face = {
                    type = "select",
                    name = "Font Face",
                    order = 1,
                    dialogControl = "LSM30_Font",
                    values = R.Libs.SharedMedia:HashTable("font"),
                    get = function()
                        for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                            if R.config.db.profile.modules.tooltips.fontFamily == font then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        R.config.db.profile.modules.tooltips.fontFamily = R.Libs.SharedMedia:Fetch("font", key)
                        R.Modules.Tooltips:UpdateFonts()
                    end
                },
                size = {
                    type = "range",
                    name = "Font Size (Body)",
                    order = 2,
                    min = 8,
                    softMax = 36,
                    step = 1,
                    get = function()
                        return R.config.db.profile.modules.tooltips.fontSize
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.tooltips.fontSize = val
                        R.Modules.Tooltips:UpdateFonts()
                    end
                },
                smallFontSize = {
                    type = "range",
                    name = "Font Size (Small)",
                    order = 3,
                    min = 8,
                    softMax = 36,
                    step = 1,
                    get = function()
                        return R.config.db.profile.modules.tooltips.smallFontSize
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.tooltips.smallFontSize = val
                        R.Modules.Tooltips:UpdateFonts()
                    end
                },
                headerFontSize = {
                    type = "range",
                    name = "Font Size (Header)",
                    order = 4,
                    min = 8,
                    softMax = 36,
                    step = 1,
                    get = function()
                        return R.config.db.profile.modules.tooltips.headerFontSize
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.tooltips.headerFontSize = val
                        R.Modules.Tooltips:UpdateFonts()
                    end
                },
                healthFontSize = {
                    type = "range",
                    name = "Font Size (Health)",
                    order = 5,
                    min = 8,
                    softMax = 36,
                    step = 1,
                    get = function()
                        return R.config.db.profile.modules.tooltips.healthFontSize
                    end,
                    set = function(_, val)
                        R.config.db.profile.modules.tooltips.healthFontSize = val
                        R.Modules.Tooltips:UpdateFonts()
                    end
                }
            }
        },
        scale = {
            type = "range",
            name = "Scale",
            order = 22,
            min = 0.1,
            softMax = 3,
            step = 0.1,
            get = function()
                return R.config.db.profile.modules.tooltips.scale
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.scale = val
                R.Modules.Tooltips:UpdateScale()
            end
        },
        anchor = {
            type = "select",
            name = "Anchor",
            order = 31,
            values = TOOLTIP_ANCHORS,
            get = function()
                return R.config.db.profile.modules.tooltips.anchor
            end,
            set = function(_, key)
                R.config.db.profile.modules.tooltips.anchor = key
            end
        },
        offsetX = {
            type = "range",
            name = "Offset X",
            order = 32,
            min = -100,
            softMax = 100,
            step = 1,
            get = function()
                return R.config.db.profile.modules.tooltips.offsetX
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.offsetX = val
            end
        },
        offsetY = {
            type = "range",
            name = "Offset Y",
            order = 32,
            min = -100,
            softMax = 100,
            step = 1,
            get = function()
                return R.config.db.profile.modules.tooltips.offsetY
            end,
            set = function(_, val)
                R.config.db.profile.modules.tooltips.offsetY = val
            end
        }
    }
}