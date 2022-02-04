local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTarget()
    local config = UF.config.target
    if not config.enabled then return end

    return UF:SpawnFrame("Target", "target", UF.CreateTarget, config, UF.defaults.target)
end

function UF:CreateTarget()
    self.config = UF.config.target
    self.defaults = UF.defaults.target

    self:InitializeFrame()

    self.Update = UF.UpdateTarget
end

function UF:UpdateTarget()
    if not self then return end

    self:ConfigureFrame()
end
