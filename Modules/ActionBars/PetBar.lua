local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreatePetBar()
    local bar = CreateFrame("Frame", addonName .. "_PetBar", UIParent, "SecureHandlerStateTemplate")
    bar:SetFrameStrata("LOW")
    bar.config = AB.config.petBar
    bar.buttons = {}

    for i = 1, 10 do
        local button = CreateFrame("CheckButton", "$parent_Button" .. i, bar, "PetActionButtonTemplate")
        button:SetID(i)
        button:SetScript("OnEvent", nil)
        button:SetScript("OnUpdate", nil)
        button:UnregisterAllEvents()
        R.Modules.ButtonStyles:StyleActionButton(button)
        button.keyBoundTarget = bar.config.keyBoundTarget .. i
        AB:UpdatePetButton(button)

        AB:SecureHookScript(button, "OnEnter", function(self)
            R.Libs.KeyBound:Set(self)
        end)

        bar.buttons[i] = button
    end

    local dismissButton = R.Libs.ActionButton:CreateButton(11, "$parent_Button11", bar, nil)
    dismissButton:SetState(0, "custom", {func = function() PetDismiss() end, texture = [[Interface\Icons\Spell_Shadow_SacrificialShield]], tooltip = _G.PET_DISMISS})
    bar.buttons[11] = dismissButton
    R.Modules.ButtonStyles:StyleActionButton(dismissButton)

    bar.visibility = "[overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide"
    RegisterStateDriver(bar, "visibility", bar.visibility)

    bar:SetScript("OnEvent", function(self, event, arg1)
        if event == "PET_BAR_UPDATE" or event == "PET_SPECIALIZATION_CHANGED" or event == "PET_UI_UPDATE" or (event == "UNIT_PET" and arg1 == "player") or
            ((event == "UNIT_FLAGS" or event == "UNIT_AURA") and arg1 == "pet") or event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED" or
            event == "PET_BAR_UPDATE_COOLDOWN" then for i = 1, 10 do AB:UpdatePetButton(self.buttons[i]) end end
    end)

    bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
    bar:RegisterEvent("PET_BAR_UPDATE")
    if R.isRetail then bar:RegisterEvent("PET_SPECIALIZATION_CHANGED") end
    bar:RegisterEvent("PLAYER_CONTROL_GAINED")
    bar:RegisterEvent("PLAYER_CONTROL_LOST")
    bar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
    bar:RegisterEvent("UNIT_AURA")
    bar:RegisterEvent("UNIT_FLAGS")
    bar:RegisterEvent("UNIT_PET")

    R:CreateBackdrop(bar, {bgFile = R.media.textures.blank})
    R:CreateBorder(bar)
    R:CreateShadow(bar)
    R:CreateFader(bar, bar.config.fader, bar.buttons)
    R:CreateDragFrame(bar, bar:GetName(), AB.defaults.petBar)

    return bar
end

function AB:UpdatePetButton(button)
    local id = button:GetID()
    local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(id)

    button.tooltipName = isToken and _G[name] or name
    button.isToken = isToken
    button.icon:SetTexture(isToken and _G[texture] or texture)
    button.icon:SetShown(texture ~= nil)

    if spellID then button.tooltipSubtext = GetSpellSubtext(spellID) end

    if PetHasActionBar() and isActive then
        if IsPetAttackAction(id) then
            PetActionButton_StartFlash(button)
            button:GetCheckedTexture():SetAlpha(0.5)
        else
            PetActionButton_StopFlash(button)
            button:GetCheckedTexture():SetAlpha(1.0)
        end

        button:SetChecked(true)
    else
        PetActionButton_StopFlash(button)
        button:GetCheckedTexture():SetAlpha(1.0)
        button:SetChecked(false)
    end

    _G[button:GetName() .. "AutoCastable"]:SetShown(autoCastAllowed)
    if autoCastEnabled then
        AutoCastShine_AutoCastStart(button.AutoCastShine)
    else
        AutoCastShine_AutoCastStop(button.AutoCastShine)
    end

    button.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(button.keyBoundTarget)))
    button.HotKey:Show()
end