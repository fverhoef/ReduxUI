local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateStanceBar()
    local bar = CreateFrame("Frame", addonName .. "_StanceBar", UIParent, "SecureHandlerStateTemplate")
    bar:SetFrameStrata("LOW")
    bar.config = AB.config.stanceBar
    bar.buttons = {}

    for i = 1, 10 do
        local button = CreateFrame("CheckButton", "$parent_Button" .. i, bar, "StanceButtonTemplate")
        button:SetID(i)
        button:SetScript("OnEvent", nil)
        button:SetScript("OnUpdate", nil)
        button:UnregisterAllEvents()
        R.Modules.ButtonStyles:StyleActionButton(button)
        button.keyBoundTarget = bar.config.keyBoundTarget .. i
        AB:UpdateStanceButton(button)

        button:SetScript("OnEnter", function(self)
            R.Libs.KeyBound:Set(self)
        end)

        bar.buttons[i] = button
    end

    bar.visibility = "[overridebar][vehicleui][possessbar] hide; show"
    RegisterStateDriver(bar, "visibility", bar.visibility)

    bar:SetScript("OnEvent", function(self, event)
        if event == "UPDATE_SHAPESHIFT_COOLDOWN" then
            AB:UpdateStanceBar(self)
        elseif event == "PLAYER_REGEN_ENABLED" then
            if self.needsUpdate and not InCombatLockdown() then
                self.needsUpdate = nil
                AB:UpdateStanceButtonVisibility(self)
            end
        else
            if InCombatLockdown() then
                self.needsUpdate = true
                AB:UpdateStanceBar(self)
            else
                AB:UpdateStanceButtonVisibility(self)
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

    bar.Update = function(self) AB:UpdateStanceButtonVisibility(self) end

    R:CreateBackdrop(bar, {bgFile = R.media.textures.blank})
    R:CreateBorder(bar)
    R:CreateShadow(bar)
    R:CreateFader(bar, bar.config.fader, bar.buttons)
    R:CreateDragFrame(bar, bar:GetName(), AB.defaults.stanceBar.point)

    return bar
end

function AB:UpdateStanceBar(bar) for _, button in ipairs(bar.buttons) do AB:UpdateStanceButton(button) end end

function AB:UpdateStanceButtonVisibility(bar)
    local numForms = GetNumShapeshiftForms()
    for i, button in ipairs(bar.buttons) do button:SetShown(i <= numForms) end
    AB:UpdateStanceBar(bar)
end

function AB:UpdateStanceButton(button)
    if not button:IsShown() then return end

    local id = button:GetID()
    local texture, isActive, isCastable = GetShapeshiftFormInfo(id)

    button.icon:SetTexture(texture)
    button.icon:SetDesaturated(not isCastable)
    button.icon:SetVertexColor(unpack(isCastable and {1.0, 1.0, 1.0} or {0.4, 0.4, 0.4}))
    button.cooldown:SetShown(texture ~= nil)

    button:SetChecked(isActive)

    button.HotKey:SetVertexColor(1.0, 1.0, 1.0)
    button.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(button.keyBoundTarget)))
    button.HotKey:Show()
end
