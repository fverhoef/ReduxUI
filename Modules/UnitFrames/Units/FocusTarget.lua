local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocusTarget()
    return UF:SpawnFrame("FocusTarget", "focustarget", FocusTargetMixin, UF.config.focustarget, UF.defaults.focustarget)
end

FocusTargetMixin = {}
