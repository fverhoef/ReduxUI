local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTargetTarget()
    local config = UF.config.targettarget
    if not config.enabled then return end

    return UF:SpawnFrame("TargetTarget", "targettarget", UF.CreateTargetTarget, config, UF.defaults.targettarget)
end

function UF:CreateTargetTarget()
    self.config = UF.config.targettarget
    self.defaults = UF.defaults.targettarget

    self:InitializeFrame()

    self.Update = UF.UpdateTargetTarget
end

function UF:UpdateTargetTarget()
    if not self then return end

    self:ConfigureFrame()
end
