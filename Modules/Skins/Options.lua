local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins
local L = R.L

function S:CreateEnabledOption(name, desc, order, hidden, property, reload)
    return R:CreateToggleOption(name, desc, order, "double", hidden, function()
        return S.config[property].enabled
    end, function(value)
        S.config[property].enabled = value
    end, function()
        (not S.config[property].enabled and ReloadUI or S.Initialize)()
    end, function()
        return S.config[property].enabled and L["Disabling this feature requires a UI reload. Proceed?"]
    end)
end

R:RegisterModuleOptions(S, {
    type = "group",
    name = L["Skins"],
    args = {
        header = { type = "header", name = R.title .. " > Skins", order = 0 },
        enabled = R:CreateModuleEnabledOption(1, nil, "Skins"),
        lineBreak1 = { type = "header", name = "", order = 2 },
        fonts = {
            type = "group",
            name = L["Fonts"],
            order = 3,
            inline = true,
            args = {
                enabled = S:CreateEnabledOption(L["Replace Blizzard Fonts"], nil, 1, nil, "fonts", true),
                lineBreak1 = { type = "header", name = "", order = 2 },
                damage = R:CreateFontOption(L["Damage"], nil, 5, nil, function()
                    return S.config.fonts.damage
                end, function(value)
                    S.config.fonts.damage = value
                end, _G.Logout, function()
                    return L["Changing the damage font requires you to log out. Proceed?"]
                end),
                unitName = R:CreateFontOption(L["Unit Names"], nil, 6, nil, function()
                    return S.config.fonts.unitName
                end, function(value)
                    S.config.fonts.unitName = value
                end, _G.Logout, function()
                    return L["Changing the unit name font requires you to log out. Proceed?"]
                end),
                chatBubble = R:CreateFontOption(L["Chat Bubbles"], nil, 7, nil, function()
                    return S.config.fonts.chatBubble
                end, function(value)
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
                character = S:CreateEnabledOption(L["Style Character Frame"], L["Style the Character frame, enlarging it and showing attributes in an embedded panel to the right."], 1, R.isRetail,
                                                  "character", true),
                showGearScore = R:CreateToggleOption(L["Show Gear Score"], L["Whether to show Gear Score on the Character frame."], 2, "double", function()
                    return not R.isWrath or not S.config.character.enabled
                end, function()
                    return S.config.character.showGearScore
                end, function(value)
                    S.config.character.showGearScore = value
                end, function()
                    S:UpdateCharacterStatsPane()
                end),
                friends = S:CreateEnabledOption(L["Style Friends Frame"], L["Style the Friends frame, adding class coloring and icons."], 3, R.isRetail, "friends", true),
                guild = S:CreateEnabledOption(L["Style Guild Frame"], L["Style the Guild frame, adding class coloring and icons."], 4, R.isRetail, "guild", true),
                questLog = S:CreateEnabledOption(L["Style Quest Log Frame"], L["Style the Quest Log frame, making it larger and showing more items."], 5, R.isRetail, "questLog", true),
                tradeSkill = S:CreateEnabledOption(L["Style Trade Skill Frame"], L["Style the Professions frame, making it larger and showing more items."], 6, R.isRetail, "tradeSkill", true),
                who = S:CreateEnabledOption(L["Style Who Frame"], L["Style the Who frame, adding class coloring and icons."], 7, R.isRetail, "who", true),
                worldMap = S:CreateEnabledOption(L["Style World Map"], L["Style the World Map, no longer making it full screen, fading while moving and adding coordinates."], 8, R.isRetail,
                                                 "worldMap", true)
            }
        }
    }
})
