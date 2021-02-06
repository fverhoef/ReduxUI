local addonName, ns = ...
local R = _G.ReduxUI
local C = R.Modules.Chat

R:RegisterModuleConfig(C, {
    enabled = true,
    font = {R.config.defaults.profile.fonts.normal, 12, "OUTLINE"},
    maxMessageCount = 1500,
    maxHistoryCount = 500,
    showClassColors = true,
    hideMenuButton = true,
    hideChannelButton = true
}, {chatMessages = {}})

R:RegisterModuleOptions(C, {
    type = "group",
    name = "Chat",
    args = {
        header = {type = "header", name = R.title .. " > Chat", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if C.config.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return C.config.enabled
            end,
            set = function(_, val)
                C.config.enabled = val
                if not val then
                    ReloadUI()
                else
                    C:Initialize()
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
                    values = R.Libs.SharedMedia:HashTable("font"),
                    get = function()
                        for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do
                            if C.config.font[1] == font then
                                return key
                            end
                        end
                    end,
                    set = function(_, key)
                        C.config.font[1] = R.Libs.SharedMedia:Fetch("font", key)
                        C:UpdateChatFrames()
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
                        return C.config.font[2]
                    end,
                    set = function(_, val)
                        C.config.font[2] = val
                        C:UpdateChatFrames()
                    end
                },
                outline = {
                    type = "select",
                    name = "Font Outline",
                    order = 3,
                    values = R.FONT_OUTLINES,
                    get = function()
                        return C.config.font[3]
                    end,
                    set = function(_, val)
                        C.config.font[3] = val
                        C:UpdateChatFrames()
                    end
                }
            }
        },
        maxMessageCount = {
            type = "range",
            name = "Max Message Count",
            order = 4,
            min = 100,
            softMax = 4000,
            step = 100,
            width = "full",
            get = function()
                return C.config.maxMessageCount
            end,
            set = function(_, val)
                C.config.maxMessageCount = val
                C:UpdateChatFrames()
            end
        },
        maxHistoryCount = {
            type = "range",
            name = "Max History Count",
            order = 5,
            min = 100,
            softMax = 4000,
            step = 100,
            width = "full",
            get = function()
                return C.config.maxHistoryCount
            end,
            set = function(_, val)
                C.config.maxHistoryCount = val
                C:UpdateChatFrames()
            end
        },
        clearHistory = {
            type = "execute",
            name = "Clear History",
            order = 6,
            func = function()
                C:ClearChatHistory()
            end
        },
        showClassColors = {
            type = "toggle",
            name = "Show Class Colors",
            order = 20,
            width = "full",
            get = function()
                return C.config.showClassColors
            end,
            set = function(_, val)
                C.config.showClassColors = val
                C:UpdateChatFrames()
            end
        },
        hideMenuButton = {
            type = "toggle",
            name = "Hide Menu Button",
            order = 21,
            width = "full",
            get = function()
                return C.config.hideMenuButton
            end,
            set = function(_, val)
                C.config.hideMenuButton = val
                C:UpdateChatFrames()
            end
        },
        hideChannelButton = {
            type = "toggle",
            name = "Hide Channel Button",
            order = 22,
            width = "full",
            get = function()
                return C.config.hideChannelButton
            end,
            set = function(_, val)
                C.config.hideChannelButton = val
                C:UpdateChatFrames()
            end
        }
    }
})
