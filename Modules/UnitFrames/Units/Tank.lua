local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTankHeader()
end

function UF:UpdateTankHeader()
end

function UF:CreateTank()
    self.config = UF.config.tank
    self.defaults = UF.defaults.tank
    self.isGroupUnit = true

    UF:SetupFrame(self)

    self.Update = UF.UpdateTank
end

function UF:UpdateTank()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end