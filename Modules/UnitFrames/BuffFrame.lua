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

    if R.isRetail then
        UF:SecureHook(BuffFrame, "Update", UF.UpdateAuraFrames)

        DebuffFrame.config = UF.config.auraFrames.debuffs
        DebuffFrame.defaults = UF.defaults.auraFrames.debuffs
        DebuffFrame:ClearAllPoints()
        DebuffFrame:SetNormalizedPoint(unpack(UF.config.auraFrames.debuffs.point))
        DebuffFrame:CreateMover(L["Debuffs"], UF.defaults.auraFrames.debuffs.point, 400, 50, { "TOPRIGHT", DebuffFrame, "TOPRIGHT" })
        UF:SecureHook(DebuffFrame, "Update", UF.UpdateAuraFrames)
    else
        UF:SecureHook("BuffFrame_Update", UF.UpdateAuraFrames)
    end

    UF:SecureHook(nil, "UIParent_UpdateTopFramePositions", UF.UIParent_UpdateTopFramePositions)

    if EditModeManagerFrame and EditModeManagerFrame.AccountSettings then
        EditModeManagerFrame.AccountSettings.RefreshAuraFrame = nop
    end
end

function UF:UIParent_UpdateTopFramePositions()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetNormalizedPoint(unpack(UF.config.auraFrames.buffs.point))
    BuffFrame:ClearAllPoints()
    BuffFrame:SetNormalizedPoint(unpack(UF.config.auraFrames.buffs.point))
end

function UF:UpdateAuraFrames()
    if R.isRetail then
        for _, aura in ipairs(self.auraFrames) do
            aura.isTempEnchant = aura.buttonInfo.isTempEnchant
            aura.isBuff = not aura.isTempEnchant and aura:GetFilter() == "HELPFUL"
            aura.isDebuff = aura.isTempEnchant and not aura.isBuff
            aura.buffType = aura.isBuff and aura.buttonInfo.debuffType
            aura.debuffType = aura.isDebuff and aura.buttonInfo.debuffType
            if not aura.ApplyStyle then
                _G.Mixin(aura, AuraStyleMixin)
                aura.config = UF.config.auraFrames.buffs -- TODO: distinguish between buffs/debuffs etc
            end
            aura:SetNormalizedSize(aura.config.iconSize)
            aura:ApplyStyle()
        end
    else
        local button
        for i = 1, _G.BUFF_MAX_DISPLAY do
            button = _G["BuffButton" .. i]
            if button then
                button.isTempEnchant = false
                button.isBuff = true
                button.isDebuff = false
                button.buffType = select(4, UnitAura("player", i, "HELPFUL"))
                button.debuffType = nil
                if not button.ApplyStyle then
                    _G.Mixin(button, AuraStyleMixin)
                    button.config = UF.config.auraFrames.buffs
                end
                button:SetNormalizedSize(button.config.iconSize)
                button:ApplyStyle()
            end
        end
        for i = 1, _G.DEBUFF_MAX_DISPLAY do
            button = _G["DebuffButton" .. i]
            if button then
                button.isTempEnchant = false
                button.isBuff = false
                button.isDebuff = true
                button.buffType = nil
                button.debuffType = select(4, UnitAura("player", i, "HARMFUL"))
                if not button.ApplyStyle then
                    _G.Mixin(button, AuraStyleMixin)
                    button.config = UF.config.auraFrames.debuffs
                end
                button:SetNormalizedSize(button.config.iconSize)
                button:ApplyStyle()
            end
        end
        for i = 1, _G.NUM_TEMP_ENCHANT_FRAMES do
            button = _G["TempEnchant" .. i]
            if button then
                button.isTempEnchant = true
                button.isBuff = false
                button.isDebuff = false
                button.buffType = nil
                button.debuffType = nil
                if not button.ApplyStyle then
                    _G.Mixin(button, AuraStyleMixin)
                    button.config = UF.config.auraFrames.tempEnchants
                end
                button:SetNormalizedSize(button.config.iconSize)
                button:ApplyStyle()
            end
        end
    end
end
