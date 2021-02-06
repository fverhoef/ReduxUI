local addonName, ns = ...
local R = _G.ReduxUI
local MM = R:AddModule("Minimap", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

MM.Buttons = {}
MM.IgnoreButton = {
    "HelpOpenWebTicketButton",
    "MiniMapVoiceChatFrame",
    "TimeManagerClockButton",
    "BattlefieldMinimap",
    "ButtonCollectFrame",
    "GameTimeFrame",
    "QueueStatusMinimapButton",
    "GarrisonLandingPageMinimapButton",
    "MiniMapMailFrame",
    "MinimapZoneTextButton",
    "MinimapToggleButton",
    "MiniMapTracking",
    "MinimapZoomIn",
    "MinimapZoomOut",
    "RecipeRadarMinimapButtonFrame"
}
MM.GenericIgnore = {
    "Archy",
    "GatherMatePin",
    "GatherNote",
    "GuildInstance",
    "HandyNotesPin",
    "MiniMap",
    "Spy_MapNoteList_mini",
    "ZGVMarker",
    "poiMinimap",
    "GuildMap3Mini",
    "LibRockConfig-1.0_MinimapButton",
    "NauticusClassicMiniIcon",
    "NauticusMiniIcon",
    "WestPointer",
    "Cork",
    "DugisArrowMinimapPoint",
    "QuestieFrame"
}
MM.PartialIgnore = {"Node", "Note", "Pin", "POI"}
MM.UnrulyButtons = {"WIM3MinimapButton", "RecipeRadar_MinimapButton"}
MM.ButtonFunctions = {"SetParent", "ClearAllPoints", "SetPoint", "SetSize", "SetScale", "SetFrameStrata", "SetFrameLevel"}

function MM:Initialize()    
    if not MM.config.enabled then
        return
    end

    MM:StyleMinimap()

    -- TODO: check if it's possible to use events rather than a timed update
    MM:ScheduleTimer("GrabMinimapButtons", 1)
    MM:ScheduleRepeatingTimer("GrabMinimapButtons", 5)

    MiniMapTrackingFrame:HookScript("OnShow", function()
        MiniMapBattlefieldFrame:SetPoint("TOPLEFT", 32, 2)
    end)
end

function MM:LockButton(Button)
    for _, Function in pairs(MM.ButtonFunctions) do
        Button[Function] = function()
        end
    end
end

function MM:UnlockButton(Button)
    for _, Function in pairs(MM.ButtonFunctions) do
        Button[Function] = nil
    end
end

function MM:GrabMinimapButton(button)
    if (not button) or button.isSkinned then
        return
    end

    local name = button.GetName and button:GetName()
    if not name then
        return
    end

    if tContains(MM.IgnoreButton, name) then
        return
    end

    for i = 1, #MM.GenericIgnore do
        if string.sub(name, 1, string.len(MM.GenericIgnore[i])) == MM.GenericIgnore[i] then
            return
        end
    end

    for i = 1, #MM.PartialIgnore do
        if string.find(name, MM.PartialIgnore[i]) ~= nil then
            return
        end
    end

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
                region.SetTexCoord = function()
                    return
                end
            end
        end
    end

    button.isSkinned = true
    tinsert(MM.Buttons, button)

    return button.isSkinned
end

function MM:GrabChildren(frame)
    local numChildren = frame:GetNumChildren()
    if numChildren < (frame.numChildren or 0) then
        return
    end

    for i = 1, numChildren do
        local object = select(i, frame:GetChildren())
        if object and not object.isSkinned then
            local name = object:GetName()
            local width = object:GetWidth()
            if name and width > 15 and width < 60 and (object:IsObjectType("Button") or object:IsObjectType("Frame")) then
                if MM:GrabMinimapButton(object) then
                    grabbedAnyButtons = true
                end
            end
        end
    end

    frame.numChildren = numChildren

    return grabbedAnyButtons
end

function MM:GrabMinimapButtons()
    if (InCombatLockdown() or C_PetBattles and C_PetBattles.IsInBattle()) then
        return
    end

    for _, button in pairs(MM.UnrulyButtons) do
        if _G[button] then
            _G[button]:SetParent(Minimap)
        end
    end

    local grabbedAnyButtons = MM:GrabChildren(Minimap)
    grabbedAnyButtons = MM:GrabChildren(MinimapBackdrop) or grabbedAnyButtons
    grabbedAnyButtons = MM:GrabChildren(MinimapCluster) or grabbedAnyButtons

    if grabbedAnyButtons then
        MM:UpdateButtonFrame()
    end
end

function MM:StyleMinimap()
    -- MinimapCluster
    MinimapCluster.cfg = MM.config
    MinimapCluster:SetSize(190, 240)
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint(unpack(MM.config.point))

    if MM.config.frameVisibility then
        MinimapCluster.frameVisibility = MM.config.frameVisibility
        RegisterStateDriver(MinimapCluster, "visibility", MM.config.frameVisibility)
    end

    if MM.config.fader and MM.config.fader.enabled then
        R:CreateFrameFader(MinimapCluster, MM.config.fader)
    end

    R:CreateDragFrame(MinimapCluster, "Minimap", MM.config.point)

    -- Minimap
    Minimap:SetMaskTexture(R.media.textures.minimap.minimapMask1)
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOP", 0, -30)
    Minimap:SetSize(190, 190) -- correct the cluster offset

    -- MinimapZoneText
    MinimapZoneText:SetSize(190, 10)
    MinimapZoneText:SetPoint("TOP", MinimapCluster, "TOP", 0, -10)
    MinimapZoneText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    MinimapZoneText:SetJustifyH("CENTER")
    MinimapZoneText:SetShadowColor(0, 0, 0, 0.25)
    MinimapZoneText:SetShadowOffset(1, -2)

    -- ZoneBackground
    MinimapCluster.ZoneBackground = MinimapCluster:CreateTexture("BACKGROUND")
    MinimapCluster.ZoneBackground:SetTexture(R.media.textures.bonusObjectives)
    MinimapCluster.ZoneBackground:SetTexCoord(30 / 512, (30 + 364) / 512, 183 / 512, (183 + 78) / 512)
    MinimapCluster.ZoneBackground:SetSize(370, 70)
    MinimapCluster.ZoneBackground:SetScale(0.5)
    MinimapCluster.ZoneBackground:SetPoint("TOP", MinimapCluster, "TOP", 0, -1)

    -- MiniMapNorthTag
    MinimapNorthTag:ClearAllPoints()
    MinimapNorthTag:SetPoint("TOP", Minimap, "TOP", 0, -10)
    MinimapNorthTag:SetAlpha(1)

    -- zoom
    Minimap:EnableMouseWheel()
    Minimap:SetScript("OnMouseWheel", MM.Minimap_OnMouseWheel)

    -- hide regions
    MinimapBorder:Hide()
    MinimapBorderTop:Hide()
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()
    MiniMapWorldMapButton:Hide()
    MinimapToggleButton:Hide()
    GameTimeFrame:Hide()

    -- Blizzard_TimeManager
    LoadAddOn("Blizzard_TimeManager")
    TimeManagerClockButton:GetRegions():Hide()
    TimeManagerClockButton:ClearAllPoints()
    TimeManagerClockButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 0)
    TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    TimeManagerClockTicker:SetTextColor(0.8, 0.8, 0.6, 1)

    -- InformationFrame
    Minimap.InformationFrame = CreateFrame("FRAME", addonName .. "MinimapInformationFrame", Minimap)
    Minimap.InformationFrame:SetPoint("TOP", Minimap, "BOTTOM", 0, 0)
    Minimap.InformationFrame:SetSize(192, 40)

    Minimap.InformationFrame.Background = Minimap.InformationFrame:CreateTexture("BACKGROUND")
    Minimap.InformationFrame.Background:SetTexture(R.media.textures.autoQuestParts)
    Minimap.InformationFrame.Background:SetTexCoord(224 / 512, (224 + 245) / 512, 0 / 64, 64 / 64)
    Minimap.InformationFrame.Background:SetSize(192, 50)
    Minimap.InformationFrame.Background:SetPoint("TOP", Minimap.InformationFrame, "TOP", 0, 0)

    -- mail
    MiniMapMailFrame:SetParent(Minimap.InformationFrame)
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", -25, 3)
    MiniMapMailIcon:SetTexture(R.media.textures.mailIcon)
    MiniMapMailIcon:SetTexCoord(0, 0.95, 0, 0.95)
    if MM.config.enableMailGlow then
        MiniMapMailBorder:SetTexture("Interface\\Calendar\\EventNotificationGlow")
        MiniMapMailBorder:SetBlendMode("ADD")
        MiniMapMailBorder:ClearAllPoints()
        MiniMapMailBorder:SetPoint("CENTER", MiniMapMailFrame, -0.5, 1.5)
        MiniMapMailBorder:SetSize(25, 25)
        MiniMapMailBorder:SetAlpha(0.4)
    else
        MiniMapMailBorder:Hide()
    end

    if MiniMapBattlefieldFrame then
        MiniMapBattlefieldFrame:SetParent(Minimap.InformationFrame)
        MiniMapBattlefieldFrame:SetSize(33, 33)
        MiniMapBattlefieldFrame:ClearAllPoints()
        MiniMapBattlefieldFrame:SetPoint("TOPLEFT", 5, 2)

        MiniMapBattlefieldBorder:Hide()

        MiniMapBattlefieldIcon:SetSize(MiniMapBattlefieldFrame:GetSize())
    end

    -- queue/garrison
    if R.isRetail then
        GarrisonLandingPageMinimapButton:SetParent(Minimap.InformationFrame)
        GarrisonLandingPageMinimapButton:ClearAllPoints()
        GarrisonLandingPageMinimapButton:SetPoint("TOPLEFT", 5, 2)

        QueueStatusMinimapButton:SetParent(Minimap.InformationFrame)
        QueueStatusMinimapButton:SetSize(33, 33)
        QueueStatusMinimapButton:ClearAllPoints()
        QueueStatusMinimapButton:SetPoint("TOPLEFT", 40, 2)
        QueueStatusMinimapButtonBorder:Hide()
        QueueStatusMinimapButtonIcon:SetSize(QueueStatusMinimapButton:GetSize())
    end

    -- MiniMapTracking
    MiniMapTrackingFrame:SetParent(Minimap.InformationFrame)
    MiniMapTrackingFrame:SetScale(0.8)
    MiniMapTrackingFrame:SetSize(33, 33)
    MiniMapTrackingFrame:ClearAllPoints()
    MiniMapTrackingFrame:SetPoint("TOPLEFT", 11, -2)
    MiniMapTrackingBorder:ClearAllPoints()
    MiniMapTrackingBorder:SetPoint("CENTER", 0, 0)
    MiniMapTrackingBorder:SetSize(41, 41)
    MiniMapTrackingBorder:SetTexture(R.media.textures.minimap.minimapButtonBorder)
    -- MiniMapTrackingBorder:Hide()
    -- MiniMapTrackingIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    MiniMapTrackingIcon:ClearAllPoints()
    MiniMapTrackingIcon:SetPoint("CENTER", 0, 1)
    MiniMapTrackingIcon:SetSize(20, 20)
    MiniMapTrackingIcon:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")

    -- button frame toggle
    Minimap.InformationFrame.ButtonFrameToggle = CreateFrame("CheckButton", addonName .. "MinimapButtonFrameToggle", Minimap.InformationFrame)
    Minimap.InformationFrame.ButtonFrameToggle:SetSize(16, 16)
    Minimap.InformationFrame.ButtonFrameToggle:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", -5, 4)
    Minimap.InformationFrame.ButtonFrameToggle:SetChecked(not MM.config.buttonFrame.collapsed)
    Minimap.InformationFrame.ButtonFrameToggle:SetScript("OnEnter", MM.ButtonFrameToggle_OnEnter)
    Minimap.InformationFrame.ButtonFrameToggle:SetScript("OnLeave", MM.ButtonFrameToggle_OnLeave)
    Minimap.InformationFrame.ButtonFrameToggle:SetScript("OnClick", MM.ButtonFrameToggle_OnClick)

    -- button frame
    Minimap.ButtonFrame = CreateFrame("Frame", "MinimapButtonFrame", UIParent)
    Minimap.ButtonFrame:Hide()
    Minimap.ButtonFrame:SetPoint("TOP", Minimap.InformationFrame, "BOTTOM", 0, 15)
    Minimap.ButtonFrame:SetFrameStrata("MEDIUM")
    Minimap.ButtonFrame:SetFrameLevel(1)
    Minimap.ButtonFrame:EnableMouse(true)
    Minimap.ButtonFrame:SetSize(MM.config.buttonFrame.iconSize, MM.config.buttonFrame.iconSize)

    if MM.config.frameVisibility then
        Minimap.ButtonFrame.frameVisibility = MM.config.frameVisibility
        RegisterStateDriver(Minimap.ButtonFrame, "visibility", MM.config.frameVisibility)
    end

    if MM.config.fader and MM.config.fader.enabled then
        R:CreateFrameFader(Minimap.ButtonFrame, MM.config.fader)
    end

    MM:ToggleButtonFrame()
end

function MM:Minimap_OnMouseWheel(direction)
    if (direction > 0) then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

function MM:ButtonFrameToggle_UpdateTooltip()
    if not Minimap.InformationFrame.ButtonFrameToggle then
        return
    end

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

function MM:ButtonFrameToggle_OnEnter()
    MM:ButtonFrameToggle_UpdateTooltip()
end

function MM:ButtonFrameToggle_OnLeave()
    GameTooltip:Hide()
end

function MM:ButtonFrameToggle_OnClick()
    MM:ButtonFrameToggle_UpdateTooltip()
    MM:ToggleButtonFrame()
end

function MM:UpdateButtonFrame()
    local anchorX, anchorY = 0, 1
    local buttonsPerRow = MM.config.buttonFrame.buttonsPerRow or 12
    local spacing = MM.config.buttonFrame.buttonSpacing or 2
    local size = MM.config.buttonFrame.iconSize or 27
    local actualButtons, maxed = 0

    local anchor, dirMult = "TOPLEFT", 1

    for _, button in pairs(MM.Buttons) do
        if button:IsVisible() then
            anchorX, actualButtons = anchorX + 1, actualButtons + 1

            if (anchorX % (buttonsPerRow + 1)) == 0 then
                anchorY, anchorX, maxed = anchorY + 1, 1, true
            end

            MM:UnlockButton(button)

            button:SetParent(Minimap.ButtonFrame)
            button:ClearAllPoints()
            button:SetPoint(anchor, Minimap.ButtonFrame, anchor, dirMult * (spacing + ((size + spacing) * (anchorX - 1))), (-spacing - ((size + spacing) * (anchorY - 1))))
            button:SetSize(MM.config.buttonFrame.iconSize, MM.config.buttonFrame.iconSize)
            button:SetScale(1)
            button:SetFrameStrata("MEDIUM")
            button:SetFrameLevel(Minimap.ButtonFrame:GetFrameLevel() + 1)
            button:SetScript("OnDragStart", nil)
            button:SetScript("OnDragStop", nil)

            MM:LockButton(button)

            if maxed then
                actualButtons = buttonsPerRow
            end
        end
    end

    local barWidth = spacing + (size * actualButtons) + (spacing * (actualButtons - 1)) + spacing
    local barHeight = spacing + (size * anchorY) + (spacing * (anchorY - 1)) + spacing

    Minimap.ButtonFrame:SetSize(barWidth, barHeight)
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
