local addonName, ns = ...
local R = _G.ReduxUI

R.JUSTIFY_H = {["LEFT"] = "LEFT", ["CENTER"] = "CENTER", ["RIGHT"] = "RIGHT"}
R.JUSTIFY_V = {["TOP"] = "TOP", ["CENTER"] = "CENTER", ["BOTTOM"] = "BOTTOM"}
R.FONT_OUTLINES = {["NONE"] = "NONE", ["OUTLINE"] = "OUTLINE", ["THICKOUTLINE"] = "THICKOUTLINE"}
R.FONT_MIN_SIZE = 4
R.FONT_MAX_SIZE = 30
R.BORDER_STYLES = {
    [R.media.textures.borders.beautycase] = "BeautyCase",
    [R.media.textures.borders.cainyx] = "Cainyx",
    [R.media.textures.borders.caith] = "Caith",
    [R.media.textures.borders.diablo] = "Diablo",
    [R.media.textures.borders.entropy] = "Entropy",
    [R.media.textures.borders.goldpaw] = "Goldpaw",
    [R.media.textures.borders.onyx] = "Onyx",
    [R.media.textures.borders.retina] = "Retina"
}
R.GLOW_STYLES = {
    [R.media.textures.borders.gloss1] = "Gloss 1",
    [R.media.textures.borders.gloss2] = "Gloss 2",
    [R.media.textures.borders.gloss3] = "Gloss 3"
}

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
        borders = {size = 4, texture = R.media.textures.borders.beautycase, color = {89 / 255, 89 / 255, 89 / 255, 1}},
        gloss = {size = 3, texture = R.media.textures.borders.gloss2, color = {1, 1, 1, 0.4}},
        shadows = {color = {0, 0, 0}},
        colors = {
            normalFont = {255 / 255, 209 / 255, 0 / 255}, -- GameFontNormal
            highlightFont = {255 / 255, 255 / 255, 255 / 255}, -- GameFontHighlight
            greenFont = {25 / 255, 255 / 255, 25 / 255}, -- GameFontGreen
            redFont = {255 / 255, 25 / 255, 25 / 255}, -- GameFontRed
            grayFont = {127 / 255, 127 / 255, 127 / 255}, -- GameFontGray
            darkGrayFont = {89 / 255, 89 / 255, 89 / 255} -- GameFontDarkGray
        },
        modules = {}
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
                toggleFrameLock = {
                    order = 2,
                    type = "execute",
                    name = function()
                        return R.framesLocked and "Unlock Frames" or "Lock Frames"
                    end,
                    desc = "Lock/unlock all movable frames.",
                    func = function()
                        if R.framesLocked then
                            R:ShowDragFrames()
                        else
                            R:HideDragFrames()
                        end
                    end
                },
                resetFrames = {
                    order = 3,
                    type = "execute",
                    name = "Reset Frames",
                    desc = "Reset the position of all movable frames.",
                    func = function()
                        R:ResetFrames()
                    end
                },
                fonts = {
                    type = "group",
                    name = "Fonts",
                    order = 10,
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
                },
                borders = {
                    type = "group",
                    name = "Border Defaults",
                    order = 20,
                    inline = true,
                    args = {
                        point = {
                            type = "select",
                            name = "Style",
                            desc = "The default style of borders.",
                            order = 1,
                            values = R.BORDER_STYLES,
                            get = function()
                                return R.config.db.profile.borders.texture
                            end,
                            set = function(_, key)
                                R.config.db.profile.borders.texture = key
                                R:UpdateAllBorders(nil, R.config.db.profile.borders.texture)
                            end
                        },
                        size = {
                            type = "range",
                            name = "Size",
                            desc = "The default size of borders.",
                            order = 2,
                            min = 1,
                            softMax = 10,
                            step = 1,
                            get = function()
                                return R.config.db.profile.borders.size
                            end,
                            set = function(_, val)
                                R.config.db.profile.borders.size = val
                                R:UpdateAllBorders(R.config.db.profile.borders.size)
                            end
                        },
                        color = {
                            type = "color",
                            name = "Color",
                            desc = "The default color of borders.",
                            order = 3,
                            hasAlpha = true,
                            get = function()
                                local color = R.config.db.profile.borders.color
                                return color[1], color[2], color[3], color[4]
                            end,
                            set = function(_, r, g, b, a)
                                local color = R.config.db.profile.borders.color
                                color[1] = r
                                color[2] = g
                                color[3] = b
                                color[4] = a
                                R:UpdateAllGlossOverlays(nil, nil, R.config.db.profile.borders.color)
                            end
                        }
                    }
                },
                gloss = {
                    type = "group",
                    name = "Gloss Overlay Defaults",
                    order = 30,
                    inline = true,
                    args = {
                        point = {
                            type = "select",
                            name = "Style",
                            desc = "The default style of gloss overlays.",
                            order = 1,
                            values = R.GLOW_STYLES,
                            get = function()
                                return R.config.db.profile.gloss.texture
                            end,
                            set = function(_, key)
                                R.config.db.profile.gloss.texture = key
                                R:UpdateAllGlossOverlays(nil, R.config.db.profile.gloss.texture)
                            end
                        },
                        size = {
                            type = "range",
                            name = "Size",
                            desc = "The default size of gloss borders.",
                            order = 2,
                            min = 1,
                            softMax = 10,
                            step = 1,
                            get = function()
                                return R.config.db.profile.gloss.size
                            end,
                            set = function(_, val)
                                R.config.db.profile.gloss.size = val
                                R:UpdateAllGlossOverlays(R.config.db.profile.gloss.size)
                            end
                        },
                        color = {
                            type = "color",
                            name = "Color",
                            desc = "The default color of gloss overlays.",
                            order = 3,
                            hasAlpha = true,
                            get = function()
                                local color = R.config.db.profile.gloss.color
                                return color[1], color[2], color[3], color[4]
                            end,
                            set = function(_, r, g, b, a)
                                local color = R.config.db.profile.gloss.color
                                color[1] = r
                                color[2] = g
                                color[3] = b
                                color[4] = a
                                R:UpdateAllGlossOverlays(nil, nil, R.config.db.profile.gloss.color)
                            end
                        }
                    }
                },
                inventoryDatabase = {
                    type = "group",
                    name = "Inventory Database",
                    order = 40,
                    inline = true,
                    args = {
                        character = {
                            type = "select",
                            name = "Characters",
                            desc = "Characters in the inventory database.",
                            order = 1,
                            values = R.Modules.InventoryDatabase.GetCharacterKeys,
                            get = function()
                                return R.Modules.InventoryDatabase.selectedCharacter
                            end,
                            set = function(_, key)
                                R.Modules.InventoryDatabase.selectedCharacter = key
                            end
                        },
                        clear = {
                            order = 2,
                            type = "execute",
                            name = "Clear Character Database",
                            disabled = function()
                                return R.Modules.InventoryDatabase.selectedCharacter == nil
                            end,
                            func = function()
                                R.Modules.InventoryDatabase:ClearCharacterDatabase(R.Modules.InventoryDatabase.selectedCharacter)
                            end
                        }
                    }
                }
            }
        }
    }
}

R.config.faders = {none = nil, onShow = 1, mouseOver = 2}

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

function R:RegisterModuleConfig(module, profile, char, realm)
    R.config.defaults.profile.modules[module.name] = profile
    module.defaults = profile
    if char then
        R.config.defaults.char.modules[module.name] = char
        module.charDefaults = char
    end
    if realm then
        R.config.defaults.realm.modules[module.name] = realm
        module.realmDefaults = realm
    end
end

function R:RegisterModuleOptions(module, options)
    options.order = 100 + #R.config.options.args
    R.config.options.args[module.name] = options
    module.options = options
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
    R.Libs.AceConfigDialog:SetDefaultSize(addonName, 900, 700)
end

function R:RefreshConfig()
    R.config.db = R.Libs.AceDB:New(addonName .. "_DB", R.config.defaults)
end
