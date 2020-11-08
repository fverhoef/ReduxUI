local AddonName, AddonTable = ...
local Addon = AddonTable[1]

function Addon:FindButtonBorder(button)
    return _G[button:GetName() .. "IconBorder"] or button.IconBorder
end

Addon.CreateBorder = function(self, borderSize, R, G, B, uL1, ...)
    if self.Border then
        return
    end

    local uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
    if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end

    local space
    if borderSize >= 10 then
        space = 3
    else
        space = borderSize / 3.5
    end

    if not self.Border then
        self.Border = {}
        for i = 1, 8 do
            self.Border[i] = self:CreateTexture(nil, "OVERLAY")
            self.Border[i]:SetParent(self)
            self.Border[i]:SetTexture(Addon.media.textures.BorderNormal)
            self.Border[i]:SetSize(borderSize, borderSize)
            self.Border[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end

        self.Border[1]:SetTexCoord(0, 1 / 3, 0, 1 / 3)
        self.Border[1]:SetPoint("TOPLEFT", self, -(uL1 or 0), uL2 or 0)

        self.Border[2]:SetTexCoord(2 / 3, 1, 0, 1 / 3)
        self.Border[2]:SetPoint("TOPRIGHT", self, uR1 or 0, uR2 or 0)

        self.Border[3]:SetTexCoord(0, 1 / 3, 2 / 3, 1)
        self.Border[3]:SetPoint("BOTTOMLEFT", self, -(bL1 or 0), -(bL2 or 0))

        self.Border[4]:SetTexCoord(2 / 3, 1, 2 / 3, 1)
        self.Border[4]:SetPoint("BOTTOMRIGHT", self, bR1 or 0, -(bR2 or 0))

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

    if not self.Shadow then
        self.Shadow = {}
        for i = 1, 8 do
            self.Shadow[i] = self:CreateTexture(nil, "BORDER")
            self.Shadow[i]:SetParent(self)
            self.Shadow[i]:SetTexture(Addon.media.textures.BorderShadow)
            self.Shadow[i]:SetSize(borderSize, borderSize)
            self.Shadow[i]:SetVertexColor(0, 0, 0, 1)
        end

        self.Shadow[1]:SetTexCoord(0, 1 / 3, 0, 1 / 3)
        self.Shadow[1]:SetPoint("TOPLEFT", self, -(uL1 or 0) - space, (uL2 or 0) + space)

        self.Shadow[2]:SetTexCoord(2 / 3, 1, 0, 1 / 3)
        self.Shadow[2]:SetPoint("TOPRIGHT", self, (uR1 or 0) + space, (uR2 or 0) + space)

        self.Shadow[3]:SetTexCoord(0, 1 / 3, 2 / 3, 1)
        self.Shadow[3]:SetPoint("BOTTOMLEFT", self, -(bL1 or 0) - space, -(bL2 or 0) - space)

        self.Shadow[4]:SetTexCoord(2 / 3, 1, 2 / 3, 1)
        self.Shadow[4]:SetPoint("BOTTOMRIGHT", self, (bR1 or 0) + space, -(bR2 or 0) - space)

        self.Shadow[5]:SetTexCoord(1 / 3, 2 / 3, 0, 1 / 3)
        self.Shadow[5]:SetPoint("TOPLEFT", self.Shadow[1], "TOPRIGHT")
        self.Shadow[5]:SetPoint("TOPRIGHT", self.Shadow[2], "TOPLEFT")

        self.Shadow[6]:SetTexCoord(1 / 3, 2 / 3, 2 / 3, 1)
        self.Shadow[6]:SetPoint("BOTTOMLEFT", self.Shadow[3], "BOTTOMRIGHT")
        self.Shadow[6]:SetPoint("BOTTOMRIGHT", self.Shadow[4], "BOTTOMLEFT")

        self.Shadow[7]:SetTexCoord(0, 1 / 3, 1 / 3, 2 / 3)
        self.Shadow[7]:SetPoint("TOPLEFT", self.Shadow[1], "BOTTOMLEFT")
        self.Shadow[7]:SetPoint("BOTTOMLEFT", self.Shadow[3], "TOPLEFT")

        self.Shadow[8]:SetTexCoord(2 / 3, 1, 1 / 3, 2 / 3)
        self.Shadow[8]:SetPoint("TOPRIGHT", self.Shadow[2], "BOTTOMRIGHT")
        self.Shadow[8]:SetPoint("BOTTOMRIGHT", self.Shadow[4], "TOPRIGHT")
    end
end

Addon.DestroyBorder = function(self)
    if self.Border then
        for i = 1, 8 do
            if self.Border[i] then
                Kill(self.Border[i])
            end
        end
    end
    self.Border = nil

    if self.Shadow then
        for i = 1, 8 do
            if self.Shadow[i] then
                Kill(self.Shadow[i])
            end
        end
    end
    self.Shadow = nil
end

Addon.UpdateBorder = function(self, borderSize, R, G, B, uL1, ...)
    if not self.Border then
        Addon.CreateBorder(self, borderSize, R, G, B, uL1, ...)
    else
        local uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
        if (uL1) then
            if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
                uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
            end
        end

        local space
        if borderSize >= 10 then
            space = 3
        else
            space = borderSize / 3.5
        end

        for i = 1, 8 do
            self.Border[i]:SetSize(borderSize, borderSize)
            self.Border[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end

        self.Border[1]:ClearAllPoints()
        self.Border[1]:SetPoint("TOPLEFT", self, -(uL1 or 0), uL2 or 0)
        self.Border[2]:ClearAllPoints()
        self.Border[2]:SetPoint("TOPRIGHT", self, uR1 or 0, uR2 or 0)
        self.Border[3]:ClearAllPoints()
        self.Border[3]:SetPoint("BOTTOMLEFT", self, -(bL1 or 0), -(bL2 or 0))
        self.Border[4]:ClearAllPoints()
        self.Border[4]:SetPoint("BOTTOMRIGHT", self, bR1 or 0, -(bR2 or 0))

        for i = 1, 8 do
            self.Shadow[i]:SetSize(borderSize, borderSize)
            self.Shadow[i]:SetVertexColor(0, 0, 0, 1)
        end

        self.Shadow[1]:ClearAllPoints()
        self.Shadow[1]:SetPoint("TOPLEFT", self, -(uL1 or 0) - space, (uL2 or 0) + space)
        self.Shadow[2]:ClearAllPoints()
        self.Shadow[2]:SetPoint("TOPRIGHT", self, (uR1 or 0) + space, (uR2 or 0) + space)
        self.Shadow[3]:ClearAllPoints()
        self.Shadow[3]:SetPoint("BOTTOMLEFT", self, -(bL1 or 0) - space, -(bL2 or 0) - space)
        self.Shadow[4]:ClearAllPoints()
        self.Shadow[4]:SetPoint("BOTTOMRIGHT", self, (bR1 or 0) + space, -(bR2 or 0) - space)
    end
end

Addon.SetBorderPadding = function(self, uL1, ...)
    local uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
    if uL1 then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end

    local size = Addon.GetBorderInfo(self) or 6
    local space = 3
    if size < 10 then
        space = size / 3.5
    end

    if self.Border then
        self.Border[1]:SetPoint("TOPLEFT", self, -(uL1 or 0), uL2 or 0)
        self.Border[2]:SetPoint("TOPRIGHT", self, uR1 or 0, uR2 or 0)
        self.Border[3]:SetPoint("BOTTOMLEFT", self, -(bL1 or 0), -(bL2 or 0))
        self.Border[4]:SetPoint("BOTTOMRIGHT", self, bR1 or 0, -(bR2 or 0))

        self.Shadow[1]:SetPoint("TOPLEFT", self, -(uL1 or 0) - space, (uL2 or 0) + space)
        self.Shadow[2]:SetPoint("TOPRIGHT", self, (uR1 or 0) + space, (uR2 or 0) + space)
        self.Shadow[3]:SetPoint("BOTTOMLEFT", self, -(bL1 or 0) - space, -(bL2 or 0) - space)
        self.Shadow[4]:SetPoint("BOTTOMRIGHT", self, (bR1 or 0) + space, -(bR2 or 0) - space)
    end
end

Addon.SetBorderColor = function(self, R, G, B)
    if self.Border then
        for i = 1, 8 do
            self.Border[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end
    end
end

Addon.SetBorderNormalTexture = function(self, texture)
    if self.Border then
        for i = 1, 8 do
            self.Border[i]:SetTexture(texture)
        end
    end
end

Addon.SetShadowColor = function(self, R, G, B)
    if self.Shadow then
        for i = 1, 8 do
            self.Shadow[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end
    end
end

Addon.SetBorderShadowTexture = function(self, texture)
    if self.Shadow then
        for i = 1, 8 do
            self.Shadow[i]:SetTexture(texture)
        end
    end
end

Addon.HasBorder = function(self)
    if self.Border then
        return true
    else
        return false
    end
end

Addon.GetBorderInfo = function(self)
    if self.Border then
        local tex = self.Border[1]:GetTexture()
        local size = self.Border[1]:GetSize()
        local r, g, b, a = self.Border[1]:GetVertexColor()

        return size, tex, r, g, b, a
    end
end
