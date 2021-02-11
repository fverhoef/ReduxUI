local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateSummonIndicator = function(self)
    self.SummonIndicatorParent = CreateFrame("Frame", nil, self)
    self.SummonIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.SummonIndicator = self.SummonIndicatorParent:CreateTexture(nil, "OVERLAY")
    self.SummonIndicator:SetSize(16, 16)
    self.SummonIndicator:SetPoint("CENTER", self.Health)
end

oUF:RegisterMetaFunction("CreateSummonIndicator", UF.CreateSummonIndicator)

UF.UpdateSummonIndicator = function(self)
    if not self.SummonIndicator then
        return
    end

    local cfg = self.cfg.summonIndicator
    if cfg.enabled then
        self:EnableElement("SummonIndicator")
    else
        self:DisableElement("SummonIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateSummonIndicator", UF.UpdateSummonIndicator)