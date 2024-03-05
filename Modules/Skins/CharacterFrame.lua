local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins
local L = R.L

local CATEGORY_HEADER_HEIGHT = 23
local CATEGORY_SPACING = 5
local ITEM_LEVEL_HEIGHT = 27
local GEAR_SCORE_HEIGHT = 18
local STAT_HEIGHT = 18
local ENHANCEMENT_CATEGORIES = { "PLAYERSTAT_MELEE_COMBAT", "PLAYERSTAT_RANGED_COMBAT", "PLAYERSTAT_SPELL_COMBAT", "PLAYERSTAT_DEFENSES" }

if R.isClassic then
    _G["PLAYERSTAT_MELEE_COMBAT"] = "Melee"
    _G["PLAYERSTAT_RANGED_COMBAT"] = "Ranged"
    _G["PLAYERSTAT_SPELL_COMBAT"] = "Spell"
    _G["PLAYERSTAT_DEFENSES"] = "Defenses"
end

local PAPERDOLL_SIDEBARS = {
    {
        name = PAPERDOLL_SIDEBAR_STATS,
        frame = "CharacterStatsPane",
        icon = nil, -- Uses the character portrait
        texCoords = { 0.109375, 0.890625, 0.09375, 0.90625 },
        disabledTooltip = nil,
        IsActive = function()
            return true
        end
    }, {
        name = PAPERDOLL_SIDEBAR_TITLES,
        frame = "PaperDollTitlesPane",
        icon = [[Interface\PaperDollInfoFrame\PaperDollSidebarTabs]],
        texCoords = { 0.01562500, 0.53125000, 0.32421875, 0.46093750 },
        disabledTooltip = NO_TITLES_TOOLTIP,
        IsActive = function()
            -- You always have the "No Title" title so you need to have more than one to have an option.
            return #GetKnownTitles() > 1
        end
    }, {
        name = PAPERDOLL_EQUIPMENTMANAGER,
        frame = "PaperDollEquipmentManagerPane",
        icon = [[Interface\PaperDollInfoFrame\PaperDollSidebarTabs]],
        texCoords = { 0.01562500, 0.53125000, 0.46875000, 0.60546875 },
        disabledTooltip = function()
            local _, failureReason = C_LFGInfo.CanPlayerUseLFD()
            return failureReason
        end,
        IsActive = function()
            return C_EquipmentSet.GetNumEquipmentSets() > 0 or C_LFGInfo.CanPlayerUseLFD()
        end
    }
}

function S:StyleCharacterFrame()
    if R.isRetail or not S.config.character.enabled then
        return
    end

    CharacterModelFrame:SetSize(231, 320)
    CharacterModelFrame:SetFrameLevel(10)

    CharacterResistanceFrame:SetFrameLevel(11)
    PaperDollItemsFrame:SetFrameLevel(11)
    if PlayerTitleDropDown then
        PlayerTitleDropDown:SetFrameLevel(11)
    end

    CharacterAttributesFrame:Hide()

    S:AddCharacterModelBackground()
    S:StylePaperDollFrame()
    PaperDollFrame.CharacterStatsPane = S:CreateCharacterStatsPane()

    CharacterFrame.normalWidth = CharacterFrame:GetWidth()
    CharacterFrame.extraWidth = 160
    S:RepositionCharacterFrameElements()
    S:SecureHook("CharacterFrame_ShowSubFrame", S.RepositionCharacterFrameElements)

    CharacterNameText:ClearAllPoints()

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
            if guildName then
                CharacterGuildText:SetFormattedText(GUILD_TITLE_TEMPLATE, title, R:Hex(0, 230 / 255, 0) .. guildName .. "|r")
            end
        end)
    end

    S:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", S.UpdateCharacterStatsPane)
    S:SecureHook(nil, "PaperDollItemSlotButton_Update", S.UpdateEquipmentSlotButton)
    CharacterFrame:HookScript("OnShow", S.UpdateCharacterStatsPane)
end

function S:StyleEngravingFrame()
    if EngravingFrame then
        EngravingFrame:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 136, -70)
    end
end

local function DressUpTexturePath(raceFileName)
    if not raceFileName then
        raceFileName = "Orc";
    end

    return [[Interface\DressUpFrame\DressUpBackground-]] .. raceFileName;
end

function S:AddCharacterModelBackground()
    local race, raceFileName = UnitRace("player");
    local texturePath = DressUpTexturePath(raceFileName)

    CharacterModelFrame.Background = CreateFrame("Frame", addonName .. "CharacterModelFrameBackground", CharacterModelFrame)
    CharacterModelFrame.Background:SetSize(231, 320)
    CharacterModelFrame.Background:SetAllPoints()
    CharacterModelFrame.Background:SetFrameLevel(5)
    CharacterModelFrame.Background:SetScale(0.90)

    CharacterModelFrame.Background.TopLeft = CharacterModelFrame.Background:CreateTexture("$parentBackgroundTopLeft", "BACKGROUND")
    CharacterModelFrame.Background.TopLeft:SetTexture(texturePath .. 1)
    CharacterModelFrame.Background.TopLeft:SetSize(259, 255)
    CharacterModelFrame.Background.TopLeft:SetPoint("TOPLEFT", 0, 0)
    CharacterModelFrame.Background.TopLeft:SetDesaturated(1)

    CharacterModelFrame.Background.BottomLeft = CharacterModelFrame.Background:CreateTexture("$parentBackgroundBot", "BACKGROUND")
    CharacterModelFrame.Background.BottomLeft:SetTexture(texturePath .. 3)
    CharacterModelFrame.Background.BottomLeft:SetSize(259, 128)
    CharacterModelFrame.Background.BottomLeft:SetPoint("TOPLEFT", CharacterModelFrame.Background.TopLeft, "BOTTOMLEFT")
    CharacterModelFrame.Background.BottomLeft:SetDesaturated(1)
end

function S:StylePaperDollFrame()
    local regions = { PaperDollFrame:GetRegions() }
    regions[1]:SetTexture(S.config.character.style == S.Styles.Modern and R.media.textures.frames.modern.paperDollInfoFrame or R.media.textures.frames.vanilla.paperDollInfoFrame)
    regions[1]:ClearAllPoints()
    regions[1]:SetPoint("TOPLEFT", 0, -1)
    regions[1]:SetSize(512, 512)
    regions[2]:Hide()
    regions[3]:Hide()
    regions[4]:Hide()

    PaperDollFrame:ClearAllPoints()
    PaperDollFrame:SetPoint("TOPLEFT")
    PaperDollFrame:SetPoint("BOTTOMRIGHT", 160, 0)

    if RuneFrameControlButton then
        RuneFrameControlButton:ClearAllPoints()
        RuneFrameControlButton:SetPoint("TOPRIGHT", -40, -40)
    end
end

function S:RepositionCharacterFrameElements()
    if PaperDollFrame:IsShown() then
        CharacterFrameCloseButton:SetPoint("CENTER", CharacterFrame, "TOPRIGHT", -44 + CharacterFrame.extraWidth, -25)
        CharacterNameText:SetPoint("CENTER", CharacterFrame, "CENTER", 84, 232)
        CharacterLevelText:ClearAllPoints()
        CharacterLevelText:SetPoint("TOP", CharacterNameText, "BOTTOM", 0, -10)
        CharacterLevelText:Show()
    else
        CharacterFrameCloseButton:SetPoint("CENTER", CharacterFrame, "TOPRIGHT", -44, -25)
        CharacterNameText:SetPoint("CENTER", CharacterFrame, "CENTER", 6, 232)
        CharacterLevelText:Hide()

        if TokenFrame and TokenFrame:IsShown() then
            local extraCloseButton = select(4, TokenFrame:GetChildren())
            extraCloseButton:ClearAllPoints()
            extraCloseButton:SetAllPoints(CharacterFrameCloseButton)
            extraCloseButton:Hide()
        end
    end
end

function S:CreateCharacterStatsPane()
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPane", PaperDollFrame)
    frame:SetSize(152, 355)
    frame:SetPoint("TOPRIGHT", _G.PaperDollFrame, "TOPRIGHT", -42, -76)

    frame.Background = frame:CreateTexture("BACKGROUND")
    frame.Background:SetTexture(R.media.textures.blank)
    frame.Background:SetVertexColor(1, 1, 1, 0.5)
    frame.Background:SetAllPoints()
    frame.Background:Hide()

    frame.Inset = CreateFrame("Frame", "$parentInset", frame)
    frame.Inset:SetPoint("TOPLEFT", 5, 0)
    frame.Inset:SetPoint("BOTTOMRIGHT", -5, 0)

    frame.ItemLevel = S:CreateCharacterStatsPane_ItemLevel(frame, frame.Inset)
    if not R.isClassic then
        frame.GearScore = S:CreateCharacterStatsPane_GearScore(frame, frame.Inset)
    end
    frame.Attributes = S:CreateCharacterStatsPane_Attributes(frame, frame.Inset)
    frame.Enhancements = S:CreateCharacterStatsPane_Enhancements(frame, frame.Inset)

    return frame
end

function S:CreateCharacterStatsPane_ItemLevel(parent, anchor)
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPaneItemLevel", parent)
    frame:SetHeight(CATEGORY_HEADER_HEIGHT + ITEM_LEVEL_HEIGHT)
    frame:SetPoint("TOPLEFT", anchor, "TOPLEFT")
    frame:SetPoint("TOPRIGHT", anchor, "TOPRIGHT")

    frame.Header = CreateFrame("Frame", addonName .. "CharacterStatsPaneItemLevelLabel", frame)
    frame.Header:SetHeight(CATEGORY_HEADER_HEIGHT)
    frame.Header:SetPoint("TOPLEFT")
    frame.Header:SetPoint("TOPRIGHT")
    frame.Header.Text = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Header.Text:SetAllPoints()
    frame.Header.Text:SetJustifyH("CENTER")
    frame.Header.Text:SetJustifyV("CENTER")
    frame.Header.Text:SetShadowOffset(1, -1)
    frame.Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
    frame.Header.Text:SetText(STAT_AVERAGE_ITEM_LEVEL)

    frame.Value = CreateFrame("Frame", addonName .. "CharacterStatsPaneItemLevelValue", frame)
    frame.Value:SetHeight(ITEM_LEVEL_HEIGHT)
    frame.Value:SetPoint("TOPLEFT", frame.Header, "BOTTOMLEFT")
    frame.Value:SetPoint("TOPRIGHT", frame.Header, "BOTTOMRIGHT")
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

function S:CreateCharacterStatsPane_GearScore(parent, anchor)
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPaneGearScore", parent)
    frame:SetHeight(CATEGORY_HEADER_HEIGHT + GEAR_SCORE_HEIGHT)
    frame:SetPoint("TOPLEFT", parent.ItemLevel, "BOTTOMLEFT", 0, 0)
    frame:SetPoint("TOPRIGHT", parent.ItemLevel, "BOTTOMRIGHT", 0, 0)

    frame.Header = CreateFrame("Frame", addonName .. "CharacterStatsPaneGearScoreLabel", frame)
    frame.Header:SetHeight(CATEGORY_HEADER_HEIGHT)
    frame.Header:SetPoint("TOPLEFT")
    frame.Header:SetPoint("TOPRIGHT")
    frame.Header.Text = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Header.Text:SetAllPoints()
    frame.Header.Text:SetJustifyH("CENTER")
    frame.Header.Text:SetJustifyV("CENTER")
    frame.Header.Text:SetShadowOffset(1, -1)
    frame.Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
    frame.Header.Text:SetText(L["Gear Score"])

    frame.Value = CreateFrame("Frame", addonName .. "CharacterStatsPaneGearScoreValue", frame)
    frame.Value:SetHeight(GEAR_SCORE_HEIGHT)
    frame.Value:SetPoint("TOPLEFT", frame.Header, "BOTTOMLEFT")
    frame.Value:SetPoint("TOPRIGHT", frame.Header, "BOTTOMRIGHT")
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

function S:CreateCharacterStatsPane_Attributes(parent, anchor)
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPaneAttributes", parent)
    frame:SetHeight(CATEGORY_HEADER_HEIGHT + 6 * STAT_HEIGHT)
    frame:SetPoint("TOPLEFT", parent.ItemLevel, "BOTTOMLEFT", 0, -CATEGORY_SPACING)
    frame:SetPoint("TOPRIGHT", parent.ItemLevel, "BOTTOMRIGHT", 0, -CATEGORY_SPACING)

    frame.Header = CreateFrame("Frame", addonName .. "CharacterStatsPaneAttributesHeader", frame)
    frame.Header:SetHeight(CATEGORY_HEADER_HEIGHT)
    frame.Header:SetPoint("TOPLEFT")
    frame.Header:SetPoint("TOPRIGHT")
    frame.Header.Text = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Header.Text:SetAllPoints()
    frame.Header.Text:SetJustifyH("CENTER")
    frame.Header.Text:SetJustifyV("CENTER")
    frame.Header.Text:SetShadowOffset(1, -1)
    frame.Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
    frame.Header.Text:SetText(STAT_CATEGORY_ATTRIBUTES)

    if R.isClassic then
        local stat1 = _G["CharacterStatFrame1"]
        local stat2 = _G["CharacterStatFrame2"]
        local stat3 = _G["CharacterStatFrame3"]
        local stat4 = _G["CharacterStatFrame4"]
        local stat5 = _G["CharacterStatFrame5"]

        S:HandleStat(stat1, frame, false, { "TOPLEFT", frame.Header, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", frame.Header, "BOTTOMRIGHT", 0, 0 })
        S:HandleStat(stat2, frame, true, { "TOPLEFT", stat1, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat1, "BOTTOMRIGHT", 0, 0 })
        S:HandleStat(stat3, frame, false, { "TOPLEFT", stat2, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat2, "BOTTOMRIGHT", 0, 0 })
        S:HandleStat(stat4, frame, true, { "TOPLEFT", stat3, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat3, "BOTTOMRIGHT", 0, 0 })
        S:HandleStat(stat5, frame, false, { "TOPLEFT", stat4, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat4, "BOTTOMRIGHT", 0, 0 })
    else
        local stat1 = _G["PlayerStatFrameLeft1"]
        local stat2 = _G["PlayerStatFrameLeft2"]
        local stat3 = _G["PlayerStatFrameLeft3"]
        local stat4 = _G["PlayerStatFrameLeft4"]
        local stat5 = _G["PlayerStatFrameLeft5"]
        local stat6 = _G["PlayerStatFrameLeft6"]

        S:HandleStat(stat1, frame, false, { "TOPLEFT", frame.Header, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", frame.Header, "BOTTOMRIGHT", 0, 0 })
        S:HandleStat(stat2, frame, true, { "TOPLEFT", stat1, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat1, "BOTTOMRIGHT", 0, 0 })
        S:HandleStat(stat3, frame, false, { "TOPLEFT", stat2, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat2, "BOTTOMRIGHT", 0, 0 })
        S:HandleStat(stat4, frame, true, { "TOPLEFT", stat3, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat3, "BOTTOMRIGHT", 0, 0 })
        S:HandleStat(stat5, frame, false, { "TOPLEFT", stat4, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat4, "BOTTOMRIGHT", 0, 0 })
        S:HandleStat(stat6, frame, true, { "TOPLEFT", stat5, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat5, "BOTTOMRIGHT", 0, 0 })
    end

    return frame
end

function S:GetSelectedEnhancement()
    if R.isClassic then
        return S.config.character.selectedEnhancement
    else
        GetCVar("playerStatRightDropdown")
    end
end

function S:CreateCharacterStatsPane_Enhancements(parent, anchor)
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPaneEnhancements", parent)
    frame:SetHeight(CATEGORY_HEADER_HEIGHT + 6 * STAT_HEIGHT)
    frame:SetPoint("TOPLEFT", parent.Attributes, "BOTTOMLEFT", 0, -CATEGORY_SPACING)
    frame:SetPoint("TOPRIGHT", parent.Attributes, "BOTTOMRIGHT", 0, -CATEGORY_SPACING)

    frame.Header = CreateFrame("Frame", addonName .. "CharacterStatsPaneEnhancementsHeader", frame)
    frame.Header:SetHeight(CATEGORY_HEADER_HEIGHT)
    frame.Header:SetPoint("TOPLEFT")
    frame.Header:SetPoint("TOPRIGHT")
    frame.Header.Text = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Header.Text:SetAllPoints()
    frame.Header.Text:SetJustifyH("CENTER")
    frame.Header.Text:SetJustifyV("CENTER")
    frame.Header.Text:SetShadowOffset(1, -1)
    frame.Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
    frame.Header.Text:SetText(_G[S:GetSelectedEnhancement()])

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
    frame.Header.ButtonPrevious:SetScript("OnClick", function()
        frame:PreviousCategory()
    end)

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
    frame.Header.ButtonNext:SetScript("OnClick", function()
        frame:NextCategory()
    end)

    local stat1 = R.isClassic and CreateFrame("Frame", "PlayerStatFrameRight1", frame.Header, "AttributeFrameTemplate") or _G["PlayerStatFrameRight1"]
    local stat2 = R.isClassic and CreateFrame("Frame", "PlayerStatFrameRight2", frame.Header, "AttributeFrameTemplate") or _G["PlayerStatFrameRight2"]
    local stat3 = R.isClassic and CreateFrame("Frame", "PlayerStatFrameRight3", frame.Header, "AttributeFrameTemplate") or _G["PlayerStatFrameRight3"]
    local stat4 = R.isClassic and CreateFrame("Frame", "PlayerStatFrameRight4", frame.Header, "AttributeFrameTemplate") or _G["PlayerStatFrameRight4"]
    local stat5 = R.isClassic and CreateFrame("Frame", "PlayerStatFrameRight5", frame.Header, "AttributeFrameTemplate") or _G["PlayerStatFrameRight5"]
    local stat6 = R.isClassic and CreateFrame("Frame", "PlayerStatFrameRight6", frame.Header, "AttributeFrameTemplate") or _G["PlayerStatFrameRight6"]

    S:HandleStat(stat1, frame, false, { "TOPLEFT", frame.Header, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", frame.Header, "BOTTOMRIGHT", 0, 0 })
    S:HandleStat(stat2, frame, true, { "TOPLEFT", stat1, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat1, "BOTTOMRIGHT", 0, 0 })
    S:HandleStat(stat3, frame, false, { "TOPLEFT", stat2, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat2, "BOTTOMRIGHT", 0, 0 })
    S:HandleStat(stat4, frame, true, { "TOPLEFT", stat3, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat3, "BOTTOMRIGHT", 0, 0 })
    S:HandleStat(stat5, frame, false, { "TOPLEFT", stat4, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat4, "BOTTOMRIGHT", 0, 0 })
    S:HandleStat(stat6, frame, true, { "TOPLEFT", stat5, "BOTTOMLEFT", 0, 0 }, { "TOPRIGHT", stat5, "BOTTOMRIGHT", 0, 0 })

    frame.Update = function(self)
        self.Header.Text:SetText(_G[S:GetSelectedEnhancement()])
        PaperDollFrame_UpdateStats()
        if R.isClassic then
            S:UpdateEnhancementStats()
        end
    end
    frame.PreviousCategory = function(self)
        local current = S:GetSelectedEnhancement()
        for i, category in ipairs(ENHANCEMENT_CATEGORIES) do
            if category == current then
                if R.isClassic then
                    S.config.character.selectedEnhancement = ENHANCEMENT_CATEGORIES[(i == 1 and 4) or (i - 1)]
                else
                    SetCVar("playerStatRightDropdown", ENHANCEMENT_CATEGORIES[(i == 1 and 4) or (i - 1)])
                end
                break
            end
        end
        frame:Update()
    end
    frame.NextCategory = function(self)
        local current = S:GetSelectedEnhancement()
        for i, category in ipairs(ENHANCEMENT_CATEGORIES) do
            if category == current then
                if R.isClassic then
                    S.config.character.selectedEnhancement = ENHANCEMENT_CATEGORIES[(i == 4 and 1) or (i + 1)]
                else
                    SetCVar("playerStatRightDropdown", ENHANCEMENT_CATEGORIES[(i == 4 and 1) or (i + 1)])
                end
                break
            end
        end
        frame:Update()
    end
    frame:Update()

    return frame
end

function S:HandleStat(stat, parent, showBackground, point1, point2)
    if not stat then
        return
    end

    stat:SetHeight(STAT_HEIGHT)
    stat:ClearAllPoints()
    stat:SetParent(parent)
    stat:SetNormalizedPoint(unpack(point1))
    if point2 then
        stat:SetNormalizedPoint(unpack(point2))
    end
    if showBackground then
        S:CreateStatBackground(stat)
    end
end

function S:CreateStatBackground(entry)
    if entry.Background then
        return
    end

    entry.Background = entry:CreateTexture("BACKGROUND")
    entry.Background:SetAllPoints()
    entry.Background:SetTexture([[Interface\PaperDollInfoFrame\PaperDollInfoPart1]])
    entry.Background:SetTexCoord(0 / 1024, 160 / 1024, 789 / 1024, 805 / 1024)
    entry.Background:SetAlpha(0.3)
    entry.Background:SetDesaturated(1)
end

function S:UpdateCharacterStatsPane()
    if not _G.CharacterFrame:IsShown() then
        return
    end

    S:UpdateAverageItemLevel()
    if not R.isClassic then
        S:UpdateGearScore()
    end
    SetCVar("playerStatLeftDropdown", "PLAYERSTAT_BASE_STATS")
    PaperDollFrame_UpdateStats()
end

function S:UpdateAverageItemLevel()
    local averageItemLevel, minimumItemQuality = R:GetPlayerItemLevelAndQuality()
    local r, g, b = GetItemQualityColor(minimumItemQuality)
    PaperDollFrame.CharacterStatsPane.ItemLevel.Value.Text:SetText(R:Hex(r, g, b) .. averageItemLevel .. "|r")
end

function S:UpdateGearScore()
    if S.config.character.showGearScore then
        PaperDollFrame.CharacterStatsPane.GearScore:Show()
        PaperDollFrame.CharacterStatsPane.ItemLevel:SetHeight(CATEGORY_HEADER_HEIGHT + GEAR_SCORE_HEIGHT)
        PaperDollFrame.CharacterStatsPane.ItemLevel.Value:SetHeight(GEAR_SCORE_HEIGHT)
        PaperDollFrame.CharacterStatsPane.Attributes:SetPoint("TOPLEFT", PaperDollFrame.CharacterStatsPane.ItemLevel, "BOTTOMLEFT", 0, -GEAR_SCORE_HEIGHT - CATEGORY_HEADER_HEIGHT)
        PaperDollFrame.CharacterStatsPane.Attributes:SetPoint("TOPRIGHT", PaperDollFrame.CharacterStatsPane.ItemLevel, "BOTTOMRIGHT", 0, -GEAR_SCORE_HEIGHT - CATEGORY_HEADER_HEIGHT)

        local gearScore, averageItemLevel = R.GearScore:GetScore("player")
        r, g, b = R.GearScore:GetQuality(gearScore)
        PaperDollFrame.CharacterStatsPane.GearScore.Value.Text:SetText(R:Hex(r, g, b) .. gearScore .. "|r")
    else
        PaperDollFrame.CharacterStatsPane.GearScore:Hide()
        PaperDollFrame.CharacterStatsPane.ItemLevel:SetHeight(CATEGORY_HEADER_HEIGHT + ITEM_LEVEL_HEIGHT)
        PaperDollFrame.CharacterStatsPane.ItemLevel.Value:SetHeight(ITEM_LEVEL_HEIGHT)
        PaperDollFrame.CharacterStatsPane.Attributes:SetPoint("TOPLEFT", PaperDollFrame.CharacterStatsPane.ItemLevel, "BOTTOMLEFT", 0, -CATEGORY_SPACING)
        PaperDollFrame.CharacterStatsPane.Attributes:SetPoint("TOPRIGHT", PaperDollFrame.CharacterStatsPane.ItemLevel, "BOTTOMRIGHT", 0, -CATEGORY_SPACING)
    end
end

function S:UpdateEquipmentSlotButton()
    if not self.__styled then
        self.__styled = true

        self.icon = _G[self:GetName() .. "IconTexture"]
        self.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        self.icon:SetInside(self, 2, 2)

        self:SetNormalTexture(R.media.textures.buttons.border)
        local normalTexture = self:GetNormalTexture()
        normalTexture:SetOutside(self, 4, 4)
        normalTexture:SetTexCoord(0, 1, 0, 1)

        self:SetPushedTexture(R.media.textures.buttons.border)
        local pushedTexture = self:GetPushedTexture()
        pushedTexture:SetOutside(self, 4, 4)
    end

    local r, g, b = 0.7, 0.7, 0.7
    self.ItemIDOrLink = GetInventoryItemLink("player", self:GetID())
    if self.ItemIDOrLink then
        local itemRarity = select(3, GetItemInfo(self.ItemIDOrLink))
        if itemRarity and itemRarity > 1 then
            r, g, b = GetItemQualityColor(itemRarity)
        end
    end

    self:GetNormalTexture():SetVertexColor(r, g, b, 1)
end

if R.isClassic then
    MAX_SPELL_SCHOOLS = 7;

    CR_WEAPON_SKILL = 1;
    CR_DEFENSE_SKILL = 2;
    CR_DODGE = 3;
    CR_PARRY = 4;
    CR_BLOCK = 5;
    CR_HIT_MELEE = 6;
    CR_HIT_RANGED = 7;
    CR_HIT_SPELL = 8;
    CR_CRIT_MELEE = 9;
    CR_CRIT_RANGED = 10;
    CR_CRIT_SPELL = 11;
    CR_RESILIENCE_CRIT_TAKEN = 15;
    CR_RESILIENCE_PLAYER_DAMAGE_TAKEN = 16;
    CR_HASTE_MELEE = 18;
    CR_HASTE_RANGED = 19;
    CR_HASTE_SPELL = 20;
    CR_EXPERTISE = 24;

    ATTACK_POWER_MAGIC_NUMBER = 14;
    BLOCK_PER_STRENGTH = 0.05;
    HEALTH_PER_STAMINA = 10;
    ARMOR_PER_AGILITY = 2;
    MANA_PER_INTELLECT = 15;
    MANA_REGEN_PER_SPIRIT = 0.2;
    DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE = 0.04;
    BASE_MOVEMENT_SPEED = 7;

    function S:UpdateEnhancementStats()
        local stat1 = _G["PlayerStatFrameRight1"];
        local stat2 = _G["PlayerStatFrameRight2"];
        local stat3 = _G["PlayerStatFrameRight3"];
        local stat4 = _G["PlayerStatFrameRight4"];
        local stat5 = _G["PlayerStatFrameRight5"];
        local stat6 = _G["PlayerStatFrameRight6"];

        -- reset any OnEnter scripts that may have been changed
        stat1:SetScript("OnEnter", S.PaperDollStatTooltip);
        stat2:SetScript("OnEnter", S.PaperDollStatTooltip);
        stat4:SetScript("OnEnter", S.PaperDollStatTooltip);

        stat6:Show();

        local current = S:GetSelectedEnhancement()
        if (current == "PLAYERSTAT_MELEE_COMBAT") then
            S:SetDamage(stat1);
            stat1:SetScript("OnEnter", S.CharacterDamageFrame_OnEnter);
            S:SetAttackSpeed(stat2);
            S:SetAttackPower(stat3);
            S:SetRating(stat4, CR_HIT_MELEE);
            S:SetMeleeCritChance(stat5);
            stat6:Hide();
            -- S:SetExpertise(stat6);
        elseif (current == "PLAYERSTAT_RANGED_COMBAT") then
            S:SetRangedDamage(stat1);
            stat1:SetScript("OnEnter", S.CharacterRangedDamageFrame_OnEnter);
            S:SetRangedAttackSpeed(stat2);
            S:SetRangedAttackPower(stat3);
            S:SetRating(stat4, CR_HIT_RANGED);
            S:SetRangedCritChance(stat5);
            stat6:Hide();
        elseif (current == "PLAYERSTAT_SPELL_COMBAT") then
            S:SetSpellBonusDamage(stat1);
            stat1:SetScript("OnEnter", S.CharacterSpellBonusDamage_OnEnter);
            S:SetSpellBonusHealing(stat2);
            S:SetRating(stat3, CR_HIT_SPELL);
            S:SetSpellCritChance(stat4);
            stat4:SetScript("OnEnter", S.CharacterSpellCritChance_OnEnter);
            S:SetManaRegen(stat5);
            -- S:SetSpellHaste(stat5);
            -- S:SetManaRegen(stat6);
            stat6:Hide();
        elseif (current == "PLAYERSTAT_DEFENSES") then
            S:SetArmor(stat1);
            S:SetDefense(stat2);
            S:SetDodge(stat3);
            S:SetParry(stat4);
            S:SetBlock(stat5);
            stat6:Hide();
            -- S:SetResilience(stat6);
        end
    end

    function S:SetLabelAndText(statFrame, label, text, isPercentage)
        getglobal(statFrame:GetName() .. "Label"):SetText(label .. ":");
        if (isPercentage) then
            text = format("%.2f%%", text);
        end
        getglobal(statFrame:GetName() .. "StatText"):SetText(text);
    end

    function S:SetRating(statFrame, ratingIndex)
        local label = getglobal(statFrame:GetName() .. "Label");
        local text = getglobal(statFrame:GetName() .. "StatText");
        local statName = getglobal("COMBAT_RATING_NAME" .. ratingIndex);
        label:SetText(statName .. ":");
        local rating = GetCombatRating(ratingIndex);
        local ratingBonus = GetCombatRatingBonus(ratingIndex);
        text:SetText(rating);

        -- Set the tooltip text
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. statName .. " " .. rating .. FONT_COLOR_CODE_CLOSE;
        -- Can probably axe this if else tree if all rating tooltips follow the same format
        if (ratingIndex == CR_HIT_MELEE) then
            statFrame.tooltip2 = format(CR_HIT_MELEE_TOOLTIP, UnitLevel("player"), ratingBonus, GetArmorPenetration());
        elseif (ratingIndex == CR_HIT_RANGED) then
            statFrame.tooltip2 = format(CR_HIT_RANGED_TOOLTIP, UnitLevel("player"), ratingBonus, GetArmorPenetration());
        elseif (ratingIndex == CR_DODGE) then
            statFrame.tooltip2 = format(CR_DODGE_TOOLTIP, ratingBonus);
        elseif (ratingIndex == CR_PARRY) then
            statFrame.tooltip2 = format(CR_PARRY_TOOLTIP, ratingBonus);
        elseif (ratingIndex == CR_BLOCK) then
            statFrame.tooltip2 = format(CR_PARRY_TOOLTIP, ratingBonus);
        elseif (ratingIndex == CR_HIT_SPELL) then
            statFrame.tooltip2 = format(CR_HIT_SPELL_TOOLTIP, UnitLevel("player"), ratingBonus, GetSpellPenetration(), GetSpellPenetration());
        elseif (ratingIndex == CR_CRIT_SPELL) then
            local holySchool = 2;
            local minCrit = GetSpellCritChance(holySchool);
            statFrame.spellCrit = {};
            statFrame.spellCrit[holySchool] = minCrit;
            local spellCrit;
            for i = (holySchool + 1), MAX_SPELL_SCHOOLS do
                spellCrit = GetSpellCritChance(i);
                minCrit = min(minCrit, spellCrit);
                statFrame.spellCrit[i] = spellCrit;
            end
            minCrit = format("%.2f%%", minCrit);
            statFrame.minCrit = minCrit;
        elseif (ratingIndex == CR_EXPERTISE) then
            statFrame.tooltip2 = format(CR_EXPERTISE_TOOLTIP, ratingBonus);
        else
            statFrame.tooltip2 = HIGHLIGHT_FONT_COLOR_CODE .. getglobal("COMBAT_RATING_NAME" .. ratingIndex) .. " " .. rating;
        end
    end

    function S:SetArmor(statFrame, unit)
        if (not unit) then
            unit = "player";
        end
        local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor(unit);
        getglobal(statFrame:GetName() .. "Label"):SetText(ARMOR_COLON);
        local text = getglobal(statFrame:GetName() .. "StatText");

        PaperDollFormatStat(ARMOR, base, posBuff, negBuff, statFrame, text);
        local armorReduction = S:GetArmorReduction(effectiveArmor, UnitLevel(unit));
        statFrame.tooltip2 = format(DEFAULT_STATARMOR_TOOLTIP, armorReduction);

        if (unit == "player") then
            local petBonus = S:ComputePetBonus("PET_BONUS_ARMOR", effectiveArmor);
            if (petBonus > 0) then
                statFrame.tooltip2 = statFrame.tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_ARMOR, petBonus);
            end
        end
    end

    function S:SetDefense(statFrame, unit)
        if (not unit) then
            unit = "player";
        end
        local base, modifier = UnitDefense(unit);
        local posBuff = 0;
        local negBuff = 0;
        if (modifier > 0) then
            posBuff = modifier;
        elseif (modifier < 0) then
            negBuff = modifier;
        end
        getglobal(statFrame:GetName() .. "Label"):SetText(DEFENSE_COLON);
        local text = getglobal(statFrame:GetName() .. "StatText");

        PaperDollFormatStat(DEFENSE, base, posBuff, negBuff, statFrame, text);
        local defensePercent = S:GetDodgeBlockParryChanceFromDefense();
        statFrame.tooltip2 = format(DEFAULT_STATDEFENSE_TOOLTIP, GetCombatRating(CR_DEFENSE_SKILL), GetCombatRatingBonus(CR_DEFENSE_SKILL), defensePercent, defensePercent);
    end

    function S:SetDodge(statFrame)
        local chance = GetDodgeChance();
        S:SetLabelAndText(statFrame, STAT_DODGE, chance, 1);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. getglobal("DODGE_CHANCE") .. " " .. string.format("%.02f", chance) .. "%" .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(CR_DODGE_TOOLTIP, GetCombatRating(CR_DODGE), GetCombatRatingBonus(CR_DODGE));
    end

    function S:SetBlock(statFrame)
        local chance = GetBlockChance();
        S:SetLabelAndText(statFrame, STAT_BLOCK, chance, 1);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. getglobal("BLOCK_CHANCE") .. " " .. string.format("%.02f", chance) .. "%" .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(CR_BLOCK_TOOLTIP, GetCombatRating(CR_BLOCK), GetCombatRatingBonus(CR_BLOCK), GetShieldBlock());
    end

    function S:SetParry(statFrame)
        local chance = GetParryChance();
        S:SetLabelAndText(statFrame, STAT_PARRY, chance, 1);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. getglobal("PARRY_CHANCE") .. " " .. string.format("%.02f", chance) .. "%" .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(CR_PARRY_TOOLTIP, GetCombatRating(CR_PARRY), GetCombatRatingBonus(CR_PARRY));
    end

    function S:GetDodgeBlockParryChanceFromDefense()
        local base, modifier = UnitDefense("player");
        -- local defensePercent = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE * modifier;
        local defensePercent = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE * ((base + modifier) - (UnitLevel("player") * 5));
        defensePercent = max(defensePercent, 0);
        return defensePercent;
    end

    function S:SetResilience(statFrame)
        local resilience = GetCombatRating(CR_RESILIENCE_CRIT_TAKEN);
        local bonus = GetCombatRatingBonus(CR_RESILIENCE_CRIT_TAKEN);

        S:SetLabelAndText(statFrame, STAT_RESILIENCE, resilience);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. STAT_RESILIENCE .. " " .. resilience .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(RESILIENCE_TOOLTIP, bonus, min(bonus * 2, 25.00), bonus);
    end

    function S:SetDamage(statFrame, unit)
        if (not unit) then
            unit = "player";
        end
        getglobal(statFrame:GetName() .. "Label"):SetText(DAMAGE_COLON);
        local text = getglobal(statFrame:GetName() .. "StatText");
        local speed, offhandSpeed = UnitAttackSpeed(unit);
        local minDamage;
        local maxDamage;
        local minOffHandDamage;
        local maxOffHandDamage;
        local physicalBonusPos;
        local physicalBonusNeg;
        local percent;
        minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage(unit);
        local displayMin = max(floor(minDamage), 1);
        local displayMax = max(ceil(maxDamage), 1);

        if (percent == 0) then
            minDamage = 0;
            maxDamage = 0;
        else
            minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg;
            maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg;
        end

        local baseDamage = (minDamage + maxDamage) * 0.5;
        local fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent;
        local totalBonus = (fullDamage - baseDamage);
        local damagePerSecond;
        if speed == 0 then
            damagePerSecond = 0;
        else
            damagePerSecond = (max(fullDamage, 1) / speed);
        end
        local damageTooltip = max(floor(minDamage), 1) .. " - " .. max(ceil(maxDamage), 1);

        local colorPos = "|cff20ff20";
        local colorNeg = "|cffff2020";

        -- epsilon check
        if (totalBonus < 0.1 and totalBonus > -0.1) then
            totalBonus = 0.0;
        end

        if (totalBonus == 0) then
            if ((displayMin < 100) and (displayMax < 100)) then
                text:SetText(displayMin .. " - " .. displayMax);
            else
                text:SetText(displayMin .. "-" .. displayMax);
            end
        else

            local color;
            if (totalBonus > 0) then
                color = colorPos;
            else
                color = colorNeg;
            end
            if ((displayMin < 100) and (displayMax < 100)) then
                text:SetText(color .. displayMin .. " - " .. displayMax .. "|r");
            else
                text:SetText(color .. displayMin .. "-" .. displayMax .. "|r");
            end
            if (physicalBonusPos > 0) then
                damageTooltip = damageTooltip .. colorPos .. " +" .. physicalBonusPos .. "|r";
            end
            if (physicalBonusNeg < 0) then
                damageTooltip = damageTooltip .. colorNeg .. " " .. physicalBonusNeg .. "|r";
            end
            if (percent > 1) then
                damageTooltip = damageTooltip .. colorPos .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            elseif (percent < 1) then
                damageTooltip = damageTooltip .. colorNeg .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            end

        end
        statFrame.damage = damageTooltip;
        statFrame.attackSpeed = speed;
        statFrame.dps = damagePerSecond;

        -- If there's an offhand speed then add the offhand info to the tooltip
        if (offhandSpeed) then
            minOffHandDamage = (minOffHandDamage / percent) - physicalBonusPos - physicalBonusNeg;
            maxOffHandDamage = (maxOffHandDamage / percent) - physicalBonusPos - physicalBonusNeg;

            local offhandBaseDamage = (minOffHandDamage + maxOffHandDamage) * 0.5;
            local offhandFullDamage = (offhandBaseDamage + physicalBonusPos + physicalBonusNeg) * percent;
            local offhandDamagePerSecond;
            if offhandSpeed == 0 then
                offhandDamagePerSecond = 0;
            else
                offhandDamagePerSecond = (max(offhandFullDamage, 1) / offhandSpeed);
            end
            local offhandDamageTooltip = max(floor(minOffHandDamage), 1) .. " - " .. max(ceil(maxOffHandDamage), 1);
            if (physicalBonusPos > 0) then
                offhandDamageTooltip = offhandDamageTooltip .. colorPos .. " +" .. physicalBonusPos .. "|r";
            end
            if (physicalBonusNeg < 0) then
                offhandDamageTooltip = offhandDamageTooltip .. colorNeg .. " " .. physicalBonusNeg .. "|r";
            end
            if (percent > 1) then
                offhandDamageTooltip = offhandDamageTooltip .. colorPos .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            elseif (percent < 1) then
                offhandDamageTooltip = offhandDamageTooltip .. colorNeg .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            end
            statFrame.offhandDamage = offhandDamageTooltip;
            statFrame.offhandAttackSpeed = offhandSpeed;
            statFrame.offhandDps = offhandDamagePerSecond;
        else
            statFrame.offhandAttackSpeed = nil;
        end
    end

    function S:SetAttackSpeed(statFrame, unit)
        if (not unit) then
            unit = "player";
        end
        local speed, offhandSpeed = UnitAttackSpeed(unit);
        speed = format("%.2f", speed);
        if (offhandSpeed) then
            offhandSpeed = format("%.2f", offhandSpeed);
        end
        local text;
        if (offhandSpeed) then
            text = speed .. " / " .. offhandSpeed;
        else
            text = speed;
        end
        S:SetLabelAndText(statFrame, WEAPON_SPEED, text);

        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. ATTACK_SPEED .. " " .. text .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(CR_HASTE_RATING_TOOLTIP, GetCombatRating(CR_HASTE_MELEE), GetCombatRatingBonus(CR_HASTE_MELEE));
    end

    function S:SetAttackPower(statFrame, unit)
        if (not unit) then
            unit = "player";
        end
        getglobal(statFrame:GetName() .. "Label"):SetText(ATTACK_POWER_COLON);
        local text = getglobal(statFrame:GetName() .. "StatText");
        local base, posBuff, negBuff = UnitAttackPower(unit);

        PaperDollFormatStat(MELEE_ATTACK_POWER, base, posBuff, negBuff, statFrame, text);
        statFrame.tooltip2 = format(MELEE_ATTACK_POWER_TOOLTIP, max((base + posBuff + negBuff), 0) / ATTACK_POWER_MAGIC_NUMBER);
    end

    function S:SetAttackBothHands(statFrame, unit)
        if (not unit) then
            unit = "player";
        end
        local mainHandAttackBase, mainHandAttackMod, offHandAttackBase, offHandAttackMod = UnitAttackBothHands(unit);

        getglobal(statFrame:GetName() .. "Label"):SetText(COMBAT_RATING_NAME1 .. ":");
        local text = getglobal(statFrame:GetName() .. "StatText");

        if (mainHandAttackMod == 0) then
            text:SetText(mainHandAttackBase);
        else
            local color = RED_FONT_COLOR_CODE;
            if (mainHandAttackMod > 0) then
                color = GREEN_FONT_COLOR_CODE;
            end
            text:SetText(color .. (mainHandAttackBase + mainHandAttackMod) .. FONT_COLOR_CODE_CLOSE);
        end

        if (mainHandAttackMod == 0) then
            statFrame.weaponSkill = COMBAT_RATING_NAME1 .. " " .. mainHandAttackBase;
        else
            local color = RED_FONT_COLOR_CODE;
            statFrame.weaponSkill = COMBAT_RATING_NAME1 .. " " .. (mainHandAttackBase + mainHandAttackMod) .. " (" .. mainHandAttackBase .. color .. " " .. mainHandAttackMod .. ")";
            if (mainHandAttackMod > 0) then
                color = GREEN_FONT_COLOR_CODE;
                statFrame.weaponSkill = COMBAT_RATING_NAME1 .. " " .. (mainHandAttackBase + mainHandAttackMod) .. " (" .. mainHandAttackBase .. color .. " +" .. mainHandAttackMod ..
                                            FONT_COLOR_CODE_CLOSE .. ")";
            end
        end

        local total = GetCombatRating(CR_WEAPON_SKILL) + GetCombatRating(CR_WEAPON_SKILL_MAINHAND);
        statFrame.weaponRating = format(WEAPON_SKILL_RATING, total);
        if (total > 0) then
            statFrame.weaponRating = statFrame.weaponRating .. format(WEAPON_SKILL_RATING_BONUS, GetCombatRatingBonus(CR_WEAPON_SKILL) + GetCombatRatingBonus(CR_WEAPON_SKILL_MAINHAND));
        end

        local speed, offhandSpeed = UnitAttackSpeed(unit);
        if (offhandSpeed) then
            if (offHandAttackMod == 0) then
                statFrame.offhandSkill = COMBAT_RATING_NAME1 .. " " .. offHandAttackBase;
            else
                local color = RED_FONT_COLOR_CODE;
                statFrame.offhandSkill = COMBAT_RATING_NAME1 .. " " .. (offHandAttackBase + offHandAttackMod) .. " (" .. offHandAttackBase .. color .. " " .. offHandAttackMod .. ")";
                if (offHandAttackMod > 0) then
                    color = GREEN_FONT_COLOR_CODE;
                    statFrame.offhandSkill = COMBAT_RATING_NAME1 .. " " .. (offHandAttackBase + offHandAttackMod) .. " (" .. offHandAttackBase .. color .. " +" .. offHandAttackMod ..
                                                 FONT_COLOR_CODE_CLOSE .. ")";
                end
            end

            total = GetCombatRating(CR_WEAPON_SKILL) + GetCombatRating(CR_WEAPON_SKILL_OFFHAND);
            statFrame.offhandRating = format(WEAPON_SKILL_RATING, total);
            if (total > 0) then
                statFrame.offhandRating = statFrame.offhandRating .. format(WEAPON_SKILL_RATING_BONUS, GetCombatRatingBonus(CR_WEAPON_SKILL) + GetCombatRatingBonus(CR_WEAPON_SKILL_OFFHAND));
            end
        else
            statFrame.offhandSkill = nil;
        end
    end

    function S:SetRangedAttack(statFrame, unit)
        if (not unit) then
            unit = "player";
        elseif (unit == "pet") then
            return;
        end

        local hasRelic = UnitHasRelicSlot(unit);
        local rangedAttackBase, rangedAttackMod = UnitRangedAttack(unit);
        getglobal(statFrame:GetName() .. "Label"):SetText(COMBAT_RATING_NAME1 .. ":");
        local text = getglobal(statFrame:GetName() .. "StatText");

        -- If no ranged texture then set stats to n/a
        local rangedTexture = GetInventoryItemTexture("player", 18);
        if (rangedTexture and not hasRelic) then
            PaperDollFrame.noRanged = nil;
        else
            text:SetText(NOT_APPLICABLE);
            PaperDollFrame.noRanged = 1;
            statFrame.tooltip = nil;
        end
        if (not rangedTexture or hasRelic) then
            return;
        end

        if (rangedAttackMod == 0) then
            text:SetText(rangedAttackBase);
            statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. COMBAT_RATING_NAME1 .. " " .. rangedAttackBase .. FONT_COLOR_CODE_CLOSE;
        else
            local color = RED_FONT_COLOR_CODE;
            if (rangedAttackMod > 0) then
                color = GREEN_FONT_COLOR_CODE;
                statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. COMBAT_RATING_NAME1 .. " " .. (rangedAttackBase + rangedAttackMod) .. " (" .. rangedAttackBase .. color .. " +" .. rangedAttackMod ..
                                        FONT_COLOR_CODE_CLOSE .. HIGHLIGHT_FONT_COLOR_CODE .. ")";
            else
                statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. COMBAT_RATING_NAME1 .. " " .. (rangedAttackBase + rangedAttackMod) .. " (" .. rangedAttackBase .. color .. " " .. rangedAttackMod ..
                                        FONT_COLOR_CODE_CLOSE .. HIGHLIGHT_FONT_COLOR_CODE .. ")";
            end
            text:SetText(color .. (rangedAttackBase + rangedAttackMod) .. FONT_COLOR_CODE_CLOSE);
        end
        local total = GetCombatRating(CR_WEAPON_SKILL) + GetCombatRating(CR_WEAPON_SKILL_RANGED);
        statFrame.tooltip2 = format(WEAPON_SKILL_RATING, total);
        if (total > 0) then
            statFrame.tooltip2 = statFrame.tooltip2 .. format(WEAPON_SKILL_RATING_BONUS, GetCombatRatingBonus(CR_WEAPON_SKILL) + GetCombatRatingBonus(CR_WEAPON_SKILL_RANGED));
        end
    end

    function S:SetRangedDamage(statFrame, unit)
        if (not unit) then
            unit = "player";
        elseif (unit == "pet") then
            return;
        end
        getglobal(statFrame:GetName() .. "Label"):SetText(DAMAGE_COLON);
        local text = getglobal(statFrame:GetName() .. "StatText");

        -- If no ranged attack then set to n/a
        local hasRelic = UnitHasRelicSlot(unit);
        local rangedTexture = GetInventoryItemTexture("player", 18);
        if (rangedTexture and not hasRelic) then
            PaperDollFrame.noRanged = nil;
        else
            text:SetText(NOT_APPLICABLE);
            PaperDollFrame.noRanged = 1;
            statFrame.damage = nil;
            return;
        end

        local rangedAttackSpeed, minDamage, maxDamage, physicalBonusPos, physicalBonusNeg, percent = UnitRangedDamage(unit);
        local displayMin = max(floor(minDamage), 1);
        local displayMax = max(ceil(maxDamage), 1);

        local baseDamage;
        local fullDamage;
        local totalBonus;
        local damagePerSecond;
        local tooltip;

        if (HasWandEquipped()) then
            baseDamage = (minDamage + maxDamage) * 0.5;
            fullDamage = baseDamage * percent;
            totalBonus = 0;
            damagePerSecond = (max(fullDamage, 1) / rangedAttackSpeed);
            tooltip = max(floor(minDamage), 1) .. " - " .. max(ceil(maxDamage), 1);
        else
            minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg;
            maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg;

            baseDamage = (minDamage + maxDamage) * 0.5;
            fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent;
            totalBonus = (fullDamage - baseDamage);
            if (rangedAttackSpeed == 0) then
                -- Egan's Blaster!!!
                damagePerSecond = math.huge;
            else
                damagePerSecond = (max(fullDamage, 1) / rangedAttackSpeed);
            end
            tooltip = max(floor(minDamage), 1) .. " - " .. max(ceil(maxDamage), 1);
        end

        if (totalBonus == 0) then
            if ((displayMin < 100) and (displayMax < 100)) then
                text:SetText(displayMin .. " - " .. displayMax);
            else
                text:SetText(displayMin .. "-" .. displayMax);
            end
        else
            local colorPos = "|cff20ff20";
            local colorNeg = "|cffff2020";
            local color;
            if (totalBonus > 0) then
                color = colorPos;
            else
                color = colorNeg;
            end
            if ((displayMin < 100) and (displayMax < 100)) then
                text:SetText(color .. displayMin .. " - " .. displayMax .. "|r");
            else
                text:SetText(color .. displayMin .. "-" .. displayMax .. "|r");
            end
            if (physicalBonusPos > 0) then
                tooltip = tooltip .. colorPos .. " +" .. physicalBonusPos .. "|r";
            end
            if (physicalBonusNeg < 0) then
                tooltip = tooltip .. colorNeg .. " " .. physicalBonusNeg .. "|r";
            end
            if (percent > 1) then
                tooltip = tooltip .. colorPos .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            elseif (percent < 1) then
                tooltip = tooltip .. colorNeg .. " x" .. floor(percent * 100 + 0.5) .. "%|r";
            end
            statFrame.tooltip = tooltip .. " " .. format(DPS_TEMPLATE, damagePerSecond);
        end
        statFrame.attackSpeed = rangedAttackSpeed;
        statFrame.damage = tooltip;
        statFrame.dps = damagePerSecond;
    end

    function S:SetRangedAttackSpeed(statFrame, unit)
        if (not unit) then
            unit = "player";
        elseif (unit == "pet") then
            return;
        end
        local text;
        -- If no ranged attack then set to n/a
        if (PaperDollFrame.noRanged) then
            text = NOT_APPLICABLE;
            statFrame.tooltip = nil;
        else
            text = UnitRangedDamage(unit);
            text = format("%.2f", text);
            statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. ATTACK_SPEED .. " " .. text .. FONT_COLOR_CODE_CLOSE;
        end
        S:SetLabelAndText(statFrame, WEAPON_SPEED, text);
        statFrame.tooltip2 = format(CR_HASTE_RATING_TOOLTIP, GetCombatRating(CR_HASTE_RANGED), GetCombatRatingBonus(CR_HASTE_RANGED));
    end

    function S:SetRangedAttackPower(statFrame, unit)
        if (not unit) then
            unit = "player";
        end
        getglobal(statFrame:GetName() .. "Label"):SetText(ATTACK_POWER_COLON);
        local text = getglobal(statFrame:GetName() .. "StatText");
        local base, posBuff, negBuff = UnitRangedAttackPower(unit);

        PaperDollFormatStat(RANGED_ATTACK_POWER, base, posBuff, negBuff, statFrame, text);
        local totalAP = base + posBuff + negBuff;
        statFrame.tooltip2 = format(RANGED_ATTACK_POWER_TOOLTIP, max((totalAP), 0) / ATTACK_POWER_MAGIC_NUMBER);
        local petAPBonus = S:ComputePetBonus("PET_BONUS_RAP_TO_AP", totalAP);
        if (petAPBonus > 0) then
            statFrame.tooltip2 = statFrame.tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_RANGED_ATTACK_POWER, math.floor(petAPBonus));
        end

        local petSpellDmgBonus = S:ComputePetBonus("PET_BONUS_RAP_TO_SPELLDMG", totalAP);
        if (petSpellDmgBonus > 0) then
            statFrame.tooltip2 = statFrame.tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_SPELLDAMAGE, math.floor(petSpellDmgBonus));
        end
    end

    function S:SetSpellBonusDamage(statFrame)
        getglobal(statFrame:GetName() .. "Label"):SetText(BONUS_DAMAGE .. ":");
        local text = getglobal(statFrame:GetName() .. "StatText");
        local holySchool = 2;
        -- Start at 2 to skip physical damage
        local minModifier = GetSpellBonusDamage(holySchool);
        statFrame.bonusDamage = {};
        statFrame.bonusDamage[holySchool] = minModifier;
        local bonusDamage;
        for i = (holySchool + 1), MAX_SPELL_SCHOOLS do
            bonusDamage = GetSpellBonusDamage(i);
            minModifier = min(minModifier, bonusDamage);
            statFrame.bonusDamage[i] = bonusDamage;
        end
        text:SetText(minModifier);
        statFrame.minModifier = minModifier;
    end

    function S:SetSpellCritChance(statFrame)
        getglobal(statFrame:GetName() .. "Label"):SetText(SPELL_CRIT_CHANCE .. ":");
        local text = getglobal(statFrame:GetName() .. "StatText");
        local holySchool = 2;
        -- Start at 2 to skip physical damage
        local minCrit = GetSpellCritChance(holySchool);
        statFrame.spellCrit = {};
        statFrame.spellCrit[holySchool] = minCrit;
        local spellCrit;
        for i = (holySchool + 1), MAX_SPELL_SCHOOLS do
            spellCrit = GetSpellCritChance(i);
            minCrit = min(minCrit, spellCrit);
            statFrame.spellCrit[i] = spellCrit;
        end
        -- Add agility contribution
        -- minCrit = minCrit + GetSpellCritChanceFromIntellect();
        minCrit = format("%.2f%%", minCrit);
        text:SetText(minCrit);
        statFrame.minCrit = minCrit;
    end

    function S:SetMeleeCritChance(statFrame)
        getglobal(statFrame:GetName() .. "Label"):SetText(MELEE_CRIT_CHANCE .. ":");
        local text = getglobal(statFrame:GetName() .. "StatText");
        local critChance = GetCritChance(); -- + GetCritChanceFromAgility();
        critChance = format("%.2f%%", critChance);
        text:SetText(critChance);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. MELEE_CRIT_CHANCE .. " " .. critChance .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(CR_CRIT_MELEE_TOOLTIP, GetCombatRating(CR_CRIT_MELEE), GetCombatRatingBonus(CR_CRIT_MELEE));
    end

    function S:SetRangedCritChance(statFrame)
        getglobal(statFrame:GetName() .. "Label"):SetText(RANGED_CRIT_CHANCE .. ":");
        local text = getglobal(statFrame:GetName() .. "StatText");
        local critChance = GetRangedCritChance(); -- + GetCritChanceFromAgility();
        critChance = format("%.2f%%", critChance);
        text:SetText(critChance);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. RANGED_CRIT_CHANCE .. " " .. critChance .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(CR_CRIT_RANGED_TOOLTIP, GetCombatRating(CR_CRIT_RANGED), GetCombatRatingBonus(CR_CRIT_RANGED));
    end

    function S:SetSpellBonusHealing(statFrame)
        getglobal(statFrame:GetName() .. "Label"):SetText(BONUS_HEALING .. ":");
        local text = getglobal(statFrame:GetName() .. "StatText");
        local bonusHealing = GetSpellBonusHealing();
        text:SetText(bonusHealing);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. BONUS_HEALING .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(BONUS_HEALING_TOOLTIP, bonusHealing);
    end

    function S:SetSpellHaste(statFrame)
        getglobal(statFrame:GetName() .. "Label"):SetText(SPELL_HASTE .. ":");
        local text = getglobal(statFrame:GetName() .. "StatText");
        text:SetText(GetCombatRating(CR_HASTE_SPELL));
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. SPELL_HASTE .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(SPELL_HASTE_TOOLTIP, GetCombatRatingBonus(CR_HASTE_SPELL));
    end

    function S:SetManaRegen(statFrame)
        getglobal(statFrame:GetName() .. "Label"):SetText(MANA_REGEN .. ":");
        local text = getglobal(statFrame:GetName() .. "StatText");
        if (not UnitHasMana("player")) then
            text:SetText(NOT_APPLICABLE);
            statFrame.tooltip = nil;
            return;
        end

        local base, casting = GetManaRegen();
        -- All mana regen stats are displayed as mana/5 sec.
        base = floor(base * 5.0);
        casting = floor(casting * 5.0);
        text:SetText(base);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. MANA_REGEN .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(MANA_REGEN_TOOLTIP, base, casting);
    end

    function S:SetExpertise(statFrame, unit)
        if (not unit) then
            unit = "player";
        end
        local expertise, offhandExpertise = GetExpertise();
        local speed, offhandSpeed = UnitAttackSpeed(unit);
        local text;
        if (offhandSpeed) then
            text = expertise .. " / " .. offhandExpertise;
        else
            text = expertise;
        end
        S:SetLabelAndText(statFrame, STAT_EXPERTISE, text);

        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. getglobal("COMBAT_RATING_NAME" .. CR_EXPERTISE) .. " " .. text .. FONT_COLOR_CODE_CLOSE;

        local expertisePercent, offhandExpertisePercent = GetExpertisePercent();
        expertisePercent = format("%.2f", expertisePercent);
        if (offhandSpeed) then
            offhandExpertisePercent = format("%.2f", offhandExpertisePercent);
            text = expertisePercent .. "% / " .. offhandExpertisePercent .. "%";
        else
            text = expertisePercent .. "%";
        end
        statFrame.tooltip2 = format(CR_EXPERTISE_TOOLTIP, text, GetCombatRating(CR_EXPERTISE), GetCombatRatingBonus(CR_EXPERTISE));
    end

    function S:CharacterSpellBonusDamage_OnEnter()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE .. BONUS_DAMAGE .. " " .. self.minModifier .. FONT_COLOR_CODE_CLOSE);
        for i = 2, MAX_SPELL_SCHOOLS do
            GameTooltip:AddDoubleLine(getglobal("DAMAGE_SCHOOL" .. i), self.bonusDamage[i], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                                      NORMAL_FONT_COLOR.b);
            GameTooltip:AddTexture("Interface\\PaperDollInfoFrame\\SpellSchoolIcon" .. i);
        end

        local petStr, damage;
        if (self.bonusDamage[6] > self.bonusDamage[3]) then
            petStr = PET_BONUS_TOOLTIP_WARLOCK_SPELLDMG_SHADOW;
            damage = self.bonusDamage[6];
        else
            petStr = PET_BONUS_TOOLTIP_WARLOCK_SPELLDMG_FIRE;
            damage = self.bonusDamage[3];
        end

        local petBonusAP = S:ComputePetBonus("PET_BONUS_SPELLDMG_TO_AP", damage);
        local petBonusDmg = S:ComputePetBonus("PET_BONUS_SPELLDMG_TO_SPELLDMG", damage);
        if (petBonusAP > 0 or petBonusDmg > 0) then
            GameTooltip:AddLine("\n" .. format(petStr, petBonusAP, petBonusDmg), nil, nil, nil, 1);
        end
        GameTooltip:Show();
    end

    function S:CharacterSpellCritChance_OnEnter()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE .. COMBAT_RATING_NAME11 .. " " .. GetCombatRating(11) .. FONT_COLOR_CODE_CLOSE);
        local spellCrit;
        for i = 2, MAX_SPELL_SCHOOLS do
            spellCrit = format("%.2f", self.spellCrit[i]);
            spellCrit = spellCrit .. "%";
            GameTooltip:AddDoubleLine(getglobal("DAMAGE_SCHOOL" .. i), spellCrit, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                                      NORMAL_FONT_COLOR.b);
            GameTooltip:AddTexture("Interface\\PaperDollInfoFrame\\SpellSchoolIcon" .. i);
        end
        GameTooltip:Show();
    end

    function S:CharacterDamageFrame_OnEnter()
        -- Main hand weapon
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(INVTYPE_WEAPONMAINHAND, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
        GameTooltip:AddDoubleLine(ATTACK_SPEED_COLON, format("%.2F", self.attackSpeed), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                                  NORMAL_FONT_COLOR.b);
        GameTooltip:AddDoubleLine(DAMAGE_COLON, self.damage, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:AddDoubleLine(DAMAGE_PER_SECOND, format("%.1F", self.dps), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                                  NORMAL_FONT_COLOR.b);
        -- Check for offhand weapon
        if (self.offhandAttackSpeed) then
            GameTooltip:AddLine(" "); -- Blank line.
            GameTooltip:AddLine(INVTYPE_WEAPONOFFHAND, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
            GameTooltip:AddDoubleLine(ATTACK_SPEED_COLON, format("%.2F", self.offhandAttackSpeed), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r,
                                      NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
            GameTooltip:AddDoubleLine(DAMAGE_COLON, self.offhandDamage, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
            GameTooltip:AddDoubleLine(DAMAGE_PER_SECOND, format("%.1F", self.offhandDps), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                                      NORMAL_FONT_COLOR.b);
        end
        GameTooltip:Show();
    end

    function S:CharacterRangedDamageFrame_OnEnter(self)
        if (not self.damage) then
            return;
        end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(INVTYPE_RANGED, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
        GameTooltip:AddDoubleLine(ATTACK_SPEED_COLON, format("%.2F", self.attackSpeed), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                                  NORMAL_FONT_COLOR.b);
        GameTooltip:AddDoubleLine(DAMAGE_COLON, self.damage, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:AddDoubleLine(DAMAGE_PER_SECOND, format("%.1F", self.dps), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                                  NORMAL_FONT_COLOR.b);
        GameTooltip:Show();
    end

    function S:ComputePetBonus(stat, value)
        local temp, unitClass = UnitClass("player");
        unitClass = strupper(unitClass);
        if (unitClass == "WARLOCK") then
            if (WARLOCK_PET_BONUS[stat]) then
                return value * WARLOCK_PET_BONUS[stat];
            else
                return 0;
            end
        elseif (unitClass == "HUNTER") then
            if (HUNTER_PET_BONUS[stat]) then
                return value * HUNTER_PET_BONUS[stat];
            else
                return 0;
            end
        end

        return 0;
    end

    function S:GetArmorReduction(armor, attackerLevel)
        local levelModifier = attackerLevel;
        if (levelModifier > 59) then
            levelModifier = levelModifier + (4.5 * (levelModifier - 59));
        end
        local temp = 0.1 * armor / (8.5 * levelModifier + 40);
        temp = temp / (1 + temp);

        if (temp > 0.75) then
            return 75;
        end

        if (temp < 0) then
            return 0;
        end

        return format("%.2f", (temp * 100));
    end

    function S:PaperDollStatTooltip()
        if (not self.tooltip) then
            return;
        end

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(self.tooltip, 1.0, 1.0, 1.0);
        if (self.tooltip2) then
            GameTooltip:AddLine(self.tooltip2, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
        end
        GameTooltip:Show();
    end
end
