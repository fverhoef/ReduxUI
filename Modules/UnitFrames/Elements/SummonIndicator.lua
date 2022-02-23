local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateSummonIndicator()
    if not self.config.summonIndicator.enabled then return end

    self.SummonIndicator = self:CreateTexture(nil, "OVERLAY")
    self.SummonIndicator:SetParent(self.Overlay)
    self.SummonIndicator:SetSize(16, 16)
end

oUF:RegisterMetaFunction("CreateSummonIndicator", UF.CreateSummonIndicator)

function UF:ConfigureSummonIndicator()
    local config = self.config.summonIndicator
    if not config.enabled then
        self:DisableElement("SummonIndicator")
        return
    elseif not self.SummonIndicator then
        self:CreateSummonIndicator()
    end

    self:EnableElement("SummonIndicator")

    self.SummonIndicator:SetSize(unpack(config.size))
    self.SummonIndicator:ClearAllPoints()
    self.SummonIndicator:SetNormalizedPoint(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureSummonIndicator", UF.ConfigureSummonIndicator)
