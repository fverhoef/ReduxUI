local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins
local CS = R.Modules.CharacterStats

S.attributeIndex = {["STRENGTH"] = 1, ["AGILITY"] = 2, ["STAMINA"] = 3, ["INTELLECT"] = 4, ["SPIRIT"] = 5}

function S:DressUpTexturePath(raceFileName)
    if not raceFileName then
        raceFileName = "Orc";
    end

    return "Interface\\DressUpFrame\\DressUpBackground-" .. raceFileName;
end

function S:StylePaperDollFrame()
    -- resize model
    CharacterModelFrame:SetSize(231, 320)
    CharacterModelFrame:SetFrameLevel(10)

    -- add model background
    local race, raceFileName = UnitRace("player");
    local texturePath = S:DressUpTexturePath(raceFileName)

    CharacterModelFrame.Background = CreateFrame("Frame", addonName .. "CharacterModelFrameBackground", CharacterModelFrame)
    CharacterModelFrame.Background:SetSize(231, 320)
    CharacterModelFrame.Background:SetAllPoints()
    CharacterModelFrame.Background:SetFrameLevel(5)
    CharacterModelFrame.Background:SetScale(0.90)

    CharacterModelFrame.Background.TopLeft =
        CharacterModelFrame.Background:CreateTexture("$parentBackgroundTopLeft", "BACKGROUND")
    CharacterModelFrame.Background.TopLeft:SetTexture(texturePath .. 1)
    CharacterModelFrame.Background.TopLeft:SetSize(256, 255)
    CharacterModelFrame.Background.TopLeft:SetPoint("TOPLEFT", 0, 0)
    CharacterModelFrame.Background.TopLeft:SetDesaturated(1)

    CharacterModelFrame.Background.TopRight = CharacterModelFrame.Background:CreateTexture("$parentBackgroundTopRight",
                                                                                           "BACKGROUND")
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

    CharacterModelFrame.Background.BottomRight =
        CharacterModelFrame.Background:CreateTexture("$parentBackgroundBot", "BACKGROUND")
    CharacterModelFrame.Background.BottomRight:SetTexture(texturePath .. 4)
    CharacterModelFrame.Background.BottomRight:SetSize(62, 128)
    CharacterModelFrame.Background.BottomRight:SetPoint("TOPLEFT", CharacterModelFrame.Background.TopLeft, "BOTTOMRIGHT")
    CharacterModelFrame.Background.BottomRight:SetDesaturated(1)
    CharacterModelFrame.Background.BottomRight:Hide()

    -- make sure resistances are on top
    CharacterResistanceFrame:SetFrameLevel(11)
    PaperDollItemsFrame:SetFrameLevel(11)

    -- hide default attributes frame
    CharacterAttributesFrame:Hide()

    -- create new stats pane
    CharacterFrame.originalWidth = CharacterFrame:GetWidth()
    PaperDollFrame.CharacterStatsPane = S:CreateCharacterStatsPane()
    PaperDollFrame.CharacterStatsPane.ItemLevel = S:CreateCharacterStatsPane_ItemLevel(PaperDollFrame.CharacterStatsPane)
    PaperDollFrame.CharacterStatsPane.Attributes = S:CreateCharacterStatsPane_Attributes(PaperDollFrame.CharacterStatsPane)
    PaperDollFrame.CharacterStatsPane.Enhancements = S:CreateCharacterStatsPane_Enhancements(PaperDollFrame.CharacterStatsPane)

    -- adjust frame width
    S:SecureHook("CharacterFrame_ShowSubFrame", function()
        if PaperDollFrame:IsShown() then
            CharacterFrame:SetWidth(CharacterFrame.originalWidth + PaperDollFrame.CharacterStatsPane:GetWidth() - 71)
            UIPanelWindows["CharacterFrame"].width = CharacterFrame:GetWidth() - 30
        else
            CharacterFrame:SetWidth(CharacterFrame.originalWidth)
            UIPanelWindows["CharacterFrame"].width = CharacterFrame:GetWidth()
        end
    end)

    -- move close button when switching between tabs, and show/hide level/guild texts
    S:SecureHook("ToggleCharacter", function()
        if PaperDollFrame:IsShown() then
            CharacterFrameCloseButton:SetPoint("CENTER", CharacterFrame, "TOPRIGHT", -46, -25)
            CharacterLevelText:Show()
            CharacterGuildText:Show()
        else
            CharacterFrameCloseButton:SetPoint("CENTER", CharacterFrame, "TOPRIGHT", -44, -25)
            CharacterLevelText:Hide()
            CharacterGuildText:Hide()
        end
        if HonorFrame:IsShown() then
            HonorLevelText:Show()
            HonorGuildText:Show()
        else
            HonorLevelText:Hide()
            HonorGuildText:Hide()
        end
    end)

    -- reparent level/guild texts
    CharacterLevelText:SetParent(CharacterNameFrame)
    CharacterLevelText:ClearAllPoints()
    CharacterLevelText:SetPoint("TOP", CharacterNameFrame, "BOTTOM", 0, -10)
    CharacterGuildText:SetParent(CharacterNameFrame)

    -- update name/level/guild texts
    S:SecureHook("PaperDollFrame_SetLevel", function()
        local class = R:UnlocalizedClassName(UnitClass("player"))
        local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), R:Hex(1, 1, 1) .. UnitRace("player") .. "|r",
                                            R:Hex(classColor) .. UnitClass("player") .. "|r")
    end)
    S:SecureHook("PaperDollFrame_SetGuild", function()
        local guildName, title, rank = GetGuildInfo("player")
        if guildName then
            CharacterGuildText:SetFormattedText(GUILD_TITLE_TEMPLATE, title, R:Hex(S.config.colors.guild) .. guildName .. "|r")
        end
    end)
end

function S:CreateCharacterStatsPane()
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPane", PaperDollFrame)
    frame:SetSize(150 + 128, 512)
    frame:SetPoint("TOPRIGHT", PaperDollFrame, "TOPRIGHT", 0, -1)

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
    frame:SetSize(198, 71)
    frame:SetPoint("TOPLEFT", parent.Background.Inset, "TOPLEFT", 0, 0)

    frame.Header = CreateFrame("Frame", addonName .. "CharacterStatsPaneItemLevelLabel", parent)
    frame.Header:SetSize(198, 42)
    frame.Header:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    frame.Header.Background = frame.Header:CreateTexture("BACKGROUND")
    frame.Header.Background:SetAllPoints()
    frame.Header.Background:SetTexture([[Interface\PaperDollInfoFrame\PaperDollInfoPart1]])
    frame.Header.Background:SetTexCoord(0 / 1024, 199 / 1024, 714 / 1024, 754 / 1024)
    frame.Header.Text = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Header.Text:SetAllPoints()
    frame.Header.Text:SetJustifyH("CENTER")
    frame.Header.Text:SetJustifyV("CENTER")
    frame.Header.Text:SetShadowOffset(1, -1)
    frame.Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
    frame.Header.Text:SetText(STAT_AVERAGE_ITEM_LEVEL)

    frame.Value = CreateFrame("Frame", addonName .. "CharacterStatsPaneItemLevelLabel", parent)
    frame.Value:SetSize(145, 27)
    frame.Value:SetPoint("TOP", frame.Header, "BOTTOM", 0, 0)
    frame.Value.Background = frame.Value:CreateTexture("BACKGROUND")
    frame.Value.Background:SetAllPoints()
    frame.Value.Background:SetTexture([[Interface\PaperDollInfoFrame\PaperDollInfoPart1]])
    frame.Value.Background:SetTexCoord(10 / 1024, 155 / 1024, 758 / 1024, 784 / 1024)
    frame.Value.Background:SetAlpha(0.3)
    frame.Value.Text = frame.Value:CreateFontString(nil, "OVERLAY")
    frame.Value.Text:SetAllPoints()
    frame.Value.Text:SetJustifyH("CENTER")
    frame.Value.Text:SetJustifyV("CENTER")
    frame.Value.Text:SetShadowOffset(1, -1)
    frame.Value.Text:SetFont(STANDARD_TEXT_FONT, 15)

    return frame
end

function S:CreateCharacterStatsPane_Attributes(parent)
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPaneAttributes", parent)
    frame:SetSize(198, 71)
    frame:SetPoint("TOP", parent.ItemLevel.Value, "BOTTOM", 0, 0)

    frame.Header = CreateFrame("Frame", addonName .. "CharacterStatsPaneAttributesHeader", parent)
    frame.Header:SetSize(198, 42)
    frame.Header:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    frame.Header.Background = frame.Header:CreateTexture("BACKGROUND")
    frame.Header.Background:SetAllPoints()
    frame.Header.Background:SetTexture([[Interface\PaperDollInfoFrame\PaperDollInfoPart1]])
    frame.Header.Background:SetTexCoord(0 / 1024, 199 / 1024, 714 / 1024, 754 / 1024)
    frame.Header.Text = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Header.Text:SetAllPoints()
    frame.Header.Text:SetJustifyH("CENTER")
    frame.Header.Text:SetJustifyV("CENTER")
    frame.Header.Text:SetShadowOffset(1, -1)
    frame.Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
    frame.Header.Text:SetText(STAT_CATEGORY_ATTRIBUTES)

    S:CreateCharacterStatsPane_AttributeEntry("Strength", frame, parent, false, {"TOP", frame.Header, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_AttributeEntry("Agility", frame, parent, true, {"TOP", frame.Strength, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_AttributeEntry("Stamina", frame, parent, false, {"TOP", frame.Agility, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_AttributeEntry("Intellect", frame, parent, true, {"TOP", frame.Stamina, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_AttributeEntry("Spirit", frame, parent, false, {"TOP", frame.Intellect, "BOTTOM", 0, 0})

    return frame
end

function S:CreateCharacterStatsPane_AttributeEntry(attribute, frame, parent, showBackground, point)
    local entry = CreateFrame("Frame", addonName .. "CharacterStatsPaneAttributeLabel" .. attribute, parent)
    entry.attributeName = strupper(attribute)
    entry.attributeIndex = S.attributeIndex[entry.attributeName]
    entry:SetSize(165, 17)
    entry:SetPoint(unpack(point))
    entry.Background = entry:CreateTexture("BACKGROUND")
    entry.Background:SetAllPoints()
    entry.Background:SetTexture([[Interface\PaperDollInfoFrame\PaperDollInfoPart1]])
    entry.Background:SetTexCoord(0 / 1024, 160 / 1024, 789 / 1024, 805 / 1024)
    entry.Background:SetAlpha(showBackground and 0.3 or 0)
    entry.Label = entry:CreateFontString(nil, "OVERLAY")
    entry.Label:SetAllPoints()
    entry.Label:SetJustifyH("LEFT")
    entry.Label:SetShadowOffset(1, -1)
    entry.Label:SetFontObject(GameFontNormalSmall)
    entry.Label:SetFont(STANDARD_TEXT_FONT, 11)
    entry.Label:SetText(_G["SPELL_STAT" .. entry.attributeIndex .. "_NAME"] .. ":")
    entry.Label:SetTextColor(unpack(S.config.colors.normalFont))
    entry.Value = entry:CreateFontString(nil, "OVERLAY")
    entry.Value:SetAllPoints()
    entry.Value:SetJustifyH("RIGHT")
    entry.Value:SetShadowOffset(1, -1)
    entry.Value:SetFont(STANDARD_TEXT_FONT, 11)

    entry:SetScript("OnEnter", function()
        if entry.tooltip then
            GameTooltip:SetOwner(entry, "ANCHOR_RIGHT")
            GameTooltip:SetText(entry.tooltip, unpack(S.config.colors.highlightFont))
            if (entry.tooltip2) then
                GameTooltip:AddLine(entry.tooltip2, S.config.colors.normalFont[1], S.config.colors.normalFont[2],
                                    S.config.colors.normalFont[3], true)
            end
            GameTooltip:Show()
        end
    end)
    entry:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    frame[attribute] = entry
    return entry
end

function S:CreateCharacterStatsPane_Enhancements(parent)
    local frame = CreateFrame("Frame", addonName .. "CharacterStatsPaneEnhancements", parent)
    frame:SetSize(198, 71)
    frame:SetPoint("TOP", PaperDollFrame.CharacterStatsPane.Attributes.Spirit, "BOTTOM", 0, 0)

    frame.Header = CreateFrame("Frame", addonName .. "CharacterStatsPaneEnhancementsHeader", parent)
    frame.Header:SetSize(198, 42)
    frame.Header:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    frame.Header.Background = frame.Header:CreateTexture("BACKGROUND")
    frame.Header.Background:SetAllPoints()
    frame.Header.Background:SetTexture([[Interface\PaperDollInfoFrame\PaperDollInfoPart1]])
    frame.Header.Background:SetTexCoord(0 / 1024, 199 / 1024, 714 / 1024, 754 / 1024)
    frame.Header.Text = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Header.Text:SetAllPoints()
    frame.Header.Text:SetJustifyH("CENTER")
    frame.Header.Text:SetJustifyV("CENTER")
    frame.Header.Text:SetShadowOffset(1, -1)
    frame.Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
    frame.Header.Text:SetText(STAT_CATEGORY_ENHANCEMENTS)
    frame.Header.ButtonPrevious = CreateFrame("Button", addonName .. "CharacterStatsPaneEnhancementsPrevious", frame.Header)
    frame.Header.ButtonPrevious:SetNormalTexture(R.media.textures.arrowDown_Up)
    frame.Header.ButtonPrevious:SetPushedTexture(R.media.textures.arrowDown_Down)
    frame.Header.ButtonPrevious:SetSize(16, 16)
    frame.Header.ButtonPrevious:SetPoint("LEFT", frame.Header, "LEFT", 25, -6)
    frame.Header.ButtonPrevious:SetScript("OnEnter", function()
        GameTooltip:SetOwner(frame.Header.ButtonPrevious, "ANCHOR_TOPLEFT")
        GameTooltip:SetText("Previous Category") -- TODO: Localization
        GameTooltip:Show()
    end)
    frame.Header.ButtonPrevious:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    frame.Header.ButtonPrevious:SetScript("OnClick", function()
        frame.PreviousCategory()
    end)
    frame.Header.ButtonNext = CreateFrame("Button", addonName .. "CharacterStatsPaneEnhancementsNext", frame.Header)
    frame.Header.ButtonNext:SetNormalTexture(R.media.textures.arrowUp_Up)
    frame.Header.ButtonNext:SetPushedTexture(R.media.textures.arrowUp_Down)
    frame.Header.ButtonNext:SetSize(16, 16)
    frame.Header.ButtonNext:SetPoint("RIGHT", frame.Header, "RIGHT", -25, 0)
    frame.Header.ButtonNext:SetScript("OnEnter", function()
        GameTooltip:SetOwner(frame.Header.ButtonNext, "ANCHOR_TOPLEFT")
        GameTooltip:SetText("Next Category") -- TODO: Localization
        GameTooltip:Show()
    end)
    frame.Header.ButtonNext:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    frame.Header.ButtonNext:SetScript("OnClick", function()
        frame.NextCategory()
    end)

    frame.Melee = CreateFrame("Frame", addonName .. "CharacterStatsPaneMelee", parent)
    frame.Melee:SetSize(198, 85)
    frame.Melee:SetPoint("TOP", frame.Header, "BOTTOM", 0, 0)
    frame.Melee.categoryName = PLAYERSTAT_MELEE_COMBAT
    S:CreateCharacterStatsPane_EnhancementEntry("Damage", DAMAGE .. ":", frame.Melee, false, {"TOP", frame.Melee, "TOP", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("AttackPower", MELEE_ATTACK_POWER .. ":", frame.Melee, true,
                                                 {"TOP", frame.Melee.Damage, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("AttackRating", ATTACK_TOOLTIP .. ":", frame.Melee, false,
                                                 {"TOP", frame.Melee.AttackPower, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("Crit", STAT_CRITICAL_STRIKE .. ":", frame.Melee, true,
                                                 {"TOP", frame.Melee.AttackRating, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("Hit", STAT_HIT_CHANCE .. ":", frame.Melee, false,
                                                 {"TOP", frame.Melee.Crit, "BOTTOM", 0, 0})

    frame.Ranged = CreateFrame("Frame", addonName .. "CharacterStatsPaneRanged", parent)
    frame.Ranged:SetSize(198, 85)
    frame.Ranged:SetPoint("TOP", frame.Header, "BOTTOM", 0, 0)
    frame.Ranged.categoryName = PLAYERSTAT_RANGED_COMBAT
    S:CreateCharacterStatsPane_EnhancementEntry("Damage", DAMAGE .. ":", frame.Ranged, false, {"TOP", frame.Ranged, "TOP", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("AttackPower", RANGED_ATTACK_POWER .. ":", frame.Ranged, true,
                                                 {"TOP", frame.Ranged.Damage, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("AttackRating", ATTACK_TOOLTIP .. ":", frame.Ranged, false,
                                                 {"TOP", frame.Ranged.AttackPower, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("Crit", STAT_CRITICAL_STRIKE .. ":", frame.Ranged, true,
                                                 {"TOP", frame.Ranged.AttackRating, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("Hit", STAT_HIT_CHANCE .. ":", frame.Ranged, false,
                                                 {"TOP", frame.Ranged.Crit, "BOTTOM", 0, 0})

    frame.Magic = CreateFrame("Frame", addonName .. "CharacterStatsPaneMagic", parent)
    frame.Magic:SetSize(198, 85)
    frame.Magic:SetPoint("TOP", frame.Header, "BOTTOM", 0, 0)
    frame.Magic.categoryName = PLAYERSTAT_SPELL_COMBAT
    S:CreateCharacterStatsPane_EnhancementEntry("HealingPower", STAT_SPELLHEALING .. ":", frame.Magic, false,
                                                 {"TOP", frame.Magic, "TOP", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("SpellPower", STAT_SPELLPOWER .. ":", frame.Magic, true,
                                                 {"TOP", frame.Magic.HealingPower, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("SpellCrit", STAT_CRITICAL_STRIKE .. ":", frame.Magic, false,
                                                 {"TOP", frame.Magic.SpellPower, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("SpellHit", STAT_HIT_CHANCE .. ":", frame.Magic, true,
                                                 {"TOP", frame.Magic.SpellCrit, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("ManaRegen", MANA_REGEN .. ":", frame.Magic, false,
                                                 {"TOP", frame.Magic.SpellHit, "BOTTOM", 0, 0})

    frame.Defenses = CreateFrame("Frame", addonName .. "CharacterStatsPaneDefense", parent)
    frame.Defenses:SetSize(198, 85)
    frame.Defenses:SetPoint("TOP", frame.Header, "BOTTOM", 0, 0)
    frame.Defenses.categoryName = PLAYERSTAT_DEFENSES
    S:CreateCharacterStatsPane_EnhancementEntry("Armor", STAT_ARMOR .. ":", frame.Defenses, false,
                                                 {"TOP", frame.Defenses, "TOP", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("Dodge", STAT_DODGE .. ":", frame.Defenses, true,
                                                 {"TOP", frame.Defenses.Armor, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("Parry", STAT_PARRY .. ":", frame.Defenses, false,
                                                 {"TOP", frame.Defenses.Dodge, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("Block", STAT_BLOCK .. ":", frame.Defenses, true,
                                                 {"TOP", frame.Defenses.Parry, "BOTTOM", 0, 0})
    S:CreateCharacterStatsPane_EnhancementEntry("Defense", DEFENSE .. ":", frame.Defenses, false,
                                                 {"TOP", frame.Defenses.Block, "BOTTOM", 0, 0})

    frame.Categories = {frame.Melee, frame.Ranged, frame.Magic, frame.Defenses}
    frame.CurrentCategory = S.config.enhancementIndex -- TODO: store in cache
    frame.UpdateCategoryVisibility = function()
        for i, category in next, frame.Categories do
            if i == frame.CurrentCategory then
                category:Show()
                frame.Header.Text:SetText(category.categoryName)
            else
                category:Hide()
            end
        end
        S.config.enhancementIndex = frame.CurrentCategory
    end
    frame.PreviousCategory = function()
        frame.CurrentCategory = frame.CurrentCategory - 1
        if frame.CurrentCategory < 1 then
            frame.CurrentCategory = #frame.Categories
        end
        frame.UpdateCategoryVisibility()
    end
    frame.NextCategory = function()
        frame.CurrentCategory = frame.CurrentCategory + 1
        if frame.CurrentCategory > #frame.Categories then
            frame.CurrentCategory = 1
        end
        frame.UpdateCategoryVisibility()
    end
    frame.UpdateCategoryVisibility()

    return frame
end

function S:CreateCharacterStatsPane_EnhancementEntry(enhancement, label, frame, showBackground, point)
    local entry = CreateFrame("Frame", addonName .. "CharacterStatsPaneEnhancementLabel" .. enhancement, frame)
    entry:SetSize(165, 17)
    entry:SetPoint(unpack(point))
    if showBackground then
        entry.Background = entry:CreateTexture("BACKGROUND")
        entry.Background:SetAllPoints()
        entry.Background:SetTexture([[Interface\PaperDollInfoFrame\PaperDollInfoPart1]])
        entry.Background:SetTexCoord(0 / 1024, 160 / 1024, 789 / 1024, 805 / 1024)
        entry.Background:SetAlpha(0.3)
    end
    entry.Label = entry:CreateFontString(nil, "OVERLAY")
    entry.Label:SetAllPoints()
    entry.Label:SetJustifyH("LEFT")
    entry.Label:SetShadowOffset(1, -1)
    entry.Label:SetFontObject(GameFontNormalSmall)
    entry.Label:SetFont(STANDARD_TEXT_FONT, 11)
    entry.Label:SetText(label)
    entry.Label:SetTextColor(unpack(S.config.colors.normalFont))
    entry.Value = entry:CreateFontString(nil, "OVERLAY")
    entry.Value:SetAllPoints()
    entry.Value:SetJustifyH("RIGHT")
    entry.Value:SetShadowOffset(1, -1)
    entry.Value:SetFont(STANDARD_TEXT_FONT, 11)

    entry:SetScript("OnEnter", function()
        if entry.tooltip then
            GameTooltip:SetOwner(entry, "ANCHOR_RIGHT")
            GameTooltip:SetText(entry.tooltip, unpack(S.config.colors.highlightFont))
            for i = 2, 20 do
                local line = entry["tooltip" .. i]
                if (line) then
                    if type(line) == "table" then
                        local left, right = line.left, line.right
                        local leftText, rightText, leftColor, rightColor
                        if type(left) == "table" and type(right) == "table" then
                            leftText = left.text
                            leftColor = left.color
                            rightText = right.text
                            rightColor = right.color
                        elseif type(left) == "table" and type(right) == "string" then
                            leftText = left.text
                            leftColor = left.color
                            rightText = right
                            rightColor = S.config.colors.normalFont
                        elseif type(left) == "string" and type(right) == "table" then
                            leftText = left
                            leftColor = S.config.colors.normalFont
                            rightText = right.text
                            rightColor = right.color
                        else
                            leftText = left
                            leftColor = S.config.colors.normalFont
                            rightText = right
                            rightColor = S.config.colors.normalFont
                        end
                        GameTooltip:AddDoubleLine(leftText, rightText, leftColor[1], leftColor[2], leftColor[3], rightColor[1],
                                                  rightColor[2], rightColor[3])
                    else
                        GameTooltip:AddLine(line, S.config.colors.normalFont[1], S.config.colors.normalFont[2],
                                            S.config.colors.normalFont[3], true)
                    end
                end
            end
            GameTooltip:Show()
        end
    end)
    entry:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    frame[enhancement] = entry
    return entry
end

function S:FormatStatTooltip(name, stat, posBuff, negBuff)
    local tooltip = R:Hex(S.config.colors.highlightFont) .. name .. " "

    if (posBuff == 0 and negBuff == 0) then
        tooltip = tooltip .. stat .. FONT_COLOR_CODE_CLOSE
    else
        tooltip = tooltip .. stat
        if (posBuff > 0 or negBuff < 0) then
            tooltip = tooltip .. " (" .. (stat - posBuff - negBuff) .. FONT_COLOR_CODE_CLOSE
        end
        if (posBuff > 0) then
            tooltip = tooltip .. FONT_COLOR_CODE_CLOSE .. R:Hex(S.config.colors.greenFont) .. "+" .. posBuff ..
                          FONT_COLOR_CODE_CLOSE
        end
        if (negBuff < 0) then
            tooltip = tooltip .. R:Hex(S.config.colors.redFont) .. " " .. negBuff .. FONT_COLOR_CODE_CLOSE
        end
        if (posBuff > 0 or negBuff < 0) then
            tooltip = tooltip .. R:Hex(S.config.colors.highlightFont) .. ")" .. FONT_COLOR_CODE_CLOSE
        end
    end

    return tooltip
end

function S:UpdateAttribute(entry, attribute)
    entry.Value:SetText(attribute.stat)
    local effectiveBuff = attribute.posBuff + attribute.negBuff
    if effectiveBuff == 0 then
        entry.Value:SetTextColor(unpack(S.config.colors.highlightFont))
    elseif effectiveBuff > 0 then
        entry.Value:SetTextColor(unpack(S.config.colors.greenFont))
    elseif effectiveBuff < 0 then
        entry.Value:SetTextColor(unpack(S.config.colors.redFont))
    end

    if entry.attributeIndex then
        local tooltip = S:FormatStatTooltip(_G["SPELL_STAT" .. entry.attributeIndex .. "_NAME"], attribute.stat,
                                             attribute.posBuff, attribute.negBuff)

        -- set class specific tooltip for that stat
        local tooltip2 = _G[CS.class .. "_" .. entry.attributeName .. "_TOOLTIP"]
        if (not tooltip2) then
            tooltip2 = _G["DEFAULT_" .. entry.attributeName .. "_TOOLTIP"]
        end

        entry.tooltip = tooltip
        entry.tooltip2 = tooltip2
    end
end

function S:UpdateDamage(entry, damage, mainTooltip)
    local displayMin = math.max(math.floor(damage.minDamage), 1)
    local displayMax = math.max(math.ceil(damage.maxDamage), 1)

    local minDamage = (damage.minDamage / damage.percent) - damage.bonusPos - damage.bonusNeg
    local maxDamage = (damage.maxDamage / damage.percent) - damage.bonusPos - damage.bonusNeg

    local baseDamage = (minDamage + maxDamage) / 2
    local fullDamage = (baseDamage + damage.bonusPos + damage.bonusNeg) * damage.percent
    local totalBonus = (fullDamage - baseDamage)
    local damagePerSecond = (math.max(fullDamage, 1) / (damage.speed or damage.mainhandSpeed))
    local damageTooltip = math.max(math.floor(minDamage), 1) .. " - " .. math.max(math.ceil(maxDamage), 1)

    -- epsilon check
    if (totalBonus < 0.1 and totalBonus > -0.1) then
        totalBonus = 0.0
    end

    local colorPos = R:Hex(S.config.colors.greenFont)
    local colorNeg = R:Hex(S.config.colors.redFont)

    local damageText
    -- NOTE: wands don't gain damage modifiers (bug in default UI)
    if CS.hasWand then
        if (minDamage < 100) and (maxDamage < 100) then
            damageText = math.floor(minDamage) .. " - " .. math.floor(maxDamage)
        else
            damageText = math.floor(minDamage) .. "-" .. math.floor(maxDamage)
        end
    elseif (totalBonus == 0) then
        if (displayMin < 100) and (displayMax < 100) then
            damageText = displayMin .. " - " .. displayMax
        else
            damageText = displayMin .. "-" .. displayMax
        end
    else
        -- set bonus color and display
        local color
        if (totalBonus > 0) then
            color = colorPos
        else
            color = colorNeg
        end
        if ((displayMin < 100) and (displayMax < 100)) then
            damageText = color .. displayMin .. " - " .. displayMax .. FONT_COLOR_CODE_CLOSE
        else
            damageText = color .. displayMin .. "-" .. displayMax .. FONT_COLOR_CODE_CLOSE
        end
        if (damage.bonusPos > 0) then
            damageTooltip = damageTooltip .. colorPos .. " +" .. damage.bonusPos .. FONT_COLOR_CODE_CLOSE
        end
        if (damage.bonusNeg < 0) then
            damageTooltip = damageTooltip .. colorNeg .. " " .. damage.bonusNeg .. FONT_COLOR_CODE_CLOSE
        end
        if (damage.percent > 1) then
            damageTooltip = damageTooltip .. colorPos .. " x" .. math.floor(damage.percent * 100 + 0.5) .. "%" ..
                                FONT_COLOR_CODE_CLOSE
        elseif (damage.percent < 1) then
            damageTooltip = damageTooltip .. colorNeg .. " x" .. math.floor(damage.percent * 100 + 0.5) .. "%" ..
                                FONT_COLOR_CODE_CLOSE
        end
    end

    entry.Value:SetText(damageText)
    entry.tooltip = mainTooltip
    entry.tooltip2 = {
        left = {text = ATTACK_SPEED_COLON, color = S.config.colors.normalFont},
        right = {text = string.format("%.2f", damage.speed or damage.mainhandSpeed), color = S.config.colors.highlightFont}
    }
    entry.tooltip3 = {
        left = {text = DAMAGE_COLON, color = S.config.colors.normalFont},
        right = {text = damageTooltip, color = S.config.colors.highlightFont}
    }
    entry.tooltip4 = {
        left = {text = DAMAGE_PER_SECOND, color = S.config.colors.normalFont},
        right = {text = string.format("%.1f", damagePerSecond), color = S.config.colors.highlightFont}
    }
    -- entry.tooltip6 = {left = {text = ATTACK_TOOLTIP .. ":", color = S.config.colors.normalFont}, right = {text = attackRating or 0, color = S.config.colors.highlightFont}}
end

function S:UpdateMeleeDamage(entry, melee)
    S:UpdateDamage(entry, melee, INVTYPE_WEAPONMAINHAND)

    if melee.offhandSpeed then
        local minOffHandDamage = (melee.minOffHandDamage / melee.percent) - melee.bonusPos - melee.bonusNeg
        local maxOffHandDamage = (melee.maxOffHandDamage / melee.percent) - melee.bonusPos - melee.bonusNeg

        local offhandBaseDamage = (minOffHandDamage + maxOffHandDamage) * 0.5
        local offhandFullDamage = (offhandBaseDamage + melee.bonusPos + physicalBonusNeg) * percent
        local offhandDamagePerSecond = (math.max(offhandFullDamage, 1) / melee.offhandSpeed)
        local offhandDamageTooltip = math.max(math.floor(minOffHandDamage), 1) .. " - " ..
                                         math.max(math.ceil(maxOffHandDamage), 1)
        if (melee.bonusPos > 0) then
            offhandDamageTooltip = offhandDamageTooltip .. colorPos .. " +" .. melee.bonusPos .. FONT_COLOR_CODE_CLOSE
        end
        if (melee.bonusNeg < 0) then
            offhandDamageTooltip = offhandDamageTooltip .. colorNeg .. " " .. melee.bonusNeg .. FONT_COLOR_CODE_CLOSE
        end
        if (percent > 1) then
            offhandDamageTooltip = offhandDamageTooltip .. colorPos .. " x" .. math.floor(melee.percent * 100 + 0.5) .. "%" ..
                                       FONT_COLOR_CODE_CLOSE
        elseif (percent < 1) then
            offhandDamageTooltip = offhandDamageTooltip .. colorNeg .. " x" .. math.floor(melee.percent * 100 + 0.5) .. "%" ..
                                       FONT_COLOR_CODE_CLOSE
        end

        entry.tooltip6 = " "
        entry.tooltip7 = {
            left = {text = ATTACK_SPEED_COLON, color = S.config.colors.normalFont},
            right = {text = string.format("%.2f", melee.offhandSpeed), color = S.config.colors.highlightFont}
        }
        entry.tooltip8 = {
            left = {text = DAMAGE_COLON, color = S.config.colors.normalFont},
            right = {text = offhandDamageTooltip, color = S.config.colors.highlightFont}
        }
        entry.tooltip9 = {
            left = {text = DAMAGE_PER_SECOND, color = S.config.colors.normalFont},
            right = {text = string.format("%.1f", offhandDamagePerSecond), color = S.config.colors.highlightFont}
        }
    end
end

function S:UpdateMeleeAttackPower(entry, melee)
    local value = math.max(0, melee.attackPower.base + melee.attackPower.posBuff + melee.attackPower.negBuff)
    entry.Value:SetText(value)
    entry.tooltip = STAT_ATTACK_POWER .. " " .. value
    entry.tooltip2 = string.format(MELEE_ATTACK_POWER_TOOLTIP, value / ATTACK_POWER_MAGIC_NUMBER)
end

function S:UpdateMeleeAttackRating(entry, melee)
    local totalRating = melee.attackRating.mainhandBase + melee.attackRating.mainhandModifier
    entry.Value:SetText(totalRating)
    entry.tooltip = ATTACK_TOOLTIP .. " " .. totalRating
    if melee.attackRating.mainhandModifier ~= 0 then
        local color
        local sign
        if melee.attackRating.mainhandModifier > 0 then
            color = S.config.colors.greenFont
            sign = "+"
        else
            color = S.config.colors.redFont
            sign = "-"
        end
        entry.tooltip = entry.tooltip .. "(" .. melee.attackRating.mainhandBase .. R:Hex(S.config.colors.normalFont) .. sign ..
                            melee.attackRating.mainhandModifier .. "|r" .. ")"
    end
    entry.tooltip2 = ATTACK_TOOLTIP_SUBTEXT
end

function S:UpdateMeleeCrit(entry, melee)
    local value = string.format("%.2f%%", melee.crit)
    entry.Value:SetText(value)
    entry.tooltip = STAT_CRITICAL_STRIKE .. " " .. value
    entry.tooltip2 = "Increases your chance to score a critical strike with melee attacks." -- TODO: Localization
    entry.tooltip3 = " "
    entry.tooltip4 = "Crit cap vs."

    local critSuppression = 4.8
    local glancingChance = 40

    local extraWeaponSkill = CS.weaponSkill - 300
    local bossDefense = 315 -- level 63
    local skillBossDelta = bossDefense - CS.weaponSkill
    local dodgeChance = 5 + (skillBossDelta * 0.1)
    local critCap = 100 - CS.melee.miss.missChanceVsBoss - dodgeChance - glancingChance + critSuppression +
                        (extraWeaponSkill * 0.04)

    local critChance = GetCritChance();
    local CRITCAP_COLOR_CODE = GREEN_FONT_COLOR_CODE;
    if critChance > critCap then
        CRITCAP_COLOR_CODE = ORANGE_FONT_COLOR_CODE
    end
    local critCapTxt = CRITCAP_COLOR_CODE .. format("%.2f%%", critCap) .. FONT_COLOR_CODE_CLOSE;

    local offhandItemId = GetInventoryItemID("player", INVSLOT_OFFHAND);
    if offhandItemId then
        local critCapDw = 100 - CS.melee.miss.dwMissChanceVsBoss - dodgeChance - glancingChance + critSuppression +
                              (extraWeaponSkill * 0.04);

        local DWCRITCAP_COLOR_CODE = GREEN_FONT_COLOR_CODE;
        if critChance > critCapDw then
            DWCRITCAP_COLOR_CODE = ORANGE_FONT_COLOR_CODE
        end

        local critCapDwTxt = DWCRITCAP_COLOR_CODE .. format("%.2F%%", critCapDw) .. FONT_COLOR_CODE_CLOSE;
        entry.tooltip5 = {
            left = string.format("    Level 63 NPC/Boss: %s", critCapTxt),
            right = string.format("(Dual wield: %s)", critCapDwTxt)
        }
    else
        entry.tooltip5 = string.format("    Level 63 NPC/Boss: %s", critCapTxt)
    end
end

function S:UpdateMeleeHit(entry, melee)
    local value = string.format("%.2f%%", melee.hit)
    entry.Value:SetText(value)
    entry.tooltip = STAT_HIT_CHANCE .. " " .. value
    entry.tooltip2 = "Reduces your chance to miss with melee attacks." -- TODO: Localization
    entry.tooltip3 = " "
    entry.tooltip4 = "Miss chance vs."
    entry.tooltip5 = {
        left = string.format("    Level 60 NPC: %.2f%%", CS.melee.miss.missChanceVsNPC),
        right = string.format("(Dual wield: %.2f%%)", CS.melee.miss.dwMissChanceVsNpc)
    }
    entry.tooltip6 = {
        left = string.format("    Level 60 Player: %.2f%%", CS.melee.miss.missChanceVsPlayer),
        right = string.format("(Dual wield: %.2f%%)", CS.melee.miss.dwMissChanceVsPlayer)
    }
    entry.tooltip7 = {
        left = string.format("    Level 63 NPC/Boss: %.2f%%", CS.melee.miss.missChanceVsBoss),
        right = string.format("(Dual wield: %.2f%%)", CS.melee.miss.dwMissChanceVsBoss)
    }
end

function S:UpdateRangedDamage(entry, ranged)
    S:UpdateDamage(entry, ranged, INVTYPE_RANGED)
end

function S:UpdateRangedAttackPower(entry, ranged)
    if not CS.hasRangedWeapon or CS.hasWand or not ranged.attackPower.base then
        entry.Value:SetText(NOT_APPLICABLE)
        entry.tooltip = RANGED_ATTACK_POWER .. " " .. NOT_APPLICABLE
    else
        local value = math.max(0, ranged.attackPower.base + ranged.attackPower.posBuff + ranged.attackPower.negBuff)
        entry.Value:SetText(value)
        entry.tooltip = RANGED_ATTACK_POWER .. " " .. value
        entry.tooltip2 = string.format(RANGED_ATTACK_POWER_TOOLTIP, value / ATTACK_POWER_MAGIC_NUMBER)
    end
end

function S:UpdateRangedAttackRating(entry, ranged)
    if not CS.hasRangedWeapon then
        entry.Value:SetText(NOT_APPLICABLE)
        entry.tooltip = ATTACK_TOOLTIP .. " " .. NOT_APPLICABLE
    else
        local totalRating = ranged.attackRating.base + ranged.attackRating.modifier
        entry.Value:SetText(totalRating)
        entry.tooltip = ATTACK_TOOLTIP .. " " .. totalRating
        if ranged.attackRating.modifier ~= 0 then
            local color
            local sign
            if ranged.attackRating.modifier > 0 then
                color = S.config.colors.greenFont
                sign = "+"
            else
                color = S.config.colors.redFont
                sign = "-"
            end
            entry.tooltip = entry.tooltip .. "(" .. ranged.attackRating.base .. R:Hex(S.config.colors.normalFont) .. sign ..
                                ranged.attackRating.modifier .. "|r" .. ")"
        end
        entry.tooltip2 = ATTACK_TOOLTIP_SUBTEXT
    end
end

function S:UpdateRangedCrit(entry, ranged)
    if not CS.hasRangedWeapon then
        entry.Value:SetText(NOT_APPLICABLE)
        entry.tooltip = STAT_CRITICAL_STRIKE .. " " .. NOT_APPLICABLE
    else
        local value = string.format("%.2f%%", ranged.crit)
        entry.Value:SetText(value)
        entry.tooltip = STAT_CRITICAL_STRIKE .. " " .. value
        entry.tooltip2 = "Increases your chance to score a critical strike with ranged attacks." -- TODO: Localization
    end
end

function S:UpdateRangedHit(entry, ranged)
    if not CS.hasRangedWeapon then
        entry.Value:SetText(NOT_APPLICABLE)
        entry.tooltip = STAT_HIT_CHANCE .. " " .. NOT_APPLICABLE
    else
        local value = string.format("%.2f%%", ranged.hit)
        entry.Value:SetText(value)
        entry.tooltip = STAT_HIT_CHANCE .. " " .. value
        entry.tooltip2 = "Increases your chance to hit with ranged attacks." -- TODO: Localization
    end
end

function S:UpdateHealingPower(entry, healing)
    entry.Value:SetText(healing)
    entry.tooltip = STAT_SPELLHEALING .. " " .. healing
    local index = 2
    if CS.class == "SHAMAN" then
        if CS.lesserHealingWave > 0 then
            entry.tooltip2 = "Lesser Healing Wave: " .. (healing + CS.lesserHealingWave) -- TODO: Localization
            index = index + 1
        end
    end
    entry["tooltip" .. index] = STAT_SPELLHEALING_TOOLTIP
end

function S:UpdateSpellPower(entry, spellPower)
    entry.Value:SetText(spellPower.max)
    entry.tooltip = STAT_SPELLPOWER .. " " .. spellPower.max
    entry.tooltip2 = STAT_SPELLPOWER_TOOLTIP
    entry.tooltip3 = " "
    entry.tooltip4 = {
        left = {text = SPELL_SCHOOL1_CAP .. ": ", color = S.config.colors.holy},
        right = {text = string.format("%i", spellPower.holy), color = S.config.colors.holy}
    }
    entry.tooltip5 = {
        left = {text = SPELL_SCHOOL2_CAP .. ": ", color = S.config.colors.fire},
        right = {text = string.format("%i", spellPower.fire), color = S.config.colors.fire}
    }
    entry.tooltip6 = {
        left = {text = SPELL_SCHOOL4_CAP .. ": ", color = S.config.colors.frost},
        right = {text = string.format("%i", spellPower.frost), color = S.config.colors.frost}
    }
    entry.tooltip7 = {
        left = {text = SPELL_SCHOOL6_CAP .. ": ", color = S.config.colors.arcane},
        right = {text = string.format("%i", spellPower.arcane), color = S.config.colors.arcane}
    }
    entry.tooltip8 = {
        left = {text = SPELL_SCHOOL5_CAP .. ": ", color = S.config.colors.shadow},
        right = {text = string.format("%i", spellPower.shadow), color = S.config.colors.shadow}
    }
    entry.tooltip9 = {
        left = {text = SPELL_SCHOOL3_CAP .. ": ", color = S.config.colors.nature},
        right = {text = string.format("%i", spellPower.nature), color = S.config.colors.nature}
    }
    if CS.class == "SHAMAN" then
        if spellPower.lightning > 0 then
            entry.tooltip10 = {
                left = {text = "   Lightning: ", color = S.config.colors.nature}, -- TODO: Localization
                right = {text = string.format("%i", spellPower.nature + spellPower.lightning), color = S.config.colors.nature}
            }
        elseif spellPower.shocks > 0 then
            entry.tooltip10 = {
                left = {text = "   Flame Shock: ", color = S.config.colors.fire}, -- TODO: Localization
                right = {text = string.format("%i", spellPower.fire + spellPower.shocks), color = S.config.colors.fire}
            }
            entry.tooltip11 = {
                left = {text = "   Frost Shock: ", color = S.config.colors.frost}, -- TODO: Localization
                right = {text = string.format("%i", spellPower.frost + spellPower.shocks), color = S.config.colors.frost}
            }
            entry.tooltip12 = {
                left = {text = "   Earth Shock: ", color = S.config.colors.nature}, -- TODO: Localization
                right = {text = string.format("%i", spellPower.nature + spellPower.shocks), color = S.config.colors.nature}
            }
        end
    end
end

function S:UpdateSpellCrit(entry, spellCrit)
    entry.Value:SetText(string.format("%.2f%%", spellCrit.max))
    entry.tooltip = STAT_CRITICAL_STRIKE .. " " .. string.format("%.2f%%", spellCrit.max)
    entry.tooltip2 = "Increases your chance to score a critical strike with spells." -- TODO: Localization
    entry.tooltip3 = " "

    local index = 4
    entry["tooltip" .. index] = {
        left = {text = SPELL_SCHOOL1_CAP .. ":", color = S.config.colors.holy},
        right = {text = string.format("%.2f%%", spellCrit.holy), color = S.config.colors.holy}
    }
    index = index + 1

    entry["tooltip" .. index] = {
        left = {text = SPELL_SCHOOL2_CAP .. ":", color = S.config.colors.fire},
        right = {text = string.format("%.2f%%", spellCrit.fire), color = S.config.colors.fire}
    }
    index = index + 1

    if CS.class == "WARLOCK" then
        entry["tooltip" .. index] = {
            left = {text = "   Searing Pain:", color = S.config.colors.fire},
            right = {text = string.format("%.2f%%", spellCrit.searingPain), color = S.config.colors.fire}
        }
        index = index + 1
    end

    entry["tooltip" .. index] = {
        left = {text = SPELL_SCHOOL4_CAP .. ":", color = S.config.colors.frost},
        right = {text = string.format("%.2f%%", spellCrit.frost), color = S.config.colors.frost}
    }
    index = index + 1

    entry["tooltip" .. index] = {
        left = {text = SPELL_SCHOOL6_CAP .. ":", color = S.config.colors.arcane},
        right = {text = string.format("%.2f%%", spellCrit.arcane), color = S.config.colors.arcane}
    }
    index = index + 1

    entry["tooltip" .. index] = {
        left = {text = SPELL_SCHOOL5_CAP .. ":", color = S.config.colors.shadow},
        right = {text = string.format("%.2f%%", spellCrit.shadow), color = S.config.colors.shadow}
    }
    index = index + 1

    if CS.class == "WARLOCK" then
        entry["tooltip" .. index] = {
            left = {text = "   Destruction:", color = S.config.colors.shadow},
            right = {text = string.format("%.2f%%", spellCrit.destruction), color = S.config.colors.shadow}
        }
        index = index + 1
    end

    entry["tooltip" .. index] = {
        left = {text = SPELL_SCHOOL3_CAP .. ":", color = S.config.colors.nature},
        right = {text = string.format("%.2f%%", spellCrit.nature), color = S.config.colors.nature}
    }
    index = index + 1

    if CS.class == "SHAMAN" then
        entry["tooltip" .. index] = {
            left = {text = "   Healing:", color = S.config.colors.nature},
            right = {text = string.format("%.2f%%", spellCrit.healing), color = S.config.colors.nature}
        }
        index = index + 1

        entry["tooltip" .. index] = {
            left = {text = "   Lightning:", color = S.config.colors.nature},
            right = {text = string.format("%.2f%%", spellCrit.lightning), color = S.config.colors.nature}
        }
    end
end

function S:UpdateSpellHit(entry, spellHit)
    entry.Value:SetText(string.format("%i%%", spellHit.max))
    entry.tooltip = STAT_HIT_CHANCE .. " " .. spellHit.max .. "%"
    entry.tooltip2 = "Increases your chance to hit with spells." -- TODO: Localization
    entry.tooltip3 = " "
    entry.tooltip4 = {
        left = {text = SPELL_SCHOOL1_CAP .. ": ", color = S.config.colors.holy},
        right = {text = string.format("%i%%", spellHit.holy), color = S.config.colors.holy}
    }
    entry.tooltip5 = {
        left = {text = SPELL_SCHOOL2_CAP .. ": ", color = S.config.colors.fire},
        right = {text = string.format("%i%%", spellHit.fire), color = S.config.colors.fire}
    }
    entry.tooltip6 = {
        left = {text = SPELL_SCHOOL4_CAP .. ": ", color = S.config.colors.frost},
        right = {text = string.format("%i%%", spellHit.frost), color = S.config.colors.frost}
    }
    entry.tooltip7 = {
        left = {text = SPELL_SCHOOL6_CAP .. ": ", color = S.config.colors.arcane},
        right = {text = string.format("%i%%", spellHit.arcane), color = S.config.colors.arcane}
    }
    entry.tooltip8 = {
        left = {text = SPELL_SCHOOL5_CAP .. ": ", color = S.config.colors.shadow},
        right = {text = string.format("%i%%", spellHit.shadow), color = S.config.colors.shadow}
    }
    entry.tooltip9 = {
        left = {text = SPELL_SCHOOL3_CAP .. ": ", color = S.config.colors.nature},
        right = {text = string.format("%i%%", spellHit.nature), color = S.config.colors.nature}
    }
end

function S:UpdateManaRegen(entry, regen)
    -- TODO: Localization
    local regenText = (UnitHasMana("player") and string.format("%i / %i", regen.base * 5, regen.casting * 5)) or NOT_APPLICABLE
    entry.Value:SetText(regenText)
    entry.tooltip = MANA_REGEN .. " " .. regenText
    entry.tooltip2 = MANA_REGEN_TOOLTIP
    entry.tooltip3 = " "
    entry.tooltip4 = {
        left = string.format("%s While Not Casting:", MANA_REGEN),
        right = {text = string.format("%i", regen.base * 5), color = S.config.colors.highlightFont}
    }
    entry.tooltip5 = {
        left = string.format("%s While Casting:", MANA_REGEN),
        right = {text = string.format("%i", regen.casting * 5), color = S.config.colors.highlightFont}
    }
end

function S:UpdateArmor(entry, armor)
    entry.Value:SetText(armor.effectiveArmor)
    local effectiveBuff = armor.posBuff + armor.negBuff
    if effectiveBuff == 0 then
        entry.Value:SetTextColor(unpack(S.config.colors.highlightFont))
    elseif effectiveBuff > 0 then
        entry.Value:SetTextColor(unpack(S.config.colors.greenFont))
    elseif effectiveBuff < 0 then
        entry.Value:SetTextColor(unpack(S.config.colors.redFont))
    end

    entry.tooltip = S:FormatStatTooltip(ARMOR, armor.effectiveArmor, armor.posBuff, armor.negBuff)
    entry.tooltip2 = string.format(ARMOR_TOOLTIP, CS.level, CS.armorReduction)
end

function S:UpdateDodge(entry, dodge)
    local valueText = string.format((dodge > 0 and "%.2f%%") or "0%%", dodge)
    entry.Value:SetText(valueText)
    entry.tooltip = string.format(PAPERDOLLFRAME_TOOLTIP_FORMAT, DODGE_CHANCE) .. " " .. valueText
    entry.tooltip2 = "Increases your chance to dodge an attack." -- TODO: Localization
end

function S:UpdateParry(entry, parry)
    local valueText = string.format((parry > 0 and "%.2f%%") or "0%%", parry)
    entry.Value:SetText(valueText)
    entry.tooltip = string.format(PAPERDOLLFRAME_TOOLTIP_FORMAT, PARRY_CHANCE) .. " " .. valueText
    entry.tooltip2 = "Increases your chance to parry an attack." -- TODO: Localization
end

function S:UpdateBlock(entry, block, blockValue)
    local valueText = string.format((block > 0 and "%.2f%%") or "0%%", block)
    entry.Value:SetText(valueText)
    entry.tooltip = string.format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_BLOCK) .. " " .. valueText
    entry.tooltip2 = "Increases your chance to block an attack with your shield." -- TODO: Localization
    entry.tooltip3 = " "
    entry.tooltip4 = {
        left = BLOCK_CHANCE .. ": ",
        right = {text = string.format("%.2f%%", block), color = S.config.colors.highlightFont}
    }
    entry.tooltip5 = {
        left = ITEM_MOD_BLOCK_VALUE_SHORT .. ": ",
        right = {text = string.format("%i", blockValue), color = S.config.colors.highlightFont}
    }
end

function S:UpdateDefense(entry, defense)
    entry.Value:SetText(defense)
    entry.tooltip = string.format(PAPERDOLLFRAME_TOOLTIP_FORMAT, DEFENSE) .. " " .. defense

    local tooltip2 = string.format(DEFAULT_STATDEFENSE_TOOLTIP, defense, 0, defense * 0.04, defense * 0.04);
    tooltip2 = tooltip2:gsub(".-\n", "", 1);
    tooltip2 = tooltip2:gsub("%b()", "");
    entry.tooltip2 = tooltip2;
end

function S:UpdatePaperDollFrame()
    if not CharacterFrame:IsShown() then
        return
    end

    -- update average item level
    local itemLevelCategory = 0
    if CS.itemLevel then
        if CS.itemLevel >= S.config.itemLevels.legendary then
            itemLevelCategory = 5 -- legendary
        elseif CS.itemLevel >= S.config.itemLevels.epic then
            itemLevelCategory = 4 -- epic
        elseif CS.itemLevel >= S.config.itemLevels.rare then
            itemLevelCategory = 3 -- rare
        elseif CS.itemLevel >= S.config.itemLevels.uncommon then
            itemLevelCategory = 2 -- uncommon
        elseif CS.itemLevel >= S.config.itemLevels.common then
            itemLevelCategory = 1 -- common
        else
            itemLevelCategory = 0 -- poor
        end
        local r, g, b = GetItemQualityColor(itemLevelCategory)
        PaperDollFrame.CharacterStatsPane.ItemLevel.Value.Text:SetText(R:Hex(r, g, b) .. CS.itemLevel .. "|r")
    end

    -- update attributes
    S:UpdateAttribute(PaperDollFrame.CharacterStatsPane.Attributes.Strength, CS.strength)
    S:UpdateAttribute(PaperDollFrame.CharacterStatsPane.Attributes.Agility, CS.agility)
    S:UpdateAttribute(PaperDollFrame.CharacterStatsPane.Attributes.Stamina, CS.stamina)
    S:UpdateAttribute(PaperDollFrame.CharacterStatsPane.Attributes.Intellect, CS.intellect)
    S:UpdateAttribute(PaperDollFrame.CharacterStatsPane.Attributes.Spirit, CS.spirit)

    -- update enhancements: melee
    S:UpdateMeleeDamage(PaperDollFrame.CharacterStatsPane.Enhancements.Melee.Damage, CS.melee)
    S:UpdateMeleeAttackPower(PaperDollFrame.CharacterStatsPane.Enhancements.Melee.AttackPower, CS.melee)
    S:UpdateMeleeAttackRating(PaperDollFrame.CharacterStatsPane.Enhancements.Melee.AttackRating, CS.melee)
    S:UpdateMeleeCrit(PaperDollFrame.CharacterStatsPane.Enhancements.Melee.Crit, CS.melee)
    S:UpdateMeleeHit(PaperDollFrame.CharacterStatsPane.Enhancements.Melee.Hit, CS.melee)

    -- update enhancements: ranged
    S:UpdateRangedDamage(PaperDollFrame.CharacterStatsPane.Enhancements.Ranged.Damage, CS.ranged)
    S:UpdateRangedAttackPower(PaperDollFrame.CharacterStatsPane.Enhancements.Ranged.AttackPower, CS.ranged)
    S:UpdateRangedAttackRating(PaperDollFrame.CharacterStatsPane.Enhancements.Ranged.AttackRating, CS.ranged)
    S:UpdateRangedCrit(PaperDollFrame.CharacterStatsPane.Enhancements.Ranged.Crit, CS.ranged)
    S:UpdateRangedHit(PaperDollFrame.CharacterStatsPane.Enhancements.Ranged.Hit, CS.ranged)

    -- update enhancements: magic
    S:UpdateHealingPower(PaperDollFrame.CharacterStatsPane.Enhancements.Magic.HealingPower, CS.healingPower)
    S:UpdateSpellPower(PaperDollFrame.CharacterStatsPane.Enhancements.Magic.SpellPower, CS.spellPower)
    S:UpdateSpellCrit(PaperDollFrame.CharacterStatsPane.Enhancements.Magic.SpellCrit, CS.spellCrit)
    S:UpdateSpellHit(PaperDollFrame.CharacterStatsPane.Enhancements.Magic.SpellHit, CS.spellHit)
    S:UpdateManaRegen(PaperDollFrame.CharacterStatsPane.Enhancements.Magic.ManaRegen, CS.manaRegen)

    -- update enhancements: defenses
    S:UpdateArmor(PaperDollFrame.CharacterStatsPane.Enhancements.Defenses.Armor, CS.armor)
    S:UpdateDodge(PaperDollFrame.CharacterStatsPane.Enhancements.Defenses.Dodge, CS.dodge)
    S:UpdateParry(PaperDollFrame.CharacterStatsPane.Enhancements.Defenses.Parry, CS.parry)
    S:UpdateBlock(PaperDollFrame.CharacterStatsPane.Enhancements.Defenses.Block, CS.block, CS.blockValue)
    S:UpdateDefense(PaperDollFrame.CharacterStatsPane.Enhancements.Defenses.Defense, CS.defense.defense)
end
