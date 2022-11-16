local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocus()
    return UF:SpawnFrame("Focus", "focus", FocusMixin, UF.config.focus, UF.defaults.focus)
end

FocusMixin = {}
