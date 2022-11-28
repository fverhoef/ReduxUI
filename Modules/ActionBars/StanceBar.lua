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
    _G.Mixin(bar, AB.ActionBarMixin)
    _G.Mixin(bar, AB.StanceBarMixin)

    for id = 1, 10 do
        bar.buttons[id] = AB:CreateStanceButton(id, bar, bar.config.buttonType)
    end

    bar.visibility = "[overridebar][vehicleui][possessbar] hide; show"
    RegisterStateDriver(bar, "visibility", bar.visibility)

    bar:SetScript("OnEvent", bar.OnEvent)

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

AB.StanceBarMixin = {}

function AB.StanceBarMixin:Configure()
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

function AB.StanceBarMixin:OnEvent(event)
    self:Update()
end

function AB.StanceBarMixin:Update()
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

function AB:CreateStanceButton(id, parent, buttonType)
    local button = CreateFrame("CheckButton", "$parent_Button" .. id, parent, "StanceButtonTemplate")
    button:SetID(id)
    button.config = parent.config
    _G.Mixin(button, AB.StanceButtonMixin)
    _G.Mixin(button, AB.KeyBoundButtonMixin)

    button.id = id
    button.buttonType = buttonType
    button.keyBoundTarget = buttonType .. id
    
    button.cooldown = _G[button:GetName() .. "Cooldown"]

    AB:SecureHookScript(button, "OnEnter", button.PostOnEnter)
    AB:SecureHookScript(button, "OnEvent", button.PostOnEvent)

    button:Configure()

    return button
end

AB.StanceButtonMixin = {}

function AB.StanceButtonMixin:Configure()
    self:RegisterForClicks(self.config.clickOnDown and "AnyDown" or "AnyUp")

    self:SetAttribute("showgrid", self.config.showGrid and 1 or 0)
    self.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(self.keyBoundTarget)))

    R.Modules.ButtonStyles:StyleActionButton(self)
end

function AB.StanceButtonMixin:Update()
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

function AB.StanceButtonMixin:PostOnEnter()
    R.Libs.KeyBound:Set(self)
end

function AB.StanceButtonMixin:PostOnEvent(event)
    if event == "UPDATE_BINDINGS" then
        self:Configure()
    end
end
