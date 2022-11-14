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
    _G.Mixin(bar, PetBarMixin)

    for i = 1, 10 do
        local button = CreateFrame("CheckButton", "$parent_Button" .. i, bar, "PetActionButtonTemplate")
        button:SetID(i)
        button:SetScript("OnEvent", nil)
        button:SetScript("OnUpdate", nil)
        button:UnregisterAllEvents()

        _G.Mixin(button, PetButtonMixin)
        _G.Mixin(button, KeyBoundButtonMixin)

        button.keyBoundTarget = bar.config.keyBoundTarget .. i
        AB:SecureHookScript(button, "OnEnter", function(self)
            R.Libs.KeyBound:Set(self)
        end)

        button:Update()
        bar.buttons[i] = button

        R.Modules.ButtonStyles:StyleActionButton(button)
    end

    local dismissButton = R.Libs.ActionButton:CreateButton(11, "$parent_Button11", bar, nil)
    dismissButton:SetState(0, "custom", {
        func = function()
            PetDismiss()
        end,
        texture = [[Interface\Icons\Spell_Shadow_SacrificialShield]],
        tooltip = _G.PET_DISMISS
    })
    bar.buttons[11] = dismissButton
    R.Modules.ButtonStyles:StyleActionButton(dismissButton)

    bar.visibility = "[overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide"
    RegisterStateDriver(bar, "visibility", bar.visibility)

    bar:SetScript("OnEvent", function(self, event, arg1)
        if event == "PET_BAR_UPDATE" or event == "PET_SPECIALIZATION_CHANGED" or event == "PET_UI_UPDATE" or (event == "UNIT_PET" and arg1 == "player") or
            ((event == "UNIT_FLAGS" or event == "UNIT_AURA") and arg1 == "pet") or event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED" or
            event == "PET_BAR_UPDATE_COOLDOWN" then
            for i = 1, 10 do
                self.buttons[i]:Update()
            end
        end
    end)

    bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
    bar:RegisterEvent("PET_BAR_UPDATE")
    if R.isRetail then
        bar:RegisterEvent("PET_SPECIALIZATION_CHANGED")
    end
    bar:RegisterEvent("PLAYER_CONTROL_GAINED")
    bar:RegisterEvent("PLAYER_CONTROL_LOST")
    bar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
    bar:RegisterEvent("UNIT_AURA")
    bar:RegisterEvent("UNIT_FLAGS")
    bar:RegisterEvent("UNIT_PET")

    bar:CreateBackdrop({ bgFile = R.media.textures.blank })
    bar:CreateBorder()
    bar:CreateShadow()
    bar:CreateFader(bar.config.fader, bar.buttons)
    bar:CreateMover(L["Pet Bar"], bar.defaults.point)

    return bar
end

PetBarMixin = {}

function PetBarMixin:Update()
    for _, button in ipairs(self.buttons) do
        if button.Update then
            button:Update()
        end
    end
end

PetButtonMixin = {}

function PetButtonMixin:Update()
    local id = self:GetID()
    local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(id)

    self.tooltipName = isToken and _G[name] or name
    self.isToken = isToken
    self.icon:SetTexture(isToken and _G[texture] or texture)
    self.icon:SetShown(texture ~= nil)

    if spellID then
        self.tooltipSubtext = GetSpellSubtext(spellID)
    end

    if PetHasActionBar() and isActive then
        if IsPetAttackAction(id) then
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

    _G[self:GetName() .. "AutoCastable"]:SetShown(autoCastAllowed)
    if autoCastEnabled then
        AutoCastShine_AutoCastStart(self.AutoCastShine)
    else
        AutoCastShine_AutoCastStop(self.AutoCastShine)
    end

    self.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(self.keyBoundTarget)))
    self.HotKey:Show()
end
