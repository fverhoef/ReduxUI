local addonName, ns = ...
local R = _G.ReduxUI

function R:GetNormalizedPoint()
    if not self then
        return
    end

    local a1, af, a2, x, y = self:GetPoint()
    if not af then
        af = self:GetParent()
    end
    if not a2 then
        a2 = a1
    end
    if not x then
        x = 0
    end
    if not y then
        y = 0
    end
    if af and af.GetName and af:GetName() then
        af = af:GetName()
    end
    return { a1, af, a2, R:Round(x), R:Round(y) }
end

function R:SetNormalizedPoint(arg1, arg2, arg3, arg4, arg5)
    if not self or not arg1 or not self.SetPoint then
        return
    end

    if type(arg1) == "table" then
        arg1, arg2, arg3, arg4, arg5 = unpack(arg1)
    end

    local point, anchor, relativePoint, offsetX, offsetY
    if arg5 then
        point, anchor, relativePoint, offsetX, offsetY = arg1, arg2, arg3, arg4, arg5
    elseif arg4 then
        point, anchor, relativePoint, offsetX, offsetY = arg1, self:GetParent(), arg2, arg3, arg4
    elseif arg3 then
        point, anchor, relativePoint, offsetX, offsetY = arg1, self:GetParent(), arg1, arg2, arg3
    else
        point, anchor, relativePoint, offsetX, offsetY = arg1, self:GetParent(), arg1, 0, 0
    end

    self:SetPoint(point, anchor, relativePoint, offsetX, offsetY)
end

function R:SetNormalizedSize(arg1, arg2)
    if not self or not arg1 or not self.SetSize then
        return
    end

    if type(arg1) == "table" then
        arg1, arg2 = unpack(arg1)
    end

    self:SetSize(arg1, arg2 or arg1)
end

function R:SetInside(anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or 6
    yOffset = yOffset or 6
    anchor = anchor or self:GetParent()

    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
    self:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

function R:SetOutside(anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or 6
    yOffset = yOffset or 6
    anchor = anchor or self:GetParent()

    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
    self:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

function R:Offset(offsetX, offsetY)
    if not self then
        return
    end

    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
    if not self.originalPoint then
        self.originalPoint = { point = point, relativeTo = relativeTo, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs }
    end
    self:SetPoint(self.originalPoint.point, self.originalPoint.relativeTo, self.originalPoint.relativePoint, self.originalPoint.xOfs + offsetX, self.originalPoint.yOfs + offsetY)
end
