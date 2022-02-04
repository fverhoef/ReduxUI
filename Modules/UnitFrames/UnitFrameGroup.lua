local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnUnitFrameGroup(name, unit, count, config, defaultConfig, styleFunc)
    if not config.enabled then return end

    local parent = CreateFrame("Frame", addonName .. name, UIParent)
    parent:Point(unpack(config.point))
    parent:Show()
    parent.config = config
    parent.frames = {}

    oUF:RegisterStyle(addonName .. name, styleFunc)
    oUF:SetActiveStyle(addonName .. name)
    for i = 1, count do
        local frame = oUF:Spawn(unit .. i, addonName .. name .. i)
        frame:SetParent(parent)

        parent.frames[i] = frame
    end

    R:CreateDragFrame(parent, name, defaultConfig.point)

    parent.Update = UF.UpdateUnitFrameGroup
    parent:Update()

    _G.Mixin(parent, UnitFrameGroupMixin)

    return parent
end

function UF:UpdateUnitFrameGroup()
    local count = #self.frames
    local width, height = 0, 0
    if self.config.unitAnchorPoint == "TOP" or self.config.unitAnchorPoint == "BOTTOM" then
        width = self.config.size[1]
        height = count * self.config.size[2] + (count - 1) * self.config.unitSpacing
    elseif self.config.unitAnchorPoint == "LEFT" or self.config.unitAnchorPoint == "RIGHT" then
        width = count * self.config.size[1] + (count - 1) * self.config.unitSpacing
        height = self.config.size[2]
    end
    self:SetSize(width, height)

    for i, frame in ipairs(self.frames) do
        if (i == 1) then
            frame:Point(self.config.unitAnchorPoint)
        else
            local offsetX, offsetY = 0, 0
            local relativePoint
            if self.config.unitAnchorPoint == "TOP" then
                relativePoint = "BOTTOM"
                offsetY = -self.config.unitSpacing
            elseif self.config.unitAnchorPoint == "BOTTOM" then
                relativePoint = "TOP"
                offsetY = self.config.unitSpacing
            elseif self.config.unitAnchorPoint == "LEFT" then
                relativePoint = "RIGHT"
                offsetX = self.config.unitSpacing
            elseif self.config.unitAnchorPoint == "RIGHT" then
                relativePoint = "LEFT"
                offsetX = -self.config.unitSpacing
            end
            frame:Point(self.config.unitAnchorPoint, self.frames[i - 1], relativePoint, offsetX, offsetY)
        end

        frame:Update()
    end
end

UnitFrameGroupMixin = {}

function UnitFrameGroupMixin:ForceShow()
    for i, frame in ipairs(self.frames) do
        frame:ForceShow()
    end
end

function UnitFrameGroupMixin:UnforceShow()
    for i, frame in ipairs(self.frames) do
        frame:UnforceShow()
    end
end
