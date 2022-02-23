local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins
local L = R.L

function S:CreateEnabledOption(name, desc, order, hidden, property, reload)
    return R:CreateToggleOption(name, desc, order, "double", hidden, function() return S.config[property].enabled end, function(value) S.config[property].enabled = value end,
                                function() (not S.config[property].enabled and ReloadUI or C.Initialize)() end,
                                function() return S.config[property].enabled and L["Disabling this feature requires a UI reload. Proceed?"] end)
end

R:RegisterModuleOptions(S, {
    type = "group",
    name = L["Skins"],
    args = {
        header = {type = "header", name = R.title .. " > Skins", order = 0},
        enabled = R:CreateModuleEnabledOption(1, nil, "Skins"),
        lineBreak1 = {type = "header", name = "", order = 2},
        fonts = {
            type = "group",
            name = L["Fonts"],
            order = 3,
            inline = true,
            args = {
                enabled = S:CreateEnabledOption(L["Replace Blizzard Fonts"], nil, 1, nil, "fonts", true),
                lineBreak1 = {type = "header", name = "", order = 2},
                normal = R:CreateFontOption(L["Standard Text"], nil, 3, nil, function() return S.config.fonts.normal end, function(value) S.config.fonts.normal = value end, S.UpdateBlizzardFonts),
                number = R:CreateFontOption(L["Numbers"], nil, 4, nil, function() return S.config.fonts.number end, function(value) S.config.fonts.number = value end, S.UpdateBlizzardFonts),
                damage = R:CreateFontOption(L["Damage"], nil, 5, nil, function() return S.config.fonts.damage end, function(value) S.config.fonts.damage = value end, _G.Logout,
                                            L["Changing the damage font requires you to log out. Proceed?"]),
                unitName = R:CreateFontOption(L["Unit Names"], nil, 6, nil, function() return S.config.fonts.unitName end, function(value) S.config.fonts.unitName = value end, _G.Logout,
                                              L["Changing the unit name font requires you to log out. Proceed?"]),
                chatBubble = R:CreateFontOption(L["Chat Bubbles"], nil, 7, nil, function() return R.config.db.profile.fonts.chatBubble end, function(value)
                    S.config.fonts.chatBubble = value
                end, S.UpdateBlizzardFonts)
            }
        },
        movers = {
            type = "group",
            name = L["Movers"],
            order = 4,
            inline = true,
            args = {
                durability = S:CreateEnabledOption(L["Move Durability Frame"], nil, 1, nil, "durability", true),
                objectiveTracker = S:CreateEnabledOption(L["Move Quest/Objective Tracker"], nil, 2, nil, "objectiveTracker", true),
                ticketStatus = S:CreateEnabledOption(L["Move GM Ticket Status"], nil, 3, nil, "ticketStatus", true),
                vehicleSeat = S:CreateEnabledOption(L["Move Vehicle Seat Frame"], nil, 4, not R.isRetail, "vehicleSeat", true)
            }
        },
        frameCustomization = {
            type = "group",
            name = L["Frame Customization"],
            order = 5,
            inline = true,
            hidden = R.isRetail,
            args = {
                character = S:CreateEnabledOption(L["Retail-style Character Frame"], nil, 1, R.isRetail, "character", true),
                friends = S:CreateEnabledOption(L["Style Friends Frame"], nil, 2, R.isRetail, "friends", true),
                guild = S:CreateEnabledOption(L["Style Guild Frame"], nil, 3, R.isRetail, "guild", true),
                who = S:CreateEnabledOption(L["Style Who Frame"], nil, 4, R.isRetail, "who", true),
                worldMap = S:CreateEnabledOption(L["Style World Map"], nil, 5, R.isRetail, "worldMap", true),
                classTrainer = S:CreateEnabledOption(L["Wider Class Trainer Frame"], nil, 6, R.isRetail, "classTrainer", true),
                questLog = S:CreateEnabledOption(L["Wider Quest Log"], nil, 7, R.isRetail, "questLog", true),
                tradeSkill = S:CreateEnabledOption(L["Wider Trade Skill Frame"], nil, 8, R.isRetail, "tradeSkill", true)
            }
        }
    }
})
