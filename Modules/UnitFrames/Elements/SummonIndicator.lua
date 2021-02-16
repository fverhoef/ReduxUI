local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateSummonIndicator = function(self)
    self.SummonIndicator = self:CreateTexture(nil, "OVERLAY")
    self.SummonIndicator:SetParent(self.Overlay)
    self.SummonIndicator:SetSize(16, 16)
end

oUF:RegisterMetaFunction("CreateSummonIndicator", UF.CreateSummonIndicator)

UF.UpdateSummonIndicator = function(self)
    if not self.SummonIndicator then
        return
    end

    local config = self.config.summonIndicator
    if config.enabled then
        self:EnableElement("SummonIndicator")

        self.SummonIndicator:SetSize(unpack(config.size))
        self.SummonIndicator:ClearAllPoints()
        self.SummonIndicator:Point(unpack(config.point))
    else
        self:DisableElement("SummonIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateSummonIndicator", UF.UpdateSummonIndicator)