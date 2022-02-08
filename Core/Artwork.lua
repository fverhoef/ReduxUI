local addonName, ns = ...
local R = _G.ReduxUI

R.DEFAULT_BACKDROP_COLOR = {0.1, 0.1, 0.1, 0.8}
R.DEFAULT_BORDER_COLOR = {1, 1, 1, 1}
R.DEFAULT_SHADOW_COLOR = {0, 0, 0, 0.7}
R.DEFAULT_INLAY_COLOR = {1, 1, 1, 0.7}

function R:CreateBackdrop(backdropInfo, color, borderColor)
    local backdrop = self.Backdrop
    if not backdrop then backdrop = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate") end

    color = color or R.DEFAULT_BACKDROP_COLOR
    borderColor = borderColor or R.DEFAULT_BORDER_COLOR

    backdrop:SetBackdrop(backdropInfo)
    backdrop:SetBackdropColor(unpack(color))
    backdrop:SetBackdropBorderColor(unpack(borderColor))
    backdrop:SetOutside(self, 0, 0)
    backdrop:SetFrameLevel(math.max(0, self:GetFrameLevel() - 1))

    self.Backdrop = backdrop
end

function R:CreateBorder(color, size, offset, frameLevel)
    local border = self.Border
    if not border then border = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate") end

    color = color or R.DEFAULT_BORDER_COLOR

    frameLevel = frameLevel or math.max(1, self:GetFrameLevel() + 1)

    border:SetBackdrop({edgeFile = R.media.textures.edgeFiles.borderThickTooltip, edgeSize = size or 12})
    border:SetBackdropBorderColor(unpack(color))
    border:SetOutside(self, offset or 3, offset or 3)
    border:SetFrameLevel(frameLevel)

    self.Border = border
end

function R:CreateShadow(size, color)
    local shadow = self.Shadow
    if not shadow then shadow = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate") end

    size = size or 7
    color = color or R.DEFAULT_SHADOW_COLOR
    if not color[4] then color[4] = 0.7 end

    shadow:SetBackdrop({edgeFile = R.media.textures.edgeFiles.glow, edgeSize = size + 3})
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(unpack(color))
    shadow:SetFrameLevel(1)
    shadow:SetFrameStrata(self:GetFrameStrata())
    shadow:SetOutside(self, size, size)

    self.Shadow = shadow
end

function R:CreateInlay(color, size, offset, frameLevel)
    local inlay = self.Inlay
    if not inlay then inlay = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate") end

    color = color or R.DEFAULT_INLAY_COLOR

    inlay:SetBackdrop({edgeFile = R.media.textures.edgeFiles.inlay, edgeSize = size or 12})
    inlay:SetBackdropBorderColor(unpack(color))
    inlay:SetOutside(self, offset or 6, offset or 6)
    inlay:SetFrameLevel(self:GetFrameLevel() + 1)

    self.Inlay = inlay
end
