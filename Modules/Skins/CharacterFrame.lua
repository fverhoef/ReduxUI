local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins
local L = R.L

local CATEGORY_HEADER_HEIGHT = 23
local CATEGORY_SPACING = 5
local ITEM_LEVEL_HEIGHT = 27
local STAT_HEIGHT = 18
local ENHANCEMENT_CATEGORIES = {"PLAYERSTAT_MELEE_COMBAT", "PLAYERSTAT_RANGED_COMBAT", "PLAYERSTAT_SPELL_COMBAT", "PLAYERSTAT_DEFENSES"}
local PAPERDOLL_SIDEBARS = {
    {
        name = PAPERDOLL_SIDEBAR_STATS,
        frame = "CharacterStatsPane",
        icon = nil, -- Uses the character portrait
        texCoords = {0.109375, 0.890625, 0.09375, 0.90625},
        disabledTooltip = nil,
        IsActive = function() return true end
    }, {
        name = PAPERDOLL_SIDEBAR_TITLES,
        frame = "PaperDollTitlesPane",
        icon = "Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs",
        texCoords = {0.01562500, 0.53125000, 0.32421875, 0.46093750},
        disabledTooltip = NO_TITLES_TOOLTIP,
        IsActive = function()
            -- You always have the "No Title" title so you need to have more than one to have an option.
            return #GetKnownTitles() > 1
        end
    }, {
        name = PAPERDOLL_EQUIPMENTMANAGER,
        frame = "PaperDollEquipmentManagerPane",
        icon = "Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs",
        texCoords = {0.01562500, 0.53125000, 0.46875000, 0.60546875},
        disabledTooltip = function()
            local _, failureReason = C_LFGInfo.CanPlayerUseLFD()
            return failureReason
        end,
        IsActive = function() return C_EquipmentSet.GetNumEquipmentSets() > 0 or C_LFGInfo.CanPlayerUseLFD() end
    }
}

function S:StyleCharacterFrame()
    if R.isRetail or not S.config.character.enabled then return end

    CharacterModelFrame:SetSize(231, 320)
    CharacterModelFrame:SetFrameLevel(10)

    CharacterResistanceFrame:SetFrameLevel(11)
    PaperDollItemsFrame:SetFrameLevel(11)
    PlayerTitleDropDown:SetFrameLevel(11)

    CharacterAttributesFrame:Hide()

    -- add model background
    local race, raceFileName = UnitRace("player");
    local texturePath = S:DressUpTexturePath(raceFileName)

    CharacterModelFrame.Background = CreateFrame("Frame", addonName .. "CharacterModelFrameBackground", CharacterModelFrame)
    CharacterModelFrame.Background:SetSize(231, 320)
    CharacterModelFrame.Background:SetAllPoints()
    CharacterModelFrame.Background:SetFrameLevel(5)
    CharacterModelFrame.Background:SetScale(0.90)

    CharacterModelFrame.Background.TopLeft = CharacterModelFrame.Background:CreateTexture("$parentBackgroundTopLeft", "BACKGROUND")
    CharacterModelFrame.Background.TopLeft:SetTexture(texturePath .. 1)
    CharacterModelFrame.Background.TopLeft:SetSize(256, 255)
    CharacterModelFrame.Background.TopLeft:SetPoint("TOPLEFT", 0, 0)
    CharacterModelFrame.Background.TopLeft:SetDesaturated(1)

    CharacterModelFrame.Background.TopRight = CharacterModelFrame.Background:CreateTexture("$parentBackgroundTopRight", "BACKGROUND")
    CharacterModelFrame.Background.TopRight:SetTexture(texturePath .. 2)
    CharacterModelFrame.Background.TopRight:SetSize(62, 255)
    CharacterModelFrame.Background.TopRight:SetPoint("TOPLEFT", CharacterModelFrame.Background.TopLeft, "TOPRIGHT")
    CharacterModelFrame.Background.TopRight:SetDesaturated(1)
    CharacterModelFrame.Background.TopRight:Hide()

    CharacterModelFrame.Background.BottomLeft = CharacterModelFrame.Background:CreateTexture("$parentBackgroundBot", "BACKGROUND")
    CharacterModelFrame.Background.BottomLeft:SetTexture(texturePath .. 3)
    CharacterModelFrame.Background.BottomLeft:SetSize(256, 128)
    CharacterModelFrame.Background.BottomLeft:SetPoint("TOPLEFT", CharacterModelFrame.Background.TopLeft, "BOTTOMLEFT")
    CharacterModelFrame.Background.BottomLeft:SetDesaturated(1)

    CharacterModelFrame.Background.BottomRight = CharacterModelFrame.Background:CreateTexture("$parentBackgroundBot", "BACKGROUND")
    CharacterModelFrame.Background.BottomRight:SetTexture(texturePath .. 4)
    CharacterModelFrame.Background.BottomRight:SetSize(62, 128)
    CharacterModelFrame.Background.BottomRight:SetPoint("TOPLEFT", CharacterModelFrame.Background.TopLeft, "BOTTOMRIGHT")
    CharacterModelFrame.Background.BottomRight:SetDesaturated(1)
    CharacterModelFrame.Background.BottomRight:Hide()

    CharacterFrame.originalWidth = CharacterFrame:GetWidth()
    PaperDollFrame.CharacterStatsPane = S:CreateCharacterStatsPane()

    S:SecureHook("CharacterFrame_ShowSubFrame", function()
        if PaperDollFrame:IsShown() then
            CharacterFrame:SetWidth(CharacterFrame.originalWidth + PaperDollFrame.CharacterStatsPane:GetWidth() - 71)
            UIPanelWindows["CharacterFrame"].width = CharacterFrame:GetWidth() - 30
        else
            CharacterFrame:SetWidth(CharacterFrame.originalWidth)
            UIPanelWindows["CharacterFrame"].width = CharacterFrame:GetWidth()
        end
    end)

    S:SecureHook("ToggleCharacter", function()
        if PaperDollFrame:IsShown() then
            CharacterFrameCloseButton:SetPoint("CENTER", CharacterFrame, "TOPRIGHT", -46, -25)
            CharacterLevelText:Show()
            if CharacterGuildText then CharacterGuildText:Show() end
        else
            CharacterFrameCloseButton:SetPoint("CENTER", CharacterFrame, "TOPRIGHT", -44, -25)
            CharacterLevelText:Hide()
            if CharacterGuildText then CharacterGuildText:Hide() end
        end
        if HonorFrame then
            if HonorFrame:IsShown() then
                HonorLevelText:Show()
                HonorGuildText:Show()
            else
                HonorLevelText:Hide()
                HonorGuildText:Hide()
            end
        end
    end)

    CharacterLevelText:SetParent(CharacterNameFrame)
    CharacterLevelText:ClearAllPoints()
    CharacterLevelText:SetPoint("TOP", CharacterNameFrame, "BOTTOM", 0, -10)

    if CharacterGuildText then
        CharacterGuildText:SetParent(CharacterNameFrame)

        S:SecureHook("PaperDollFrame_SetLevel", function()
            local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[R.PlayerInfo.class] or RAID_CLASS_COLORS[R.PlayerInfo.class]
            CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), R:Hex(1, 1, 1) .. UnitRace("player") .. "|r", R:Hex(classColor) .. R.PlayerInfo.localizedClass .. "|r")
        end)
        S:SecureHook("PaperDollFrame_SetGuild", function()
            local guildName, title, rank = GetGuildInfo("player")
            if guildName then CharacterGuildText:SetFormattedText(GUILD_TITLE_TEMPLATE, title, R:Hex(0, 230 / 255, 0) .. guildName .. "|r") end
        end)
    end

    S:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", S.UpdateCharacterStatsPane)
    CharacterFrame:HookScript("OnShow", S.UpdateCharacterStatsPane)
end

function S:DressUpTexturePath(raceFileName)
    if not raceFileName then raceFileName = "Orc"; end

    return "Interface\\DressUpFrame\\DressUpBackground-" .. raceFileName;
end

function S:CreateCharacterStatsPane()
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPane", PaperDollFrame)
    frame:SetSize(150 + 128, 512)
    frame:SetPoint("TOPRIGHT", _G.PaperDollFrame, "TOPRIGHT", 0, -1)

    frame.ItemLevel = S:CreateCharacterStatsPane_ItemLevel(frame)
    frame.Attributes = S:CreateCharacterStatsPane_Attributes(frame)
    frame.Enhancements = S:CreateCharacterStatsPane_Enhancements(frame)

    frame.Background = CreateFrame("Frame", addonName .. "CharacterStatsPaneBackground", frame)
    frame.Background:SetAllPoints()

    frame.Background.Top = frame.Background:CreateTexture(nil, "BACKGROUND", nil, 0)
    frame.Background.Top:SetSize(150, 72)
    frame.Background.Top:SetPoint("TOPLEFT", frame.Background, "TOPLEFT", 0, 0)
    frame.Background.Top:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-General-TopLeft]])
    frame.Background.Top:SetTexCoord((256 - 150) / 256, 256 / 256, 0 / 256, 72 / 256)

    frame.Background.CenterTop = frame.Background:CreateTexture(nil, "BACKGROUND", nil, 0)
    frame.Background.CenterTop:SetSize(115, 256 - 72)
    frame.Background.CenterTop:SetPoint("TOPRIGHT", frame.Background.Top, "BOTTOMRIGHT", 0, 0)
    frame.Background.CenterTop:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-General-TopLeft]])
    frame.Background.CenterTop:SetTexCoord((256 - 115) / 256, 256 / 256, 72 / 256, 256 / 256)

    frame.Background.TopRight = frame.Background:CreateTexture(nil, "BACKGROUND", nil, 0)
    frame.Background.TopRight:SetSize(128, 256)
    frame.Background.TopRight:SetPoint("TOPLEFT", frame.Background.Top, "TOPRIGHT", 0, 0)
    frame.Background.TopRight:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-General-TopRight]])

    frame.Background.Bottom = frame.Background:CreateTexture(nil, "BACKGROUND", nil, 0)
    frame.Background.Bottom:SetSize(150, 108)
    frame.Background.Bottom:SetPoint("BOTTOMLEFT", frame.Background, "BOTTOMLEFT", 0, 0)
    frame.Background.Bottom:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-General-BottomLeft]])
    frame.Background.Bottom:SetTexCoord((256 - 150) / 256, 256 / 256, (256 - 108) / 256, 256 / 256)

    frame.Background.CenterBottom = frame.Background:CreateTexture(nil, "BACKGROUND", nil, 0)
    frame.Background.CenterBottom:SetSize(115, 256 - 108)
    frame.Background.CenterBottom:SetPoint("BOTTOMRIGHT", frame.Background.Bottom, "TOPRIGHT", 0, 0)
    frame.Background.CenterBottom:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-General-BottomLeft]])
    frame.Background.CenterBottom:SetTexCoord((256 - 115) / 256, 256 / 256, 0 / 256, (256 - 108) / 256)

    frame.Background.BottomRight = frame.Background:CreateTexture(nil, "BACKGROUND", nil, 0)
    frame.Background.BottomRight:SetSize(128, 256)
    frame.Background.BottomRight:SetPoint("BOTTOMLEFT", frame.Background.Bottom, "BOTTOMRIGHT", 0, 0)
    frame.Background.BottomRight:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-General-BottomRight]])

    frame.Background.Inset = frame.Background:CreateTexture(nil, "BACKGROUND", nil, 1)
    frame.Background.Inset:SetSize(199, 357)
    frame.Background.Inset:SetPoint("TOPLEFT", frame.Background, "TOPLEFT", 35, -74)

    return frame
end

function S:CreateCharacterStatsPane_ItemLevel(parent)
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPaneItemLevel", parent)
    frame:SetSize(198, CATEGORY_HEADER_HEIGHT + ITEM_LEVEL_HEIGHT)
    frame:SetPoint("TOP", parent, "TOP", 0, -74)

    frame.Header = CreateFrame("Frame", addonName .. "CharacterStatsPaneItemLevelLabel", parent)
    frame.Header:SetSize(198, CATEGORY_HEADER_HEIGHT)
    frame.Header:SetPoint("TOP", frame, "TOP", 0, 0)
    frame.Header.Text = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Header.Text:SetAllPoints()
    frame.Header.Text:SetJustifyH("CENTER")
    frame.Header.Text:SetJustifyV("CENTER")
    frame.Header.Text:SetShadowOffset(1, -1)
    frame.Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
    frame.Header.Text:SetText(STAT_AVERAGE_ITEM_LEVEL)

    frame.Value = CreateFrame("Frame", addonName .. "CharacterStatsPaneItemLevelLabel", parent)
    frame.Value:SetSize(145, ITEM_LEVEL_HEIGHT)
    frame.Value:SetPoint("TOP", frame.Header, "BOTTOM", 0, 0)
    frame.Value.Text = frame.Value:CreateFontString(nil, "OVERLAY")
    frame.Value.Text:SetAllPoints()
    frame.Value.Text:SetJustifyH("CENTER")
    frame.Value.Text:SetJustifyV("CENTER")
    frame.Value.Text:SetShadowOffset(1, -1)
    frame.Value.Text:SetFont(STANDARD_TEXT_FONT, 15)
    frame.Value.Background = frame.Value:CreateTexture("BACKGROUND")
    frame.Value.Background:SetAllPoints()
    frame.Value.Background:SetTexture([[Interface\PaperDollInfoFrame\PaperDollInfoPart1]])
    frame.Value.Background:SetTexCoord(10 / 1024, 155 / 1024, 758 / 1024, 784 / 1024)
    frame.Value.Background:SetAlpha(0.3)
    frame.Value.Background:SetDesaturated(1)

    return frame
end

function S:CreateCharacterStatsPane_Attributes(parent)
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPaneAttributes", parent)
    frame:SetSize(168, CATEGORY_HEADER_HEIGHT + 6 * STAT_HEIGHT)
    frame:SetPoint("TOP", parent.ItemLevel, "BOTTOM", 0, -CATEGORY_SPACING)

    frame.Header = CreateFrame("Frame", addonName .. "CharacterStatsPaneAttributesHeader", parent)
    frame.Header:SetSize(168, CATEGORY_HEADER_HEIGHT)
    frame.Header:SetPoint("TOP", frame, "TOP", 0, 0)
    frame.Header.Text = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Header.Text:SetAllPoints()
    frame.Header.Text:SetJustifyH("CENTER")
    frame.Header.Text:SetJustifyV("CENTER")
    frame.Header.Text:SetShadowOffset(1, -1)
    frame.Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
    frame.Header.Text:SetText(STAT_CATEGORY_ATTRIBUTES)

    local stat1 = _G["PlayerStatFrameLeft1"]
    local stat2 = _G["PlayerStatFrameLeft2"]
    local stat3 = _G["PlayerStatFrameLeft3"]
    local stat4 = _G["PlayerStatFrameLeft4"]
    local stat5 = _G["PlayerStatFrameLeft5"]
    local stat6 = _G["PlayerStatFrameLeft6"]

    S:HandleStat(stat1, frame, false, {"TOPLEFT", frame.Header, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", frame.Header, "BOTTOMRIGHT", 0, 0})
    S:HandleStat(stat2, frame, true, {"TOPLEFT", stat1, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", stat1, "BOTTOMRIGHT", 0, 0})
    S:HandleStat(stat3, frame, false, {"TOPLEFT", stat2, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", stat2, "BOTTOMRIGHT", 0, 0})
    S:HandleStat(stat4, frame, true, {"TOPLEFT", stat3, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", stat3, "BOTTOMRIGHT", 0, 0})
    S:HandleStat(stat5, frame, false, {"TOPLEFT", stat4, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", stat4, "BOTTOMRIGHT", 0, 0})
    S:HandleStat(stat6, frame, true, {"TOPLEFT", stat5, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", stat5, "BOTTOMRIGHT", 0, 0})

    return frame
end

function S:CreateCharacterStatsPane_Enhancements(parent)
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPaneEnhancements", parent)
    frame:SetSize(168, CATEGORY_HEADER_HEIGHT + 6 * STAT_HEIGHT)
    frame:SetPoint("TOP", parent.Attributes, "BOTTOM", 0, -CATEGORY_SPACING)

    frame.Header = CreateFrame("Frame", addonName .. "CharacterStatsPaneEnhancementsHeader", parent)
    frame.Header:SetSize(168, CATEGORY_HEADER_HEIGHT)
    frame.Header:SetPoint("TOP", frame, "TOP", 0, 0)
    frame.Header.Text = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Header.Text:SetAllPoints()
    frame.Header.Text:SetJustifyH("CENTER")
    frame.Header.Text:SetJustifyV("CENTER")
    frame.Header.Text:SetShadowOffset(1, -1)
    frame.Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
    frame.Header.Text:SetText(STAT_CATEGORY_ENHANCEMENTS)

    frame.Header.ButtonPrevious = CreateFrame("Button", addonName .. "CharacterStatsPaneEnhancementsPrevious", frame.Header)
    frame.Header.ButtonPrevious:SetSize(16, 16)
    frame.Header.ButtonPrevious:SetNormalTexture([[Interface\BUTTONS\Arrow-Up-Up]])
    frame.Header.ButtonPrevious:GetNormalTexture():SetRotation(math.pi / 2)
    frame.Header.ButtonPrevious:SetPushedTexture([[Interface\BUTTONS\Arrow-Up-Down]])
    frame.Header.ButtonPrevious:GetPushedTexture():SetRotation(math.pi / 2)
    frame.Header.ButtonPrevious:SetPoint("LEFT", frame.Header, "LEFT", 0, 0)
    frame.Header.ButtonPrevious:SetScript("OnEnter", function(btn)
        GameTooltip:SetOwner(frame.Header.ButtonPrevious, "ANCHOR_TOPLEFT")
        GameTooltip:SetText(L["Previous Category"]) -- TODO: Localization
        GameTooltip:Show()
    end)
    frame.Header.ButtonPrevious:SetScript("OnLeave", function(btn)
        GameTooltip:Hide()
        btn:GetNormalTexture():SetVertexColor(1, 1, 1)
    end)
    frame.Header.ButtonPrevious:SetScript("OnClick", function() frame:PreviousCategory() end)

    frame.Header.ButtonNext = CreateFrame("Button", addonName .. "CharacterStatsPaneEnhancementsNext", frame.Header)
    frame.Header.ButtonNext:SetNormalTexture([[Interface\BUTTONS\Arrow-Up-Up]])
    frame.Header.ButtonNext:GetNormalTexture():SetRotation(-math.pi / 2)
    frame.Header.ButtonNext:SetPushedTexture([[Interface\BUTTONS\Arrow-Up-Down]])
    frame.Header.ButtonNext:GetPushedTexture():SetRotation(-math.pi / 2)
    frame.Header.ButtonNext:SetPoint("RIGHT", frame.Header, "RIGHT", 0, 0)
    frame.Header.ButtonNext:SetSize(16, 16)
    frame.Header.ButtonNext:SetScript("OnEnter", function(btn)
        GameTooltip:SetOwner(frame.Header.ButtonNext, "ANCHOR_TOPLEFT")
        GameTooltip:SetText(L["Next Category"]) -- TODO: Localization
        GameTooltip:Show()
    end)
    frame.Header.ButtonNext:SetScript("OnLeave", function(btn)
        GameTooltip:Hide()
        btn:GetNormalTexture():SetVertexColor(1, 1, 1)
    end)
    frame.Header.ButtonNext:SetScript("OnClick", function() frame:NextCategory() end)

    local stat1 = _G["PlayerStatFrameRight1"]
    local stat2 = _G["PlayerStatFrameRight2"]
    local stat3 = _G["PlayerStatFrameRight3"]
    local stat4 = _G["PlayerStatFrameRight4"]
    local stat5 = _G["PlayerStatFrameRight5"]
    local stat6 = _G["PlayerStatFrameRight6"]

    S:HandleStat(stat1, frame, false, {"TOPLEFT", frame.Header, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", frame.Header, "BOTTOMRIGHT", 0, 0})
    S:HandleStat(stat2, frame, true, {"TOPLEFT", stat1, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", stat1, "BOTTOMRIGHT", 0, 0})
    S:HandleStat(stat3, frame, false, {"TOPLEFT", stat2, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", stat2, "BOTTOMRIGHT", 0, 0})
    S:HandleStat(stat4, frame, true, {"TOPLEFT", stat3, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", stat3, "BOTTOMRIGHT", 0, 0})
    S:HandleStat(stat5, frame, false, {"TOPLEFT", stat4, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", stat4, "BOTTOMRIGHT", 0, 0})
    S:HandleStat(stat6, frame, true, {"TOPLEFT", stat5, "BOTTOMLEFT", 0, 0}, {"TOPRIGHT", stat5, "BOTTOMRIGHT", 0, 0})

    frame.Update = function(self)
        self.Header.Text:SetText(_G[GetCVar("playerStatRightDropdown")])
        PaperDollFrame_UpdateStats()
    end
    frame.PreviousCategory = function(self)
        local current = GetCVar("playerStatRightDropdown")
        for i, category in ipairs(ENHANCEMENT_CATEGORIES) do
            if category == current then
                SetCVar("playerStatRightDropdown", ENHANCEMENT_CATEGORIES[(i == 1 and 4) or (i - 1)])
                break
            end
        end
        frame:Update()
    end
    frame.NextCategory = function(self)
        local current = GetCVar("playerStatRightDropdown")
        for i, category in ipairs(ENHANCEMENT_CATEGORIES) do
            if category == current then
                SetCVar("playerStatRightDropdown", ENHANCEMENT_CATEGORIES[(i == 4 and 1) or (i + 1)])
                break
            end
        end
        frame:Update()
    end
    frame:Update()

    return frame
end

function S:HandleStat(stat, parent, showBackground, point1, point2)
    stat:SetHeight(STAT_HEIGHT)
    stat:ClearAllPoints()
    stat:SetParent(parent)
    stat:SetNormalizedPoint(unpack(point1))
    if point2 then stat:SetNormalizedPoint(unpack(point2)) end
    if showBackground then S:CreateStatBackground(stat) end
end

function S:CreateStatBackground(entry)
    if entry.Background then return end

    entry.Background = entry:CreateTexture("BACKGROUND")
    entry.Background:SetAllPoints()
    entry.Background:SetTexture([[Interface\PaperDollInfoFrame\PaperDollInfoPart1]])
    entry.Background:SetTexCoord(0 / 1024, 160 / 1024, 789 / 1024, 805 / 1024)
    entry.Background:SetAlpha(0.3)
    entry.Background:SetDesaturated(1)
end

function S:UpdateCharacterStatsPane()
    if not _G.CharacterFrame:IsShown() then return end

    S:UpdateAverageItemLevel()
    SetCVar("playerStatLeftDropdown", "PLAYERSTAT_BASE_STATS")
    PaperDollFrame_UpdateStats()
end

local function GetPlayerItemLevelAndQuality()
    local slots = {
        "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot",
        "MainHandSlot", "SecondaryHandSlot", "RangedSlot"
    }
    local minimumItemQuality = 5
    local totalItemLevel = 0
    local count = 0
    local hasTwoHander = false
    for i, slot in next, slots do
        local link = GetInventoryItemLink("player", GetInventorySlotInfo(slot))
        if link then
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon = GetItemInfo(link)
            if itemEquipLoc == "INVTYPE_2HWEAPON" then hasTwoHander = true end
            if itemLevel then totalItemLevel = totalItemLevel + itemLevel end
            if itemRarity and itemRarity < minimumItemQuality then minimumItemQuality = itemRarity end
            count = count + 1
        elseif slot ~= "SecondaryHandSlot" and hasTwoHander then
            count = count + 1
        end
    end

    return math.floor((count and totalItemLevel / count) or 0), minimumItemQuality
end

function S:UpdateAverageItemLevel()
    local averageItemLevel, minimumItemQuality = GetPlayerItemLevelAndQuality()
    local r, g, b = GetItemQualityColor(minimumItemQuality)
    PaperDollFrame.CharacterStatsPane.ItemLevel.Value.Text:SetText(R:Hex(r, g, b) .. averageItemLevel .. "|r")
end
