local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTankHeader()
end

function UF:UpdateTankHeader()
end

function UF:CreateTank()
    self.cfg = UF.config.tank

    self:CreateBorder(self.cfg.border.size)
    self:CreateShadow()

    self.Update = function(self)
        UF:UpdateTank(self)
    end
end

function UF:UpdateTank(self)
end