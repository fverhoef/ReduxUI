local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local AB = Addon.Modules.ActionBars

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

Addon.config.defaults.profile.modules.actionBars = {
    enabled = true,
    mainMenuBar = {
        theme = AB.themes.Default,
        fader = Addon.config.faders.onShow
        -- frameVisibility = "[combat][mod:shift][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide"
    },
    multiBarLeft = {fader = Addon.config.faders.mouseOver},
    multiBarRight = {fader = Addon.config.faders.mouseOver},
    microButtonAndBags = {
        lowLatencyTreshold = 50,
        lowLatencyColor = {0 / 255, 175 / 255, 0 / 255},
        mediumLatencyTreshold = 100,
        mediumLatencyColor = {225 / 255, 150 / 255, 0 / 255},
        highLatencyColor = {225 / 255, 0 / 255, 0 / 255},
        lowFpsTreshold = 20,
        lowFpsColor = {225 / 255, 0 / 255, 0 / 255},
        mediumFpsTreshold = 50,
        mediumFpsColor = {225 / 255, 150 / 255, 0 / 255},
        highFpsColor = {0 / 255, 175 / 255, 0 / 255},
        addonsToDisplay = 10,
        fader = Addon.config.faders.mouseOver
    },
    stanceBar = {
        -- frameVisibility = "[overridebar][vehicleui][possessbar][shapeshift] hide; show"
    },
    petActionBar = {frameVisibility = "[overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide"}
}

Addon.config.options.args.actionBars = {
    type = "group",
    name = "Action Bars",
    order = 2,
    args = {
        header = {type = "header", name = Addon.title .. " > Action Bars", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            confirm = function()
                return "Disabling this module requires a UI reload. Proceed?"
            end,
            get = function()
                return AB.config.db.profile.enabled
            end,
            set = function(_, val)
                AB.config.db.profile.enabled = val
                ReloadUI()
            end,
            order = 1
        },
        mainMenuBar = {
            type = "group",
            name = "Main Action Bar",
            order = 2,
            args = {
                theme = {
                    type = "select",
                    name = "Theme",
                    order = 1,
                    values = AB.themes,
                    get = function()
                        for key, val in pairs(AB.themes) do
                            if AB.config.db.profile.mainMenuBar.theme == val then
                                return val
                            end
                        end
                    end,
                    set = function(_, key)
                        AB.config.db.profile.mainMenuBar.theme = AB.themes[key]
                        AB:OnUpdate()
                    end
                }
            }
        }
    }
}
