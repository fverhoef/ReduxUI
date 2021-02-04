local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnAssistHeader()
end

function UF:UpdateAssistHeader()
end

function UF:CreateAssist()
    self.cfg = R.config.db.profile.modules.unitFrames.assist

    self:CreateBorder(self.cfg.border.size)
    self:SetBorderPadding(1, 1, 0, 0)
    self:CreateShadow()
    self:SetShadowPadding(1, 1, 0, 0)
end

function UF:UpdateAssist()
end