local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTankHeader()
    return UF:SpawnHeader("Tank", 1, TankMixin, UF.config.tank, UF.defaults.tank, "MAINTANK")
end

TankMixin = {}
