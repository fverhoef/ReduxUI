local AddonName, AddonTable = ...
local Addon = AddonTable[1]

Addon.PlayerName = UnitName("player")
Addon.PlayerClass = select(2, UnitClass("player"))
Addon.PlayerFaction = UnitFactionGroup("player")
Addon.PlayerRealm = GetRealmName()
Addon.PlayerSex = UnitSex("player")
Addon.PlayerIsMale = Addon.PlayerSex == 2
Addon.PlayerIsFemale = Addon.PlayerSex == 3

Addon.HiddenFrame = CreateFrame("Frame")
Addon.HiddenFrame:Hide()

Addon.UnlocalizedClasses = {}
for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
    Addon.UnlocalizedClasses[v] = k
end
for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do
    Addon.UnlocalizedClasses[v] = k
end

Addon.EquipmentSlots = {
    "HeadSlot",
    "NeckSlot",
    "ShoulderSlot",
    "BackSlot",
    "ChestSlot",
    "ShirtSlot",
    "TabardSlot",
    "WristSlot",
    "HandsSlot",
    "WaistSlot",
    "LegsSlot",
    "FeetSlot",
    "Finger0Slot",
    "Finger1Slot",
    "Trinket0Slot",
    "Trinket1Slot",
    "MainHandSlot",
    "SecondaryHandSlot"
}

if Addon.IsClassic then
    table.insert(Addon.EquipmentSlots, "RangedSlot")
end

function Addon:UnlocalizedClassName(className)
    return (className and className ~= "") and Addon.UnlocalizedClasses[className]
end

function Addon:LocalizedClassName(className)
    return (className and className ~= "") and
               (Addon.PlayerIsMale and _G.LOCALIZED_CLASS_NAMES_MALE[className] or Addon.PlayerIsFemale and _G.LOCALIZED_CLASS_NAMES_FEMALE[className]) or className
end

function Addon:Print(value, ...)
    print(Addon.title .. ":", string.format(value, ...))
end

function Addon:PrintError(value, ...)
    print(Addon.title .. ": error ", string.format(value, ...))
end

function Addon:FormatValue(value)
    if value < 1e3 then
        return math.floor(value)
    elseif value >= 1e12 then
        return string.format("%.3ft", value / 1e12)
    elseif value >= 1e9 then
        return string.format("%.3fb", value / 1e9)
    elseif value >= 1e6 then
        return string.format("%.2fm", value / 1e6)
    elseif value >= 1e3 then
        return string.format("%.1fk", value / 1e3)
    end
end

local COLOR_COPPER, COLOR_SILVER, COLOR_GOLD = "|cffeda55f", "|cffc7c7cf", "|cffffd700"
local ICON_COPPER = "|TInterface\\MoneyFrame\\UI-CopperIcon:12:12|t"
local ICON_SILVER = "|TInterface\\MoneyFrame\\UI-SilverIcon:12:12|t"
local ICON_GOLD = "|TInterface\\MoneyFrame\\UI-GoldIcon:12:12|t"

function Addon:FormatMoney(amount, style, textonly)
    local coppername = textonly and L["copperabbrev"] or ICON_COPPER
    local silvername = textonly and L["silverabbrev"] or ICON_SILVER
    local goldname = textonly and L["goldabbrev"] or ICON_GOLD

    local value = abs(amount)
    local gold = floor(value / 10000)
    local silver = floor(mod(value / 100, 100))
    local copper = floor(mod(value, 100))

    if not style or style == "SMART" then
        local str = ""
        if gold > 0 then
            str = format("%d%s%s", gold, goldname, (silver > 0 or copper > 0) and " " or "")
        end
        if silver > 0 then
            str = format("%s%d%s%s", str, silver, silvername, copper > 0 and " " or "")
        end
        if copper > 0 or value == 0 then
            str = format("%s%d%s", str, copper, coppername)
        end
        return str
    end

    if style == "FULL" then
        if gold > 0 then
            return format("%d%s %d%s %d%s", gold, goldname, silver, silvername, copper, coppername)
        elseif silver > 0 then
            return format("%d%s %d%s", silver, silvername, copper, coppername)
        else
            return format("%d%s", copper, coppername)
        end
    elseif style == "SHORT" then
        if gold > 0 then
            return format("%.1f%s", amount / 10000, goldname)
        elseif silver > 0 then
            return format("%.1f%s", amount / 100, silvername)
        else
            return format("%d%s", amount, coppername)
        end
    elseif style == "SHORTINT" then
        if gold > 0 then
            return format("%d%s", gold, goldname)
        elseif silver > 0 then
            return format("%d%s", silver, silvername)
        else
            return format("%d%s", copper, coppername)
        end
    elseif style == "CONDENSED" then
        if gold > 0 then
            return format("%s%d|r.%s%02d|r.%s%02d|r", COLOR_GOLD, gold, COLOR_SILVER, silver, COLOR_COPPER, copper)
        elseif silver > 0 then
            return format("%s%d|r.%s%02d|r", COLOR_SILVER, silver, COLOR_COPPER, copper)
        else
            return format("%s%d|r", COLOR_COPPER, copper)
        end
    elseif style == "BLIZZARD" then
        if gold > 0 then
            return format("%s%s %d%s %d%s", BreakUpLargeNumbers(gold), goldname, silver, silvername, copper, coppername)
        elseif silver > 0 then
            return format("%d%s %d%s", silver, silvername, copper, coppername)
        else
            return format("%d%s", copper, coppername)
        end
    elseif style == "BLIZZARD2" then
        if gold > 0 then
            return format("%s%s %02d%s %02d%s", BreakUpLargeNumbers(gold), goldname, silver, silvername, copper, coppername)
        elseif silver > 0 then
            return format("%d%s %02d%s", silver, silvername, copper, coppername)
        else
            return format("%d%s", copper, coppername)
        end
    end

    -- Shouldn't be here; punt
    return self:FormatMoney(amount, "SMART")
end

function Addon:Hex(r, g, b)
    if (type(r) == "table") then
        if (r.r) then
            r, g, b = r.r, r.g, r.b
        else
            r, g, b = unpack(r)
        end
    end

    return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

function Addon:RomanNumeral(number)
    local roman = nil
    if number == 1 then
        roman = "I"
    elseif number == 2 then
        roman = "II"
    elseif number == 3 then
        roman = "III"
    elseif number == 4 then
        roman = "IV"
    elseif number == 5 then
        roman = "V"
    elseif number == 6 then
        roman = "VI"
    elseif number == 7 then
        roman = "VII"
    elseif number == 8 then
        roman = "VIII"
    elseif number == 9 then
        roman = "IX"
    elseif number == 10 then
        roman = "X"
    end

    return roman
end

function Addon:GetPoint(frame)
    if not frame then
        return
    end
    local a1, af, a2, x, y = frame:GetPoint()
    if af and af:GetName() then
        af = af:GetName()
    end
    return {a1, af, a2, x, y}
end

function Addon:GetSize(frame)
    if not frame then
        return
    end
    return {frame:GetWidth(), frame:GetHeight()}
end

function Addon:SetOutside(obj, anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or 6
    yOffset = yOffset or 6
    anchor = anchor or obj:GetParent()

    if obj:GetPoint() then
        obj:ClearAllPoints()
    end

    obj:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
    obj:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

function Addon:SetInside(obj, anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or 6
    yOffset = yOffset or 6
    anchor = anchor or obj:GetParent()

    if obj:GetPoint() then
        obj:ClearAllPoints()
    end

    obj:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
    obj:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

function Addon:ParseItemLink(itemLink)
    if not itemLink then
        return {}
    end
    local _, _, color, Ltype, itemId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name =
        string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

    return {itemId = itemId, color = color}
end

function Addon:GetItemIdFromLink(itemLink)
    return Addon:ParseItemLink(itemLink).itemId
end

function Addon:FixNormalTextureSize(button)
    local normalTexture = button:GetNormalTexture()
    if normalTexture then
        local texturePath = normalTexture:GetTexture()
        if texturePath == "Interface\\Buttons\\UI-Quickslot2" then
            local size = 66 * (button:GetWidth() / 36)
            normalTexture:SetSize(size, size)
        end
    end
end

function Addon:ApplyTexCoords(texture, texCoord)
    if not texture or not texCoord then
        return
    end
    texture.__texCoord = texCoord
    texture:SetTexCoord(unpack(texCoord))
    if not texture.hookedSetTexCoord then
        texture.hookedSetTexCoord = true
        Addon:SecureHook(texture, "SetTexCoord", function(self, texCoord)
            if not self.__texCoord or texCoord == self.__texCoord then
                return
            end
            self:SetTexCoord(unpack(self.__texCoord))
        end)
    end
end

function Addon:ApplyTexture(texture, file)
    if not texture or not file then
        return
    end
    texture.__textureFile = file
    texture:SetTexture(file)
    if not texture.hookedSetTexture then
        texture.hookedSetTexture = true
        Addon:SecureHook(texture, "SetTexture", function(self, file)
            if not self.__textureFile or file == self.__textureFile then
                return
            end
            self:SetTexture(self.__textureFile)
        end)
    end
end

function Addon:ApplyNormalTexture(button, file)
    if not button or not file then
        return
    end
    button.__normalTextureFile = file
    button:SetNormalTexture(file)
    if not button.hookedSetNormalTexture then
        button.hookedSetNormalTexture = true
        Addon:SecureHook(button, "SetNormalTexture", function(self, file)
            if not self.__normalTextureFile or file == self.__normalTextureFile then
                return
            end
            self:SetNormalTexture(self.__normalTextureFile)
        end)
    end
end

function Addon:ApplyPushedTexture(button, file)
    if not button or not file then
        return
    end
    button.__pushedTextureFile = file
    button:SetPushedTexture(file)
    if not button.hookedSetPushedTexture then
        button.hookedSetPushedTexture = true
        Addon:SecureHook(button, "SetPushedTexture", function(self, file)
            if not self.__pushedTextureFile or file == self.__pushedTextureFile then
                return
            end
            self:SetPushedTexture(self.__pushedTextureFile)
        end)
    end
end

function Addon:ApplyHighlightTexture(button, file)
    if not button or not file then
        return
    end
    button.__highlightTextureFile = file
    button:SetHighlightTexture(file)
    if not button.hookedSetHighlightTexture then
        button.hookedSetHighlightTexture = true
        Addon:SecureHook(button, "SetHighlightTexture", function(self, file)
            if not self.__highlightTextureFile or file == self.__highlightTextureFile then
                return
            end
            self:SetHighlightTexture(self.__highlightTextureFile)
        end)
    end
end

function Addon:ApplyCheckedTexture(button, file)
    if not button or not file then
        return
    end
    button.__checkedTextureFile = file
    button:SetCheckedTexture(file)
    if not button.hookedSetCheckedTexture then
        button.hookedSetCheckedTexture = true
        Addon:SecureHook(button, "SetCheckedTexture", function(self, file)
            if not self.__checkedTextureFile or file == self.__checkedTextureFile then
                return
            end
            self:SetCheckedTexture(self.__checkedTextureFile)
        end)
    end
end

function Addon:ApplyVertexColor(texture, color)
    if not color then
        return
    end
    texture.__vertexColor = color
    texture:SetVertexColor(unpack(color))
    if not texture.hookedSetVertexColor then
        texture.hookedSetVertexColor = true
        Addon:SecureHook(texture, "SetVertexColor", function(self, r, g, b, a)
            if not self.__vertexColor then
                return
            end
            local r2, g2, b2, a2 = unpack(self.__vertexColor)
            if not a2 then
                a2 = 1
            end
            if r ~= r2 or g ~= g2 or b ~= b2 or a ~= a2 then
                self:SetVertexColor(r2, g2, b2, a2)
            end
        end)
    end
end

function Addon:OffsetFrame(frame, offsetX, offsetY)
    if frame then
        local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
        if not frame.OriginalPoint then
            frame.OriginalPoint = {point = point, relativeTo = relativeTo, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs}
        end
        frame:SetPoint(frame.OriginalPoint.point, frame.OriginalPoint.relativeTo, frame.OriginalPoint.relativePoint, frame.OriginalPoint.xOfs + offsetX,
                       frame.OriginalPoint.yOfs + offsetY)
    end
end
