local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

AB.MAIN_MENU_BAR_THEMES = {
    Default = "Default",
    None = "None",
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
AB.ATTACHMENT_POINTS = {
    Center = "Center",
    Right = "Right"
}
AB.CLASS_BAR_DOCKS = {
    MainActionBar_Left = 1,
    MainActionBar_Right = 2
}

R:RegisterModuleConfig(AB, {
    enabled = true,
    mainMenuBar = {
        point = {"BOTTOM", "BOTTOM", 0, 10},
        fader = R.config.faders.onShow,
        artwork = {enabled = true, theme = AB.MAIN_MENU_BAR_THEMES.Default},
        page = {enabled = true},
        experience = {enabled = true},
        reputation = {enabled = true}
        -- frameVisibility = "[combat][mod:shift][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide"
    },
    multiBarBottomLeft = {enabled = true, detached = false, point = {"BOTTOM", "BOTTOM", 0, 50}, fader = R.config.faders.none, buttonsPerRow = 12},
    multiBarBottomRight = {enabled = true, detached = false, point = {"BOTTOM", "BOTTOM", 0, 90}, attachedPoint = AB.ATTACHMENT_POINTS.Right, fader = R.config.faders.none, buttonsPerRow = 12},
    multiBarLeft = {enabled = true, point = {"RIGHT", "RIGHT", 0, 0}, fader = R.config.faders.mouseOver},
    multiBarRight = {enabled = true, point = {"RIGHT", "RIGHT", 40, 0}, fader = R.config.faders.mouseOver},
    stanceBar = {
        enabled = true,
        point = {"BOTTOM", "BOTTOM", 0, 130},
        fader = R.config.faders.onShow,
        frameVisibility = "[overridebar][vehicleui][possessbar] hide; show"
    },
    petActionBar = {
        enabled = true,
        point = {"BOTTOM", "BOTTOM", 0, 130},
        fader = R.config.faders.onShow,
        frameVisibility = "[overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide"
    },
    vehicleExitBar = {enabled = true, point = {"BOTTOM", "BOTTOM", 0, 130}, fader = R.config.faders.onShow},
    experienceBar = {enabled = true, point = {"BOTTOM", "BOTTOM", 0, 0}, fader = R.config.faders.onShow},
    reputationBar = {enabled = true, point = {"BOTTOM", "BOTTOM", 0, 20}, fader = R.config.faders.onShow},
    maxLevelBar = {enabled = true, point = {"BOTTOM", "BOTTOM", 0, 0}, fader = R.config.faders.onShow},
    microButtonAndBags = {
        enabled = true,
        point = {"BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0},
        fader = R.config.faders.mouseOver,
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
        addonsToDisplay = 10
    },
    mageBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 50},
        buttonSize = 36,
        buttonSpacing = 6,
        dock = AB.CLASS_BAR_DOCKS.MainActionBar_Left,
        fader = R.config.faders.OnShow
    },
    shamanBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 50},
        buttonSize = 36,
        buttonSpacing = 6,
        dock = AB.CLASS_BAR_DOCKS.MainActionBar_Left,
        fader = R.config.faders.OnShow
    }
})

R:RegisterModuleOptions(AB, {
    type = "group",
    name = "Action Bars",
    args = {
        header = {type = "header", name = R.title .. " > Action Bars", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                return "Disabling this module requires a UI reload. Proceed?"
            end,
            get = function()
                return AB.config.enabled
            end,
            set = function(_, val)
                AB.config.enabled = val
                ReloadUI()
            end
        },
        mainMenuBar = {
            type = "group",
            name = "Main Action Bar",
            order = 2,
            inline = true,
            args = {
                artwork = {
                    type = "group",
                    name = "Artwork",
                    order = 10,
                    inline = true,
                    args = {
                        enabled = {
                            type = "toggle",
                            name = "Enabled",
                            order = 1,
                            get = function()
                                return AB.config.mainMenuBar.artwork.enabled
                            end,
                            set = function(_, val)
                                AB.config.mainMenuBar.artwork.enabled = val
                                AB:UpdateAll()
                            end
                        },
                        theme = {
                            type = "select",
                            name = "Theme",
                            order = 2,
                            values = AB.MAIN_MENU_BAR_THEMES,
                            get = function()
                                for key, val in pairs(AB.MAIN_MENU_BAR_THEMES) do
                                    if AB.config.mainMenuBar.artwork.theme == val then
                                        return val
                                    end
                                end
                            end,
                            set = function(_, key)
                                AB.config.mainMenuBar.artwork.theme = AB.MAIN_MENU_BAR_THEMES[key]
                                AB:UpdateAll()
                            end
                        }
                    }
                }
            }
        },
        multiBarBottomLeft = {
            type = "group",
            name = "Action Bar 2",
            order = 3,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.multiBarBottomLeft.enabled
                    end,
                    set = function(_, val)
                        AB.config.multiBarBottomLeft.enabled = val
                        _G.SHOW_MULTI_ACTIONBAR_1 = val
                        AB:UpdateAll()
                    end
                },
                linebreak = {type = "description", name = "", order = 2},
                detached = {
                    type = "toggle",
                    name = "Detached",
                    order = 3,
                    get = function()
                        return AB.config.multiBarBottomLeft.detached
                    end,
                    set = function(_, val)
                        AB.config.multiBarBottomLeft.detached = val
                        AB:UpdateAll()
                    end
                }
            }
        },
        multiBarBottomRight = {
            type = "group",
            name = "Action Bar 3",
            order = 4,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.multiBarBottomRight.enabled
                    end,
                    set = function(_, val)
                        AB.config.multiBarBottomRight.enabled = val
                        _G.SHOW_MULTI_ACTIONBAR_2 = val
                        AB:UpdateAll()
                    end
                },
                linebreak = {type = "description", name = "", order = 2},
                detached = {
                    type = "toggle",
                    name = "Detached",
                    order = 3,
                    get = function()
                        return AB.config.multiBarBottomRight.detached
                    end,
                    set = function(_, val)
                        AB.config.multiBarBottomRight.detached = val
                        AB:UpdateAll()
                    end
                },
                attachedPoint = {
                    type = "select",
                    name = "Attach To",
                    order = 4,
                    values = AB.ATTACHMENT_POINTS,
                    disabled = function() return AB.config.multiBarBottomRight.detached end,
                    get = function()
                        for key, val in pairs(AB.ATTACHMENT_POINTS) do
                            if AB.config.multiBarBottomRight.attachedPoint == val then
                                return val
                            end
                        end
                    end,
                    set = function(_, key)
                        AB.config.multiBarBottomRight.attachedPoint = AB.ATTACHMENT_POINTS[key]
                        AB:UpdateAll()
                    end
                }
            }
        },
        multiBarLeft = {
            type = "group",
            name = "Action Bar 4",
            order = 5,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.multiBarLeft.enabled
                    end,
                    set = function(_, val)
                        AB.config.multiBarLeft.enabled = val
                        _G.SHOW_MULTI_ACTIONBAR_3 = val
                        AB:UpdateAll()
                    end
                }
            }
        },
        multiBarRight = {
            type = "group",
            name = "Action Bar 5",
            order = 6,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.multiBarRight.enabled
                    end,
                    set = function(_, val)
                        AB.config.multiBarRight.enabled = val
                        _G.SHOW_MULTI_ACTIONBAR_4 = val
                        AB:UpdateAll()
                    end
                }
            }
        },
        stanceBar = {
            type = "group",
            name = "Stance Bar",
            order = 7,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.stanceBar.enabled
                    end,
                    set = function(_, val)
                        AB.config.stanceBar.enabled = val
                        AB:UpdateAll()
                    end
                }
            }
        },
        petActionBar = {
            type = "group",
            name = "Pet Action Bar",
            order = 8,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.petActionBar.enabled
                    end,
                    set = function(_, val)
                        AB.config.petActionBar.enabled = val
                        AB:UpdateAll()
                    end
                }
            }
        },
        vehicleExitBar = {
            type = "group",
            name = "Vehicle Exit Bar",
            order = 9,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.vehicleExitBar.enabled
                    end,
                    set = function(_, val)
                        AB.config.vehicleExitBar.enabled = val
                        AB:UpdateAll()
                    end
                }
            }
        },
        experienceBar = {
            type = "group",
            name = "Experience Bar",
            order = 10,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.experienceBar.enabled
                    end,
                    set = function(_, val)
                        AB.config.experienceBar.enabled = val
                        AB:UpdateAll()
                    end
                }
            }
        },
        reputationBar = {
            type = "group",
            name = "Reputation Bar",
            order = 11,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.reputationBar.enabled
                    end,
                    set = function(_, val)
                        AB.config.reputationBar.enabled = val
                        AB:UpdateAll()
                    end
                }
            }
        },
        maxLevelBar = {
            type = "group",
            name = "Max Level Bar",
            order = 12,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.maxLevelBar.enabled
                    end,
                    set = function(_, val)
                        AB.config.maxLevelBar.enabled = val
                        AB:UpdateAll()
                    end
                }
            }
        },
        microButtonAndBags = {
            type = "group",
            name = "Micro Buttons & Bags Bar",
            order = 20,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.microButtonAndBags.enabled
                    end,
                    set = function(_, val)
                        AB.config.microButtonAndBags.enabled = val
                        AB:UpdateAll()
                    end
                }
            }
        }
    }
})
