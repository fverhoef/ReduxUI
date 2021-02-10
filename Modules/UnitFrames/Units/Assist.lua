local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnAssistHeader()
end

function UF:UpdateAssistHeader()
end

function UF:CreateAssist()
    self.cfg = UF.config.assist

    self:CreateBorder(self.cfg.border.size)
    self:CreateShadow()

    self.Update = function(self)
        UF:UpdateAssist(self)
    end
end

function UF:UpdateAssist()
end