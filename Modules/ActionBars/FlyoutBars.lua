local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

local SPELLFLYOUT_DEFAULT_SPACING = 0
local SPELLFLYOUT_INITIAL_SPACING = 0
local SPELLFLYOUT_FINAL_SPACING = 4

function AB:LoadFlyoutBars()
    AB.flyoutBars = {}
    for name, config in pairs(AB.config.flyoutBars) do AB.flyoutBars[name] = AB:CreateFlyoutBar(name, config) end
end

function AB:UpdateFlyoutBars()
    for name, bar in pairs(AB.flyoutBars) do
        if AB.config.flyoutBars[name] then
            AB:UpdateFlyoutBar(bar)
        else
            R:Disable(bar)
            bar.Mover:Lock(true)
            AB.flyoutBars[name] = nil
        end
    end

    for name, config in pairs(AB.config.flyoutBars) do if not AB.flyoutBars[name] then AB.flyoutBars[name] = AB:CreateFlyoutBar(name, config) end end
end

function AB:CreateFlyoutBar(name, config)
    if config.tbc and R.isRetail or not config.enabled or (config.class ~= R.PlayerInfo.class and (config.class or "") ~= "") then return end

    local bar = CreateFrame("Frame", addonName .. "_" .. name, _G.UIParent)
    bar:CreateBackdrop("Transparent")
    bar.config = config
    bar.buttons = {}
    bar.name = name
    for i, button in ipairs(config.buttons) do bar.buttons[i] = AB:CreateFlyoutButton(button.name, bar, button) end

    bar:RegisterEvent("LEARNED_SPELL_IN_TAB")
    bar:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
    bar:HookScript("OnEvent", function(self, event)
        if event == "ACTIONBAR_UPDATE_USABLE" then
            self.needsUpdate = true
        elseif event == "LEARNED_SPELL_IN_TAB" then
            self.needsUpdate = true
        end
    end)
    bar:SetScript("OnUpdate", function(self, event)
        if self.needsUpdate and not InCombatLockdown() then
            for i, button in ipairs(bar.buttons) do
                button.CurrentAction:UpdateConfig()
                for j, child in next, button.childButtons do child:UpdateConfig() end
            end

            AB:UpdateFlyoutBar(self)
            self.needsUpdate = false
        end
    end)

    local default =  AB.defaults.flyoutBars[name] or config
    bar:CreateMover(name, default.point)
    AB:UpdateFlyoutBar(bar)

    return bar
end

function AB:UpdateFlyoutBar(bar)
    if not bar then return end
    if InCombatLockdown() then bar.needsUpdate = true end

    if not bar.config.enabled or (bar.config.class ~= R.PlayerInfo.class and (bar.config.class or "") ~= "") then
        bar:Hide()
        return
    else
        bar:Show()
    end

    -- remove deleted buttons
    for i, button in ipairs(bar.buttons) do
        local found = false
        for _, buttonConfig in ipairs(bar.config.buttons) do
            if button.config == buttonConfig then
                found = true
                break
            end
        end

        if not found then
            button:Hide()
            table.remove(bar.buttons, i)
        end
    end

    -- create newly added buttons
    for i, buttonConfig in ipairs(bar.config.buttons) do
        local found = false
        for _, button in ipairs(bar.buttons) do
            if button.config == buttonConfig then
                found = true
                break
            end
        end

        if not found then table.insert(bar.buttons, i, AB:CreateFlyoutButton(buttonConfig.name, bar, buttonConfig)) end
    end

    -- update buttons
    local spacing = bar.config.backdrop and bar.config.backdropSpacing
    local visibleButtonCount = 0
    local lastVisibleButton
    local buttonList = {}
    for i, button in ipairs(bar.buttons) do
        AB:UpdateFlyoutButton(button)

        if button:IsVisible() then
            visibleButtonCount = visibleButtonCount + 1

            button:ClearAllPoints()
            if visibleButtonCount == 1 then
                button:SetPoint("BOTTOMLEFT", spacing or 0, spacing or 0)
            else
                button:SetPoint("BOTTOMLEFT", lastVisibleButton, "BOTTOMRIGHT", bar.config.buttonSpacing, 0)
            end

            lastVisibleButton = button
        end
    end

    local width = (visibleButtonCount) * bar.config.buttonSize + (visibleButtonCount - 1) * bar.config.buttonSpacing
    local height = bar.config.buttonSize

    bar:SetSize(width, height)
    bar:SetNormalizedPoint(unpack(bar.config.point))
end

function AB:GetButtonActions()
    return type(self.config.actions) == "function" and self.config.actions() or self.config.actions
end

function AB:CreateFlyoutButton(name, bar, config)
    -- create parent frame
    local button = CreateFrame("Frame", "FlyoutButton_" .. name, bar, "SecureHandlerStateTemplate")
    button.bar = bar
    button.config = config
    button.size = button.bar.config.buttonSize
    button.childSize = button.bar.config.buttonSize - 8
    button.childButtons = {}
    button:EnableMouse(true)
    button:SetSize(button.size, button.size)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(1)

    -- Create secure open/close functions (needed for combat execution)
    button:Execute([[open = [=[        
            self:SetAttribute("open", 1)
            local childButtons = newtable(self:GetChildren())
            for i, button in ipairs(childButtons) do
                local index = button:GetAttribute("index")
                local hidden = button:GetAttribute("hidden")
                if hidden == 1 then
                    button:Hide()
                else
                    button:Show()
                end
            end
        ]=] ]])
    button:Execute([[close = [=[
            self:SetAttribute("open", 0)
            local childButtons = newtable(self:GetChildren())
            for i, button in pairs(childButtons) do
                local index = button:GetAttribute("index")
                if index ~= 0 then
                    button:Hide()
                end			
            end
        ]=] ]])

    -- Create a button for the current/default action
    button.CurrentAction = R.Libs.ActionButton:CreateButton(button:GetName() .. 0, button:GetName() .. "_CurrentAction", button)
    button.CurrentAction:SetPoint("BOTTOM", button, "BOTTOM", 0, 0)
    button.CurrentAction:SetSize(button.size, button.size)
    button.CurrentAction:SetFrameLevel(10)
    button.CurrentAction:SetAttribute("index", 0)
    button.CurrentAction:SetAttribute("buttonlock", true)
    button.CurrentAction:DisableDragNDrop()
    button.CurrentAction:Show()
    R.Modules.ButtonStyles:StyleActionButton(button.CurrentAction)

    SecureHandlerWrapScript(button.CurrentAction, "OnEnter", button, [[
            control:Run(open)
        ]])
    SecureHandlerWrapScript(button.CurrentAction, "OnLeave", button, [[return true, ""]], [[
            inHeader =  control:IsUnderMouse(true)
            if not inHeader then
                control:Run(close)
            end	    
        ]])

    button.CurrentAction:HookScript("OnEnter", function() AB:UpdateFlyoutButtonBackground(button) end)
    button.CurrentAction:HookScript("OnLeave", function() AB:UpdateFlyoutButtonBackground(button) end)
    button.CurrentAction:HookScript("OnClick", function() button.CurrentAction:SetChecked(false) end)

    button.GetActions =  AB.GetButtonActions

    AB:CreateFlyoutButtonBackground(button)
    AB:UpdateFlyoutButton(button)

    return button
end

function AB:UpdateFlyoutButton(button)
    button.isOpen = button:GetAttribute("open") == 1

    button.size = button.bar.config.buttonSize
    button.childSize = button.bar.config.buttonSize - 8
    button:SetSize(button.bar.config.buttonSize, button.bar.config.buttonSize)
    button.CurrentAction:SetSize(button.bar.config.buttonSize, button.bar.config.buttonSize)

    if not InCombatLockdown() then
        button.count = 0

        local actions = button:GetActions()

        -- generate/position child buttons
        local previousButton
        for i, action in ipairs(actions) do
            local child = button.childButtons[action]
            if not child then
                child = AB:CreateFlyoutButtonChild(button, action, i)
                button.childButtons[action] = child
            end

            local visible = (not button.config.showOnlyMaxRank and IsSpellKnown(action)) or (button.config.showOnlyMaxRank and R:IsMaxKnownRank(action))
            child:SetAttribute("hidden", (not visible and 1) or 0)
            child:SetShown(visible and button.isOpen)

            if visible and IsSpellKnown(action) then
                child:SetState(0, "spell", action)
                button.count = button.count + 1
                AB:PositionFlyoutButtonChild(button, child, previousButton)
                previousButton = child
            end
        end

        for i, child in next, button.childButtons do
            if not tContains(actions, child:GetAttribute("spell")) then
                child:SetAttribute("hidden", 1)
                child:Hide()
            end
        end

        AB:SetFlyoutCurrentAction(button, button.config.defaultAction)
    end

    AB:UpdateFlyoutButtonBackground(button)

    if button.count > 0 and button.config.enabled then
        button:Show()
    else
        button:Hide()
    end
end

function AB:CreateFlyoutButtonBackground(button)
    button.FlyoutArrowHolder = CreateFrame("Frame", nil, button.CurrentAction)
    button.FlyoutArrowHolder:SetPoint("CENTER", button.CurrentAction, "CENTER")
    button.FlyoutArrowHolder:SetFrameLevel(button.CurrentAction:GetFrameLevel() + 20)
    button.FlyoutArrow = button.FlyoutArrowHolder:CreateTexture(nil, "OVERLAY", "ActionBarFlyoutButton-ArrowUp")
    button.FlyoutArrow:SetPoint("CENTER", button.FlyoutArrowHolder, "CENTER")

    button.FlyoutBackground = CreateFrame("Frame", button:GetName() .. "_Background", button, "BackdropTemplate")
    button.FlyoutBackground:EnableMouse(true)
end

function AB:UpdateFlyoutButtonBackground(button)
    button.isOpen = button:GetAttribute("open") == 1

    local arrowDistance = button.isOpen and 5 or 2
    button.FlyoutArrow:Show()
    button.FlyoutArrow:ClearAllPoints()
    if button.bar.config.direction == "LEFT" then
        button.FlyoutArrow:SetPoint("LEFT", button.CurrentAction, "LEFT", -arrowDistance, 0)
        SetClampedTextureRotation(button.FlyoutArrow, 270)
    elseif button.bar.config.direction == "RIGHT" then
        button.FlyoutArrow:SetPoint("RIGHT", button.CurrentAction, "RIGHT", arrowDistance, 0)
        SetClampedTextureRotation(button.FlyoutArrow, 90)
    elseif button.bar.config.direction == "DOWN" then
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

    if button.bar.config.direction == "UP" then
        button.FlyoutBackground:SetPoint("BOTTOM", button, "TOP", 0, -4)
    elseif button.bar.config.direction == "DOWN" then
        button.FlyoutBackground:SetPoint("TOP", button, "BOTTOM", 0, 4)
    elseif button.bar.config.direction == "LEFT" then
        button.FlyoutBackground:SetPoint("RIGHT", button, "LEFT", -4, 0)
    elseif button.bar.config.direction == "RIGHT" then
        button.FlyoutBackground:SetPoint("LEFT", button, "RIGHT", 4, 0)
    end

    if (button.bar.config.direction == "UP" or button.bar.config.direction == "DOWN") then
        button.FlyoutBackground:SetHeight((button.childSize + SPELLFLYOUT_DEFAULT_SPACING) * button.count - SPELLFLYOUT_DEFAULT_SPACING + SPELLFLYOUT_INITIAL_SPACING + SPELLFLYOUT_FINAL_SPACING + 2)
        button.FlyoutBackground:SetWidth(button.size - 3)
    else
        button.FlyoutBackground:SetHeight(button.size - 3)
        button.FlyoutBackground:SetWidth((button.childSize + SPELLFLYOUT_DEFAULT_SPACING) * button.count - SPELLFLYOUT_DEFAULT_SPACING + SPELLFLYOUT_INITIAL_SPACING + SPELLFLYOUT_FINAL_SPACING + 2)
    end
end

function AB:CreateFlyoutButtonChild(button, action, index)
    local child = R.Libs.ActionButton:CreateButton(button:GetName() .. index, button:GetName() .. "_Button_" .. index, button)
    child:SetSize(button.childSize, button.childSize)
    child:SetFrameLevel(5)
    child:SetAttribute("index", index)
    child:DisableDragNDrop()
    child:Hide()

    child:HookScript("OnEnter", function() AB:UpdateFlyoutButtonBackground(button) end)
    child:HookScript("OnLeave", function() end)
    child:HookScript("OnHide", function() AB:UpdateFlyoutButtonBackground(button) end)
    child:HookScript("OnClick", function(self, mouseButton)
        child:SetChecked(false)
        if not InCombatLockdown() then
            local mode = button.config.defaultActionUpdateMode
            if (mode == AB.UPDATE_DEFAULT_MODE.ANY_CLICK) or (mouseButton == "LeftButton" and (mode == AB.UPDATE_DEFAULT_MODE.LEFT_CLICK)) or
                (mouseButton == "RightButton" and (mode == AB.UPDATE_DEFAULT_MODE.RIGHT_CLICK)) or (mouseButton == "MiddleButton" and (mode == AB.UPDATE_DEFAULT_MODE.MIDDLE_CLICK)) then
                AB:SetFlyoutCurrentAction(button, action)
            end
            AB:UpdateFlyoutButton(button)
        end
    end)

    SecureHandlerWrapScript(child, "OnEnter", button, [[
        control:Run(open)
    ]])
    SecureHandlerWrapScript(child, "OnLeave", button, [[return true, ""]], [[
        inHeader =  control:IsUnderMouse(true)
        if not inHeader then
            control:Run(close)
        end	    
    ]])

    R.Modules.ButtonStyles:StyleActionButton(child)

    return child
end

function AB:PositionFlyoutButtonChild(button, child, previousButton)
    child:SetSize(button.childSize, button.childSize)
    child:ClearAllPoints()
    if button.bar.config.direction == "UP" then
        if previousButton then
            child:SetPoint("BOTTOM", previousButton, "TOP", 0, SPELLFLYOUT_DEFAULT_SPACING)
        else
            child:SetPoint("BOTTOM", button.CurrentAction, "TOP", 0, SPELLFLYOUT_INITIAL_SPACING)
        end
    elseif button.bar.config.direction == "DOWN" then
        if previousButton then
            child:SetPoint("TOP", previousButton, "BOTTOM", 0, -SPELLFLYOUT_DEFAULT_SPACING)
        else
            child:SetPoint("TOP", button.CurrentAction, "BOTTOM", 0, -SPELLFLYOUT_INITIAL_SPACING)
        end
    elseif button.bar.config.direction == "LEFT" then
        if previousButton then
            child:SetPoint("RIGHT", previousButton, "LEFT", -SPELLFLYOUT_DEFAULT_SPACING, 0)
        else
            child:SetPoint("RIGHT", button.CurrentAction, "LEFT", -SPELLFLYOUT_INITIAL_SPACING, 0)
        end
    elseif button.bar.config.direction == "RIGHT" then
        if previousButton then
            child:SetPoint("LEFT", previousButton, "RIGHT", SPELLFLYOUT_DEFAULT_SPACING, 0)
        else
            child:SetPoint("LEFT", button.CurrentAction, "RIGHT", SPELLFLYOUT_INITIAL_SPACING, 0)
        end
    end
end

function AB:SetFlyoutCurrentAction(button, action)
    local actions = button:GetActions()
    local actionFound = false
    for _, id in ipairs(actions) do if action == id then actionFound = true end end

    if not actionFound then action = button.config.defaultAction or R:GetMaxKnownRank(actions[1]) or actions[1] end

    if button.config.showOnlyMaxRank then action = R:GetMaxKnownRank(action) or action end

    if action and not IsSpellKnown(action) then for _, id in next, actions do if IsSpellKnown(id) then action = id end end end

    if action and IsSpellKnown(action) then
        local icon = select(3, GetSpellInfo(action))
        button.CurrentAction.icon:SetTexture(icon)
        button.CurrentAction.icon:Show()

        button.CurrentAction:SetState(0, "spell", action)
        button.config.defaultAction = action
    end
end
