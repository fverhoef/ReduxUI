local addonName, ns = ...
local R = _G.ReduxUI

function R:SetInside(anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or 6
    yOffset = yOffset or 6
    anchor = anchor or self:GetParent()

    if self:GetPoint() then
        self:ClearAllPoints()
    end

    self:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
    self:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

function R:SetOutside(anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or 6
    yOffset = yOffset or 6
    anchor = anchor or self:GetParent()

    if self:GetPoint() then
        self:ClearAllPoints()
    end

    self:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
    self:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

function R:Offset(offsetX, offsetY)
    if self then
        local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
        if not self.originalPoint then
            self.originalPoint = {point = point, relativeTo = relativeTo, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs}
        end
        self:SetPoint(self.originalPoint.point, self.originalPoint.relativeTo, self.originalPoint.relativePoint,
                      self.originalPoint.xOfs + offsetX, self.originalPoint.yOfs + offsetY)
    end
end

function R:CreateBorder(size, texture, color, left, right, top, bottom)
    if self.Border then
        return
    end

    left = left or 0
    if right == nil then
        right = left
    end
    if top == nil then
        top = left
    end
    if bottom == nil then
        bottom = top or left
    end

    if not self.Border then
        size = size or R.config.db.profile.borders.size
        texture = texture or R.config.db.profile.borders.texture
        color = color or R.config.db.profile.borders.color

        self.Border = {}
        self.Border.size = size
        self.Border.color = color
        self.Border.texture = texture
        self.Border.padding = {left, right, top, bottom}

        for i = 1, 8 do
            self.Border[i] = self:CreateTexture(nil, "OVERLAY")
            self.Border[i]:SetParent(self)
            self.Border[i]:SetSize(size, size)
            self.Border[i]:SetTexture(texture)
            self.Border[i]:SetVertexColor(unpack(color))
        end

        self.Border[1]:SetTexCoord(0, 1 / 3, 0, 1 / 3)
        self.Border[1]:SetPoint("TOPLEFT", self, -left, top)

        self.Border[2]:SetTexCoord(2 / 3, 1, 0, 1 / 3)
        self.Border[2]:SetPoint("TOPRIGHT", self, right, top)

        self.Border[3]:SetTexCoord(0, 1 / 3, 2 / 3, 1)
        self.Border[3]:SetPoint("BOTTOMLEFT", self, -left, -bottom)

        self.Border[4]:SetTexCoord(2 / 3, 1, 2 / 3, 1)
        self.Border[4]:SetPoint("BOTTOMRIGHT", self, right, -bottom)

        self.Border[5]:SetTexCoord(1 / 3, 2 / 3, 0, 1 / 3)
        self.Border[5]:SetPoint("TOPLEFT", self.Border[1], "TOPRIGHT")
        self.Border[5]:SetPoint("TOPRIGHT", self.Border[2], "TOPLEFT")

        self.Border[6]:SetTexCoord(1 / 3, 2 / 3, 2 / 3, 1)
        self.Border[6]:SetPoint("BOTTOMLEFT", self.Border[3], "BOTTOMRIGHT")
        self.Border[6]:SetPoint("BOTTOMRIGHT", self.Border[4], "BOTTOMLEFT")

        self.Border[7]:SetTexCoord(0, 1 / 3, 1 / 3, 2 / 3)
        self.Border[7]:SetPoint("TOPLEFT", self.Border[1], "BOTTOMLEFT")
        self.Border[7]:SetPoint("BOTTOMLEFT", self.Border[3], "TOPLEFT")

        self.Border[8]:SetTexCoord(2 / 3, 1, 1 / 3, 2 / 3)
        self.Border[8]:SetPoint("TOPRIGHT", self.Border[2], "BOTTOMRIGHT")
        self.Border[8]:SetPoint("BOTTOMRIGHT", self.Border[4], "TOPRIGHT")
    end
end

function R:SetBorderPadding(left, right, top, bottom)
    if not self.Border then
        return
    end

    left = left or 0
    if right == nil then
        right = left
    end
    if top == nil then
        top = left
    end
    if bottom == nil then
        bottom = top or left
    end

    if self.Border.padding[1] ~= left or self.Border.padding[2] ~= right or self.Border.padding[3] ~= top or
        self.Border.padding[4] ~= bottom then
        self.Border.padding = {left, right, top, bottom}

        self.Border[1]:SetPoint("TOPLEFT", self, -left, top)
        self.Border[2]:SetPoint("TOPRIGHT", self, right, top)
        self.Border[3]:SetPoint("BOTTOMLEFT", self, -left, -bottom)
        self.Border[4]:SetPoint("BOTTOMRIGHT", self, right, -bottom)
    end
end

function R:SetBorderColor(r, g, b, a)
    if not self.Border then
        return
    end

    for i = 1, 8 do
        self.Border[i]:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
    end
end

function R:SetBorderSize(size)
    if not self.Border then
        return
    end

    for i = 1, 8 do
        self.Border[i]:SetSize(size, size)
    end
end

function R:SetBorderTexture(texture)
    if not self.Border then
        return
    end

    for i = 1, 8 do
        self.Border[i]:SetTexture(texture)
    end
end

function R:CreateShadow(size, edgeSize, pass, color)
    if not pass and self.Shadow then
        return
    end

    size = size or 5
    edgeSize = edgeSize or (size + 2)
    color = color or {0, 0, 0, 0.7}
    if not color[4] then
        color[4] = 0.7
    end

    local shadow = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    shadow.size = size
    shadow.edgeSize = edgeSize

    shadow:SetFrameLevel(1)
    shadow:SetFrameStrata(self:GetFrameStrata())
    shadow:SetOutside(self, size, size)
    shadow:SetBackdrop({edgeFile = R.media.textures.backdrops.glow, edgeSize = edgeSize})
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(unpack(color))

    if not pass then
        self.Shadow = shadow
    end

    return shadow
end

function R:SetShadowPadding(left, right, top, bottom)
    if not self.Shadow then
        return
    end

    left = left or 0
    if right == nil then
        right = left
    end
    if top == nil then
        top = left
    end
    if bottom == nil then
        bottom = top or left
    end

    self.Shadow:SetPoint("TOPLEFT", self, "TOPLEFT", -self.Shadow.size - left, self.Shadow.size + top)
    self.Shadow:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", self.Shadow.size + right, -self.Shadow.size - bottom)
end

function R:SetShadowColor(color)
    if not self.Shadow then
        return
    end

    if not color[4] then
        color[4] = 0.7
    end

    self.Shadow:SetBackdropBorderColor(unpack(color))
end

local function AddApi(object)
    local mt = getmetatable(object).__index
    if not object.SetInside then
        mt.SetInside = R.SetInside
    end
    if not object.SetOutside then
        mt.SetOutside = R.SetOutside
    end
    if not object.Offset then
        mt.Offset = R.Offset
    end
    if not object.CreateBackdrop then
        mt.CreateBackdrop = R.CreateBackdrop
    end
    if not object.CreateBorder then
        mt.CreateBorder = R.CreateBorder
    end
    if not object.SetBorderPadding then
        mt.SetBorderPadding = R.SetBorderPadding
    end
    if not object.SetBorderColor then
        mt.SetBorderColor = R.SetBorderColor
    end
    if not object.SetBorderSize then
        mt.SetBorderSize = R.SetBorderSize
    end
    if not object.SetBorderTexture then
        mt.SetBorderTexture = R.SetBorderTexture
    end
    if not object.CreateShadow then
        mt.CreateShadow = R.CreateShadow
    end
    if not object.SetShadowPadding then
        mt.SetShadowPadding = R.SetShadowPadding
    end
    if not object.SetShadowColor then
        mt.SetShadowColor = R.SetShadowColor
    end
end

local handled = {["Frame"] = true}
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

AddApi(_G.GameFontNormal)
AddApi(CreateFrame("ScrollFrame"))
