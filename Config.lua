local addonName, ns = ...
local R = _G.ReduxUI

R.FONT_OUTLINES = {["NONE"] = "NONE", ["OUTLINE"] = "OUTLINE", ["THICKOUTLINE"] = "THICKOUTLINE"}

R.config = {}
R.config.defaults = {
    profile = {
        fonts = {
            damage = R.Libs.SharedMedia:Fetch("font", "Adventure"),
            normal = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            number = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            unitName = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            chatBubble = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            replaceBlizzardFonts = true
        },
        borders = {
            size = 5,
            texture = R.media.textures.borders.beautycaseWhite,
            color = {89 / 255, 89 / 255, 89 / 255}
        },
        colors = {
            normalFont = {255 / 255, 209 / 255, 0 / 255}, -- GameFontNormal
            highlightFont = {255 / 255, 255 / 255, 255 / 255}, -- GameFontHighlight
            greenFont = {25 / 255, 255 / 255, 25 / 255}, -- GameFontGreen
            redFont = {255 / 255, 25 / 255, 25 / 255}, -- GameFontRed
            grayFont = {127 / 255, 127 / 255, 127 / 255}, -- GameFontGray
            darkGrayFont = {89 / 255, 89 / 255, 89 / 255} -- GameFontDarkGray
        },
        modules = {
        }
    },
    char = {modules = {}},
    realm = {inventory = {}, modules = {}}
}

R.config.options = {
    type = "group",
    name = R.title,
    args = {
        general = {
            type = "group",
            name = "General",
            order = 1,
            args = {
                header = {type = "header", name = R.title .. " > General", order = 0},
                desc = {order = 1, type = "description", name = "These are features that apply to every module."},
                fonts = {
                    type = "group",
                    name = "Fonts",
                    order = 2,
                    inline = true,
                    args = {
                        normal = {
                            name = "Standard Text",
                            type = "select",
                            order = 1,
                            dialogControl = "LSM30_Font",
                            values = R.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                                    if R.config.db.profile.fonts.normal == font then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                R.config.db.profile.fonts.normal = R.Libs.SharedMedia:Fetch("font", key)
                                R:UpdateBlizzardFonts()
                            end
                        },
                        number = {
                            name = "Numbers",
                            type = "select",
                            order = 2,
                            dialogControl = "LSM30_Font",
                            values = R.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                                    if R.config.db.profile.fonts.number == font then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                R.config.db.profile.fonts.number = R.Libs.SharedMedia:Fetch("font", key)
                                R:UpdateBlizzardFonts()
                            end
                        },
                        -- TODO: warn that changing this option requires a relog
                        damage = {
                            name = "Damage",
                            type = "select",
                            order = 3,
                            dialogControl = "LSM30_Font",
                            values = R.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                                    if R.config.db.profile.fonts.damage == font then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                R.config.db.profile.fonts.damage = R.Libs.SharedMedia:Fetch("font", key)
                                R:UpdateBlizzardFonts()
                            end
                        },
                        -- TODO: warn that changing this option requires a relog
                        unitName = {
                            name = "Unit Names",
                            type = "select",
                            order = 4,
                            dialogControl = "LSM30_Font",
                            values = R.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                                    if R.config.db.profile.fonts.unitName == font then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                R.config.db.profile.fonts.unitName = R.Libs.SharedMedia:Fetch("font", key)
                                R:UpdateBlizzardFonts()
                            end
                        },
                        chatBubble = {
                            name = "Chat Bubbles",
                            type = "select",
                            order = 5,
                            dialogControl = "LSM30_Font",
                            values = R.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                                    if R.config.db.profile.fonts.chatBubble == font then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                R.config.db.profile.fonts.chatBubble = R.Libs.SharedMedia:Fetch("font", key)
                                R:UpdateBlizzardFonts()
                            end
                        }
                    }
                }
            }
        }
    }
}

R.config.faders = {
    none = nil,
    onShow = {fadeInAlpha = 1, fadeInDuration = 0.3, fadeInSmooth = "OUT", fadeOutAlpha = 0, fadeOutDuration = 0.9, fadeOutSmooth = "OUT", fadeOutDelay = 0, trigger = "OnShow"},
    mouseOver = {fadeInAlpha = 1, fadeInDuration = 0.3, fadeInSmooth = "OUT", fadeOutAlpha = 0, fadeOutDuration = 0.9, fadeOutSmooth = "OUT", fadeOutDelay = 0}
}

local function FindPanel(name, parent)
    for i, button in next, InterfaceOptionsFrameAddOns.buttons do
        if button.element then
            if name and button.element.name == name then
                return button
            elseif parent and button.element.parent == parent then
                return button
            end
        end
    end
end

local function AddLogo(frame)
    local logo = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
    logo:SetFrameLevel(4)
    logo:SetSize(64, 64)
    logo:SetPoint("TOPRIGHT", 8, 24)
    logo:SetBackdrop({bgFile = R.media.textures.logo})

    frame.logo = logo
end

function R:SetupConfig()
    R.config.db = R.Libs.AceDB:New(addonName .. "_DB", R.config.defaults)

    R.config.options.args.profiles = R.Libs.AceDBOptions:GetOptionsTable(R.config.db)
    R.config.options.args.profiles.order = 99

    R.Libs.AceConfigRegistry:RegisterOptionsTable(addonName, R.config.options)
    R.config.dialog = R.Libs.AceConfigDialog:AddToBlizOptions(addonName, R.title)
    R.config.dialog:HookScript("OnShow", function()
        local p = FindPanel(addonName)
        if p and p.element.collapsed then
            OptionsListButtonToggle_OnClick(p.toggle)
        end
    end)

    AddLogo(R.config.dialog)
end

function R:RefreshConfig()
    R.config.db = R.Libs.AceDB:New(addonName .. "_DB", R.config.defaults)
end
