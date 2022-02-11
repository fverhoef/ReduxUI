local addonName, ns = ...
local R = _G.ReduxUI

R.BACKDROP_PIECES = {"TopLeftCorner", "TopRightCorner", "BottomLeftCorner", "BottomRightCorner", "TopEdge", "BottomEdge", "LeftEdge", "RightEdge", "Center"}

R.DEFAULT_BACKDROP_COLOR = {0.1, 0.1, 0.1, 0.8}
R.DEFAULT_BORDER_COLOR = {0.5, 0.5, 0.5, 1}
R.DEFAULT_BORDER_SIZE = 12
R.DEFAULT_BORDER_OFFSET = 3
R.DEFAULT_SHADOW_COLOR = {0, 0, 0, 0.5}
R.DEFAULT_SHADOW_SIZE = 12
R.DEFAULT_SHADOW_OFFSET = 5
R.DEFAULT_INLAY_COLOR = {1, 1, 1, 0.7}
R.DEFAULT_INLAY_SIZE = 12
R.DEFAULT_INLAY_OFFSET = 6
R.DEFAULT_SEPARATOR_COLOR = {0.5, 0.5, 0.5, 1}
R.DEFAULT_SEPARATOR_SIZE = 6
R.DEFAULT_SEPARATOR_OFFSET = 2
R.DEFAULT_SEPARATOR_POSITION = "TOP"
R.VALID_SEPARATOR_POSITIONS = { ["TOP"] = true, ["BOTTOM"] = true, ["LEFT"] = true, ["RIGHT"] = true}

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
    backdrop:SetFrameStrata(self:GetFrameStrata())

    self.Backdrop = backdrop
end

function R:CreateBorder(color, size, offset, frameLevel, texture)
    local border = self.Border
    if not border then border = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate") end

    color = color or R.DEFAULT_BORDER_COLOR
    if not color[4] then color[4] = R.DEFAULT_BORDER_COLOR[4] end
    size = size or R.DEFAULT_BORDER_SIZE
    offset = offset or R.DEFAULT_BORDER_OFFSET
    frameLevel = frameLevel or math.max(1, self:GetFrameLevel() + 1)
    texture = texture or R.config.db.profile.borders.texture or R.media.textures.edgeFiles.borderThick

    border:SetBackdrop({edgeFile = texture, edgeSize = size})
    border:SetBackdropBorderColor(unpack(color))
    border:SetOutside(self, offset, offset)
    border:SetFrameLevel(frameLevel)
    border:SetFrameStrata(self:GetFrameStrata())

    self.Border = border
end

function R:CreateShadow(size, color, offset)
    local shadow = self.Shadow
    if not shadow then shadow = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate") end

    color = color or R.DEFAULT_SHADOW_COLOR
    if not color[4] then color[4] = R.DEFAULT_SHADOW_COLOR[4] end
    size = size or R.DEFAULT_SHADOW_SIZE
    offset = offset or R.DEFAULT_SHADOW_OFFSET

    shadow:SetBackdrop({edgeFile = R.media.textures.edgeFiles.glow, edgeSize = size, insets = {left = size, right = size, top = size, bottom = size}})
    shadow:SetBackdropBorderColor(unpack(color))
    shadow:SetFrameLevel(1)
    shadow:SetFrameStrata(self:GetFrameStrata())
    shadow:SetOutside(self, offset, offset)

    self.Shadow = shadow
end

function R:CreateInlay(color, size, offset, frameLevel)
    local inlay = self.Inlay
    if not inlay then inlay = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate") end

    color = color or R.DEFAULT_INLAY_COLOR
    if not color[4] then color[4] = R.DEFAULT_INLAY_COLOR[4] end
    size = size or R.DEFAULT_INLAY_SIZE
    offset = offset or R.DEFAULT_INLAY_OFFSET
    frameLevel = frameLevel or math.max(1, self:GetFrameLevel() + 1)

    inlay:SetBackdrop({edgeFile = R.media.textures.edgeFiles.inlay, edgeSize = size})
    inlay:SetBackdropBorderColor(unpack(color))
    inlay:SetOutside(self, offset, offset)
    inlay:SetFrameLevel(frameLevel)

    self.Inlay = inlay
end

function R:CreateSeparator(color, size, offset, frameLevel, position)
    local separator = self.Separator
    if not separator then separator = CreateFrame("Frame", nil, self) end
    if not separator.Texture then separator.Texture = separator:CreateTexture("BORDER") end

    color = color or R.DEFAULT_SEPARATOR_COLOR
    size = size or R.DEFAULT_SEPARATOR_SIZE
    offset = offset or R.DEFAULT_SEPARATOR_OFFSET
    frameLevel = frameLevel or math.max(1, self:GetFrameLevel() + 1)
    position = R.VALID_SEPARATOR_POSITIONS[position] and position or "TOP"

    if position == "TOP" then
        separator.Texture:SetTexture(R.media.textures.edgeFiles.separatorHorizontal)
        separator:SetPoint("TOPLEFT", 0, offset)
        separator:SetPoint("TOPRIGHT", 0, offset)
    elseif position == "BOTTOM" then
        separator.Texture:SetTexture(R.media.textures.edgeFiles.separatorHorizontal)
        separator:SetPoint("BOTTOMLEFT", 0, -offset)
        separator:SetPoint("BOTTOMRIGHT", 0, -offset)
    elseif position == "LEFT" then
        separator.Texture:SetTexture(R.media.textures.edgeFiles.separatorVertical)
        separator:SetPoint("TOPLEFT", -offset, 0)
        separator:SetPoint("BOTTOMLEFT", -offset, 0)
    elseif position == "RIGHT" then
        separator.Texture:SetTexture(R.media.textures.edgeFiles.separatorVertical)
        separator:SetPoint("TOPRIGHT", offset, 0)
        separator:SetPoint("BOTTOMRIGHT", offset, 0)
    end

    separator.Texture:SetAllPoints()
    separator.Texture:SetVertexColor(unpack(color))

    separator:SetSize(size, size)
    separator:SetFrameLevel(self:GetFrameLevel() + 1)

    self.Separator = separator
end
