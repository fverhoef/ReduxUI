local addonName, ns = ...
local R = _G.ReduxUI
local C = R.Modules.Chat
local L = R.L

R:RegisterModuleOptions(C, {
    type = "group",
    name = L["Chat"],
    args = {
        header = {type = "header", name = R.title .. " > Chat", order = 0},
        enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return C.config.enabled end, function(value) C.config.enabled = value end,
                                       function() (not C.config.enabled and ReloadUI or C.Initialize)() end,
                                       function() return C.config.enabled and L["Disabling this module requires a UI reload. Proceed?"] end),
        lineBreak = {type = "header", name = "", order = 2},
        showClassColors = R:CreateToggleOption(L["Show Class Colors"], nil, 3, "full", nil, function() return C.config.showClassColors end, function(value) C.config.showClassColors = value end,
                                               C.UpdateChatFrames),
        hideMenuButton = R:CreateToggleOption(L["Hide Menu Button"], nil, 4, "full", nil, function() return C.config.hideMenuButton end, function(value) C.config.hideMenuButton = value end,
                                              C.UpdateChatFrames),
        hideChannelButton = R:CreateToggleOption(L["Hide Channel Button"], nil, 5, "full", nil, function() return C.config.hideChannelButton end,
                                                 function(value) C.config.hideChannelButton = value end, C.UpdateChatFrames),
        hideSocialButton = R:CreateToggleOption(L["Hide Social Button"], nil, 6, "full", nil, function() return C.config.hideSocialButton end,
                                                 function(value) C.config.hideSocialButton = value end, C.UpdateChatFrames),
        font = {
            type = "group",
            name = L["Font"],
            inline = true,
            order = 7,
            args = {
                font = R:CreateFontOption(L["Font"], L["The font to use for chat text."], 1, nil, function() return C.config.font end, function(value) C.config.font = value end, R.UpdateChatFrames),
                size = R:CreateRangeOption(L["Font Size"], L["The size of chat text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function() return C.config.fontSize end,
                                           function(value) C.config.fontSize = value end, C.UpdateChatFrames),
                outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of this text."], 3, nil, R.FONT_OUTLINES, function() return C.config.fontOutline end,
                                               function(value) C.config.fontOutline = value end, C.UpdateChatFrames),
                shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for this text."], 4, nil, nil, function() return C.config.fontShadow end,
                                              function(value) C.config.fontShadow = value end, C.UpdateChatFrames)
            }
        },
        history = {
            type = "group",
            name = L["History"],
            inline = true,
            order = 8,
            args = {
                maxMessageCount = R:CreateRangeOption(L["Max Message Count"], L["The maximum number of messages in the text."], 1, nil, 100, 4000, nil, 10,
                                                      function() return C.config.maxMessageCount end, function(value) C.config.maxMessageCount = value end, C.UpdateChatFrames),
                maxHistoryCount = R:CreateRangeOption(L["Max History Count"], L["The maximum number of messages to store in the history database."], 2, nil, 100, 4000, nil, 10,
                                                      function() return C.config.maxMessageCount end, function(value) C.config.maxMessageCount = value end, C.UpdateChatFrames),
                clearHistory = {type = "execute", name = "Clear History", order = 4, func = function() C:ClearChatHistory() end}
            }
        }
    }
})
