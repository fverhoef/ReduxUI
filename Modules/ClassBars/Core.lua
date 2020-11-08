local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local CB = Addon.Modules.ClassBars

local SPELLFLYOUT_DEFAULT_SPACING = 0
local SPELLFLYOUT_INITIAL_SPACING = 0
local SPELLFLYOUT_FINAL_SPACING = 4

function CB:OnEnable()
    local mageMasqueGroup
    if LibStub("Masque", true) then
        mageMasqueGroup = LibStub("Masque", true):Group(Addon.title, "Mage Bar", true)
    end

    local shamanMasqueGroup
    if LibStub("Masque", true) then
        shamanMasqueGroup = LibStub("Masque", true):Group(Addon.title, "Shaman Bar", true)
    end

    if Addon.PlayerClass == "MAGE" then
        CB.MageBar = CB:CreateMageBar(mageMasqueGroup)

        CB:RegisterEvent("PLAYER_ENTERING_WORLD", CB.OnUpdate)
        CB:SecureHook("MultiActionBar_Update", CB.OnUpdate)
        CB:SecureHook("MainMenuBar_UpdateExperienceBars", CB.OnUpdate)

        CB:OnUpdate()
    elseif Addon.PlayerClass == "SHAMAN" then
        CB.ShamanBar = CB:CreateShamanBar(shamanMasqueGroup)

        CB:RegisterEvent("PLAYER_ENTERING_WORLD", CB.OnUpdate)
        CB:SecureHook("MultiActionBar_Update", CB.OnUpdate)
        CB:SecureHook("MainMenuBar_UpdateExperienceBars", CB.OnUpdate)

        CB:OnUpdate()
    end
end

function CB:OnUpdate()
    if CB.MageBar then
        CB:DockClassBar(CB.MageBar, CB.config.db.profile.mageBar.dock)
    elseif CB.ShamanBar then
        CB:DockClassBar(CB.ShamanBar, CB.config.db.profile.shamanBar.dock)
    end
end

function CB:CreateMageBar(masqueGroup)
    local config = CB.config.db.profile.mageBar

    local polymorphs = {}
    for i, id in next, CB.database.Mage.PolymorphSheep do
        table.insert(polymorphs, id)
    end
    table.insert(polymorphs, CB.database.Mage.PolymorphPig[1])
    table.insert(polymorphs, CB.database.Mage.PolymorphTurtle[1])

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "_MageBar", UIParent)
    frame.buttonSize = config.buttonSize
    frame.buttonSpacing = config.buttonSpacing
    frame:SetSize(6 * config.buttonSize + 5 * config.buttonSpacing, config.buttonSize)
    frame.buttons = {}
    frame.buttons[1] = CB:CreateSpellFlyout("Teleports", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = CB.database.Mage.Teleports[Addon.PlayerFaction],
        defaultActionIndex = 1,
        showOnlyMaxRank = false,
        masqueGroup = masqueGroup
    })
    frame.buttons[2] = CB:CreateSpellFlyout("Portals", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = CB.database.Mage.Portals[Addon.PlayerFaction],
        defaultActionIndex = 1,
        showOnlyMaxRank = false,
        masqueGroup = masqueGroup
    })
    frame.buttons[3] = CB:CreateSpellFlyout("Water", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = CB.database.Mage.ConjureWater,
        defaultActionIndex = #CB.database.Mage.ConjureWater,
        showOnlyMaxRank = false,
        masqueGroup = masqueGroup
    })
    frame.buttons[4] = CB:CreateSpellFlyout("Food", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = CB.database.Mage.ConjureFood,
        defaultActionIndex = #CB.database.Mage.ConjureFood,
        showOnlyMaxRank = false,
        masqueGroup = masqueGroup
    })
    frame.buttons[5] = CB:CreateSpellFlyout("Gems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = CB.database.Mage.ConjureGem,
        defaultActionIndex = #CB.database.Mage.ConjureGem,
        showOnlyMaxRank = false,
        masqueGroup = masqueGroup
    })
    frame.buttons[6] = CB:CreateSpellFlyout("Polymorph", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = polymorphs,
        defaultActionIndex = #polymorphs,
        showOnlyMaxRank = true,
        masqueGroup = masqueGroup
    })

    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
    frame:HookScript("OnEvent", function()
        CB:UpdateClassBar(frame)
    end)

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    if config.fader then
        Addon:CreateFrameFader(frame, config.fader)
    end

    -- TODO: drag frame

    return frame
end

function CB:CreateShamanBar(masqueGroup)
    local config = CB.config.db.profile.shamanBar

    local fire = {}
    for i, totem in next, CB.database.Shaman.FireTotems do
        for j, id in next, totem do
            table.insert(fire, id)
        end
    end
    local earth = {}
    for i, totem in next, CB.database.Shaman.EarthTotems do
        for j, id in next, totem do
            table.insert(earth, id)
        end
    end
    local water = {}
    for i, totem in next, CB.database.Shaman.WaterTotems do
        for j, id in next, totem do
            table.insert(water, id)
        end
    end
    local air = {}
    for i, totem in next, CB.database.Shaman.AirTotems do
        for j, id in next, totem do
            table.insert(air, id)
        end
    end
    local enchants = {}
    for i, totem in next, CB.database.Shaman.WeaponEnchants do
        for j, id in next, totem do
            table.insert(enchants, id)
        end
    end

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "_ShamanBar", UIParent)
    frame.buttonSize = config.buttonSize
    frame.buttonSpacing = config.buttonSpacing
    frame:SetSize(5 * config.buttonSize + 4 * config.buttonSpacing, config.buttonSize)
    frame.buttons = {}
    frame.buttons[1] = CB:CreateSpellFlyout("FireTotems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = fire,
        defaultActionIndex = 1,
        showOnlyMaxRank = true,
        masqueGroup = masqueGroup
    })
    frame.buttons[2] = CB:CreateSpellFlyout("EarthTotems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = earth,
        defaultActionIndex = 1,
        showOnlyMaxRank = true,
        masqueGroup = masqueGroup
    })
    frame.buttons[3] = CB:CreateSpellFlyout("WaterTotems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = water,
        defaultActionIndex = 1,
        showOnlyMaxRank = true,
        masqueGroup = masqueGroup
    })
    frame.buttons[4] = CB:CreateSpellFlyout("AirTotems", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = air,
        defaultActionIndex = 1,
        showOnlyMaxRank = true,
        masqueGroup = masqueGroup
    })
    frame.buttons[5] = CB:CreateSpellFlyout("WeaponEnchants", frame, {
        size = config.buttonSize,
        direction = "UP",
        actions = enchants,
        defaultActionIndex = 1,
        showOnlyMaxRank = true,
        masqueGroup = masqueGroup
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
                local totemId = CB:FindTotem(totemName)
                if totemId then
                    local actionButton = button.childButtons[totemId]
                    if actionButton then
                        button.defaultAction = totemId
                    end
                end
            end
        end

        CB:UpdateClassBar(frame)
    end)

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    if config.fader then
        Addon:CreateFrameFader(frame, config.fader)
    end

    -- TODO: drag frame

    return frame
end

function CB:DockClassBar(bar, dock)
    if dock == CB.dockLocations.MainActionBar_Left then
        if SHOW_MULTI_ACTIONBAR_1 and (not CB.SHOW_MULTI_ACTIONBAR_1) then
            bar:ClearAllPoints()
            bar:SetPoint("BOTTOMLEFT", _G["MultiBarBottomLeftButton1"], "TOPLEFT", 18, 6)
            CB.SHOW_MULTI_ACTIONBAR_1 = SHOW_MULTI_ACTIONBAR_1
        elseif (not SHOW_MULTI_ACTIONBAR_1) and (CB.SHOW_MULTI_ACTIONBAR_1 or CB.SHOW_MULTI_ACTIONBAR_1 == nil) then
            bar:ClearAllPoints()
            bar:SetPoint("BOTTOMLEFT", _G["ActionButton1"], "TOPLEFT", 18, 12)
            CB.SHOW_MULTI_ACTIONBAR_1 = SHOW_MULTI_ACTIONBAR_1
        end
    end
end

function CB:UpdateClassBar(bar)
    local visibleIndex = 0
    local lastVisibleButton
    local buttonList = {}
    for i, button in next, bar.buttons do
        CB:UpdateSpellFlyout(button)

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

    if bar.faderConfig then
        Addon:CreateButtonFrameFader(bar, buttonList, bar.faderConfig)
    end
end

function CB:CreateSpellFlyout(name, parent, config)
    local defaultAction = config.actions[config.defaultActionIndex or 1]

    -- create parent frame
    local button = CreateFrame("Frame", "FlyoutButton_" .. name, parent, "SecureHandlerStateTemplate")
    button.tag = name
    button.config = config
    button.actions = config.actions
    button.defaultAction = defaultAction
    button.showOnlyMaxRank = config.showOnlyMaxRank or false
    button.size = config.size
    button.childSize = button.size - 8
    button.direction = config.direction
    button.childButtons = {}
    button:EnableMouse(true)
    button:SetSize(button.size, button.size)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(1)

    -- Create secure open/close functions (needed for combat execution)
    button:Execute([[open = [=[
            local popups = newtable(self:GetChildren())
            for i, button in ipairs(popups) do
                local index = button:GetAttribute("index")
                if index == 0 then
                    button:SetAttribute("open", 1)
                else
                    button:Show()
                end
            end
        ]=] ]])
    button:Execute([[close = [=[
            local popups = newtable(self:GetChildren())
            for i, button in pairs(popups) do
                local index = button:GetAttribute("index")
                if index == 0 then
                    button:SetAttribute("open", 0)
                else
                    button:Hide()
                end			
            end
        ]=] ]])

    -- Create a button for the current/default action
    button.CurrentAction = CreateFrame("CheckButton", button:GetName() .. "_CurrentAction", button,
                                       "SecureHandlerStateTemplate, SecureHandlerEnterLeaveTemplate, SecureActionButtonTemplate, ActionButtonTemplate")
    button.CurrentAction:EnableMouse(true)
    button.CurrentAction:SetPoint("BOTTOM", button, "BOTTOM", 0, 0)
    button.CurrentAction:SetSize(button.size, button.size)
    button.CurrentAction:SetFrameLevel(10)
    button.CurrentAction:SetAttribute("index", 0)
    button.CurrentAction:SetAttribute("type", "spell")
    button.CurrentAction:RegisterForClicks("AnyUp")
    button.CurrentAction:Show()

    if config.masqueGroup then
        config.masqueGroup:AddButton(button.CurrentAction)
    else
        button.CurrentAction:SetNormalTexture(nil)
    end

    SecureHandlerWrapScript(button.CurrentAction, "OnEnter", button, [[
            control:Run(open)
        ]]);
    SecureHandlerWrapScript(button.CurrentAction, "OnLeave", button, [[return true, ""]], [[
            inHeader =  control:IsUnderMouse(true)
            if not inHeader then
                control:Run(close)
            end	    
        ]])

    button.CurrentAction:HookScript("OnEnter", function()
        GameTooltip:SetOwner(button.CurrentAction, "ANCHOR_LEFT")
        GameTooltip:SetSpellByID(button.CurrentAction.spellID, false, true)
        CB:UpdateSpellFlyoutBackground(button)
    end)
    button.CurrentAction:HookScript("OnLeave", function()
        GameTooltip:Hide()
        CB:UpdateSpellFlyoutBackground(button)
    end)
    button.CurrentAction:HookScript("OnClick", function()
        button.CurrentAction:SetChecked(false)
    end)

    Addon:FixNormalTextureSize(button.CurrentAction)
    if Addon.Modules.Buttons then
        Addon.Modules.Buttons:StyleActionButton(button.CurrentAction)
    end

    button.childButtons[0] = button.CurrentAction

    -- Add a duration spiral
    button.CurrentAction.Duration = CreateFrame("Cooldown", nil, button.CurrentAction, "CooldownFrameTemplate")
    button.CurrentAction.Duration:SetHideCountdownNumbers(true)
    button.CurrentAction.Duration:SetAllPoints()

    -- Create flyout border and arrow
    button.FlyoutArrow = button:CreateTexture(nil, "OVERLAY", "ActionBarFlyoutButton-ArrowUp")
    button.FlyoutArrow:SetParent(button.CurrentAction)
    button.FlyoutArrow:SetPoint("CENTER", button.CurrentAction, "CENTER")

    -- create background for child buttons
    button.FlyoutBackground = CreateFrame("Frame", "FlyoutButton_" .. name .. "_Background", button)
    button.FlyoutBackground:EnableMouse(true)

    button.FlyoutBackground.End = button.FlyoutBackground:CreateTexture(nil, "BACKGROUND")
    button.FlyoutBackground.End:SetTexture([[Interface\Buttons\ActionBarFlyoutButton]])
    button.FlyoutBackground.End:SetTexCoord(0.01562500, 0.59375000, 0.74218750, 0.91406250)
    button.FlyoutBackground.End:SetVertexColor(0.5, 0.5, 0.5, 1)
    button.FlyoutBackground.End:SetSize(button.size, 22)
    button.FlyoutBackground.End:Hide()

    button.FlyoutBackground.Vertical = button.FlyoutBackground:CreateTexture(nil, "BACKGROUND")
    button.FlyoutBackground.Vertical:SetTexture([[Interface\Buttons\ActionBarFlyoutButton-FlyoutMid]])
    button.FlyoutBackground.Vertical:SetTexCoord(0, 0.578125, 0, 1)
    button.FlyoutBackground.Vertical:SetVertexColor(0.5, 0.5, 0.5, 1)
    button.FlyoutBackground.Vertical:SetSize(button.size, button.size)
    button.FlyoutBackground.Vertical:Hide()

    button.FlyoutBackground.Horizontal = button.FlyoutBackground:CreateTexture(nil, "BACKGROUND")
    button.FlyoutBackground.Horizontal:SetTexture([[Interface\Buttons\ActionBarFlyoutButton-FlyoutMidLeft]])
    button.FlyoutBackground.Horizontal:SetTexCoord(0, 1, 0, 0.578125)
    button.FlyoutBackground.Horizontal:SetVertexColor(0.5, 0.5, 0.5, 1)
    button.FlyoutBackground.Horizontal:SetSize(button.size, button.size)
    button.FlyoutBackground.Horizontal:Hide()

    CB:UpdateSpellFlyout(button)

    -- TODO: check if any additional events need to be listened to here
    button:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
    button:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
    button:RegisterEvent("PLAYER_ENTERING_WORLD")
    button:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
    button:RegisterEvent("UNIT_POWER_FREQUENT")
    button:RegisterEvent("LOSS_OF_CONTROL_ADDED")
    button:RegisterEvent("LOSS_OF_CONTROL_UPDATE")
    button:RegisterEvent("SPELL_UPDATE_CHARGES")
    button:RegisterEvent("SPELL_UPDATE_ICON")
    button:RegisterEvent("BAG_UPDATE")
    button:RegisterEvent("UNIT_INVENTORY_CHANGED")

    button:SetScript("OnEvent", function(self, event)
        CB:UpdateSpellFlyout(button)
        for i, child in next, button.childButtons do
            CB:UpdateSpellFlyoutChild(button, child)
        end
    end)

    if TODO then
        local onUpdateElapsed, onUpdateWait = 0, 0.25
        button:SetScript("OnUpdate", function(self, elapsed)
            if onUpdateElapsed > onUpdateWait then
                CB:UpdateSpellFlyout(button)
                for i, child in next, button.childButtons do
                    CB:UpdateSpellFlyoutChild(button, child)
                end

                onUpdateElapsed = 0
            else
                onUpdateElapsed = onUpdateElapsed + elapsed
            end
        end)
    end

    return button
end

function CB:UpdateSpellFlyout(button)
    local actions = button.actions
    local defaultAction = button.defaultAction

    button.isOpen = button.CurrentAction:GetAttribute("open") == 1

    if not InCombatLockdown() then
        button.count = 0

        -- generate buttons
        local previousButton
        for i, action in next, actions do
            local actionButton = button.childButtons[action]

            -- generate a new button if known and not generated yet
            local isKnown = IsSpellKnown(action)
            if isKnown then
                local shouldBeVisible = not button.showOnlyMaxRank or (button.showOnlyMaxRank and CB:IsMaxKnownRank(action))
                if not actionButton and shouldBeVisible then
                    actionButton = CB:CreateSpellFlyoutChild(button, action, i, previousButton)
                    button.childButtons[action] = actionButton
                elseif actionButton and not shouldBeVisible then
                    actionButton:Hide()
                    actionButton = nil
                    button.childButtons[action] = nil
                end
            end

            if actionButton then
                button.count = button.count + 1
                previousButton = actionButton
            end
        end

        -- if the default is not max rank, set it to max rank
        if button.showOnlyMaxRank then
            local maxRank = CB:GetMaxKnownRank(defaultAction)
            if maxRank then
                defaultAction = maxRank
            end
        end

        -- if the default is an unknown spell, try to find one that we do know
        if not IsSpellKnown(defaultAction) then
            for i, action in next, button.actions do
                if IsSpellKnown(action) then
                    defaultAction = action
                end
            end
        end

        -- set current action
        if IsSpellKnown(defaultAction) then
            local spellName, _, icon = GetSpellInfo(defaultAction)
            button.CurrentAction.icon:SetTexture(icon)
            button.CurrentAction.icon:Show()
            button.CurrentAction:SetAttribute("spell", spellName)
            button.CurrentAction.spellID = defaultAction
        end

        button.defaultAction = defaultAction
    end

    CB:UpdateSpellFlyoutBackground(button)
    if Addon.Modules.Buttons then
        Addon.Modules.Buttons:StyleActionButton(button.CurrentAction)
    end

    if button.count > 0 then
        button:Show()
    else
        button:Hide()
    end
end

function CB:UpdateSpellFlyoutBackground(button)
    button.isOpen = button.CurrentAction:GetAttribute("open") == 1

    local arrowDistance = button.isOpen and 5 or 2
    button.FlyoutArrow:Show()
    button.FlyoutArrow:ClearAllPoints()
    if button.direction == "LEFT" then
        button.FlyoutArrow:SetPoint("LEFT", button.CurrentAction, "LEFT", -arrowDistance, 0)
        SetClampedTextureRotation(button.FlyoutArrow, 270)
    elseif button.direction == "RIGHT" then
        button.FlyoutArrow:SetPoint("RIGHT", button.CurrentAction, "RIGHT", arrowDistance, 0)
        SetClampedTextureRotation(button.FlyoutArrow, 90)
    elseif button.direction == "DOWN" then
        button.FlyoutArrow:SetPoint("BOTTOM", button.CurrentAction, "BOTTOM", 0, -arrowDistance)
        SetClampedTextureRotation(button.FlyoutArrow, 180)
    else
        button.FlyoutArrow:SetPoint("TOP", button.CurrentAction, "TOP", 0, arrowDistance)
        SetClampedTextureRotation(button.FlyoutArrow, 0)
    end

    if button.isOpen then
        button.FlyoutBackground:Show()
    else
        button.FlyoutBackground:Hide()
    end

    button.FlyoutBackground:EnableMouse(button.isOpen)

    if button.direction == "UP" then
        button.FlyoutBackground:SetPoint("BOTTOM", button, "TOP")
        button.FlyoutBackground.End:Show()
        button.FlyoutBackground.End:SetPoint("TOP", button.FlyoutBackground, "TOP", 0, 0)
        SetClampedTextureRotation(button.FlyoutBackground.End, 0)
        button.FlyoutBackground.Horizontal:Hide()
        button.FlyoutBackground.Vertical:Show()
        button.FlyoutBackground.Vertical:ClearAllPoints()
        button.FlyoutBackground.Vertical:SetPoint("TOP", button.FlyoutBackground.End, "BOTTOM")
        button.FlyoutBackground.Vertical:SetPoint("BOTTOM", 0, -4)
    elseif button.direction == "DOWN" then
        button.FlyoutBackground:SetPoint("TOP", button, "BOTTOM")
        button.FlyoutBackground.End:Show()
        button.FlyoutBackground.End:SetPoint("BOTTOM", button.FlyoutBackground, "BOTTOM", 0, 0)
        SetClampedTextureRotation(button.FlyoutBackground.End, 180)
        button.FlyoutBackground.Horizontal:Hide()
        button.FlyoutBackground.Vertical:Show()
        button.FlyoutBackground.Vertical:ClearAllPoints()
        button.FlyoutBackground.Vertical:SetPoint("BOTTOM", button.FlyoutBackground.End, "TOP")
        button.FlyoutBackground.Vertical:SetPoint("TOP", 0, 4)
    elseif button.direction == "LEFT" then
        button.FlyoutBackground:SetPoint("RIGHT", button, "LEFT")
        button.FlyoutBackground.End:Show()
        button.FlyoutBackground.End:SetPoint("LEFT", button.FlyoutBackground, "LEFT", 0, 0)
        SetClampedTextureRotation(button.FlyoutBackground.End, 270)
        button.FlyoutBackground.Vertical:Hide()
        button.FlyoutBackground.Horizontal:Show()
        button.FlyoutBackground.Horizontal:ClearAllPoints()
        button.FlyoutBackground.Horizontal:SetPoint("LEFT", button.FlyoutBackground.End, "RIGHT")
        button.FlyoutBackground.Horizontal:SetPoint("RIGHT", 4, 0)
    elseif button.direction == "RIGHT" then
        button.FlyoutBackground:SetPoint("LEFT", button, "RIGHT")
        button.FlyoutBackground.End:Show()
        button.FlyoutBackground.End:SetPoint("RIGHT", button.FlyoutBackground, "RIGHT", 0, 0)
        SetClampedTextureRotation(button.FlyoutBackground.End, 90)
        button.FlyoutBackground.Vertical:Hide()
        button.FlyoutBackground.Horizontal:Show()
        button.FlyoutBackground.Horizontal:ClearAllPoints()
        button.FlyoutBackground.Horizontal:SetPoint("RIGHT", button.FlyoutBackground.End, "LEFT")
        button.FlyoutBackground.Horizontal:SetPoint("LEFT", -4, 0)
    end

    if (button.direction == "UP" or button.direction == "DOWN") then
        button.FlyoutBackground:SetHeight((button.childSize + SPELLFLYOUT_DEFAULT_SPACING) * button.count - SPELLFLYOUT_DEFAULT_SPACING + SPELLFLYOUT_INITIAL_SPACING +
                                              SPELLFLYOUT_FINAL_SPACING)
        button.FlyoutBackground:SetWidth(button.size - 3)
    else
        button.FlyoutBackground:SetHeight(button.size - 3)
        button.FlyoutBackground:SetWidth((button.childSize + SPELLFLYOUT_DEFAULT_SPACING) * button.count - SPELLFLYOUT_DEFAULT_SPACING + SPELLFLYOUT_INITIAL_SPACING +
                                             SPELLFLYOUT_FINAL_SPACING)
    end
end

function CB:CreateSpellFlyoutChild(button, action, index, previousButton)
    local spellName, _, icon = GetSpellInfo(action)

    local actionButton = CreateFrame("CheckButton", button:GetName() .. "_Button_" .. index, button,
                                     "SecureHandlerStateTemplate, SecureHandlerEnterLeaveTemplate, SecureActionButtonTemplate, ActionButtonTemplate")
    actionButton:EnableMouse(true)
    actionButton:SetSize(button.childSize, button.childSize)
    actionButton:SetFrameLevel(5)
    actionButton:SetAttribute("index", index)
    actionButton:SetAttribute("type", "spell")
    actionButton:SetAttribute("spell", spellName)
    actionButton:RegisterForClicks("AnyUp")
    actionButton.icon:SetTexture(icon)
    actionButton.icon:Show()
    actionButton.spellID = action
    actionButton:Hide()

    if button.config.masqueGroup then
        button.config.masqueGroup:AddButton(actionButton)
    else
        actionButton:SetNormalTexture(nil)
    end

    actionButton:ClearAllPoints()
    if button.direction == "UP" then
        if previousButton then
            actionButton:SetPoint("BOTTOM", previousButton, "TOP", 0, SPELLFLYOUT_DEFAULT_SPACING)
        else
            actionButton:SetPoint("BOTTOM", button.CurrentAction, "TOP", 0, SPELLFLYOUT_INITIAL_SPACING)
        end
    elseif button.direction == "DOWN" then
        if previousButton then
            actionButton:SetPoint("TOP", previousButton, "BOTTOM", 0, -SPELLFLYOUT_DEFAULT_SPACING)
        else
            actionButton:SetPoint("TOP", button.CurrentAction, "BOTTOM", 0, -SPELLFLYOUT_INITIAL_SPACING)
        end
    elseif button.direction == "LEFT" then
        if previousButton then
            actionButton:SetPoint("RIGHT", previousButton, "LEFT", -SPELLFLYOUT_DEFAULT_SPACING, 0)
        else
            actionButton:SetPoint("RIGHT", button.CurrentAction, "LEFT", -SPELLFLYOUT_INITIAL_SPACING, 0)
        end
    elseif button.direction == "RIGHT" then
        if previousButton then
            actionButton:SetPoint("LEFT", previousButton, "RIGHT", SPELLFLYOUT_DEFAULT_SPACING, 0)
        else
            actionButton:SetPoint("LEFT", button.CurrentAction, "RIGHT", SPELLFLYOUT_INITIAL_SPACING, 0)
        end
    end

    actionButton:HookScript("OnEnter", function()
        GameTooltip:SetOwner(button, "ANCHOR_LEFT")
        GameTooltip:SetSpellByID(action, false, true)
        CB:UpdateSpellFlyoutBackground(button)
    end)
    actionButton:HookScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    actionButton:HookScript("OnHide", function()
        CB:UpdateSpellFlyoutBackground(button)
    end)
    actionButton:HookScript("OnClick", function()
        actionButton:SetChecked(false)
        if not InCombatLockdown() then
            button.defaultAction = action
            CB:UpdateSpellFlyout(button)
        end
    end)

    SecureHandlerWrapScript(actionButton, "OnEnter", button, [[
        control:Run(open)
    ]])
    SecureHandlerWrapScript(actionButton, "OnLeave", button, [[return true, ""]], [[
        inHeader =  control:IsUnderMouse(true)
        if not inHeader then
            control:Run(close)
        end	    
    ]])

    Addon:FixNormalTextureSize(actionButton)
    if Addon.Modules.Buttons then
        Addon.Modules.Buttons:StyleActionButton(actionButton)
    end

    return actionButton
end

function CB:UpdateSpellFlyoutChild(button, child)
    if child.spellID then
        if Addon.Modules.Buttons then
            Addon.Modules.Buttons:StyleActionButton(child)
            Addon.Modules.Buttons:Update(child)
        else
            child.isUsable, child.notEnoughMana = IsUsableSpell(child.spellID)

            if child.isUsable and UnitOnTaxi("player") then
                child.isUsable = false
            end

            if child.isUsable then
                child.icon:SetVertexColor(1.0, 1.0, 1.0)
            elseif child.notEnoughMana then
                child.icon:SetVertexColor(0.5, 0.5, 1.0)
            else
                child.icon:SetVertexColor(0.4, 0.4, 0.4)
            end

            -- update charges
            child.reagentCount = Addon.Libs.ClassicSpellActionCount:GetSpellReagentCount(child.spellID)
            if child.reagentCount ~= nil then
                child.Count:SetText(child.reagentCount)
            else
                child.Count:SetText("")
            end
        end

        -- update cooldown
        local start, duration, enable, modRate = GetSpellCooldown(child.spellID)
        local charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(child.spellID)

        if (child.cooldown.currentCooldownType ~= COOLDOWN_TYPE_NORMAL) then
            child.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge");
            child.cooldown:SetSwipeColor(0, 0, 0);
            child.cooldown:SetHideCountdownNumbers(false);
            child.cooldown.currentCooldownType = COOLDOWN_TYPE_NORMAL;
        end

        if (charges and maxCharges and maxCharges > 1 and charges < maxCharges) then
            StartChargeCooldown(child, chargeStart, chargeDuration, chargeModRate)
        else
            ClearChargeCooldown(child)
        end

        CooldownFrame_Set(child.cooldown, start, duration, enable, false, modRate)
    end
end

function CB:CreateSpellOverlay(config)
    local spellOverlay = CreateFrame("Frame", AddonName .. "_SpellOverlay", UIParent)
    spellOverlay:SetPoint("CENTER", UIParent, "CENTER")
    spellOverlay:SetSize(128, 256)

    spellOverlay.Texture = spellOverlay:CreateTexture(nil, "BACKGROUND")
    spellOverlay.Texture:SetTexture("Interface\\Addons\\" .. AddonName .. "\\Media\\Textures\\Arcane_Missiles")
    spellOverlay.Texture:SetAllPoints()

    spellOverlay:Hide()

    return spellOverlay
end
