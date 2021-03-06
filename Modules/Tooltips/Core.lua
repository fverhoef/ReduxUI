local addonName, ns = ...
local R = _G.ReduxUI
local TT = R:AddModule("Tooltips", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local SD = R.Modules.SpellDatabase

TT.classColors = {}
TT.factionColors = {}

function TT:Initialize()
    if not TT.config.enabled then
        return
    end

    -- hex class colors
    for class, color in next, RAID_CLASS_COLORS do
        TT.classColors[class] = R:Hex(color)
    end

    -- hex reaction colors
    -- for idx, color in next, FACTION_BAR_COLORS do
    for i = 1, #FACTION_BAR_COLORS do
        TT.factionColors[i] = R:Hex(FACTION_BAR_COLORS[i])
    end

    -- gametooltip statusbar
    GameTooltipStatusBar:ClearAllPoints()
    GameTooltipStatusBar:SetPoint("LEFT", 5, 0)
    GameTooltipStatusBar:SetPoint("RIGHT", -5, 0)
    GameTooltipStatusBar:SetPoint("TOP", 0, -2.5)
    GameTooltipStatusBar:SetHeight(4)

    -- gametooltip statusbar bg
    GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND", nil, -8)
    GameTooltipStatusBar.bg:SetAllPoints()
    GameTooltipStatusBar.bg:SetColorTexture(1, 1, 1)
    GameTooltipStatusBar.bg:SetVertexColor(0, 0, 0, 0.5)

    GameTooltipStatusBar.text = GameTooltipStatusBar:CreateFontString(nil, "OVERLAY")
    GameTooltipStatusBar.text:SetPoint("CENTER", GameTooltipStatusBar, 0, 0)

    TT:SecureHook(GameTooltipStatusBar, "SetStatusBarColor", TT.SetStatusBarColor)
    TT:SecureHookScript(GameTooltipStatusBar, "OnValueChanged", TT.OnStatusBarValueChanged)
    TT:SecureHook("GameTooltip_SetDefaultAnchor", TT.SetDefaultAnchor)
    TT:SecureHook("GameTooltip_SetBackdropStyle", TT.SetBackdropStyle)
    GameTooltip:HookScript("OnTooltipSetUnit", TT.OnTooltipSetUnit)

    local tooltips = {
        GameTooltip,
        ShoppingTooltip1,
        ShoppingTooltip2,
        ItemRefTooltip,
        ItemRefShoppingTooltip1,
        ItemRefShoppingTooltip2,
        WorldMapTooltip,
        WorldMapCompareTooltip1,
        WorldMapCompareTooltip2,
        SmallTextTooltip
    }
    for _, tooltip in next, tooltips do
        if tooltip:HasScript("OnTooltipCleared") then
            tooltip:HookScript("OnTooltipCleared", TT.SetBackdropStyle)
        end
    end

    TT:SecureHook(GameTooltip, "SetUnitBuff", TT.SetUnitBuff)
    TT:SecureHook(GameTooltip, "SetUnitDebuff", TT.SetUnitDebuff)
    TT:SecureHook(GameTooltip, "SetUnitAura", TT.SetUnitAura)
    TT:SecureHook("SetItemRef", TT.SetItemRef)

    GameTooltip:HookScript("OnTooltipSetItem", TT.OnTooltipSetItem)
    GameTooltip:HookScript("OnTooltipSetSpell", TT.OnTooltipSetSpell)

    ItemRefTooltip:HookScript("OnTooltipSetItem", TT.OnTooltipSetItem)
    ItemRefTooltip:HookScript("OnTooltipSetSpell", TT.OnTooltipSetSpell)

    GameTooltip:HookScript("OnShow", TT.OnShow)

    TT.SetBackdropStyle(GameTooltip)
    TT.SetBackdropStyle(ItemRefTooltip)

    TT:UpdateAll()
end

function TT:UpdateAll()
    TT:UpdateFonts()

    local tooltips = {
        GameTooltip,
        ShoppingTooltip1,
        ShoppingTooltip2,
        ItemRefTooltip,
        ItemRefShoppingTooltip1,
        ItemRefShoppingTooltip2,
        WorldMapTooltip,
        WorldMapCompareTooltip1,
        WorldMapCompareTooltip2,
        SmallTextTooltip
    }
    for _, tooltip in next, tooltips do
        TT:Update(tooltip)
    end

    local menus = {DropDownList1MenuBackdrop, DropDownList2MenuBackdrop}
    for _, menu in next, menus do
        menu:SetScale(TT.config.scale)
    end
end

function TT:Update(tooltip)
    tooltip:SetScale(TT.config.scale)

    if tooltip.Border then
        if TT.config.border.enabled then
            tooltip.Border:Show()
            tooltip.Border:SetSize(TT.config.border.size)
            tooltip.Border:SetTexture(TT.config.border.texture)

            local color = TT.config.border.color
            if TT.config.colorBorderByRarity then        
                local _, link = tooltip:GetItem()
                if link then
                    local _, _, itemRarity = GetItemInfo(link)        
                    if itemRarity and itemRarity > 1 then
                        color = {GetItemQualityColor(itemRarity)}
                    end
                end
            end
            tooltip.Border:SetVertexColor(unpack(color))
        else
            tooltip.Border:Hide()
        end
    end

    if tooltip.Shadow then
        if TT.config.shadow.enabled then
            tooltip.Shadow:Show()
            tooltip.Shadow:SetBackdropBorderColor(unpack(TT.config.shadow.color))
        else
            tooltip.Shadow:Hide()
        end
    end

    if tooltip.Gloss then
        if TT.config.gloss.enabled then
            tooltip.Gloss:Show()
            tooltip.Gloss:SetTexture(TT.config.gloss.texture)
            tooltip.Gloss:SetVertexColor(unpack(TT.config.gloss.color))
        else
            tooltip.Gloss:Hide()
        end
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
        TT:AddSpellID(ItemRefTooltip, value:match("([^:]+)"))
    end
end

function TT:OnTooltipSetUnit()
    local unitName, unit = self:GetUnit()
    if not unit then
        return
    end

    -- color tooltips
    GameTooltipTextLeft2:SetTextColor(unpack(TT.config.colors.text))
    GameTooltipTextLeft3:SetTextColor(unpack(TT.config.colors.text))
    GameTooltipTextLeft4:SetTextColor(unpack(TT.config.colors.text))
    GameTooltipTextLeft5:SetTextColor(unpack(TT.config.colors.text))
    GameTooltipTextLeft6:SetTextColor(unpack(TT.config.colors.text))
    GameTooltipTextLeft7:SetTextColor(unpack(TT.config.colors.text))
    GameTooltipTextLeft8:SetTextColor(unpack(TT.config.colors.text))

    -- position raid icon
    local raidIconIndex = GetRaidTargetIndex(unit)
    if raidIconIndex then
        GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[raidIconIndex] .. "14|t", unitName))
    end

    if not UnitIsPlayer(unit) then
        -- unit is not a player
        -- color textleft1 and statusbar by faction color
        local reaction = UnitReaction(unit, "player")
        if reaction then
            local color = FACTION_BAR_COLORS[reaction]
            if color then
                GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
                GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)
            end
        end

        -- color textleft2 by classificationcolor
        local unitClassification = UnitClassification(unit)
        local levelLine
        if string.find(GameTooltipTextLeft2:GetText() or "empty", "%a%s%d") then
            levelLine = GameTooltipTextLeft2
        elseif string.find(GameTooltipTextLeft3:GetText() or "empty", "%a%s%d") then
            GameTooltipTextLeft2:SetTextColor(unpack(TT.config.colors.guild))
            levelLine = GameTooltipTextLeft3
        end
        if levelLine then
            local l = UnitLevel(unit)
            local color = GetCreatureDifficultyColor((l > 0) and l or 999)
            levelLine:SetTextColor(color.r, color.g, color.b)
        end
        if unitClassification == "worldboss" or UnitLevel(unit) == -1 then
            GameTooltipTextLeft2:SetTextColor(unpack(TT.config.colors.boss))
        end
    else
        -- unit is any player
        local _, unitClass = UnitClass(unit)

        -- color textleft1 and statusbar by class color
        local color = RAID_CLASS_COLORS[unitClass]
        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
        GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)

        -- color textleft2 by guildcolor
        local unitGuild, guildRankName = GetGuildInfo(unit)
        local l = UnitLevel(unit)
        local color = GetCreatureDifficultyColor((l > 0) and l or 999)
        if unitGuild then
            -- move level line to a new one
            GameTooltip:AddLine(GameTooltipTextLeft2:GetText(), color.r, color.g, color.b)
            -- add guild info
            GameTooltipTextLeft2:SetText("<" .. unitGuild .. "> [" .. guildRankName .. "]")
            GameTooltipTextLeft2:SetTextColor(unpack(TT.config.colors.guild))
        else
            GameTooltipTextLeft2:SetTextColor(color.r, color.g, color.b)
        end

        -- afk?
        if UnitIsAFK(unit) then
            self:AppendText((" %s<AFK>|r"):format(R:Hex(TT.config.colors.afk)))
        end
    end

    -- pvp
    if string.find(GameTooltipTextLeft2:GetText() or "empty", "PvP") then
        GameTooltipTextLeft2:SetTextColor(unpack(TT.config.colors.pvp))
    elseif string.find(GameTooltipTextLeft3:GetText() or "empty", "PvP") then
        GameTooltipTextLeft3:SetTextColor(unpack(TT.config.colors.pvp))
    elseif string.find(GameTooltipTextLeft4:GetText() or "empty", "PvP") then
        GameTooltipTextLeft4:SetTextColor(unpack(TT.config.colors.pvp))
    elseif string.find(GameTooltipTextLeft5:GetText() or "empty", "PvP") then
        GameTooltipTextLeft5:SetTextColor(unpack(TT.config.colors.pvp))
    end

    -- dead?
    if UnitIsDeadOrGhost(unit) then
        GameTooltipTextLeft1:SetTextColor(unpack(TT.config.colors.dead))
    end

    -- target line
    if (UnitExists(unit .. "target")) then
        GameTooltip:AddDoubleLine(("%s%s|r"):format(R:Hex(TT.config.colors.target), "Target"),
                                  TT:GetTarget(unit .. "target") or "Unknown")
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
        TT:ModifySpellDamage(self, spellId)
        TT:ShowNextRank(self, spellId)

        self:Show()
    end
end

function TT:OnShow()
    TT:Update(self)
end

function TT:SetBackdropStyle()
    if self.TopOverlay then
        self.TopOverlay:Hide()
    end
    if self.BottomOverlay then
        self.BottomOverlay:Hide()
    end

    self:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        tileEdge = false,
        tileSize = 16,
        edgeSize = 24,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    })
    self:SetBackdropColor(0.08, 0.08, 0.1, 0.92)

    self:CreateBorder(TT.config.border.size, TT.config.border.texture, TT.config.border.color)
    self:CreateShadow()
    self:CreateGlossOverlay(nil, TT.config.gloss.texture)

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
        if parent == MultiBarBottomRight or parent == MultiBarRight or parent == MultiBarLeft or
            (AB and
                (parent == AB.Bars.MultiBarBottomRight or parent == AB.Bars.MultiBarRight or parent == AB.Bars.MultiBarLeft or
                    parent == AB.Bars.MicroButtonAndBagsBar)) then
            anchor = "ANCHOR_LEFT"
        elseif parent == MainMenuBar or parent == MultiBarBottomLeft or parent == StanceBarFrame or PetActionBarFrame or (AB and
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

function TT:InsertLine(tooltip, position, line)
    local name = tooltip:GetName()
    local lines = {}
    local numLines = tooltip:NumLines()
    for i = 1, numLines do
        local tooltipLeft = _G[name .. "TextLeft" .. i]
        local tooltipRight = _G[name .. "TextRight" .. i]
        local lR, lG, lB = tooltipLeft:GetTextColor()
        local rR, rG, rB = tooltipRight:GetTextColor()

        local index = #lines + 1

        if index == position then
            lines[index] = line
            index = index + 1
        end
        lines[index] = {
            left = {text = tooltipLeft:GetText(), color = {lR, lG, lB}},
            right = {text = tooltipRight:GetText(), color = {rR, rG, rB}}
        }
    end

    if line.right then
        tooltip:AddDoubleLine(line.left.text, line.right.text, unpack(line.left.color or {1, 1, 1}),
                              unpack(line.right.color or {1, 1, 1}))
    else
        tooltip:AddLine(line.left.text, unpack(line.left.color))
    end

    for i, currentLine in next, lines do
        if currentLine.left then
            local tooltipLeft = _G[name .. "TextLeft" .. i]
            tooltipLeft:SetText(currentLine.left.text or "")
            if currentLine.left.color then
                tooltipLeft:SetTextColor(unpack(currentLine.left.color or {1, 1, 1}))
            end
            tooltipLeft:Show()
        end
        if currentLine.right then
            local tooltipRight = _G[name .. "TextRight" .. i]
            tooltipRight:SetText(currentLine.right.text or "")
            if currentLine.right.color then
                tooltipRight:SetTextColor(unpack(currentLine.right.color or {1, 1, 1}))
            end
            tooltipRight:Show()
        end
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
    if itemId and TT.config.showItemCount and R.config.db.realm.inventory then
        for i, char in next, R.config.db.realm.inventory do
            local bagCount = char.bags and char.bags[itemId] or 0
            local bankCount = char.bank and char.bank[itemId] or 0
            local equippedCount = char.equipped and char.equipped[itemId] or 0
            if bagCount > 0 or bankCount > 0 or equippedCount > 0 then
                local value = ""
                if equippedCount > 0 then
                    value = "Equipped: " .. equippedCount -- TODO: Localize
                end
                if bagCount > 0 then
                    if value ~= "" then
                        value = value .. " | "
                    end
                    value = value .. "Bags: " .. bagCount -- TODO: Localize
                end
                if bankCount > 0 then
                    if value ~= "" then
                        value = value .. " | "
                    end
                    value = value .. "Bank: " .. bankCount -- TODO: Localize
                end

                tooltip:AddDoubleLine(R:Hex(RAID_CLASS_COLORS[char.class or "MAGE"]) .. i .. "|r:", value)
            end
        end
    end
end

function TT:AddItemLevel(tooltip, itemLevel)
    if TT.config.showItemLevel then
        TT:InsertLine(tooltip, 2, {left = {text = "Item Level " .. itemLevel, color = TT.config.colors.itemLevel}, right = {}})
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

function TT:ModifySpellDamage(tooltip, spellId)
    if spellId and TT.config.modifySpellDamage then
        local rank = SD:GetSpellById(spellId)
        if rank and rank.spell.hasSpellCoefficient then
            local name = tooltip:GetName()
            local tooltipText = _G[name .. "TextLeft4"]
            local description = tooltipText:GetText()
            if description then
                -- TODO: localize this or find another way of doing it
                if string.find(description, "Cooldown remaining:") then
                    tooltipText = _G[name .. "TextLeft5"]
                    description = tooltipText:GetText()
                end

                SD:ParseDescription(rank, description)
                SD:UpdateDescription(rank)
                tooltipText:SetText(rank.description)
            end
        end
    end
end

function TT:ShowNextRank(tooltip, spellId)
    if spellId and TT.config.showNextRank then
        local isMaxKnownRank = SD:IsMaxKnownRank(spellId)
        local isMaxRank = SD:IsMaxRank(spellId)
        if isMaxKnownRank and not isMaxRank then
            local nextRank = SD:GetNextRank(spellId)
            if nextRank then
                tooltip:AddLine("|cffa0bed2Next rank available at level " .. nextRank.level .. ".|r") -- TODO: Localize
            end
        end
    end
end

function TT:UpdateFonts()
    GameTooltipHeaderText:SetFont(TT.config.fontFamily, TT.config.headerFontSize, "NONE")
    GameTooltipHeaderText:SetShadowOffset(1, -2)
    GameTooltipHeaderText:SetShadowColor(0, 0, 0, 0.75)

    GameTooltipText:SetFont(TT.config.fontFamily, TT.config.fontSize, "NONE")
    GameTooltipText:SetShadowOffset(1, -2)
    GameTooltipText:SetShadowColor(0, 0, 0, 0.75)

    Tooltip_Small:SetFont(TT.config.fontFamily, TT.config.smallFontSize, "NONE")
    Tooltip_Small:SetShadowOffset(1, -2)
    Tooltip_Small:SetShadowColor(0, 0, 0, 0.75)

    GameTooltipStatusBar.text:SetFont(TT.config.fontFamily, TT.config.healthFontSize, "OUTLINE")
end

