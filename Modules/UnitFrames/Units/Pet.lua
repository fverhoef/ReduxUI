local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPet()
    local config = UF.config.pet
    local default = UF.defaults.pet

    if config.enabled then return UF:SpawnFrame("Pet", "pet", UF.CreatePet, config, default) end
end

function UF:CreatePet()
    self.config = UF.config.pet
    self.defaults = UF.defaults.pet

    self:InitializeFrame()

    self.Update = UF.UpdatePet
end

function UF:UpdatePet()
    if not self then return end

    self:ConfigureFrame()
end