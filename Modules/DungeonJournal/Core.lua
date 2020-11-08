local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local DJ = Addon.Modules.DungeonJournal

function DJ:OnEnable()
    DJ.DungeonJournal = DJ:CreateDungeonJournal()
    DJ.MicroButton = DJ:CreateMicroButton()

    DJ:OpenInstanceSelectTab(1)
end

function DJ:CreateDungeonJournal()
    local frame = CreateFrame("Frame", AddonName .. "DungeonJournal", UIParent, "PortraitFrameTemplate")
    frame:SetSize(800, 496)
    frame:SetPoint("CENTER", 0, 0)
    frame:EnableMouse(true)
    frame:Hide()

    _G[AddonName .. "DungeonJournalTitleText"]:SetText(ADVENTURE_JOURNAL)
    SetPortraitToTexture(frame.portrait, "Interface\\EncounterJournal\\UI-EJ-PortraitIcon")
    tinsert(UISpecialFrames, frame:GetName())

    frame.navBar = DJ:CreateNavBar(frame)
    frame.inset = DJ:CreateInset(frame)
    frame.instanceSelect = DJ:CreateInstanceSelect(frame)
    frame.encounter = DJ:CreateEncounterFrame(frame)

    frame:SetScript("OnShow", function()
        DJ.MicroButton:SetButtonState("PUSHED", true)
    end)
    frame:SetScript("OnHide", function()
        DJ.MicroButton:SetButtonState("NORMAL")
    end)

    local homeData = {
        name = HOME,
        OnClick = function()
            if frame.instanceSelect.suggestTab:IsEnabled() then
                DJ:OpenInstanceSelectTab(1)
            elseif not frame.instanceSelect.dungeonsTab:IsEnabled() then
                DJ:ListInstances(false)
            elseif not frame.instanceSelect.raidsTab:IsEnabled() then
                DJ:ListInstances(true)
            end
        end
    }
    NavBar_Initialize(frame.navBar, "NavButtonTemplate", homeData, frame.navBar.home, frame.navBar.overflow)

    return frame
end

function DJ:CreateMicroButton()
    local button = CreateFrame("Button", "EJMicroButton", UIParent, "MainMenuBarMicroButton")
    button:SetSize(29, 58)
    button:RegisterForClicks("AnyUp")
    button:SetNormalTexture("Interface\\Buttons\\UI-MicroButton-EJ-Up")
    button:SetPushedTexture("Interface\\Buttons\\UI-MicroButton-EJ-Down")
    button:SetDisabledTexture("Interface\\Buttons\\UI-MicroButton-EJ-Disabled")
    button:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight")
    button.tooltipText = ENCOUNTER_JOURNAL
    button.newbieText = string.gsub(NEWBIE_TOOLTIP_ENCOUNTER_JOURNAL, "Cataclysm ", "")
    button:Hide()

    button:SetScript("OnClick", DJ.ToggleDungeonJournal)

    return button
end

function DJ:ToggleDungeonJournal()
    if not DJ.DungeonJournal:IsShown() then
        DJ.DungeonJournal:Show()
    else
        DJ.DungeonJournal:Hide()
    end
end

function DJ:CreateNavBar(parent)
    local navBar = CreateFrame("Frame", "$parentNavBar", parent, "NavBarTemplate")
    navBar:SetSize(500, 34)
    navBar:SetPoint("TOPLEFT", 61, -22)

    if TODO then -- fix nav bar background border
        navBar.InsetBorderBottomLeft = navBar:CreateTexture("$parentInsetBotLeftCorner", "BACKGROUND", "UI-Frame-InnerBotLeftCorner", -5)
        navBar.InsetBorderBottomLeft:SetPoint("BOTTOMLEFT", -3, -3)

        navBar.InsetBorderBottomRight = navBar:CreateTexture("$parentInsetBotRightCorner", "BACKGROUND", "UI-Frame-InnerBotRight", -5)
        navBar.InsetBorderBottomRight:SetPoint("BOTTOMRIGHT", 3, -3)

        navBar.InsetBorderBottom = navBar:CreateTexture("$parentInsetBottomBorder", "BACKGROUND", "_UI-Frame-InnerBotTile", -5)
        navBar.InsetBorderBottom:SetPoint("BOTTOMLEFT", "$parentInsetBotLeftCorner", "BOTTOMRIGHT")
        navBar.InsetBorderBottom:SetPoint("BOTTOMRIGHT", "$parentInsetBotRightCorner", "BOTTOMLEFT")

        navBar.InsetBorderLeft = navBar:CreateTexture("$parentInsetLeftBorder", "BACKGROUND", "!UI-Frame-InnerLeftTile", -5)
        navBar.InsetBorderLeft:SetPoint("TOPLEFT", -3, 0)
        navBar.InsetBorderLeft:SetPoint("BOTTOMLEFT", "$parentInsetBotLeftCorner", "TOPLEFT")

        navBar.InsetBorderRight = navBar:CreateTexture("$parentInsetRightBorder", "BACKGROUND", "!UI-Frame-InnerRightTile", -5)
        navBar.InsetBorderRight:SetPoint("TOPRIGHT", 3, 0)
        navBar.InsetBorderRight:SetPoint("BOTTOMRIGHT", "$parentInsetBotRightCorner", "TOPRIGHT")
    end

    navBar:SetScript("OnShow", nil)

    return navBar
end

function DJ:CreateInset(parent)
    local inset = CreateFrame("Frame", "$parentInset", parent, "InsetFrameTemplate")
    inset:SetPoint("TOPRIGHT", -4, -60)
    inset:SetPoint("BOTTOMLEFT", 4, 5)

    return inset
end

function DJ:CreateInstanceSelect(parent)
    local instanceSelect = CreateFrame("Frame", "$parentInstanceSelect", parent)
    instanceSelect:SetPoint("TOPLEFT", "$parentInset", 0, -2)
    instanceSelect:SetPoint("BOTTOMRIGHT", "$parentInset", -3, 0)

    instanceSelect.bg = instanceSelect:CreateTexture("$parentBG", "BACKGROUND")
    instanceSelect.bg:SetTexture("Interface\\EncounterJournal\\UI-EJ-Classic")
    instanceSelect.bg:SetPoint("TOPLEFT", 3, -1)
    instanceSelect.bg:SetPoint("BOTTOMRIGHT", -3, 1)

    instanceSelect.suggestTab = DJ:CreateInstanceSelectTab("$parentSuggestTab", instanceSelect)
    instanceSelect.suggestTab.id = 1
    instanceSelect.suggestTab:SetText(AJ_SUGGESTED_CONTENT_TAB)
    instanceSelect.suggestTab:SetPoint("BOTTOMLEFT", instanceSelect, "TOPLEFT", 25, -45)
    instanceSelect.suggestTab:SetScript("OnClick", function()
        DJ:OpenInstanceSelectTab(1)
    end)

    instanceSelect.dungeonsTab = DJ:CreateInstanceSelectTab("$parentDungeonTab", instanceSelect)
    instanceSelect.dungeonsTab.id = 2
    instanceSelect.dungeonsTab:SetText(DUNGEONS)
    instanceSelect.dungeonsTab:SetPoint("BOTTOMLEFT", "$parentSuggestTab", "BOTTOMRIGHT", 35, 0)
    instanceSelect.dungeonsTab:SetScript("OnClick", function()
        DJ:OpenInstanceSelectTab(2)
    end)

    instanceSelect.raidsTab = DJ:CreateInstanceSelectTab("$parentRaidTab", instanceSelect)
    instanceSelect.raidsTab.id = 3
    instanceSelect.raidsTab:SetText(RAIDS)
    instanceSelect.raidsTab:SetPoint("BOTTOMLEFT", "$parentDungeonTab", "BOTTOMRIGHT", 35, 0)
    instanceSelect.raidsTab:SetScript("OnClick", function()
        DJ:OpenInstanceSelectTab(3)
    end)

    instanceSelect.tabs = {instanceSelect.suggestTab, instanceSelect.dungeonsTab, instanceSelect.raidsTab}

    -- TODO: Loot Journal
    -- instanceSelect.LootJournalTab = DJ:CreateInstanceSelectTab("$parentLootJournalTab", instanceSelect)
    -- instanceSelect.LootJournalTab:SetText(LOOT_JOURNAL_POWERS)
    -- instanceSelect.LootJournalTab:SetPoint("BOTTOMLEFT", "$parentRaidTab", "BOTTOMRIGHT", 35, 0)

    instanceSelect.scroll = DJ:CreateScrollFrame(instanceSelect, "$parentScrollFrame", 785, 377)
    instanceSelect.scroll:SetPoint("TOPLEFT", 5, -49)
    instanceSelect.scroll:SetPoint("BOTTOMRIGHT", -25, 3)
    instanceSelect.scroll.ScrollBar.trackBG:SetAlpha(0)

    return instanceSelect
end

function DJ:CreateInstanceSelectTab(name, parent)
    local tab = CreateFrame("Button", name, parent)
    tab:SetSize(120, 36)
    tab:SetHitRectInsets(-12, -12, 0, 0)
    tab:SetNormalFontObject(GameFontNormalMed1)

    tab.mid = tab:CreateTexture("$parentMid", "BACKGROUND") -- _DungeonGridTab-Mid
    tab.mid:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures_Tile")
    tab.mid:SetTexCoord(0, 1, 0.67382813, 0.74414063)
    tab.mid:SetSize(64, 36)
    tab.mid:SetPoint("TOPLEFT")
    tab.mid:SetPoint("BOTTOMRIGHT")
    tab.mid:SetHorizTile(true)

    tab.left = tab:CreateTexture("$parentLeft", "BACKGROUND") -- UI-EJ-DungeonGridTab-Left
    tab.left:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab.left:SetTexCoord(0.81835938, 0.84179688, 0.02246094, 0.05761719)
    tab.left:SetSize(12, 36)
    tab.left:SetPoint("TOPRIGHT", tab, "TOPLEFT")
    tab.left:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT")

    tab.right = tab:CreateTexture("$parentRight", "BACKGROUND") -- UI-EJ-DungeonGridTab-Right
    tab.right:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab.right:SetTexCoord(0.84570313, 0.86914063, 0.05957031, 0.09472656)
    tab.right:SetSize(12, 36)
    tab.right:SetPoint("TOPLEFT", tab, "TOPRIGHT")
    tab.right:SetPoint("BOTTOMLEFT", tab, "BOTTOMRIGHT")

    tab.midSelect = tab:CreateTexture("$parentMidSelect", "OVERLAY") -- _DungeonGridTab-MidSelect
    tab.midSelect:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures_Tile")
    tab.midSelect:SetTexCoord(0, 1, 0.59960938, 0.66992188)
    tab.midSelect:SetSize(64, 36)
    tab.midSelect:SetPoint("TOPLEFT")
    tab.midSelect:SetPoint("BOTTOMRIGHT")
    tab.midSelect:SetHorizTile(true)
    tab.midSelect:Hide()

    tab.leftSelect = tab:CreateTexture("$parentLeftSelect", "OVERLAY") -- UI-EJ-DungeonGridTab-LeftSelect
    tab.leftSelect:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab.leftSelect:SetTexCoord(0.84570313, 0.86914063, 0.02246094, 0.05761719)
    tab.leftSelect:SetSize(12, 36)
    tab.leftSelect:SetPoint("TOPRIGHT", tab, "TOPLEFT")
    tab.leftSelect:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT")
    tab.leftSelect:Hide()

    tab.rightSelect = tab:CreateTexture("$parentRightSelect", "OVERLAY") -- UI-EJ-DungeonGridTab-RightSelect
    tab.rightSelect:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab.rightSelect:SetTexCoord(0.87304688, 0.89648438, 0.05957031, 0.09472656)
    tab.rightSelect:SetSize(12, 36)
    tab.rightSelect:SetPoint("TOPLEFT", tab, "TOPRIGHT")
    tab.rightSelect:SetPoint("BOTTOMLEFT", tab, "BOTTOMRIGHT")
    tab.rightSelect:Hide()

    tab.selectedGlow = tab:CreateTexture("$parentSelectedGlow", "OVERLAY") -- UI-EJ-DungeonGridTab-RightSelect
    tab.selectedGlow:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab.selectedGlow:SetTexCoord(0.52343750, 0.64843750, 0.00097656, 0.01562500)
    tab.selectedGlow:SetSize(64, 15)
    tab.selectedGlow:SetPoint("BOTTOMLEFT", -18, 0)
    tab.selectedGlow:SetPoint("BOTTOMRIGHT", 18, 0)
    tab.selectedGlow:Hide()

    tab.midHighlight = tab:CreateTexture("$parentMidHighlight", "HIGHLIGHT") -- _DungeonGridTab-MidHighlight
    tab.midHighlight:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures_Tile")
    tab.midHighlight:SetTexCoord(0, 1, 0.52539063, 0.59570313)
    tab.midHighlight:SetSize(64, 36)
    tab.midHighlight:SetPoint("TOPLEFT")
    tab.midHighlight:SetPoint("BOTTOMRIGHT")
    tab.midHighlight:SetHorizTile(true)

    tab.leftHighlight = tab:CreateTexture("$parentLeftHighlight", "HIGHLIGHT") -- UI-EJ-DungeonGridTab-LeftHighlight
    tab.leftHighlight:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab.leftHighlight:SetTexCoord(0.81835938, 0.84179688, 0.05957031, 0.09472656)
    tab.leftHighlight:SetSize(12, 36)
    tab.leftHighlight:SetPoint("TOPRIGHT", tab, "TOPLEFT")
    tab.leftHighlight:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT")

    tab.rightHighlight = tab:CreateTexture("$parentRightHighlight", "HIGHLIGHT") -- UI-EJ-DungeonGridTab-RightSelect
    tab.rightHighlight:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab.rightHighlight:SetTexCoord(0.87304688, 0.89648438, 0.02246094, 0.05761719)
    tab.rightHighlight:SetSize(12, 36)
    tab.rightHighlight:SetPoint("TOPLEFT", tab, "TOPRIGHT")
    tab.rightHighlight:SetPoint("BOTTOMLEFT", tab, "BOTTOMRIGHT")

    tab.grayBox = CreateFrame("Frame", nil, parent)
    tab.grayBox:SetPoint("TOPLEFT", -10, 19)
    tab.grayBox:SetPoint("BOTTOMRIGHT", 10, 0)
    tab.grayBox.texture = tab.grayBox:CreateTexture(nil, "BACKGROUND")
    tab.grayBox.texture:SetPoint("TOPLEFT", 3, -25)
    tab.grayBox.texture:SetPoint("BOTTOMRIGHT", -3, 0)
    tab.grayBox.texture:SetAlpha(0.6)
    tab.grayBox:Hide()

    tab:SetScript("OnLoad", function()
        tab:SetHeight(32)
        tab:SetWidth(max(tab:GetTextWidth() + 20, 70))
    end)
    tab:SetScript("OnEnable", function()
        tab.leftSelect:Hide()
        tab.midSelect:Hide()
        tab.rightSelect:Hide()
        tab:SetHeight(32)
    end)
    tab:SetScript("OnDisable", function()
        tab.leftSelect:Show()
        tab.midSelect:Show()
        tab.rightSelect:Show()
        tab:SetHeight(36)
    end)

    return tab
end

function DJ:CreateScrollFrame(parent, name, width, height)
    local scrollFrame = CreateFrame("ScrollFrame", name, parent, "MinimalScrollFrameTemplate")
    scrollFrame:SetSize(width, height)
    scrollFrame.child = CreateFrame("Frame", "$parentScrollChild", scrollFrame)
    scrollFrame:SetScrollChild(scrollFrame.child)
    scrollFrame.child:SetSize(width, height - 2)

    return scrollFrame
end

function DJ:OpenInstanceSelectTab(id)
    local instanceSelect = DJ.DungeonJournal.instanceSelect
    local encounter = DJ.DungeonJournal.encounter

    local selectedTab
    for _, tab in next, instanceSelect.tabs do
        if tab.id == id then
            tab:GetFontString():SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
            tab:Disable()
            selectedTab = tab
        else
            tab:GetFontString():SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
            tab.selectedGlow:Hide()
            tab:Enable()
        end
    end

    if selectedTab then
        selectedTab.selectedGlow:SetVertexColor(1.0, 0.82, 0.0)
        selectedTab.selectedGlow:Show()
    end

    if id == instanceSelect.suggestTab.id then
        encounter:Hide()
        instanceSelect:Show()
        instanceSelect.scroll:Hide()
        -- elseif id == instanceSelect.LootJournalTab.id then
        --	instanceSelect.scroll:Hide()
    elseif id == instanceSelect.dungeonsTab.id then
        encounter:Hide()
        instanceSelect:Show()
        instanceSelect.scroll:Show()
        DJ:ListInstances(false)
    elseif id == instanceSelect.raidsTab.id then
        encounter:Hide()
        instanceSelect:Show()
        instanceSelect.scroll:Show()
        DJ:ListInstances(true)
    end
end

function DJ:SelectInstance(id)
    NavBar_Reset(DJ.DungeonJournal.navBar)
    local instance = DJ.Database:GetInstanceById(id)
    if instance then
        -- DJ:OpenInstanceSelectTab(0) -- unselect all tabs
        local instanceSelect = DJ.DungeonJournal.instanceSelect
        instanceSelect:Hide()

        local encounter = DJ.DungeonJournal.encounter
        encounter:Show()
        encounter.instance.title:SetText(instance.title);
        encounter.instance.titleBG:SetWidth(encounter.instance.title:GetStringWidth() + 80);
        local loreImage = instance.name
        loreImage = string.gsub(instance.name, "Onyxia", "OnxyiasLair")
        encounter.instance.loreBG:SetTexture("Interface\\EncounterJournal\\UI-EJ-LOREBG-" .. loreImage)

        encounter.instance.loreScroll.child.lore:SetText(instance.lore)
        local loreHeight = encounter.instance.loreScroll.child.lore:GetHeight()
        encounter.instance.loreScroll.ScrollBar:SetValue(0);
        if loreHeight <= 100 then
            encounter.instance.loreScroll.ScrollBar:Hide();
        else
            encounter.instance.loreScroll.ScrollBar:Show();
        end

        encounter.info.difficultyIcon:Hide() -- TODO: dungeon difficulty
        encounter.info.instanceTitle:ClearAllPoints()
        encounter.info.instanceTitle:SetPoint("TOPLEFT", 65, -20)
        encounter.info.instanceTitle:SetText(instance.title)

        encounter.info.instanceButton.icon:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
        local buttonImage = instance.name
        buttonImage = string.gsub(buttonImage, "Onyxia", "OnyxiaEncounter")
        buttonImage = string.gsub(buttonImage, "RuinsOfAhnQiraj", "AQRUINS")
        buttonImage = string.gsub(buttonImage, "TempleOfAhnQiraj", "AQTEMPLE")
        buttonImage = string.gsub(buttonImage, "TheStockade", "STORMWINDSTOCKADES")
        buttonImage = string.gsub(buttonImage, "ZulFarrak", "ZULFARAK")
        encounter.info.instanceButton.icon:SetTexture("Interface\\LFGFrame\\LFGICON-" .. buttonImage)

        DJ:SetEncounterInfoTabEnabled(encounter.info.overviewTab, false)
        DJ:SetEncounterInfoTabEnabled(encounter.info.modelTab, false)
        DJ:SetEncounterInfoTabEnabled(encounter.info.bossTab, false)
        DJ:SetEncounterInfoTabEnabled(encounter.info.lootTab, false) -- TODO: enable for trash loot?

        DJ:ListBosses(instance)

        -- unlock boss button highlights
        DJ.DungeonJournal.bossId = nil
        for _, button in next, DJ.DungeonJournal.encounter.bossesFrame.BossButtons do
            button.isSelected = false
            if not button.hover then
                button.text:SetTextColor(0.827, 0.659, 0.463)
            end
            button:UnlockHighlight()
        end

        instanceSelect:Hide()
        encounter:Show()
        encounter.instance:Show()
        encounter.info.encounterTitle:Hide()
        encounter.info.overviewScroll:Hide()
        encounter.info.detailsScroll:Hide()
        encounter.info.lootScroll:Hide()
        encounter.info.rightShadow:Hide()

        local backgroundImage = instance.name
        backgroundImage = string.gsub(instance.name, "Onyxia", "OnyxiasLair")
        encounter.info.model.dungeonBG:SetTexture("Interface\\EncounterJournal\\UI-EJ-BACKGROUND-" .. backgroundImage)

        DJ.DungeonJournal.instanceId = instance.id

        local buttonData = {
            id = instance.id,
            name = instance.title,
            OnClick = DJ.RefreshInstance,
            listFunc = function()
                return DJ:GetNavInstanceList(instance.isRaid)
            end
        }
        NavBar_AddButton(DJ.DungeonJournal.navBar, buttonData)
    end
end

function DJ:RefreshInstance()
    DJ:SelectInstance(DJ.DungeonJournal.instanceId)
end

function DJ:ListInstances(isRaid)
    local list = isRaid and DJ.Database.Raids or DJ.Database.Dungeons
    local parent = DJ.DungeonJournal.instanceSelect.scroll.child
    if not parent.InstanceButtons then
        parent.InstanceButtons = {}
    end

    local numberOfRows = 1
    local buttonsPerRow = 4
    local previousButton, previousRow
    for i, instance in next, list do
        local instanceButton = parent.InstanceButtons[instance.name]
        if not instanceButton then
            instanceButton = DJ:CreateInstanceButton(instance, parent)
            parent.InstanceButtons[instance.name] = instanceButton
        end

        if i == 1 then
            instanceButton:SetPoint("TOPLEFT", 12, -10)
            previousRow = instanceButton
        elseif math.fmod(i, buttonsPerRow) == 1 then
            instanceButton:SetPoint("TOP", previousRow, "BOTTOM", 0, -15)
            previousRow = instanceButton
            numberOfRows = numberOfRows + 1
        else
            instanceButton:SetPoint("LEFT", previousButton, "RIGHT", 15, 0)
        end

        previousButton = instanceButton
        instanceButton:Show()
    end

    if previousButton then
        parent:SetHeight(10 + numberOfRows * previousButton:GetHeight())
    end

    DJ:HideOtherInstances(isRaid)
    DJ.DungeonJournal.encounter:Hide()
end

function DJ:GetNavInstanceList(isRaid)
    local list = isRaid and DJ.Database.Raids or DJ.Database.Dungeons
    local instances = {}
    for i, instance in next, list do
        table.insert(instances, {
            text = instance.title,
            id = instance.id,
            func = function()
                DJ:SelectInstance(instance.id)
            end
        })
    end
    return instances
end

function DJ:HideOtherInstances(isRaid)
    local list = not isRaid and DJ.Database.Raids or DJ.Database.Dungeons
    local parent = DJ.DungeonJournal.instanceSelect.scroll.child

    for i, instance in next, list do
        local instanceButton = parent.InstanceButtons[instance.name]
        if instanceButton then
            instanceButton:Hide()
        end
    end
end

function DJ:CreateInstanceButton(instance, parent)
    local instanceButton = CreateFrame("Button", "$parentInstanceButton" .. instance.name, parent)
    instanceButton:SetSize(174, 96)
    instanceButton:SetNormalTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    instanceButton:GetNormalTexture():SetTexCoord(0.00195313, 0.34179688, 0.42871094, 0.52246094)
    instanceButton:SetPushedTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    instanceButton:GetPushedTexture():SetTexCoord(0.00195313, 0.34179688, 0.33300781, 0.42675781)
    instanceButton:SetHighlightTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    instanceButton:GetHighlightTexture():SetTexCoord(0.34570313, 0.68554688, 0.33300781, 0.42675781)
    instanceButton.instance = instance

    instanceButton.bgImage = instanceButton:CreateTexture("$parentbgImage", "BACKGROUND")
    instanceButton.bgImage:SetPoint("TOPLEFT", 0, 0)
    instanceButton.bgImage:SetPoint("BOTTOMRIGHT", 0, 0)
    instanceButton.bgImage:SetTexture("Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-" .. instance.name)
    instanceButton.bgImage:SetTexCoord(0, 0.68359375, 0, 0.7421875)

    instanceButton.name = instanceButton:CreateFontString("$parentName", "OVERLAY", "QuestTitleFontBlackShadow")
    instanceButton.name:SetSize(150, 0)
    instanceButton.name:SetPoint("TOP", 0, -15)
    if instance then
        instanceButton.name:SetText(instance.title)
    end

    instanceButton.range = instanceButton:CreateFontString("$parentRange", "OVERLAY", "GameFontNormal")
    instanceButton.range:SetSize(100, 12)
    instanceButton.range:SetPoint("BOTTOMLEFT", 7, 7)
    instanceButton.range:SetJustifyH("LEFT")

    if instance and instance.recommended then
        instanceButton.range:SetText(instance.recommended[1] .. "-" .. instance.recommended[2])
    else
        instanceButton.range:Hide()
    end

    instanceButton:SetScript("OnClick", function()
        DJ:SelectInstance(instance.id)
        PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN)
    end)

    return instanceButton
end

function DJ:CreateEncounterFrame(parent)
    local frame = CreateFrame("Frame", "$parentEncounterFrame", parent)
    frame:SetPoint("TOPLEFT", "$parentInset", 0, 0)
    frame:SetPoint("BOTTOMRIGHT", "$parentInset", -3, 0)

    frame.instance = CreateFrame("Frame", "$parentInstanceFrame", frame)
    frame.instance:SetSize(390, 425)
    frame.instance:SetPoint("BOTTOMRIGHT", -1, 2)

    frame.instance.loreBG = frame.instance:CreateTexture("$parentBG", "BACKGROUND", nil, 1)
    frame.instance.loreBG:SetSize(390, 336)
    frame.instance.loreBG:SetPoint("TOP", 3, -9)
    frame.instance.loreBG:SetTexture("Interface\\EncounterJournal\\UI-EJ-LOREBG-Default")
    frame.instance.loreBG:SetTexCoord(0, 0.7617187, 0, 0.65625)

    frame.instance.title = frame.instance:CreateFontString("$parentTitle", "OVERLAY", "QuestFont_Super_Huge")
    frame.instance.title:SetSize(320, 10)
    frame.instance.title:SetPoint("TOP", 0, -72)
    frame.instance.title:SetJustifyH("CENTER")
    frame.instance.title:SetJustifyV("BOTTOM")

    frame.instance.titleBG = frame.instance:CreateTexture("$parentBG", "BACKGROUND", nil, 5)
    frame.instance.titleBG:SetSize(256, 64)
    frame.instance.titleBG:SetPoint("TOP", "$parentBG", 0, -38)
    frame.instance.titleBG:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.instance.titleBG:SetTexCoord(0.34570313, 0.84570313, 0.42871094, 0.49121094)

    frame.instance.mapButton = CreateFrame("Button", "$parentMapButton", frame.instance)
    frame.instance.mapButton:SetSize(48, 32)
    frame.instance.mapButton:SetPoint("BOTTOMLEFT", 33, 126)

    frame.instance.mapButton.shadow = frame.instance.mapButton:CreateTexture("$parentShadow", "BACKGROUND")
    frame.instance.mapButton.shadow:SetSize(171, 50)
    frame.instance.mapButton.shadow:SetPoint("LEFT", -3, 5)
    frame.instance.mapButton.shadow:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.instance.mapButton.shadow:SetTexCoord(0.00195313, 0.33593750, 0.85253906, 0.90136719)

    frame.instance.mapButton.text = frame.instance.mapButton:CreateFontString("$parentText", "ARTWORK", "GameFontNormal")
    frame.instance.mapButton.text:SetSize(0, 0)
    frame.instance.mapButton.text:SetPoint("LEFT", frame.instance.mapButton, "RIGHT", 2, 0)
    frame.instance.mapButton.text:SetJustifyH("LEFT")
    frame.instance.mapButton.text:SetText(SHOW_MAP)

    frame.instance.mapButton.texture = frame.instance.mapButton:CreateTexture("$parentTexture", "ARTWORK")
    frame.instance.mapButton.texture:SetSize(48, 32)
    frame.instance.mapButton.texture:SetPoint("RIGHT")
    frame.instance.mapButton.texture:SetTexture("Interface\\QuestFrame\\UI-QuestMap_Button")
    frame.instance.mapButton.texture:SetTexCoord(0.125, 0.875, 0.0, 0.5)

    frame.instance.mapButton.highlight = frame.instance.mapButton:CreateTexture("$parentHighlight", "HIGHLIGHT")
    frame.instance.mapButton.highlight:SetSize(36, 25)
    frame.instance.mapButton.highlight:SetPoint("RIGHT", -7, 0)
    frame.instance.mapButton.highlight:SetTexture("Interface\\BUTTONS\\ButtonHilight-Square")
    frame.instance.mapButton.highlight:SetBlendMode("ADD")

    frame.instance.mapButton:SetScript("OnClick", function()
        local mapID = nil -- TODO: add map ID for each instance
        if mapID and mapID > 0 then
            OpenWorldMap(mapID)
        end
    end)
    frame.instance.mapButton:SetScript("OnMouseDown", function(self)
        self.texture:SetTexCoord(0.125, 0.875, 0.5, 1.0)
    end)
    frame.instance.mapButton:SetScript("OnMouseUp", function(self)
        self.texture:SetTexCoord(0.125, 0.875, 0.0, 0.5)
    end)

    frame.instance.loreScroll = DJ:CreateScrollFrame(frame.instance, "$parentLoreScrollFrame", 315, 102)
    frame.instance.loreScroll:SetPoint("BOTTOM", 0, 5)
    frame.instance.loreScroll.ScrollBar.trackBG:SetAlpha(0)

    frame.instance.loreScroll.child.lore = frame.instance.loreScroll.child:CreateFontString("$parentLore", "ARTWORK", "GameFontBlack")
    frame.instance.loreScroll.child.lore:SetSize(300, 0)
    frame.instance.loreScroll.child.lore:SetPoint("TOPLEFT", 5, -5)
    frame.instance.loreScroll.child.lore:SetTextColor(0.13, 0.07, 0.01)
    frame.instance.loreScroll.child.lore:SetJustifyH("LEFT")

    frame.info = CreateFrame("Frame", "$parentInfo", frame)
    frame.info:SetSize(785, 425)
    frame.info:SetPoint("BOTTOMRIGHT", -1, 2)

    frame.info.bg = frame.info:CreateTexture("$parentBG", "BACKGROUND")
    frame.info.bg:SetSize(785, 425)
    frame.info.bg:SetPoint("BOTTOMRIGHT")
    frame.info.bg:SetTexture("Interface\\EncounterJournal\\UI-EJ-JournalBG")
    frame.info.bg:SetTexCoord(0, 0.766601562, 0, 0.830078125)

    frame.info.leftShadow = frame.info:CreateTexture("$parentLeftHeaderShadow", "BACKGROUND", nil, 3)
    frame.info.leftShadow:SetSize(386, 39)
    frame.info.leftShadow:SetPoint("TOPLEFT", 0, -11)
    frame.info.leftShadow:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.leftShadow:SetTexCoord(0, 0.755859375, 0.9599609375, 1)

    frame.info.rightShadow = frame.info:CreateTexture("$parentRightHeaderShadow", "BACKGROUND", nil, 3)
    frame.info.rightShadow:SetSize(386, 39)
    frame.info.rightShadow:SetPoint("TOPRIGHT", 0, -11)
    frame.info.rightShadow:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.rightShadow:SetTexCoord(0.755859375, 0, 0.9599609375, 1)
    frame.info.rightShadow:Hide()

    frame.info.encounterTitle = frame.info:CreateFontString("$parentEncounterTitle", "OVERLAY", "GameFontNormalLarge")
    frame.info.encounterTitle:SetSize(227, 12)
    frame.info.encounterTitle:SetPoint("BOTTOMLEFT", frame.info, "TOPRIGHT", -350, -36)
    frame.info.encounterTitle:SetTextColor(0.902, 0.788, 0.671)
    frame.info.encounterTitle:SetJustifyH("LEFT")

    frame.info.difficultyIcon = frame.info:CreateTexture("$parentDifficultyIcon", "OVERLAY")
    frame.info.difficultyIcon:SetSize(32, 32)
    frame.info.difficultyIcon:SetPoint("TOPLEFT", 55, -10)
    frame.info.difficultyIcon:SetTexture("Interface\\EncounterJournal\\UI-EJ-Icons")

    frame.info.instanceTitle = frame.info:CreateFontString("$parentInstanceTitle", "OVERLAY", "GameFontNormalLarge")
    frame.info.instanceTitle:SetSize(290, 12)
    frame.info.instanceTitle:SetPoint("LEFT", frame.info.difficultyIcon, "RIGHT", -4, 0)
    frame.info.instanceTitle:SetTextColor(0.902, 0.788, 0.671)
    frame.info.instanceTitle:SetJustifyH("LEFT")

    frame.info.instanceButton = CreateFrame("Button", "$parentInstanceButton", frame.info)
    frame.info.instanceButton:SetSize(64, 61)
    frame.info.instanceButton:SetPoint("TOPLEFT", 0, -3)
    frame.info.instanceButton.icon = frame.info.instanceButton:CreateTexture("$parentIcon", "BACKGROUND", nil, 6)
    frame.info.instanceButton.icon:SetSize(40, 40)
    frame.info.instanceButton.icon:SetPoint("CENTER")
    frame.info.instanceButton:SetNormalTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.instanceButton:GetNormalTexture():SetSize(64, 61)
    frame.info.instanceButton:GetNormalTexture():SetTexCoord(0.50585938, 0.63085938, 0.02246094, 0.08203125)
    frame.info.instanceButton:SetHighlightTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.instanceButton:GetHighlightTexture():SetSize(64, 61)
    frame.info.instanceButton:GetHighlightTexture():SetTexCoord(0.50585938, 0.63085938, 0.02246094, 0.08203125)
    frame.info.instanceButton:GetHighlightTexture():SetBlendMode("ADD")
    frame.info.instanceButton:SetScript("OnClick", function()
        DJ:SelectInstance(DJ.DungeonJournal.instanceId)
        PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN)
    end)

    frame.info.overviewTab = DJ:CreateEncounterInfoTab("$parentOverviewTab", frame.info)
    frame.info.overviewTab.id = 1
    frame.info.overviewTab:SetPoint("TOPLEFT", frame.info, "TOPRIGHT", -12, -35)

    frame.info.overviewTab.unselected = frame.info.overviewTab:CreateTexture("$parentUnselect", "OVERLAY")
    frame.info.overviewTab.unselected:SetSize(48, 43)
    frame.info.overviewTab.unselected:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.overviewTab.unselected:SetTexCoord(0.85546875, 0.94921875, 0.52441406, 0.56640625)
    frame.info.overviewTab.unselected:SetPoint("RIGHT", -6, 0)

    frame.info.overviewTab.selected = frame.info.overviewTab:CreateTexture("$parentSelect", "OVERLAY")
    frame.info.overviewTab.selected:SetSize(48, 43)
    frame.info.overviewTab.selected:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.overviewTab.selected:SetTexCoord(0.90234375, 0.99609375, 0.26953125, 0.31152344)
    frame.info.overviewTab.selected:SetPoint("CENTER", "$parentUnselect", 0, 0)
    frame.info.overviewTab.selected:Hide()

    frame.info.overviewTab.tooltip = OVERVIEW
    frame.info.overviewTab:SetScript("OnClick", function(self)
        DJ:OpenEncounterInfoTab(1)
    end)

    frame.info.lootTab = DJ:CreateEncounterInfoTab("$parentLootTab", frame.info)
    frame.info.lootTab.id = 2
    frame.info.lootTab:SetPoint("TOP", "$parentOverviewTab", "BOTTOM", 0, 2)

    frame.info.lootTab.unselected = frame.info.lootTab:CreateTexture("$parentUnselect", "OVERLAY")
    frame.info.lootTab.unselected:SetSize(48, 43)
    frame.info.lootTab.unselected:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.lootTab.unselected:SetTexCoord(0.73046875, 0.82421875, 0.61816406, 0.66015625)
    frame.info.lootTab.unselected:SetPoint("RIGHT", -6, 0)

    frame.info.lootTab.selected = frame.info.lootTab:CreateTexture("$parentSelect", "OVERLAY")
    frame.info.lootTab.selected:SetSize(48, 43)
    frame.info.lootTab.selected:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.lootTab.selected:SetTexCoord(0.63281250, 0.72656250, 0.61816406, 0.66015625)
    frame.info.lootTab.selected:SetPoint("CENTER", "$parentUnselect", 0, 0)
    frame.info.lootTab.selected:Hide()

    frame.info.lootTab.tooltip = LOOT_NOUN
    frame.info.lootTab:SetScript("OnClick", function(self)
        DJ:OpenEncounterInfoTab(2)
    end)

    frame.info.bossTab = DJ:CreateEncounterInfoTab("$parentBossTab", frame.info)
    frame.info.bossTab.id = 3
    frame.info.bossTab:SetPoint("TOP", "$parentLootTab", "BOTTOM", 0, 2)

    frame.info.bossTab.unselected = frame.info.bossTab:CreateTexture("$parentUnselect", "OVERLAY")
    frame.info.bossTab.unselected:SetSize(48, 43)
    frame.info.bossTab.unselected:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.bossTab.unselected:SetTexCoord(0.904296875, 0.99609375, 0.70703125, 0.748046875)
    frame.info.bossTab.unselected:SetPoint("RIGHT", -6, 0)

    frame.info.bossTab.selected = frame.info.bossTab:CreateTexture("$parentSelect", "OVERLAY")
    frame.info.bossTab.selected:SetSize(48, 43)
    frame.info.bossTab.selected:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.bossTab.selected:SetTexCoord(0.806640625, 0.8984375, 0.70703125, 0.748046875)
    frame.info.bossTab.selected:SetPoint("CENTER", "$parentUnselect", 0, 0)
    frame.info.bossTab.selected:Hide()

    frame.info.bossTab.tooltip = ABILITIES
    frame.info.bossTab:SetScript("OnClick", function(self)
        DJ:OpenEncounterInfoTab(3)
    end)

    frame.info.modelTab = DJ:CreateEncounterInfoTab("$parentModelTab", frame.info)
    frame.info.modelTab.id = 4
    frame.info.modelTab:SetPoint("TOP", "$parentBossTab", "BOTTOM", 0, 2)

    frame.info.modelTab.unselected = frame.info.modelTab:CreateTexture("$parentUnselect", "OVERLAY")
    frame.info.modelTab.unselected:SetSize(48, 43)
    frame.info.modelTab.unselected:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.modelTab.unselected:SetTexCoord(0.90234375, 1, 0.662109375, 0.705078125)
    frame.info.modelTab.unselected:SetPoint("RIGHT", -6, 0)

    frame.info.modelTab.selected = frame.info.modelTab:CreateTexture("$parentSelect", "OVERLAY")
    frame.info.modelTab.selected:SetSize(48, 43)
    frame.info.modelTab.selected:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.modelTab.selected:SetTexCoord(0.8046875, 0.900390625, 0.662109375, 0.705078125)
    frame.info.modelTab.selected:SetPoint("CENTER", "$parentUnselect", 0, 0)
    frame.info.modelTab.selected:Hide()

    frame.info.modelTab.tooltip = MODEL
    frame.info.modelTab:SetScript("OnClick", function(self)
        DJ:OpenEncounterInfoTab(4)
    end)

    frame.info.tabs = {frame.info.overviewTab, frame.info.lootTab, frame.info.bossTab, frame.info.modelTab}

    frame.info.bossesScroll = DJ:CreateScrollFrame(frame.info, "$parentBossesScrollFrame", 363, 382)
    frame.info.bossesScroll:SetPoint("BOTTOMLEFT", 25, 1)
    frame.info.bossesScroll.ScrollBar:ClearAllPoints()
    frame.info.bossesScroll.ScrollBar:SetPoint("TOPRIGHT", 2, -17)
    frame.info.bossesScroll.ScrollBar:SetPoint("BOTTOMRIGHT", 2, 17)
    frame.info.bossesScroll.ScrollBar.trackBG:SetAlpha(0.25)
    frame.info.bossesScroll.ScrollBar.scrollStep = 30

    frame.info.bossesScroll.child.description = frame.info.bossesScroll.child:CreateFontString("$parentDescription", "ARTWORK", "GameFontBlack")
    frame.info.bossesScroll.child.description:SetSize(0, 0)
    frame.info.bossesScroll.child.description:SetPoint("TOPLEFT", 2, -8)
    frame.info.bossesScroll.child.description:SetTextColor(0.25, 0.1484375, 0.02)
    frame.info.bossesScroll.child.description:SetJustifyH("LEFT")

    frame.info.detailsScroll = DJ:CreateScrollFrame(frame.info, "$parentDetailsScrollFrame", 350, 383)
    frame.info.detailsScroll:SetPoint("BOTTOMRIGHT", -5, 1)
    frame.info.detailsScroll.ScrollBar:ClearAllPoints()
    frame.info.detailsScroll.ScrollBar:SetPoint("TOPRIGHT", 2, -17)
    frame.info.detailsScroll.ScrollBar:SetPoint("BOTTOMRIGHT", 2, 17)
    frame.info.detailsScroll.ScrollBar.trackBG:SetAlpha(0.25)
    frame.info.detailsScroll.ScrollBar.scrollStep = 30

    frame.info.detailsScroll.child.description = frame.info.detailsScroll.child:CreateFontString("$parentDescription", "ARTWORK", "GameFontBlack")
    frame.info.detailsScroll.child.description:SetSize(0, 0)
    frame.info.detailsScroll.child.description:SetPoint("TOPLEFT", 2, -8)
    frame.info.detailsScroll.child.description:SetTextColor(0.25, 0.1484375, 0.02)
    frame.info.detailsScroll.child.description:SetJustifyH("LEFT")

    frame.info.overviewScroll = DJ:CreateScrollFrame(frame.info, "$parentOverviewScrollFrame", 350, 383)
    frame.info.overviewScroll:SetPoint("BOTTOMRIGHT", -5, 1)
    frame.info.overviewScroll.ScrollBar:ClearAllPoints()
    frame.info.overviewScroll.ScrollBar:SetPoint("TOPRIGHT", 2, -17)
    frame.info.overviewScroll.ScrollBar:SetPoint("BOTTOMRIGHT", 2, 17)
    frame.info.overviewScroll.ScrollBar.trackBG:SetAlpha(0.25)
    frame.info.overviewScroll.ScrollBar.scrollStep = 30

    frame.info.overviewScroll.child:SetWidth(325)
    frame.info.overviewScroll.child.loreDescription = frame.info.overviewScroll.child:CreateFontString("$parentLoreDescription", "ARTWORK", "GameFontBlack")
    frame.info.overviewScroll.child.loreDescription:SetSize(0, 0)
    frame.info.overviewScroll.child.loreDescription:SetPoint("TOPLEFT", 2, -8)
    frame.info.overviewScroll.child.loreDescription:SetTextColor(0.25, 0.1484375, 0.02)
    frame.info.overviewScroll.child.loreDescription:SetJustifyH("LEFT")

    frame.info.overviewScroll.child.header = frame.info.overviewScroll.child:CreateTexture("$parentHeader", "ARTWORK")
    frame.info.overviewScroll.child.header:SetSize(327, 30)
    frame.info.overviewScroll.child.header:SetPoint("TOPLEFT", "$parentLoreDescription", "BOTTOMLEFT", -5, -6)
    frame.info.overviewScroll.child.header:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.overviewScroll.child.header:SetTexCoord(0.359375, 0.99609375, 0.8525390625, 0.880859375)

    frame.info.overviewScroll.child.title = frame.info.overviewScroll.child:CreateFontString("$parentTitle", "ARTWORK", "GameFontBlack")
    frame.info.overviewScroll.child.title:SetSize(200, 10)
    frame.info.overviewScroll.child.title:SetPoint("BOTTOMLEFT", "$parentHeader", "BOTTOMLEFT", 8, 6)
    frame.info.overviewScroll.child.title:SetTextColor(0.929, 0.788, 0.620)
    frame.info.overviewScroll.child.title:SetJustifyH("LEFT")
    frame.info.overviewScroll.child.title:SetShadowOffset(1, -1)
    frame.info.overviewScroll.child.title:SetText(OVERVIEW)

    frame.info.overviewScroll.child.overviewDescription = CreateFrame("Frame", "$parentDescription", frame.info.overviewScroll.child)
    frame.info.overviewScroll.child.overviewDescription:SetSize(95, 10)
    frame.info.overviewScroll.child.overviewDescription:SetPoint("TOP", "$parentHeader", "BOTTOM", 0, -6)
    frame.info.overviewScroll.child.overviewDescription.Text = CreateFrame("SimpleHTML", nil, frame.info.overviewScroll.child.overviewDescription, "InlineHyperlinkFrameTemplate")
    -- TODO: fontstring
    -- frame.info.overviewScroll.child.overviewDescription.Text: 

    frame.info.lootScroll = DJ:CreateScrollFrame(frame.info, "$parentLootScrollFrame", 350, 383)
    frame.info.lootScroll:SetPoint("BOTTOMRIGHT", -5, 1)
    frame.info.lootScroll.ScrollBar:ClearAllPoints()
    frame.info.lootScroll.ScrollBar:SetPoint("TOPRIGHT", 2, -17)
    frame.info.lootScroll.ScrollBar:SetPoint("BOTTOMRIGHT", 2, 17)
    frame.info.lootScroll.ScrollBar.trackBG:SetAlpha(0.25)
    frame.info.lootScroll.ScrollBar.scrollStep = 30

    frame.info.model = CreateFrame("PlayerModel", "$parentModelFrame", frame.info, "ModelTemplate")
    frame.info.model:SetSize(390, 423)
    frame.info.model:SetPoint("BOTTOMRIGHT", -3, 1)
    frame.info.model.dungeonBG = frame.info.model:CreateTexture("$parentDungeonBG", "BACKGROUND", nil, 1)
    frame.info.model.dungeonBG:SetSize(405, 425)
    frame.info.model.dungeonBG:SetPoint("BOTTOMRIGHT", 0, -2)
    frame.info.model.dungeonBG:SetTexture("Interface\\EncounterJournal\\UI-EJ-BACKGROUND-Default")
    frame.info.model.dungeonBG:SetTexCoord(0.80953125, 0, 0, 0.830078125)
    frame.info.model.shadow = frame.info.model:CreateTexture("$parentShadow", "OVERLAY")
    frame.info.model.shadow:SetSize(393, 424)
    frame.info.model.shadow:SetPoint("BOTTOMRIGHT", 3, 0)
    frame.info.model.shadow:SetTexture("Interface\\EncounterJournal\\UI-EJ-BossModelPaperFrame")
    frame.info.model.shadow:SetTexCoord(0.767578125, 0, 0, 0.828125)
    frame.info.model.shadow:Hide() -- TODO: align shadow properly
    frame.info.model.titleBG = frame.info.model:CreateTexture("$parentTitleBG", "OVERLAY", nil, 1)
    frame.info.model.titleBG:SetSize(395, 63)
    frame.info.model.titleBG:SetPoint("BOTTOM", 0, -2)
    frame.info.model.titleBG:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    frame.info.model.titleBG:SetTexCoord(0.00195313, 0.77343750, 0.26953125, 0.33105469)
    frame.info.model.imageTitle = frame.info.model:CreateFontString("$parentImageTile", "OVERLAY", "QuestTitleFontBlackShadow", 2)
    frame.info.model.imageTitle:SetSize(380, 10)
    frame.info.model.imageTitle:SetPoint("BOTTOM", 0, 6)
    frame.info.model.imageTitle:SetJustifyH("CENTER")
    frame.info.model:Hide()

    frame.overviewFrame = frame.info.overviewScroll.child
    frame.overviewFrame.isOverview = true
    frame.overviewFrame.overviews = {}

    frame.infoFrame = frame.info.detailsScroll.child
    frame.bossesFrame = frame.info.bossesScroll.child
    frame.lootFrame = frame.info.lootScroll.child

    frame:Hide()

    return frame
end

function DJ:CreateEncounterInfoTab(name, parent)
    local tab = CreateFrame("Button", name, parent)
    tab:SetSize(63, 57)
    tab:SetFrameLevel(510)
    tab:SetNormalTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab:GetNormalTexture():SetTexCoord(0.25585938, 0.37890625, 0.90332031, 0.95898438)
    tab:SetPushedTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab:GetPushedTexture():SetTexCoord(0.12890625, 0.25195313, 0.90332031, 0.95898438)
    tab:SetDisabledTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab:GetDisabledTexture():SetTexCoord(0.25585938, 0.37890625, 0.90332031, 0.95898438)
    tab:SetHighlightTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    tab:GetHighlightTexture():SetTexCoord(0.00195313, 0.12500000, 0.90332031, 0.95898438)
    tab:GetHighlightTexture():SetBlendMode("ADD")

    tab:SetScript("OnClick", function(self)
        DJ:OpenEncounterInfoTab(self.id)
    end)
    tab:SetScript("OnEnter", function(self)
        if self.tooltip then
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
            GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
            GameTooltip:Show()
        end
    end)
    tab:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    return tab
end

function DJ:SetEncounterInfoTabEnabled(tab, enabled)
    tab:SetEnabled(enabled)
    tab:GetDisabledTexture():SetDesaturated(not enabled)
    tab.unselected:SetDesaturated(not enabled)
    if not enabled then
        -- EncounterJournal_ValidateSelectedTab()
    end
end

function DJ:OpenEncounterInfoTab(id)
    local instanceSelect = DJ.DungeonJournal.instanceSelect
    local encounter = DJ.DungeonJournal.encounter
    local info = DJ.DungeonJournal.encounter.info
    local boss = DJ.Database:GetBossById(DJ.DungeonJournal.bossId)

    local selectedTab
    for _, tab in next, info.tabs do
        if tab.id == id then
            tab.selected:Show()
            tab.unselected:Show()
            tab:LockHighlight()
            selectedTab = tab
        else
            tab.selected:Hide()
            tab.unselected:Show()
            tab:UnlockHighlight()
        end
    end

    encounter.instance:Hide()
    encounter.overviewFrame.loreDescription:SetHeight(0)
    encounter.overviewFrame.loreDescription:SetWidth(encounter.overviewFrame:GetWidth() - 5)
    encounter.overviewFrame.loreDescription:SetText(boss.lore or "")

    if id == info.overviewTab.id then
        encounter:Show()
        encounter.info.overviewScroll:Show()
        encounter.info.detailsScroll:Hide()
        encounter.info.lootScroll:Hide()
        encounter.info.rightShadow:Show()
        encounter.info.model:Hide()
        encounter.info.encounterTitle:Show()
    elseif id == info.bossTab.id then
        encounter:Show()
        encounter.info.overviewScroll:Hide()
        encounter.info.detailsScroll:Show()
        encounter.info.lootScroll:Hide()
        encounter.info.rightShadow:Show()
        encounter.info.model:Hide()
        encounter.info.encounterTitle:Show()
    elseif id == info.lootTab.id then
        encounter:Show()
        encounter.info.overviewScroll:Hide()
        encounter.info.detailsScroll:Hide()
        encounter.info.lootScroll:Show()
        encounter.info.rightShadow:Show()
        encounter.info.model:Hide()
        encounter.info.encounterTitle:Hide()
    elseif id == info.modelTab.id then
        encounter:Show()
        encounter.info.overviewScroll:Hide()
        encounter.info.detailsScroll:Hide()
        encounter.info.lootScroll:Hide()
        encounter.info.rightShadow:Hide()
        encounter.info.model:Show()
        encounter.info.encounterTitle:Hide()
    end
end

function DJ:CreateBossButton(boss, parent)
    local bossButton = CreateFrame("Button", "$parentBossButton" .. boss.id, parent)
    bossButton:SetSize(325, 55)
    bossButton:SetNormalTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    bossButton:GetNormalTexture():SetTexCoord(0.00195313, 0.63671875, 0.21386719, 0.26757813)
    bossButton:SetPushedTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    bossButton:GetPushedTexture():SetTexCoord(0.00195313, 0.63671875, 0.10253906, 0.15625000)
    bossButton:SetHighlightTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    bossButton:GetHighlightTexture():SetTexCoord(0.00195313, 0.63671875, 0.15820313, 0.21191406)
    bossButton.boss = boss

    bossButton.DefeatedOverlay = CreateFrame("Button", nil, bossButton)
    bossButton.DefeatedOverlay:SetSize(16, 16)
    bossButton.DefeatedOverlay:SetPoint("BOTTOMLEFT", 4, 0)
    bossButton.DefeatedOverlay:SetFrameLevel(150)
    bossButton.DefeatedOverlay:Hide()

    bossButton.creatureFrame = CreateFrame("Frame", nil, bossButton)
    bossButton.creatureFrame:SetSize(1, 1)
    bossButton.creatureFrame:SetPoint("TOPLEFT", -4, 13)
    bossButton.creatureFrame.creature = bossButton.creatureFrame:CreateTexture("$parentCreature", "OVERLAY")
    bossButton.creatureFrame.creature:SetSize(128, 64)
    bossButton.creatureFrame.creature:SetPoint("TOPLEFT", 0, 0)
    bossButton.creatureFrame.creature:SetTexture("Interface\\EncounterJournal\\UI-EJ-BOSS-" .. (boss.imageName or boss.name))
    bossButton.creature = bossButton.creatureFrame.creature

    bossButton.text = bossButton:CreateFontString("$parentName", "OVERLAY", "GameFontNormalMed3")
    bossButton.text:SetSize(160, 40)
    bossButton.text:SetPoint("LEFT", 105, -3)
    bossButton.text:SetTextColor(0.827, 0.659, 0.463)
    bossButton:SetFontString(bossButton.text)
    bossButton:SetText(boss.name) -- TODO: translate boss name

    bossButton:SetScript("OnClick", function()
        DJ:SelectBoss(boss.id)
    end)
    bossButton:SetScript("OnEnter", function(self)
        self.hover = true
        self.text:SetTextColor(0.973, 0.902, 0.581)
    end)
    bossButton:SetScript("OnLeave", function(self)
        self.hover = false
        if not self.isSelected then
            self.text:SetTextColor(0.827, 0.659, 0.463)
        end
    end)

    return bossButton
end

function DJ:ListBosses(instance)
    local parent = DJ.DungeonJournal.encounter.bossesFrame
    if not parent.BossButtons then
        parent.BossButtons = {}
    end

    if instance.bosses then
        local previousButton
        for i, boss in next, instance.bosses do
            local bossButton = parent.BossButtons[boss.name]
            if not bossButton then
                bossButton = DJ:CreateBossButton(boss, parent)
                parent.BossButtons[boss.name] = bossButton
            end

            if i == 1 then
                bossButton:SetPoint("TOPLEFT", 0, -10)
            else
                bossButton:SetPoint("TOPLEFT", previousButton, "BOTTOMLEFT", 0, -15)
            end

            bossButton:Show()
            bossButton.creatureFrame:Show()
            previousButton = bossButton
        end

        if previousButton then
            parent:SetHeight(10 + #instance.bosses * previousButton:GetHeight())
        end
    else
        parent:SetHeight(0)
    end

    DJ:HideOtherBosses(instance)
end

function DJ:HideOtherBosses(instance)
    local parent = DJ.DungeonJournal.encounter.info.bossesScroll.child
    if not parent.BossButtons then
        return
    end

    for name, button in next, parent.BossButtons do
        if button:IsShown() and not DJ.Database:IsBossInInstance(name, instance) then
            button:Hide()
        end
    end
end

function DJ:SelectBoss(id)
    local boss = DJ.Database:GetBossById(id)
    if boss then
        local encounter = DJ.DungeonJournal.encounter
        local noButton
        if DJ.DungeonJournal.bossId == boss.id then
            noButton = true
        elseif DJ.DungeonJournal.instanceId then
            NavBar_OpenTo(DJ.DungeonJournal.navBar, DJ.DungeonJournal.instanceId)
        end

        local bossButton = encounter.bossesFrame.BossButtons[boss.name]
        if bossButton then
            bossButton:LockHighlight()
        end

        DJ.DungeonJournal.bossId = boss.id

        encounter.info.encounterTitle:Show()
        encounter.info.encounterTitle:SetText(boss.name)
        encounter.info.model.imageTitle:SetText(boss.name)
        if boss.displayId then
            encounter.info.model:SetDisplayInfo(boss.displayId)
            encounter.info.model:SetRotation(MODELFRAME_DEFAULT_ROTATION)
            if boss.displayPosition then
                encounter.info.model:SetPosition(unpack(boss.displayPosition))
            else
                encounter.info.model:SetPosition(0, 0, 0)
            end
            encounter.info.model:Show()
            DJ:SetEncounterInfoTabEnabled(encounter.info.modelTab, true)
        else
            DJ:SetEncounterInfoTabEnabled(encounter.info.modelTab, false)
            encounter.info.model:Hide()
        end

        -- enable tabs
        DJ:SetEncounterInfoTabEnabled(encounter.info.overviewTab, true)
        DJ:SetEncounterInfoTabEnabled(encounter.info.bossTab, true)
        DJ:SetEncounterInfoTabEnabled(encounter.info.lootTab, true)

        -- show overview tab when first selecting boss
        DJ:OpenEncounterInfoTab(1)
        DJ:ListItems(boss)

        if not noButton then
            local buttonData = {
                id = boss.id,
                name = boss.name,
                OnClick = DJ.RefreshBoss,
                listFunc = function()
                    return DJ:GetNavBossList(DJ.DungeonJournal.instanceId)
                end
            }
            NavBar_AddButton(DJ.DungeonJournal.navBar, buttonData)
        end
    end

    -- lock/unlock highlight
    for _, button in next, DJ.DungeonJournal.encounter.bossesFrame.BossButtons do
        if button.boss == boss then
            button.text:SetTextColor(0.973, 0.902, 0.581)
            button.isSelected = true
            button:LockHighlight()
        else
            button.isSelected = false
            if not button.hover then
                button.text:SetTextColor(0.827, 0.659, 0.463)
            end
            button:UnlockHighlight()
        end
    end
end

function DJ:RefreshBoss()
    DJ:SelectInstance(DJ.DungeonJournal.bossId)
end

function DJ:GetNavBossList(instanceId)
    local instance = DJ.Database:GetInstanceById(instanceId)
    local bosses = {}
    for i, boss in ipairs(instance.bosses) do
        table.insert(bosses, {
            text = boss.name,
            id = boss.id,
            func = function()
                DJ:SelectBoss(boss.id)
            end
        })
    end
    return bosses
end

function DJ:CreateBossButton(boss, parent)
    local bossButton = CreateFrame("Button", "$parentBossButton" .. boss.id, parent)
    bossButton:SetSize(325, 55)
    bossButton:SetNormalTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    bossButton:GetNormalTexture():SetTexCoord(0.00195313, 0.63671875, 0.21386719, 0.26757813)
    bossButton:SetPushedTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    bossButton:GetPushedTexture():SetTexCoord(0.00195313, 0.63671875, 0.10253906, 0.15625000)
    bossButton:SetHighlightTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    bossButton:GetHighlightTexture():SetTexCoord(0.00195313, 0.63671875, 0.15820313, 0.21191406)
    bossButton.boss = boss

    bossButton.DefeatedOverlay = CreateFrame("Button", nil, bossButton)
    bossButton.DefeatedOverlay:SetSize(16, 16)
    bossButton.DefeatedOverlay:SetPoint("BOTTOMLEFT", 4, 0)
    bossButton.DefeatedOverlay:SetFrameLevel(150)
    bossButton.DefeatedOverlay:Hide()

    bossButton.creatureFrame = CreateFrame("Frame", nil, bossButton)
    bossButton.creatureFrame:SetSize(1, 1)
    bossButton.creatureFrame:SetPoint("TOPLEFT", -4, 13)
    bossButton.creatureFrame.creature = bossButton.creatureFrame:CreateTexture("$parentCreature", "OVERLAY")
    bossButton.creatureFrame.creature:SetSize(128, 64)
    bossButton.creatureFrame.creature:SetPoint("TOPLEFT", 0, 0)
    bossButton.creatureFrame.creature:SetTexture("Interface\\EncounterJournal\\UI-EJ-BOSS-" .. (boss.imageName or boss.name))
    bossButton.creature = bossButton.creatureFrame.creature

    bossButton.text = bossButton:CreateFontString("$parentName", "OVERLAY", "GameFontNormalMed3")
    bossButton.text:SetSize(160, 40)
    bossButton.text:SetPoint("LEFT", 105, -3)
    bossButton.text:SetTextColor(0.827, 0.659, 0.463)
    bossButton:SetFontString(bossButton.text)
    bossButton:SetText(boss.name) -- TODO: translate boss name

    bossButton:SetScript("OnClick", function()
        DJ:SelectBoss(boss.id)
    end)
    bossButton:SetScript("OnEnter", function(self)
        self.hover = true
        self.text:SetTextColor(0.973, 0.902, 0.581)
    end)
    bossButton:SetScript("OnLeave", function(self)
        self.hover = false
        if not self.isSelected then
            self.text:SetTextColor(0.827, 0.659, 0.463)
        end
    end)

    return bossButton
end

function DJ:ListItems(boss)
    local parent = DJ.DungeonJournal.encounter.lootFrame
    if not parent.ItemButtons then
        parent.ItemButtons = {}
    end

    -- TODO: reuse buttons rather than creating a new one for each unique item
    if boss.items then
        local previousButton
        for i, item in ipairs(boss.items) do
            local itemId = item[1]
            local itemButton = parent.ItemButtons[itemId]
            if not itemButton then
                itemButton = DJ:CreateItemButton(item, parent, boss)
                parent.ItemButtons[itemId] = itemButton
            end

            if i == 1 then
                itemButton:SetPoint("TOPLEFT", 0, -10)
            else
                itemButton:SetPoint("TOPLEFT", previousButton, "BOTTOMLEFT", 0, 0)
            end

            itemButton:Show()
            previousButton = itemButton
        end

        if previousButton then
            parent:SetHeight(10 + #boss.items * previousButton:GetHeight())
        end
    end

    DJ:HideOtherItems(boss)
end

function DJ:HideOtherItems(boss)
    local parent = DJ.DungeonJournal.encounter.lootFrame
    if not parent.ItemButtons then
        return
    end

    for name, button in next, parent.ItemButtons do
        if button:IsShown() and not DJ.Database:BossDropsItem(boss, button.item[1]) then
            button:Hide()
        end
    end
end

function DJ:CreateItemButton(item, parent)
    local itemId = item[1]
    local itemButton = CreateFrame("Button", "$parentItemButton" .. itemId, parent)
    itemButton:SetSize(325, 55)
    itemButton.item = item

    itemButton.icon = itemButton:CreateTexture("$parentIcon", "BACKGROUND")
    itemButton.icon:SetSize(42, 42)
    itemButton.icon:SetPoint("TOPLEFT", itemButton, "TOPLEFT", 2, -2)

    itemButton.bossTexture = itemButton:CreateTexture("$parentIcon", "BORDER")
    itemButton.bossTexture:SetSize(369, 64)
    itemButton.bossTexture:SetPoint("CENTER", 24, 0)
    itemButton.bossTexture:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    itemButton.bossTexture:SetTexCoord(0.00195313, 0.72265625, 0.52441406, 0.58691406)

    itemButton.bosslessTexture = itemButton:CreateTexture("$parentIcon", "BORDER")
    itemButton.bosslessTexture:SetSize(321, 45)
    itemButton.bosslessTexture:SetPoint("CENTER", 0, 0)
    itemButton.bosslessTexture:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
    itemButton.bosslessTexture:SetTexCoord(0.00195313, 0.62890625, 0.61816406, 0.66210938)

    itemButton.name = itemButton:CreateFontString("$parentName", "OVERLAY", "GameFontNormalMed3")
    itemButton.name:SetSize(250, 12)
    itemButton.name:SetPoint("TOPLEFT", "$parentIcon", "TOPRIGHT", 7, -7)
    itemButton.name:SetJustifyH("LEFT")

    itemButton.armorType = itemButton:CreateFontString("$parentArmorClass", "OVERLAY", "GameFontBlack")
    itemButton.armorType:SetSize(0, 12)
    itemButton.armorType:SetPoint("BOTTOMRIGHT", "$parentName", "TOPLEFT", 264, -30)
    itemButton.armorType:SetJustifyH("RIGHT")
    itemButton.armorType:SetTextColor(0.25, 0.1484375, 0.02)

    itemButton.slot = itemButton:CreateFontString("$parentSlot", "OVERLAY", "GameFontBlack")
    itemButton.slot:SetSize(0, 12)
    itemButton.slot:SetPoint("BOTTOMLEFT", "$parentIcon", "BOTTOMRIGHT", 7, 5)
    itemButton.slot:SetPoint("BOTTOMRIGHT", "$parentArmorClass", "BOTTOMLEFT", -15, 0)
    itemButton.slot:SetJustifyH("LEFT")
    itemButton.slot:SetTextColor(0.25, 0.1484375, 0.02)

    itemButton.boss = itemButton:CreateFontString("$parentBoss", "OVERLAY", "GameFontBlack")
    itemButton.boss:SetSize(0, 12)
    itemButton.boss:SetPoint("TOPLEFT", "$parentIcon", "BOTTOMLEFT", 0, -3)
    itemButton.boss:SetJustifyH("LEFT")
    itemButton.boss:SetTextColor(0.25, 0.1484375, 0.02)

    itemButton.IconBorder = itemButton:CreateTexture("$parentIcon", "OVERLAY", nil, 1)
    itemButton.IconBorder:SetSize(37, 37)
    itemButton.IconBorder:SetPoint("TOPLEFT", "$parentIcon", "TOPLEFT")
    itemButton.IconBorder:SetPoint("BOTTOMRIGHT", "$parentIcon", "BOTTOMRIGHT")
    itemButton.IconBorder:SetTexture("Interface\\Common\\WhiteIconFrame")

    local bosses = DJ.Database:GetBossesThatDropItem(itemId, DJ.DungeonJournal.instanceId)
    local bossCount = #bosses
    if bossCount > 0 then
        itemButton:SetHeight(64)
        itemButton.bosslessTexture:Hide()

        if bossCount == 1 then
            itemButton.boss:SetFormattedText(BOSS_INFO_STRING, bosses[1].name)
        elseif bossCount == 2 then
            itemButton.boss:SetFormattedText(BOSS_INFO_STRING_TWO, bosses[1].name, bosses[2].name)
        else
            itemButton.boss:SetFormattedText(BOSS_INFO_STRING_MANY, bosses[1].name)
        end
    else
        itemButton:SetHeight(45)
        itemButton.bossTexture:Hide()
        itemButton.boss:Hide()
    end

    local itemQuery = Item:CreateFromItemID(itemId)
    itemQuery:ContinueOnItemLoad(function()
        local link = itemQuery:GetItemLink()
        local name, _, quality, _, _, type, subType, _, slot, icon, _, class, subClass = GetItemInfo(link)
        local r, g, b = GetItemQualityColor(quality)

        itemButton.itemLink = link
        itemButton.name:SetText(Addon:Hex(r, g, b) .. name .. "|r")
        itemButton.icon:SetTexture(icon)
        itemButton.slot:SetText(_G[slot])
        if subClass ~= LE_ITEM_MISCELLANEOUS_JUNK then
            itemButton.armorType:SetText(subType)
        end

        if quality > 1 then
            itemButton.IconBorder:Show()
            itemButton.IconBorder:SetVertexColor(r, g, b)
        else
            itemButton.IconBorder:Hide()
        end
    end)

    itemButton:SetScript("OnClick", function()
    end)
    itemButton:SetScript("OnEnter", function(self)
        if self.itemLink then
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:SetAnchorType("ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(self.itemLink)

            if IsShiftKeyDown() then
                GameTooltip_ShowCompareItem()
            end
        end
    end)
    itemButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    return itemButton
end
