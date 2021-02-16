local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateAssistantIndicator = function(self)
    self.AssistantIndicator = self:CreateTexture("$parentAssistIcon", "OVERLAY")
    self.AssistantIndicator:SetParent(self.Overlay)
    self.AssistantIndicator:SetSize(16, 16)

    return self.AssistantIndicator
end

oUF:RegisterMetaFunction("CreateAssistantIndicator", UF.CreateAssistantIndicator)

UF.UpdateAssistantIndicator = function(self)
    if not self.AssistantIndicator then
        return
    end

    local config = self.config.assistantIndicator
    if config.enabled then
        self:EnableElement("AssistantIndicator")

        self.AssistantIndicator:SetSize(unpack(config.size))
        self.AssistantIndicator:ClearAllPoints()
        self.AssistantIndicator:Point(unpack(config.point))
    else
        self:DisableElement("AssistantIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateAssistantIndicator", UF.UpdateAssistantIndicator)
