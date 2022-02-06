local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocus()
    local config = UF.config.focus
    if not config.enabled then return end

    return UF:SpawnFrame("Focus", "focus", UF.CreateFocus, config, UF.defaults.focus)
end

function UF:CreateFocus()
    self.config = UF.config.focus
    self.defaults = UF.defaults.focus

    self:InitializeFrame()

    self.Update = UF.UpdateFocus
end

function UF:UpdateFocus()
    if not self then return end

    self:ConfigureFrame()
end