local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local CS = R.Modules.CharacterStats

function AB:CreateMageBar()
    local config = AB.config.mageBar

    local polymorphs = {}
    for i, id in next, AB.database.Mage.PolymorphSheep do
        table.insert(polymorphs, id)
    end
    table.insert(polymorphs, AB.database.Mage.PolymorphPig[1])
    table.insert(polymorphs, AB.database.Mage.PolymorphTurtle[1])

    local armor = {}
    for i, id in next, AB.database.Mage.FrostArmor do
        table.insert(armor, id)
    end
    for i, id in next, AB.database.Mage.IceArmor do
        table.insert(armor, id)
    end
    for i, id in next, AB.database.Mage.MageArmor do
        table.insert(armor, id)
    end

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "_MageBar", UIParent)
    frame:Point(unpack(config.point))
    frame:SetSize(7 * config.buttonSize + 6 * config.buttonSpacing, config.buttonSize)
    frame.config = config
    frame.buttonSize = config.buttonSize
    frame.buttonSpacing = config.buttonSpacing
    frame.buttons = {}
    frame.buttons[1] = AB:CreateSpellFlyout("Teleports", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = AB.database.Mage.Teleports[CS.faction],
        defaultActionIndex = 1,
        showOnlyMaxRank = false
    })
    frame.buttons[2] = AB:CreateSpellFlyout("Portals", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = AB.database.Mage.Portals[CS.faction],
        defaultActionIndex = 1,
        showOnlyMaxRank = false
    })
    frame.buttons[3] = AB:CreateSpellFlyout("Water", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = AB.database.Mage.ConjureWater,
        defaultActionIndex = #AB.database.Mage.ConjureWater,
        showOnlyMaxRank = false
    })
    frame.buttons[4] = AB:CreateSpellFlyout("Food", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = AB.database.Mage.ConjureFood,
        defaultActionIndex = #AB.database.Mage.ConjureFood,
        showOnlyMaxRank = false
    })
    frame.buttons[5] = AB:CreateSpellFlyout("Gems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = AB.database.Mage.ConjureGem,
        defaultActionIndex = #AB.database.Mage.ConjureGem,
        showOnlyMaxRank = false
    })
    frame.buttons[6] = AB:CreateSpellFlyout("Polymorph", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = polymorphs,
        defaultActionIndex = #polymorphs,
        showOnlyMaxRank = true
    })
    frame.buttons[7] = AB:CreateSpellFlyout("Armor", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = armor,
        defaultActionIndex = 1,
        showOnlyMaxRank = true
    })

    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
    frame:HookScript("OnEvent", function()
        AB:UpdateClassBar(frame)
    end)

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    frame:CreateFader(config.fader)

    R:CreateDragFrame(frame, "Mage Bar")

    return frame
end

function AB:CreateShamanBar()
    local config = AB.config.shamanBar

    local fire = {}
    for i, totem in next, AB.database.Shaman.FireTotems do
        for j, id in next, totem do
            table.insert(fire, id)
        end
    end
    local earth = {}
    for i, totem in next, AB.database.Shaman.EarthTotems do
        for j, id in next, totem do
            table.insert(earth, id)
        end
    end
    local water = {}
    for i, totem in next, AB.database.Shaman.WaterTotems do
        for j, id in next, totem do
            table.insert(water, id)
        end
    end
    local air = {}
    for i, totem in next, AB.database.Shaman.AirTotems do
        for j, id in next, totem do
            table.insert(air, id)
        end
    end
    local enchants = {}
    for i, totem in next, AB.database.Shaman.WeaponEnchants do
        for j, id in next, totem do
            table.insert(enchants, id)
        end
    end

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "_ShamanBar", UIParent)
    frame:Point(unpack(config.point))
    frame:SetSize(5 * config.buttonSize + 4 * config.buttonSpacing, config.buttonSize)
    frame.config = config
    frame.buttonSize = config.buttonSize
    frame.buttonSpacing = config.buttonSpacing
    frame.buttons = {}
    frame.buttons[1] = AB:CreateSpellFlyout("FireTotems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = fire,
        defaultActionIndex = 1,
        showOnlyMaxRank = true
    })
    frame.buttons[2] = AB:CreateSpellFlyout("EarthTotems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = earth,
        defaultActionIndex = 1,
        showOnlyMaxRank = true
    })
    frame.buttons[3] = AB:CreateSpellFlyout("WaterTotems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = water,
        defaultActionIndex = 1,
        showOnlyMaxRank = true
    })
    frame.buttons[4] = AB:CreateSpellFlyout("AirTotems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = air,
        defaultActionIndex = 1,
        showOnlyMaxRank = true
    })
    frame.buttons[5] = AB:CreateSpellFlyout("WeaponEnchants", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = enchants,
        defaultActionIndex = 1,
        showOnlyMaxRank = true
    })

    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
    frame:RegisterEvent("PLAYER_TOTEM_UPDATE")
    frame:HookScript("OnEvent", function()
        for index = 1, MAX_TOTEMS do
            local button = frame.buttons[index]

            local haveTotem, totemName, start, duration, icon = GetTotemInfo(index)
            if (haveTotem and duration > 0) then
                button.CurrentAction.Duration:SetCooldown(start, duration)
                local totemId = AB:FindTotem(totemName)
                if totemId then
                    local actionButton = button.childButtons[totemId]
                    if actionButton then
                        button.defaultAction = totemId
                    end
                end
            end
        end

        AB:UpdateClassBar(frame)
    end)

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    frame:CreateFader(config.fader)

    R:CreateDragFrame(frame, "Shaman Bar")

    return frame
end

function AB:UpdateClassBars()   
    if AB.bars.MageBar then
        AB:UpdateClassBarPosition(AB.bars.MageBar, AB.config.mageBar.dock)
    elseif AB.bars.ShamanBar then
        AB:UpdateClassBarPosition(AB.bars.ShamanBar, AB.config.shamanBar.dock)
    end
end

function AB:UpdateClassBarPosition(bar, dock)
    if dock == AB.CLASS_BAR_DOCKS.MainActionBar_Left then
        if AB.config.multiBarBottomLeft.enabled and not AB.config.multiBarBottomLeft.detached then
            bar:ClearAllPoints()
            if AB.config.multiBarBottomRight.enabled and not AB.config.multiBarBottomRight.detached and
                AB.config.multiBarBottomRight.attachedPoint == AB.ATTACHMENT_POINTS.Center then
                bar:SetPoint("BOTTOMLEFT", AB.bars.MultiBarBottomRight, "TOPLEFT", 18, 8)
            else
                bar:SetPoint("BOTTOMLEFT", AB.bars.MultiBarBottomLeft, "TOPLEFT", 18, 8)
            end
        else
            bar:ClearAllPoints()
            bar:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 18, 6)
        end
    else
        bar:ClearAllPoints()
        bar:Point(unpack(bar.config.point))
    end
end

function AB:UpdateClassBar(bar)
    local visibleIndex = 0
    local lastVisibleButton
    local buttonList = {}
    for i, button in next, bar.buttons do
        AB:UpdateSpellFlyout(button)

        if button:IsVisible() then
            visibleIndex = visibleIndex + 1

            button:ClearAllPoints()
            if visibleIndex == 1 then
                button:SetPoint("BOTTOMLEFT", 0, 0)
            else
                button:SetPoint("BOTTOMLEFT", lastVisibleButton, "BOTTOMRIGHT", bar.buttonSpacing, 0)
            end

            lastVisibleButton = button

            if bar.faderConfig then
                table.insert(buttonList, button.CurrentAction)

                for j, child in next, button.childButtons do
                    table.insert(buttonList, child)
                end
            end
        end
    end

    bar:CreateFader(bar.faderConfig, buttonList)
end

AB.database = {
    Mage = {
        Portals = {
            Alliance = {
                10059, -- Stormwind
                11416, -- Ironforge
                11419 -- Darnassus
            },
            Horde = {
                11417, -- Orgrimmar
                11418, -- Undercity
                11420 -- Thunder Bluff
            }
        },
        Teleports = {
            Alliance = {
                3561, -- Stormwind
                3562, -- Ironforge
                3565 -- Darnassus
            },
            Horde = {
                3567, -- Orgrimmar
                3563, -- Undercity
                3566 -- Thunder Bluff
            }
        },
        ConjureFood = {587, 597, 990, 6129, 10144, 10145, 28612},
        ConjureWater = {5504, 5505, 5506, 6127, 10138, 10139, 10140},
        ConjureGem = {759, 3552, 10053, 10054},
        PolymorphSheep = {118, 12824, 12825, 12826},
        PolymorphPig = {28272},
        PolymorphTurtle = {28271},
        FrostArmor = {168, 7300, 7301},
        IceArmor = {7302, 7320, 10219, 10220},
        MageArmor = {6117, 22782, 22783}
    },
    Shaman = {
        FireTotems = {
            ["Fire Nova Totem"] = {1535, 8498, 8499, 11314, 11315},
            ["Magma Totem"] = {8190, 10585, 10586, 10587},
            ["Searing Totem"] = {3599, 6363, 6364, 6365, 10437, 10438},
            ["Flametongue Totem"] = {8227, 8249, 10526, 16387},
            ["Frost Resistance Totem"] = {8181, 10478, 10479}
        },

        EarthTotems = {
            ["Earthbind Totem"] = {2484},
            ["Stoneclaw Totem"] = {5730, 6390, 6391, 6392, 10427, 10428},
            ["Stoneskin Totem"] = {8071, 8154, 8155, 10406, 10407, 10408},
            ["Strength of Earth Totem"] = {8075, 8160, 8161, 10442, 25361},
            ["Tremor Totem"] = {8143}
        },

        WaterTotems = {
            ["Poison Cleansing Totem"] = {8166},
            ["Disease Cleansing Totem"] = {8170},
            ["Fire Resistance Totem"] = {8184, 10537, 10538},
            ["Healing Stream Totem"] = {5394, 6375, 6377, 10462, 10463},
            ["Mana Spring Totem"] = {5675, 10495, 10496, 10497},
            ["Mana Tide Totem"] = {16190, 17354, 17359}
        },

        AirTotems = {
            ["Grace of Air Totem"] = {8835, 10627, 25359},
            ["Grounding Totem"] = {8177},
            ["Nature Resistance Totem"] = {10595, 10600, 10601},
            ["Sentry Totem"] = {6495},
            ["Tranquil Air Totem"] = {25908},
            ["Windfury Totem"] = {8512, 10613, 10614},
            ["Windwall Totem"] = {15107, 15111, 15112}
        },

        WeaponEnchants = {
            ["Rockbiter Weapon"] = {8017, 8018, 8019, 10399, 16314, 16315, 16316},
            ["Flametongue Weapon"] = {8024, 8027, 8030, 16339, 16341, 16342},
            ["Frostbrand Weapon"] = {8033, 8038, 10456, 16355, 16356},
            ["Windfury Weapon"] = {8232, 8235, 10486, 16362}
        }
    }
}

local spellRankTables = {AB.database.Mage.ConjureFood, AB.database.Mage.ConjureWater, AB.database.Mage.ConjureGem, AB.database.Mage.PolymorphSheep, AB.database.Mage.MageArmor}

local frostAndIceArmor = {}
for i, id in next, AB.database.Mage.FrostArmor do
    table.insert(frostAndIceArmor, id)
end
for i, id in next, AB.database.Mage.IceArmor do
    table.insert(frostAndIceArmor, id)
end
table.insert(spellRankTables, frostAndIceArmor)

for i, totem in next, AB.database.Shaman.FireTotems do
    table.insert(spellRankTables, totem)
end
for i, totem in next, AB.database.Shaman.EarthTotems do
    table.insert(spellRankTables, totem)
end
for i, totem in next, AB.database.Shaman.WaterTotems do
    table.insert(spellRankTables, totem)
end
for i, totem in next, AB.database.Shaman.AirTotems do
    table.insert(spellRankTables, totem)
end
for i, totem in next, AB.database.Shaman.WeaponEnchants do
    table.insert(spellRankTables, totem)
end

function AB:GetMaxKnownRank(spellId)
    if not spellId then
        return
    end

    local maxKnownRank
    for i, rankTable in next, spellRankTables do
        local matchedSpell
        for j, id in next, rankTable do
            if id == spellId then
                maxKnownRank = id
                matchedSpell = true
            elseif matchedSpell and IsSpellKnown(id) then
                maxKnownRank = id
            end
        end

        if matchedSpell then
            break
        end
    end

    return maxKnownRank
end

function AB:IsMaxKnownRank(spellId)
    if not spellId then
        return false
    end

    return AB:GetMaxKnownRank(spellId) == spellId
end

function AB:FindTotem(totemName)
    local totem = AB.database.Shaman.FireTotems[totemName] or AB.database.Shaman.EarthTotems[totemName] or AB.database.Shaman.WaterTotems[totemName] or
                      AB.database.Shaman.AirTotems[totemName]

    local totemId
    if totem then
        for index, id in next, totem do
            if IsSpellKnown(id) then
                totemId = id
            end
        end
    end

    return totemId
end