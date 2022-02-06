local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTankHeader()
    local config = UF.config.tank
    if not config.enabled then return end

    return UF:SpawnHeader("Tank", 1, config, UF.defaults.tank, UF.CreateTank, "MAINTANK")
end

function UF:CreateTank()
    self.config = UF.config.tank
    self.defaults = UF.defaults.tank
    self.isGroupUnit = true

    self:InitializeFrame()

    self.Update = UF.UpdateTank
end

function UF:UpdateTank()
    if not self then return end

    self:ConfigureFrame()
end