local addonName, ns = ...
local R = _G.ReduxUI
local L = R.L
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

R.UNIT_ANCHORS = { "TOP", "BOTTOM", "LEFT", "RIGHT" }
R.GROUP_ANCHORS = { "TOP", "BOTTOM", "LEFT", "RIGHT" }
R.GROUP_UNITS = { ["party"] = true, ["raid"] = true, ["assist"] = true, ["tank"] = true, ["arena"] = true, ["boss"] = true }

local function IsBlizzardStyled(unit)
    return function()
        return UF:UnitConfig(unit).style ~= nil and UF:UnitConfig(unit).style ~= UF.Styles.Custom
    end
end

local function IsCustomStyled(unit)
    return function()
        return UF:UnitConfig(unit).style == nil or UF:UnitConfig(unit).style == UF.Styles.Custom
    end
end

local function SafeToNumber(input)
    local number = tonumber(input)
    return number and (number < 2147483648 and number > -2147483649) and number or nil
end

local function GetSpellDisplayName(id)
    local name, icon, spellId
    if SafeToNumber(id) then
        name, _, icon, _, _, _, spellId = GetSpellInfo(id)
        local subText = GetSpellSubtext(spellId or id)
        if subText and subText ~= "" then
            name = name .. " (" .. subText .. ")"
        end

        name =  string.format("%d : %s", spellId or id, name)
    else
        name = id
        _, _, icon = GetSpellInfo(id)
    end

    return icon and string.format("|T%s:20:20:0:0:64:64:5:59:5:59:%d|t %s", icon, 40, name) or name
end

local selectedWhitelistSpells, selectedBlacklistSpells = {}, {}
local addWhitelistSpellFilter, addBlacklistSpellFilter
local whitelistSpellToAdd, blacklistSpellToAdd

function UF:UnitConfig(unit)
    return UF.config[unit] or UF.config.nameplates[unit]
end

function UF:UnitDefaults(unit)
    return UF.defaults[unit] or UF.defaults.nameplates[unit]
end

function UF:CreateStatusBarTextureOption(name, desc, option, order)
    return R:CreateStatusBarOption(name, desc, order, nil, function()
        return UF.config.statusbars[option]
    end, function(value)
        UF.config.statusbars[option] = value
    end, UF.UpdateAll)
end

function UF:CreateStatusBarColorOption(name, option, order)
    return R:CreateColorOption(name, nil, order, nil, false, UF.defaults.colors[option], function()
        return UF.config.colors[option]
    end, UF.UpdateAll)
end

function UF:CreateClassColorOption(class, name, order, hidden)
    return R:CreateColorOption(name, nil, order, hidden, false, UF.defaults.colors.class[class], function()
        return UF.config.colors.class[class]
    end, UF.UpdateAll)
end

function UF:CreateRangeOption(unit, name, desc, order, hidden, min, max, softMax, step, get, set, disabled)
    return R:CreateRangeOption(name, desc, order, hidden, min, max, softMax, step, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateToggleOption(unit, name, desc, order, width, hidden, get, set, confirm, disabled)
    return R:CreateToggleOption(name, desc, order, width, hidden, get, set, function()
        UF:UpdateUnit(unit)
    end, confirm, disabled)
end

function UF:CreateSelectOption(unit, name, desc, order, hidden, values, get, set, disabled)
    return R:CreateSelectOption(name, desc, order, hidden, values, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateInputOption(unit, name, desc, order, hidden, get, set, disabled)
    return R:CreateInputOption(name, desc, order, hidden, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreatePointOption(unit, order, get, set, disabled)
    return R:CreateSelectOption(L["Point"], L["The anchor point on this element."], order, nil, R.ANCHOR_POINTS, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateAnchorOption(unit, order, hidden, get, set, disabled)
    return R:CreateSelectOption(L["Anchor"], L["The frame to attach to."], order, hidden, R.ANCHORS, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateRelativePointOption(unit, order, get, set, disabled)
    return R:CreateSelectOption(L["Relative Point"], L["The point on the unit frame to attach to."], order, nil, R.ANCHOR_POINTS, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateOffsetXOption(unit, order, get, set, disabled)
    return R:CreateRangeOption(L["Offset (X)"], L["The horizontal offset from the anchor point."], order, nil, -500, nil, 500, 1, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateOffsetYOption(unit, order, get, set, disabled)
    return R:CreateRangeOption(L["Offset (Y)"], L["The vertical offset from the anchor point."], order, nil, -500, nil, 500, 1, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateFontFamilyOption(unit, order, get, set, disabled)
    return R:CreateFontOption(L["Font Family"], L["The font family for this text."], order, nil, get, set, function()
        UF:UpdateUnit(unit)
    end, nil, disabled)
end

function UF:CreateFontSizeOption(unit, order, get, set, disabled)
    return R:CreateRangeOption(L["Font Size"], L["The size of the text."], order, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateFontOutlineOption(unit, order, get, set, disabled)
    return R:CreateSelectOption(L["Font Outline"], L["The outline style of this text."], order, nil, R.FONT_OUTLINES, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateFontShadowOption(unit, order, get, set, disabled)
    return R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for this text."], order, nil, nil, get, set, function()
        UF:UpdateUnit(unit)
    end, nil, disabled)
end

function UF:CreateFontJustifyHOption(unit, order, get, set, disabled)
    return R:CreateSelectOption(L["Horizontal Justification"], L["The horizontal justification for this text."], order, nil, R.JUSTIFY_H, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateFontJustifyVOption(unit, order, get, set, disabled)
    return R:CreateSelectOption(L["Vertical Justification"], L["The vertical justification for this text."], order, nil, R.JUSTIFY_V, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateTagOption(unit, order, get, set, disabled)
    return R:CreateInputOption(L["Tag"], L["The tag determines what is displayed in this text string."], order, nil, get, set, function()
        UF:UpdateUnit(unit)
    end, disabled)
end

function UF:CreateUnitOptions(unit, order, name, hidden, isNameplate, disabled)
    local options = {
        type = "group",
        childGroups = "tab",
        name = name,
        order = order,
        hidden = hidden,
        disabled = disabled,
        args = {
            header = { type = "header", name = R.title .. " > Unit Frames: " .. name, order = 0 },
            enabled = R:CreateToggleOption(L["Enabled"], nil, 1, "double", isNameplate, function()
                return UF:UnitConfig(unit).enabled
            end, function(value)
                UF:UnitConfig(unit).enabled = value
            end, function()
                if UF:UnitConfig(unit).enabled then
                    UF:UpdateUnit(unit)
                else
                    ReloadUI()
                end
            end, function()
                return UF:UnitConfig(unit).enabled and L["Disabling this unit requires a UI reload. Proceed?"]
            end),
            desc = {
                order = 2,
                type = "description",
                name = string.format(L["%sNOTE:|r This unit is currently using a non-custom style preset. Some options may be disabled."], R:Hex(1, 0, 0)),
                hidden = IsCustomStyled(unit)
            },
            general = {
                type = "group",
                name = L["General"],
                order = 4,
                args = {
                    styling = UF:CreateUnitStylingOption(unit, 1),
                    size = UF:CreateUnitSizeOption(unit, 2),
                    position = UF:CreateUnitPositionOption(unit, 3),
                    highlight = UF:CreateUnitHighlightOption(unit, 4)
                }
            },
            elements = {
                type = "group",
                name = L["Elements"],
                order = 5,
                args = {
                    health = UF:CreateUnitHealthOption(unit, 1),
                    power = UF:CreateUnitPowerOption(unit, 2),
                    castbar = UF:CreateUnitCastbarOption(unit, 3, unit == "player"),
                    portrait = UF:CreateUnitPortraitOption(unit, 4),
                    trinket = UF:CreateUnitTrinketOption(unit, 5),
                    diminishingReturnsTracker = UF:CreateUnitDRTrackerOption(unit, 6)
                }
            },
            texts = {
                type = "group",
                name = L["Texts"],
                order = 6,
                args = {
                    name = UF:CreateUnitNameOption(unit, 1),
                    health = UF:CreateUnitHealthValueOption(unit, 2),
                    healthPercent = UF:CreateUnitHealthPercentOption(unit, 3),
                    power = UF:CreateUnitPowerValueOption(unit, 4),
                    powerPercent = UF:CreateUnitPowerPercentOption(unit, 5),
                    level = UF:CreateUnitLevelOption(unit, 6)
                }
            },
            indicators = {
                type = "group",
                name = L["Indicators"],
                order = 7,
                args = {
                    combatIndicator = UF:CreateUnitIndicatorOption(unit, "combatIndicator", 1, L["Combat"], unit ~= "player"),
                    restingIndicator = UF:CreateUnitIndicatorOption(unit, "restingIndicator", 2, L["Resting"], unit ~= "player"),
                    pvpIndicator = UF:CreateUnitIndicatorOption(unit, "pvpIndicator", 3, L["PvP Status"]),
                    pvpClassificationIndicator = UF:CreateUnitIndicatorOption(unit, "pvpClassificationIndicator", 4, L["PvP Classification"], not R.isRetail),
                    masterLooterIndicator = UF:CreateUnitIndicatorOption(unit, "masterLooterIndicator", 5, L["Master Looter"], R.isRetail),
                    leaderIndicator = UF:CreateUnitIndicatorOption(unit, "leaderIndicator", 6, L["Raid Leader"]),
                    assistantIndicator = UF:CreateUnitIndicatorOption(unit, "assistantIndicator", 7, L["Raid Assistant"]),
                    raidRoleIndicator = UF:CreateUnitIndicatorOption(unit, "raidRoleIndicator", 8, L["Raid Role"]),
                    groupRoleIndicator = UF:CreateUnitIndicatorOption(unit, "groupRoleIndicator", 9, L["Group Role"], not R.isRetail),
                    raidTargetIndicator = UF:CreateUnitIndicatorOption(unit, "raidTargetIndicator", 10, L["Target Icon"]),
                    readyCheckIndicator = UF:CreateUnitIndicatorOption(unit, "readyCheckIndicator", 11, L["Ready Check"]),
                    phaseIndicator = UF:CreateUnitIndicatorOption(unit, "phaseIndicator", 12, L["Phase"]),
                    resurrectIndicator = UF:CreateUnitIndicatorOption(unit, "resurrectIndicator", 13, L["Resurrect"]),
                    summonIndicator = UF:CreateUnitIndicatorOption(unit, "summonIndicator", 14, L["Summon"], not R.isRetail),
                    questIndicator = UF:CreateUnitIndicatorOption(unit, "questIndicator", 15, L["Quest"], not R.isRetail)
                }
            },
            auras = {
                type = "group",
                name = L["Auras"],
                order = 8,
                args = {
                    enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                        return UF:UnitConfig(unit).auras.enabled
                    end, function(value)
                        UF:UnitConfig(unit).auras.enabled = value
                    end),
                    lineBreak0 = { type = "header", name = "", order = 2 },
                    separateBuffsAndDebuffs = UF:CreateToggleOption(unit, L["Separate Buffs & Debuffs"], L["Whether to show buffs & debuffs separately, or grouped together."], 3, nil, nil, function()
                        return UF:UnitConfig(unit).auras.separateBuffsAndDebuffs
                    end, function(value)
                        UF:UnitConfig(unit).auras.separateBuffsAndDebuffs = value
                    end, nil, function()
                        return not UF:UnitConfig(unit).auras.enabled
                    end),
                    buffsAndDebuffs = UF:CreateUnitAurasOption(unit, 4, L["Buffs & Debuffs"], "buffsAndDebuffs", function()
                        return UF:UnitConfig(unit).auras.separateBuffsAndDebuffs
                    end),
                    buffs = UF:CreateUnitAurasOption(unit, 5, L["Buffs"], "buffs", function()
                        return not UF:UnitConfig(unit).auras.separateBuffsAndDebuffs
                    end),
                    buffFilter = UF:CreateUnitAuraFilterOption(unit, 6, L["Buff Filter"], "buffs", true),
                    debuffs = UF:CreateUnitAurasOption(unit, 7, L["Debuffs"], "debuffs", function()
                        return not UF:UnitConfig(unit).auras.separateBuffsAndDebuffs
                    end),
                    debuffFilter = UF:CreateUnitAuraFilterOption(unit, 8, L["Debuff Filter"], "debuffs", false)
                }
            }
        }
    }

    if unit == "player" and R.PlayerInfo.class == "SHAMAN" then
        options.args.elements.args.totemTimers = UF:CreateUnitTotemsOption(unit, 7)
    elseif unit == "player" and R.PlayerInfo.class == "DEATHKNIGHT" then
        options.args.elements.args.runes = UF:CreateUnitRunesOption(unit, 7)
    end

    if R.GROUP_UNITS[unit] then
        options.args.forceShow = {
            order = 2,
            type = "execute",
            name = function()
                return UF.headers[unit].isForced and L["Hide Frames"] or L["Show Frames"]
            end,
            desc = string.format(L["Forcibly show/hide the %s frames."], unit),
            func = function()
                if not UF.headers[unit].isForced then
                    UF.headers[unit]:ForceShow()
                else
                    UF.headers[unit]:UnforceShow()
                end
            end
        }

        options.args.general.args.layout = {
            type = "group",
            name = L["Layout"],
            order = 3,
            inline = true,
            args = {
                desc = { type = "description", name = L["These options control how each unit is positioned within the group."], order = 0 },
                unitAnchorPoint = R:CreateSelectOption(L["Unit Anchor Point"], L["The point on each unit to attach to."], 1, nil, R.UNIT_ANCHORS, function()
                    return UF:UnitConfig(unit).unitAnchorPoint
                end, function(value)
                    UF:UnitConfig(unit).unitAnchorPoint = value
                end, function()
                    UF:UpdateUnit(unit)
                end),
                unitSpacing = UF:CreateRangeOption(unit, L["Unit Spacing"], L["The spacing between each unit."], 2, nil, 0, nil, 50, 1, function()
                    return UF:UnitConfig(unit).unitSpacing
                end, function(value)
                    UF:UnitConfig(unit).unitSpacing = value
                end),
                lineBreak1 = { type = "description", name = "", order = 3, hidden = unit ~= "raid" },
                groupAnchorPoint = R:CreateSelectOption(L["Group Anchor Point"], L["The point on each group to attach to."], 4, unit ~= "raid", R.GROUP_ANCHORS, function()
                    return UF:UnitConfig(unit).groupAnchorPoint
                end, function(value)
                    UF:UnitConfig(unit).groupAnchorPoint = value
                end, function()
                    UF:UpdateUnit(unit)
                end),
                groupSpacing = UF:CreateRangeOption(unit, L["Group Spacing"], L["The spacing between each group."], 5, unit ~= "raid", 0, nil, 50, 1, function()
                    return UF:UnitConfig(unit).groupSpacing
                end, function(value)
                    UF:UnitConfig(unit).groupSpacing = value
                end),
                lineBreak2 = { type = "description", name = "", order = 10, hidden = unit ~= "party" },
                showPlayer = UF:CreateToggleOption(unit, L["Show Player"], nil, 11, nil, unit ~= "party", function()
                    return UF:UnitConfig(unit).showPlayer
                end, function(value)
                    UF:UnitConfig(unit).showPlayer = value
                end),
                showRaid = UF:CreateToggleOption(unit, L["Show in Raid"], nil, 12, nil, unit ~= "party", function()
                    return UF:UnitConfig(unit).showRaid
                end, function(value)
                    UF:UnitConfig(unit).showRaid = value
                end),
                showSolo = UF:CreateToggleOption(unit, L["Show when Solo"], nil, 13, nil, unit ~= "party", function()
                    return UF:UnitConfig(unit).showSolo
                end, function(value)
                    UF:UnitConfig(unit).showSolo = value
                end)
            }
        }
    end

    return options
end

function UF:CreateUnitPositionOption(unit, order)
    return {
        type = "group",
        name = L["Position"],
        order = order,
        inline = true,
        args = {
            desc = {
                type = "description",
                name = L["Frame and header positions can be adjusted either here or by unlocking all frames in the addon's general options and dragging them by hand."],
                order = 1
            },
            point = UF:CreatePointOption(unit, 2, function()
                return UF:UnitConfig(unit).point[1]
            end, function(value)
                UF:UnitConfig(unit).point[1] = value
            end),
            anchor = UF:CreateAnchorOption(unit, 3, nil, function()
                return UF:UnitConfig(unit).point[2]
            end, function(value)
                UF:UnitConfig(unit).point[2] = value
            end),
            relativePoint = UF:CreateRelativePointOption(unit, 4, function()
                return UF:UnitConfig(unit).point[3]
            end, function(value)
                UF:UnitConfig(unit).point[3] = value
            end),
            offsetX = UF:CreateOffsetXOption(unit, 5, function()
                return UF:UnitConfig(unit).point[4]
            end, function(value)
                UF:UnitConfig(unit).point[4] = value
            end),
            offsetY = UF:CreateOffsetYOption(unit, 6, function()
                return UF:UnitConfig(unit).point[5]
            end, function(value)
                UF:UnitConfig(unit).point[5] = value
            end)
        }
    }
end

function UF:CreateUnitSizeOption(unit, order)
    return {
        type = "group",
        name = L["Size"],
        order = order,
        inline = true,
        disabled = IsBlizzardStyled(unit),
        args = {
            width = UF:CreateRangeOption(unit, L["Width"], L["The width of the unit frame."], 1, nil, 10, nil, 400, 1, function()
                return UF:UnitConfig(unit).size[1]
            end, function(value)
                UF:UnitConfig(unit).size[1] = value
            end),
            height = UF:CreateRangeOption(unit, L["Height"], L["The height of the unit frame."], 2, nil, 10, nil, 400, 1, function()
                return UF:UnitConfig(unit).size[2]
            end, function(value)
                UF:UnitConfig(unit).size[2] = value
            end),
            scale = UF:CreateRangeOption(unit, L["Scale"], L["The scale of the unit frame."], 3, nil, 0.1, nil, 3, 0.1, function()
                return UF:UnitConfig(unit).scale
            end, function(value)
                UF:UnitConfig(unit).scale = value
            end)
        }
    }
end

function UF:CreateUnitHealthOption(unit, order)
    return {
        type = "group",
        name = L["Health Bar"],
        order = order,
        args = {
            desc = {
                order = 1,
                type = "description",
                name = string.format(L["%sNOTE:|r The size of the health bar for a unit always matches the frame size; to resize it, adjust the size of the frame."], R:Hex(1, 0, 0))
            }
        }
    }
end

function UF:CreateUnitHealthValueOption(unit, order)
    return {
        type = "group",
        name = L["Health"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).health.value.enabled
            end, function(value)
                UF:UnitConfig(unit).health.value.enabled = value
            end),
            position = {
                type = "group",
                name = L["Position"],
                order = 2,
                disabled = IsBlizzardStyled(unit),
                inline = true,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).health.value.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).health.value.point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).health.value.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).health.value.point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit).health.value.point[3]
                    end, function(value)
                        UF:UnitConfig(unit).health.value.point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit).health.value.point[4]
                    end, function(value)
                        UF:UnitConfig(unit).health.value.point[4] = value
                    end)
                }
            },
            font = {
                type = "group",
                name = L["Font"],
                order = 3,
                inline = true,
                args = {
                    font = UF:CreateFontFamilyOption(unit, 1, function()
                        return UF:UnitConfig(unit).health.value.font
                    end, function(value)
                        UF:UnitConfig(unit).health.value.font = value
                    end),
                    fontSize = UF:CreateFontSizeOption(unit, 2, function()
                        return UF:UnitConfig(unit).health.value.fontSize
                    end, function(value)
                        UF:UnitConfig(unit).health.value.fontSize = value
                    end),
                    fontOutline = UF:CreateFontOutlineOption(unit, 3, function()
                        return UF:UnitConfig(unit).health.value.fontOutline
                    end, function(value)
                        UF:UnitConfig(unit).health.value.fontOutline = value
                    end),
                    fontShadow = UF:CreateFontShadowOption(unit, 4, function()
                        return UF:UnitConfig(unit).health.value.fontShadow
                    end, function(value)
                        UF:UnitConfig(unit).health.value.fontShadow = value
                    end)
                }
            },
            lineBreakTag = { type = "header", name = "Tag", order = 5 },
            tag = UF:CreateTagOption(unit, 6, function()
                return UF:UnitConfig(unit).health.value.tag
            end, function(value)
                UF:UnitConfig(unit).health.value.tag = value
            end),
            lineBreakFade = { type = "header", name = "Fading", order = 7 },
            fade = UF:CreateToggleOption(unit, L["Mouseover Fade"], L["Whether to only show this text when the mouse is over this unit frame"], 8, nil, nil, function()
                return UF:UnitConfig(unit).health.value.fader == R.config.faders.mouseOver
            end, function(value)
                UF:UnitConfig(unit).health.value.fader = value and R.config.faders.mouseOver or R.config.faders.onShow
            end)
        }
    }
end

function UF:CreateUnitHealthPercentOption(unit, order)
    return {
        type = "group",
        name = L["Health (Percentage)"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).health.percent.enabled
            end, function(value)
                UF:UnitConfig(unit).health.percent.enabled = value
            end),
            position = {
                type = "group",
                name = L["Position"],
                order = 2,
                disabled = IsBlizzardStyled(unit),
                inline = true,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).health.percent.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).health.percent.point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).health.percent.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).health.percent.point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit).health.percent.point[3]
                    end, function(value)
                        UF:UnitConfig(unit).health.percent.point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit).health.percent.point[4]
                    end, function(value)
                        UF:UnitConfig(unit).health.percent.point[4] = value
                    end)
                }
            },
            font = {
                type = "group",
                name = L["Font"],
                order = 3,
                inline = true,
                args = {
                    font = UF:CreateFontFamilyOption(unit, 1, function()
                        return UF:UnitConfig(unit).health.percent.font
                    end, function(value)
                        UF:UnitConfig(unit).health.percent.font = value
                    end),
                    fontSize = UF:CreateFontSizeOption(unit, 2, function()
                        return UF:UnitConfig(unit).health.percent.fontSize
                    end, function(value)
                        UF:UnitConfig(unit).health.percent.fontSize = value
                    end),
                    fontOutline = UF:CreateFontOutlineOption(unit, 3, function()
                        return UF:UnitConfig(unit).health.percent.fontOutline
                    end, function(value)
                        UF:UnitConfig(unit).health.percent.fontOutline = value
                    end),
                    fontShadow = UF:CreateFontShadowOption(unit, 4, function()
                        return UF:UnitConfig(unit).health.percent.fontShadow
                    end, function(value)
                        UF:UnitConfig(unit).health.percent.fontShadow = value
                    end)
                }
            },
            lineBreakTag = { type = "header", name = "Tag", order = 5 },
            tag = UF:CreateTagOption(unit, 6, function()
                return UF:UnitConfig(unit).health.percent.tag
            end, function(value)
                UF:UnitConfig(unit).health.percent.tag = value
            end),
            lineBreakFade = { type = "header", name = "Fading", order = 7 },
            fade = UF:CreateToggleOption(unit, L["Mouseover Fade"], L["Whether to only show this text when the mouse is over this unit frame"], 8, nil, nil, function()
                return UF:UnitConfig(unit).health.percent.fader == R.config.faders.mouseOver
            end, function(value)
                UF:UnitConfig(unit).health.percent.fader = value and R.config.faders.mouseOver or R.config.faders.onShow
            end)
        }
    }
end

function UF:CreateUnitPowerOption(unit, order)
    return {
        type = "group",
        name = L["Power Bar"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).power.enabled
            end, function(value)
                UF:UnitConfig(unit).power.enabled = value
            end, nil, IsBlizzardStyled(unit)),
            lineBreakLayout = { type = "description", name = "", order = 2 },
            layout = {
                type = "group",
                name = L["Layout"],
                order = 3,
                inline = true,
                disabled = IsBlizzardStyled(unit),
                args = {
                    width = UF:CreateRangeOption(unit, L["Width"], L["The width of the power bar."], 1, nil, 0, nil, 500, 1, function()
                        return UF:UnitConfig(unit).power.size[1]
                    end, function(value)
                        UF:UnitConfig(unit).power.size[1] = value
                    end),
                    height = UF:CreateRangeOption(unit, L["Height"], L["The height of the power bar."], 2, nil, 0, nil, 100, 1, function()
                        return UF:UnitConfig(unit).power.size[2]
                    end, function(value)
                        UF:UnitConfig(unit).power.size[2] = value
                    end),
                    lineBreakSize = { type = "description", name = "", order = 3 },
                    showSeparator = UF:CreateToggleOption(unit, L["Show Separator"], L["Whether the power bar has a separator between it and the health bar."], 4, nil, nil, function()
                        return UF:UnitConfig(unit).power.showSeparator
                    end, function(value)
                        UF:UnitConfig(unit).power.showSeparator = value
                    end),
                    detached = UF:CreateToggleOption(unit, L["Detached"], L["Whether the power bar is detached from the health bar."], 5, nil, unit ~= "player", function()
                        return UF:UnitConfig(unit).power.detached
                    end, function(value)
                        UF:UnitConfig(unit).power.inset = false;
                        UF:UnitConfig(unit).power.detached = value
                    end),
                    inset = UF:CreateToggleOption(unit, L["Inset"], L["Whether the power bar is displayed as an inset."], 6, nil, nil, function()
                        return UF:UnitConfig(unit).power.inset
                    end, function(value)
                        UF:UnitConfig(unit).power.detached = false;
                        UF:UnitConfig(unit).power.inset = value
                    end),
                    detachedPoint = {
                        type = "group",
                        name = L["Detached Point"],
                        order = 7,
                        inline = true,
                        hidden = function()
                            return unit ~= "player" or not UF:UnitConfig(unit).power.detached
                        end,
                        args = {
                            desc = {
                                type = "description",
                                name = L["Detached power bar position can be adjusted either here or by unlocking all frames in the addon's general options and dragging them by hand."],
                                order = 1
                            },
                            point = UF:CreatePointOption(unit, 2, function()
                                return UF:UnitConfig(unit).power.point[1]
                            end, function(value)
                                UF:UnitConfig(unit).power.point[1] = value
                            end),
                            anchor = UF:CreateAnchorOption(unit, 3, nil, function()
                                return UF:UnitConfig(unit).power.point[2]
                            end, function(value)
                                UF:UnitConfig(unit).power.point[2] = value
                            end),
                            relativePoint = UF:CreateRelativePointOption(unit, 4, function()
                                return UF:UnitConfig(unit).power.point[3]
                            end, function(value)
                                UF:UnitConfig(unit).power.point[3] = value
                            end),
                            offsetX = UF:CreateOffsetXOption(unit, 5, function()
                                return UF:UnitConfig(unit).power.point[4]
                            end, function(value)
                                UF:UnitConfig(unit).power.point[4] = value
                            end),
                            offsetY = UF:CreateOffsetYOption(unit, 6, function()
                                return UF:UnitConfig(unit).power.point[5]
                            end, function(value)
                                UF:UnitConfig(unit).power.point[5] = value
                            end)
                        }
                    },
                    insetPoint = {
                        type = "group",
                        name = L["Inset Point"],
                        order = 8,
                        inline = true,
                        hidden = function()
                            return not UF:UnitConfig(unit).power.inset
                        end,
                        args = {
                            point = UF:CreatePointOption(unit, 3, function()
                                return UF:UnitConfig(unit).power.insetPoint[1]
                            end, function(value)
                                UF:UnitConfig(unit).power.insetPoint[1] = value
                            end),
                            relativePoint = UF:CreateRelativePointOption(unit, 4, function()
                                return UF:UnitConfig(unit).power.insetPoint[2]
                            end, function(value)
                                UF:UnitConfig(unit).power.insetPoint[2] = value
                            end),
                            offsetX = UF:CreateOffsetXOption(unit, 5, function()
                                return UF:UnitConfig(unit).power.insetPoint[3]
                            end, function(value)
                                UF:UnitConfig(unit).power.insetPoint[3] = value
                            end),
                            offsetY = UF:CreateOffsetYOption(unit, 6, function()
                                return UF:UnitConfig(unit).power.insetPoint[4]
                            end, function(value)
                                UF:UnitConfig(unit).power.insetPoint[4] = value
                            end)
                        }
                    }
                }
            },
            lineBreak2 = { type = "description", name = "", order = 7 },
            powerPrediction = UF:CreateToggleOption(unit, L["Power Prediction"], L["Whether power prediction is enabled for the player's power bar."], 8, nil, unit ~= "player", function()
                return UF:UnitConfig(unit).power.powerPrediction
            end, function(value)
                UF:UnitConfig(unit).power.powerPrediction = value
            end)
        }
    }
end

function UF:CreateUnitPowerValueOption(unit, order)
    return {
        type = "group",
        name = L["Power"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).power.value.enabled
            end, function(value)
                UF:UnitConfig(unit).power.value.enabled = value
            end),
            position = {
                type = "group",
                name = L["Position"],
                order = 2,
                disabled = IsBlizzardStyled(unit),
                inline = true,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).power.value.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).power.value.point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).power.value.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).power.value.point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit).power.value.point[3]
                    end, function(value)
                        UF:UnitConfig(unit).power.value.point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit).power.value.point[4]
                    end, function(value)
                        UF:UnitConfig(unit).power.value.point[4] = value
                    end)
                }
            },
            font = {
                type = "group",
                name = L["Font"],
                order = 3,
                inline = true,
                args = {
                    font = UF:CreateFontFamilyOption(unit, 1, function()
                        return UF:UnitConfig(unit).power.value.font
                    end, function(value)
                        UF:UnitConfig(unit).power.value.font = value
                    end),
                    fontSize = UF:CreateFontSizeOption(unit, 2, function()
                        return UF:UnitConfig(unit).power.value.fontSize
                    end, function(value)
                        UF:UnitConfig(unit).power.value.fontSize = value
                    end),
                    fontOutline = UF:CreateFontOutlineOption(unit, 3, function()
                        return UF:UnitConfig(unit).power.value.fontOutline
                    end, function(value)
                        UF:UnitConfig(unit).power.value.fontOutline = value
                    end),
                    fontShadow = UF:CreateFontShadowOption(unit, 4, function()
                        return UF:UnitConfig(unit).power.value.fontShadow
                    end, function(value)
                        UF:UnitConfig(unit).power.value.fontShadow = value
                    end)
                }
            },
            lineBreakTag = { type = "header", name = "Tag", order = 4 },
            tag = UF:CreateTagOption(unit, 5, function()
                return UF:UnitConfig(unit).power.value.tag
            end, function(value)
                UF:UnitConfig(unit).power.value.tag = value
            end),
            lineBreakFade = { type = "header", name = "Fading", order = 7 },
            fade = UF:CreateToggleOption(unit, L["Mouseover Fade"], L["Whether to only show this text when the mouse is over this unit frame"], 8, nil, nil, function()
                return UF:UnitConfig(unit).power.value.fader == R.config.faders.mouseOver
            end, function(value)
                UF:UnitConfig(unit).power.value.fader = value and R.config.faders.mouseOver or R.config.faders.onShow
            end)
        }
    }
end

function UF:CreateUnitPowerPercentOption(unit, order)
    return {
        type = "group",
        name = L["Power (Percentage)"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).power.percent.enabled
            end, function(value)
                UF:UnitConfig(unit).power.percent.enabled = value
            end),
            position = {
                type = "group",
                name = L["Position"],
                order = 2,
                disabled = IsBlizzardStyled(unit),
                inline = true,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).power.percent.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).power.percent.point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).power.percent.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).power.percent.point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit).power.percent.point[3]
                    end, function(value)
                        UF:UnitConfig(unit).power.percent.point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit).power.percent.point[4]
                    end, function(value)
                        UF:UnitConfig(unit).power.percent.point[4] = value
                    end)
                }
            },
            font = {
                type = "group",
                name = L["Font"],
                order = 3,
                inline = true,
                args = {
                    font = UF:CreateFontFamilyOption(unit, 1, function()
                        return UF:UnitConfig(unit).power.percent.font
                    end, function(value)
                        UF:UnitConfig(unit).power.percent.font = value
                    end),
                    fontSize = UF:CreateFontSizeOption(unit, 2, function()
                        return UF:UnitConfig(unit).power.percent.fontSize
                    end, function(value)
                        UF:UnitConfig(unit).power.percent.fontSize = value
                    end),
                    fontOutline = UF:CreateFontOutlineOption(unit, 3, function()
                        return UF:UnitConfig(unit).power.percent.fontOutline
                    end, function(value)
                        UF:UnitConfig(unit).power.percent.fontOutline = value
                    end),
                    fontShadow = UF:CreateFontShadowOption(unit, 4, function()
                        return UF:UnitConfig(unit).power.percent.fontShadow
                    end, function(value)
                        UF:UnitConfig(unit).power.percent.fontShadow = value
                    end)
                }
            },
            lineBreakTag = { type = "header", name = "Tag", order = 5 },
            tag = UF:CreateTagOption(unit, 6, function()
                return UF:UnitConfig(unit).power.percent.tag
            end, function(value)
                UF:UnitConfig(unit).power.percent.tag = value
            end),
            lineBreakFade = { type = "header", name = "Fading", order = 7 },
            fade = UF:CreateToggleOption(unit, L["Mouseover Fade"], L["Whether to only show this text when the mouse is over this unit frame"], 8, nil, nil, function()
                return UF:UnitConfig(unit).power.percent.fader == R.config.faders.mouseOver
            end, function(value)
                UF:UnitConfig(unit).power.percent.fader = value and R.config.faders.mouseOver or R.config.faders.onShow
            end)
        }
    }
end

function UF:CreateUnitNameOption(unit, order)
    return {
        type = "group",
        name = L["Name"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).name.enabled
            end, function(value)
                UF:UnitConfig(unit).name.enabled = value
            end, nil, IsBlizzardStyled(unit)),
            size = {
                type = "group",
                name = L["Size"],
                order = 2,
                disabled = IsBlizzardStyled(unit),
                inline = true,
                args = {
                    width = UF:CreateRangeOption(unit, L["Width"], L["The width of the name text."], 1, nil, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit).name.size[1]
                    end, function(value)
                        UF:UnitConfig(unit).name.size[1] = value
                    end),
                    height = UF:CreateRangeOption(unit, L["Height"], L["The height of the name text."], 2, nil, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit).name.size[2]
                    end, function(value)
                        UF:UnitConfig(unit).name.size[2] = value
                    end)
                }
            },
            position = {
                type = "group",
                name = L["Position"],
                order = 3,
                disabled = IsBlizzardStyled(unit),
                inline = true,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).name.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).name.point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).name.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).name.point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit).name.point[3]
                    end, function(value)
                        UF:UnitConfig(unit).name.point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit).name.point[4]
                    end, function(value)
                        UF:UnitConfig(unit).name.point[4] = value
                    end)
                }
            },
            font = {
                type = "group",
                name = L["Font"],
                order = 4,
                inline = true,
                args = {
                    font = UF:CreateFontFamilyOption(unit, 1, function()
                        return UF:UnitConfig(unit).name.font
                    end, function(value)
                        UF:UnitConfig(unit).name.font = value
                    end),
                    fontSize = UF:CreateFontSizeOption(unit, 2, function()
                        return UF:UnitConfig(unit).name.fontSize
                    end, function(value)
                        UF:UnitConfig(unit).name.fontSize = value
                    end, IsBlizzardStyled(unit)),
                    fontOutline = UF:CreateFontOutlineOption(unit, 3, function()
                        return UF:UnitConfig(unit).name.fontOutline
                    end, function(value)
                        UF:UnitConfig(unit).name.fontOutline = value
                    end, IsBlizzardStyled(unit)),
                    fontShadow = UF:CreateFontShadowOption(unit, 4, function()
                        return UF:UnitConfig(unit).name.fontShadow
                    end, function(value)
                        UF:UnitConfig(unit).name.fontShadow = value
                    end, IsBlizzardStyled(unit)),
                    justifyH = UF:CreateFontJustifyHOption(unit, 5, function()
                        return UF:UnitConfig(unit).name.justifyH
                    end, function(value)
                        UF:UnitConfig(unit).name.justifyH = value
                    end, IsBlizzardStyled(unit))
                }
            },
            lineBreakTag = { type = "header", name = "Tag", order = 5 },
            tag = UF:CreateTagOption(unit, 6, function()
                return UF:UnitConfig(unit).name.tag
            end, function(value)
                UF:UnitConfig(unit).name.tag = value
            end, IsBlizzardStyled(unit))
        }
    }
end

function UF:CreateUnitLevelOption(unit, order)
    return {
        type = "group",
        name = L["Level"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).level.enabled
            end, function(value)
                UF:UnitConfig(unit).level.enabled = value
            end, nil, IsBlizzardStyled(unit)),
            size = {
                type = "group",
                name = L["Size"],
                order = 2,
                disabled = IsBlizzardStyled(unit),
                inline = true,
                args = {
                    width = UF:CreateRangeOption(unit, L["Width"], L["The width of the name text."], 1, nil, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit).level.size[1]
                    end, function(value)
                        UF:UnitConfig(unit).level.size[1] = value
                    end, IsBlizzardStyled(unit)),
                    height = UF:CreateRangeOption(unit, L["Height"], L["The height of the name text."], 2, nil, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit).level.size[2]
                    end, function(value)
                        UF:UnitConfig(unit).level.size[2] = value
                    end, IsBlizzardStyled(unit))
                }
            },
            position = {
                type = "group",
                name = L["Position"],
                order = 3,
                disabled = IsBlizzardStyled(unit),
                inline = true,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).level.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).level.point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).level.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).level.point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit).level.point[3]
                    end, function(value)
                        UF:UnitConfig(unit).level.point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit).level.point[4]
                    end, function(value)
                        UF:UnitConfig(unit).level.point[4] = value
                    end)
                }
            },
            font = {
                type = "group",
                name = L["Font"],
                order = 4,
                inline = true,
                args = {
                    font = UF:CreateFontFamilyOption(unit, 1, function()
                        return UF:UnitConfig(unit).level.font
                    end, function(value)
                        UF:UnitConfig(unit).level.font = value
                    end),
                    fontSize = UF:CreateFontSizeOption(unit, 2, function()
                        return UF:UnitConfig(unit).level.fontSize
                    end, function(value)
                        UF:UnitConfig(unit).level.fontSize = value
                    end, IsBlizzardStyled(unit)),
                    fontOutline = UF:CreateFontOutlineOption(unit, 3, function()
                        return UF:UnitConfig(unit).level.fontOutline
                    end, function(value)
                        UF:UnitConfig(unit).level.fontOutline = value
                    end, IsBlizzardStyled(unit)),
                    fontShadow = UF:CreateFontShadowOption(unit, 4, function()
                        return UF:UnitConfig(unit).level.fontShadow
                    end, function(value)
                        UF:UnitConfig(unit).level.fontShadow = value
                    end, IsBlizzardStyled(unit)),
                    justifyH = UF:CreateFontJustifyHOption(unit, 5, function()
                        return UF:UnitConfig(unit).level.justifyH
                    end, function(value)
                        UF:UnitConfig(unit).level.justifyH = value
                    end, IsBlizzardStyled(unit))
                }
            },
            lineBreakTag = { type = "header", name = "Tag", order = 5 },
            tag = UF:CreateTagOption(unit, 6, function()
                return UF:UnitConfig(unit).level.tag
            end, function(value)
                UF:UnitConfig(unit).level.tag = value
            end, IsBlizzardStyled(unit))
        }
    }
end

function UF:CreateUnitPortraitOption(unit, order)
    return {
        type = "group",
        name = L["Portrait"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).portrait.enabled
            end, function(value)
                UF:UnitConfig(unit).portrait.enabled = value
            end, nil, IsBlizzardStyled(unit)),
            lineBreakOptions = { type = "description", name = "", order = 2 },
            class = UF:CreateToggleOption(unit, L["Use Class Icons"], L["Whether to use class icons for the portrait texture."], 4, nil, nil, function()
                return UF:UnitConfig(unit).portrait.class
            end, function(value)
                UF:UnitConfig(unit).portrait.model = false
                UF:UnitConfig(unit).portrait.class = value
            end),
            model = UF:CreateToggleOption(unit, L["Use 3D Portrait"], L["Whether to use class 3D portraits."], 5, nil, nil, function()
                return UF:UnitConfig(unit).portrait.model
            end, function(value)
                UF:UnitConfig(unit).portrait.class = false
                UF:UnitConfig(unit).portrait.model = value
            end, nil, IsBlizzardStyled(unit)),
            lineBreakDetached = { type = "description", name = "", order = 6 },
            detached = UF:CreateToggleOption(unit, L["Detached"], L["Whether the portrait is detached from the health bar."], 7, nil, nil, function()
                return UF:UnitConfig(unit).portrait.detached
            end, function(value)
                UF:UnitConfig(unit).portrait.detached = value
            end, nil, IsBlizzardStyled(unit)),
            showSeparator = UF:CreateToggleOption(unit, L["Show Separator"], L["Whether the portrait has a separator between it and the health bar."], 8, nil, nil, function()
                return UF:UnitConfig(unit).portrait.showSeparator
            end, function(value)
                UF:UnitConfig(unit).portrait.showSeparator = value
            end, nil, IsBlizzardStyled(unit)),
            lineBreakSize = { type = "description", name = L["Size"], order = 10 },
            width = UF:CreateRangeOption(unit, L["Width"], L["The width of the portrait."], 11, nil, 0, nil, 500, 1, function()
                return UF:UnitConfig(unit).portrait.size[1]
            end, function(value)
                UF:UnitConfig(unit).portrait.size[1] = value
            end, IsBlizzardStyled(unit)),
            height = UF:CreateRangeOption(unit, L["Height"], L["The height of the portrait."], 12, nil, 0, nil, 100, 1, function()
                return UF:UnitConfig(unit).portrait.size[2]
            end, function(value)
                UF:UnitConfig(unit).portrait.size[2] = value
            end, IsBlizzardStyled(unit)),
            detachedPosition = {
                type = "group",
                name = L["Position"],
                inline = true,
                order = 13,
                hidden = function()
                    return not UF:UnitConfig(unit).portrait.detached
                end,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).portrait.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).portrait.point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).portrait.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).portrait.point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit).portrait.point[3]
                    end, function(value)
                        UF:UnitConfig(unit).portrait.point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit).portrait.point[4]
                    end, function(value)
                        UF:UnitConfig(unit).portrait.point[4] = value
                    end)
                }
            }
        }
    }
end

function UF:CreateUnitTrinketOption(unit, order)
    return {
        type = "group",
        name = L["PvP Trinket"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).trinket.enabled
            end, function(value)
                UF:UnitConfig(unit).trinket.enabled = value
            end),
            announce = {
                type = "group",
                name = L["Announcements"],
                order = 2,
                inline = true,
                disabled = function()
                    return not UF:UnitConfig(unit).trinket.enabled
                end,
                args = {
                    trinketUseAnnounce = UF:CreateToggleOption(unit, L["Announce Trinket Use"], L["Whether to send an announcement when this unit uses their PvP trinket."], 3, nil, nil, function()
                        return UF:UnitConfig(unit).trinket.trinketUseAnnounce
                    end, function(value)
                        UF:UnitConfig(unit).trinket.trinketUseAnnounce = value
                    end),
                    trinketUpAnnounce = UF:CreateToggleOption(unit, L["Announce Trinket Ready"], L["Whether to send an announcement when this unit's PvP trinket comes off cooldown."], 4, nil, nil,
                                                              function()
                        return UF:UnitConfig(unit).trinket.trinketUpAnnounce
                    end, function(value)
                        UF:UnitConfig(unit).trinket.trinketUpAnnounce = value
                    end),
                    announceChannel = UF:CreateSelectOption(unit, L["Announce Channel"], L["The channel to make announcements in."], 5, nil, R.ANNOUNCE_CHANNELS, function()
                        return UF:UnitConfig(unit).trinket.announceChannel
                    end, function(value)
                        UF:UnitConfig(unit).trinket.announceChannel = value
                    end)
                }
            },
            size = {
                type = "group",
                name = L["Size"],
                order = 3,
                inline = true,
                disabled = function()
                    return not UF:UnitConfig(unit).trinket.enabled
                end,
                args = {
                    width = UF:CreateRangeOption(unit, L["Width"], L["The width of the trinket icon."], 1, function()
                        return not UF:UnitConfig(unit).trinket.size[1]
                    end, 10, 60, nil, 1, function()
                        return UF:UnitConfig(unit).trinket.size[1]
                    end, function(value)
                        UF:UnitConfig(unit).trinket.size[1] = value
                    end),
                    width = UF:CreateRangeOption(unit, L["Height"], L["The height of the trinket icon."], 2, function()
                        return not UF:UnitConfig(unit).trinket.size[2]
                    end, 10, 60, nil, 1, function()
                        return UF:UnitConfig(unit).trinket.size[2]
                    end, function(value)
                        UF:UnitConfig(unit).trinket.size[2] = value
                    end)
                }
            },
            position = {
                type = "group",
                name = L["Position"],
                order = 4,
                inline = true,
                disabled = function()
                    return not UF:UnitConfig(unit).trinket.enabled
                end,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).trinket.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).trinket.point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).trinket.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).trinket.point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit).trinket.point[3]
                    end, function(value)
                        UF:UnitConfig(unit).trinket.point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit).trinket.point[4]
                    end, function(value)
                        UF:UnitConfig(unit).trinket.point[4] = value
                    end)
                }
            }
        }
    }
end

function UF:CreateUnitDRTrackerOption(unit, order)
    return {
        type = "group",
        name = L["DR Tracker"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).diminishingReturnsTracker.enabled
            end, function(value)
                UF:UnitConfig(unit).diminishingReturnsTracker.enabled = value
            end),
            size = {
                type = "group",
                name = L["Position"],
                order = 2,
                inline = true,
                disabled = function()
                    return not UF:UnitConfig(unit).diminishingReturnsTracker.enabled
                end,
                args = {
                    iconSize = UF:CreateRangeOption(unit, L["Icon Size"], L["The size of the DR icons."], 1, function()
                        return not UF:UnitConfig(unit).diminishingReturnsTracker.iconSize
                    end, 10, 60, nil, 1, function()
                        return UF:UnitConfig(unit).diminishingReturnsTracker.iconSize
                    end, function(value)
                        UF:UnitConfig(unit).diminishingReturnsTracker.iconSize = value
                    end),
                    iconSpacing = UF:CreateRangeOption(unit, L["Icon Spacing"], L["The spacing between each of the DR icons."], 2, function()
                        return not UF:UnitConfig(unit).diminishingReturnsTracker.iconSpacing
                    end, -50, 50, nil, 1, function()
                        return UF:UnitConfig(unit).diminishingReturnsTracker.iconSpacing
                    end, function(value)
                        UF:UnitConfig(unit).diminishingReturnsTracker.iconSpacing = value
                    end)
                }
            },
            position = {
                type = "group",
                name = L["Position"],
                order = 3,
                inline = true,
                disabled = function()
                    return not UF:UnitConfig(unit).diminishingReturnsTracker.enabled
                end,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).diminishingReturnsTracker.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).diminishingReturnsTracker.point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).diminishingReturnsTracker.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).diminishingReturnsTracker.point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit).diminishingReturnsTracker.point[3]
                    end, function(value)
                        UF:UnitConfig(unit).diminishingReturnsTracker.point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit).diminishingReturnsTracker.point[4]
                    end, function(value)
                        UF:UnitConfig(unit).diminishingReturnsTracker.point[4] = value
                    end)
                }
            }
        }
    }
end

function UF:CreateUnitCastbarOption(unit, order, canDetach)
    return {
        type = "group",
        name = L["Castbar"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).castbar.enabled
            end, function(value)
                UF:UnitConfig(unit).castbar.enabled = value
            end),
            styling = {
                type = "group",
                name = L["Styling"],
                inline = true,
                order = 2,
                disabled = function()
                    return not UF:UnitConfig(unit).castbar.enabled
                end,
                args = {
                    style = UF:CreateSelectOption(unit, L["Style"], L["The style of castbar to use."], 2, function()
                        return UF:UnitConfig(unit).castbar.style == nil
                    end, UF.CastbarStyles, function()
                        return UF:UnitConfig(unit).castbar.style
                    end, function(value)
                        UF:UnitConfig(unit).castbar.style = value
                    end),
                    lineBreakToggles = { type = "description", name = "", order = 3 },
                    showIcon = UF:CreateToggleOption(unit, L["Show Icon"], L["Whether to show an icon in the castbar."], 4, nil, nil, function()
                        return UF:UnitConfig(unit).castbar.showIcon
                    end, function(value)
                        UF:UnitConfig(unit).castbar.showIcon = value
                    end),
                    showSpark = UF:CreateToggleOption(unit, L["Show Spark"], L["Whether to show the spark at the end of the castbar."], 5, nil, nil, function()
                        return UF:UnitConfig(unit).castbar.showSpark
                    end, function(value)
                        UF:UnitConfig(unit).castbar.showSpark = value
                    end),
                    showSafeZone = UF:CreateToggleOption(unit, L["Show Latency"], L["Whether to show a latency indicator."], 6, nil, unit ~= "player", function()
                        return UF:UnitConfig(unit).castbar.showSafeZone
                    end, function(value)
                        UF:UnitConfig(unit).castbar.showSafeZone = value
                    end),
                    showGlow = UF:CreateToggleOption(unit, L["Show Decorations"], L["Whether to show border glow and decorations for the castbar."], 7, nil, function()
                        return UF:UnitConfig(unit).castbar.style ~= UF.CastbarStyles.Custom
                    end, function()
                        return UF:UnitConfig(unit).castbar.showGlow
                    end, function(value)
                        UF:UnitConfig(unit).castbar.showGlow = value
                    end),
                    lineBreakShield = { type = "description", name = "", order = 9 },
                    showShield = UF:CreateToggleOption(unit, L["Show Shield"], L["Whether to show a shield icon for uninterruptible spells."], 10, nil, nil, function()
                        return UF:UnitConfig(unit).castbar.showShield
                    end, function(value)
                        UF:UnitConfig(unit).castbar.showShield = value
                    end),
                    shieldSize = UF:CreateRangeOption(unit, L["Shield Size"], L["The size of the shield icon."], 11, function()
                        return not UF:UnitConfig(unit).castbar.showShield
                    end, 10, 60, nil, 1, function()
                        return UF:UnitConfig(unit).castbar.shieldSize
                    end, function(value)
                        UF:UnitConfig(unit).castbar.shieldSize = value
                    end),
                    lineBreakDetached = { type = "description", name = "", order = 12 },
                    detached = UF:CreateToggleOption(unit, L["Detached"], L["Whether the castbar is detached from the unit frame."], 13, nil, not canDetach, function()
                        return UF:UnitConfig(unit).castbar.detached
                    end, function(value)
                        UF:UnitConfig(unit).castbar.detached = value;
                        UF:UnitConfig(unit).castbar.point = value and { "CENTER", "UIParent", "BOTTOM", 0, 150 } or { "TOPLEFT", "BOTTOMLEFT", 0, -5 }
                    end)
                }
            },
            size = {
                type = "group",
                name = L["Size"],
                inline = true,
                order = 3,
                args = {
                    overrideStyleSize = UF:CreateToggleOption(unit, L["Override Style Size"], L["Allow the settings below to take effect even when using a preset style."], 0, nil, nil, function()
                        return UF:UnitConfig(unit).castbar.overrideStyleSize
                    end, function(value)
                        UF:UnitConfig(unit).castbar.overrideStyleSize = value
                    end),
                    lineBreak1 = { type = "description", name = "", order = 1 },
                    width = UF:CreateRangeOption(unit, L["Width"], L["The width of the castbar."], 2, not canDetach, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit).castbar.size[1]
                    end, function(value)
                        UF:UnitConfig(unit).castbar.size[1] = value
                    end, function()
                        return not UF:UnitConfig(unit).castbar.enabled or (IsBlizzardStyled(unit) and not UF:UnitConfig(unit).castbar.overrideStyleSize)
                    end),
                    height = UF:CreateRangeOption(unit, L["Height"], L["The height of the castbar."], 3, nil, 4, nil, 400, 1, function()
                        return UF:UnitConfig(unit).castbar.size[2]
                    end, function(value)
                        UF:UnitConfig(unit).castbar.size[2] = value
                    end, function()
                        return not UF:UnitConfig(unit).castbar.enabled or (IsBlizzardStyled(unit) and not UF:UnitConfig(unit).castbar.overrideStyleSize)
                    end)
                }
            },
            position = {
                type = "group",
                name = L["Position"],
                inline = true,
                order = 4,
                args = {
                    overrideStylePosition = UF:CreateToggleOption(unit, L["Override Style Position"], L["Allow the settings below to take effect even when using a preset style."], 0, nil, nil, function()
                        return UF:UnitConfig(unit).castbar.overrideStylePosition
                    end, function(value)
                        UF:UnitConfig(unit).castbar.overrideStylePosition = value
                    end),
                    lineBreak1 = { type = "description", name = "", order = 1 },
                    point = UF:CreatePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).castbar.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).castbar.point[1] = value
                    end, function()
                        return not UF:UnitConfig(unit).castbar.enabled or (IsBlizzardStyled(unit) and not UF:UnitConfig(unit).castbar.overrideStylePosition)
                    end),
                    anchor = UF:CreateAnchorOption(unit, 3, function()
                        return not UF:UnitConfig(unit).castbar.detached
                    end, function()
                        return UF:UnitConfig(unit).castbar.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).castbar.point[2] = value
                    end, function()
                        return not UF:UnitConfig(unit).castbar.enabled or (IsBlizzardStyled(unit) and not UF:UnitConfig(unit).castbar.overrideStylePosition)
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 4, function()
                        return UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 2 or 3]
                    end, function(value)
                        UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 2 or 3] = value
                    end, function()
                        return not UF:UnitConfig(unit).castbar.enabled or (IsBlizzardStyled(unit) and not UF:UnitConfig(unit).castbar.overrideStylePosition)
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 5, function()
                        return UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 3 or 4]
                    end, function(value)
                        UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 3 or 4] = value
                    end, function()
                        return not UF:UnitConfig(unit).castbar.enabled or (IsBlizzardStyled(unit) and not UF:UnitConfig(unit).castbar.overrideStylePosition)
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 6, function()
                        return UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 4 or 5]
                    end, function(value)
                        UF:UnitConfig(unit).castbar.point[(not UF:UnitConfig(unit).castbar.detached) and 4 or 5] = value
                    end, function()
                        return not UF:UnitConfig(unit).castbar.enabled or (IsBlizzardStyled(unit) and not UF:UnitConfig(unit).castbar.overrideStylePosition)
                    end)
                }
            },
            font = {
                type = "group",
                name = L["Font"],
                inline = true,
                order = 5,
                disabled = function()
                    return not UF:UnitConfig(unit).castbar.enabled
                end,
                args = {
                    font = UF:CreateFontFamilyOption(unit, 1, function()
                        return UF:UnitConfig(unit).castbar.font
                    end, function(value)
                        UF:UnitConfig(unit).castbar.font = value
                    end),
                    fontSize = UF:CreateFontSizeOption(unit, 2, function()
                        return UF:UnitConfig(unit).castbar.fontSize
                    end, function(value)
                        UF:UnitConfig(unit).castbar.fontSize = value
                    end),
                    fontOutline = UF:CreateFontOutlineOption(unit, 3, function()
                        return UF:UnitConfig(unit).castbar.fontOutline
                    end, function(value)
                        UF:UnitConfig(unit).castbar.fontOutline = value
                    end),
                    fontShadow = UF:CreateFontShadowOption(unit, 4, function()
                        return UF:UnitConfig(unit).castbar.fontShadow
                    end, function(value)
                        UF:UnitConfig(unit).castbar.fontShadow = value
                    end)
                }
            }
        }
    }
end

function UF:CreateUnitTotemsOption(unit, order)
    return unit == "player" and {
        type = "group",
        name = L["Totem Timers"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).totems.enabled
            end, function(value)
                UF:UnitConfig(unit).totems.enabled = value
            end),
            styling = {
                type = "group",
                name = L["Styling"],
                inline = true,
                order = 2,
                disabled = function()
                    return not UF:UnitConfig(unit).totems.enabled
                end,
                args = {
                    iconSize = UF:CreateRangeOption(unit, L["Icon Size"], L["The size of totem timer icons."], 1, nil, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit).totems.iconSize
                    end, function(value)
                        UF:UnitConfig(unit).totems.iconSize = value
                    end),
                    iconSpacing = UF:CreateRangeOption(unit, L["Icon Spacing"], L["The spacing between each totem timer icon."], 2, nil, 0, nil, 400, 1, function()
                        return UF:UnitConfig(unit).totems.spacing
                    end, function(value)
                        UF:UnitConfig(unit).totems.spacing = value
                    end),
                    detached = UF:CreateToggleOption(unit, L["Detached"], L["Whether the totem timer frame is detached from the unit frame."], 3, nil, nil, function()
                        return UF:UnitConfig(unit).totems.detached
                    end, function(value)
                        UF:UnitConfig(unit).totems.detached = value;
                        UF:UnitConfig(unit).totems.point = value and { "CENTER", "UIParent", "BOTTOM", 0, 450 } or { "BOTTOM", "TOP", 0, 5 }
                    end)
                }
            },
            position = {
                type = "group",
                name = L["Position"],
                inline = true,
                order = 3,
                disabled = function()
                    return not UF:UnitConfig(unit).totems.enabled
                end,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).totems.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).totems.point[1] = value
                    end),
                    anchor = UF:CreateAnchorOption(unit, 2, function()
                        return not UF:UnitConfig(unit).totems.detached
                    end, function()
                        return UF:UnitConfig(unit).totems.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).totems.point[2] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 3, function()
                        return UF:UnitConfig(unit).totems.point[(not UF:UnitConfig(unit).totems.detached) and 2 or 3]
                    end, function(value)
                        UF:UnitConfig(unit).totems.point[(not UF:UnitConfig(unit).totems.detached) and 2 or 3] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 4, function()
                        return UF:UnitConfig(unit).totems.point[(not UF:UnitConfig(unit).totems.detached) and 3 or 4]
                    end, function(value)
                        UF:UnitConfig(unit).totems.point[(not UF:UnitConfig(unit).totems.detached) and 3 or 4] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 5, function()
                        return UF:UnitConfig(unit).totems.point[(not UF:UnitConfig(unit).totems.detached) and 4 or 5]
                    end, function(value)
                        UF:UnitConfig(unit).totems.point[(not UF:UnitConfig(unit).totems.detached) and 4 or 5] = value
                    end)
                }
            }
        }
    }
end

function UF:CreateUnitRunesOption(unit, order)
    return unit == "player" and {
        type = "group",
        name = L["Runes"],
        order = order,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).runes.enabled
            end, function(value)
                UF:UnitConfig(unit).runes.enabled = value
            end),
            styling = {
                type = "group",
                name = L["Styling"],
                inline = true,
                order = 2,
                disabled = function()
                    return not UF:UnitConfig(unit).runes.enabled
                end,
                args = {
                    style = UF:CreateSelectOption(unit, L["Style"], L["The style preset for this unit's rune frame."], 0, function()
                        return UF:UnitConfig(unit).runes.style == nil
                    end, UF.RuneStyles, function()
                        return UF:UnitConfig(unit).runes.style
                    end, function(value)
                        UF:UnitConfig(unit).runes.style = value
                        UF:UnitConfig(unit).runes.size = value == UF.RuneStyles.Bars and { 32, 12 } or { 24, 24 }
                    end),
                    detached = UF:CreateToggleOption(unit, L["Detached"], L["Whether the rune frame is detached from the unit frame."], 6, nil, nil, function()
                        return UF:UnitConfig(unit).runes.detached
                    end, function(value)
                        UF:UnitConfig(unit).runes.detached = value;
                        UF:UnitConfig(unit).runes.point = value and { "CENTER", "UIParent", "BOTTOM", 0, 450 } or { "BOTTOM", "TOP", 0, 5 }
                    end),
                    lineBreak0 = { type = "description", name = "", order = 1 },
                    iconSize = UF:CreateRangeOption(unit, L["Rune Size"], L["The width of rune bars/icons."], 2, function()
                        return UF:UnitConfig(unit).runes.style == UF.RuneStyles.Bars
                    end, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit).runes.size[1]
                    end, function(value)
                        UF:UnitConfig(unit).runes.size[1] = value
                        UF:UnitConfig(unit).runes.size[2] = value
                    end),
                    iconWidth = UF:CreateRangeOption(unit, L["Rune Width"], L["The width of rune bars/icons."], 2, function()
                        return UF:UnitConfig(unit).runes.style == UF.RuneStyles.Icons
                    end, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit).runes.size[1]
                    end, function(value)
                        UF:UnitConfig(unit).runes.size[1] = value
                    end),
                    iconHeight = UF:CreateRangeOption(unit, L["Rune Height"], L["The height of rune bars/icons."], 3, function()
                        return UF:UnitConfig(unit).runes.style == UF.RuneStyles.Icons
                    end, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit).runes.size[2]
                    end, function(value)
                        UF:UnitConfig(unit).runes.size[2] = value
                    end),
                    iconSpacing = UF:CreateRangeOption(unit, L["Rune Spacing"], L["The spacing between each rune bar/icon."], 4, nil, 0, nil, 400, 1, function()
                        return UF:UnitConfig(unit).runes.spacing
                    end, function(value)
                        UF:UnitConfig(unit).runes.spacing = value
                    end),
                    lineBreak1 = { type = "description", name = "", order = 5 },
                    detached = UF:CreateToggleOption(unit, L["Detached"], L["Whether the rune frame is detached from the unit frame."], 6, nil, nil, function()
                        return UF:UnitConfig(unit).runes.detached
                    end, function(value)
                        UF:UnitConfig(unit).runes.detached = value;
                        UF:UnitConfig(unit).runes.point = value and { "CENTER", "UIParent", "BOTTOM", 0, 450 } or { "BOTTOM", "TOP", 0, 5 }
                    end),
                    lineBreak2 = { type = "description", name = "", order = 7 },
                    showBorder = UF:CreateToggleOption(unit, L["Show Border"], L["Whether each rune has a border around it."], 8, nil, nil, function()
                        return UF:UnitConfig(unit).runes.border
                    end, function(value)
                        UF:UnitConfig(unit).runes.border = value
                    end, nil, function()
                        return UF:UnitConfig(unit).runes.style == UF.RuneStyles.Icons
                    end),
                    showInlay = UF:CreateToggleOption(unit, L["Show Inlay"], L["Whether each rune has an inlay decoration."], 9, nil, nil, function()
                        return UF:UnitConfig(unit).runes.inlay
                    end, function(value)
                        UF:UnitConfig(unit).runes.inlay = value
                    end, nil, function()
                        return UF:UnitConfig(unit).runes.style == UF.RuneStyles.Icons
                    end)
                }
            },
            position = {
                type = "group",
                name = L["Position"],
                inline = true,
                order = 3,
                disabled = function()
                    return not UF:UnitConfig(unit).runes.enabled
                end,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).runes.point[1]
                    end, function(value)
                        UF:UnitConfig(unit).runes.point[1] = value
                    end),
                    anchor = UF:CreateAnchorOption(unit, 2, function()
                        return not UF:UnitConfig(unit).runes.detached
                    end, function()
                        return UF:UnitConfig(unit).runes.point[2]
                    end, function(value)
                        UF:UnitConfig(unit).runes.point[2] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 3, function()
                        return UF:UnitConfig(unit).runes.point[(not UF:UnitConfig(unit).runes.detached) and 2 or 3]
                    end, function(value)
                        UF:UnitConfig(unit).runes.point[(not UF:UnitConfig(unit).runes.detached) and 2 or 3] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 4, function()
                        return UF:UnitConfig(unit).runes.point[(not UF:UnitConfig(unit).runes.detached) and 3 or 4]
                    end, function(value)
                        UF:UnitConfig(unit).runes.point[(not UF:UnitConfig(unit).runes.detached) and 3 or 4] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 5, function()
                        return UF:UnitConfig(unit).runes.point[(not UF:UnitConfig(unit).runes.detached) and 4 or 5]
                    end, function(value)
                        UF:UnitConfig(unit).runes.point[(not UF:UnitConfig(unit).runes.detached) and 4 or 5] = value
                    end)
                }
            }
        }
    }
end

function UF:CreateUnitIndicatorOption(unit, indicatorName, order, title, hidden)
    return {
        type = "group",
        name = title,
        order = order,
        hidden = hidden,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit)[indicatorName].enabled
            end, function(value)
                UF:UnitConfig(unit)[indicatorName].enabled = value
            end),
            position = {
                type = "group",
                name = L["Position"],
                order = 2,
                disabled = IsBlizzardStyled(unit),
                inline = true,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit)[indicatorName].point[1]
                    end, function(value)
                        UF:UnitConfig(unit)[indicatorName].point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit)[indicatorName].point[2]
                    end, function(value)
                        UF:UnitConfig(unit)[indicatorName].point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit)[indicatorName].point[3]
                    end, function(value)
                        UF:UnitConfig(unit)[indicatorName].point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit)[indicatorName].point[4]
                    end, function(value)
                        UF:UnitConfig(unit)[indicatorName].point[4] = value
                    end)
                }
            },
            size = {
                type = "group",
                name = L["Size"],
                order = 3,
                inline = true,
                disabled = IsBlizzardStyled(unit),
                args = {
                    width = UF:CreateRangeOption(unit, L["Width"], L["The width of the indicator."], 10, nil, 10, nil, 400, 1, function()
                        return UF:UnitConfig(unit)[indicatorName].size[1]
                    end, function(value)
                        UF:UnitConfig(unit)[indicatorName].size[1] = value
                    end),
                    height = UF:CreateRangeOption(unit, L["Height"], L["The height of the indicator."], 11, nil, 4, nil, 400, 1, function()
                        return UF:UnitConfig(unit)[indicatorName].size[2]
                    end, function(value)
                        UF:UnitConfig(unit)[indicatorName].size[2] = value
                    end)
                }
            }
        }
    }
end

function UF:CreateUnitAurasOption(unit, order, name, setting, hidden)
    return {
        type = "group",
        name = name,
        order = order,
        inline = true,
        hidden = hidden,
        disabled = function()
            return not UF:UnitConfig(unit).auras.enabled
        end,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).auras[setting].enabled
            end, function(value)
                UF:UnitConfig(unit).auras[setting].enabled = value
            end),
            layout = {
                type = "group",
                name = L["Layout"],
                order = 2,
                inline = true,
                disabled = function()
                    return not UF:UnitConfig(unit).auras.enabled or not UF:UnitConfig(unit).auras[setting].enabled
                end,
                args = {
                    iconSize = UF:CreateRangeOption(unit, L["Aura Size"], L["The size of the aura icons."], 1, nil, 10, nil, 50, 1, function()
                        return UF:UnitConfig(unit).auras[setting].iconSize
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].iconSize = value
                    end),
                    showDuration = UF:CreateToggleOption(unit, L["Show Duration"], nil, 2, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].showDuration
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].showDuration = value
                    end),
                    minSizeToShowDuration = UF:CreateRangeOption(unit, L["Min Size to Show Duration"], L["The minimum size an aura icon should be before duration is shown."], 3, nil, 0, nil, 80, 1,
                                                                 function()
                        return UF:UnitConfig(unit).auras[setting].minSizeToShowDuration
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].minSizeToShowDuration = value
                    end, function()
                        return not UF:UnitConfig(unit).auras[setting].showDuration
                    end),
                    spacing = UF:CreateRangeOption(unit, L["Aura Spacing"], L["The spacing between aura icons."], 4, nil, -10, nil, 30, 1, function()
                        return UF:UnitConfig(unit).auras[setting].spacing
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].spacing = value
                    end),
                    numColumns = UF:CreateRangeOption(unit, L["Number of Columns"], L["The number of columns."], 5, nil, 1, nil, 32, 1, function()
                        return UF:UnitConfig(unit).auras[setting].numColumns
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].numColumns = value
                    end),
                    num = UF:CreateRangeOption(unit, L["Number of " .. name], L["The number of auras to show."], 6, setting == "buffsAndDebuffs", 1, nil, 32, 1, function()
                        return UF:UnitConfig(unit).auras[setting].num
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].num = value
                    end),
                    numBuffs = UF:CreateRangeOption(unit, L["Number of Buffs"], L["The number of buffs to show."], 7, setting ~= "buffsAndDebuffs", 1, nil, 32, 1, function()
                        return UF:UnitConfig(unit).auras[setting].numBuffs
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].numBuffs = value
                    end),
                    numDebuffs = UF:CreateRangeOption(unit, L["Number of Debuffs"], L["The number of debuffs to show."], 8, setting ~= "buffsAndDebuffs", 1, nil, 32, 1, function()
                        return UF:UnitConfig(unit).auras[setting].numDebuffs
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].numDebuffs = value
                    end),
                    initialAnchor = UF:CreateSelectOption(unit, L["Initial Anchor"], L["Anchor point for the aura buttons."], 9, nil, R.ANCHOR_POINTS, function()
                        return UF:UnitConfig(unit).auras[setting].initialAnchor
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].initialAnchor = value
                    end),
                    growthX = UF:CreateSelectOption(unit, L["Horizontal Growth Direction"], L["Horizontal growth direction."], 10, nil, { "LEFT", "RIGHT" }, function()
                        return UF:UnitConfig(unit).auras[setting].growthX
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].growthX = value
                    end),
                    growthY = UF:CreateSelectOption(unit, L["Vertical Growth Direction"], L["Horizontal growth direction."], 11, nil, { "UP", "DOWN" }, function()
                        return UF:UnitConfig(unit).auras[setting].growthY
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].growthY = value
                    end)
                }
            },
            position = {
                type = "group",
                name = L["Position"],
                order = 3,
                inline = true,
                disabled = function()
                    return not UF:UnitConfig(unit).auras.enabled or not UF:UnitConfig(unit).auras[setting].enabled
                end,
                args = {
                    point = UF:CreatePointOption(unit, 1, function()
                        return UF:UnitConfig(unit).auras[setting].point[1]
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].point[1] = value
                    end),
                    relativePoint = UF:CreateRelativePointOption(unit, 2, function()
                        return UF:UnitConfig(unit).auras[setting].point[2]
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].point[2] = value
                    end),
                    offsetX = UF:CreateOffsetXOption(unit, 3, function()
                        return UF:UnitConfig(unit).auras[setting].point[3]
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].point[3] = value
                    end),
                    offsetY = UF:CreateOffsetYOption(unit, 4, function()
                        return UF:UnitConfig(unit).auras[setting].point[4]
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].point[4] = value
                    end)
                }
            },
            count = {
                type = "group",
                name = L["Count"],
                order = 4,
                inline = true,
                disabled = function()
                    return not UF:UnitConfig(unit).auras.enabled or not UF:UnitConfig(unit).auras[setting].enabled
                end,
                args = {
                    font = UF:CreateFontFamilyOption(unit, 1, function()
                        return UF:UnitConfig(unit).auras[setting].countFont
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].countFont = value
                    end),
                    size = UF:CreateFontSizeOption(unit, 2, function()
                        return UF:UnitConfig(unit).auras[setting].countFontSize
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].countFontSize = value
                    end),
                    outline = UF:CreateFontOutlineOption(unit, 3, function()
                        return UF:UnitConfig(unit).auras[setting].countFontOutline
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].countFontOutline = value
                    end),
                    shadow = UF:CreateFontShadowOption(unit, 4, function()
                        return UF:UnitConfig(unit).auras[setting].countFontShadow
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].countFontShadow = value
                    end)
                }
            },
            duration = {
                type = "group",
                name = L["Duration"],
                order = 5,
                inline = true,
                disabled = function()
                    return not UF:UnitConfig(unit).auras.enabled or not UF:UnitConfig(unit).auras[setting].enabled
                end,
                args = {
                    font = UF:CreateFontFamilyOption(unit, 1, function()
                        return UF:UnitConfig(unit).auras[setting].durationFont
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].durationFont = value
                    end),
                    size = UF:CreateFontSizeOption(unit, 2, function()
                        return UF:UnitConfig(unit).auras[setting].durationFontSize
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].durationFontSize = value
                    end),
                    outline = UF:CreateFontOutlineOption(unit, 3, function()
                        return UF:UnitConfig(unit).auras[setting].durationFontOutline
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].durationFontOutline = value
                    end),
                    shadow = UF:CreateFontShadowOption(unit, 4, function()
                        return UF:UnitConfig(unit).auras[setting].durationFontShadow
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].durationFontShadow = value
                    end),
                    lineBreak1 = { type = "description", name = "", order = 5 },
                    showFill = UF:CreateToggleOption(unit, L["Show Fill"], L["Whether the duration overlay should be shown."], 6, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].showFill
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].showFill = value
                    end),
                    reverseFill = UF:CreateToggleOption(unit, L["Reverse Fill"], L["Whether the duration overlay should fill in reverse order."], 7, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].reverseFill
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].reverseFill = value
                    end)
                }
            }
        }
    }
end

function UF:CreateUnitAuraFilterOption(unit, order, name, setting, isBuff)
    return {
        type = "group",
        name = name or L["Filter"],
        order = order,
        inline = true,
        disabled = function()
            return not UF:UnitConfig(unit).auras.enabled
        end,
        args = {
            minDuration = UF:CreateRangeOption(unit, L["Minimum Duration"], L["The minimum duration an aura needs to have to be shown. Set to 0 to disable."], 1, nil, 0, nil, 120, 1, function()
                return UF:UnitConfig(unit).auras[setting].minDuration
            end, function(value)
                UF:UnitConfig(unit).auras[setting].minDuration = value
            end),
            maxDuration = UF:CreateRangeOption(unit, L["Maximum Duration"], L["The maximum duration an aura is allowed to have to be shown. Set to 0 to disable."], 2, nil, 0, nil, 600, 1, function()
                return UF:UnitConfig(unit).auras[setting].maxDuration
            end, function(value)
                UF:UnitConfig(unit).auras[setting].maxDuration = value
            end),
            whitelist = {
                type = "group",
                name = L["Whitelist"],
                order = 3,
                inline = true,
                args = {
                    boss = UF:CreateToggleOption(unit, L["Boss"], nil, 1, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.Boss
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.Boss = value
                    end),
                    myPet = UF:CreateToggleOption(unit, L["MyPet"], nil, 2, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.MyPet
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.MyPet = value
                    end),
                    otherPet = UF:CreateToggleOption(unit, L["OtherPet"], nil, 3, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.OtherPet
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.OtherPet = value
                    end),
                    personal = UF:CreateToggleOption(unit, L["Personal"], nil, 4, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.Personal
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.Personal = value
                    end),
                    nonPersonal = UF:CreateToggleOption(unit, L["NonPersonal"], nil, 5, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.NonPersonal
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.NonPersonal = value
                    end),
                    castByUnit = UF:CreateToggleOption(unit, L["CastByUnit"], nil, 6, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByUnit
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByUnit = value
                    end),
                    notCastByUnit = UF:CreateToggleOption(unit, L["NotCastByUnit"], nil, 7, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.NotCastByUnit
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.NotCastByUnit = value
                    end),
                    castByNPC = UF:CreateToggleOption(unit, L["CastByNPC"], nil, 8, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByNPC
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByNPC = value
                    end),
                    castByPlayers = UF:CreateToggleOption(unit, L["CastByPlayers"], nil, 9, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByPlayers
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.CastByPlayers = value
                    end),
                    dispellable = UF:CreateToggleOption(unit, L["Dispellable"], nil, 10, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.Dispellable
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.Dispellable = value
                    end),
                    notDispellable = UF:CreateToggleOption(unit, L["NotDispellable"], nil, 11, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.NotDispellable
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.NotDispellable = value
                    end),
                    nameplate = UF:CreateToggleOption(unit, L["Nameplate"], nil, 12, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.Nameplate
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.Nameplate = value
                    end),
                    lineBreak1 = { type = "header", name = "", order = 13 },
                    crowdControl = UF:CreateToggleOption(unit, L["Crowd Control"], nil, 15, nil, isBuff, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.CrowdControl
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.CrowdControl = value
                    end),
                    playerBuffs = UF:CreateToggleOption(unit, L["Player Buffs"], nil, 16, nil, not isBuff, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.PlayerBuffs
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.PlayerBuffs = value
                    end),
                    turtleBuffs = UF:CreateToggleOption(unit, L["Turtle Buffs"], nil, 17, nil, not isBuff, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.TurtleBuffs
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.TurtleBuffs = value
                    end),
                    raidBuffs = UF:CreateToggleOption(unit, L["Raid Buffs"], nil, 18, nil, not isBuff, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.RaidBuffs
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.RaidBuffs = value
                    end),
                    raidDebuffs = UF:CreateToggleOption(unit, L["Raid Debuffs"], nil, 19, nil, isBuff, function()
                        return UF:UnitConfig(unit).auras[setting].filter.whitelist.PlayerBuffs
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.whitelist.PlayerBuffs = value
                    end),
                    lineBreak2 = { type = "header", name = "", order = 20 },
                    spellIDs = {
                        order = 21,
                        type = "multiselect",
                        width = 1.75,
                        name = L["Specific Spell IDs/Names"],
                        tristate = false,
                        values = function()
                            local spells = {}
                            for spell, _ in pairs(UF:UnitConfig(unit).auras[setting].filter.whitelist.Spells) do
                                spells["" .. spell] = GetSpellDisplayName(spell)
                            end
                            return spells
                        end,
                        get = function(info, key)
                            return selectedWhitelistSpells[key]
                        end,
                        set = function(info, key)
                            selectedWhitelistSpells[key] = not selectedWhitelistSpells[key]
                        end
                    },
                    removeAction = {
                        order = 22,
                        type = "execute",
                        name = L["Remove Selected Spell(s)"],
                        func = function()
                            for spell, selected in pairs(selectedWhitelistSpells) do
                                if selected then
                                    UF:UnitConfig(unit).auras[setting].filter.whitelist.Spells[spell] = nil
                                    spell = SafeToNumber(spell) or spell
                                    UF:UnitConfig(unit).auras[setting].filter.whitelist.Spells[spell] = nil
                                end
                            end
                            selectedWhitelistSpells = {}
    
                            UF:UpdateUnit(unit)
                        end
                    },
                    addSpellBreak1 = {order = 23, type = "description", name = ""},
                    findSpellName = {
                        order = 24,
                        type = "input",
                        name = L["Spell ID or Name"],
                        desc = L["Name or ID of the spell to add."],
                        get = function(info)
                            return addWhitelistSpellFilter
                        end,
                        set = function(info, value)
                            addWhitelistSpellFilter = value
                        end
                    },
                    addSpellByName = {
                        order = 25,
                        type = "execute",
                        name = L["Add Spell by Name"],
                        disabled = function()
                            return not addWhitelistSpellFilter
                        end,
                        func = function()
                            if not addWhitelistSpellFilter then
                                return
                            end
    
                            UF:UnitConfig(unit).auras[setting].filter.whitelist.Spells[addWhitelistSpellFilter] = true    
                            UF:UpdateUnit(unit)
                        end
                    },
                    addSpellBreak2 = {order = 26, type = "description", name = ""},
                    findSpellResults = {
                        order = 27,
                        type = "select",
                        name = L["Select Spell by ID"],
                        values = function()
                            local spells = {}
                            if addWhitelistSpellFilter then
                                local ids = R.Libs.SpellCache:GetSpells(addWhitelistSpellFilter)
                                for _, id in ipairs(ids) do
                                    spells[id] = GetSpellDisplayName(id)
                                end

                                if not whitelistSpellToAdd or not spells[whitelistSpellToAdd] then
                                    whitelistSpellToAdd = ids[1]
                                end
                            end
                            return spells
                        end,
                        get = function(info, key)
                            return whitelistSpellToAdd
                        end,
                        set = function(info, key)
                            whitelistSpellToAdd = key
                        end
                    },
                    addSpellByID = {
                        order = 28,
                        type = "execute",
                        name = L["Add Selected Spell by ID"],
                        disabled = function()
                            return not whitelistSpellToAdd
                        end,
                        func = function()
                            if not whitelistSpellToAdd then
                                return
                            end
    
                            UF:UnitConfig(unit).auras[setting].filter.whitelist.Spells[whitelistSpellToAdd] = true    
                            UF:UpdateUnit(unit)
                        end
                    }
                }
            },
            blacklist = {
                type = "group",
                name = L["Blacklist"],
                order = 4,
                inline = true,
                args = {
                    blockNonPersonal = UF:CreateToggleOption(unit, L["BlockNonPersonal"], nil, 1, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNonPersonal
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNonPersonal = value
                    end),
                    blockCastByPlayers = UF:CreateToggleOption(unit, L["BlockCastByPlayers"], nil, 2, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockCastByPlayers
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockCastByPlayers = value
                    end),
                    blockNoDuration = UF:CreateToggleOption(unit, L["BlockNoDuration"], nil, 3, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNoDuration
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNoDuration = value
                    end),
                    blockDispellable = UF:CreateToggleOption(unit, L["BlockDispellable"], nil, 4, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockDispellable
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockDispellable = value
                    end),
                    blockNotDispellable = UF:CreateToggleOption(unit, L["BlockNotDispellable"], nil, 5, nil, nil, function()
                        return UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNotDispellable
                    end, function(value)
                        UF:UnitConfig(unit).auras[setting].filter.blacklist.BlockNotDispellable = value
                    end),
                    lineBreak = { type = "header", name = "", order = 20 },
                    spellIDs = {
                        order = 21,
                        type = "multiselect",
                        width = 1.75,
                        name = L["Specific Spell IDs/Names"],
                        tristate = false,
                        values = function()
                            local spells = {}
                            for spell, _ in pairs(UF:UnitConfig(unit).auras[setting].filter.blacklist.Spells) do
                                spells["" .. spell] = GetSpellDisplayName(spell)
                            end
                            return spells
                        end,
                        get = function(info, key)
                            return selectedBlacklistSpells[key]
                        end,
                        set = function(info, key)
                            selectedBlacklistSpells[key] = not selectedBlacklistSpells[key]
                        end
                    },
                    removeAction = {
                        order = 22,
                        type = "execute",
                        name = L["Remove Selected Spell(s)"],
                        func = function()
                            for spell, selected in pairs(selectedBlacklistSpells) do
                                if selected then                                    
                                    UF:UnitConfig(unit).auras[setting].filter.blacklist.Spells[spell] = nil
                                    spell = SafeToNumber(spell) or spell
                                    UF:UnitConfig(unit).auras[setting].filter.blacklist.Spells[spell] = nil
                                end
                            end
                            selectedBlacklistSpells = {}
    
                            UF:UpdateUnit(unit)
                        end
                    },
                    addSpellBreak1 = {order = 23, type = "description", name = ""},
                    findSpellName = {
                        order = 24,
                        type = "input",
                        name = L["Spell ID or Name"],
                        desc = L["Name or ID of the spell to add."],
                        get = function(info)
                            return addBlacklistSpellFilter
                        end,
                        set = function(info, value)
                            addBlacklistSpellFilter = value
                        end
                    },
                    addSpellByName = {
                        order = 25,
                        type = "execute",
                        name = L["Add Spell by Name"],
                        disabled = function()
                            return not addBlacklistSpellFilter
                        end,
                        func = function()
                            if not addBlacklistSpellFilter then
                                return
                            end
    
                            UF:UnitConfig(unit).auras[setting].filter.blacklist.Spells[addBlacklistSpellFilter] = true    
                            UF:UpdateUnit(unit)
                        end
                    },
                    addSpellBreak2 = {order = 26, type = "description", name = ""},
                    findSpellResults = {
                        order = 27,
                        type = "select",
                        name = L["Select Spell by ID"],
                        values = function()
                            local spells = {}
                            if addBlacklistSpellFilter then
                                local ids = R.Libs.SpellCache:GetSpells(addBlacklistSpellFilter)
                                for _, id in ipairs(ids) do
                                    spells[id] = GetSpellDisplayName(id)
                                end

                                if not blacklistSpellToAdd or not spells[blacklistSpellToAdd] then
                                    blacklistSpellToAdd = ids[1]
                                end
                            end
                            return spells
                        end,
                        get = function(info, key)
                            return blacklistSpellToAdd
                        end,
                        set = function(info, key)
                            blacklistSpellToAdd = key
                        end
                    },
                    addSpellByID = {
                        order = 28,
                        type = "execute",
                        name = L["Add Selected Spell by ID"],
                        disabled = function()
                            return not blacklistSpellToAdd
                        end,
                        func = function()
                            if not blacklistSpellToAdd then
                                return
                            end
    
                            UF:UnitConfig(unit).auras[setting].filter.blacklist.Spells[blacklistSpellToAdd] = true    
                            UF:UpdateUnit(unit)
                        end
                    }
                }
            }
        }
    }
end

function UF:CreateUnitStylingOption(unit, order)
    local styling = {
        type = "group",
        name = L["Styling"],
        order = order,
        inline = true,
        args = {
            style = UF:CreateSelectOption(unit, L["Style"], L["The style preset for this unit."], 1, function()
                return UF:UnitConfig(unit).style == nil
            end, UF.Styles, function()
                return UF:UnitConfig(unit).style
            end, function(value)
                UF:UnitConfig(unit).style = value
            end),
            inlay = UF:CreateToggleOption(unit, L["Show Inlay"], L["Whether to show an inlay for this unit."], 3, nil, IsBlizzardStyled(unit), function()
                return UF:UnitConfig(unit).inlay.enabled
            end, function(value)
                UF:UnitConfig(unit).inlay.enabled = value
            end),
            largeHealth = UF:CreateToggleOption(unit, L["Large Health"], L["Whether to use a larger health for this unit."], 4, nil, function()
                return UF:UnitConfig(unit).largeHealth == nil or UF:UnitConfig(unit).style == nil or UF:UnitConfig(unit).style ~= UF.Styles.Vanilla
            end, function()
                return UF:UnitConfig(unit).largeHealth
            end, function(value)
                UF:UnitConfig(unit).largeHealth = value
            end)
        }
    }

    return styling
end

function UF:CreateUnitHighlightOption(unit, order)
    local highlight = {
        type = "group",
        name = L["Highlighting"],
        order = order,
        inline = true,
        args = {
            enabled = UF:CreateToggleOption(unit, L["Enabled"], nil, 1, nil, nil, function()
                return UF:UnitConfig(unit).highlight.enabled
            end, function(value)
                UF:UnitConfig(unit).highlight.enabled = value
            end),
            lineBreak1 = { type = "description", name = "", order = 2 },
            animate = UF:CreateToggleOption(unit, L["Animate"], L["Whether to animate highlighting."], 4, nil, nil, function()
                return UF:UnitConfig(unit).highlight.animate
            end, function(value)
                UF:UnitConfig(unit).highlight.animate = value
            end),
            colorBorder = UF:CreateToggleOption(unit, L["Color Border"], L["Whether to color unit frame borders when highlighting."], 4, nil, nil, function()
                return UF:UnitConfig(unit).highlight.colorBorder
            end, function(value)
                UF:UnitConfig(unit).highlight.colorBorder = value
            end),
            colorShadow = UF:CreateToggleOption(unit, L["Color Shadows"], L["Whether to color unit frame shadows when highlighting."], 5, nil, nil, function()
                return UF:UnitConfig(unit).highlight.colorShadow
            end, function(value)
                UF:UnitConfig(unit).highlight.colorShadow = value
            end),
            lineBreak2 = { type = "description", name = "", order = 6 },
            debuffs = UF:CreateToggleOption(unit, L["Highlight Based On Debuff"], L["Whether to color unit frames based on debuff type."], 7, nil, nil, function()
                return UF:UnitConfig(unit).highlight.debuffs
            end, function(value)
                UF:UnitConfig(unit).highlight.debuffs = value
            end),
            onlyDispellableDebuffs = UF:CreateToggleOption(unit, L["Only Highlight Dispellable Debuffs"], L["Whether only highlight unit frames when player can dispel the debuff."], 8, nil, nil,
                                                           function()
                return UF:UnitConfig(unit).highlight.onlyDispellableDebuffs
            end, function(value)
                UF:UnitConfig(unit).highlight.onlyDispellableDebuffs = value
            end),
            lineBreak3 = { type = "description", name = "", order = 9 },
            threat = UF:CreateToggleOption(unit, L["Highlight Based On Threat"], L["Whether to color unit frames based on threat situation."], 10, nil, nil, function()
                return UF:UnitConfig(unit).highlight.threat
            end, function(value)
                UF:UnitConfig(unit).highlight.threat = value
            end),
            target = UF:CreateToggleOption(unit, L["Highlight Target"], L["Whether to color unit frames when targeted."], 11, nil, nil, function()
                return UF:UnitConfig(unit).highlight.target
            end, function(value)
                UF:UnitConfig(unit).highlight.target = value
            end),
            targetArrows = UF:CreateToggleOption(unit, L["Show Target Arrows"], L["Whether to show arrows next to the frame when targeted."], 12, nil,
                                                 UF:UnitDefaults(unit).highlight.targetArrows == nil, function()
                return UF:UnitConfig(unit).highlight.targetArrows
            end, function(value)
                UF:UnitConfig(unit).highlight.targetArrows = value
            end),
            lineBreak4 = { type = "description", name = "", order = 13 },
            resting = UF:CreateToggleOption(unit, L["Highlight Resting"], L["Whether to color the player frame when resting."], 14, nil, unit ~= "player", function()
                return UF:UnitConfig(unit).highlight.resting
            end, function(value)
                UF:UnitConfig(unit).highlight.resting = value
            end),
            combat = UF:CreateToggleOption(unit, L["Highlight Combat"], L["Whether to color the player frame when in combat."], 15, nil, unit ~= "player", function()
                return UF:UnitConfig(unit).highlight.combat
            end, function(value)
                UF:UnitConfig(unit).highlight.combat = value
            end)
        }
    }

    return highlight
end

function UF:CreateNamePlateCVarToggleOption(cvar, name, desc, order)
    return R:CreateToggleOption(name, desc, order, nil, nil, function()
        return UF:UnitConfig("nameplates").cvars[cvar] == 1
    end, function(value)
        UF:UnitConfig("nameplates").cvars[cvar] = value and 1 or 0
    end, UF.UpdateNamePlates)
end

function UF:CreateNamePlateCVarRangeOption(cvar, name, desc, order, min, max, step)
    return R:CreateRangeOption(name, desc, order, nil, min, max, max, step, function()
        return UF:UnitConfig("nameplates").cvars[cvar]
    end, function(value)
        UF:UnitConfig("nameplates").cvars[cvar] = value
    end, UF.UpdateNamePlates)
end

R:RegisterModuleOptions(UF, {
    type = "group",
    name = L["Unit Frames"],
    childGroups = "tree",
    args = {
        header = { type = "header", name = R.title .. " > Unit Frames", order = 0 },
        enabled = R:CreateModuleEnabledOption(1, nil, "UnitFrames"),
        lineBreak1 = { type = "header", name = "", order = 2 },
        fonts = {
            type = "group",
            name = L["Fonts"],
            order = 5,
            inline = true,
            args = {
                font = R:CreateFontOption(L["Default Font Family"], L["The default font family for unit frame texts."], 1, nil, function()
                    return UF.config.font
                end, function(value)
                    UF.config.font = value
                end, UF.UpdateAll)
            }
        },
        statusbarTextures = {
            type = "group",
            name = L["Status Bar Textures"],
            order = 6,
            inline = true,
            args = {
                health = UF:CreateStatusBarTextureOption(L["Health"], L["Set the texture to use for health bars."], "health", 1),
                healthPrediction = UF:CreateStatusBarTextureOption(L["Health Prediction (Healing)"], L["Set the texture to use for health prediction bars."], "healthPrediction", 2),
                power = UF:CreateStatusBarTextureOption(L["Power"], L["Set the texture to use for power bars."], "power", 3),
                powerPrediction = UF:CreateStatusBarTextureOption(L["Power Prediction (Power Cost)"], L["Set the texture to use for power prediction bars."], "powerPrediction", 4),
                additionalPower = UF:CreateStatusBarTextureOption(L["Additional Power"], L["Set the texture to use for power bars."], "additionalPower", 5),
                additionalPowerPrediction = UF:CreateStatusBarTextureOption(L["Additional Power Prediction (Power Cost)"], L["Set the texture to use for additional power prediction bars."],
                                                                            "additionalPowerPrediction", 6),
                classPower = UF:CreateStatusBarTextureOption(L["Class Power"], L["Set the texture to use for class power bars (combo points etc)."], "classPower", 7),
                castbar = UF:CreateStatusBarTextureOption(L["Castbar (Normal)"], L["Set the texture to use for cast bars."], "castbar", 8),
                castbarChanneling = UF:CreateStatusBarTextureOption(L["Castbar (Channeling)"], L["Set the texture to use for cast bars when channeling."], "castbarChanneling", 9),
                castbarCrafting = UF:CreateStatusBarTextureOption(L["Castbar (Crafting)"], L["Set the texture to use for cast bars when crafting."], "castbarCrafting", 10),
                castbarEmpowering = UF:CreateStatusBarTextureOption(L["Castbar (Empowering)"], L["Set the texture to use for cast bars when empowering."], "castbarEmpowering", 11),
                castbarInterrupted = UF:CreateStatusBarTextureOption(L["Castbar (Interrupted)"], L["Set the texture to use for cast bars when casts are interrupted."], "castbarInterrupted", 12),
                castbarUninterruptable = UF:CreateStatusBarTextureOption(L["Castbar (Uninterruptable)"], L["Set the texture to use for cast bars when the cast is not interruptable."],
                                                                         "castbarUninterruptable", 13)
            }
        },
        statusBarColors = {
            type = "group",
            name = L["Status Bar Colors"],
            order = 7,
            inline = true,
            args = {
                health = UF:CreateStatusBarColorOption(L["Health"], "health", 1),
                mana = UF:CreateStatusBarColorOption(L["Mana"], "mana", 2),
                rage = UF:CreateStatusBarColorOption(L["Rage"], "rage", 3),
                energy = UF:CreateStatusBarColorOption(L["Energy"], "energy", 4),
                focus = UF:CreateStatusBarColorOption(L["Focus"], "focus", 5),
                comboPoints = UF:CreateStatusBarColorOption(L["Combo Points"], "comboPoints", 6),
                runicPower = UF:CreateStatusBarColorOption(L["Runic Power"], "runicPower", 7),
                castbar = UF:CreateStatusBarColorOption(L["Castbar"], "castbar", 8),
                castbarChanneling = UF:CreateStatusBarColorOption(L["Castbar (Channeling)"], "castbarChanneling", 9),
                castbarCrafting = UF:CreateStatusBarColorOption(L["Castbar (Crafting)"], "castbarCrafting", 10),
                castbarEmpowering = UF:CreateStatusBarColorOption(L["Castbar (Empowering)"], "castbarEmpowering", 11),
                castbarInterrupted = UF:CreateStatusBarColorOption(L["Castbar (Interrupted)"], "castbarInterrupted", 12),
                castbarUninterruptable = UF:CreateStatusBarColorOption(L["Castbar (Uninterruptable)"], "castbarUninterruptable", 13),
                lineBreak1 = { type = "header", name = "", order = 20 },
                colorHealthClass = R:CreateToggleOption(L["Color Health by Class"], nil, 21, nil, nil, function()
                    return UF.config.colors.colorHealthClass
                end, function(val)
                    UF.config.colors.colorHealthClass = val
                end, UF.UpdateAll),
                colorHealthSmooth = R:CreateToggleOption(L["Color Health by Value"], nil, 22, nil, nil, function()
                    return UF.config.colors.colorHealthSmooth
                end, function(val)
                    UF.config.colors.colorHealthSmooth = val
                end, UF.UpdateAll),
                colorHealthDisconnected = R:CreateToggleOption(L["Color Health when Disconnected"], nil, 23, nil, nil, function()
                    return UF.config.colors.colorHealthDisconnected
                end, function(val)
                    UF.config.colors.colorHealthDisconnected = val
                end, UF.UpdateAll),
                colorPowerClass = R:CreateToggleOption(L["Color Power by Class"], nil, 24, nil, nil, function()
                    return UF.config.colors.colorPowerClass
                end, function(val)
                    UF.config.colors.colorPowerClass = val
                end, UF.UpdateAll),
                colorPowerSmooth = R:CreateToggleOption(L["Color Power by Value"], nil, 25, nil, nil, function()
                    return UF.config.colors.colorPowerSmooth
                end, function(val)
                    UF.config.colors.colorPowerSmooth = val
                end, UF.UpdateAll),
                colorPowerDisconnected = R:CreateToggleOption(L["Color Power when Disconnected"], nil, 26, nil, nil, function()
                    return UF.config.colors.colorPowerDisconnected
                end, function(val)
                    UF.config.colors.colorPowerDisconnected = val
                end, UF.UpdateAll)
            }
        },
        classcolors = {
            type = "group",
            name = L["Class Colors"],
            order = 8,
            inline = true,
            args = {
                deathKnight = UF:CreateClassColorOption("DEATHKNIGHT", R:LocalizedClassName("Death Knight"), 10),
                demonHunter = UF:CreateClassColorOption("DEMONHUNTER", R:LocalizedClassName("Demon Hunter"), 11, not R.isRetail),
                druid = UF:CreateClassColorOption("DRUID", R:LocalizedClassName("Druid"), 12),
                hunter = UF:CreateClassColorOption("HUNTER", R:LocalizedClassName("Hunter"), 13),
                mage = UF:CreateClassColorOption("MAGE", R:LocalizedClassName("Mage"), 14),
                monk = UF:CreateClassColorOption("MONK", R:LocalizedClassName("Monk"), 15, not R.isRetail),
                paladin = UF:CreateClassColorOption("PALADIN", R:LocalizedClassName("Paladin"), 16),
                priest = UF:CreateClassColorOption("PRIEST", R:LocalizedClassName("Priest"), 17),
                rogue = UF:CreateClassColorOption("ROGUE", R:LocalizedClassName("Rogue"), 18),
                shaman = UF:CreateClassColorOption("SHAMAN", R:LocalizedClassName("Shaman"), 19),
                warlock = UF:CreateClassColorOption("WARLOCK", R:LocalizedClassName("Warlock"), 20),
                warrior = UF:CreateClassColorOption("WARRIOR", R:LocalizedClassName("Warrior"), 21)
            }
        },
        auras = {
            type = "group",
            name = L["Buffs & Debuffs"],
            order = 10,
            args = {
                header = { type = "header", name = R.title .. " > Unit Frames > Buffs & Debuffs", order = 0 },
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, nil, nil, function()
                    return UF.config.auraFrames.enabled
                end, function(value)
                    UF.config.auraFrames.enabled = value
                end, function()
                    if UF.config.auraFrames.enabled then
                        UF:StyleAuraFrames()
                    else
                        ReloadUI()
                    end
                end, function()
                    return UF.config.auraFrames.enabled and L["Disabling Aura Frames requires a UI reload. Proceed?"]
                end),
                buffs = {
                    type = "group",
                    name = L["Buffs"],
                    order = 2,
                    inline = true,
                    disabled = function()
                        return not UF.config.auraFrames.enabled
                    end,
                    args = {
                        iconSize = R:CreateRangeOption(L["Icon Size"], L["The size of the aura icons."], 1, nil, 10, nil, 80, 1, function()
                            return UF.config.auraFrames.buffs.iconSize
                        end, function(value)
                            UF.config.auraFrames.buffs.iconSize = value
                        end, function()
                            UF:UpdateAuraFrames()
                        end),
                        showDuration = R:CreateToggleOption(L["Show Duration"], nil, 2, nil, nil, function()
                            return UF.config.auraFrames.buffs.showDuration
                        end, function(value)
                            UF.config.auraFrames.buffs.showDuration = value
                        end, function()
                            UF:UpdateAuraFrames()
                        end),
                        minSizeToShowDuration = R:CreateRangeOption(L["Min Size to Show Duration"], L["The minimum size an aura icon should be before duration is shown."], 3, nil, 0, nil, 80, 1,
                                                                    function()
                            return UF.config.auraFrames.buffs.minSizeToShowDuration
                        end, function(value)
                            UF.config.auraFrames.buffs.minSizeToShowDuration = value
                        end, function()
                            UF:UpdateAuraFrames()
                        end, nil, function()
                            return not UF.config.auraFrames.buffs.showDuration
                        end),
                        count = {
                            type = "group",
                            name = L["Count Text"],
                            order = 4,
                            inline = true,
                            args = {
                                font = R:CreateFontOption(L["Font"], L["The font to use for aura texts."], 1, nil, function()
                                    return UF.config.auraFrames.buffs.countFont
                                end, function(value)
                                    UF.config.auraFrames.buffs.countFont = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                size = R:CreateRangeOption(L["Font Size"], L["The size of aura text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                                    return UF.config.auraFrames.buffs.countFontSize
                                end, function(value)
                                    UF.config.auraFrames.buffs.countFontSize = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of aura text."], 3, nil, R.FONT_OUTLINES, function()
                                    return UF.config.auraFrames.buffs.countFontOutline
                                end, function(value)
                                    UF.config.auraFrames.buffs.countFontOutline = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for aura text."], 4, nil, nil, function()
                                    return UF.config.auraFrames.buffs.countFontShadow
                                end, function(value)
                                    UF.config.auraFrames.buffs.countFontShadow = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end)
                            }
                        },
                        duration = {
                            type = "group",
                            name = L["Duration Text"],
                            order = 5,
                            inline = true,
                            args = {
                                font = R:CreateFontOption(L["Font"], L["The font to use for aura texts."], 1, nil, function()
                                    return UF.config.auraFrames.buffs.durationFont
                                end, function(value)
                                    UF.config.auraFrames.buffs.durationFont = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                size = R:CreateRangeOption(L["Font Size"], L["The size of aura text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                                    return UF.config.auraFrames.buffs.durationFontSize
                                end, function(value)
                                    UF.config.auraFrames.buffs.durationFontSize = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of aura text."], 3, nil, R.FONT_OUTLINES, function()
                                    return UF.config.auraFrames.buffs.durationFontOutline
                                end, function(value)
                                    UF.config.auraFrames.buffs.durationFontOutline = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for aura text."], 4, nil, nil, function()
                                    return UF.config.auraFrames.buffs.durationFontShadow
                                end, function(value)
                                    UF.config.auraFrames.buffs.durationFontShadow = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end)
                            }
                        }
                    }
                },
                debuffs = {
                    type = "group",
                    name = L["Debuffs"],
                    order = 3,
                    inline = true,
                    disabled = function()
                        return not UF.config.auraFrames.enabled
                    end,
                    args = {
                        iconSize = R:CreateRangeOption(L["Icon Size"], L["The size of the aura icons."], 1, nil, 10, nil, 80, 1, function()
                            return UF.config.auraFrames.debuffs.iconSize
                        end, function(value)
                            UF.config.auraFrames.debuffs.iconSize = value
                        end, function()
                            UF:UpdateAuraFrames()
                        end),
                        showDuration = R:CreateToggleOption(L["Show Duration"], nil, 2, nil, nil, function()
                            return UF.config.auraFrames.debuffs.showDuration
                        end, function(value)
                            UF.config.auraFrames.debuffs.showDuration = value
                        end, function()
                            UF:UpdateAuraFrames()
                        end),
                        minSizeToShowDuration = R:CreateRangeOption(L["Min Size to Show Duration"], L["The minimum size an aura icon should be before duration is shown."], 3, nil, 0, nil, 80, 1,
                                                                    function()
                            return UF.config.auraFrames.debuffs.minSizeToShowDuration
                        end, function(value)
                            UF.config.auraFrames.debuffs.minSizeToShowDuration = value
                        end, function()
                            UF:UpdateAuraFrames()
                        end, nil, function()
                            return not UF.config.auraFrames.debuffs.showDuration
                        end),
                        count = {
                            type = "group",
                            name = L["Count Text"],
                            order = 4,
                            inline = true,
                            args = {
                                font = R:CreateFontOption(L["Font"], L["The font to use for aura texts."], 1, nil, function()
                                    return UF.config.auraFrames.debuffs.countFont
                                end, function(value)
                                    UF.config.auraFrames.debuffs.countFont = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                size = R:CreateRangeOption(L["Font Size"], L["The size of aura text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                                    return UF.config.auraFrames.debuffs.countFontSize
                                end, function(value)
                                    UF.config.auraFrames.debuffs.countFontSize = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of aura text."], 3, nil, R.FONT_OUTLINES, function()
                                    return UF.config.auraFrames.debuffs.countFontOutline
                                end, function(value)
                                    UF.config.auraFrames.debuffs.countFontOutline = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for aura text."], 4, nil, nil, function()
                                    return UF.config.auraFrames.debuffs.countFontShadow
                                end, function(value)
                                    UF.config.auraFrames.debuffs.countFontShadow = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end)
                            }
                        },
                        duration = {
                            type = "group",
                            name = L["Duration Text"],
                            order = 5,
                            inline = true,
                            args = {
                                font = R:CreateFontOption(L["Font"], L["The font to use for aura texts."], 1, nil, function()
                                    return UF.config.auraFrames.debuffs.durationFont
                                end, function(value)
                                    UF.config.auraFrames.debuffs.durationFont = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                size = R:CreateRangeOption(L["Font Size"], L["The size of aura text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                                    return UF.config.auraFrames.debuffs.durationFontSize
                                end, function(value)
                                    UF.config.auraFrames.debuffs.durationFontSize = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of aura text."], 3, nil, R.FONT_OUTLINES, function()
                                    return UF.config.auraFrames.debuffs.durationFontOutline
                                end, function(value)
                                    UF.config.auraFrames.debuffs.durationFontOutline = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for aura text."], 4, nil, nil, function()
                                    return UF.config.auraFrames.debuffs.durationFontShadow
                                end, function(value)
                                    UF.config.auraFrames.debuffs.durationFontShadow = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end)
                            }
                        }
                    }
                },
                tempEnchants = {
                    type = "group",
                    name = L["Weapon Enchants"],
                    order = 4,
                    inline = true,
                    disabled = function()
                        return not UF.config.auraFrames.enabled
                    end,
                    args = {
                        iconSize = R:CreateRangeOption(L["Icon Size"], L["The size of the aura icons."], 1, nil, 10, nil, 80, 1, function()
                            return UF.config.auraFrames.tempEnchants.iconSize
                        end, function(value)
                            UF.config.auraFrames.tempEnchants.iconSize = value
                        end, function()
                            UF:UpdateAuraFrames()
                        end),
                        showDuration = R:CreateToggleOption(L["Show Duration"], nil, 2, nil, nil, function()
                            return UF.config.auraFrames.tempEnchants.showDuration
                        end, function(value)
                            UF.config.auraFrames.tempEnchants.showDuration = value
                        end, function()
                            UF:UpdateAuraFrames()
                        end),
                        minSizeToShowDuration = R:CreateRangeOption(L["Min Size to Show Duration"], L["The minimum size an aura icon should be before duration is shown."], 3, nil, 0, nil, 80, 1,
                                                                    function()
                            return UF.config.auraFrames.tempEnchants.minSizeToShowDuration
                        end, function(value)
                            UF.config.auraFrames.tempEnchants.minSizeToShowDuration = value
                        end, function()
                            UF:UpdateAuraFrames()
                        end, nil, function()
                            return not UF.config.auraFrames.tempEnchants.showDuration
                        end),
                        count = {
                            type = "group",
                            name = L["Count Text"],
                            order = 4,
                            inline = true,
                            args = {
                                font = R:CreateFontOption(L["Font"], L["The font to use for aura texts."], 1, nil, function()
                                    return UF.config.auraFrames.tempEnchants.countFont
                                end, function(value)
                                    UF.config.auraFrames.tempEnchants.countFont = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                size = R:CreateRangeOption(L["Font Size"], L["The size of aura text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                                    return UF.config.auraFrames.tempEnchants.countFontSize
                                end, function(value)
                                    UF.config.auraFrames.tempEnchants.countFontSize = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of aura text."], 3, nil, R.FONT_OUTLINES, function()
                                    return UF.config.auraFrames.tempEnchants.countFontOutline
                                end, function(value)
                                    UF.config.auraFrames.tempEnchants.countFontOutline = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for aura text."], 4, nil, nil, function()
                                    return UF.config.auraFrames.tempEnchants.countFontShadow
                                end, function(value)
                                    UF.config.auraFrames.tempEnchants.countFontShadow = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end)
                            }
                        },
                        duration = {
                            type = "group",
                            name = L["Duration Text"],
                            order = 5,
                            inline = true,
                            args = {
                                font = R:CreateFontOption(L["Font"], L["The font to use for aura texts."], 1, nil, function()
                                    return UF.config.auraFrames.tempEnchants.durationFont
                                end, function(value)
                                    UF.config.auraFrames.tempEnchants.durationFont = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                size = R:CreateRangeOption(L["Font Size"], L["The size of aura text."], 2, nil, R.FONT_MIN_SIZE, R.FONT_MAX_SIZE, nil, 1, function()
                                    return UF.config.auraFrames.tempEnchants.durationFontSize
                                end, function(value)
                                    UF.config.auraFrames.tempEnchants.durationFontSize = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                outline = R:CreateSelectOption(L["Font Outline"], L["The outline style of aura text."], 3, nil, R.FONT_OUTLINES, function()
                                    return UF.config.auraFrames.tempEnchants.durationFontOutline
                                end, function(value)
                                    UF.config.auraFrames.tempEnchants.durationFontOutline = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end),
                                shadow = R:CreateToggleOption(L["Font Shadows"], L["Whether to show shadow for aura text."], 4, nil, nil, function()
                                    return UF.config.auraFrames.tempEnchants.durationFontShadow
                                end, function(value)
                                    UF.config.auraFrames.tempEnchants.durationFontShadow = value
                                end, function()
                                    UF:UpdateAuraFrames()
                                end)
                            }
                        }
                    }
                }
            }
        },
        player = UF:CreateUnitOptions("player", 11, L["Player"]),
        target = UF:CreateUnitOptions("target", 12, L["Target"]),
        targettarget = UF:CreateUnitOptions("targettarget", 13, L["Target's Target"], nil, nil, function()
            return not UF.config.target.enabled
        end),
        pet = UF:CreateUnitOptions("pet", 14, L["Pet"]),
        focus = UF:CreateUnitOptions("focus", 15, L["Focus"]),
        focustarget = UF:CreateUnitOptions("focustarget", 16, L["Focus's Target"], nil, nil, function()
            return not UF.config.focus.enabled
        end),
        party = UF:CreateUnitOptions("party", 17, L["Party"]),
        raid = UF:CreateUnitOptions("raid", 18, L["Raid"]),
        tank = UF:CreateUnitOptions("tank", 19, L["Tank"]),
        assist = UF:CreateUnitOptions("assist", 19, L["Assist"]),
        boss = UF:CreateUnitOptions("boss", 20, L["Boss"]),
        arena = UF:CreateUnitOptions("arena", 21, L["Arena"]),
        nameplates = {
            type = "group",
            name = L["Nameplates"],
            order = 22,
            args = {
                header = { type = "header", name = R.title .. " > Unit Frames : Nameplates", order = 0 },
                enabled = R:CreateToggleOption(L["Enabled"], nil, 1, "double", nil, function()
                    return UF:UnitConfig("nameplates").enabled
                end, function(value)
                    UF:UnitConfig("nameplates").enabled = value
                end, function()
                    if UF:UnitConfig("nameplates").enabled then
                        UF:SpawnNamePlates()
                    else
                        ReloadUI()
                    end
                end, function()
                    return UF:UnitConfig("nameplates").enabled and L["Disabling nameplates requires a UI reload. Proceed?"]
                end),
                description = { type = "description", name = L["To configure nameplate unit frames, select friendly/enemy player/NPC from the tree on the left."], order = 2 },
                cvarsScale = {
                    type = "group",
                    name = L["Scale"],
                    order = 3,
                    inline = true,
                    disabled = function()
                        return not UF.config.nameplates.enabled
                    end,
                    args = {
                        nameplateMinScale = UF:CreateNamePlateCVarRangeOption("nameplateMinScale", L["Minimum Scale"], L["The minimum scale nameplates should have."], 1, 0.5, 2.0, 0.01),
                        nameplateMinScaleDistance = UF:CreateNamePlateCVarRangeOption("nameplateMinScaleDistance", L["Minimum Scale Distance"],
                                                                                      L["The distance from the max distance that nameplates will reach their minimum scale."], 2, 0, 41, 1),
                        lineBreak1 = { type = "description", name = "", order = 3 },
                        nameplateMaxScale = UF:CreateNamePlateCVarRangeOption("nameplateMaxScale", L["Maximum Scale"],
                                                                              L["The maximum Scale (the higher, the more transparent) nameplates should have."], 4, 0.5, 2.0, 0.01),
                        nameplateMaxScaleDistance = UF:CreateNamePlateCVarRangeOption("nameplateMaxScaleDistance", L["Maximum Scale Distance"],
                                                                                      L["The distance from the max distance that nameplates will reach their maximum scale."], 5, 0, 41, 1),
                        lineBreak2 = { type = "description", name = "", order = 6 },
                        nameplateSelectedScale = UF:CreateNamePlateCVarRangeOption("nameplateSelectedScale", L["Selected Target Scale"], L["The scale of the nameplate of your current target."], 7,
                                                                                   0.5, 2.0, 0.01),
                        lineBreak3 = { type = "description", name = "", order = 8 },
                        nameplateLargerScale = UF:CreateNamePlateCVarRangeOption("nameplateLargerScale", L["Important Enemy Scale"], L["The scale of the nameplates of important targets."], 9, 0.5,
                                                                                 2.0, 0.01)
                    }
                },
                cvarsTransparency = {
                    type = "group",
                    name = L["Transparency"],
                    order = 4,
                    inline = true,
                    disabled = function()
                        return not UF.config.nameplates.enabled
                    end,
                    args = {
                        nameplateMinAlpha = UF:CreateNamePlateCVarRangeOption("nameplateMinAlpha", L["Minimum Alpha"], L["The minimum alpha (the lower, the more transparent) nameplates should have."],
                                                                              1, 0.1, 1.0, 0.01),
                        nameplateMinAlphaDistance = UF:CreateNamePlateCVarRangeOption("nameplateMinAlphaDistance", L["Minimum Alpha Distance"],
                                                                                      L["The distance from the max distance that nameplates will reach their minimum alpha (most transparent)."], 2, 0,
                                                                                      41, 1),
                        lineBreak1 = { type = "description", name = "", order = 3 },
                        nameplateMaxAlpha = UF:CreateNamePlateCVarRangeOption("nameplateMaxAlpha", L["Maximum Alpha"],
                                                                              L["The maximum alpha (the higher, the more transparent) nameplates should have."], 4, 0.1, 1.0, 0.01),
                        nameplateMaxAlphaDistance = UF:CreateNamePlateCVarRangeOption("nameplateMaxAlphaDistance", L["Maximum Alpha Distance"],
                                                                                      L["The distance from the max distance that nameplates will reach their maximum alpha (least transparent)."], 5, 0,
                                                                                      41, 1),
                        lineBreak2 = { type = "description", name = "", order = 6 },
                        nameplateSelectedAlpha = UF:CreateNamePlateCVarRangeOption("nameplateSelectedAlpha", L["Selected Target Alpha"],
                                                                                   L["The alpha (the higher, the more transparent) of the nameplate of your current target."], 7, 0.1, 1.0, 0.01)
                    }
                },
                friendlyPlayer = UF:CreateUnitOptions("friendlyPlayer", 5, L["Friendly Player Nameplates"], nil, true, function()
                    return not UF.config.nameplates.enabled
                end),
                enemyPlayer = UF:CreateUnitOptions("enemyPlayer", 6, L["Enemy Player Nameplates"], nil, true, function()
                    return not UF.config.nameplates.enabled
                end),
                friendlyNpc = UF:CreateUnitOptions("friendlyNpc", 7, L["Friendly NPC Nameplates"], nil, true, function()
                    return not UF.config.nameplates.enabled
                end),
                enemyNpc = UF:CreateUnitOptions("enemyNpc", 8, L["Enemy NPC Nameplates"], nil, true, function()
                    return not UF.config.nameplates.enabled
                end)
            }
        }
    }
})
