local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local C = Addon.Modules.Chat

Addon.config.defaults.profile.modules.chat = {
    enabled = true,
    font = {Addon.config.defaults.profile.fonts.normal, 12, "OUTLINE"},
    maxMessageCount = 500,
    maxHistoryCount = 500,
    showClassColors = true,
    hideMenuButton = true,
    hideChannelButton = true
}

Addon.config.defaults.char.modules.chat = {
    chatMessages = {}
}

Addon.config.options.args.chat = {
    type = "group",
    name = "Chat",
    order = 6,
    args = {
        header = {type = "header", name = Addon.title .. " > Chat", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if C.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return C.config.db.profile.enabled
            end,
            set = function(_, val)
                C.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.Chat:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2},
        font = {
            type = "group",
            name = "Font",
            inline = true,
            order = 3,
            args = {
                face = {
                    type = "select",
                    name = "Font Face",
                    order = 1,
                    dialogControl = "LSM30_Font",
                    values = Addon.Libs.SharedMedia:HashTable("font"),
                    get = function()
                        for key, font in pairs(Addon.Libs.SharedMedia:HashTable("font")) do
                            if C.config.db.profile.font[1] == font then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        C.config.db.profile.font[1] = Addon.Libs.SharedMedia:Fetch("font", key)
                        Addon.Modules.Chat:UpdateChatFrames()
                    end
                },
                size = {
                    type = "range",
                    name = "Font Size",
                    order = 2,
                    min = 8,
                    softMax = 36,
                    step = 1,
                    get = function()
                        return C.config.db.profile.font[2]
                    end,
                    set = function(_, val)
                        C.config.db.profile.font[2] = val
                        Addon.Modules.Chat:UpdateChatFrames()
                    end
                },
                outline = {
                    type = "select",
                    name = "Font Outline",
                    order = 3,
                    values = Addon.FONT_OUTLINES,
                    get = function()
                        return C.config.db.profile.font[3]
                    end,
                    set = function(_, val)
                        C.config.db.profile.font[3] = val
                        Addon.Modules.Chat:UpdateChatFrames()
                    end
                }
            }
        },
        maxMessageCount = {
            type = "toggle",
            type = "range",
            name = "Max Message Count",
            order = 4,
            min = 100,
            softMax = 4000,
            step = 100,
            width = "full",
            get = function()
                return C.config.db.profile.maxMessageCount
            end,
            set = function(_, val)
                C.config.db.profile.maxMessageCount = val
                Addon.Modules.Chat:UpdateChatFrames()
            end
        },
        maxHistoryCount = {
            type = "toggle",
            type = "range",
            name = "Max History Count",
            order = 5,
            min = 100,
            softMax = 4000,
            step = 100,
            width = "full",
            get = function()
                return C.config.db.profile.maxHistoryCount
            end,
            set = function(_, val)
                C.config.db.profile.maxHistoryCount = val
                Addon.Modules.Chat:UpdateChatFrames()
            end
        },
        showClassColors = {
            type = "toggle",
            name = "Show Class Colors",
            order = 20,
            width = "full",
            get = function()
                return C.config.db.profile.showClassColors
            end,
            set = function(_, val)
                C.config.db.profile.showClassColors = val
                Addon.Modules.Chat:UpdateChatFrames()
            end
        },
        hideMenuButton = {
            type = "toggle",
            name = "Hide Menu Button",
            order = 21,
            width = "full",
            get = function()
                return C.config.db.profile.hideMenuButton
            end,
            set = function(_, val)
                C.config.db.profile.hideMenuButton = val
                Addon.Modules.Chat:UpdateChatFrames()
            end
        },
        hideChannelButton = {
            type = "toggle",
            name = "Hide Channel Button",
            order = 22,
            width = "full",
            get = function()
                return C.config.db.profile.hideChannelButton
            end,
            set = function(_, val)
                C.config.db.profile.hideChannelButton = val
                Addon.Modules.Chat:UpdateChatFrames()
            end
        }
    }
}