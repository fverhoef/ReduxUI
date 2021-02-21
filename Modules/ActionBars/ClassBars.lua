local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local CS = R.Modules.CharacterStats
local SD = R.Modules.SpellDatabase

function AB:CreateMageBar()
    local config = AB.config.mageBar

    local teleports = {}
    local portals = {}
    local water = {}
    local food = {}
    local gems = {}
    local polymorphs = {}
    local armors = {}

    for i, spell in next, SD.Spells["MAGE"] do
        for j, rank in next, spell.ranks do
            if spell.tag == SD.Tags.Teleport then
                table.insert(teleports, rank.id)
            elseif spell.tag == SD.Tags.Portal then
                table.insert(portals, rank.id)
            elseif spell.tag == SD.Tags.Water then
                table.insert(water, rank.id)
            elseif spell.tag == SD.Tags.Food then
                table.insert(food, rank.id)
            elseif spell.tag == SD.Tags.Gem then
                table.insert(gems, rank.id)
            elseif spell.tag == SD.Tags.Polymorph then
                table.insert(polymorphs, rank.id)
            elseif spell.tag == SD.Tags.Armor then
                table.insert(armors, rank.id)
            end
        end
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
        actions = teleports,
        defaultActionIndex = 1,
        showOnlyMaxRank = false
    })
    frame.buttons[2] = AB:CreateSpellFlyout("Portals", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = portals,
        defaultActionIndex = 1,
        showOnlyMaxRank = false
    })
    frame.buttons[3] = AB:CreateSpellFlyout("Water", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = water,
        defaultActionIndex = #water,
        showOnlyMaxRank = false
    })
    frame.buttons[4] = AB:CreateSpellFlyout("Food", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = food,
        defaultActionIndex = #food,
        showOnlyMaxRank = false
    })
    frame.buttons[5] = AB:CreateSpellFlyout("Gems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = gems,
        defaultActionIndex = #gems,
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
        actions = armors,
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

    frame:CreateFader(config.fader, frame.buttons)
    R:CreateDragFrame(frame, "Mage Bar")

    return frame
end

function AB:CreateShamanBar()
    local config = AB.config.shamanBar

    local fire = {}
    local earth = {}
    local water = {}
    local air = {}
    local enchants = {}

    for i, spell in next, SD.Spells["SHAMAN"] do
        for j, rank in next, spell.ranks do
            if spell.tag == SD.Tags.Totem and spell.element == SD.TotemElements.Fire then
                table.insert(fire, rank.id)
            elseif spell.tag == SD.Tags.Totem and spell.element == SD.TotemElements.Earth then
                table.insert(earth, rank.id)
            elseif spell.tag == SD.Tags.Totem and spell.element == SD.TotemElements.Water then
                table.insert(water, rank.id)
            elseif spell.tag == SD.Tags.Totem and spell.element == SD.TotemElements.Air then
                table.insert(air, rank.id)
            elseif spell.tag == SD.Tags.Enchant then
                table.insert(enchants, rank.id)
            end
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
                local totemId = SD:FindTotem(totemName)
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

    frame:CreateFader(config.fader, frame.buttons)
    R:CreateDragFrame(frame, "Shaman Bar")

    return frame
end

function AB:UpdateClassBars()
    if AB.bars.MageBar then
        AB:UpdateClassBar(AB.bars.MageBar)
    end
    if AB.bars.ShamanBar then
        AB:UpdateClassBar(AB.bars.ShamanBar)
    end
end

function AB:UpdateClassBar(bar)
    if bar.config.enabled then
        local visibleIndex = 0
        local lastVisibleButton
        local buttonList = {}
        for i, button in next, bar.buttons do
            button.config.size = bar.config.buttonSize
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
        if not bar.detached then
            bar:LinkFader(AB.bars.MainMenuBar)
        else
            bar:UnlinkFader(AB.bars.MainMenuBar)
        end
        bar:SetShown(bar.detached or not AB.bars.MainMenuBar.faded)

        bar:ClearAllPoints()
        if not bar.detached and bar.config.attachedPoint == AB.CLASS_BAR_DOCKS.Left then
            local leftEnabledAndAttached = AB.config.multiBarBottomLeft.enabled and not AB.config.multiBarBottomLeft.detached
            local rightEnabledAndAttached = AB.config.multiBarBottomRight.enabled and not AB.config.multiBarBottomRight.detached
            local rightAttachedToCenter = AB.config.multiBarBottomRight.attachedPoint == AB.ATTACHMENT_POINTS.Center

            if rightEnabledAndAttached and rightAttachedToCenter then
                bar:SetPoint("BOTTOMLEFT", AB.bars.MultiBarBottomRight, "TOPLEFT", 18, 4)
            elseif leftEnabledAndAttached then
                bar:SetPoint("BOTTOMLEFT", AB.bars.MultiBarBottomLeft, "TOPLEFT", 18, 4)
            else
                bar:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 18, 8)
            end
        else
            bar:Point(unpack(bar.config.point))
        end

    else
        bar:UnlinkFader(AB.bars.MainMenuBar)
        bar:Hide()
    end
end
