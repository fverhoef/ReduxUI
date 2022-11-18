local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:StyleBuffFrame()
    _G.BuffFrame.config = UF.config.buffFrame
    _G.BuffFrame.defaults = UF.defaults.buffFrame
    _G.BuffFrame:ClearAllPoints()
    _G.BuffFrame:SetNormalizedPoint(unpack(UF.config.buffFrame.point))
    _G.BuffFrame:CreateMover("Buffs & Debuffs", UF.defaults.buffFrame.point, 400, 200, {"TOPRIGHT", _G.BuffFrame, "TOPRIGHT"})
    UF:SecureHook(nil, "UIParent_UpdateTopFramePositions", UF.UIParent_UpdateTopFramePositions)
    UF:SecureHook("BuffFrame_Update", UF.BuffFrame_Update)
end

function UF:UIParent_UpdateTopFramePositions()
    _G.BuffFrame:ClearAllPoints()
    _G.BuffFrame:SetNormalizedPoint(unpack(UF.config.buffFrame.point))
end

function UF:BuffFrame_Update()
    local button
    for i = 1, _G.BUFF_MAX_DISPLAY do
        button = _G["BuffButton" .. i]
        if button then
            button:SetSize(UF.config.buffFrame.buffs.iconSize, UF.config.buffFrame.buffs.iconSize)
        end
    end
    for i = 1, _G.DEBUFF_MAX_DISPLAY do
        button = _G["DebuffButton" .. i]
        if button then
            button:SetSize(UF.config.buffFrame.debuffs.iconSize, UF.config.buffFrame.debuffs.iconSize)
        end
    end
    for i = 1, _G.NUM_TEMP_ENCHANT_FRAMES do
        button = _G["TempEnchant" .. i]
        if button then
            button:SetSize(UF.config.buffFrame.tempEnchants.iconSize, UF.config.buffFrame.tempEnchants.iconSize)
        end
    end
end