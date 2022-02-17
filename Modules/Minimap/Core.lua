local addonName, ns = ...
local R = _G.ReduxUI
local MM = R:AddModule("Minimap", "AceEvent-3.0", "AceHook-3.0")
local L = R.L

function MM:Initialize()
    if not MM.config.enabled then return end

    MM:StyleMinimap()
end

function MM:StyleMinimap()
    local width, height = unpack(MM.config.size)

    MinimapCluster.config = MM.config
    MinimapCluster:SetSize(width, height + 30)
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint(unpack(MM.config.point))

    if MM.config.visibility then
        MinimapCluster.visibility = MM.config.visibility
        RegisterStateDriver(MinimapCluster, "visibility", MM.config.visibility)
    end

    R:CreateFader(MinimapCluster, MM.config.fader)
    R:CreateDragFrame(MinimapCluster, "Minimap", MM.config.point)

    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOP", 0, -30)
    Minimap:SetSize(width, height)
    R:CreateBorder(Minimap)
    R:CreateShadow(Minimap)

    MinimapZoneText:SetSize(190, 10)
    MinimapZoneText:SetPoint("TOP", MinimapCluster, "TOP", 0, -8)
    MinimapZoneText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    MinimapZoneText:SetJustifyH("CENTER")
    MinimapZoneText:SetShadowColor(0, 0, 0, 0.25)
    MinimapZoneText:SetShadowOffset(1, -2)

    MinimapNorthTag:ClearAllPoints()
    MinimapNorthTag:SetPoint("TOP", Minimap, "TOP", 0, -10)
    MinimapNorthTag:SetAlpha(1)

    Minimap:EnableMouseWheel()
    Minimap:SetScript("OnMouseWheel", MM.Minimap_OnMouseWheel)

    MinimapBorder:Hide()
    MinimapBorderTop:Hide()
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()
    R:Disable(MiniMapWorldMapButton)
    if not R.isRetail then MinimapToggleButton:Hide() end
    GameTimeFrame:Hide()

    LoadAddOn("Blizzard_TimeManager")
    TimeManagerClockButton:GetRegions():Hide()
    TimeManagerClockButton:ClearAllPoints()
    TimeManagerClockButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 0)
    TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    TimeManagerClockTicker:SetTextColor(0.8, 0.8, 0.6, 1)

    MM:CreateZoneBackground()
    MM:CreateInformationFrame()
    MM:CreateButtonFrame()

    MiniMapMailFrame:SetParent(Minimap.InformationFrame)
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", -25, 3)
    MiniMapMailIcon:SetTexture([[Interface\MINIMAP\TRACKING\Mailbox]])
    MiniMapMailIcon:SetTexCoord(0, 0.95, 0, 0.95)

    MiniMapMailBorder:SetTexture([[Interface\Calendar\EventNotificationGlow]])
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

        MiniMapTrackingButtonBorder:Hide()
    else
        MiniMapTrackingBorder:Hide()
    end

    MiniMapTrackingBackground:Hide()

    Minimap.ButtonFrame:Toggle()
    MM:UpdateMinimap()
end

function MM:UpdateMinimap()
    local width, height = unpack(MM.config.size)
    Minimap:SetSize(width, height)

    local mask = MM.config.border.enabled and [[interface\chatframe\chatframebackground]] or MM.config.mask
    Minimap:SetMaskTexture(mask)

    Minimap.Border:SetShown(MM.config.border.enabled)
    Minimap.Shadow:SetShown(MM.config.shadow.enabled)

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

    Minimap.InformationFrame:SetShown(MM.config.infoPanel.enabled)
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
        Minimap.ButtonFrame:SetPoint("TOPLEFT", Minimap.InformationFrame, "BOTTOMLEFT", 0, 0)
        Minimap.ButtonFrame:SetPoint("TOPRIGHT", Minimap.InformationFrame, "BOTTOMRIGHT", 0, 0)

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

    Minimap.ButtonFrame:Update()
end

function MM:Minimap_OnMouseWheel(direction)
    if (direction > 0) then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end
