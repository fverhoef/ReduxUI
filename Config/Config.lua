local AddonName, AddonTable = ...
local Addon = AddonTable[1]

Addon.FONT_OUTLINES = {["NONE"] = "NONE", ["OUTLINE"] = "OUTLINE", ["THICKOUTLINE"] = "THICKOUTLINE"}

Addon.config = {}
Addon.config.defaults = {
    profile = {
        fonts = {
            damage = Addon.Libs.SharedMedia:Fetch("font", "Adventure"),
            normal = Addon.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            number = Addon.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            unitName = Addon.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            chatBubble = Addon.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            replaceBlizzardFonts = true
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
            ["*"] = {
                enabled = true
            }
        }
    },
    char = {modules = {}},
    realm = {inventory = {}, modules = {}}
}

Addon.config.options = {
    type = "group",
    name = Addon.title,
    args = {
        general = {
            type = "group",
            name = "General",
            order = 1,
            args = {
                header = {type = "header", name = Addon.title .. " > General", order = 0},
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
                            values = Addon.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(Addon.Libs.SharedMedia:HashTable("font")) do
                                    if Addon.config.db.profile.fonts.normal == font then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                Addon.config.db.profile.fonts.normal = Addon.Libs.SharedMedia:Fetch("font", key)
                                Addon:UpdateBlizzardFonts()
                            end
                        },
                        number = {
                            name = "Numbers",
                            type = "select",
                            order = 2,
                            dialogControl = "LSM30_Font",
                            values = Addon.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(Addon.Libs.SharedMedia:HashTable("font")) do
                                    if Addon.config.db.profile.fonts.number == font then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                Addon.config.db.profile.fonts.number = Addon.Libs.SharedMedia:Fetch("font", key)
                                Addon:UpdateBlizzardFonts()
                            end
                        },
                        damage = {
                            name = "Damage",
                            type = "select",
                            order = 3,
                            dialogControl = "LSM30_Font",
                            values = Addon.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(Addon.Libs.SharedMedia:HashTable("font")) do
                                    if Addon.config.db.profile.fonts.damage == font then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                Addon.config.db.profile.fonts.damage = Addon.Libs.SharedMedia:Fetch("font", key)
                                Addon:UpdateBlizzardFonts()
                            end
                        },
                        unitName = {
                            name = "Unit Names",
                            type = "select",
                            order = 4,
                            dialogControl = "LSM30_Font",
                            values = Addon.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(Addon.Libs.SharedMedia:HashTable("font")) do
                                    if Addon.config.db.profile.fonts.unitName == font then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                Addon.config.db.profile.fonts.unitName = Addon.Libs.SharedMedia:Fetch("font", key)
                                Addon:UpdateBlizzardFonts()
                            end
                        },
                        chatBubble = {
                            name = "Chat Bubbles",
                            type = "select",
                            order = 5,
                            dialogControl = "LSM30_Font",
                            values = Addon.Libs.SharedMedia:HashTable("font"),
                            get = function()
                                for key, font in pairs(Addon.Libs.SharedMedia:HashTable("font")) do
                                    if Addon.config.db.profile.fonts.chatBubble == font then
                                        return key
                                    end
                                end
                            end,
                            set = function(_, key)
                                Addon.config.db.profile.fonts.chatBubble = Addon.Libs.SharedMedia:Fetch("font", key)
                                Addon:UpdateBlizzardFonts()
                            end
                        }
                    }
                }
            }
        }
    }
}

Addon.config.faders = {
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
    local logo = CreateFrame("Frame", nil, frame)
    logo:SetFrameLevel(4)
    logo:SetSize(64, 64)
    logo:SetPoint("TOPRIGHT", 8, 24)
    logo:SetBackdrop({bgFile = Addon.media.textures.Logo})

    frame.logo = logo
end

function Addon:SetupConfig()
    Addon.config.db = Addon.Libs.AceDB:New(AddonName .. "_DB", Addon.config.defaults)

    Addon.config.options.args.profiles = Addon.Libs.AceDBOptions:GetOptionsTable(Addon.config.db)
    Addon.config.options.args.profiles.order = 99

    Addon.Libs.AceConfigRegistry:RegisterOptionsTable(AddonName, Addon.config.options)
    Addon.config.dialog = Addon.Libs.AceConfigDialog:AddToBlizOptions(AddonName, Addon.title)
    Addon.config.dialog:HookScript("OnShow", function()
        local p = FindPanel(AddOnName)
        if p and p.element.collapsed then
            OptionsListButtonToggle_OnClick(p.toggle)
        end
    end)

    AddLogo(Addon.config.dialog)
end
