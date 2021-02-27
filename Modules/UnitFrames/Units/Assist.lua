local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnAssistHeader()
    local config = UF.config.assist
    local default = UF.config.assist

    if config.enabled then
        local parent = CreateFrame("Frame", addonName .. "Assist")
        parent:Point(unpack(config.point))
        parent:SetSize(200, 40)
        parent:Show()
        parent.config = config
        parent.defaults = default

        local group = UF:SpawnHeader("Assist", UF.CreateAssist, config, default, true)
        parent.group = group

        R:CreateDragFrame(parent, "Assist", default.point, 200, 40)

        parent.Update = UF.UpdateAssistHeader
        parent.ForceShow = UF.ForceShowAssist
        parent.UnforceShow = UF.UnforceShowAssist

        return parent
    end
end

function UF:UpdateAssistHeader()
end

function UF:CreateAssist()
    self.config = UF.config.assist
    self.defaults = UF.defaults.assist
    self.isGroupUnit = true

    UF:SetupFrame(self)

    self.Update = UF.UpdateAssist
end

function UF:UpdateAssist()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end

function UF:ForceShowAssist()
    UF:ForceShowHeader(self.group)
    UF:UpdateAssistHeader()
    self.forceShow = true
end

function UF:UnforceShowAssist()
    UF:UnforceShowHeader(self.group)
    UF:UpdateAssistHeader()
    self.forceShow = false
end