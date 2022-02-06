local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnAssistHeader()
    local config = UF.config.assist
    if not config.enabled then return end

    return UF:SpawnHeader("Assist", 1, config, UF.defaults.assist, UF.CreateAssist, "MAINASSIST")
end

function UF:CreateAssist()
    self.config = UF.config.assist
    self.defaults = UF.defaults.assist
    self.isGroupUnit = true

    self:InitializeFrame()

    self.Update = UF.UpdateAssist
end

function UF:UpdateAssist()
    if not self then return end

    self:ConfigureFrame()
end
