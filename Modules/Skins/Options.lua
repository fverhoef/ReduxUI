local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins
local L = R.L

R:RegisterModuleOptions(S, {
    type = "group",
    name = L["Skins"],
    hidden = R.isRetail,
    args = {
        header = {type = "header", name = R.title .. " > Skins", order = 0},
        enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function() return S.config.enabled end, function(value) S.config.enabled = value end,
                                       function() (not S.config.enabled and ReloadUI or C.Initialize)() end,
                                       function() return S.config.enabled and L["Disabling this module requires a UI reload. Proceed?"] end),
        lineBreak1 = {type = "header", name = "", order = 2},
        character = R:CreateToggleOption(L["Retail-style Character Frame"], nil, 3, "full", nil, function() return S.config.character end, function(value) S.config.character = value end,
                                         function() (not S.config.character and ReloadUI or C.Initialize)() end,
                                         function() return S.config.character and L["Disabling this feature requires a UI reload. Proceed?"] end),
        friends = R:CreateToggleOption(L["Style Friends Frame"], nil, 4, "full", nil, function() return S.config.friends end, function(value) S.config.friends = value end,
                                       function() (not S.config.friends and ReloadUI or C.Initialize)() end,
                                       function() return S.config.friends and L["Disabling this feature requires a UI reload. Proceed?"] end),
        guild = R:CreateToggleOption(L["Style Guild Frame"], nil, 5, "full", nil, function() return S.config.guild end, function(value) S.config.guild = value end,
                                     function() (not S.config.guild and ReloadUI or C.Initialize)() end,
                                     function() return S.config.guild and L["Disabling this feature requires a UI reload. Proceed?"] end),
        who = R:CreateToggleOption(L["Style Who Frame"], nil, 6, "full", nil, function() return S.config.who end, function(value) S.config.who = value end,
                                   function() (not S.config.who and ReloadUI or C.Initialize)() end, function()
            return S.config.who and L["Disabling this feature requires a UI reload. Proceed?"]
        end),
        worldMap = R:CreateToggleOption(L["Style World Map"], nil, 7, "full", nil, function() return S.config.worldMap end, function(value) S.config.worldMap = value end,
                                        function() (not S.config.worldMap and ReloadUI or C.Initialize)() end,
                                        function() return S.config.worldMap and L["Disabling this feature requires a UI reload. Proceed?"] end),
        classTrainer = R:CreateToggleOption(L["Wider Class Trainer Frame"], nil, 8, "full", nil, function() return S.config.classTrainer end, function(value) S.config.classTrainer = value end,
                                            function() (not S.config.classTrainer and ReloadUI or C.Initialize)() end,
                                            function() return S.config.classTrainer and L["Disabling this feature requires a UI reload. Proceed?"] end),
        questLog = R:CreateToggleOption(L["Wider Quest Log"], nil, 9, "full", nil, function() return S.config.questLog end, function(value) S.config.questLog = value end,
                                        function() (not S.config.questLog and ReloadUI or C.Initialize)() end,
                                        function() return S.config.questLog and L["Disabling this feature requires a UI reload. Proceed?"] end),
        tradeSkill = R:CreateToggleOption(L["Wider Trade Skill Frame"], nil, 10, "full", nil, function() return S.config.tradeSkill end, function(value) S.config.tradeSkill = value end,
                                          function() (not S.config.tradeSkill and ReloadUI or C.Initialize)() end,
                                          function() return S.config.tradeSkill and L["Disabling this feature requires a UI reload. Proceed?"] end)
    }
})
