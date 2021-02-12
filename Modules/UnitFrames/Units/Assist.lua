local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnAssistHeader()
end

function UF:UpdateAssistHeader()
end

function UF:CreateAssist()
    self.config = UF.config.assist
    self.defaults = UF.defaults.assist
    self.isGroupUnit = true

    UF:SetupFrame(self)

    self.Update = UF.UpdateAssist
end

function UF:UpdateAssist()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end