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
    _G.Mixin(bar, StanceBarMixin)

    for i = 1, 10 do
        local button = CreateFrame("CheckButton", "$parent_Button" .. i, bar, "StanceButtonTemplate")
        button:SetID(i)
        button:SetScript("OnEvent", nil)
        button:SetScript("OnUpdate", nil)
        button:UnregisterAllEvents()

        _G.Mixin(button, StanceButtonMixin)
        _G.Mixin(button, KeyBoundButtonMixin)

        button.keyBoundTarget = bar.config.keyBoundTarget .. i
        AB:SecureHookScript(button, "OnEnter", function(self)
            R.Libs.KeyBound:Set(self)
        end)

        button:Update()
        bar.buttons[i] = button

        R.Modules.ButtonStyles:StyleActionButton(button)
    end

    bar.visibility = "[overridebar][vehicleui][possessbar] hide; show"
    RegisterStateDriver(bar, "visibility", bar.visibility)

    bar:SetScript("OnEvent", function(self, event)
        if event == "UPDATE_SHAPESHIFT_COOLDOWN" then
            self:Update()
        elseif event == "PLAYER_REGEN_ENABLED" then
            if self.needsUpdate and not InCombatLockdown() then
                self.needsUpdate = nil
                self:UpdateStanceButtonVisibility()
            end
        else
            if InCombatLockdown() then
                self.needsUpdate = true
                self:Update()
            else
                self:UpdateStanceButtonVisibility()
            end
        end
    end)

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

function StanceBarMixin:Update()
    for _, button in ipairs(self.buttons) do
        button:Update()
    end
end

function StanceBarMixin:UpdateStanceButtonVisibility()
    local numForms = GetNumShapeshiftForms()
    for i, button in ipairs(self.buttons) do
        button:SetShown(i <= numForms)
    end
    self:Update()
end

StanceButtonMixin = {}

function StanceButtonMixin:Update()
    if not self:IsShown() then
        return
    end

    local id = self:GetID()
    local texture, isActive, isCastable = GetShapeshiftFormInfo(id)

    self.icon:SetTexture(texture)
    self.icon:SetDesaturated(not isCastable)
    self.icon:SetVertexColor(unpack(isCastable and { 1.0, 1.0, 1.0 } or { 0.4, 0.4, 0.4 }))
    self.cooldown:SetShown(texture ~= nil)

    self:SetChecked(isActive)

    self.HotKey:SetVertexColor(1.0, 1.0, 1.0)
    self.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(self.keyBoundTarget)))
    self.HotKey:Show()
end
