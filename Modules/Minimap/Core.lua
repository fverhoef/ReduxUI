local addonName, ns = ...
local R = _G.ReduxUI
local MM = R:AddModule("Minimap", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = R.L

MM.Buttons = {}
MM.IgnoreButton = {
    "HelpOpenWebTicketButton", "MiniMapVoiceChatFrame", "TimeManagerClockButton", "BattlefieldMinimap", "ButtonCollectFrame", "GameTimeFrame", "QueueStatusMinimapButton",
    "GarrisonLandingPageMinimapButton", "MiniMapMailFrame", "MinimapZoneTextButton", "MinimapToggleButton", "MiniMapTracking", "MinimapZoomIn", "MinimapZoomOut", "RecipeRadarMinimapButtonFrame"
}
MM.GenericIgnore = {
    "Archy", "GatherMatePin", "GatherNote", "GuildInstance", "HandyNotesPin", "MiniMap", "Spy_MapNoteList_mini", "ZGVMarker", "poiMinimap", "GuildMap3Mini", "LibRockConfig-1.0_MinimapButton",
    "NauticusClassicMiniIcon", "NauticusMiniIcon", "WestPointer", "Cork", "DugisArrowMinimapPoint", "QuestieFrame"
}
MM.PartialIgnore = {"Node", "Note", "Pin", "POI"}
MM.UnrulyButtons = {"WIM3MinimapButton", "RecipeRadar_MinimapButton"}
MM.ButtonFunctions = {"SetParent", "ClearAllPoints", "SetPoint", "SetSize", "SetScale", "SetFrameStrata", "SetFrameLevel"}

function MM:Initialize()
    if not MM.config.enabled then return end

    MM:StyleMinimap()

    -- TODO: check if it's possible to use events rather than a timed update
    MM:ScheduleTimer("GrabMinimapButtons", 1)
    MM:ScheduleRepeatingTimer("GrabMinimapButtons", 5)
end

function MM:LockButton(Button) for _, Function in pairs(MM.ButtonFunctions) do Button[Function] = function() end end end

function MM:UnlockButton(Button) for _, Function in pairs(MM.ButtonFunctions) do Button[Function] = nil end end

function MM:GrabMinimapButton(button)
    if not button or button.isSkinned then return end

    local name = button.GetName and button:GetName()
    if not name then return end

    if tContains(MM.IgnoreButton, name) then return end

    for i = 1, #MM.GenericIgnore do if string.sub(name, 1, string.len(MM.GenericIgnore[i])) == MM.GenericIgnore[i] then return end end

    for i = 1, #MM.PartialIgnore do if string.find(name, MM.PartialIgnore[i]) ~= nil then return end end

    for i = 1, button:GetNumRegions() do
        local region = select(i, button:GetRegions())
        if region.IsObjectType and region:IsObjectType("Texture") then
            local textureID = region.GetTextureFileID and region:GetTextureFileID()
            local texture = region:GetTexture()

            if textureID == 136430 or texture == "Interface\\Minimap\\MiniMap-TrackingBorder" then
                region:SetSize(32, 32)
                region:SetTexture(R.media.textures.minimap.minimapButtonBorder)
            elseif textureID == 136467 or texture == "Interface\\Minimap\\UI-Minimap-Background" then
                -- region:SetTexture(nil)
                region:SetAlpha(0.6)
            elseif textureID == 136477 or texture == "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight" then
                region:SetSize(28, 28)
                region:ClearAllPoints()
                local offset = 1 + (28 - MM.config.buttonFrame.iconSize) / 2
                region:SetPoint("CENTER", offset, -1 * offset)
            else
                region:SetSize(18, 18)

                -- replace icons that don't display properly
                -- TODO: find out why masking icons with alpha gives a white background
                if name == "LibDBIcon10_DBM" then
                    region:SetTexture("Interface\\Icons\\INV_Helmet_01")
                elseif name == "LibDBIcon10_Leatrix_Plus" then
                    region:SetTexture("Interface\\Icons\\INV_Staff_20")
                end
                region:SetTexCoord(0, 1, 0, 1)
                region:SetMask(R.media.textures.portraitAlphaMask)
                region.SetTexCoord = function() return end
            end
        end
    end

    button.isSkinned = true
    tinsert(MM.Buttons, button)

    return button.isSkinned
end

function MM:GrabChildren(frame)
    local numChildren = frame:GetNumChildren()
    if numChildren < (frame.numChildren or 0) then return end

    for i = 1, numChildren do
        local object = select(i, frame:GetChildren())
        if object and not object.isSkinned then
            local name = object:GetName()
            local width = object:GetWidth()
            if name and width > 15 and width < 60 and (object:IsObjectType("Button") or object:IsObjectType("Frame")) then if MM:GrabMinimapButton(object) then grabbedAnyButtons = true end end
        end
    end

    frame.numChildren = numChildren

    return grabbedAnyButtons
end

function MM:GrabMinimapButtons()
    if (InCombatLockdown() or C_PetBattles and C_PetBattles.IsInBattle()) then return end

    for _, button in pairs(MM.UnrulyButtons) do if _G[button] then _G[button]:SetParent(Minimap) end end

    local grabbedAnyButtons = MM:GrabChildren(Minimap)
    grabbedAnyButtons = MM:GrabChildren(MinimapBackdrop) or grabbedAnyButtons
    grabbedAnyButtons = MM:GrabChildren(MinimapCluster) or grabbedAnyButtons

    if grabbedAnyButtons then MM:UpdateButtonFrame() end
end

function MM:StyleMinimap()
    local width, height = unpack(MM.config.size)

    -- MinimapCluster
    MinimapCluster.config = MM.config
    MinimapCluster:SetSize(width, height + 30)
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint(unpack(MM.config.point))

    if MM.config.frameVisibility then
        MinimapCluster.frameVisibility = MM.config.frameVisibility
        RegisterStateDriver(MinimapCluster, "visibility", MM.config.frameVisibility)
    end

    MinimapCluster:CreateFader(MM.config.fader)
    R:CreateDragFrame(MinimapCluster, "Minimap", MM.config.point)

    Minimap:SetMaskTexture(MM.config.mask)
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOP", 0, -30)
    Minimap:SetSize(width, height) -- correct the cluster offset
    Minimap:CreateBorder()
    Minimap:CreateShadow()

    MinimapZoneText:SetSize(190, 10)
    MinimapZoneText:SetPoint("TOP", MinimapCluster, "TOP", 0, -8)
    MinimapZoneText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    MinimapZoneText:SetJustifyH("CENTER")
    MinimapZoneText:SetShadowColor(0, 0, 0, 0.25)
    MinimapZoneText:SetShadowOffset(1, -2)

    MinimapCluster.ZoneBackground = MinimapCluster:CreateTexture("BACKGROUND")
    MinimapCluster.ZoneBackground:SetTexture(R.media.textures.bonusObjectives)
    MinimapCluster.ZoneBackground:SetTexCoord(30 / 512, 394 / 512, 183 / 512, 261 / 512)
    MinimapCluster.ZoneBackground:SetHeight(30)
    MinimapCluster.ZoneBackground:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT")
    MinimapCluster.ZoneBackground:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT")

    MinimapNorthTag:ClearAllPoints()
    MinimapNorthTag:SetPoint("TOP", Minimap, "TOP", 0, -10)
    MinimapNorthTag:SetAlpha(1)

    Minimap:EnableMouseWheel()
    Minimap:SetScript("OnMouseWheel", MM.Minimap_OnMouseWheel)

    MinimapBorder:Hide()
    MinimapBorderTop:Hide()
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()
    MiniMapWorldMapButton:Hide()
    if not R.isRetail then MinimapToggleButton:Hide() end
    GameTimeFrame:Hide()

    LoadAddOn("Blizzard_TimeManager")
    TimeManagerClockButton:GetRegions():Hide()
    TimeManagerClockButton:ClearAllPoints()
    TimeManagerClockButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 0)
    TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    TimeManagerClockTicker:SetTextColor(0.8, 0.8, 0.6, 1)

    Minimap.InformationFrame = CreateFrame("FRAME", addonName .. "MinimapInformationFrame", Minimap)
    Minimap.InformationFrame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, 0)
    Minimap.InformationFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)
    Minimap.InformationFrame:SetHeight(25)

    Minimap.InformationFrame.Background = Minimap.InformationFrame:CreateTexture("BACKGROUND")
    Minimap.InformationFrame.Background:SetTexture(R.media.textures.autoQuestParts)
    Minimap.InformationFrame.Background:SetTexCoord(224 / 512, (224 + 245) / 512, 0 / 64, 64 / 64)
    Minimap.InformationFrame.Background:SetHeight(50)
    Minimap.InformationFrame.Background:SetPoint("TOPLEFT", Minimap.InformationFrame, "TOPLEFT", 0, 0)
    Minimap.InformationFrame.Background:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", 0, 0)

    MiniMapMailFrame:SetParent(Minimap.InformationFrame)
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", -25, 3)
    MiniMapMailIcon:SetTexture(R.media.textures.mailIcon)
    MiniMapMailIcon:SetTexCoord(0, 0.95, 0, 0.95)

    MiniMapMailBorder:SetTexture("Interface\\Calendar\\EventNotificationGlow")
    MiniMapMailBorder:SetBlendMode("ADD")
    MiniMapMailBorder:ClearAllPoints()
    MiniMapMailBorder:SetPoint("CENTER", MiniMapMailFrame, -0.5, 1.5)
    MiniMapMailBorder:SetSize(25, 25)
    MiniMapMailBorder:SetAlpha(0.4)

    if not MM.config.enableMailGlow then MiniMapMailBorder:Hide() end

    if MiniMapBattlefieldFrame then
        MiniMapBattlefieldFrame:SetSize(33, 33)
        MiniMapBattlefieldBorder:Hide()
        MiniMapBattlefieldIcon:SetSize(MiniMapBattlefieldFrame:GetSize())
    end

    if R.isRetail then
        MM:SecureHook("GarrisonLandingPageMinimapButton_UpdateIcon", function(self)
            GarrisonLandingPageMinimapButton:ClearAllPoints()
            GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 0)
        end)

        QueueStatusMinimapButton:SetParent(Minimap.InformationFrame)
        QueueStatusMinimapButton:SetSize(33, 33)
        QueueStatusMinimapButton:ClearAllPoints()
        QueueStatusMinimapButton:SetPoint("TOPLEFT", 40, 2)
        QueueStatusMinimapButtonBorder:Hide()
        QueueStatusMinimapButtonIcon:SetSize(QueueStatusMinimapButton:GetSize())
        
        MiniMapInstanceDifficulty:ClearAllPoints()
        MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 10, -10)
        GuildInstanceDifficulty:ClearAllPoints()
        GuildInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 10, -10)
        MiniMapChallengeMode:ClearAllPoints()
        MiniMapChallengeMode:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 10, -10)
    end

    MiniMapTrackingBackground:Hide()
    MiniMapTrackingButtonBorder:Hide()

    Minimap.InformationFrame.ButtonFrameToggle = CreateFrame("CheckButton", addonName .. "MinimapButtonFrameToggle", Minimap.InformationFrame)
    Minimap.InformationFrame.ButtonFrameToggle:SetSize(16, 16)
    Minimap.InformationFrame.ButtonFrameToggle:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", -5, 4)
    Minimap.InformationFrame.ButtonFrameToggle:SetChecked(not MM.config.buttonFrame.collapsed)
    Minimap.InformationFrame.ButtonFrameToggle:SetScript("OnEnter", MM.ButtonFrameToggle_OnEnter)
    Minimap.InformationFrame.ButtonFrameToggle:SetScript("OnLeave", MM.ButtonFrameToggle_OnLeave)
    Minimap.InformationFrame.ButtonFrameToggle:SetScript("OnClick", MM.ButtonFrameToggle_OnClick)

    Minimap.ButtonFrame = CreateFrame("Frame", "MinimapButtonFrame", UIParent)
    Minimap.ButtonFrame:Hide()
    Minimap.ButtonFrame:SetFrameStrata("MEDIUM")
    Minimap.ButtonFrame:SetFrameLevel(1)
    Minimap.ButtonFrame:EnableMouse(true)
    Minimap.ButtonFrame:SetSize(MM.config.buttonFrame.iconSize, MM.config.buttonFrame.iconSize)

    if MM.config.frameVisibility then
        Minimap.ButtonFrame.frameVisibility = MM.config.frameVisibility
        RegisterStateDriver(Minimap.ButtonFrame, "visibility", MM.config.frameVisibility)
    end

    Minimap.ButtonFrame:CreateFader(MM.config.fader)

    MM:ToggleButtonFrame()
    MM:UpdateMinimap()
end

function MM:UpdateMinimap()
    local width, height = unpack(MM.config.size)
    Minimap:SetSize(width, height)
    Minimap:SetMaskTexture(MM.config.mask)

    if MM.config.frameVisibility then
        MinimapCluster.frameVisibility = MM.config.frameVisibility
        RegisterStateDriver(MinimapCluster, "visibility", MM.config.frameVisibility)
    else
        UnregisterStateDriver(MinimapCluster, "visibility")
    end

    Minimap.Border:SetShown(MM.config.border.enabled)
    Minimap.Shadow:SetShown(MM.config.shadow.enabled)
    Minimap.InformationFrame:SetShown(MM.config.infoPanel.enabled)
    MinimapZoneText:SetShown(MM.config.zoneText.enabled)

    if MM.config.zoneText.enabled and MM.config.zoneText.showBackground then
        MinimapCluster.ZoneBackground:Show()
        MinimapCluster:SetSize(width, height + 30)
        Minimap:SetPoint("TOP", 0, -30)
    else
        MinimapCluster.ZoneBackground:Hide()
        MinimapCluster:SetSize(width, height)
        Minimap:SetPoint("TOP", 0, 0)
    end

    MinimapZoneText:SetFont(MM.config.zoneText.font, MM.config.zoneText.fontSize, MM.config.zoneText.fontOutline)
    MinimapZoneText:SetJustifyH(MM.config.zoneText.justifyH)
    MinimapZoneText:SetShadowOffset(MM.config.zoneText.fontShadow and 1 or 0, MM.config.zoneText.fontShadow and -2 or 0)

    if MM.config.infoPanel.enabled and MM.config.infoPanel.showBackground then
        Minimap.InformationFrame.Background:Show()

        Minimap.InformationFrame:ClearAllPoints()
        Minimap.InformationFrame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, 0)
        Minimap.InformationFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)

        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 0)

        MiniMapTracking:ClearAllPoints()
        MiniMapTracking:SetPoint("TOPLEFT", Minimap.InformationFrame, "TOPLEFT", 7, 2)

        Minimap.ButtonFrame:ClearAllPoints()
        Minimap.ButtonFrame:SetPoint("TOPLEFT", Minimap.InformationFrame, "BOTTOMLEFT", 0, 5)
        Minimap.ButtonFrame:SetPoint("TOPRIGHT", Minimap.InformationFrame, "BOTTOMRIGHT", 0, 5)

        if MiniMapBattlefieldFrame then
            MiniMapBattlefieldFrame:ClearAllPoints()
            MiniMapBattlefieldFrame:SetParent(Minimap.InformationFrame)
            MiniMapBattlefieldFrame:SetPoint("TOPLEFT", 5, 2)
        end
    else
        Minimap.InformationFrame.Background:Hide()

        Minimap.InformationFrame:ClearAllPoints()
        Minimap.InformationFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 0)
        Minimap.InformationFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)

        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 0)

        MiniMapTracking:ClearAllPoints()
        MiniMapTracking:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 6, 2)

        Minimap.ButtonFrame:ClearAllPoints()
        Minimap.ButtonFrame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, 0)
        Minimap.ButtonFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)

        if MiniMapBattlefieldFrame then
            MiniMapBattlefieldFrame:ClearAllPoints()
            MiniMapBattlefieldFrame:SetParent(Minimap)
            MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", 2, -2)
        end
    end

    MinimapNorthTag:SetShown(MM.config.showNorthTag)
    MiniMapMailBorder:SetShown(MM.config.enableMailGlow)

    MM:UpdateButtonFrame()
end

function MM:Minimap_OnMouseWheel(direction)
    if (direction > 0) then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

function MM:ButtonFrameToggle_UpdateTooltip()
    if not Minimap.InformationFrame.ButtonFrameToggle then return end

    GameTooltip:SetOwner(Minimap.InformationFrame.ButtonFrameToggle, "ANCHOR_TOPLEFT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine("Minimap", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    if Minimap.InformationFrame.ButtonFrameToggle:GetChecked() then
        GameTooltip:AddLine("Hide minimap buttons", 1, 1, 1)
    else
        GameTooltip:AddLine("Show minimap buttons", 1, 1, 1)
    end
    GameTooltip:Show()
end

function MM:ButtonFrameToggle_OnEnter() MM:ButtonFrameToggle_UpdateTooltip() end

function MM:ButtonFrameToggle_OnLeave() GameTooltip:Hide() end

function MM:ButtonFrameToggle_OnClick()
    MM:ButtonFrameToggle_UpdateTooltip()
    MM:ToggleButtonFrame()
end

function MM:UpdateButtonFrame()
    local spacing = MM.config.buttonFrame.buttonSpacing or 2
    local iconSize = MM.config.buttonFrame.iconSize or 27

    local columnCount, rowCount = 1, 1
    local anchor, relativeColumnAnchor, relativeRowAnchor, dirMult = "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", 1
    local actualWidth, availableWidth = 0, Minimap.ButtonFrame:GetWidth()
    local previousButton, previousRowFirstButton

    for _, button in pairs(MM.Buttons) do
        if button:IsVisible() then
            actualWidth = columnCount * iconSize + (columnCount - 1) * spacing

            if actualWidth > availableWidth then columnCount, rowCount = 1, rowCount + 1 end

            MM:UnlockButton(button)

            button:SetParent(Minimap.ButtonFrame)
            button:ClearAllPoints()
            if columnCount == 1 and rowCount == 1 then
                button:SetPoint(anchor, Minimap.ButtonFrame, anchor, spacing, -spacing)
            elseif columnCount == 1 and rowCount > 1 then
                button:SetPoint(anchor, previousRowFirstButton or Minimap.ButtonFrame, relativeRowAnchor, 0, -spacing)
            else
                button:SetPoint(anchor, previousButton, relativeColumnAnchor, spacing, 0)
            end

            button:SetSize(iconSize, iconSize)
            button:SetScale(1)
            button:SetFrameStrata("MEDIUM")
            button:SetFrameLevel(Minimap.ButtonFrame:GetFrameLevel() + 1)
            button:SetScript("OnDragStart", nil)
            button:SetScript("OnDragStop", nil)

            MM:LockButton(button)

            previousButton = button
            if columnCount == 1 then previousRowFirstButton = button end

            columnCount = columnCount + 1
        end
    end

    Minimap.ButtonFrame:SetHeight(2 * spacing + (iconSize * rowCount) + (spacing * (rowCount - 1)))
end

function MM:ToggleButtonFrame()
    if Minimap.InformationFrame.ButtonFrameToggle:GetChecked() then
        Minimap.ButtonFrame:Show()
        Minimap.InformationFrame.ButtonFrameToggle:SetNormalTexture(R.media.textures.arrowUp_Up)
        Minimap.InformationFrame.ButtonFrameToggle:SetPushedTexture(R.media.textures.arrowUp_Down)
        Minimap.InformationFrame.ButtonFrameToggle:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", -8, -1)
        MM.config.buttonFrame.collapsed = false
    else
        Minimap.ButtonFrame:Hide()
        Minimap.InformationFrame.ButtonFrameToggle:SetNormalTexture(R.media.textures.arrowDown_Up)
        Minimap.InformationFrame.ButtonFrameToggle:SetPushedTexture(R.media.textures.arrowDown_Down)
        Minimap.InformationFrame.ButtonFrameToggle:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", -8, -8)
        MM.config.buttonFrame.collapsed = true
    end
    MM:UpdateButtonFrame()
end
