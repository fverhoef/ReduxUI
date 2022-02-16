local addonName, ns = ...
local R = _G.ReduxUI

R.PlayerInfo = {name = UnitName("player"), guid = UnitGUID("player"), class = select(2, UnitClass("player")), faction = UnitFactionGroup("player"), realm = GetRealmName()}

R.HiddenFrame = CreateFrame("Frame")
R.HiddenFrame:Hide()

R.UnlocalizedClasses = {}
for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do R.UnlocalizedClasses[v] = k end
for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do R.UnlocalizedClasses[v] = k end

R.EquipmentSlots = {
    "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot",
    "Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot"
}

if not R.isRetail then table.insert(R.EquipmentSlots, "RangedSlot") end

R.EmptyFunction = function() end

function R:ForceHide(frame, skipEvents)
	if not frame then return end

	if frame.UnregisterAllEvents then
		if not skipEvents then
			frame:UnregisterAllEvents()
		end

		if frame:GetName() then
			frame.ignoreFramePositionManager = true
			frame:SetAttribute("ignoreFramePositionManager", true)
			UIPARENT_MANAGED_FRAME_POSITIONS[frame:GetName()] = nil
		end
	end

	frame:Hide()
	frame:SetParent(R.HiddenFrame)
end

function R:UnlocalizedClassName(className)
    return (className and className ~= "") and R.UnlocalizedClasses[className]
end

function R:LocalizedClassName(className)
    return (className and className ~= "") and (UnitSex("player") == 2 and _G.LOCALIZED_CLASS_NAMES_MALE[className] or UnitSex("player") == 3 and _G.LOCALIZED_CLASS_NAMES_FEMALE[className]) or
               className
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
        if gold > 0 then str = format("%d%s%s", gold, goldname, (silver > 0 or copper > 0) and " " or "") end
        if silver > 0 then str = format("%s%d%s%s", str, silver, silvername, copper > 0 and " " or "") end
        if copper > 0 or value == 0 then str = format("%s%d%s", str, copper, coppername) end
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

function R:ShortValue(value, decimalPlaces)
    local absoluteValue = math.abs(value)
    local suffix = ""

    if absoluteValue >= 1e12 then
        suffix = "T"
        value = value / 1e12
        decimalPlaces = decimalPlaces or 1
    elseif absoluteValue >= 1e9 then
        suffix = "B"
        value = value / 1e9
        decimalPlaces = decimalPlaces or 1
    elseif absoluteValue >= 1e6 then
        suffix = "M"
        value = value / 1e6
        decimalPlaces = decimalPlaces or 1
    elseif absoluteValue >= 1e3 then
        suffix = "k"
        value = value / 1e3
        decimalPlaces = decimalPlaces or 1
    end

    return string.format("%." .. (decimalPlaces and tonumber(decimalPlaces) or 0) .. "f" .. suffix, value)
end

function R:SetInside(self, anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or 6
    yOffset = yOffset or 6
    anchor = anchor or self:GetParent()

    if self:GetPoint() then self:ClearAllPoints() end

    self:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
    self:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

function R:SetOutside(self, anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or 6
    yOffset = yOffset or 6
    anchor = anchor or self:GetParent()

    if self:GetPoint() then self:ClearAllPoints() end

    self:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
    self:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

function R:Offset(self, offsetX, offsetY)
    if self then
        local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
        if not self.originalPoint then self.originalPoint = {point = point, relativeTo = relativeTo, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs} end
        self:SetPoint(self.originalPoint.point, self.originalPoint.relativeTo, self.originalPoint.relativePoint, self.originalPoint.xOfs + offsetX, self.originalPoint.yOfs + offsetY)
    end
end

function R:SetPoint(self, arg1, arg2, arg3, arg4, arg5)
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

function R:GetPoint(frame)
    if not frame then return end
    local a1, af, a2, x, y = frame:GetPoint()
    if af and af:GetName() then af = af:GetName() end
    return {a1, af, a2, x, y}
end

function R:GetSize(frame)
    if not frame then return end
    return {frame:GetWidth(), frame:GetHeight()}
end

function R:ParseItemLink(itemLink)
    if not itemLink then return {} end
    local _, _, color, Ltype, itemId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLink,
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

function R:PlayerHasAura(auraId)
    local i = 1
    local spellId = select(10, UnitAura("player", i))
    while spellId do
        if spellId == auraId then return true end

        i = i + 1
        spellId = select(10, UnitAura("player", i))
    end

    return false
end

function R:GetAuraId(spellName, unit)
    local auraName, spellId
    for i = 1, 255 do
        auraName, _, _, _, _, _, _, _, _, spellId = UnitBuff(unit, i)
        if auraName == spellName then
            break
        elseif not auraName then
            spellId = nil
            break
        end
    end
    return spellId
end

function R:FixNormalTextureSize(button)
    local normalTexture = button:GetNormalTexture()
    if normalTexture then
        local texture = normalTexture:GetTexture()
        if texture == 130841 or texture == [[Interface\Buttons\UI-Quickslot2]] then
            local size = 66 * (button:GetWidth() / 36)
            normalTexture:SetSize(size, size)
        end
    end
end

function R:CopyTable(table, overwrites)
    local copy = {}

    for k, v in pairs(table) do
        if type(v) == "table" then
            copy[k] = R:CopyTable(v)
        else
            copy[k] = v
        end
    end

    if overwrites then R:OverwriteTableValues(copy, overwrites) end

    return copy
end

function R:OverwriteTableValues(target, overwrites)
    for k, v in pairs(overwrites) do
        if type(v) == "table" and target[k] then
            target[k] = R:OverwriteTableValues(target[k], v)
        else
            target[k] = v
        end
    end
    return target
end
