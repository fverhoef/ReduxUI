local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnBossHeader()
    return UF:SpawnUnitFrameGroup("Boss", "boss", MAX_BOSS_FRAMES, BossMixin, UF.config.boss, UF.defaults.boss)
end

BossMixin = {}
