local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnAssistHeader()
    return UF:SpawnHeader("Assist", 1, AssistMixin, UF.config.assist, UF.defaults.assist, "MAINASSIST")
end

AssistMixin = {}
