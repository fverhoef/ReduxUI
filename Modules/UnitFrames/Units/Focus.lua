local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocus()
    local config = UF.config.focus
    local default = UF.defaults.focus
    
    if R.isRetail and config.enabled then
        return UF:SpawnFrame("Focus", "focus", UF.CreateFocus, config, default)
    end
end

function UF:CreateFocus()
    self.config = UF.config.focus
    self.defaults = UF.defaults.focus

    UF:SetupFrame(self)

    self.Update = UF.UpdateFocus
end

function UF:UpdateFocus()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end
