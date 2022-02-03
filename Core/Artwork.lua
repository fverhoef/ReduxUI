local addonName, ns = ...
local R = _G.ReduxUI

function R:CreateBackdrop(backdropInfo, color, borderColor)
    if self.Backdrop then
        return
    end

    color = color or {0.1, 0.1, 0.1, 0.8}
    borderColor = color or {1, 1, 1, 1}

    local backdrop = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    backdrop:SetOutside(0, 0)
    backdrop:SetFrameLevel(self:GetFrameLevel() - 1)
    backdrop:SetBackdrop(backdropInfo)
    backdrop:SetBackdropColor(unpack(color))
    backdrop:SetBackdropBorderColor(unpack(borderColor))

    self.Backdrop = backdrop
end

function R:SetBackdropColor(r, g, b, a)
    if not self.Backdrop then
        return
    end
    self.Backdrop:SetBackdropColor(r or 0.1, g or 0.1, b or 0.1, a or 0.8)
end

function R:SetBackdropBorderColor(r, g, b, a)
    if not self.Backdrop then
        return
    end
    self.Backdrop:SetBackdropBorderColor(r or 1, g or 1, b or 1, a or 1)
end

function R:CreateShadow(size, pass, color)
    if not pass and self.Shadow then
        return
    end

    size = size or 5
    color = color or {0, 0, 0, 0.7}
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

    if not pass then
        self.Shadow = shadow
    end

    return shadow
end

function R:SetShadowColor(r, g, b, a)
    if not self.Shadow then
        return
    end
    self.Shadow:SetBackdropBorderColor(r or 0, g or 0, b or 0, a or 0.7)
end