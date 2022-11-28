local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreatePetBar()
    local bar = CreateFrame("Frame", addonName .. "_PetBar", UIParent, "SecureHandlerStateTemplate")
    bar.config = AB.config.petBar
    bar.defaults = AB.defaults.petBar
    bar.buttons = {}
    bar:SetFrameStrata("LOW")
    _G.Mixin(bar, AB.PetBarMixin)

    for id = 1, 10 do
        bar.buttons[id] = AB:CreatePetButton(id, bar, bar.config.buttonType)
    end

    bar.buttons[11] = AB:CreateActionButton("$parent_Button11", bar, _G.PetDismiss, [[Interface\Icons\Spell_Shadow_SacrificialShield]], _G.PET_DISMISS)

    bar.visibility = "[overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide"

    bar:SetScript("OnEvent", bar.OnEvent)

    bar:RegisterEvent("PLAYER_REGEN_ENABLED")
    bar:RegisterEvent("PLAYER_CONTROL_LOST")
    bar:RegisterEvent("PLAYER_CONTROL_GAINED")
    bar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
    bar:RegisterEvent("UNIT_PET")
    bar:RegisterEvent("UNIT_FLAGS")
    bar:RegisterEvent("PET_BAR_UPDATE")
    bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
    bar:RegisterEvent("PET_BAR_UPDATE_USABLE")
    bar:RegisterEvent("PET_UI_UPDATE")
    bar:RegisterEvent("PLAYER_TARGET_CHANGED")
    bar:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
    bar:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
    bar:RegisterUnitEvent("UNIT_AURA", "pet")

    if R.isRetail then
        bar:RegisterEvent("PET_SPECIALIZATION_CHANGED")
    end

    bar:CreateBackdrop({ bgFile = R.media.textures.blank })
    bar:CreateBorder()
    bar:CreateShadow()
    bar:CreateFader(bar.config.fader, bar.buttons)
    bar:CreateMover(L["Pet Bar"], bar.defaults.point)

    return bar
end

AB.PetBarMixin = {}

function AB.PetBarMixin:Configure()
    for i, button in ipairs(self.buttons) do
        button:SetSize(self.config.buttonSize, self.config.buttonSize)
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("LEFT", self, "LEFT")
        else
            button:SetPoint("LEFT", self.buttons[i - 1], "RIGHT", self.config.columnSpacing, 0)
        end
    end

    if self.visibility then
        RegisterStateDriver(self, "visibility", self.visibility)
    else
        self:SetShown(self.config.enabled)
    end
    self:SetSize(#self.buttons * self.config.buttonSize + (#self.buttons - 1) * self.config.columnSpacing, self.config.buttonSize)

    self:ClearAllPoints()
    self:SetNormalizedPoint(self.config.point)

    self.Backdrop:SetShown(self.config.backdrop)
    self.Border:SetShown(self.config.border)
    self.Shadow:SetShown(self.config.shadow)
    self.Mover:Unlock()
    self:CreateFader(self.config.fader, self.buttons)
end

function AB.PetBarMixin:OnEvent(event, arg1, ...)
    if event == "UNIT_PET" and arg1 ~= "player" then
        return
    elseif (event == "UNIT_FLAGS" or event == "UNIT_AURA") and arg1 ~= "pet" then
        return
    elseif not PetHasActionBar() or not UnitIsVisible("pet") then
        return
    end

    for i = 1, 10 do
        if event == "PET_BAR_UPDATE_COOLDOWN" then
            self.buttons[i]:UpdateCooldown()
        else
            self.buttons[i]:Update()
        end
    end
end

function AB:CreatePetButton(id, parent, buttonType)
    local button = CreateFrame("CheckButton", "$parent_Button" .. id, parent, "PetActionButtonTemplate")
    button:SetID(id)
    button.config = parent.config
    _G.Mixin(button, AB.PetButtonMixin)
    _G.Mixin(button, AB.KeyBoundButtonMixin)
    button:SetScript("OnEvent", nil)
    button:UnregisterAllEvents()

    button.id = id
    button.buttonType = buttonType
    button.keyBoundTarget = buttonType .. id
    
    button.cooldown = _G[button:GetName() .. "Cooldown"]
    button.autoCastable = _G[button:GetName() .. "AutoCastable"]
    button.shine = _G[button:GetName() .. "Shine"]

    AB:SecureHookScript(button, "OnEnter", button.PostOnEnter)
    AB:SecureHookScript(button, "OnEvent", button.PostOnEvent)

    button:Configure()

    return button
end

AB.PetButtonMixin = {}

function AB.PetButtonMixin:Configure()
    self:RegisterForClicks(self.config.clickOnDown and "AnyDown" or "AnyUp")

    self:SetAttribute("showgrid", self.config.showGrid and 1 or 0)
    self.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(self.keyBoundTarget)))

    R.Modules.ButtonStyles:StyleActionButton(self)
end

function AB.PetButtonMixin:Update()
    local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(self.id)

    self.tooltipName = isToken and _G[name] or name
    self.isToken = isToken

    if spellID then
        local spell = Spell:CreateFromSpellID(spellID)
        self.spellDataLoadedCancelFunc = spell:ContinueWithCancelOnSpellLoad(function()
            self.tooltipSubtext = spell:GetSpellSubtext()
        end)
    end

    if PetHasActionBar() and isActive then
        if IsPetAttackAction(self.id) then
            PetActionButton_StartFlash(self)
            self:GetCheckedTexture():SetAlpha(0.5)
        else
            PetActionButton_StopFlash(self)
            self:GetCheckedTexture():SetAlpha(1.0)
        end

        self:SetChecked(true)
    else
        PetActionButton_StopFlash(self)
        self:GetCheckedTexture():SetAlpha(1.0)
        self:SetChecked(false)
    end

    self.autoCastable:SetShown(autoCastAllowed)
    if autoCastEnabled then
        AutoCastShine_AutoCastStart(self.AutoCastShine)
    else
        AutoCastShine_AutoCastStop(self.AutoCastShine)
    end

    if texture then
        self.icon:SetTexture(isToken and _G[texture] or texture)
        if GetPetActionSlotUsable(self.id) then
            self.icon:SetVertexColor(1, 1, 1)
        else
            self.icon:SetVertexColor(0.4, 0.4, 0.4)
        end
        self.icon:Show()
    else
        self.icon:Hide()
    end

    SharedActionButton_RefreshSpellHighlight(self, HasPetActionHighlightMark(self.id))

    self:UpdateCooldown()
end

function AB.PetButtonMixin:UpdateCooldown()
    local start, duration, enable = GetPetActionCooldown(self.id)
    CooldownFrame_Set(self.cooldown, start, duration, enable)

    if (GameTooltip:GetOwner() == self) then
        PetActionButton_OnEnter(self)
    end
end

function AB.PetButtonMixin:PostOnEnter()
    R.Libs.KeyBound:Set(self)
end

function AB.PetButtonMixin:PostOnEvent(event)
    if event == "UPDATE_BINDINGS" then
        self:Configure()
    end
end
