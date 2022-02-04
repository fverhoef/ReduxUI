local addonName, ns = ...
local R = _G.ReduxUI

R.DEFAULT_BACKDROP_COLOR = {0.1, 0.1, 0.1, 0.8}
R.DEFAULT_BORDER_COLOR = {1, 1, 1, 1}
R.DEFAULT_SHADOW_COLOR = {0, 0, 0, 0.7}

function R:CreateBackdrop(backdropInfo, color, borderColor)
    if self.Backdrop then
        return
    end

    color = color or R.DEFAULT_BACKDROP_COLOR
    borderColor = borderColor or R.DEFAULT_BORDER_COLOR

    local backdrop = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    backdrop:SetOutside(self, 0, 0)
    backdrop:SetFrameLevel(math.max(0, self:GetFrameLevel() - 1))
    backdrop:SetBackdrop(backdropInfo)
    backdrop:SetBackdropColor(unpack(color))
    backdrop:SetBackdropBorderColor(unpack(borderColor))

    self.Backdrop = backdrop
end

function R:CreateShadow(size, color)
    if self.Shadow then
        return
    end

    size = size or 5
    color = color or R.DEFAULT_SHADOW_COLOR
    if not color[4] then
        color[4] = 0.7
    end

	local offset = size + 1
    local shadow = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    shadow.size = size

    shadow:SetFrameLevel(1)
    shadow:SetFrameStrata(self:GetFrameStrata())
    shadow:SetOutside(self, offset, offset)
    shadow:SetBackdrop({edgeFile = R.media.textures.edgeFiles.glow, edgeSize = size})
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(unpack(color))

    self.Shadow = shadow
end

function R:CreateInlay(backdropInfo, color)
    if self.Inlay then
        return
    end

    color = color or {1, 1, 1, 0.7}

    local inlay = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    inlay:SetInside(self, 0, 0)
    inlay:SetFrameLevel(self:GetFrameLevel())
    inlay:SetBackdrop(backdropInfo)
    inlay:SetBackdropBorderColor(unpack(color))

    self.Inlay = inlay
end