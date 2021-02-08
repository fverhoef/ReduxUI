local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

AB.themes = {
    Default = "Default",
    Alliance = "Alliance",
    Amber = "Amber",
    Bamboo = "Bamboo",
    Darkmoon = "Darkmoon",
    Faction = "Faction",
    Fancy = "Fancy",
    Generic = "Generic",
    Horde = "Horde",
    Mechanical = "Mechanical",
    Mechanical2 = "Mechanical2",
    Natural = "Natural",
    PandarenWood = "PandarenWood",
    Stone = "Stone",
    Tree = "Tree",
    Wood = "Wood"
}

R:RegisterModuleConfig(AB, {
    enabled = true,
    mainMenuBar = {
        theme = AB.themes.Default,
        fader = R.config.faders.onShow
        -- frameVisibility = "[combat][mod:shift][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide"
    },
    multiBarBottomLeft = {fader = R.config.faders.none},
    multiBarBottomRight = {fader = R.config.faders.none},
    multiBarLeft = {fader = R.config.faders.mouseOver},
    multiBarRight = {fader = R.config.faders.mouseOver},
    microButtonAndBags = {
        lowLatencyTreshold = 70,
        lowLatencyColor = {0 / 255, 175 / 255, 0 / 255},
        mediumLatencyTreshold = 120,
        mediumLatencyColor = {225 / 255, 150 / 255, 0 / 255},
        highLatencyColor = {225 / 255, 0 / 255, 0 / 255},
        lowFpsTreshold = 20,
        lowFpsColor = {225 / 255, 0 / 255, 0 / 255},
        mediumFpsTreshold = 50,
        mediumFpsColor = {225 / 255, 150 / 255, 0 / 255},
        highFpsColor = {0 / 255, 175 / 255, 0 / 255},
        addonsToDisplay = 10,
        fader = R.config.faders.mouseOver
    },
    stanceBar = {
        {fader = R.config.faders.onShow}
        -- frameVisibility = "[overridebar][vehicleui][possessbar][shapeshift] hide; show"
    },
    petActionBar = {
        {fader = R.config.faders.onShow},
        frameVisibility = "[overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide"
    },
    vehicleExitBar = {{fader = R.config.faders.onShow}}
})

R:RegisterModuleOptions(AB, {
    type = "group",
    name = "Action Bars",
    args = {
        header = {type = "header", name = R.title .. " > Action Bars", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            confirm = function()
                return "Disabling this module requires a UI reload. Proceed?"
            end,
            get = function()
                return AB.config.enabled
            end,
            set = function(_, val)
                AB.config.enabled = val
                ReloadUI()
            end,
            order = 1
        },
        mainMenuBar = {
            type = "group",
            name = "Main Action Bar",
            order = 2,
            inline = true,
            args = {
                theme = {
                    type = "select",
                    name = "Theme",
                    order = 1,
                    values = AB.themes,
                    get = function()
                        for key, val in pairs(AB.themes) do
                            if AB.config.mainMenuBar.theme == val then
                                return val
                            end
                        end
                    end,
                    set = function(_, key)
                        AB.config.mainMenuBar.theme = AB.themes[key]
                        AB:UpdateAll()
                    end
                }
            }
        }
    }
})
