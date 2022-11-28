local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateActionBarButton(id, parent, buttonType)
    local button = CreateFrame("CheckButton", "$parent_Button" .. id, parent, "SecureActionButtonTemplate, ActionButtonTemplate")
    button:SetID(id)
    button.config = parent.config
    _G.Mixin(button, AB.ActionBarButtonMixin)
    _G.Mixin(button, AB.KeyBoundButtonMixin)

    button.id = id
    button.buttonType = buttonType
    button.keyBoundTarget = buttonType .. id
    button.cooldown = _G[button:GetName() .. "Cooldown"]

    button:SetAttribute("_childupdate-actionpage", [[
		self:CallMethod("UpdateAction")
	]])

    button:SetScript("OnLoad", button.OnLoad)
    button:SetScript("OnAttributeChanged", button.OnAttributeChanged)
    button:SetScript("OnEvent", button.OnEvent)
    button:SetScript("OnEnter", button.OnEnter)
    button:SetScript("OnLeave", button.OnLeave)
    button:SetScript("OnUpdate", button.OnUpdate)
    button:SetScript("PostClick", button.UpdateState)
    button:SetScript("OnDragStart", button.OnDragStart)
    button:SetScript("OnReceiveDrag", button.OnReceiveDrag)

    button.EnableGlow = ActionButton_ShowOverlayGlow
    button.DisableGlow = ActionButton_HideOverlayGlow

    button:OnLoad()
    button:Configure()

    return button
end

AB.ActionBarButtonMixin = {}

function AB.ActionBarButtonMixin:Configure()
    self:RegisterForClicks(self.config.clickOnDown and "AnyDown" or "AnyUp")

    self:SetAttribute("showgrid", self.config.showGrid and 1 or 0)
    self:SetAttribute("flyoutDirection", self.config.flyoutDirection)
    self.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(self.keyBoundTarget)))

    R.Modules.ButtonStyles:StyleActionButton(self)
end

function AB.ActionBarButtonMixin:Configure()
    self:RegisterForClicks(self.config.clickOnDown and "AnyDown" or "AnyUp")

    self:SetAttribute("showgrid", self.config.showGrid and 1 or 0)
    self:SetAttribute("flyoutDirection", self.config.flyoutDirection)
    self.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(self.keyBoundTarget)))

    R.Modules.ButtonStyles:StyleActionButton(self)
end

function AB.ActionBarButtonMixin:OnLoad()
    self.SetButtonStateBase = self.SetButtonState
    self.SetButtonState = self.SetButtonStateOverride

    self.flashing = 0
    self.flashtime = 0
    self:SetAttribute("type", "action")
    self:SetAttribute("typerelease", "actionrelease")
    self:SetAttribute("checkselfcast", true)
    self:SetAttribute("checkfocuscast", true)
    self:SetAttribute("checkmouseovercast", true)
    self:SetAttribute("useparent-unit", true)
    self:SetAttribute("useparent-actionpage", true)
    self:RegisterForDrag("LeftButton", "RightButton")
    self:RegisterForClicks("AnyUp", "LeftButtonDown", "RightButtonDown")
    self:UpdateAction()
    self:UpdateHotkeys(self.buttonType)
end

function AB.ActionBarButtonMixin:UpdateHotkeys()
    self.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(self.keyBoundTarget)))
end

function AB.ActionBarButtonMixin:UpdatePressAndHoldAction()
    if not R.isRetail then
        return
    end

    local pressAndHoldAction = false

    if self.action then
        local actionType, id = GetActionInfo(self.action)
        if actionType == "spell" then
            pressAndHoldAction = IsPressHoldReleaseSpell(id)
        elseif actionType == "macro" then
            local spellID = GetMacroSpell(id)
            if spellID then
                pressAndHoldAction = IsPressHoldReleaseSpell(spellID)
            end
        end
    end

    self:SetAttribute("pressAndHoldAction", pressAndHoldAction)
end

function AB.ActionBarButtonMixin:OnAttributeChanged(name, value)
    self:UpdateAction()
end

function AB.ActionBarButtonMixin:CalculateAction()
    if not button then
        button = SecureButton_GetEffectiveButton(self)
    end
    if self:GetID() > 0 then
        local page = SecureButton_GetModifiedAttribute(self, "actionpage", button)
        if not page then
            page = GetActionBarPage()
            if self.isExtra then
                page = GetExtraBarIndex()
            elseif self.buttonType == "MULTICASTACTIONBUTTON" then
                page = GetMultiCastBarIndex()
            end
        end
        return self:GetID() + ((page - 1) * NUM_ACTIONBAR_BUTTONS)
    else
        return SecureButton_GetModifiedAttribute(self, "action", button) or 1
    end
end

function AB.ActionBarButtonMixin:UpdateAction(force)
    local action = self:CalculateAction()
    if action ~= self.action or force then
        self.action = action
        SetActionUIButton(self, action, self.cooldown)
        self:Update()
    end
end

function AB.ActionBarButtonMixin:Update()
    local action = self.action
    local icon = self.icon
    local buttonCooldown = self.cooldown
    local texture = GetActionTexture(action)

    icon:SetDesaturated(false)
    local type, id = GetActionInfo(action)
    if HasAction(action) then
        self:UpdateState()
        self:UpdateUsable()
        ActionButton_UpdateCooldown(self)
        self:UpdateFlash()
        self:UpdateHighlightMark()
        self:UpdateSpellHighlightMark()
    else
        buttonCooldown:Hide()

        ClearChargeCooldown(self)

        self:ClearFlash()
        self:SetChecked(false)

        if self.LevelLinkLockIcon then
            self.LevelLinkLockIcon:SetShown(false)
        end
    end

    self:UpdatePressAndHoldAction()

    -- Add a green border if button is an equipped item
    local border = self.Border
    if border then
        if IsEquippedAction(action) then
            border:SetVertexColor(0, 1.0, 0, 0.5)
            border:Show()
        else
            border:Hide()
        end
    end

    -- Update Action Text
    local actionName = self.Name
    if actionName then
        if not IsConsumableAction(action) and not IsStackableAction(action) and (IsItemAction(action) or GetActionCount(action) == 0) then
            actionName:SetText(GetActionText(action))
        else
            actionName:SetText("")
        end
    end

    -- Update icon and hotkey text
    if texture then
        icon:SetTexture(texture)
        icon:Show()
        self.rangeTimer = -1
        self:UpdateCount()
    else
        self.Count:SetText("")
        icon:Hide()
        buttonCooldown:Hide()
        self.rangeTimer = nil
        local hotkey = self.HotKey
        if hotkey:GetText() == RANGE_INDICATOR then
            hotkey:Hide()
        else
            hotkey:SetVertexColor(0.6, 0.6, 0.6)
        end
    end

    -- Update flyout appearance
    self:UpdateFlyout()

    self:UpdateOverlayGlow()

    -- Update tooltip
    if GameTooltip:GetOwner() == self then
        self:SetTooltip()
    end

    self.feedback_action = action

    R.Modules.ButtonStyles:UpdateActionButton(self)

    -- SpellActivationOverlay integration
    if HookActionButton_Update then
        HookActionButton_Update(self)
    end
end

function AB.ActionBarButtonMixin:UpdateHighlightMark()
    if self.NewActionTexture then
        self.NewActionTexture:SetShown(GetNewActionHighlightMark(self.action)) -- TODO: Should bindings support this, or should we force SetShown to take a bool?
    end
end

function AB.ActionBarButtonMixin:UpdateSpellHighlightMark()
    if self.SpellHighlightTexture and self.SpellHighlightAnim then
        SharedActionButton_RefreshSpellHighlight(self, GetOnBarHighlightMark(self.action))
    end
end

function AB.ActionBarButtonMixin:HasAction()
    return HasAction(self.action)
end

function AB.ActionBarButtonMixin:UpdateState()
    self:SetChecked((IsCurrentAction(self.action) or IsAutoRepeatAction(self.action)) and not C_ActionBar.IsAutoCastPetAction(self.action))
end

function AB.ActionBarButtonMixin:UpdateUsable()
    if self.checksRange and not self.inRange then
        self.icon:SetVertexColor(0.8, 0.1, 0.1)
    else
        local isUsable, notEnoughMana = IsUsableAction(self.action);
        if isUsable then
            self.icon:SetVertexColor(1.0, 1.0, 1.0)
        elseif notEnoughMana then
            self.icon:SetVertexColor(0.5, 0.5, 1.0)
        else
            self.icon:SetVertexColor(0.4, 0.4, 0.4)
        end
    end

    if R.isRetail then
        local isLevelLinkLocked = C_LevelLink.IsActionLocked(self.action)
        if not self.icon:IsDesaturated() then
            self.icon:SetDesaturated(isLevelLinkLocked)
        end

        if self.LevelLinkLockIcon then
            self.LevelLinkLockIcon:SetShown(isLevelLinkLocked)
        end
    end
end

function AB.ActionBarButtonMixin:UpdateCount()
    local text = self.Count
    local action = self.action
    if IsConsumableAction(action) or IsStackableAction(action) or (not IsItemAction(action) and GetActionCount(action) > 0) then
        local count = GetActionCount(action)
        if count > (self.maxDisplayCount or 9999) then
            text:SetText("*")
        else
            text:SetText(count)
        end
    else
        local charges, maxCharges, chargeStart, chargeDuration = GetActionCharges(action)
        if maxCharges > 1 then
            text:SetText(charges)
        else
            text:SetText("")
        end
    end
end

function AB.ActionBarButtonMixin:UpdateOverlayGlow()
    if not R.isRetail then
        return
    end

    local spellType, id, subType = GetActionInfo(self.action)
    if spellType == "spell" and IsSpellOverlayed(id) then
        ActionButton_ShowOverlayGlow(self)
    elseif spellType == "macro" then
        local spellId = GetMacroSpell(id)
        if spellId and IsSpellOverlayed(spellId) then
            ActionButton_ShowOverlayGlow(self)
        else
            ActionButton_HideOverlayGlow(self)
        end
    else
        ActionButton_HideOverlayGlow(self)
    end
end

function AB.ActionBarButtonMixin:OnEvent(event, ...)
    local arg1 = ...
    if (event == "UNIT_INVENTORY_CHANGED" and arg1 == "player") or event == "LEARNED_SPELL_IN_TAB" then
        if GameTooltip:GetOwner() == self then
            self:SetTooltip()
        end
    elseif event == "ACTIONBAR_SLOT_CHANGED" then
        if arg1 == 0 or arg1 == tonumber(self.action) then
            ClearNewActionHighlight(self.action, true)
            self:UpdateAction(true)
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:Update()
    elseif event == "UPDATE_SHAPESHIFT_FORM" then
        -- need to listen for UPDATE_SHAPESHIFT_FORM because attack icons change when the shapeshift form changes
        -- This is NOT intended to update everything about shapeshifting; most stuff should be handled by ActionBar-specific events such as UPDATE_BONUS_ACTIONBAR, UPDATE_USABLE, etc.
        local texture = GetActionTexture(self.action)
        if texture then
            self.icon:SetTexture(texture)
        end
    elseif event == "UPDATE_BINDINGS" or event == "GAME_PAD_ACTIVE_CHANGED" then
        self:UpdateHotkeys(self.buttonType)
    elseif event == "PLAYER_TARGET_CHANGED" then -- All event handlers below this line are only set when the button has an action
        self.rangeTimer = -1
    elseif event == "UNIT_FLAGS" or event == "UNIT_AURA" or event == "PET_BAR_UPDATE" then
        -- Pet actions can also change the state of action buttons.
        self.flashDirty = true
        self.stateDirty = true
    elseif (event == "ACTIONBAR_UPDATE_STATE") or ((event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE") and (arg1 == "player")) or ((event == "COMPANION_UPDATE") and (arg1 == "MOUNT")) then
        self:UpdateState()
    elseif event == "ACTIONBAR_UPDATE_USABLE" or event == "PLAYER_MOUNT_DISPLAY_CHANGED" then
        self:UpdateUsable()
    elseif event == "LOSS_OF_CONTROL_UPDATE" then
        ActionButton_UpdateCooldown(self)
    elseif event == "ACTIONBAR_UPDATE_COOLDOWN" or event == "LOSS_OF_CONTROL_ADDED" then
        ActionButton_UpdateCooldown(self)
        -- Update tooltip
        if GameTooltip:GetOwner() == self then
            self:SetTooltip()
        end
    elseif event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" or event == "ARCHAEOLOGY_CLOSED" then
        self:UpdateState()
    elseif event == "PLAYER_ENTER_COMBAT" then
        if IsAttackAction(self.action) then
            self:StartFlash()
        end
    elseif (event == "PLAYER_LEAVE_COMBAT") then
        if (IsAttackAction(self.action)) then
            self:StopFlash();
        end
    elseif event == "START_AUTOREPEAT_SPELL" then
        if IsAutoRepeatAction(self.action) then
            self:StartFlash()
        end
    elseif event == "STOP_AUTOREPEAT_SPELL" then
        if self:IsFlashing() and not IsAttackAction(self.action) then
            self:StopFlash()
        end
    elseif event == "PET_STABLE_UPDATE" or event == "PET_STABLE_SHOW" then
        -- Has to update everything for now, but this event should happen infrequently
        self:Update()
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
        local actionType, id, subType = GetActionInfo(self.action)
        if actionType == "spell" and id == arg1 then
            ActionButton_ShowOverlayGlow(self)
        elseif actionType == "macro" then
            local spellId = GetMacroSpell(id)
            if spellId and spellId == arg1 then
                ActionButton_ShowOverlayGlow(self)
            end
        elseif actionType == "flyout" and FlyoutHasSpell(id, arg1) then
            ActionButton_ShowOverlayGlow(self)
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        local actionType, id, subType = GetActionInfo(self.action)
        if actionType == "spell" and id == arg1 then
            ActionButton_HideOverlayGlow(self)
        elseif actionType == "macro" then
            local spellId = GetMacroSpell(id)
            if spellId and spellId == arg1 then
                ActionButton_HideOverlayGlow(self)
            end
        elseif actionType == "flyout" and FlyoutHasSpell(id, arg1) then
            ActionButton_HideOverlayGlow(self)
        end
    elseif event == "SPELL_UPDATE_CHARGES" then
        self:UpdateCount()
    elseif event == "UPDATE_SUMMONPETS_ACTION" then
        local actionType, id = GetActionInfo(self.action)
        if actionType == "summonpet" then
            local texture = GetActionTexture(self.action)
            if texture then
                self.icon:SetTexture(texture)
            end
        end
    elseif event == "SPELL_UPDATE_ICON" then
        self:Update()
    end
end

function AB.ActionBarButtonMixin:SetTooltip()
    local inQuickKeybind = KeybindFrames_InQuickKeybindMode()
    if GetCVar("UberTooltips") == "1" or inQuickKeybind then
        GameTooltip_SetDefaultAnchor(GameTooltip, self)
    else
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    end
    if GameTooltip:SetAction(self.action) then
        self.UpdateTooltip = self.SetTooltip
    else
        self.UpdateTooltip = nil
    end
end

function AB.ActionBarButtonMixin:OnUpdate(elapsed)
    if self.stateDirty then
        self:UpdateState()
        self.stateDirty = nil
    end

    if self.flashDirty then
        self:UpdateFlash()
        self.flashDirty = nil
    end

    if self:IsFlashing() then
        local flashtime = self.flashtime
        flashtime = flashtime - elapsed

        if flashtime <= 0 then
            local overtime = -flashtime
            if overtime >= ATTACK_BUTTON_FLASH_TIME then
                overtime = 0
            end
            flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

            local flashTexture = self.Flash
            if flashTexture:IsShown() then
                flashTexture:Hide()
            else
                flashTexture:Show()
            end
        end

        self.flashtime = flashtime
    end

    if self.rangeTimer then
        self.rangeTimer = self.rangeTimer - elapsed

        if self.rangeTimer <= 0 then
            local valid = IsActionInRange(self.action)
            local checksRange = (valid ~= nil)
            self.checksRange = (valid ~= nil)
            self.inRange = self.checksRange and valid
            self:UpdateUsable()
            self.rangeTimer = TOOLTIP_UPDATE_TIME
        end
    end
end

function AB.ActionBarButtonMixin:GetPagedID()
    return self.action
end

function AB.ActionBarButtonMixin:UpdateFlash()
    local action = self.action
    if (IsAttackAction(action) and IsCurrentAction(action)) or IsAutoRepeatAction(action) then
        self:StartFlash()

        local actionType, actionID, actionSubtype = GetActionInfo(action)
        if actionSubtype == "pet" then
            self:GetCheckedTexture():SetAlpha(0.5)
        else
            self:GetCheckedTexture():SetAlpha(1.0)
        end
    else
        self:StopFlash()
    end

    if self.AutoCastable then
        self.AutoCastable:SetShown(C_ActionBar.IsAutoCastPetAction(action))
        if C_ActionBar.IsEnabledAutoCastPetAction(action) then
            self.AutoCastShine:Show()
            AutoCastShine_AutoCastStart(self.AutoCastShine)
        else
            self.AutoCastShine:Hide()
            AutoCastShine_AutoCastStop(self.AutoCastShine)
        end
    end
end

function AB.ActionBarButtonMixin:ClearFlash()
    if self.AutoCastable then
        self.AutoCastable:Hide()
        self.AutoCastShine:Hide()
        AutoCastShine_AutoCastStop(self.AutoCastShine)
    end
end

function AB.ActionBarButtonMixin:StartFlash()
    self.flashing = 1
    self.flashtime = 0
    self:UpdateState()
end

function AB.ActionBarButtonMixin:StopFlash()
    self.flashing = 0
    self.Flash:Hide()
    self:UpdateState()
end

function AB.ActionBarButtonMixin:IsFlashing()
    if self.flashing == 1 then
        return 1
    end

    return nil
end

-- Shared between action bar buttons and spell flyout buttons
function AB.ActionBarButtonMixin:UpdateFlyout(isButtonDownOverride)
    if not self.FlyoutArrowContainer or not self.FlyoutBorderShadow then
        return
    end

    local actionType = GetActionInfo(self.action)
    if actionType ~= "flyout" then
        self.FlyoutBorderShadow:Hide()
        self.FlyoutArrowContainer:Hide()
        return
    end

    -- Update border
    local isMouseOverButton = GetMouseFocus() == self
    local isFlyoutShown = SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self
    if isFlyoutShown or isMouseOverButton then
        self.FlyoutBorderShadow:Show()
    else
        self.FlyoutBorderShadow:Hide()
    end

    -- Update arrow
    local isButtonDown
    if isButtonDownOverride ~= nil then
        isButtonDown = isButtonDownOverride
    else
        isButtonDown = self:GetButtonState() == "PUSHED"
    end

    local flyoutArrowTexture = self.FlyoutArrowContainer.FlyoutArrowNormal

    if isButtonDown then
        flyoutArrowTexture = self.FlyoutArrowContainer.FlyoutArrowPushed

        self.FlyoutArrowContainer.FlyoutArrowNormal:Hide()
        self.FlyoutArrowContainer.FlyoutArrowHighlight:Hide()
    elseif isMouseOverButton then
        flyoutArrowTexture = self.FlyoutArrowContainer.FlyoutArrowHighlight

        self.FlyoutArrowContainer.FlyoutArrowNormal:Hide()
        self.FlyoutArrowContainer.FlyoutArrowPushed:Hide()
    else
        self.FlyoutArrowContainer.FlyoutArrowHighlight:Hide()
        self.FlyoutArrowContainer.FlyoutArrowPushed:Hide()
    end

    self.FlyoutArrowContainer:Show()
    flyoutArrowTexture:Show()
    flyoutArrowTexture:ClearAllPoints()

    local arrowDirection = self:GetAttribute("flyoutDirection")
    local arrowDistance = isFlyoutShown and 1 or 4

    -- If you are on an action bar then base your direction based on the action bar's orientation
    local actionBar = self:GetParent()
    if actionBar.actionButtons then
        arrowDirection = actionBar:GetSpellFlyoutDirection()
    end

    if arrowDirection == "LEFT" then
        SetClampedTextureRotation(flyoutArrowTexture, isFlyoutShown and 90 or 270)
        flyoutArrowTexture:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
    elseif arrowDirection == "RIGHT" then
        SetClampedTextureRotation(flyoutArrowTexture, isFlyoutShown and 270 or 90)
        flyoutArrowTexture:SetPoint("RIGHT", self, "RIGHT", arrowDistance, 0)
    elseif arrowDirection == "DOWN" then
        SetClampedTextureRotation(flyoutArrowTexture, isFlyoutShown and 0 or 180)
        flyoutArrowTexture:SetPoint("BOTTOM", self, "BOTTOM", 0, -arrowDistance)
    else
        SetClampedTextureRotation(flyoutArrowTexture, isFlyoutShown and 180 or 0)
        flyoutArrowTexture:SetPoint("TOP", self, "TOP", 0, arrowDistance)
    end
end

function AB.ActionBarButtonMixin:SetButtonStateOverride(state)
    self:SetButtonStateBase(state)
    self:UpdateFlyout()
end

function AB.ActionBarButtonMixin:OnDragStart()
    if not GetCVar("lockActionBars") or IsModifiedClick("PICKUPACTION") then
        local ignoreActionRemoval = IsAnyIconSelectorPopupFrameShown and IsAnyIconSelectorPopupFrameShown()
        PickupAction(self.action, ignoreActionRemoval)

        if SpellFlyout then
            SpellFlyout:Hide()
        end
        self:UpdateState()
        self:UpdateFlash()
    end
end

function AB.ActionBarButtonMixin:OnReceiveDrag()
    PlaceAction(self.action)
    self:UpdateState()
    self:UpdateFlash()
end

function AB.ActionBarButtonMixin:OnEnter()
    if self.NewActionTexture then
        ClearNewActionHighlight(self.action)
        self:UpdateAction(true)
    end
    self:SetTooltip()
    ActionBarButtonEventsFrame.tooltipOwner = self
    ActionBarActionEventsFrame.tooltipOwner = self
    self:UpdateFlyout()

    R.Libs.KeyBound:Set(self)
end

function AB.ActionBarButtonMixin:OnLeave()
    GameTooltip:Hide()
    ActionBarButtonEventsFrame.tooltipOwner = nil
    ActionBarActionEventsFrame.tooltipOwner = nil
    self:UpdateFlyout()
end
