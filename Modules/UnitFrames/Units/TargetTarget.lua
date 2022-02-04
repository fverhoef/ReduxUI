local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTargetTarget()
    local config = UF.config.targettarget
    local default = UF.defaults.targettarget

    if config.enabled then return UF:SpawnFrame("TargetTarget", "targettarget", UF.CreateTargetTarget, config, default) end
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
