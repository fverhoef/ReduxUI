local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local TT = Addon.Modules.Tooltips

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

Addon.config.defaults.profile.modules.tooltips = {
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
    fontFamily = Addon.config.defaults.profile.fonts.normal,
    fontSize = 12,
    headerFontSize = 14,
    smallFontSize = 11,
    healthFontSize = 12,
    anchor = "ANCHOR_CURSOR",
    showHealthValues = true,
    showIcons = true,
    showSpellId = false,
    showItemId = false,
    showItemLevel = true,
    showItemCount = true,
    showVendorPrice = true
}

Addon.config.options.args.tooltips = {    
    type = "group",
    name = "Tooltips",
    order = 11,
    args = {
        header = {type = "header", name = Addon.title .. " > Spell Info", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if TT.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return TT.config.db.profile.enabled
            end,
            set = function(_, val)
                TT.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.Tooltips:OnInitialize()
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
                return TT.config.db.profile.showHealthValues
            end,
            set = function(_, val)
                TT.config.db.profile.showHealthValues = val
            end
        },
        showVendorPrice = {
            type = "toggle",
            name = "Show Vendor Price",
            order = 11,
            width = "full",
            get = function()
                return TT.config.db.profile.showVendorPrice
            end,
            set = function(_, val)
                TT.config.db.profile.showVendorPrice = val
            end
        },
        showItemLevel = {
            type = "toggle",
            name = "Show Item Level",
            order = 12,
            width = "full",
            get = function()
                return TT.config.db.profile.showItemLevel
            end,
            set = function(_, val)
                TT.config.db.profile.showItemLevel = val
            end
        },
        showItemCount = {
            type = "toggle",
            name = "Show Item Count",
            order = 13,
            width = "full",
            get = function()
                return TT.config.db.profile.showItemCount
            end,
            set = function(_, val)
                TT.config.db.profile.showItemCount = val
            end
        },
        showIcons = {
            type = "toggle",
            name = "Show Icons",
            order = 14,
            width = "full",
            get = function()
                return TT.config.db.profile.showIcons
            end,
            set = function(_, val)
                TT.config.db.profile.showIcons = val
            end
        },
        showSpellId = {
            type = "toggle",
            name = "Show Spell IDs",
            order = 15,
            width = "full",
            get = function()
                return TT.config.db.profile.showSpellId
            end,
            set = function(_, val)
                TT.config.db.profile.showSpellId = val
            end
        },
        showItemId = {
            type = "toggle",
            name = "Show Item IDs",
            order = 16,
            width = "full",
            get = function()
                return TT.config.db.profile.showItemId
            end,
            set = function(_, val)
                TT.config.db.profile.showItemId = val
            end
        },
        showNextRank = {
            type = "toggle",
            name = "Show Next Available Rank",
            order = 17,
            width = "full",
            get = function()
                return TT.config.db.profile.showNextRank
            end,
            set = function(_, val)
                TT.config.db.profile.showNextRank = val
            end
        },
        modifySpellDamage = {
            type = "toggle",
            name = "Update Spell Damage",
            order = 18,
            width = "full",
            get = function()
                return TT.config.db.profile.modifySpellDamage
            end,
            set = function(_, val)
                TT.config.db.profile.modifySpellDamage = val
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
                    values = Addon.Libs.SharedMedia:HashTable("font"),
                    get = function()
                        for key, font in pairs(Addon.Libs.SharedMedia:HashTable("font")) do
                            if TT.config.db.profile.fontFamily == font then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        TT.config.db.profile.fontFamily = Addon.Libs.SharedMedia:Fetch("font", key)
                        Addon.Modules.Tooltips:UpdateFonts()
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
                        return TT.config.db.profile.fontSize
                    end,
                    set = function(_, val)
                        TT.config.db.profile.fontSize = val
                        Addon.Modules.Tooltips:UpdateFonts()
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
                        return TT.config.db.profile.smallFontSize
                    end,
                    set = function(_, val)
                        TT.config.db.profile.smallFontSize = val
                        Addon.Modules.Tooltips:UpdateFonts()
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
                        return TT.config.db.profile.headerFontSize
                    end,
                    set = function(_, val)
                        TT.config.db.profile.headerFontSize = val
                        Addon.Modules.Tooltips:UpdateFonts()
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
                        return TT.config.db.profile.healthFontSize
                    end,
                    set = function(_, val)
                        TT.config.db.profile.healthFontSize = val
                        Addon.Modules.Tooltips:UpdateFonts()
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
                return TT.config.db.profile.scale
            end,
            set = function(_, val)
                TT.config.db.profile.scale = val
                Addon.Modules.Tooltips:UpdateScale()
            end
        },
        anchor = {
            type = "select",
            name = "Anchor",
            order = 23,
            values = TOOLTIP_ANCHORS,
            get = function()
                return TT.config.db.profile.anchor
            end,
            set = function(_, key)
                TT.config.db.profile.anchor = key
            end
        }
    }
}

function TT:SetupConfig()
    TT.config = {}
    TT.config.db = {
        profile = Addon.config.db.profile.modules.tooltips
    }
end