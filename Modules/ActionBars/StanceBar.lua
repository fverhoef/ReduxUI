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
        bar.buttons[id] = bar:CreateButton(id)
    end

    RegisterStateDriver(bar, "visibility", "[overridebar][vehicleui][possessbar] hide; show")

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

function AB.StanceBarMixin:CreateButton(id)
    local button = CreateFrame("CheckButton", "$parent_Button" .. id, self, "StanceButtonTemplate")
    button:SetID(id)
    button.id = id
    button.header = self
    button.keyBoundTarget = self.config.buttonStyle.type .. id
    _G.Mixin(button, AB.StanceButtonMixin)
    _G.Mixin(button, AB.KeyBoundButtonMixin)
    
    button.cooldown = _G[button:GetName() .. "Cooldown"]

    AB:SecureHookScript(button, "OnEnter", button.PostOnEnter)
    AB:SecureHookScript(button, "OnEvent", button.PostOnEvent)

    button:Configure()

    return button
end

AB.StanceButtonMixin = {}

function AB.StanceButtonMixin:Configure()
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

function AB.StanceButtonMixin:ApplyStyle()
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
end

function AB.StanceButtonMixin:PostOnEnter()
    R.Libs.KeyBound:Set(self)
end

function AB.StanceButtonMixin:PostOnEvent(event)
    if event == "UPDATE_BINDINGS" then
        self:Configure()
    end
end
