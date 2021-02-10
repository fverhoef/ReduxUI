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
    self.cfg = UF.config.focus

    self:CreateBorder(self.cfg.border.size)
    self:CreateShadow()

    self.Update = function(self)
        UF:UpdateFocus(self)
    end
end

function UF:UpdateFocus(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
    end
end
