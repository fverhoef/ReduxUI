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

function R:Point(arg1, arg2, arg3, arg4, arg5)
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

function R:DisableScripts()
    local scripts = {
        "OnShow",
        "OnHide",
        "OnEvent",
        "OnEnter",
        "OnLeave",
        "OnUpdate",
        "OnValueChanged",
        "OnClick",
        "OnMouseDown",
        "OnMouseUp"
    }

    for _, script in next, scripts do
        if self:HasScript(script) then
            self:SetScript(script, nil)
        end
    end
end

function R:CreateBackdrop(texture, tile, tileSize, edgeSize, inset)
    if self.Backdrop then
        return
    end

    texture = texture or [[Interface\Buttons\WHITE8X8]]
    tile = tile or false
    tileSize = tileSize or 32
    edgeSize = edgeSize or 0
    inset = inset or 0

    local backdrop = CreateFrame("Frame", nil, self)
    backdrop:SetOutside(0, 0)
    backdrop:SetFrameLevel(self:GetFrameLevel() - 1)
    backdrop:SetBackdrop({
        bgFile = texture,
        tile = tile,
        tileSize = tileSize,
        edgeSize = edgeSize,
        insets = {left = inset, right = inset, top = inset, bottom = inset}
    })
    backdrop:SetBackdropColor(0.1, 0.1, 0.1, 0.8)

    self.Backdrop = backdrop
end

function R:SetBackdropColor(r, g, b, a)
    if not self.Backdrop then
        return
    end
    self.Backdrop:SetBackdropColor(r or 0.1, g or 0.1, b or 0.1, a or 0.8)
end

local borders = {}

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
        self.Border.parent = self
        self.Border.Show = function(self)
            for i = 1, 8 do
                self[i]:Show()
            end
        end
        self.Border.Hide = function(self)
            for i = 1, 8 do
                self[i]:Hide()
            end
        end
        self.Border.SetShown = function(self, val)
            for i = 1, 8 do
                self[i]:SetShown(val)
            end
        end
        self.Border.SetTexture = function(self, texture)
            for i = 1, 8 do
                self[i]:SetTexture(texture)
            end
        end
        self.Border.SetVertexColor = function(self, r, g, b, a)
            for i = 1, 8 do
                self[i]:SetVertexColor(r, g, b, a)
            end
        end

        for i = 1, 8 do
            self.Border[i] = self:CreateTexture(nil, "OVERLAY")
            self.Border[i]:SetParent(self)
            self.Border[i]:SetSize(size, size)
            self.Border[i]:SetTexture(texture)
            self.Border[i]:SetVertexColor(unpack(color))
        end

        -- Top Left Corner
        self.Border[1]:SetTexCoord(0, 8 / 64, 0, 8 / 64)
        self.Border[1]:SetPoint("TOPLEFT", self, -left, top)

        -- Top Right Corner
        self.Border[2]:SetTexCoord(56 / 64, 1, 0, 8 / 64)
        self.Border[2]:SetPoint("TOPRIGHT", self, right, top)

        -- Bottom Left Corner
        self.Border[3]:SetTexCoord(0, 8 / 64, 56 / 64, 1)
        self.Border[3]:SetPoint("BOTTOMLEFT", self, -left, -bottom)

        -- Bottom Right Corner
        self.Border[4]:SetTexCoord(56 / 64, 1, 56 / 64, 1)
        self.Border[4]:SetPoint("BOTTOMRIGHT", self, right, -bottom)

        -- Top
        self.Border[5]:SetTexCoord(8 / 64, 56 / 64, 0, 8 / 64)
        self.Border[5]:SetPoint("TOPLEFT", self.Border[1], "TOPRIGHT")
        self.Border[5]:SetPoint("TOPRIGHT", self.Border[2], "TOPLEFT")

        -- Bottom
        self.Border[6]:SetTexCoord(8 / 64, 56 / 64, 56 / 64, 1)
        self.Border[6]:SetPoint("BOTTOMLEFT", self.Border[3], "BOTTOMRIGHT")
        self.Border[6]:SetPoint("BOTTOMRIGHT", self.Border[4], "BOTTOMLEFT")

        -- Left
        self.Border[7]:SetTexCoord(0, 8 / 64, 8 / 64, 56 / 64)
        self.Border[7]:SetPoint("TOPLEFT", self.Border[1], "BOTTOMLEFT")
        self.Border[7]:SetPoint("BOTTOMLEFT", self.Border[3], "TOPLEFT")

        -- Right
        self.Border[8]:SetTexCoord(56 / 64, 1, 8 / 64, 56 / 64)
        self.Border[8]:SetPoint("TOPRIGHT", self.Border[2], "BOTTOMRIGHT")
        self.Border[8]:SetPoint("BOTTOMRIGHT", self.Border[4], "TOPRIGHT")

        borders[self.Border] = true
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

    self.Border:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
end

function R:GetBorderColor()
    if not self.Border then
        return
    end

    local color = {self.Border[1]:GetVertexColor()}

    if not color[4] then
        color[4] = 1
    end

    return color
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

    self.Border:SetTexture(texture)
end

function R:UpdateAllBorders(size, texture)
    local parent
    for border, _ in pairs(borders) do
        if size then
            border.parent:SetBorderSize(size)
        end
        if texture then
            border.parent:SetBorderTexture(texture)
        end
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
    shadow:SetBackdrop({edgeFile = R.media.textures.edgeFiles.glow, edgeSize = edgeSize})
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

function R:SetShadowColor(r, g, b, a)
    if not self.Shadow then
        return
    end

    if not a then
        a = 0.7
    end

    self.Shadow:SetBackdropBorderColor(r, g, b, a)
end

function R:GetShadowColor()
    if not self.Shadow then
        return
    end

    local color = {self.Shadow:GetBackdropBorderColor()}

    if not color[4] then
        color[4] = 0.7
    end

    return color
end

function R:FadeIn(timeToFade, startAlpha, endAlpha, finishedFunc, finishedArg1, finishedArg2, finishedArg3, finishedArg4)
    self.faded = false

    UIFrameFade(self, {
        mode = "IN",
        timeToFade = timeToFade or 0.3,
        startAlpha = startAlpha or self:GetAlpha(),
        endAlpha = endAlpha or 1,
        finishedFunc = finishedFunc,
        finishedArg1 = finishedArg1,
        finishedArg2 = finishedArg2,
        finishedArg3 = finishedArg3,
        finishedArg4 = finishedArg4
    })

    for child, enabled in pairs(self.linkedFaders or {}) do
        if enabled then
            child:FadeIn(timeToFade, startAlpha, endAlpha)
        end
    end
end

function R:FadeOut(timeToFade, startAlpha, endAlpha, finishedFunc, finishedArg1, finishedArg2, finishedArg3, finishedArg4)
    self.faded = true

    UIFrameFade(self, {
        mode = "OUT",
        timeToFade = timeToFade or 0.3,
        startAlpha = startAlpha or self:GetAlpha(),
        endAlpha = endAlpha or 0,
        finishedFunc = finishedFunc,
        finishedArg1 = finishedArg1,
        finishedArg2 = finishedArg2,
        finishedArg3 = finishedArg3,
        finishedArg4 = finishedArg4
    })

    for child, enabled in pairs(self.linkedFaders or {}) do
        if enabled then
            child:FadeOut(timeToFade, startAlpha, endAlpha)
        end
    end
end

function R:CreateFader(faderConfig, children)
    if not self then
        return
    end

    if not self.faderConfig then
        self.faderConfig = faderConfig
        self.linkedFaders = {}
        self.faded = false

        self:EnableMouse(true)
        self:HookScript("OnShow", R.Fader_OnShow)
        self:HookScript("OnHide", R.Fader_OnHide)
        self:HookScript("OnEnter", R.Fader_OnEnterOrLeave)
        self:HookScript("OnLeave", R.Fader_OnEnterOrLeave)
        if self.faderConfig == R.config.faders.mouseOver then
            R.Fader_OnEnterOrLeave(self)
        end
    end

    if children then
        for _, child in next, children do
            if not child.faderParent then
                child.faderParent = self
                child:EnableMouse(true)
                child:HookScript("OnEnter", R.Fader_OnEnterOrLeave)
                child:HookScript("OnLeave", R.Fader_OnEnterOrLeave)
            end
        end
    end
end

function R:LinkFader(parent)
    if not self or not parent or parent.linkedFaders[self] then
        return
    end

    parent.linkedFaders[self] = true
end

function R:UnlinkFader(parent)
    if not self or not parent or not parent.linkedFaders[self] then
        return
    end

    parent.linkedFaders[self] = false
end

function R:Fader_OnShow()
    local frame = self.faderParent or self
    if frame.faderConfig == R.config.faders.onShow then
        frame:FadeIn(0.3, 0)
    end
end

function R:Fader_OnHide()
    local frame = self.faderParent or self

    for child, enabled in pairs(self.linkedFaders or {}) do
        if enabled then
            child:FadeOut(0)
        end
    end
end

function R:Fader_OnEnterOrLeave()
    local frame = self.faderParent or self
    if frame.faderConfig == R.config.faders.mouseOver then
        if MouseIsOver(frame) then
            frame:FadeIn()
        else
            frame:FadeOut()
        end
    end
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
    if not object.Point then
        mt.Point = R.Point
    end
    if not object.DisableScripts then
        mt.DisableScripts = R.DisableScripts
    end
    if not object.CreateBackdrop then
        mt.CreateBackdrop = R.CreateBackdrop
    end
    if not object.SetBackdropColor then
        mt.SetBackdropColor = R.SetBackdropColor
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
    if not object.GetBorderColor then
        mt.GetBorderColor = R.GetBorderColor
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
    if not object.GetShadowColor then
        mt.GetShadowColor = R.GetShadowColor
    end
    if not object.FadeIn then
        mt.FadeIn = R.FadeIn
    end
    if not object.FadeOut then
        mt.FadeOut = R.FadeOut
    end
    if not object.CreateFader then
        mt.CreateFader = R.CreateFader
    end
    if not object.LinkFader then
        mt.LinkFader = R.LinkFader
    end
    if not object.UnlinkFader then
        mt.UnlinkFader = R.UnlinkFader
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
