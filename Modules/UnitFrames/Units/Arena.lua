local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnArenaHeader()
    return UF:SpawnUnitFrameGroup("Arena", "arena", 5, ArenaMixin, UF.config.arena, UF.defaults.arena)
end

ArenaMixin = {}
