local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local L = R.L

function UF:StyleAuraFrames()
    if not UF.config.auraFrames.enabled then
        return
    end

    BuffFrame.config = UF.config.auraFrames.buffs
    BuffFrame.defaults = UF.defaults.auraFrames.buffs
    BuffFrame:ClearAllPoints()
    BuffFrame:SetNormalizedPoint(unpack(UF.config.auraFrames.buffs.point))
    BuffFrame:CreateMover(R.isRetail and L["Buffs"] or L["Buffs & Debuffs"], UF.defaults.auraFrames.buffs.point, 400, 50, { "TOPRIGHT", BuffFrame, "TOPRIGHT" })
    if not BuffFrame.Update then
        BuffFrame.Update = BuffFrame_Update
    end
    UF:SecureHook(BuffFrame, "Update", UF.AuraFrame_Update)

    if DebuffFrame then
        DebuffFrame.config = UF.config.auraFrames.debuffs
        DebuffFrame.defaults = UF.defaults.auraFrames.debuffs
        DebuffFrame:ClearAllPoints()
        DebuffFrame:SetNormalizedPoint(unpack(UF.config.auraFrames.debuffs.point))
        DebuffFrame:CreateMover(L["Debuffs"], UF.defaults.auraFrames.debuffs.point, 400, 50, { "TOPRIGHT", DebuffFrame, "TOPRIGHT" })
        UF:SecureHook(DebuffFrame, "Update", UF.AuraFrame_Update)
    end

    if DeadlyDebuffFrame and TODO then
        DeadlyDebuffFrame.config = UF.config.auraFrames.deadlyDebuffs
        DeadlyDebuffFrame.defaults = UF.defaults.auraFrames.deadlyDebuffs
        DeadlyDebuffFrame:ClearAllPoints()
        DeadlyDebuffFrame:SetNormalizedPoint(unpack(UF.config.auraFrames.deadlyDebuffs.point))
        DeadlyDebuffFrame:CreateMover(L["Debuffs"], UF.defaults.auraFrames.deadlyDebuffs.point, 400, 50, { "TOPRIGHT", DebuffFrame, "TOPRIGHT" })
        UF:SecureHook(DeadlyDebuffFrame, "Update", UF.AuraFrame_Update)
    end

    UF:SecureHook(nil, "UIParent_UpdateTopFramePositions", UF.UIParent_UpdateTopFramePositions)

    if EditModeManagerFrame then
        EditModeManagerFrame.AccountSettings.RefreshAuraFrame = nop
    end
    if R.isRetail then
        for _, aura in ipairs(self.auraFrames) do
            _G.Mixin(aura, AuraStyleMixin)
            aura.config = UF.config.auraFrames.buffs
        end
    else
        local button
        for i = 1, _G.BUFF_MAX_DISPLAY do
            button = _G["BuffButton" .. i]
            if button then
                _G.Mixin(button, AuraStyleMixin)
                button.config = UF.config.auraFrames.buffs
            end
        end
        for i = 1, _G.DEBUFF_MAX_DISPLAY do
            button = _G["DebuffButton" .. i]
            if button then
                _G.Mixin(button, AuraStyleMixin)
                button.config = UF.config.auraFrames.debuffs
            end
        end
        for i = 1, _G.NUM_TEMP_ENCHANT_FRAMES do
            button = _G["TempEnchant" .. i]
            if button then
                _G.Mixin(button, AuraStyleMixin)
                button.config = UF.config.auraFrames.tempEnchants
            end
        end
    end
end

function UF:UIParent_UpdateTopFramePositions()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetNormalizedPoint(unpack(UF.config.auraFrames.buffs.point))
    BuffFrame:ClearAllPoints()
    BuffFrame:SetNormalizedPoint(unpack(UF.config.auraFrames.buffs.point))
end

function UF:AuraFrame_Update()
    if R.isRetail then
        for _, aura in ipairs(self.auraFrames) do
            aura:ApplyStyle()
        end
    else
        local button
        for i = 1, _G.BUFF_MAX_DISPLAY do
            button = _G["BuffButton" .. i]
            if button then
                button.isBuff = true
                button.isDebuff = false
                button.isTempEnchant = false
                button.buffType = select(4, UnitAura("player", i, "HELPFUL"))
                button.debuffType = nil
                button:ApplyStyle()
            end
        end
        for i = 1, _G.DEBUFF_MAX_DISPLAY do
            button = _G["DebuffButton" .. i]
            if button then
                button.isBuff = false
                button.isDebuff = true
                button.isTempEnchant = false
                button.buffType = nil
                button.debuffType = select(4, UnitAura("player", i, "HARMFUL"))
                button:ApplyStyle()
            end
        end
        for i = 1, _G.NUM_TEMP_ENCHANT_FRAMES do
            button = _G["TempEnchant" .. i]
            if button then
                button.isBuff = false
                button.isDebuff = false
                button.isTempEnchant = true
                button.buffType = nil
                button.debuffType = nil
                button:ApplyStyle()
            end
        end
    end
end
