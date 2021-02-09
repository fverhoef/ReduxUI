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
    self:SetBorderPadding(1, 1, 0, 0)
    self:CreateShadow()
    self:SetShadowPadding(1, 1, 0, 0)

    self.Update = function(self)
        UF:UpdateTank(self)
    end
end

function UF:UpdateTank(self)
end