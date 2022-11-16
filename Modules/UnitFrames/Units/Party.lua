local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPartyHeader()
    return UF:SpawnHeader("Party", 1, PartyMixin, UF.config.party, UF.defaults.party)
end

PartyMixin = {}
