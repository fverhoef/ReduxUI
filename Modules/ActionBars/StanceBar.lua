local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateStanceBar()
    local bar = CreateFrame("Frame", addonName .. "_StanceBar", UIParent, "SecureHandlerStateTemplate")
    bar.config = AB.config.stanceBar
    bar.defaults = AB.defaults.stanceBar
    bar.buttons = {}
    bar:SetFrameStrata("LOW")
    _G.Mixin(bar, ActionBarMixin)
    _G.Mixin(bar, StanceBarMixin)

    for id = 1, 10 do
        bar.buttons[id] = AB:CreateStanceButton(id, bar, bar.config.keyBoundTarget .. id)
    end

    bar.visibility = "[overridebar][vehicleui][possessbar] hide; show"
    RegisterStateDriver(bar, "visibility", bar.visibility)

    bar:SetScript("OnEvent", StanceBarMixin.OnEvent)

    bar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    bar:RegisterEvent("PLAYER_ENTERING_WORLD")
    bar:RegisterEvent("PLAYER_REGEN_ENABLED")
    bar:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
    if R.isRetail then
        bar:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
        bar:RegisterEvent("UPDATE_POSSESS_BAR")
        bar:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
    end
    bar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
    bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    bar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
    bar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")

    bar:CreateBackdrop({ bgFile = R.media.textures.blank })
    bar:CreateBorder()
    bar:CreateShadow()
    bar:CreateFader(bar.config.fader, bar.buttons)
    bar:CreateMover(L["Stance Bar"], bar.defaults.point)

    return bar
end

StanceBarMixin = {}

function StanceBarMixin:OnEvent(event)
    self:Update()
end

function StanceBarMixin:Update()
    if InCombatLockdown() then
        self.needsUpdate = true
    else
        self.needsUpdate = nil
        local numForms = GetNumShapeshiftForms()
        for i, button in ipairs(self.buttons) do
            button:SetShown(i <= numForms)
        end
    end

    for i, button in ipairs(self.buttons) do
        button:Update()
    end
end

function AB:CreateStanceButton(id, parent, keyBoundTarget)
    local button = CreateFrame("CheckButton", "$parent_Button" .. id, parent, "StanceButtonTemplate")
    button:SetID(id)
    button.config = parent.config
    _G.Mixin(button, StanceButtonMixin)

    button.id = id

    if keyBoundTarget then
        _G.Mixin(button, KeyBoundButtonMixin)

        button.keyBoundTarget = keyBoundTarget
        AB:SecureHookScript(button, "OnEnter", function(self)
            R.Libs.KeyBound:Set(self)
        end)
    end

    button:Configure()

    return button
end

StanceButtonMixin = {}

function StanceButtonMixin:Update()
    if not self:IsShown() then
        return
    end

    local texture, isActive, isCastable = GetShapeshiftFormInfo(self.id)

    self.icon:SetTexture(texture)
    self.icon:SetDesaturated(not isCastable)
    self.icon:SetVertexColor(unpack(isCastable and { 1.0, 1.0, 1.0 } or { 0.4, 0.4, 0.4 }))
    self.cooldown:SetShown(texture ~= nil)

    local start, duration, enable = GetShapeshiftFormCooldown(self.id)
    CooldownFrame_Set(self.cooldown, start, duration, enable)

    self:SetChecked(isActive)

    self:Configure()
end

function StanceButtonMixin:Configure()
    self:RegisterForClicks(self.config.clickOnDown and "AnyDown" or "AnyUp")

    self.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(self.keyBoundTarget)))
    self.HotKey:SetShown(not self.config.hideHotkey)

    R.Modules.ButtonStyles:StyleActionButton(self)
end
