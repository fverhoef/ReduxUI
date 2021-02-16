local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateResurrectIndicator = function(self)
    self.ResurrectIndicator = self:CreateTexture(nil, "OVERLAY")
    self.ResurrectIndicator:SetParent(self.Overlay)
    self.ResurrectIndicator:SetSize(16, 16)
end

oUF:RegisterMetaFunction("CreateResurrectIndicator", UF.CreateResurrectIndicator)

UF.UpdateResurrectIndicator = function(self)
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