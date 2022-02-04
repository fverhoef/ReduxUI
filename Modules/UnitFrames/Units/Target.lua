local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTarget()
    local config = UF.config.target
    local default = UF.defaults.target

    if config.enabled then
        return UF:SpawnFrame("Target", "target", UF.CreateTarget, config, default)
    end
end

function UF:CreateTarget()
    self.config = UF.config.target
    self.defaults = UF.defaults.target
    
    self:InitializeFrame()

    self.Update = UF.UpdateTarget
end

function UF:UpdateTarget()
    if not self then
        return
    end

    self:ConfigureFrame()
end