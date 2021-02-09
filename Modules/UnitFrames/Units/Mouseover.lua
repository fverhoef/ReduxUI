local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnMouseOver()
    local config = UF.config.mouseover
    if config.enabled then
        return UF:SpawnFrame("Mouseover", "mouseover", UF.CreateMouseover, config)
    end
end

function UF:CreateMouseover()
    self.cfg = UF.config.mouseover

    self:CreateBorder(self.cfg.border.size)
    self:SetBorderPadding(1, 1, 0, 0)
    self:CreateShadow()
    self:SetShadowPadding(1, 1, 0, 0)

    self.Update = function(self)
        UF:UpdateMouseover(self)
    end
end

function UF:UpdateMouseover(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)
end
