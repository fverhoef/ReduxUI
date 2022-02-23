local addonName, ns = ...
local R = _G.ReduxUI

local function GetNormalizedPoint(frame)
    if not frame then return end
    local a1, af, a2, x, y = frame:GetPoint()
    if not af then af = frame:GetParent() end
    if not a2 then a2 = a1 end
    if not x then x = 0 end
    if not y then y = 0 end
    if af and af.GetName and af:GetName() then af = af:GetName() end
    return {a1, af, a2, R:Round(x), R:Round(y)}
end

local function SetNormalizedPoint(self, arg1, arg2, arg3, arg4, arg5)
    if not self or not arg1 or not self.SetPoint then return end

    if type(arg1) == "table" then arg1, arg2, arg3, arg4, arg5 = unpack(arg1) end

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

local function SetInside(self, anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or 6
    yOffset = yOffset or 6
    anchor = anchor or self:GetParent()

    if self:GetPoint() then self:ClearAllPoints() end

    self:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
    self:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

local function SetOutside(self, anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or 6
    yOffset = yOffset or 6
    anchor = anchor or self:GetParent()

    if self:GetPoint() then self:ClearAllPoints() end

    self:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
    self:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

local function Offset(self, offsetX, offsetY)
    if self then
        local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
        if not self.originalPoint then self.originalPoint = {point = point, relativeTo = relativeTo, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs} end
        self:SetPoint(self.originalPoint.point, self.originalPoint.relativeTo, self.originalPoint.relativePoint, self.originalPoint.xOfs + offsetX, self.originalPoint.yOfs + offsetY)
    end
end

local function AddApi(object)
    local mt = getmetatable(object).__index
	-- Utilities
	if not object.GetNormalizedPoint then mt.GetNormalizedPoint = GetNormalizedPoint end
	if not object.SetNormalizedPoint then mt.SetNormalizedPoint = SetNormalizedPoint end
    if not object.SetOutside then mt.SetOutside = SetOutside end
    if not object.SetInside then mt.SetInside = SetInside end
    if not object.Offset then mt.Offset = Offset end
	-- Artwork
    if not object.CreateBackdrop then mt.CreateBackdrop = R.CreateBackdrop end
    if not object.CreateBorder then mt.CreateBorder = R.CreateBorder end
    if not object.CreateShadow then mt.CreateShadow = R.CreateShadow end
    if not object.CreateInlay then mt.CreateInlay = R.CreateInlay end
    if not object.CreateSeparator then mt.CreateSeparator = R.CreateSeparator end
	-- Fader
    if not object.FadeIn then mt.FadeIn = R.FadeIn end
    if not object.FadeOut then mt.FadeOut = R.FadeOut end
    if not object.CreateFader then mt.CreateFader = R.CreateFader end
	-- Mover
    if not object.CreateMover then mt.CreateMover = R.CreateMover end
end

local handled = {Frame = true}
local object = CreateFrame("Frame")
AddApi(object)
AddApi(object:CreateTexture())
AddApi(object:CreateFontString())
AddApi(object:CreateMaskTexture())

object = EnumerateFrames()
while object do
    if not object:IsForbidden() and not handled[object:GetObjectType()] then
        AddApi(object)
        handled[object:GetObjectType()] = true
    end

    object = EnumerateFrames(object)
end

AddApi(_G.GameFontNormal) -- Add API to `CreateFont` objects without actually creating one
AddApi(CreateFrame("ScrollFrame")) -- Hacky fix for issue on 7.1 PTR where scroll frames no longer seem to inherit the methods from the 'Frame' widget
