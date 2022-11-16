local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTargetTarget()
    return UF:SpawnFrame("TargetTarget", "targettarget", TargetTargetMixin, UF.config.targettarget, UF.defaults.targettarget)
end

TargetTargetMixin = {}
