local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocus()
    local config = R.config.db.profile.modules.unitFrames.focus
    local default = R.config.defaults.profile.modules.unitFrames.focus
    
    if R.isRetail and config.enabled then
        return UF:SpawnFrame("Focus", "focus", UF.CreateFocus, config, default)
    end
end

function UF:CreateFocus()
    self.cfg = R.config.db.profile.modules.unitFrames.focus

    self:CreateBorder(self.cfg.border.size)
    self:SetBorderPadding(1, 1, 0, 0)
    self:CreateShadow()
    self:SetShadowPadding(1, 1, 0, 0)
end

function UF:UpdateFocus(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
    else
    end
end
