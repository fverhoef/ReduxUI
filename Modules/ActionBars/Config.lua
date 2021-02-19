local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

AB.ARTWORK_THEMES = {
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
AB.ATTACHMENT_POINTS = {Center = "Center", Right = "Right"}
AB.CLASS_BAR_DOCKS = {Left = "Left", Right = "Right"}
AB.COLUMN_DIRECTIONS = {Right = "Right", Left = "Left"}
AB.ROW_DIRECTIONS = {Up = "Up", Down = "Down"}

function AB:CreateBarButtonCountOption(name, bar, order)
    return {
        type = "range",
        name = name or "Button Count",
        desc = "The number of buttons on this bar.",
        order = order,
        min = 1,
        max = 12,
        step = 1,
        disabled = function()
            return not AB.config[bar].detached
        end,
        get = function()
            return AB.config[bar].buttons
        end,
        set = function(_, val)
            AB.config[bar].buttons = val
            AB:UpdateAll()
        end
    }
end

function AB:CreateBarButtonSizeOption(name, bar, order)
    return {
        type = "range",
        name = name or "Button Size",
        desc = "The size of the buttons on this bar.",
        order = order,
        min = 10,
        max = 50,
        step = 1,
        disabled = function()
            return not AB.config[bar].detached
        end,
        get = function()
            return AB.config[bar].buttonSize
        end,
        set = function(_, val)
            AB.config[bar].buttonSize = val
            AB:UpdateAll()
        end
    }
end

function AB:CreateBarButtonsPerRowOption(name, bar, order)
    return {
        type = "range",
        name = name or "Buttons Per Row",
        desc = "The number of buttons in each row.",
        order = order,
        min = 1,
        max = 12,
        step = 1,
        disabled = function()
            return not AB.config[bar].detached
        end,
        get = function()
            return AB.config[bar].buttonsPerRow
        end,
        set = function(_, val)
            AB.config[bar].buttonsPerRow = val
            AB:UpdateAll()
        end
    }
end

function AB:CreateBarColumnDirectionOption(name, bar, order)
    return {
        type = "select",
        name = name or "Column Growth Direction",
        desc = "The direction in which columns grow.",
        order = order,
        disabled = function()
            return not AB.config[bar].detached
        end,
        values = AB.COLUMN_DIRECTIONS,
        get = function()
            return AB.config[bar].columnDirection
        end,
        set = function(_, key)
            AB.config[bar].columnDirection = key
            AB:UpdateAll()
        end
    }
end

function AB:CreateBarColumnSpacingOption(name, bar, order)
    return {
        type = "range",
        name = name or "Column Spacing",
        desc = "The spacing between each column.",
        order = order,
        min = 0,
        max = 50,
        step = 1,
        disabled = function()
            return not AB.config[bar].detached
        end,
        get = function()
            return AB.config[bar].columnSpacing
        end,
        set = function(_, val)
            AB.config[bar].columnSpacing = val
            AB:UpdateAll()
        end
    }
end

function AB:CreateBarRowDirectionOption(name, bar, order)
    return {
        type = "select",
        name = name or "Row Growth Direction",
        desc = "The direction in which rows grow.",
        order = order,
        disabled = function()
            return not AB.config[bar].detached
        end,
        values = AB.ROW_DIRECTIONS,
        get = function()
            return AB.config[bar].rowDirection
        end,
        set = function(_, key)
            AB.config[bar].rowDirection = key
            AB:UpdateAll()
        end
    }
end

function AB:CreateBarRowSpacingOption(name, bar, order)
    return {
        type = "range",
        name = name or "Row Spacing",
        desc = "The spacing between each row.",
        order = order,
        min = 0,
        max = 50,
        step = 1,
        disabled = function()
            return not AB.config[bar].detached
        end,
        get = function()
            return AB.config[bar].rowSpacing
        end,
        set = function(_, val)
            AB.config[bar].rowSpacing = val
            AB:UpdateAll()
        end
    }
end

R:RegisterModuleConfig(AB, {
    enabled = true,
    artwork = {enabled = true, theme = AB.ARTWORK_THEMES.Default},
    mainMenuBar = {
        enabled = true,
        detached = false,
        point = {"BOTTOM", "BOTTOM", 0, 10},
        fader = R.config.faders.onShow,
        frameVisibility = "show",
        -- frameVisibility = "[combat][mod:shift][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide"
        page = {enabled = true},
        experience = {enabled = true},
        reputation = {enabled = true},
        columnDirection = AB.COLUMN_DIRECTIONS.Right,
        rowDirection = AB.ROW_DIRECTIONS.Down,
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 36,
        columnSpacing = 6,
        rowSpacing = 6
    },
    multiBarBottomLeft = {
        enabled = true,
        detached = false,
        point = {"BOTTOM", "BOTTOM", 0, 50},
        fader = R.config.faders.none,
        frameVisibility = "show",
        columnDirection = AB.COLUMN_DIRECTIONS.Right,
        rowDirection = AB.ROW_DIRECTIONS.Down,
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 36,
        columnSpacing = 6,
        rowSpacing = 6
    },
    multiBarBottomRight = {
        enabled = true,
        detached = false,
        point = {"BOTTOM", "BOTTOM", 0, 90},
        attachedPoint = AB.ATTACHMENT_POINTS.Right,
        fader = R.config.faders.none,
        frameVisibility = "show",
        columnDirection = AB.COLUMN_DIRECTIONS.Right,
        rowDirection = AB.ROW_DIRECTIONS.Down,
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 36,
        columnSpacing = 6,
        rowSpacing = 6
    },
    multiBarLeft = {
        enabled = true,
        point = {"RIGHT", "RIGHT", -38, 0},
        fader = R.config.faders.mouseOver,
        frameVisibility = "show",
        columnDirection = AB.COLUMN_DIRECTIONS.Right,
        rowDirection = AB.ROW_DIRECTIONS.Down,
        buttons = 12,
        buttonsPerRow = 1,
        buttonSize = 36,
        columnSpacing = 6,
        rowSpacing = 6
    },
    multiBarRight = {
        enabled = true,
        point = {"RIGHT", "RIGHT", 0, 0},
        fader = R.config.faders.mouseOver,
        frameVisibility = "show",
        columnDirection = AB.COLUMN_DIRECTIONS.Right,
        rowDirection = AB.ROW_DIRECTIONS.Down,
        buttons = 12,
        buttonsPerRow = 1,
        buttonSize = 36,
        columnSpacing = 6,
        rowSpacing = 6
    },
    stanceBar = {
        enabled = true,
        detached = false,
        point = {"BOTTOM", "BOTTOM", 0, 130},
        fader = R.config.faders.onShow,
        frameVisibility = "[overridebar][vehicleui][possessbar] hide; show",
        columnDirection = AB.COLUMN_DIRECTIONS.Right,
        rowDirection = AB.ROW_DIRECTIONS.Down,
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 30,
        columnSpacing = 6,
        rowSpacing = 6
    },
    petActionBar = {
        enabled = true,
        detached = false,
        point = {"BOTTOM", "BOTTOM", 0, 130},
        fader = R.config.faders.onShow,
        frameVisibility = "[overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide",
        columnDirection = AB.COLUMN_DIRECTIONS.Right,
        rowDirection = AB.ROW_DIRECTIONS.Down,
        buttons = 12,
        buttonsPerRow = 12,
        buttonSize = 30,
        columnSpacing = 6,
        rowSpacing = 6
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
        dock = AB.CLASS_BAR_DOCKS.Left,
        fader = R.config.faders.OnShow
    },
    shamanBar = {
        enabled = true,
        point = {"BOTTOM", "UIParent", "BOTTOM", 0, 50},
        buttonSize = 36,
        buttonSpacing = 6,
        dock = AB.CLASS_BAR_DOCKS.Left,
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
        artwork = {
            type = "group",
            name = "Artwork",
            order = 2,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.artwork.enabled
                    end,
                    set = function(_, val)
                        AB.config.artwork.enabled = val
                        AB:UpdateAll()
                    end
                },
                theme = {
                    type = "select",
                    name = "Theme",
                    order = 2,
                    values = AB.ARTWORK_THEMES,
                    get = function()
                        for key, val in pairs(AB.ARTWORK_THEMES) do
                            if AB.config.artwork.theme == val then
                                return val
                            end
                        end
                    end,
                    set = function(_, key)
                        AB.config.artwork.theme = AB.ARTWORK_THEMES[key]
                        AB:UpdateAll()
                    end
                }
            }
        },
        mainMenuBar = {
            type = "group",
            name = "Main Action Bar",
            order = 3,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.mainMenuBar.enabled
                    end,
                    set = function(_, val)
                        AB.config.mainMenuBar.enabled = val
                        AB:UpdateAll()
                    end
                },
                linebreak = {type = "description", name = "", order = 2},
                detached = {
                    type = "toggle",
                    name = "Detached",
                    order = 3,
                    get = function()
                        return AB.config.mainMenuBar.detached
                    end,
                    set = function(_, val)
                        AB.config.mainMenuBar.detached = val
                        AB:UpdateAll()
                    end
                },
                linebreak1 = {type = "description", name = "", order = 10},
                buttons = AB:CreateBarButtonCountOption(nil, "mainMenuBar", 11),
                buttonSize = AB:CreateBarButtonSizeOption(nil, "mainMenuBar", 12),
                buttonsPerRow = AB:CreateBarButtonsPerRowOption(nil, "mainMenuBar", 13),
                linebreak2 = {type = "description", name = "", order = 14},
                columnDirection = AB:CreateBarColumnDirectionOption(nil, "mainMenuBar", 15),
                columnSpacing = AB:CreateBarColumnSpacingOption(nil, "mainMenuBar", 16),
                linebreak3 = {type = "description", name = "", order = 17},
                rowDirection = AB:CreateBarRowDirectionOption(nil, "mainMenuBar", 18),
                rowSpacing = AB:CreateBarRowSpacingOption(nil, "mainMenuBar", 19)
            }
        },
        multiBarBottomLeft = {
            type = "group",
            name = "Action Bar 2",
            order = 4,
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
                },
                linebreak1 = {type = "description", name = "", order = 10},
                buttons = AB:CreateBarButtonCountOption(nil, "multiBarBottomLeft", 11),
                buttonSize = AB:CreateBarButtonSizeOption(nil, "multiBarBottomLeft", 12),
                buttonsPerRow = AB:CreateBarButtonsPerRowOption(nil, "multiBarBottomLeft", 13),
                linebreak2 = {type = "description", name = "", order = 14},
                columnDirection = AB:CreateBarColumnDirectionOption(nil, "multiBarBottomLeft", 15),
                columnSpacing = AB:CreateBarColumnSpacingOption(nil, "multiBarBottomLeft", 16),
                linebreak3 = {type = "description", name = "", order = 17},
                rowDirection = AB:CreateBarRowDirectionOption(nil, "multiBarBottomLeft", 18),
                rowSpacing = AB:CreateBarRowSpacingOption(nil, "multiBarBottomLeft", 19)
            }
        },
        multiBarBottomRight = {
            type = "group",
            name = "Action Bar 3",
            order = 5,
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
                    disabled = function()
                        return AB.config.multiBarBottomRight.detached
                    end,
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
                },
                linebreak1 = {type = "description", name = "", order = 10},
                buttons = AB:CreateBarButtonCountOption(nil, "multiBarBottomRight", 11),
                buttonSize = AB:CreateBarButtonSizeOption(nil, "multiBarBottomRight", 12),
                buttonsPerRow = AB:CreateBarButtonsPerRowOption(nil, "multiBarBottomRight", 13),
                linebreak2 = {type = "description", name = "", order = 14},
                columnDirection = AB:CreateBarColumnDirectionOption(nil, "multiBarBottomRight", 15),
                columnSpacing = AB:CreateBarColumnSpacingOption(nil, "multiBarBottomRight", 16),
                linebreak3 = {type = "description", name = "", order = 17},
                rowDirection = AB:CreateBarRowDirectionOption(nil, "multiBarBottomRight", 18),
                rowSpacing = AB:CreateBarRowSpacingOption(nil, "multiBarBottomRight", 19)
            }
        },
        multiBarLeft = {
            type = "group",
            name = "Action Bar 4",
            order = 6,
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
                },
                linebreak1 = {type = "description", name = "", order = 10},
                buttons = AB:CreateBarButtonCountOption(nil, "multiBarLeft", 11),
                buttonSize = AB:CreateBarButtonSizeOption(nil, "multiBarLeft", 12),
                buttonsPerRow = AB:CreateBarButtonsPerRowOption(nil, "multiBarLeft", 13),
                linebreak2 = {type = "description", name = "", order = 14},
                columnDirection = AB:CreateBarColumnDirectionOption(nil, "multiBarLeft", 15),
                columnSpacing = AB:CreateBarColumnSpacingOption(nil, "multiBarLeft", 16),
                linebreak3 = {type = "description", name = "", order = 17},
                rowDirection = AB:CreateBarRowDirectionOption(nil, "multiBarLeft", 18),
                rowSpacing = AB:CreateBarRowSpacingOption(nil, "multiBarLeft", 19)
            }
        },
        multiBarRight = {
            type = "group",
            name = "Action Bar 5",
            order = 7,
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
                },
                linebreak1 = {type = "description", name = "", order = 10},
                buttons = AB:CreateBarButtonCountOption(nil, "multiBarRight", 11),
                buttonSize = AB:CreateBarButtonSizeOption(nil, "multiBarRight", 12),
                buttonsPerRow = AB:CreateBarButtonsPerRowOption(nil, "multiBarRight", 13),
                linebreak2 = {type = "description", name = "", order = 14},
                columnDirection = AB:CreateBarColumnDirectionOption(nil, "multiBarRight", 15),
                columnSpacing = AB:CreateBarColumnSpacingOption(nil, "multiBarRight", 16),
                linebreak3 = {type = "description", name = "", order = 17},
                rowDirection = AB:CreateBarRowDirectionOption(nil, "multiBarRight", 18),
                rowSpacing = AB:CreateBarRowSpacingOption(nil, "multiBarRight", 19)
            }
        },
        stanceBar = {
            type = "group",
            name = "Stance Bar",
            order = 8,
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
                },
                linebreak = {type = "description", name = "", order = 2},
                detached = {
                    type = "toggle",
                    name = "Detached",
                    order = 3,
                    get = function()
                        return AB.config.stanceBar.detached
                    end,
                    set = function(_, val)
                        AB.config.stanceBar.detached = val
                        AB:UpdateAll()
                    end
                },
                linebreak1 = {type = "description", name = "", order = 10},
                buttons = AB:CreateBarButtonCountOption(nil, "stanceBar", 11),
                buttonSize = AB:CreateBarButtonSizeOption(nil, "stanceBar", 12),
                buttonsPerRow = AB:CreateBarButtonsPerRowOption(nil, "stanceBar", 13),
                linebreak2 = {type = "description", name = "", order = 14},
                columnDirection = AB:CreateBarColumnDirectionOption(nil, "stanceBar", 15),
                columnSpacing = AB:CreateBarColumnSpacingOption(nil, "stanceBar", 16),
                linebreak3 = {type = "description", name = "", order = 17},
                rowDirection = AB:CreateBarRowDirectionOption(nil, "stanceBar", 18),
                rowSpacing = AB:CreateBarRowSpacingOption(nil, "stanceBar", 19)
            }
        },
        petActionBar = {
            type = "group",
            name = "Pet Action Bar",
            order = 9,
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
                },
                linebreak = {type = "description", name = "", order = 2},
                detached = {
                    type = "toggle",
                    name = "Detached",
                    order = 3,
                    get = function()
                        return AB.config.petActionBar.detached
                    end,
                    set = function(_, val)
                        AB.config.petActionBar.detached = val
                        AB:UpdateAll()
                    end
                },
                linebreak1 = {type = "description", name = "", order = 10},
                buttons = AB:CreateBarButtonCountOption(nil, "petActionBar", 11),
                buttonSize = AB:CreateBarButtonSizeOption(nil, "petActionBar", 12),
                buttonsPerRow = AB:CreateBarButtonsPerRowOption(nil, "petActionBar", 13),
                linebreak2 = {type = "description", name = "", order = 14},
                columnDirection = AB:CreateBarColumnDirectionOption(nil, "petActionBar", 15),
                columnSpacing = AB:CreateBarColumnSpacingOption(nil, "petActionBar", 16),
                linebreak3 = {type = "description", name = "", order = 17},
                rowDirection = AB:CreateBarRowDirectionOption(nil, "petActionBar", 18),
                rowSpacing = AB:CreateBarRowSpacingOption(nil, "petActionBar", 19)
            }
        },
        vehicleExitBar = {
            type = "group",
            name = "Vehicle Exit Bar",
            order = 10,
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
            order = 11,
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
            order = 12,
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
            order = 13,
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
            order = 14,
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
        },
        mageBar = {
            type = "group",
            name = "Class Bars: Mage",
            order = 15,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.mageBar.enabled
                    end,
                    set = function(_, val)
                        AB.config.mageBar.enabled = val
                        AB:UpdateAll()
                    end
                }
            }
        },
        shamanBar = {
            type = "group",
            name = "Class Bars: Shaman",
            order = 15,
            inline = true,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enabled",
                    order = 1,
                    get = function()
                        return AB.config.shamanBar.enabled
                    end,
                    set = function(_, val)
                        AB.config.shamanBar.enabled = val
                        AB:UpdateAll()
                    end
                }
            }
        }
    }
})
