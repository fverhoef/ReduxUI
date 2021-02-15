local addonName, ns = ...
local R = _G.ReduxUI

R.PlayerName = UnitName("player")
R.PlayerClass = select(2, UnitClass("player"))
R.PlayerFaction = UnitFactionGroup("player")
R.PlayerRealm = GetRealmName()
R.PlayerSex = UnitSex("player")
R.PlayerIsMale = R.PlayerSex == 2
R.PlayerIsFemale = R.PlayerSex == 3

R.HiddenFrame = CreateFrame("Frame")
R.HiddenFrame:Hide()

R.UnlocalizedClasses = {}
for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
    R.UnlocalizedClasses[v] = k
end
for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do
    R.UnlocalizedClasses[v] = k
end

R.EquipmentSlots = {
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

if R.isClassic then
    table.insert(R.EquipmentSlots, "RangedSlot")
end

function R:UnlocalizedClassName(className)
    return (className and className ~= "") and R.UnlocalizedClasses[className]
end

function R:LocalizedClassName(className)
    return (className and className ~= "") and
               (R.PlayerIsMale and _G.LOCALIZED_CLASS_NAMES_MALE[className] or R.PlayerIsFemale and
                   _G.LOCALIZED_CLASS_NAMES_FEMALE[className]) or className
end

function R:Print(value, ...)
    print(R.title .. ":", string.format(value, ...))
end

function R:PrintError(value, ...)
    print(R.title .. ": error ", string.format(value, ...))
end

function R:FormatValue(value)
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

function R:FormatMoney(amount, style, textonly)
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

function R:Hex(r, g, b)
    if (type(r) == "table") then
        if (r.r) then
            r, g, b = r.r, r.g, r.b
        else
            r, g, b = unpack(r)
        end
    end

    return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

function R:RomanNumeral(number)
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

function R:GetPoint(frame)
    if not frame then
        return
    end
    local a1, af, a2, x, y = frame:GetPoint()
    if af and af:GetName() then
        af = af:GetName()
    end
    return {a1, af, a2, x, y}
end

function R:GetSize(frame)
    if not frame then
        return
    end
    return {frame:GetWidth(), frame:GetHeight()}
end

function R:ParseItemLink(itemLink)
    if not itemLink then
        return {}
    end
    local _, _, color, Ltype, itemId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name =
        string.find(itemLink,
                    "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

    return {itemId = itemId, color = color}
end

function R:GetItemIdFromLink(itemLink)
    return R:ParseItemLink(itemLink).itemId
end

function R:FindButtonBorder(button)
    return _G[button:GetName() .. "IconBorder"] or button.IconBorder
end

function R:PlayerCanInvite()
    return not UnitExists("party1") or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")
end

function R:FixNormalTextureSize(button)
    local normalTexture = button:GetNormalTexture()
    if normalTexture then
        local texturePath = normalTexture:GetTexture()
        if texturePath == "Interface\\Buttons\\UI-Quickslot2" then
            local size = 66 * (button:GetWidth() / 36)
            normalTexture:SetSize(size, size)
        end
    end
end

function R:ApplyTexCoords(texture, texCoord)
    if not texture or not texCoord or texture.__texCoord == texCoord then
        return
    end
    texture.__texCoord = texCoord
    texture:SetTexCoord(unpack(texCoord))
    if not texture.hookedSetTexCoord then
        texture.hookedSetTexCoord = true
        R:SecureHook(texture, "SetTexCoord", R.ResetTexCoord)
    end
end

function R:ResetTexCoord(texCoord)
    if not self.__texCoord or texCoord == self.__texCoord then
        return
    end
    self:SetTexCoord(unpack(self.__texCoord))
end

function R:ApplyTexture(texture, file)
    if not texture or not file or texture.__textureFile == file then
        return
    end
    texture.__textureFile = file
    texture:SetTexture(file)
    if not texture.hookedSetTexture then
        texture.hookedSetTexture = true
        R:SecureHook(texture, "SetTexture", R.ResetTexture)
    end
end

function R:ResetTexture(file)
    if not self.__textureFile or file == self.__textureFile then
        return
    end
    self:SetTexture(self.__textureFile)
end

function R:ApplyNormalTexture(button, file)
    if not button or not file or button.__normalTextureFile == file then
        return
    end
    button.__normalTextureFile = file
    button:SetNormalTexture(file)
    if not button.hookedSetNormalTexture then
        button.hookedSetNormalTexture = true
        R:SecureHook(button, "SetNormalTexture", R.ResetNormalTexture)
    end
end

function R:ResetNormalTexture(file)
    if not self.__normalTextureFile or file == self.__normalTextureFile then
        return
    end
    self:SetNormalTexture(self.__normalTextureFile)
end

function R:ApplyPushedTexture(button, file)
    if not button or not file or button.__pushedTextureFile == file then
        return
    end
    button.__pushedTextureFile = file
    button:SetPushedTexture(file)
    if not button.hookedSetPushedTexture then
        button.hookedSetPushedTexture = true
        R:SecureHook(button, "SetPushedTexture", R.ResetPushedTexture)
    end
end

function R:ResetPushedTexture(file)
    if not self.__pushedTextureFile or file == self.__pushedTextureFile then
        return
    end
    self:SetPushedTexture(self.__pushedTextureFile)
end

function R:ApplyHighlightTexture(button, file)
    if not button or not file or button.__highlightTextureFile == file then
        return
    end
    button.__highlightTextureFile = file
    button:SetHighlightTexture(file)
    if not button.hookedSetHighlightTexture then
        button.hookedSetHighlightTexture = true
        R:SecureHook(button, "SetHighlightTexture", R.ResetHighlightTexture)
    end
end

function R:ResetHighlightTexture(file)
    if not self.__highlightTextureFile or file == self.__highlightTextureFile then
        return
    end
    self:SetHighlightTexture(self.__highlightTextureFile)
end

function R:ApplyCheckedTexture(button, file)
    if not button or not file or button.__checkedTextureFile == file then
        return
    end
    button.__checkedTextureFile = file
    button:SetCheckedTexture(file)
    if not button.hookedSetCheckedTexture then
        button.hookedSetCheckedTexture = true
        R:SecureHook(button, "SetCheckedTexture", R.ResetCheckedTexture)
    end
end

function R:ResetCheckedTexture(file)
    if not self.__checkedTextureFile or file == self.__checkedTextureFile then
        return
    end
    self:SetCheckedTexture(self.__checkedTextureFile)
end

function R:ApplyVertexColor(texture, color)
    if not color or texture.__vertexColor == color then
        return
    end
    if texture.__vertexColor and
        (color[1] == texture.__vertexColor[1] and color[2] == texture.__vertexColor[2] and color[3] == texture.__vertexColor[3] and
            (color[4] or 1) == (texture.__vertexColor[4] or 1)) then
        return
    end

    texture.__vertexColor = color
    texture:SetVertexColor(unpack(color))

    if not texture.hookedSetVertexColor then
        texture.hookedSetVertexColor = true
        R:SecureHook(texture, "SetVertexColor", R.ResetVertexColor)
    end
end

function R:ResetVertexColor(r, g, b, a)
    if not self.__vertexColor then
        return
    end
    if r ~= self.__vertexColor[1] or g ~= self.__vertexColor[2] or b ~= self.__vertexColor[3] or
        ((a or 1) ~= (self.__vertexColor[4] or 1)) then
        self:SetVertexColor(unpack(self.__vertexColor))
    end
end
