local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateResurrectIndicator()
    self.ResurrectIndicator = self:CreateTexture(nil, "OVERLAY")
    self.ResurrectIndicator:SetParent(self.Overlay)
    self.ResurrectIndicator:SetSize(16, 16)
end

oUF:RegisterMetaFunction("CreateResurrectIndicator", UF.CreateResurrectIndicator)

function UF:UpdateResurrectIndicator()
    if not self.ResurrectIndicator then
        return
    end

    local config = self.config.resurrectIndicator
    if config.enabled then
        self:EnableElement("ResurrectIndicator")

        self.ResurrectIndicator:SetSize(unpack(config.size))
        self.ResurrectIndicator:ClearAllPoints()
        self.ResurrectIndicator:Point(unpack(config.point))
    else
        self:DisableElement("ResurrectIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateResurrectIndicator", UF.UpdateResurrectIndicator)