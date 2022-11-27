local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnUnitFrameGroup(name, unit, count, mixin, config, defaultConfig)
    if not config.enabled then
        return
    end

    local parent = CreateFrame("Frame", addonName .. name, UIParent)
    parent:SetNormalizedPoint(unpack(config.point))
    parent:Show()
    parent.config = config
    parent.frames = {}

    UF:SetStyle(name, mixin, config, defaultConfig, true)
    for i = 1, count do
        local frame = oUF:Spawn(unit .. i, addonName .. name .. i)
        frame:SetParent(parent)

        parent.frames[i] = frame
    end

    parent:CreateMover(name, defaultConfig.point)

    _G.Mixin(parent, UF.UnitFrameGroupMixin)
    parent:Configure()

    return parent
end

UF.UnitFrameGroupMixin = {}

function UF.UnitFrameGroupMixin:Configure()
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
            frame:SetNormalizedPoint(self.config.unitAnchorPoint)
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
            frame:SetNormalizedPoint(self.config.unitAnchorPoint, self.frames[i - 1], relativePoint, offsetX, offsetY)
        end

        frame:Configure()
    end
end

function UF.UnitFrameGroupMixin:ForceShow()
    if self.isForced then
        return
    end
    self.isForced = true

    for i, frame in ipairs(self.frames) do
        frame:ForceShow()
    end
end

function UF.UnitFrameGroupMixin:UnforceShow()
    if not self.isForced then
        return
    end
    self.isForced = nil

    for i, frame in ipairs(self.frames) do
        frame:UnforceShow()
    end
end
