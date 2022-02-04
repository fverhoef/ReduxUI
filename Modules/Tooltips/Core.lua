local addonName, ns = ...
local R = _G.ReduxUI
local TT = R:AddModule("Tooltips", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local ID = R.Modules.InventoryDatabase

TT.classColors = {}
TT.factionColors = {}

function TT:Initialize()
    if not TT.config.enabled then
        return
    end

    for class, color in next, _G.RAID_CLASS_COLORS do
        TT.classColors[class] = R:Hex(color)
    end
    for i = 1, #_G.FACTION_BAR_COLORS do
        TT.factionColors[i] = R:Hex(_G.FACTION_BAR_COLORS[i])
    end

    _G.GameTooltipStatusBar:ClearAllPoints()
    _G.GameTooltipStatusBar:SetPoint("LEFT", 5, 0)
    _G.GameTooltipStatusBar:SetPoint("RIGHT", -5, 0)
    _G.GameTooltipStatusBar:SetPoint("TOP", 0, -2.5)
    _G.GameTooltipStatusBar:SetHeight(4)

    _G.GameTooltipStatusBar.bg = _G.GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND", nil, -8)
    _G.GameTooltipStatusBar.bg:SetAllPoints()
    _G.GameTooltipStatusBar.bg:SetColorTexture(1, 1, 1)
    _G.GameTooltipStatusBar.bg:SetVertexColor(0, 0, 0, 0.5)

    _G.GameTooltipStatusBar.text = _G.GameTooltipStatusBar:CreateFontString(nil, "OVERLAY")
    _G.GameTooltipStatusBar.text:SetPoint("CENTER", _G.GameTooltipStatusBar, 0, 0)

    TT:SecureHook(_G.GameTooltipStatusBar, "SetStatusBarColor", TT.SetStatusBarColor)
    TT:SecureHookScript(_G.GameTooltipStatusBar, "OnValueChanged", TT.OnStatusBarValueChanged)
    TT:SecureHook("GameTooltip_SetDefaultAnchor", TT.SetDefaultAnchor)
    _G.GameTooltip:HookScript("OnTooltipSetUnit", TT.OnTooltipSetUnit)

    TT:SecureHook(_G.GameTooltip, "SetUnitBuff", TT.SetUnitBuff)
    TT:SecureHook(_G.GameTooltip, "SetUnitDebuff", TT.SetUnitDebuff)
    TT:SecureHook(_G.GameTooltip, "SetUnitAura", TT.SetUnitAura)
    TT:SecureHook("SetItemRef", TT.SetItemRef)

    _G.GameTooltip:HookScript("OnTooltipSetItem", TT.OnTooltipSetItem)
    _G.GameTooltip:HookScript("OnTooltipSetSpell", TT.OnTooltipSetSpell)

    _G.ItemRefTooltip:HookScript("OnTooltipSetItem", TT.OnTooltipSetItem)
    _G.ItemRefTooltip:HookScript("OnTooltipSetSpell", TT.OnTooltipSetSpell)

    _G.GameTooltip:HookScript("OnShow", TT.OnShow)

    TT:UpdateAll()
end

function TT:UpdateAll()
    TT:UpdateFonts()

    local tooltips = {
        _G.GameTooltip,
        _G.ShoppingTooltip1,
        _G.ShoppingTooltip2,
        _G.ItemRefTooltip,
        _G.ItemRefShoppingTooltip1,
        _G.ItemRefShoppingTooltip2,
        _G.WorldMapTooltip,
        _G.WorldMapCompareTooltip1,
        _G.WorldMapCompareTooltip2,
        _G.SmallTextTooltip
    }
    for _, tooltip in next, tooltips do
        TT:Update(tooltip)
    end

    local menus = {_G.DropDownList1MenuBackdrop, _G.DropDownList2MenuBackdrop}
    for _, menu in next, menus do
        menu:SetScale(TT.config.scale)
    end
end

function TT:Update(tooltip)
    tooltip:SetScale(TT.config.scale)

    if TT.config.colorBorderByRarity and tooltip.NineSlice then
        tooltip.defaultBorderColor = tooltip.defaultBorderColor or {tooltip.NineSlice:GetBorderColor()}
        local color = tooltip.defaultBorderColor
        local _, link = tooltip:GetItem()
        if link then
            local _, _, itemRarity = GetItemInfo(link)
            if itemRarity and itemRarity > 1 then
                color = {GetItemQualityColor(itemRarity)}
            end
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

function TT:SetUnitBuff(...)
    TT:AddSpellID(self, select(10, UnitBuff(...)))
end

function TT:SetUnitDebuff(...)
    TT:AddSpellID(self, select(10, UnitDebuff(...)))
end

function TT:SetUnitAura(...)
    TT:AddSpellID(self, select(10, UnitAura(...)))
end

function TT:SetItemRef(...)
    local link = self
    local type, value = link:match("(%a+):(.+)")
    if type == "spell" then
        TT:AddSpellID(_G.ItemRefTooltip, value:match("([^:]+)"))
    end
end

function TT:OnTooltipSetUnit()
    local unitName, unit = self:GetUnit()
    if not unit then
        return
    end

    local raidIconIndex = GetRaidTargetIndex(unit)
    if raidIconIndex then
        _G.GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[raidIconIndex] .. "14|t", unitName))
    end

    if UnitIsPlayer(unit) then
        if UnitIsAFK(unit) then
            self:AppendText((" %s<AFK>|r"):format(R:Hex(TT.config.colors.afk)))
        end

        local rank = UnitPVPRank and UnitPVPRank(unit)
        if rank and rank > 0 then
            -- rank starts at 5 for some reason
            rank = rank - 4
            TT:AddPvPRank(self, rank)
        end
    end

    for i = 2, 5 do
        local text = _G["GameTooltipTextLeft" .. i]
        if text and string.find(text:GetText() or "empty", "PvP") then
            text:SetTextColor(unpack(TT.config.colors.pvp))
        end
    end

    if UnitIsDeadOrGhost(unit) then
        _G.GameTooltipTextLeft1:SetTextColor(unpack(TT.config.colors.dead))
    end

    if (UnitExists(unit .. "target")) then
        _G.GameTooltip:AddDoubleLine(("%s%s|r"):format(R:Hex(TT.config.colors.target), "Target"), TT:GetTarget(unit .. "target") or "Unknown")
    end
end

function TT:OnTooltipSetItem()
    local itemName, link = self:GetItem()
    if link then
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc,
              itemIcon, sellPrice, classID = GetItemInfo(link)
        TT:AddIcon(self, itemIcon)
        if itemEquipLoc and itemEquipLoc ~= "" then
            TT:AddItemLevel(self, itemLevel)
        end
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

function TT:OnShow()
    TT:Update(self)
end

function TT:SetStatusBarColor(r, g, b)
    if not barColor then
        return
    end
    if r == barColor.r and g == barColor.g and b == barColor.b then
        return
    end
    self:SetStatusBarColor(barColor.r, barColor.g, barColor.b)
end

function TT:OnStatusBarValueChanged(value)
    if TT.config.showHealthValues then
        local tooltip = self:GetParent()
        local unit = select(2, tooltip:GetUnit())
        if (not unit) then
            local focus = GetMouseFocus()
            if (focus and focus.GetAttribute and focus:GetAttribute("unit")) then
                unit = focus:GetAttribute("unit")
            end
        end

        local _, max = self:GetMinMaxValues()
        if (value > 0 and max == 1) then
            self.text:SetFormattedText("%d%%", floor(value * 100))
            self:SetStatusBarColor(0.6, 0.6, 0.6)
        elseif (value == 0 or (unit and UnitIsDeadOrGhost(unit))) then
            self.text:SetText(_G.DEAD)
        else
            self.text:SetText(R:FormatValue(value) .. " / " .. R:FormatValue(max))
        end
    end
end

function TT:SetDefaultAnchor(owner)
    if not TT.config.anchor then
        return
    end
    local anchor = TT.config.anchor
    local offsetX = TT.config.offsetX
    local offsetY = TT.config.offsetY

    -- override anchor for action bar buttons
    local parent = owner:GetParent()
    if parent then
        if parent == _G.MultiBarBottomRight or parent == _G.MultiBarRight or parent == _G.MultiBarLeft or
            (AB and
                (parent == AB.Bars.MultiBarBottomRight or parent == AB.Bars.MultiBarRight or parent == AB.Bars.MultiBarLeft or
                    parent == AB.Bars.MicroButtonAndBagsBar)) then
            anchor = "ANCHOR_LEFT"
        elseif parent == _G.MainMenuBar or parent == _G.MultiBarBottomLeft or parent == _G.StanceBarFrame or _G.PetActionBarFrame or (AB and
            (parent == AB.Bars.MainMenuBar or parent == AB.Bars.MultiBarBottomLeft or parent == AB.Bars.StanceBar or
                AB.Bars.PetActionBar or AB.Bars.VehicleExitBar)) then
            anchor = "ANCHOR_RIGHT"
        end
    end

    if anchor == "ANCHOR_CURSOR" then
        self:SetOwner(owner, anchor, offsetX, offsetY)
    else
        self:SetOwner(owner, anchor)
    end
end

function TT:AddIcon(tooltip, icon)
    if icon and TT.config.showIcons then
        local title = _G[tooltip:GetName() .. "TextLeft1"]
        if title and not title:GetText():find("|T" .. icon) then
            title:SetFormattedText("|T%s:20:20:0:0:64:64:5:59:5:59:%d|t %s", icon, 40, title:GetText())
        end
    end
end

function TT:AddSpellID(tooltip, spellId)
    if spellId and TT.config.showSpellId then
        tooltip:AddDoubleLine("|cff0099ffSpell ID|r", spellId)
    end
end

function TT:AddItemID(tooltip, itemId)
    if itemId and TT.config.showItemId then
        tooltip:AddDoubleLine("|cff0099ffItem ID|r", itemId)
    end
end

function TT:AddItemCount(tooltip, itemId)
    if itemId and TT.config.showItemCount then
        local charCounts = ID:GetItemCount(itemId)
        for char, count in pairs(charCounts) do
            local value = ""
            if count.equipped > 0 then
                value = "Equipped: " .. count.equipped -- TODO: Localize
            end
            if count.bag > 0 then
                if value ~= "" then
                    value = value .. " | "
                end
                value = value .. "Bags: " .. count.bag -- TODO: Localize
            end
            if count.bank > 0 then
                if value ~= "" then
                    value = value .. " | "
                end
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
%s]], title:GetText(), Addon:Hex(E.db[addonName].layout.tooltips.colors.itemLevel) .. L["Item Level "] .. itemLevel .. "|r")
        end
    end
end

function TT:AddVendorPrice(tooltip, sellPrice, classID)
    if TT.config.showVendorPrice and not tooltip.shownMoneyFrames then
        if sellPrice and sellPrice > 0 then
            local container = GetMouseFocus()
            if not container then
                return
            end
            local count = container and type(container.count) == "number" and container.count or 1
            if sellPrice and count > 0 then
                if classID and classID == 11 then
                    count = 1
                end -- Fix for quiver/ammo pouch so ammo is not included
                SetTooltipMoney(tooltip, sellPrice * count, "STATIC", SELL_PRICE .. ":")
            end
        end
    end
end

function TT:AddPvPRank(tooltip, rank)
    if not R.isRetail and rank and TT.config.showPvPRank then
        local size = TT.config.rankSize or 12
        local rank = "Interface\\PvPRankBadges\\PvPRank" .. (rank < 10 and "0" or "") .. rank
        local title = _G[tooltip:GetName() .. "TextLeft1"]
        if title and not title:GetText():find("|T" .. rank) then
            title:SetFormattedText("|T%s:%d:%d:0:0|t %s", rank, size, size, title:GetText())
        end
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

    _G.GameTooltipStatusBar.text:SetFont(TT.config.fontFamily, TT.config.healthFontSize, "OUTLINE")
end

