local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPet()
    return UF:SpawnFrame("Pet", "pet", PetMixin, UF.config.pet, UF.defaults.pet)
end

PetMixin = {}
