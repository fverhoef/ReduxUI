local addonName, ns = ...
local R = _G.ReduxUI
local TT = R:AddModule("Tooltips", "AceEvent-3.0", "AceHook-3.0")
local ID = R.Modules.InventoryDatabase
local L = R.L
local oUF = ns.oUF or oUF

local LEVEL1 = strlower(_G.TOOLTIP_UNIT_LEVEL:gsub("%s?%%s%s?%-?", ""))
local LEVEL2 = strlower(_G.TOOLTIP_UNIT_LEVEL_CLASS:gsub("^%%2$s%s?(.-)%s?%%1$s", "%1"):gsub("^%-?г?о?%s?", ""):gsub("%s?%%s%s?%-?", ""))

TT.classColors = {}
TT.factionColors = {}
TT.mountIDs = {}

function TT:Initialize() end

function TT:Enable()
    if not TT.config.enabled then return end

    for class, color in next, _G.RAID_CLASS_COLORS do TT.classColors[class] = R:Hex(color) end
    for i = 1, #_G.FACTION_BAR_COLORS do TT.factionColors[i] = R:Hex(_G.FACTION_BAR_COLORS[i]) end

    _G.GameTooltipStatusBar:ClearAllPoints()
    _G.GameTooltipStatusBar:SetNormalizedPoint("BOTTOMLEFT", "TOPLEFT", 3, 2)
    _G.GameTooltipStatusBar:SetNormalizedPoint("BOTTOMRIGHT", "TOPRIGHT", -3, 2)
    _G.GameTooltipStatusBar:SetHeight(10)
    _G.GameTooltipStatusBar:CreateBorder({1, 1, 1}, 8, 2)

    _G.GameTooltipStatusBar:SetStatusBarTexture(TT.config.statusbar)

    _G.GameTooltipStatusBar.Background = _G.GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND", nil, -8)
    _G.GameTooltipStatusBar.Background:SetAllPoints()
    _G.GameTooltipStatusBar.Background:SetColorTexture(1, 1, 1)
    _G.GameTooltipStatusBar.Background:SetVertexColor(0, 0, 0, 0.5)

    _G.GameTooltipStatusBar.TextHolder = CreateFrame("Frame", nil, _G.GameTooltipStatusBar)
    _G.GameTooltipStatusBar.TextHolder:SetFrameLevel(_G.GameTooltipStatusBar.TextHolder:GetFrameLevel() + 2)
    _G.GameTooltipStatusBar.Text = _G.GameTooltipStatusBar.TextHolder:CreateFontString(nil, "OVERLAY", nil, 7)
    _G.GameTooltipStatusBar.Text:SetPoint("CENTER", _G.GameTooltipStatusBar, 0, 0)

    TT:SecureHookScript(_G.GameTooltipStatusBar, "OnValueChanged", TT.OnStatusBarValueChanged)
    TT:SecureHook("GameTooltip_SetDefaultAnchor", TT.SetDefaultAnchor)
    TT:SecureHookScript(_G.GameTooltip, "OnTooltipSetUnit", TT.OnTooltipSetUnit)

    TT:SecureHook(_G.GameTooltip, "SetUnitBuff", TT.SetUnitBuff)
    TT:SecureHook(_G.GameTooltip, "SetUnitDebuff", TT.SetUnitDebuff)
    TT:SecureHook(_G.GameTooltip, "SetUnitAura", TT.SetUnitAura)
    TT:SecureHook("SetItemRef", TT.SetItemRef)

    TT:SecureHookScript(_G.GameTooltip, "OnTooltipSetItem", TT.OnTooltipSetItem)
    TT:SecureHookScript(_G.GameTooltip, "OnTooltipSetSpell", TT.OnTooltipSetSpell)

    TT:SecureHookScript(_G.ItemRefTooltip, "OnTooltipSetItem", TT.OnTooltipSetItem)
    TT:SecureHookScript(_G.ItemRefTooltip, "OnTooltipSetSpell", TT.OnTooltipSetSpell)

    TT:SecureHookScript(_G.GameTooltip, "OnShow", TT.OnShow)

    TT:UpdateAll()
end

function TT:UpdateAll()
    TT:UpdateFonts()

    local tooltips = {
        _G.GameTooltip, _G.ShoppingTooltip1, _G.ShoppingTooltip2, _G.ItemRefTooltip, _G.ItemRefShoppingTooltip1, _G.ItemRefShoppingTooltip2, _G.WorldMapTooltip, _G.WorldMapCompareTooltip1,
        _G.WorldMapCompareTooltip2, _G.SmallTextTooltip
    }
    for _, tooltip in next, tooltips do TT:Update(tooltip) end

    local menus = {_G.DropDownList1MenuBackdrop, _G.DropDownList2MenuBackdrop}
    for _, menu in next, menus do menu:SetScale(TT.config.scale) end
end

function TT:Update(tooltip)
    tooltip:SetScale(TT.config.scale)

    if TT.config.colorBorderByRarity and tooltip.NineSlice and tooltip.GetItem then
        tooltip.defaultBorderColor = tooltip.defaultBorderColor or {tooltip.NineSlice:GetBorderColor()}
        local color = tooltip.defaultBorderColor
        local _, link = tooltip:GetItem()
        if link then
            local _, _, itemRarity = GetItemInfo(link)
            if itemRarity and itemRarity > 1 then color = {GetItemQualityColor(itemRarity)} end
        end
        tooltip.NineSlice:SetBorderColor(unpack(color))
    end
end

function TT:GetTarget(unit)
    if UnitIsUnit(unit, "player") then
        return ("|cffff0000%s|r"):format("<YOU>")
    elseif UnitIsPlayer(unit, "player") then
        local _, class = UnitClass(unit)
        return ("%s%s|r"):format(TT.classColors[class], UnitName(unit))
    elseif UnitReaction(unit, "player") then
        return ("%s%s|r"):format(TT.factionColors[UnitReaction(unit, "player")], UnitName(unit))
    else
        return ("|cffffffff%s|r"):format(UnitName(unit))
    end
end

function TT:SetUnitBuff(...) TT:AddSpellID(self, select(10, UnitBuff(...))) end

function TT:SetUnitDebuff(...) TT:AddSpellID(self, select(10, UnitDebuff(...))) end

function TT:SetUnitAura(...) TT:AddSpellID(self, select(10, UnitAura(...))) end

function TT:SetItemRef(...)
    local link = self
    local type, value = link:match("(%a+):(.+)")
    if type == "spell" then TT:AddSpellID(_G.ItemRefTooltip, value:match("([^:]+)")) end
end

function TT:OnTooltipSetUnit()
    local unitName, unit = self:GetUnit()
    if not unit then return end

    local raidIconIndex = GetRaidTargetIndex(unit)
    if raidIconIndex then _G.GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[raidIconIndex] .. "14|t", unitName)) end

    if UnitIsPlayer(unit) then
        TT:FormatNameText(self, unit)
        TT:FormatGuildText(self, unit)
        TT:FormatPvPText(self)

        local rank = UnitPVPRank and UnitPVPRank(unit)
        if rank and rank > 0 then
            -- rank starts at 5 for some reason
            rank = rank - 4
            TT:AddPvPRank(self, rank)
        end

        TT:AddMountText(self, unit)
    end
    TT:FormatLevelText(self, unit)
    TT:AddStatusBarColor(self)

    if UnitIsDeadOrGhost(unit) then _G.GameTooltipTextLeft1:SetTextColor(unpack(TT.config.colors.dead)) end

    if (UnitExists(unit .. "target")) then _G.GameTooltip:AddDoubleLine(("%s%s|r"):format(R:Hex(TT.config.colors.target), "Target"), TT:GetTarget(unit .. "target") or "Unknown") end
end

function TT:OnTooltipSetItem()
    local itemName, link = self:GetItem()
    if link then
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, sellPrice, classID = GetItemInfo(link)
        TT:AddIcon(self, itemIcon)
        if itemEquipLoc and itemEquipLoc ~= "" then TT:AddItemLevel(self, itemLevel) end
        TT:AddVendorPrice(self, sellPrice, classID)

        local itemId = R:GetItemIdFromLink(itemLink)
        if itemId then
            TT:AddItemCount(self, itemId)
            TT:AddItemID(self, itemId)
        end

        self:Show()
    end
end

function TT:OnTooltipSetSpell()
    local spellName, spellId = self:GetSpell()
    if spellName then
        local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellId)

        TT:AddIcon(self, icon)
        TT:AddSpellID(self, spellId)

        self:Show()
    end
end

function TT:OnShow() TT:Update(self) end

function TT:OnStatusBarSetColor(r, g, b) TT:AddStatusBarColor(self:GetParent()) end

function TT:OnStatusBarValueChanged(value)
    if TT.config.showHealthValues then
        local tooltip = self:GetParent()
        local unit = select(2, tooltip:GetUnit())
        if not unit then
            local focus = GetMouseFocus()
            if (focus and focus.GetAttribute and focus:GetAttribute("unit")) then unit = focus:GetAttribute("unit") end
        end
        if not unit then return end

        local _, max = self:GetMinMaxValues()
        if (value > 0 and max == 1) then
            self.Text:SetFormattedText("%d%%", floor(value * 100))
        elseif (value == 0 or (unit and UnitIsDeadOrGhost(unit))) then
            self.Text:SetText(_G.DEAD)
        else
            self.Text:SetText(R:FormatValue(value) .. " / " .. R:FormatValue(max))
        end

        TT:AddStatusBarColor(tooltip)
    else
        self.Text:Hide()
    end
end

function TT:SetDefaultAnchor(owner)
    if not TT.config.anchor then return end
    local anchor = TT.config.anchor

    -- override anchor for action bar buttons
    local parent = owner:GetParent()
    if parent then
        if parent == _G.MultiBarBottomRight or parent == _G.MultiBarRight or parent == _G.MultiBarLeft then
            anchor = "ANCHOR_LEFT"
        elseif parent == _G.MainMenuBar or parent == _G.MultiBarBottomLeft or parent == _G.StanceBarFrame or _G.PetActionBarFrame then
            anchor = "ANCHOR_RIGHT"
        end
    end

    if anchor == "ANCHOR_CURSOR" then
        self:SetOwner(owner, anchor, TT.config.offsetX, TT.config.offsetY)
    else
        self:SetOwner(owner, anchor)
    end
end

function TT:AddIcon(tooltip, icon)
    if icon and TT.config.showIcons then
        local title = _G[tooltip:GetName() .. "TextLeft1"]
        if title and not title:GetText():find("|T" .. icon) then title:SetFormattedText("|T%s:20:20:0:0:64:64:5:59:5:59:%d|t %s", icon, 40, title:GetText()) end
    end
end

function TT:AddSpellID(tooltip, spellId) if spellId and TT.config.showSpellId then tooltip:AddDoubleLine("|cff0099ffSpell ID|r", spellId) end end

function TT:AddItemID(tooltip, itemId) if itemId and TT.config.showItemId then tooltip:AddDoubleLine("|cff0099ffItem ID|r", itemId) end end

function TT:AddItemCount(tooltip, itemId)
    if itemId and TT.config.showItemCount then
        local charCounts = ID:GetItemCount(itemId)
        for char, count in pairs(charCounts) do
            local value = ""
            if count.equipped > 0 then
                value = "Equipped: " .. count.equipped -- TODO: Localize
            end
            if count.bag > 0 then
                if value ~= "" then value = value .. " | " end
                value = value .. "Bags: " .. count.bag -- TODO: Localize
            end
            if count.bank > 0 then
                if value ~= "" then value = value .. " | " end
                value = value .. "Bank: " .. count.bank -- TODO: Localize
            end

            tooltip:AddDoubleLine(R:Hex(RAID_CLASS_COLORS[count.class or "MAGE"]) .. char .. "|r:", value)
        end
    end
end

function TT:AddItemLevel(tooltip, itemLevel)
    if not R.isRetail and TT.config.showItemLevel then
        local title = _G[tooltip:GetName() .. "TextLeft1"]
        if title and not title:GetText():find("Item Level") then
            title:SetFormattedText([[%s
%s]], title:GetText(), R:Hex(TT.config.colors.itemLevel) .. "Item Level " .. itemLevel .. "|r")
        end
    end
end

function TT:AddVendorPrice(tooltip, sellPrice, classID)
    if TT.config.showVendorPrice and not tooltip.shownMoneyFrames then
        if sellPrice and sellPrice > 0 then
            local container = GetMouseFocus()
            if not container then return end
            local count = container and type(container.count) == "number" and container.count or 1
            if sellPrice and count > 0 then
                if classID and classID == 11 then count = 1 end -- Fix for quiver/ammo pouch so ammo is not included
                SetTooltipMoney(tooltip, sellPrice * count, "STATIC", SELL_PRICE .. ":")
            end
        end
    end
end

function TT:AddMountText(tooltip, unit)
    if not TT.config.showMount then return end

    local index = 1
    local spellID = select(10, UnitAura(unit, index, "HELPFUL"))
    while spellID do
        local mountInfo = R:GetMountInfo(spellID)
        if mountInfo then
            tooltip:AddDoubleLine(string.format("%s", MOUNT), mountInfo.name, TT.config.colors.mount[1], TT.config.colors.mount[2], TT.config.colors.mount[3], 1, 1, 1)
            --tooltip:AddDoubleLine(string.format("%s", MOUNT), string.format("|T%s:20:20:0:0:64:64:5:59:5:59:%d|t %s", mountInfo.icon, 40, mountInfo.name), nil, nil, nil, 1, 1, 1)
            break
        else
            index = index + 1
            spellID = select(10, UnitAura(unit, index, "HELPFUL"))
        end
    end
end

function TT:FormatNameText(tooltip, unit)
    local class = select(2, UnitClass(unit))
    if not class then return end

    _G.GameTooltipTextLeft1:SetFormattedText("%s%s|r%s", R:Hex(RAID_CLASS_COLORS[class] or RAID_CLASS_COLORS["PRIEST"]), (TT.config.showTitle and UnitPVPName(unit) or UnitName(unit)) or UNKNOWN,
                                             UnitIsAFK(unit) and (R:Hex(TT.config.colors.afk) .. " <" .. L["AFK"] .. ">|r") or UnitIsDND(unit) and
                                                 (R:Hex(TT.config.colors.dnd) .. " <" .. L["DND"] .. ">|r") or "")
end

function TT:FormatGuildText(tooltip, unit)
    local guildName, guildRankName, _, guildRealm = GetGuildInfo(unit)
    if not guildName then return end
    local levelLine = TT:GetLevelLine(tooltip, 2, guildName)
    if not levelLine then return end

    local text = R:Hex(TT.config.colors.guild) .. "<" .. (IsShiftKeyDown() and guildRealm and (guildName .. "-" .. guildRealm) or guildName) .. ">" ..
                     (TT.config.showGuildRank and (" [" .. guildRankName .. "]") or "") .. "|r"
    if levelLine == _G.GameTooltipTextLeft2 then
        tooltip:AddLine(text, 1, 1, 1)
    else
        _G.GameTooltipTextLeft2:SetText(text)
    end
end

function TT:FormatLevelText(tooltip, unit)
    local guildName, guildRankName, _, guildRealm = GetGuildInfo(unit)
    local levelLine = TT:GetLevelLine(tooltip, 2, guildName)
    if not levelLine then return end

    local level, realLevel = (R.isRetail and UnitEffectiveLevel or UnitLevel)(unit), UnitLevel(unit)
    local difficultyColor = GetCreatureDifficultyColor(level)

    if UnitIsPlayer(unit) then
        local localeClass, class = UnitClass(unit)
        local classColor = RAID_CLASS_COLORS[class] or RAID_CLASS_COLORS["PRIEST"]

        local race = UnitRace(unit)
        race = (race and race .. " ") or ""

        local sex = UnitSex(unit)
        local gender = (sex == 2 and MALE) or (sex == 3 and FEMALE)
        gender = (gender and gender .. " ") or ""

        if level < realLevel then
            levelLine:SetFormattedText("%s%s|r |cffFFFFFF(%s)|r %s%s%s%s|r", R:Hex(difficultyColor), level > 0 and level or "??", realLevel, gender, race, R:Hex(classColor), localeClass or "")
        else
            levelLine:SetFormattedText("%s%s|r %s%s%s%s|r", R:Hex(difficultyColor), level > 0 and level or "??", gender, race, R:Hex(classColor), localeClass or "")
        end
    else
        levelLine:SetFormattedText("%s%s|r %s", R:Hex(difficultyColor), level > 0 and level or "??", UnitCreatureType(unit) or UNKNOWN)
    end
end

function TT:FormatPvPText(tooltip)
    local line = TT:GetPvPLine(tooltip)
    if not line then return end
    line:SetTextColor(unpack(TT.config.colors.pvp))
end

function TT:AddPvPRank(tooltip, rank)
    if not R.isRetail and rank and TT.config.showPvPRank then
        local size = TT.config.rankSize or 12
        local rank = "Interface\\PvPRankBadges\\PvPRank" .. (rank < 10 and "0" or "") .. rank
        local title = _G[tooltip:GetName() .. "TextLeft1"]
        if title and not title:GetText():find("|T" .. rank) then title:SetFormattedText("|T%s:%d:%d:0:0|t %s", rank, size, size, title:GetText()) end
    end
end

function TT:AddStatusBarColor(tooltip)
    local statusBar = tooltip and _G[tooltip:GetName() .. "StatusBar"]
    if not tooltip or not statusBar then return end

    local unit = select(2, tooltip:GetUnit())
    if not unit then
        local focus = GetMouseFocus()
        if (focus and focus.GetAttribute and focus:GetAttribute("unit")) then unit = focus:GetAttribute("unit") end
    end
    if not unit then return end

    local class = UnitIsPlayer(unit) and select(2, UnitClass(unit)) or nil
    if class then
        local classColor = RAID_CLASS_COLORS[class] or RAID_CLASS_COLORS["PRIEST"]
        statusBar:SetStatusBarColor(classColor.r, classColor.g, classColor.b, 1)
    elseif UnitReaction(unit, "player") then
        local reactionColor = oUF.colors.reaction[UnitReaction(unit, "player")]
        statusBar:SetStatusBarColor(unpack(reactionColor))
    end
end

function TT:GetLevelLine(tooltip, offset, guildName)
    if tooltip:IsForbidden() then return end

    if guildName and R.isRetail then offset = 3 end

    for i = offset, tooltip:NumLines() do
        local line = _G["GameTooltipTextLeft" .. i]
        local text = line and line:GetText() and string.lower(line:GetText())
        if text and (string.find(text, LEVEL1) or string.find(text, LEVEL2)) then return line end
    end
end

function TT:GetPvPLine(tooltip)
    if tooltip:IsForbidden() then return end

    for i = 2, 5 do
        local line = _G["GameTooltipTextLeft" .. i]
        if line and string.find(line:GetText() or "empty", "PvP") then return line end
    end
end

function TT:UpdateFonts()
    _G.GameTooltipHeaderText:SetFont(TT.config.fontFamily, TT.config.headerFontSize, "NONE")
    _G.GameTooltipHeaderText:SetShadowOffset(1, -2)
    _G.GameTooltipHeaderText:SetShadowColor(0, 0, 0, 0.75)

    _G.GameTooltipText:SetFont(TT.config.fontFamily, TT.config.fontSize, "NONE")
    _G.GameTooltipText:SetShadowOffset(1, -2)
    _G.GameTooltipText:SetShadowColor(0, 0, 0, 0.75)

    _G.Tooltip_Small:SetFont(TT.config.fontFamily, TT.config.smallFontSize, "NONE")
    _G.Tooltip_Small:SetShadowOffset(1, -2)
    _G.Tooltip_Small:SetShadowColor(0, 0, 0, 0.75)

    _G.GameTooltipStatusBar.Text:SetFont(TT.config.fontFamily, TT.config.healthFontSize, "OUTLINE")
end

