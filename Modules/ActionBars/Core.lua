local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local AB = Addon.Modules.ActionBars
AB.bars = {}

function AB:OnEnable()
    AB.bars.MainMenuBar = AB:CreateMainMenuBar()
    AB.bars.MultiBarBottomLeft = AB:CreateMultiBarBottomLeft()
    AB.bars.MultiBarBottomRight = AB:CreateMultiBarBottomRight()
    AB.bars.MultiBarRight = AB:CreateMultiBarRight()
    AB.bars.MultiBarLeft = AB:CreateMultiBarLeft()
    AB.bars.StanceBar = AB:CreateStanceBar()
    AB.bars.PetActionBar = AB:CreatePetActionBar()
    AB.bars.VehicleExitBar = AB:CreateVehicleExitBar()
    AB.bars.ExperienceBar = AB:CreateExperienceBar()
    AB.bars.ReputationBar = AB:CreateReputationBar()
    AB.bars.MaxLevelBar = AB:CreateMaxLevelBar()
    AB.bars.MicroButtonAndBagsBar = AB:CreateMicroButtonAndBagsBar()

    AB:RegisterEvent("PLAYER_ENTERING_WORLD", AB.OnUpdate)
    AB:RegisterEvent("BAG_UPDATE", AB.OnBagUpdate)
    AB:SecureHook("MultiActionBar_Update", AB.OnUpdate)
    AB:SecureHook("MainMenuBar_UpdateExperienceBars", AB.OnUpdate)

    AB:UpdateMainMenuBarTextures()
end

function AB:OnUpdate()
    if AB.bars.MainMenuBar.PageNumber then
        AB.bars.MainMenuBar.PageNumber:SetText(GetActionBarPage())
    end

    AB:UpdateMainMenuBarTextures()

    if SHOW_MULTI_ACTIONBAR_1 and not AB.bars.MultiBarBottomLeft:IsShown() then
        AB.bars.MultiBarBottomLeft:Show()

        AB.bars.PetActionBar.__blizzardBar:SetParent(AB.bars.PetActionBar)
        AB.bars.PetActionBar.__blizzardBar:ClearAllPoints()
        AB.bars.PetActionBar.__blizzardBar:SetAllPoints()
        AB.bars.PetActionBar:ClearAllPoints()
        AB.bars.PetActionBar:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 40, 40)

        AB.bars.StanceBar.__blizzardBar:SetParent(AB.bars.StanceBar)
        AB.bars.StanceBar.__blizzardBar:ClearAllPoints()
        AB.bars.StanceBar.__blizzardBar:SetAllPoints()
        AB.bars.StanceBar:ClearAllPoints()
        AB.bars.StanceBar:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 30, 40)
    elseif not SHOW_MULTI_ACTIONBAR_1 and AB.bars.MultiBarBottomLeft:IsShown() then
        AB.bars.MultiBarBottomLeft:Hide()

        AB.bars.PetActionBar.__blizzardBar:SetParent(AB.bars.PetActionBar)
        AB.bars.PetActionBar.__blizzardBar:ClearAllPoints()
        AB.bars.PetActionBar.__blizzardBar:SetAllPoints()
        AB.bars.PetActionBar:ClearAllPoints()
        AB.bars.PetActionBar:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 40, 0)

        AB.bars.StanceBar.__blizzardBar:SetParent(AB.bars.StanceBar)
        AB.bars.StanceBar.__blizzardBar:ClearAllPoints()
        AB.bars.StanceBar.__blizzardBar:SetAllPoints()
        AB.bars.StanceBar:ClearAllPoints()
        AB.bars.StanceBar:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 30, 0)
    end

    if SHOW_MULTI_ACTIONBAR_2 and not AB.bars.MultiBarBottomRight:IsShown() then
        AB.bars.MultiBarBottomRight:Show()
        AB.bars.MainMenuBar.Texture:SetTexCoord(113 / 1024, (113 + 806) / 1024, 115 / 255, 165 / 255)
        AB.bars.MainMenuBar:SetWidth(806)
        AB.bars.MainMenuBar.Texture:SetWidth(806)

        AB.bars.ExperienceBar:SetSize(804, 11)
        MainMenuExpBar:SetSize(804, 11)
        AB:UpdateExperienceBarTextures()

        AB.bars.MaxLevelBar:SetSize(804, 11)
        MainMenuBarMaxLevelBar:SetSize(804, 11)
        AB:UpdateMaxLevelBarTextures()

        AB.bars.ReputationBar:SetSize(804, 11)
        ReputationWatchBar:SetSize(804, 11)
        ReputationWatchBar.StatusBar:SetSize(804, 11)
        AB:UpdateReputationBarTextures()
    elseif not SHOW_MULTI_ACTIONBAR_2 and AB.bars.MultiBarBottomRight:IsShown() then
        AB.bars.MultiBarBottomRight:Hide()
        AB.bars.MainMenuBar.Texture:SetTexCoord(113 / 1024, (113 + 552) / 1024, 64 / 255, 114 / 255)
        AB.bars.MainMenuBar:SetWidth(552)
        AB.bars.MainMenuBar.Texture:SetWidth(552)

        AB.bars.ExperienceBar:SetSize(550, 11)
        MainMenuExpBar:SetSize(550, 11)
        AB:UpdateExperienceBarTextures()

        AB.bars.MaxLevelBar:SetSize(550, 11)
        MainMenuBarMaxLevelBar:SetSize(550, 11)
        AB:UpdateMaxLevelBarTextures()

        AB.bars.ReputationBar:SetSize(550, 11)
        ReputationWatchBar:SetSize(550, 11)
        ReputationWatchBar.StatusBar:SetSize(550, 11)
        AB:UpdateReputationBarTextures()
    end

    if SHOW_MULTI_ACTIONBAR_3 and not AB.bars.MultiBarRight:IsShown() then
        AB.bars.MultiBarRight:Show()
    elseif not SHOW_MULTI_ACTIONBAR_3 and AB.bars.MultiBarRight:IsShown() then
        AB.bars.MultiBarRight:Hide()
    end

    if SHOW_MULTI_ACTIONBAR_4 and not AB.bars.MultiBarLeft:IsShown() then
        AB.bars.MultiBarLeft:Show()
    elseif not SHOW_MULTI_ACTIONBAR_4 and AB.bars.MultiBarLeft:IsShown() then
        AB.bars.MultiBarLeft:Hide()
    end

    if (TalentMicroButton and QuestLogMicroButton) then
        local widthOffset = 0
        local playerLevel = UnitLevel("player")
        if (playerLevel < SHOW_SPEC_LEVEL) then
            TalentMicroButton:Hide()
            QuestLogMicroButton:SetPoint("BOTTOMLEFT", "TalentMicroButton", "BOTTOMLEFT", 0, 0)
            widthOffset = 98
        else
            TalentMicroButton:Show()
            QuestLogMicroButton:SetPoint("BOTTOMLEFT", "TalentMicroButton", "BOTTOMRIGHT", 1, 0)
            widthOffset = 38 -- 37
        end

        if Addon.Modules.DungeonJournal then
            if not Addon.Modules.DungeonJournal.MicroButton:IsShown() then
                Addon.Modules.DungeonJournal.MicroButton:SetParent(AB.bars.MicroButtonAndBagsBar)
                Addon.Modules.DungeonJournal.MicroButton:SetPoint("BOTTOMLEFT", "WorldMapMicroButton", "BOTTOMRIGHT", 0, 0)
                Addon.Modules.DungeonJournal.MicroButton:Show()
                MainMenuMicroButton:ClearAllPoints()
                MainMenuMicroButton:SetPoint("BOTTOMLEFT", Addon.Modules.DungeonJournal.MicroButton, "BOTTOMRIGHT", 0, 0)
            end
            widthOffset = 10
        end

        AB.bars.MicroButtonAndBagsBar:SetSize(298 - widthOffset, 88)
        AB.bars.MicroButtonAndBagsBar.Texture:SetTexCoord((257 + widthOffset) / 1024, (257 + 286) / 1024, 168 / 255, 255 / 255)
        AB.bars.MicroButtonAndBagsBar.Texture:SetSize(286 - widthOffset, 88)
    end

    if KeyRingButton and not KeyRingButton:IsShown() then
        KeyRingButton:Show()
    end
end

function AB:OnBagUpdate()
    MainMenuBarBackpackButtonCount:ClearAllPoints()
    MainMenuBarBackpackButtonCount:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton, "BOTTOMRIGHT", -2, 4)
    MainMenuBarBackpackButtonCount:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    MainMenuBarBackpackButtonCount:SetText(format("(%d)", MainMenuBarBackpackButton.freeSlots))
end

function AB:DisableAllScripts(frame)
    local scripts = {"OnShow", "OnHide", "OnEvent", "OnEnter", "OnLeave", "OnUpdate", "OnValueChanged", "OnClick", "OnMouseDown", "OnMouseUp"}

    for _, script in next, scripts do
        if frame:HasScript(script) then
            frame:SetScript(script, nil)
        end
    end
end

function AB:HideBlizzardBar(framesToHide, framesToDisable)
    if framesToHide and type(framesToHide == "table") then
        for _, frame in next, framesToHide do
            frame:SetParent(Addon.HiddenFrame)
        end
    end
    if framesToDisable and type(framesToDisable == "table") then
        for _, frame in next, framesToDisable do
            frame:UnregisterAllEvents()
            AB:DisableAllScripts(frame)
        end
    end
end

function AB:SetupButton(button, frame, width, height, point, masqueGroup)
    if not frame.__blizzardBar then
        button:SetParent(frame)
    end
    button:SetSize(width, height)
    button:ClearAllPoints()
    button:SetPoint(unpack(point))

    if masqueGroup then
        masqueGroup:AddButton(button)
    end
end

function AB:CreateMicroButtonAndBagsBar()
    local config = AB.config.db.profile.microButtonAndBags

    local widthOffset = 0
    local playerLevel = UnitLevel("player")
    if (playerLevel < SHOW_SPEC_LEVEL) then
        widthOffset = 93
    else
        widthOffset = 47
    end

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "MicroMenuBar", UIParent, "SecureHandlerStateTemplate")
    frame:SetSize(298 - widthOffset, 88)
    frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

    frame.Texture = frame:CreateTexture("BACKGROUND")
    frame.Texture:SetTexture(Addon.media.textures.MainMenuBar)
    frame.Texture:SetTexCoord((257 + widthOffset) / 1024, (257 + 286) / 1024, 168 / 255, 255 / 255)
    frame.Texture:SetSize(286 - widthOffset, 88)
    frame.Texture:SetPoint("RIGHT", frame, "RIGHT", 0, 0)

    frame.TextureEndCap = frame:CreateTexture("BACKGROUND")
    frame.TextureEndCap:SetTexture(Addon.media.textures.MainMenuBar)
    frame.TextureEndCap:SetTexCoord(245 / 1024, (245 + 12) / 1024, 168 / 255, 255 / 255)
    frame.TextureEndCap:SetSize(12, 88)
    frame.TextureEndCap:SetPoint("LEFT", frame, "LEFT", 0, 0)

    local previous
    local buttonList = {MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot, KeyRingButton}

    for _, buttonName in next, MICRO_BUTTONS do
        local button = _G[buttonName]
        if button then
            local parent = frame
            local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 3}

            if previous then
                parent = previous
                point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 1, 0}
            end

            AB:SetupButton(button, parent, 28, 58, point)
            previous = button

            table.insert(buttonList, button)
        end
    end

    local masqueGroup
    if LibStub("Masque", true) then
        masqueGroup = LibStub("Masque", true):Group(AB.Title, "Bags", true)
    end

    AB:SetupButton(MainMenuBarBackpackButton, frame, 40, 40, {"BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 46}, masqueGroup)
    AB:SetupButton(CharacterBag0Slot, frame, 30, 30, {"BOTTOMRIGHT", MainMenuBarBackpackButton, "BOTTOMLEFT", -3, 0}, masqueGroup)
    AB:SetupButton(CharacterBag1Slot, frame, 30, 30, {"BOTTOMRIGHT", CharacterBag0Slot, "BOTTOMLEFT", -2, 0}, masqueGroup)
    AB:SetupButton(CharacterBag2Slot, frame, 30, 30, {"BOTTOMRIGHT", CharacterBag1Slot, "BOTTOMLEFT", -2, 0}, masqueGroup)
    AB:SetupButton(CharacterBag3Slot, frame, 30, 30, {"BOTTOMRIGHT", CharacterBag2Slot, "BOTTOMLEFT", -2, 0}, masqueGroup)

    Addon:FixNormalTextureSize(MainMenuBarBackpackButton)
    Addon:FixNormalTextureSize(CharacterBag0Slot)
    Addon:FixNormalTextureSize(CharacterBag1Slot)
    Addon:FixNormalTextureSize(CharacterBag2Slot)
    Addon:FixNormalTextureSize(CharacterBag3Slot)

    if KeyRingButton then
        AB:SetupButton(KeyRingButton, frame, 16, 34, {"BOTTOMLEFT", HelpMicroButton, "BOTTOMRIGHT", 2, 2})
        KeyRingButton:Show()
    end

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    if config.fader then
        Addon:CreateButtonFrameFader(frame, buttonList, config.fader)
    end

    if Addon.IsClassic then
        MainMenuMicroButton.PerformanceBar = CreateFrame("Frame", nil, MainMenuMicroButton)
        MainMenuMicroButton.PerformanceBar:SetSize(28, 58)
        MainMenuMicroButton.PerformanceBar:SetPoint("BOTTOM", MainMenuMicroButton, "BOTTOM", 0, 0)

        MainMenuMicroButton.PerformanceBar.Texture = MainMenuMicroButton.PerformanceBar:CreateTexture("OVERLAY")
        MainMenuMicroButton.PerformanceBar.Texture:SetAllPoints()
        MainMenuMicroButton.PerformanceBar.Texture:SetTexture(Addon.media.textures.PerformanceBar)
    end

    AB:SecureHook("MicroButton_OnEnter", function(self)
        if self == MainMenuMicroButton then
            AB:AddSystemInfo(GameTooltip)
        end
    end)

    MainMenuMicroButton.lastUpdate = 0
    MainMenuMicroButton:HookScript("OnUpdate", function(self, elapsed)
        if (MainMenuMicroButton.lastUpdate > 0) then
            MainMenuMicroButton.lastUpdate = MainMenuMicroButton.lastUpdate - elapsed
        else
            MainMenuMicroButton.lastUpdate = MainMenuMicroButton.customUpdateInterval or PERFORMANCEBAR_UPDATE_INTERVAL

            if Addon.IsClassic then
                Addon.SystemInfo:Update(false)
                if self.hover then
                    MicroButton_OnEnter(self)
                end

                local latencyColor
                local latency = Addon.SystemInfo.homePing > Addon.SystemInfo.worldPing and Addon.SystemInfo.homePing or Addon.SystemInfo.worldPing
                if latency > AB.config.db.profile.microButtonAndBags.mediumLatencyTreshold then
                    latencyColor = AB.config.db.profile.microButtonAndBags.highLatencyColor
                elseif latency > AB.config.db.profile.microButtonAndBags.lowLatencyTreshold then
                    latencyColor = AB.config.db.profile.microButtonAndBags.mediumLatencyColor
                else
                    latencyColor = AB.config.db.profile.microButtonAndBags.lowLatencyColor
                end

                MainMenuMicroButton.PerformanceBar.Texture:SetVertexColor(unpack(latencyColor))
            end
        end

        if IsShiftKeyDown() then
            if not MainMenuMicroButton.isShiftKeyDown then
                MainMenuMicroButton.updateInterval = 0
                MainMenuMicroButton.isShiftKeyDown = true
                MainMenuMicroButton.customUpdateInterval = 1
            end
        elseif MainMenuMicroButton.isShiftKeyDown then
            MainMenuMicroButton.updateInterval = 0
            MainMenuMicroButton.isShiftKeyDown = false
        end

        if not IsShiftKeyDown() then
            MainMenuMicroButton.customUpdateInterval = nil
        end
    end)

    return frame
end

function AB:CreateMainMenuBar()
    local config = AB.config.db.profile.mainMenuBar

    local framesToHide = {MainMenuBar}
    local framesToDisable = {MainMenuBar, MicroButtonAndBagsBar, MainMenuBarArtFrame}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "MainMenuBar", UIParent, "SecureHandlerStateTemplate")
    frame:SetSize(552, 51)
    frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)

    frame.Texture = frame:CreateTexture("BACKGROUND")
    frame.Texture:SetTexture(Addon.media.textures.MainMenuBar)
    frame.Texture:SetSize(552, 92)
    frame.Texture:SetAllPoints()

    local overlay = CreateFrame("Frame", AddonName .. "MainMenuBarOverlay", frame)
    overlay:SetFrameLevel(10)
    overlay:SetAllPoints()

    frame.TopEndCap = overlay:CreateTexture("BACKGROUND", 0)
    frame.LeftEndCap = overlay:CreateTexture("ARTWORK", 1)
    frame.LeftEndCap:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 32, 0)
    frame.RightEndCap = overlay:CreateTexture("ARTWORK", 2)
    frame.RightEndCap:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -32, 0)

    local masqueGroup
    if LibStub("Masque", true) then
        masqueGroup = LibStub("Masque", true):Group(AB.Title, "Main Action Bar", true)
    end

    local buttonList = {}
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["ActionButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}

        if i > 1 then
            parent = buttonList[i - 1]
            point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
        end

        AB:SetupButton(button, frame, 36, 36, point, masqueGroup)
    end

    if ActionBarUpButton then
        ActionBarUpButton:SetParent(frame)
        ActionBarUpButton:ClearAllPoints()
        ActionBarUpButton:SetPoint("LEFT", "ActionButton12", "RIGHT", 0, 9)
    end

    if ActionBarDownButton then
        ActionBarDownButton:SetParent(frame)
        ActionBarDownButton:ClearAllPoints()
        ActionBarDownButton:SetPoint("LEFT", "ActionButton12", "RIGHT", 0, -10)
    end

    frame.PageNumber = frame:CreateFontString(nil, "OVERLAY")
    frame.PageNumber:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    frame.PageNumber:SetJustifyH("CENTER")
    frame.PageNumber:SetText(GetActionBarPage())
    frame.PageNumber:SetSize(20, 20)
    frame.PageNumber:SetPoint("LEFT", "ActionButton12", "RIGHT", 25, 0)

    -- fix the button grid for actionbar1
    local function UpdateGridVisibility()
        if InCombatLockdown() then
            return
        end
        local showgrid = tonumber(GetCVar("alwaysShowActionBars"))
        for _, button in next, buttonList do
            button:SetAttribute("showgrid", showgrid)
            ActionButton_ShowGrid(button)
        end
    end
    AB:SecureHook("MultiActionBar_UpdateGridVisibility", UpdateGridVisibility)

    -- _onstate-page state driver
    for i, button in next, buttonList do
        frame:SetFrameRef("ActionButton" .. i, button)
    end

    frame:Execute(([[
        buttons = table.new()
        for i=1, %d do
            table.insert(buttons, self:GetFrameRef("%s"..i))
        end
    ]]):format(NUM_ACTIONBAR_BUTTONS, "ActionButton"))

    frame:SetAttribute("_onstate-page", [[
        --print("_onstate-page","index",newstate)
        self:SetAttribute("actionpage", newstate)
        for i, button in next, buttons do
            button:SetAttribute("actionpage", newstate)
        end
    ]])

    local actionPage =
        "[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1"
    RegisterStateDriver(frame, "page", actionPage)

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    if config.fader then
        local buttonList = {}
        for i = 1, NUM_ACTIONBAR_BUTTONS do
            local button = _G["ActionButton" .. i]
            if not button then
                break
            end
            table.insert(buttonList, button)
        end

        for i = 1, NUM_ACTIONBAR_BUTTONS do
            local button = _G["MultiBarBottomLeftButton" .. i]
            if not button then
                break
            end
            table.insert(buttonList, button)
        end

        for i = 1, NUM_ACTIONBAR_BUTTONS do
            local button = _G["MultiBarBottomRightButton" .. i]
            if not button then
                break
            end
            table.insert(buttonList, button)
        end

        for i = 1, NUM_STANCE_SLOTS do
            local button = _G["StanceButton" .. i]
            if not button then
                break
            end
            table.insert(buttonList, button)
        end

        for i = 1, NUM_PET_ACTION_SLOTS do
            local button = _G["PetActionButton" .. i]
            if not button then
                break
            end
            table.insert(buttonList, button)
        end

        if MainMenuBarVehicleLeaveButton then
            table.insert(buttonList, MainMenuBarVehicleLeaveButton)
        end

        Addon:CreateButtonFrameFader(frame, buttonList, config.fader)
    end

    return frame
end

function AB:UpdateMainMenuBarTextures()
    local config = AB.config.db.profile.mainMenuBar

    local isExpBarShown = MainMenuExpBar:IsShown()
    local isRepBarShown = ReputationWatchBar:IsShown()

    local offset = 0
    if isExpBarShown and isRepBarShown then
        offset = 22
    else
        offset = 10
    end

    AB.bars.MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, offset)
    AB.bars.MainMenuBar.LeftEndCap:SetPoint("BOTTOMRIGHT", AB.bars.MainMenuBar, "BOTTOMLEFT", 32, -1 * offset - 1)
    AB.bars.MainMenuBar.RightEndCap:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "BOTTOMRIGHT", -32, -1 * offset - 1)
    AB.bars.ExperienceBar:SetPoint("BOTTOM", AB.bars.MainMenuBar, "BOTTOM", 0, -1 * offset)

    if isRepBarShown then
        if not isExpBarShown then
            AB.bars.ReputationBar:SetPoint("BOTTOM", AB.bars.ExperienceBar, "TOP", 0, -15)
        else
            AB.bars.ReputationBar:SetPoint("BOTTOM", AB.bars.ExperienceBar, "TOP", 0, -3)
        end
        ReputationWatchBar:ClearAllPoints()
        ReputationWatchBar:SetPoint("BOTTOM", AB.bars.ReputationBar, "BOTTOM", 0, 4)
    end

    local endCapWidth = 128
    local endCapHeight = 76
    if config.theme == AB.themes.Default then
        AB.bars.MainMenuBar.TopEndCap:Hide()

        AB.bars.MainMenuBar.LeftEndCap:SetTexture(Addon.media.textures.MainMenuBar)
        AB.bars.MainMenuBar.LeftEndCap:SetTexCoord(115 / 1024, (115 + endCapWidth) / 1024, 168 / 255, (168 + endCapHeight) / 255)
        AB.bars.MainMenuBar.LeftEndCap:SetSize(endCapWidth, 76)

        AB.bars.MainMenuBar.RightEndCap:SetTexture(Addon.media.textures.MainMenuBar)
        AB.bars.MainMenuBar.RightEndCap:SetTexCoord((115 + endCapWidth) / 1024, 115 / 1024, 168 / 255, (168 + endCapHeight) / 255)
        AB.bars.MainMenuBar.RightEndCap:SetSize(endCapWidth, 76)
    else
        local texture = Addon.media.textures["MainMenuBar_" .. config.theme]
        if config.theme == AB.themes.Faction then
            if UnitFactionGroup("player") == "Horde" then
                texture = Addon.media.textures.MainMenuBar_Horde
            else
                texture = Addon.media.textures.MainMenuBar_Alliance
            end
        end

        AB.bars.MainMenuBar.TopEndCap:Show()
        AB.bars.MainMenuBar.TopEndCap:SetTexture(texture, true)
        AB.bars.MainMenuBar.TopEndCap:SetTexCoord(0 / 512, 512 / 512, 2 / 512, 29 / 512)
        AB.bars.MainMenuBar.TopEndCap:SetHorizTile(true)
        AB.bars.MainMenuBar.TopEndCap:SetHeight(16)
        AB.bars.MainMenuBar.TopEndCap:SetWidth(AB.bars.MainMenuBar:GetWidth())
        AB.bars.MainMenuBar.TopEndCap:SetPoint("TOPLEFT", AB.bars.MainMenuBar.LeftEndCap, "TOPRIGHT", -30, (isExpBarShown and isRepBarShown and -25) or -38)
        AB.bars.MainMenuBar.TopEndCap:SetPoint("TOPRIGHT", AB.bars.MainMenuBar.RightEndCap, "TOPLEFT", 30, (isExpBarShown and isRepBarShown and -25) or -38)
        AB.bars.MainMenuBar.TopEndCap:SetDrawLayer("BACKGROUND", 0)

        AB.bars.MainMenuBar.LeftEndCap:SetTexture(texture)
        AB.bars.MainMenuBar.LeftEndCap:SetTexCoord(0 / 512, 176 / 512, 365 / 512, 510 / 512)
        AB.bars.MainMenuBar.LeftEndCap:SetSize(endCapWidth, 105)
        AB.bars.MainMenuBar.LeftEndCap:SetDrawLayer("ARTWORK", 1)

        AB.bars.MainMenuBar.RightEndCap:SetTexture(texture)
        AB.bars.MainMenuBar.RightEndCap:SetTexCoord(176 / 512, 0 / 512, 365 / 512, 510 / 512)
        AB.bars.MainMenuBar.RightEndCap:SetSize(endCapWidth, 105)
        AB.bars.MainMenuBar.RightEndCap:SetDrawLayer("ARTWORK", 2)
    end
end

function AB:CreateExperienceBar()
    local frame = CreateFrame("Frame", AddonName .. "ExperienceBar", AB.bars.MainMenuBar, "SecureHandlerStateTemplate")
    frame:SetSize(804, 11)
    frame:SetPoint("BOTTOM", AB.bars.MainMenuBar, "BOTTOM", 0, -10)

    MainMenuExpBar:SetParent(frame)
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetSize(804, 11)
    MainMenuExpBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)

    AB:UpdateExperienceBarTextures()

    return frame
end

function AB:UpdateExperienceBarTextures()
    local width = math.floor(MainMenuExpBar:GetWidth() / 4)

    MainMenuXPBarTexture0:ClearAllPoints()
    MainMenuXPBarTexture0:SetSize(width, 12)
    MainMenuXPBarTexture0:SetPoint("BOTTOM", MainMenuExpBar, "BOTTOM", -1.5 * width, 0)

    MainMenuXPBarTexture1:ClearAllPoints()
    MainMenuXPBarTexture1:SetSize(width, 12)
    MainMenuXPBarTexture1:SetPoint("BOTTOM", MainMenuExpBar, "BOTTOM", -0.5 * width, 0)

    MainMenuXPBarTexture2:ClearAllPoints()
    MainMenuXPBarTexture2:SetSize(width, 12)
    MainMenuXPBarTexture2:SetPoint("BOTTOM", MainMenuExpBar, "BOTTOM", 0.5 * width, 0)

    MainMenuXPBarTexture3:ClearAllPoints()
    MainMenuXPBarTexture3:SetSize(width, 12)
    MainMenuXPBarTexture3:SetPoint("BOTTOM", MainMenuExpBar, "BOTTOM", 1.5 * width, 0)
end

function AB:CreateReputationBar()
    local frame = CreateFrame("Frame", AddonName .. "ReputationBar", AB.bars.ExperienceBar, "SecureHandlerStateTemplate")
    frame:SetSize(804, 11)
    frame:SetPoint("BOTTOM", AB.bars.ExperienceBar, "TOP", 0, -3)

    ReputationWatchBar:SetParent(frame)
    ReputationWatchBar:ClearAllPoints()
    ReputationWatchBar:SetSize(804, 11)
    ReputationWatchBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)

    ReputationWatchBar.StatusBar:SetSize(804, 11)
    ReputationWatchBar.StatusBar:ClearAllPoints()
    ReputationWatchBar.StatusBar:SetPoint("BOTTOM", ReputationWatchBar, "BOTTOM", 0, 0)

    AB:UpdateReputationBarTextures()

    return frame
end

function AB:UpdateReputationBarTextures()
    local width = math.floor(ReputationWatchBar.StatusBar:GetWidth() / 4)

    ReputationWatchBar.StatusBar.WatchBarTexture0:ClearAllPoints()
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetSize(width, 12)
    ReputationWatchBar.StatusBar.WatchBarTexture0:SetPoint("BOTTOM", ReputationWatchBar.StatusBar, "BOTTOM", -1.5 * width, 0)

    ReputationWatchBar.StatusBar.WatchBarTexture1:ClearAllPoints()
    ReputationWatchBar.StatusBar.WatchBarTexture1:SetSize(width, 12)
    ReputationWatchBar.StatusBar.WatchBarTexture1:SetPoint("BOTTOM", ReputationWatchBar.StatusBar, "BOTTOM", -0.5 * width, 0)

    ReputationWatchBar.StatusBar.WatchBarTexture2:ClearAllPoints()
    ReputationWatchBar.StatusBar.WatchBarTexture2:SetSize(width, 12)
    ReputationWatchBar.StatusBar.WatchBarTexture2:SetPoint("BOTTOM", ReputationWatchBar.StatusBar, "BOTTOM", 0.5 * width, 0)

    ReputationWatchBar.StatusBar.WatchBarTexture3:ClearAllPoints()
    ReputationWatchBar.StatusBar.WatchBarTexture3:SetSize(width, 12)
    ReputationWatchBar.StatusBar.WatchBarTexture3:SetPoint("BOTTOM", ReputationWatchBar.StatusBar, "BOTTOM", 1.5 * width, 0)

    ReputationWatchBar.StatusBar.XPBarTexture0:ClearAllPoints()
    ReputationWatchBar.StatusBar.XPBarTexture0:SetSize(width, 12)
    ReputationWatchBar.StatusBar.XPBarTexture0:SetPoint("BOTTOM", ReputationWatchBar.StatusBar, "BOTTOM", -1.5 * width, 0)

    ReputationWatchBar.StatusBar.XPBarTexture1:ClearAllPoints()
    ReputationWatchBar.StatusBar.XPBarTexture1:SetSize(width, 12)
    ReputationWatchBar.StatusBar.XPBarTexture1:SetPoint("BOTTOM", ReputationWatchBar.StatusBar, "BOTTOM", -0.5 * width, 0)

    ReputationWatchBar.StatusBar.XPBarTexture2:ClearAllPoints()
    ReputationWatchBar.StatusBar.XPBarTexture2:SetSize(width, 12)
    ReputationWatchBar.StatusBar.XPBarTexture2:SetPoint("BOTTOM", ReputationWatchBar.StatusBar, "BOTTOM", 0.5 * width, 0)

    ReputationWatchBar.StatusBar.XPBarTexture3:ClearAllPoints()
    ReputationWatchBar.StatusBar.XPBarTexture3:SetSize(width, 12)
    ReputationWatchBar.StatusBar.XPBarTexture3:SetPoint("BOTTOM", ReputationWatchBar.StatusBar, "BOTTOM", 1.5 * width, 0)
end

function AB:CreateMaxLevelBar()
    local frame = CreateFrame("Frame", AddonName .. "MaxLevelBar", AB.bars.MainMenuBar, "SecureHandlerStateTemplate")
    frame:SetSize(804, 11)
    frame:SetPoint("BOTTOM", AB.bars.MainMenuBar, "BOTTOM", 0, -10)

    MainMenuBarMaxLevelBar:SetParent(frame)
    MainMenuBarMaxLevelBar:ClearAllPoints()
    MainMenuBarMaxLevelBar:SetSize(804, 11)
    MainMenuBarMaxLevelBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)

    AB:UpdateMaxLevelBarTextures()

    return frame
end

function AB:UpdateMaxLevelBarTextures()
    local width = math.floor(MainMenuBarMaxLevelBar:GetWidth() / 4)

    MainMenuMaxLevelBar0:ClearAllPoints()
    MainMenuMaxLevelBar0:SetSize(width, 12)
    MainMenuMaxLevelBar0:SetPoint("BOTTOM", MainMenuBarMaxLevelBar, "BOTTOM", -1.5 * width, 0)

    MainMenuMaxLevelBar1:ClearAllPoints()
    MainMenuMaxLevelBar1:SetSize(width, 12)
    MainMenuMaxLevelBar1:SetPoint("BOTTOM", MainMenuBarMaxLevelBar, "BOTTOM", -0.5 * width, 0)

    MainMenuMaxLevelBar2:ClearAllPoints()
    MainMenuMaxLevelBar2:SetSize(width, 12)
    MainMenuMaxLevelBar2:SetPoint("BOTTOM", MainMenuBarMaxLevelBar, "BOTTOM", 0.5 * width, 0)

    MainMenuMaxLevelBar3:ClearAllPoints()
    MainMenuMaxLevelBar3:SetSize(width, 12)
    MainMenuMaxLevelBar3:SetPoint("BOTTOM", MainMenuBarMaxLevelBar, "BOTTOM", 1.5 * width, 0)
end

function AB:CreateMultiBarBottomLeft()
    local config = AB.config.db.profile.multiBarBottomLeft

    local framesToHide = {MultiBarBottomLeft}
    local framesToDisable = {MultiBarBottomLeft}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "MultiBarBottomLeft", AB.bars.MainMenuBar, "SecureHandlerStateTemplate")
    frame:SetSize(506, 36)
    frame:SetPoint("BOTTOMLEFT", AB.bars.MainMenuBar, "TOPLEFT", 0, -5)

    local masqueGroup
    if LibStub("Masque", true) then
        masqueGroup = LibStub("Masque", true):Group(AB.Title, "Bottom Left Action Bar", true)
    end

    local buttonList = {}
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarBottomLeftButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}

        if i > 1 then
            parent = buttonList[i - 1]
            point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
        end

        AB:SetupButton(button, frame, 36, 36, point, masqueGroup)
    end

    frame:SetAttribute("actionpage", 6) -- 6 = MultiBarBottomLeft

    return frame
end

function AB:CreateMultiBarBottomRight()
    local config = AB.config.db.profile.multiBarBottomRight

    local framesToHide = {MultiBarBottomRight}
    local framesToDisable = {MultiBarBottomRight}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "MultiBarBottomRight", AB.bars.MainMenuBar, "SecureHandlerStateTemplate")
    frame:SetSize(506, 36)
    frame:SetPoint("BOTTOMLEFT", AB.bars.MultiBarBottomLeft, "BOTTOMRIGHT", 38, 0)

    local masqueGroup
    if LibStub("Masque", true) then
        masqueGroup = LibStub("Masque", true):Group(AB.Title, "Bottom Right Action Bar", true)
    end

    local buttonList = {}
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarBottomRightButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}

        if i == 7 then
            parent = buttonList[1]
            point = {"TOPLEFT", parent, "BOTTOMLEFT", 0, -10}
        elseif i > 1 then
            parent = buttonList[i - 1]
            point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
        end

        AB:SetupButton(button, frame, 36, 36, point, masqueGroup)
    end

    frame:SetAttribute("actionpage", 5) -- 5 = MultiBarBottomRight

    return frame
end

function AB:CreateMultiBarRight()
    local config = AB.config.db.profile.multiBarRight

    local framesToHide = {MultiBarRight}
    local framesToDisable = {MultiBarRight}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "MultiBarRight", UIParent, "SecureHandlerStateTemplate")
    frame:SetSize(36, 498)
    frame:SetPoint("RIGHT", UIParent, "RIGHT", 0, 0)

    local masqueGroup
    if LibStub("Masque", true) then
        masqueGroup = LibStub("Masque", true):Group(AB.Title, "Right Action Bar", true)
    end

    local buttonList = {}
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarRightButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"TOPLEFT", frame, "TOPLEFT", 0, 0}

        if i > 1 then
            parent = buttonList[i - 1]
            point = {"TOPLEFT", parent, "BOTTOMLEFT", 0, -2}
        end

        AB:SetupButton(button, frame, 36, 36, point, masqueGroup)
    end

    frame:SetAttribute("actionpage", 3) -- 3 = MultiBarRight

    if config.fader then
        Addon:CreateButtonFrameFader(frame, buttonList, config.fader)
    end

    return frame
end

function AB:CreateMultiBarLeft()
    local config = AB.config.db.profile.multiBarLeft

    local framesToHide = {MultiBarLeft}
    local framesToDisable = {MultiBarLeft}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "MultiBarLeft", UIParent, "SecureHandlerStateTemplate")
    frame:SetSize(36, 498)
    frame:SetPoint("RIGHT", AddonName .. "MultiBarRight", "LEFT", -2, 0)

    local masqueGroup
    if LibStub("Masque", true) then
        masqueGroup = LibStub("Masque", true):Group(AB.Title, "Left Action Bar", true)
    end

    local buttonList = {}
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarLeftButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"TOPLEFT", frame, "TOPLEFT", 0, 0}

        if i > 1 then
            parent = buttonList[i - 1]
            point = {"TOPLEFT", parent, "BOTTOMLEFT", 0, -2}
        end

        AB:SetupButton(button, frame, 36, 36, point, masqueGroup)
    end

    frame:SetAttribute("actionpage", 4) -- 4 = MultiBarLeft

    if config.fader then
        Addon:CreateButtonFrameFader(frame, buttonList, config.fader)
    end

    return frame
end

function AB:CreateStanceBar()
    local config = AB.config.db.profile.stanceBar

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "StanceBar", UIParent, "SecureHandlerStateTemplate")
    frame:SetSize(29, 32)
    frame:SetPoint("BOTTOMLEFT", AddonName .. "MainMenuBar", "TOPLEFT", 30, 40)
    frame.__blizzardBar = StanceBarFrame

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    -- reparent the Blizzard bar
    if frame.__blizzardBar then
        frame.__blizzardBar:SetParent(frame)
        frame.__blizzardBar:EnableMouse(false)
        frame.__blizzardBar:ClearAllPoints()
        frame.__blizzardBar:SetAllPoints()
    end

    local masqueGroup
    if LibStub("Masque", true) then
        masqueGroup = LibStub("Masque", true):Group(AB.Title, "Stance/Shapeshift Bar", true)
    end

    local buttonList = {}
    for i = 1, NUM_STANCE_SLOTS do
        local button = _G["StanceButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}

        if i > 1 then
            parent = buttonList[i - 1]
            point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
        end

        AB:SetupButton(button, parent, 30, 30, point, masqueGroup)
    end

    -- hide blizzard textures
    StanceBarLeft:SetTexture(nil)
    StanceBarMiddle:SetTexture(nil)
    StanceBarRight:SetTexture(nil)

    return frame
end

function AB:CreatePetActionBar()
    local config = AB.config.db.profile.petActionBar

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "StanceBar", UIParent, "SecureHandlerStateTemplate")
    frame:SetSize(509, 43)
    frame:SetPoint("BOTTOMLEFT", AddonName .. "MainMenuBar", "TOPLEFT", 40, 40)
    frame.__blizzardBar = PetActionBarFrame

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    -- reparent the Blizzard bar
    if frame.__blizzardBar then
        frame.__blizzardBar:SetParent(frame)
        frame.__blizzardBar:EnableMouse(false)
        frame.__blizzardBar:ClearAllPoints()
        frame.__blizzardBar:SetAllPoints()
    end

    local masqueGroup
    if LibStub("Masque", true) then
        masqueGroup = LibStub("Masque", true):Group(AB.Title, "Pet Action Bar", true)
    end

    local buttonList = {}
    for i = 1, NUM_PET_ACTION_SLOTS do
        local button = _G["PetActionButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}

        if i > 1 then
            parent = buttonList[i - 1]
            point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
        end

        AB:SetupButton(button, parent, 30, 30, point, masqueGroup)
    end

    return frame
end

function AB:CreateVehicleExitBar()
    local config = AB.config.db.profile.vehicleExitBar

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", AddonName .. "VehicleExitBar", UIParent, "SecureHandlerStateTemplate")
    frame:SetSize(36, 36)
    frame:SetPoint("BOTTOMRIGHT", AddonName .. "MainMenuBar", "TOPRIGHT", -24, 40)

    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetParent(frame)
    MainMenuBarVehicleLeaveButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)

    AB:SecureHook(MainMenuBarVehicleLeaveButton, "SetPoint", function(_, _, parent)
        if parent ~= frame then
            MainMenuBarVehicleLeaveButton:ClearAllPoints()
            MainMenuBarVehicleLeaveButton:SetParent(UIParent)
            MainMenuBarVehicleLeaveButton:SetPoint("CENTER", frame, "CENTER")
        end
    end)

    AB:SecureHook(MainMenuBarVehicleLeaveButton, "SetHighlightTexture", function(btn, tex)
        if tex ~= btn.hover then
            MainMenuBarVehicleLeaveButton:SetHighlightTexture(btn.hover)
        end
    end)

    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
    local function HandleEvent(this, event)
        if event ~= "PLAYER_ENTERING_WORLD" and event ~= "UPDATE_BONUS_ACTIONBAR" then
            return
        end
        if UnitOnTaxi("player") then
            frame:Show()
            MainMenuBarVehicleLeaveButton:Show()
        else
            frame:Hide()
            MainMenuBarVehicleLeaveButton:Hide()
        end
    end
    frame:HookScript("OnEvent", HandleEvent)

    return frame
end

function AB:AddSystemInfo(tooltip)
    Addon.SystemInfo:Update(true)

    local ipTypes = {"IPv4", "IPv6"}
    local statusColors = {"|cff0CD809", "|cffE8DA0F", "|cffFF9000", "|cffD80909"}
    local fpsString = "%s%d|r"
    local bandwidthString = "%.2f Mbps"
    local percentageString = "%.2f%%"
    local homeLatencyString = "%d ms"
    local cpuString = "%d ms"
    local cpuAndMemoryString = "%d ms / %s"

    local labelColor = Addon.config.db.profile.colors.highlightFont
    local valueColor = Addon.config.db.profile.colors.normalFont

    tooltip:AddLine(" ")

    local latencyColor
    local latency = Addon.SystemInfo.homePing > Addon.SystemInfo.worldPing and Addon.SystemInfo.homePing or Addon.SystemInfo.worldPing
    if latency > AB.config.db.profile.microButtonAndBags.mediumLatencyTreshold then
        latencyColor = AB.config.db.profile.microButtonAndBags.highLatencyColor
    elseif latency > AB.config.db.profile.microButtonAndBags.lowLatencyTreshold then
        latencyColor = AB.config.db.profile.microButtonAndBags.mediumLatencyColor
    else
        latencyColor = AB.config.db.profile.microButtonAndBags.lowLatencyColor
    end

    tooltip:AddDoubleLine("Latency:", Addon.SystemInfo.homePing, labelColor[1], labelColor[2], labelColor[3], latencyColor[1], latencyColor[2], latencyColor[3])

    local fpsColor
    if Addon.SystemInfo.framerate > AB.config.db.profile.microButtonAndBags.mediumFpsTreshold then
        fpsColor = AB.config.db.profile.microButtonAndBags.highFpsColor
    elseif Addon.SystemInfo.framerate > AB.config.db.profile.microButtonAndBags.lowFpsTreshold then
        fpsColor = AB.config.db.profile.microButtonAndBags.mediumFpsColor
    else
        fpsColor = AB.config.db.profile.microButtonAndBags.lowFpsColor
    end

    tooltip:AddDoubleLine("FPS:", Addon.SystemInfo.framerate, labelColor[1], labelColor[2], labelColor[3], fpsColor[1], fpsColor[2], fpsColor[3])

    if Addon.SystemInfo.useIPv6 then
        tooltip:AddDoubleLine("Home Protocol:", ipTypes[Addon.SystemInfo.ipTypeHome or 0] or UNKNOWN, labelColor[1], labelColor[2], labelColor[3], valueColor[1], valueColor[2],
                              valueColor[3])
        tooltip:AddDoubleLine("World Protocol:", ipTypes[Addon.SystemInfo.ipTypeWorld or 0] or UNKNOWN, labelColor[1], labelColor[2], labelColor[3], valueColor[1], valueColor[2],
                              valueColor[3])
    end

    if Addon.SystemInfo.bandwidth ~= 0 then
        tooltip:AddDoubleLine("Bandwidth", format(bandwidthString, Addon.SystemInfo.bandwidth), labelColor[1], labelColor[2], labelColor[3], valueColor[1], valueColor[2],
                              valueColor[3])
        tooltip:AddDoubleLine("Download", format(percentageString, GetDownloadedPercentage() * 100), labelColor[1], labelColor[2], labelColor[3], valueColor[1], valueColor[2],
                              valueColor[3])
        tooltip:AddLine(" ")
    end

    tooltip:AddDoubleLine("Total Memory:", Addon.SystemInfo:FormatMemory(Addon.SystemInfo.totalMemory), labelColor[1], labelColor[2], labelColor[3], valueColor[1], valueColor[2],
                          valueColor[3])
    local totalCPU
    if Addon.SystemInfo.cpuProfiling then
        tooltip:AddDoubleLine("Total CPU:", format(homeLatencyString, Addon.SystemInfo.totalCPU), labelColor[1], labelColor[2], labelColor[3], valueColor[1], valueColor[2],
                              valueColor[3])
    end

    tooltip:AddLine(" ")
    if Addon.SystemInfo.cpuProfiling then
        for i = 1, #Addon.SystemInfo.cpuTable do
            if (not IsShiftKeyDown()) and (i > AB.config.db.profile.microButtonAndBags.addonsToDisplay) then
                tooltip:AddLine("(Hold Shift) Show All Addons") -- TODO: Localize
                break
            end

            local cpu = Addon.SystemInfo.cpuTable[i]
            if cpu and IsAddOnLoaded(cpu[1]) then
                local red = cpu[3] / Addon.SystemInfo.totalCPU
                local green = 1 - red

                local mem
                for j = 1, #Addon.SystemInfo.memoryTable do
                    if Addon.SystemInfo.memoryTable[j][1] == cpu[1] then
                        mem = Addon.SystemInfo.memoryTable[j][1]
                        break
                    end
                end
                if mem then
                    tooltip:AddDoubleLine(cpu[2], format(cpuAndMemoryString, cpu[3], Addon.SystemInfo:FormatMemory(mem)), labelColor[1], labelColor[2], labelColor[3], red,
                                          green + .5, 0)
                else
                    tooltip:AddDoubleLine(cpu[2], format(cpuString, cpu[3]), labelColor[1], labelColor[2], labelColor[3], red, green + .5, 0)
                end
            end
        end
    else
        for i = 1, #Addon.SystemInfo.memoryTable do
            if (not IsShiftKeyDown()) and (i > AB.config.db.profile.microButtonAndBags.addonsToDisplay) then
                tooltip:AddLine("(Hold Shift) Show All Addons") -- TODO: Localize
                break
            end

            local ele = Addon.SystemInfo.memoryTable[i]
            if ele and IsAddOnLoaded(ele[1]) then
                local red = ele[3] / Addon.SystemInfo.totalMemory
                local green = 1 - red
                tooltip:AddDoubleLine(ele[2], Addon.SystemInfo:FormatMemory(ele[3]), labelColor[1], labelColor[2], labelColor[3], red, green + .5, 0)
            end
        end
    end

    tooltip:Show()
end
