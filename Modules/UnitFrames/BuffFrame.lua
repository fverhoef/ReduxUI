local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:StyleBuffFrame()
    _G.BuffFrame.config = UF.config.buffFrame
    _G.BuffFrame:ClearAllPoints()
    _G.BuffFrame:Point(unpack(UF.config.buffFrame.point))
    R:CreateDragFrame(_G.BuffFrame, "Buffs & Debuffs", UF.defaults.buffFrame.point, 400, 200, {"TOPRIGHT", _G.BuffFrame, "TOPRIGHT"})
    UF:SecureHook(nil, "UIParent_UpdateTopFramePositions", UF.UIParent_UpdateTopFramePositions)
end

function UF:UIParent_UpdateTopFramePositions()
    _G.BuffFrame:ClearAllPoints()
    _G.BuffFrame:Point(unpack(UF.config.buffFrame.point))
end