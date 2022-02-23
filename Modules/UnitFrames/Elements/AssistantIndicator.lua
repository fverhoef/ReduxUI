local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAssistantIndicator()
    if not self.config.assistantIndicator.enabled then return end

    self.AssistantIndicator = self:CreateTexture("$parentAssistIcon", "OVERLAY")
    self.AssistantIndicator:SetParent(self.Overlay)
    self.AssistantIndicator:SetSize(16, 16)

    return self.AssistantIndicator
end

oUF:RegisterMetaFunction("CreateAssistantIndicator", UF.CreateAssistantIndicator)

function UF:ConfigureAssistantIndicator()
    local config = self.config.assistantIndicator
    if not config.enabled then
        self:DisableElement("AssistantIndicator")
        return
    elseif not self.AssistantIndicator then
        self:CreateAssistantIndicator()
    end

    self:EnableElement("AssistantIndicator")

    self.AssistantIndicator:SetSize(unpack(config.size))
    self.AssistantIndicator:ClearAllPoints()
    self.AssistantIndicator:SetNormalizedPoint(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureAssistantIndicator", UF.ConfigureAssistantIndicator)
