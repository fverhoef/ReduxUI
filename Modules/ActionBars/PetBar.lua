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
        bar.buttons[id] = bar:CreateButton(id)
    end

    bar.buttons[11] = AB:CreateActionButton("$parent_Button11", bar, _G.PetDismiss, [[Interface\Icons\Spell_Shadow_SacrificialShield]], _G.PET_DISMISS)

    RegisterStateDriver(bar, "visibility", "[overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide")

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
        button:SetSize(self.config.buttonStyle.size, self.config.buttonStyle.size)
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("LEFT", self, "LEFT")
        else
            button:SetPoint("LEFT", self.buttons[i - 1], "RIGHT", self.config.columnSpacing, 0)
        end

        button:Configure()
    end

    self:SetSize(#self.buttons * self.config.buttonStyle.size + (#self.buttons - 1) * self.config.columnSpacing, self.config.buttonStyle.size)

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

function AB.PetBarMixin:CreateButton(id)
    local button = CreateFrame("CheckButton", "$parent_Button" .. id, self, "PetActionButtonTemplate")
    button:SetID(id)
    button.id = id
    button.header = self
    button.keyBoundTarget = self.config.buttonStyle.type .. id
    _G.Mixin(button, AB.PetButtonMixin)
    _G.Mixin(button, AB.KeyBoundButtonMixin)
    button:SetScript("OnEvent", nil)
    button:UnregisterAllEvents()

    button.cooldown = button.cooldown or _G[button:GetName() .. "Cooldown"]
    button.autoCastable = button.autoCastable or _G[button:GetName() .. "AutoCastable"]
    button.shine = button.shine or _G[button:GetName() .. "Shine"]

    AB:SecureHookScript(button, "OnEnter", button.PostOnEnter)
    AB:SecureHookScript(button, "OnEvent", button.PostOnEvent)

    button:Configure()

    return button
end

AB.PetButtonMixin = {}

function AB.PetButtonMixin:Configure()
    self:RegisterForClicks(self.header.config.buttonStyle.clickOnDown and "AnyDown" or "AnyUp")
    self:SetAttribute("buttonlock", true)
    self:SetAttribute("checkselfcast", self.header.config.buttonStyle.checkSelfCast)
    self:SetAttribute("checkfocuscast", self.header.config.buttonStyle.checkFocusCast)
    self:SetAttribute("checkmouseovercast", self.header.config.buttonStyle.checkMouseoverCast)
    self:SetAttribute("showgrid", self.header.config.showGrid and 1 or 0)
    self.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(self.keyBoundTarget)))
    self.HotKey:SetShown(self.header.config.buttonStyle.hideKeybindText)
    self.Name:SetShown(self.header.config.buttonStyle.hideMacroText)

    self:ApplyStyle()
end

function AB.PetButtonMixin:ApplyStyle()
    if not self.__styled then
        self.__styled = true

        self.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        self.icon:SetInside(self, 2, 2)

        self.raisedContainer = CreateFrame("Frame", nil, self)
        self.raisedContainer:SetAllPoints()
        self.raisedContainer:SetFrameLevel(self:GetFrameLevel() + 1)

        self.cooldown:SetInside(self, 2, 2)
        self.cooldown:SetSwipeColor(0, 0, 0)

        self.Count:SetParent(self.raisedContainer)
        self.HotKey:SetParent(self.raisedContainer)
        self.Name:SetParent(self.raisedContainer)

        self:CreateBackdrop({ bgFile = R.media.textures.buttons.backdrop, edgeSize = 2, insets = { left = 2, right = 2, top = 2, bottom = 2 } })
    end

    self:SetNormalTexture(R.media.textures.buttons.border)
    local normalTexture = self:GetNormalTexture()
    normalTexture:SetOutside(self, 4, 4)
    normalTexture:SetTexCoord(0, 1, 0, 1)
    normalTexture:SetVertexColor(0.7, 0.7, 0.7)

    self:SetPushedTexture(R.media.textures.buttons.border)
    local pushedTexture = self:GetPushedTexture()
    pushedTexture:SetOutside(self, 4, 4)
    pushedTexture:SetTexCoord(0, 1, 0, 1)
    pushedTexture:SetVertexColor(1, 0.78, 0, 1)

    self:GetCheckedTexture():SetOutside(self, 2, 2)
    self:GetHighlightTexture():SetInside(self, 0, 0)
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
