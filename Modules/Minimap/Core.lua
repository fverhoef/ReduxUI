local addonName, ns = ...
local R = _G.ReduxUI
local MM = R:AddModule("Minimap", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local L = R.L

MM.Styles = {}

function MM:Initialize()
end

function MM:Enable()
    if not MM.config.enabled then
        return
    end

    MM:StyleMinimap()
end

function MM:StyleMinimap()
    MinimapCluster.config = MM.config
    MinimapCluster.defaults = MM.defaults
    MinimapCluster:CreateFader(MM.config.fader)
    MinimapCluster:CreateMover("Minimap", MM.defaults.point)

    if MM.config.visibility then
        MinimapCluster.visibility = MM.config.visibility
        RegisterStateDriver(MinimapCluster, "visibility", MM.config.visibility)
    end

    MinimapButtonFrameToggleButton = CreateFrame("CheckButton", "MinimapButtonFrameToggleButton", Minimap, "MinimapButtonFrameToggleButtonTemplate")
    MinimapButtonFrameToggleButton:SetChecked(not MM.config.buttonFrame.collapsed)
    MinimapButtonFrameToggleButton:CreateFader(R.config.faders.onShow)

    MinimapButtonFrame = CreateFrame("Frame", "MinimapButtonFrame", Minimap, "MinimapButtonFrameTemplate")
    MinimapButtonFrame:SetShown(not MM.config.buttonFrame.collapsed)
    MinimapButtonFrame:CreateFader(MM.config.buttonFrame.fader, MinimapButtonFrame.Buttons)

    MinimapZonePanel = CreateFrame("Frame", "MinimapZonePanel", MinimapCluster)
    MinimapZonePanel:SetSize(140, 12)
    MinimapZonePanel:SetPoint("TOP", 0, -2)
    MinimapZonePanel.Background = MinimapCluster:CreateTexture("BACKGROUND")
    MinimapZonePanel.Background:SetTexture(R.media.textures.minimap.vanilla.zoneBorder)
    MinimapZonePanel.Background:SetTexCoord(0, 1, 0, 78 / 128)
    MinimapZonePanel.Background:SetPoint("TOPLEFT", MinimapZonePanel, "TOPLEFT", 0, 2)
    MinimapZonePanel.Background:SetPoint("BOTTOMRIGHT", MinimapZonePanel, "BOTTOMRIGHT", 0, -2)
    MinimapZonePanel.BackgroundLeft = MinimapZonePanel:CreateTexture("$parentBackgroundLeft", "BACKGROUND")
    MinimapZonePanel.BackgroundLeft:SetTexture(R.media.textures.minimap.modern.atlas)
    MinimapZonePanel.BackgroundLeft:SetTexCoord(443 / 512, 451 / 512, 404 / 1024, 440 / 1024)
    MinimapZonePanel.BackgroundLeft:SetWidth(4)
    MinimapZonePanel.BackgroundLeft:SetPoint("TOPLEFT", MinimapZonePanel, "TOPLEFT", 0, 0)
    MinimapZonePanel.BackgroundLeft:SetPoint("BOTTOMLEFT", MinimapZonePanel, "BOTTOMLEFT", 0, 0)
    MinimapZonePanel.BackgroundMiddle = MinimapZonePanel:CreateTexture("$parentBackgroundMiddle", "BACKGROUND")
    MinimapZonePanel.BackgroundMiddle:SetTexture(R.media.textures.minimap.modern.atlas)
    MinimapZonePanel.BackgroundMiddle:SetTexCoord(452 / 512, 470 / 512, 404 / 1024, 440 / 1024)
    MinimapZonePanel.BackgroundMiddle:SetPoint("TOPLEFT", MinimapZonePanel, "TOPLEFT", 4, 0)
    MinimapZonePanel.BackgroundMiddle:SetPoint("BOTTOMRIGHT", MinimapZonePanel, "BOTTOMRIGHT", -4, 0)
    MinimapZonePanel.BackgroundRight = MinimapZonePanel:CreateTexture("$parentBackgroundRight", "BACKGROUND")
    MinimapZonePanel.BackgroundRight:SetTexture(R.media.textures.minimap.modern.atlas)
    MinimapZonePanel.BackgroundRight:SetTexCoord(471 / 512, 479 / 512, 404 / 1024, 440 / 1024)
    MinimapZonePanel.BackgroundRight:SetWidth(4)
    MinimapZonePanel.BackgroundRight:SetPoint("TOPRIGHT", MinimapZonePanel, "TOPRIGHT", 0, 0)
    MinimapZonePanel.BackgroundRight:SetPoint("BOTTOMRIGHT", MinimapZonePanel, "BOTTOMRIGHT", 0, 0)

    MinimapZoneText:ClearAllPoints()
    MinimapZoneText:SetAllPoints()

    MinimapBorderTop:Hide()

    MinimapZoomHitArea = CreateFrame("Frame", "MinimapZoomHitArea", Minimap)
    MinimapZoomHitArea:EnableMouse(true)
    MinimapZoomHitArea:SetPoint("TOPRIGHT", MinimapZoomIn, "TOPRIGHT")
    MinimapZoomHitArea:SetPoint("BOTTOMLEFT", MinimapZoomOut, "BOTTOMLEFT")

    MinimapZoomIn:CreateFader(R.config.faders.onShow)
    MinimapZoomOut:CreateFader(R.config.faders.onShow)

    MinimapNorthTag:ClearAllPoints()
    MinimapNorthTag:SetPoint("TOP", Minimap, "TOP", 0, -15)
    MinimapNorthTag.__texture = MinimapNorthTag:GetTexture()

    Minimap:EnableMouseWheel()
    MM:SecureHookScript(Minimap, "OnMouseWheel", MM.Minimap_OnMouseWheel)
    MM:SecureHookScript(Minimap, "OnEnter", MM.Minimap_OnEnter)
    MM:SecureHookScript(Minimap, "OnLeave", MM.Minimap_OnLeave)
    MM:Minimap_OnLeave()

    MM.OnLeaveTimer = MM:ScheduleRepeatingTimer(MM.Minimap_OnLeave, 0.5)
    MM:SecureHookScript(GameTimeFrame, "OnLeave", MM.Minimap_OnLeave)
    MM:SecureHookScript(MiniMapWorldMapButton, "OnLeave", MM.Minimap_OnLeave)
    MM:SecureHookScript(MiniMapMailFrame, "OnLeave", MM.Minimap_OnLeave)
    MM:SecureHookScript(MinimapButtonFrameToggleButton, "OnLeave", MM.Minimap_OnLeave)
    MM:SecureHookScript(MiniMapInstanceDifficulty, "OnLeave", MM.Minimap_OnLeave)
    MM:SecureHookScript(MiniMapTracking, "OnLeave", MM.Minimap_OnLeave)
    MM:SecureHookScript(MiniMapBattlefieldFrame, "OnLeave", MM.Minimap_OnLeave)
    MM:SecureHookScript(MiniMapLFGFrame, "OnLeave", MM.Minimap_OnLeave)

    MM:UpdateMinimap()
end

function MM:UpdateMinimap()
    local width, height = unpack(MM.config.size)

    local radius = width / 2 - 5
    local x, y

    if MM.config.style == MM.Styles.Vanilla then
        MinimapCluster:ClearAllPoints()
        MinimapCluster:SetPoint(unpack(MM.config.point))
        MinimapCluster:SetSize(width, height + 35)

        Minimap:ClearAllPoints()
        Minimap:SetPoint("TOPLEFT", 0, -35)
        Minimap:SetPoint("BOTTOMRIGHT", 0, 0)
        Minimap:SetSize(width, height)
        Minimap:SetMaskTexture(R.media.textures.minimap.vanilla.mask)

        MinimapBackdrop:ClearAllPoints()
        MinimapBackdrop:SetOutside(Minimap, 5, 5)

        MinimapBorder:ClearAllPoints()
        MinimapBorder:SetAllPoints()
        MinimapBorder:SetTexture(R.media.textures.minimap.vanilla.border)
        MinimapBorder:SetTexCoord(0, 1, 0, 1)
    elseif MM.config.style == MM.Styles.Modern then
        MinimapCluster:ClearAllPoints()
        MinimapCluster:SetPoint(unpack(MM.config.point))
        MinimapCluster:SetSize(width, height + 25)

        Minimap:ClearAllPoints()
        Minimap:SetPoint("TOPLEFT", 0, -25)
        Minimap:SetPoint("BOTTOMRIGHT", 0, 0)
        Minimap:SetSize(width, height + (height / 220) * 6)
        Minimap:SetMaskTexture(R.media.textures.minimap.modern.mask)

        MinimapBackdrop:ClearAllPoints()
        MinimapBackdrop:SetPoint("TOPLEFT", -3, 5)
        MinimapBackdrop:SetPoint("BOTTOMRIGHT", 6, -6)
        
        MinimapBorder:ClearAllPoints()
        MinimapBorder:SetAllPoints()
        MinimapBorder:SetTexture(R.media.textures.minimap.modern.atlas)
        MinimapBorder:SetTexCoord(0, 440 / 512, 57 / 1024, 509 / 1024)
    end

    MinimapNorthTag:SetTexture(MM.config.showNorthTag and MinimapNorthTag.__texture or nil)

    MM:UpdateZoom(radius)
    MM:UpdateTracking(radius)
    MM:UpdateTimeManager(radius)
    MM:UpdateZonePanel(width, height)
    MM:UpdateCalendar(radius)
    MM:UpdateMail(radius)
    MM:UpdateButtonFrame(radius, width)

    x, y = R:PolarToXY(55, radius)
    if not MM.config.showWorldMap then
        MiniMapWorldMapButton:SetParent(R.HiddenFrame)
    else
        MiniMapWorldMapButton:SetParent(MinimapBackdrop)
        MiniMapWorldMapButton:SetScale(MinimapBackdrop:GetScale())
        MiniMapWorldMapButton:ClearAllPoints()
        MiniMapWorldMapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
        MiniMapWorldMapButton:Show()
    end

    x, y = R:PolarToXY(-35, radius)
    MiniMapInstanceDifficulty:ClearAllPoints()
    MiniMapInstanceDifficulty:SetPoint("CENTER", Minimap, "CENTER", x, y)

    x, y = R:PolarToXY(-72, radius)
    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)

    x, y = R:PolarToXY(-72, radius)
    MiniMapLFGFrame:ClearAllPoints()
    MiniMapLFGFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

function MM:UpdateZoom(radius)
    local x, y
    if MM.config.style == MM.Styles.Vanilla then
        x, y = R:PolarToXY(127, radius)
        MinimapZoomIn:SetSize(32, 32)
        MinimapZoomIn:ClearAllPoints()
        MinimapZoomIn:SetPoint("CENTER", Minimap, "CENTER", x, y)
        MinimapZoomIn:SetNormalTexture([[Interface\Minimap\UI-Minimap-ZoomInButton-Up]])
        MinimapZoomIn:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
        MinimapZoomIn:SetPushedTexture([[Interface\Minimap\UI-Minimap-ZoomInButton-Down]])
        MinimapZoomIn:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
        MinimapZoomIn:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
        MinimapZoomIn:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
        MinimapZoomIn:SetDisabledTexture([[Interface\Minimap\UI-Minimap-ZoomInButton-Disabled]])
        MinimapZoomIn:GetDisabledTexture():SetTexCoord(0, 1, 0, 1)

        x, y = R:PolarToXY(143, radius)
        MinimapZoomOut:SetSize(32, 32)
        MinimapZoomOut:ClearAllPoints()
        MinimapZoomOut:SetPoint("CENTER", Minimap, "CENTER", x, y)
        MinimapZoomOut:SetNormalTexture([[Interface\Minimap\UI-Minimap-ZoomOutButton-Up]])
        MinimapZoomOut:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
        MinimapZoomOut:SetPushedTexture([[Interface\Minimap\UI-Minimap-ZoomOutButton-Down]])
        MinimapZoomOut:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
        MinimapZoomOut:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
        MinimapZoomOut:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
        MinimapZoomOut:SetDisabledTexture([[Interface\Minimap\UI-Minimap-ZoomOutButton-Disabled]])
        MinimapZoomOut:GetDisabledTexture():SetTexCoord(0, 1, 0, 1)
    elseif MM.config.style == MM.Styles.Modern then
        x, y = R:PolarToXY(129, radius + 15)
        MinimapZoomIn:SetSize(24, 24)
        MinimapZoomIn:ClearAllPoints()
        MinimapZoomIn:SetPoint("CENTER", Minimap, "CENTER", x, y)
        MinimapZoomIn:SetNormalTexture(R.media.textures.minimap.modern.atlas)
        MinimapZoomIn:GetNormalTexture():SetTexCoord(0, 36 / 512, 551 / 1024, 587 / 1024)
        MinimapZoomIn:SetPushedTexture(R.media.textures.minimap.modern.atlas)
        MinimapZoomIn:GetPushedTexture():SetTexCoord(0, 36 / 512, 587 / 1024, 623 / 1024)
        MinimapZoomIn:SetHighlightTexture(R.media.textures.minimap.modern.atlas)
        MinimapZoomIn:GetHighlightTexture():SetTexCoord(0, 36 / 512, 623 / 1024, 659 / 1024)
        MinimapZoomIn:SetDisabledTexture(R.media.textures.minimap.modern.atlas)
        MinimapZoomIn:GetDisabledTexture():SetTexCoord(0, 36 / 512, 659 / 1024, 695 / 1024)

        x, y = R:PolarToXY(141, radius + 15)
        MinimapZoomOut:SetSize(24, 24)
        MinimapZoomOut:ClearAllPoints()
        MinimapZoomOut:SetPoint("CENTER", Minimap, "CENTER", x, y)
        MinimapZoomOut:SetNormalTexture(R.media.textures.minimap.modern.atlas)
        MinimapZoomOut:GetNormalTexture():SetTexCoord(180 / 512, 216 / 512, 511 / 1024, 547 / 1024)
        MinimapZoomOut:SetPushedTexture(R.media.textures.minimap.modern.atlas)
        MinimapZoomOut:GetPushedTexture():SetTexCoord(216 / 512, 252 / 512, 511 / 1024, 547 / 1024)
        MinimapZoomOut:SetHighlightTexture(R.media.textures.minimap.modern.atlas)
        MinimapZoomOut:GetHighlightTexture():SetTexCoord(252 / 512, 288 / 512, 511 / 1024, 547 / 1024)
        MinimapZoomOut:SetDisabledTexture(R.media.textures.minimap.modern.atlas)
        MinimapZoomOut:GetDisabledTexture():SetTexCoord(288 / 512, 324 / 512, 511 / 1024, 547 / 1024)
    end
end

function MM:UpdateTracking(radius)
    local x, y
    if MM.config.style == MM.Styles.Vanilla then
        x, y = R:PolarToXY(-55, radius)
        MiniMapTracking:ClearAllPoints()
        MiniMapTracking:SetPoint("CENTER", Minimap, "CENTER", x, y)
        MiniMapTracking:SetSize(32, 32)

        if MiniMapTracking.Background then
            MiniMapTracking.Background:Hide()
        end

        MiniMapTrackingButton:SetSize(32, 32)

        if MiniMapTrackingButton.HighlightTexture then
            MiniMapTrackingButton:SetHighlightTexture(MiniMapTrackingButton.HighlightTexture)
        end

        MiniMapTrackingBackground:Show()
        MiniMapTrackingButtonBorder:Show()

        MM:TrackingButton_OnMouseUpDown()
        if MiniMapTrackingIconOverlay.Texture then
            MiniMapTrackingIconOverlay:SetTexture(MiniMapTrackingIconOverlay.Texture)
        end
    elseif MM.config.style == MM.Styles.Modern then

        MiniMapTracking:ClearAllPoints()
        MiniMapTracking:SetPoint("TOPRIGHT", MinimapZonePanel, "TOPLEFT", -2, -1)
        MiniMapTracking:SetSize(16, 15)

        MiniMapTracking.Background = MiniMapTracking.Background or MiniMapTracking:CreateTexture("$parentBackground", "BACKGROUND")
        MiniMapTracking.Background:SetTexture(R.media.textures.minimap.modern.atlas)
        MiniMapTracking.Background:SetTexCoord(443 / 512, 479 / 512, 404 / 1024, 440 / 1024)
        MiniMapTracking.Background:SetPoint("TOPLEFT", -1, 1)
        MiniMapTracking.Background:SetPoint("BOTTOMRIGHT", 1, -2)

        MiniMapTrackingButton:SetSize(14, 14)
        MiniMapTrackingButton.HighlightTexture = MiniMapTrackingButton.HighlightTexture or MiniMapTrackingButton:GetHighlightTexture()
        MiniMapTrackingButton:SetHighlightTexture(nil)
        if not MM:IsHooked(MiniMapTrackingButton, "OnMouseDown") then
            MM:SecureHookScript(MiniMapTrackingButton, "OnMouseDown", MM.TrackingButton_OnMouseUpDown)
        end
        if not MM:IsHooked(MiniMapTrackingButton, "OnMouseUp") then
            MM:SecureHookScript(MiniMapTrackingButton, "OnMouseUp", MM.TrackingButton_OnMouseUpDown)
        end

        MiniMapTrackingBackground:Hide()
        MiniMapTrackingButtonBorder:Hide()

        MM:TrackingButton_OnMouseUpDown()
        MiniMapTrackingIconOverlay.Texture = MiniMapTrackingIconOverlay.Texture or MiniMapTrackingIconOverlay:GetTexture()
        MiniMapTrackingIconOverlay:SetTexture(nil)
    end
end

function MM:UpdateTimeManager(radius)
    local x, y
    if MM.config.style == MM.Styles.Vanilla then
        LoadAddOn("Blizzard_TimeManager")
        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 23)
        TimeManagerClockButton:SetSize(1.1 * 60, 1.1 * 28)
        TimeManagerClockButton:GetRegions():Show()
        TimeManagerClockTicker:ClearAllPoints()
        TimeManagerClockTicker:SetPoint("CENTER", 1, 0)
        TimeManagerClockTicker:SetJustifyH("CENTER")
    elseif MM.config.style == MM.Styles.Modern then
        LoadAddOn("Blizzard_TimeManager")
        TimeManagerClockButton:GetRegions():Hide()
        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetSize(45, 12)
        TimeManagerClockButton:SetPoint("TOPRIGHT", MinimapZonePanel, "TOPRIGHT", -5, -2)
        TimeManagerClockTicker:ClearAllPoints()
        TimeManagerClockTicker:SetPoint("RIGHT")
        TimeManagerClockTicker:SetFont(MM.config.timeText.font, MM.config.timeText.fontSize, MM.config.timeText.fontOutline)
        TimeManagerClockTicker:SetShadowColor(0, 0, 0, 0.25)
        TimeManagerClockTicker:SetShadowOffset(1, -2)
        TimeManagerClockTicker:SetJustifyH("RIGHT")
    end
end

function MM:UpdateZonePanel(width, height)
    if MM.config.style == MM.Styles.Vanilla then
        MinimapZoneTextButton:SetSize(190, 10)
        MinimapZoneTextButton:ClearAllPoints()
        MinimapZoneTextButton:SetPoint("CENTER", MinimapZonePanel, "CENTER", 0, 0)

        MinimapZonePanel:ClearAllPoints()
        MinimapZonePanel:SetPoint("TOPLEFT", 0, -2)
        MinimapZonePanel:SetSize(width, 24)
        MinimapZonePanel.Background:Show()
        MinimapZonePanel.BackgroundLeft:Hide()
        MinimapZonePanel.BackgroundMiddle:Hide()
        MinimapZonePanel.BackgroundRight:Hide()
    elseif MM.config.style == MM.Styles.Modern then
        MinimapZoneTextButton:SetSize(135, 12)
        MinimapZoneTextButton:ClearAllPoints()
        MinimapZoneTextButton:SetPoint("TOPLEFT", MinimapZonePanel, "TOPLEFT", 5, -2)

        MinimapZonePanel:ClearAllPoints()
        MinimapZonePanel:SetPoint("TOP", 0, 0)
        MinimapZonePanel:SetSize(188, 18)
        MinimapZonePanel.Background:Hide()
        MinimapZonePanel.BackgroundLeft:Show()
        MinimapZonePanel.BackgroundMiddle:Show()
        MinimapZonePanel.BackgroundRight:Show()
    end

    MinimapZoneText:SetShown(MM.config.zonePanel.enabled and MM.config.zonePanel.zoneText.enabled)
    MinimapZoneText:SetFont(MM.config.zonePanel.zoneText.font, MM.config.zonePanel.zoneText.fontSize, MM.config.zonePanel.zoneText.fontOutline)
    MinimapZoneText:SetJustifyH(MM.config.zonePanel.zoneText.justifyH)
    MinimapZoneText:SetShadowOffset(MM.config.zonePanel.zoneText.fontShadow and 1 or 0, MM.config.zonePanel.zoneText.fontShadow and -2 or 0)

    MinimapZonePanel:SetShown(MM.config.zonePanel.enabled and MM.config.zonePanel.showBorder)
end

function MM:UpdateCalendar(radius)
    local x, y
    if MM.config.style == MM.Styles.Vanilla then
        x, y = R:PolarToXY(35, radius)
        GameTimeFrame:ClearAllPoints()
        GameTimeFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)
        GameTimeFrame:SetSize(40, 40)
        GameTimeFrame:SetHitRectInsets(6, 0, 5, 10)
        GameTimeFrame:SetNormalFontObject(GameFontBlack)

        if GameTimeFrame.NormalTexture then
            GameTimeFrame:SetNormalTexture([[Interface\Calendar\UI-Calendar-Button]])
            GameTimeFrame:GetNormalTexture():SetTexCoord(0, 0.390625, 0, 0.78125)
        end
        if GameTimeFrame.PushedTexture then
            GameTimeFrame:SetPushedTexture([[Interface\Calendar\UI-Calendar-Button]])
            GameTimeFrame:GetPushedTexture():SetTexCoord(0.5, 0.890625, 0, 0.78125)
        end
        if GameTimeFrame.HighlightTexture then
            GameTimeFrame:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
            GameTimeFrame:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
        end
        if GameTimeFrame.Background then
            GameTimeFrame.Background:Hide()
        end
        if GameTimeCalendarInvitesGlow.Texture then
            GameTimeCalendarInvitesGlow:SetTexture(GameTimeCalendarInvitesGlow.Texture)
        end
        if GameTimeCalendarEventAlarmTexture.Texture then
            GameTimeCalendarEventAlarmTexture:SetTexture(GameTimeCalendarEventAlarmTexture.Texture)
        end
    elseif MM.config.style == MM.Styles.Modern then
        GameTimeFrame:ClearAllPoints()
        GameTimeFrame:SetPoint("TOPLEFT", MinimapZonePanel, "TOPRIGHT", 2, -1)
        GameTimeFrame:SetSize(16, 15)
        GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
        GameTimeFrame.NormalTexture = GameTimeFrame.NormalTexture or GameTimeFrame:GetNormalTexture()
        GameTimeFrame:SetNormalTexture(R.media.textures.minimap.modern.calendarBlank)
        GameTimeFrame:GetNormalTexture():SetTexCoord(30 / 64, 45 / 64, 0, 16 / 64)
        GameTimeFrame.PushedTexture = GameTimeFrame.PushedTexture or GameTimeFrame:GetPushedTexture()
        GameTimeFrame:SetPushedTexture(R.media.textures.minimap.modern.calendarBlank)
        GameTimeFrame:GetPushedTexture():SetTexCoord(30 / 64, 45 / 64, 0, 16 / 64)
        GameTimeFrame.HighlightTexture = GameTimeFrame.HighlightTexture or GameTimeFrame:GetHighlightTexture()
        GameTimeFrame:SetHighlightTexture(nil)
        GameTimeFrame:GetFontString():SetFont(MM.config.calendarText.font, MM.config.calendarText.fontSize, MM.config.calendarText.fontOutline)
        GameTimeFrame:GetFontString():SetPoint("CENTER", 0.5, 0)

        -- TODO: figure out how to properly center/justify calendar button text
        -- GameTimeFrame:SetJustifyH("CENTER")
        GameTimeFrame.Background = GameTimeFrame.Background or GameTimeFrame:CreateTexture("$parentBackground", "BACKGROUND")
        GameTimeFrame.Background:SetTexture(R.media.textures.minimap.modern.atlas)
        GameTimeFrame.Background:SetTexCoord(443 / 512, 479 / 512, 404 / 1024, 440 / 1024)
        GameTimeFrame.Background:SetPoint("TOPLEFT", -1, 1)
        GameTimeFrame.Background:SetPoint("BOTTOMRIGHT", 1, -2)
        GameTimeFrame.Background:Show()

        GameTimeCalendarInvitesGlow.Texture = GameTimeCalendarInvitesGlow.Texture or GameTimeCalendarInvitesGlow:GetTexture()
        GameTimeCalendarInvitesGlow:SetTexture()
        GameTimeCalendarEventAlarmTexture.Texture = GameTimeCalendarEventAlarmTexture.Texture or GameTimeCalendarEventAlarmTexture:GetTexture()
        GameTimeCalendarEventAlarmTexture:SetTexture()
    end
end

function MM:UpdateMail(radius)
    local x, y
    if MM.config.style == MM.Styles.Vanilla then
        x, y = R:PolarToXY(72, radius)
        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)
        MiniMapMailFrame:SetSize(33, 33)
        MiniMapMailBorder:Show()
        MiniMapMailIcon:ClearAllPoints()
        MiniMapMailIcon:SetPoint("TOPLEFT", 7, -6)
        MiniMapMailIcon:SetSize(18, 18)
        MiniMapMailIcon:SetTexture([[Interface\Icons\INV_Letter_15]])
        MiniMapMailIcon:SetTexCoord(0, 1, 0, 1)
    elseif MM.config.style == MM.Styles.Modern then
        MiniMapMailFrame:SetFrameLevel(MiniMapTracking:GetFrameLevel() + 1)
        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint("TOP", MiniMapTracking, "BOTTOM", 0, -5)
        MiniMapMailFrame:SetSize(20, 15)
        MiniMapMailBorder:Hide()
        MiniMapMailIcon:ClearAllPoints()
        MiniMapMailIcon:SetAllPoints()
        MiniMapMailIcon:SetTexture(R.media.textures.minimap.modern.atlas)
        MiniMapMailIcon:SetTexCoord(41 / 512, 82 / 512, 519 / 1024, 551 / 1024)
    end
end

function MM:UpdateButtonFrame(radius, width)
    local x, y
    if MM.config.style == MM.Styles.Vanilla then
        MinimapButtonFrame:SetWidth(width)
        MinimapButtonFrame:ClearAllPoints()
        MinimapButtonFrame:SetPoint("TOPRIGHT", MinimapButtonFrameToggleButton, "BOTTOMLEFT", 5, 5)

        x, y = R:PolarToXY(225, radius)
        MinimapButtonFrameToggleButton:ClearAllPoints()
        MinimapButtonFrameToggleButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
        MinimapButtonFrameToggleButton:SetNormalTexture(R.media.textures.minimap.vanilla.buttonFrameToggle)
        MinimapButtonFrameToggleButton:SetPushedTexture(R.media.textures.minimap.vanilla.buttonFrameToggle)
        MinimapButtonFrameToggleButton:SetHighlightTexture(R.media.textures.minimap.vanilla.minimapButtonHighlight)
    elseif MM.config.style == MM.Styles.Modern then
        MinimapButtonFrame:SetWidth(width - 30)
        MinimapButtonFrame:ClearAllPoints()
        MinimapButtonFrame:SetPoint("TOP", MinimapButtonFrameToggleButton, "BOTTOM", 0, 0)

        MinimapButtonFrameToggleButton:ClearAllPoints()
        MinimapButtonFrameToggleButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 20)
        MinimapButtonFrameToggleButton:SetNormalTexture(R.media.textures.minimap.modern.buttonFrameToggle)
        MinimapButtonFrameToggleButton:SetPushedTexture(R.media.textures.minimap.modern.buttonFrameToggle)
        MinimapButtonFrameToggleButton:SetHighlightTexture(R.media.textures.minimap.modern.buttonFrameToggle_Highlight)
    end
    MinimapButtonFrame:Update()
end

function MM:Minimap_OnMouseWheel(direction)
    if (direction > 0) then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

function MM:Minimap_OnEnter()
    MinimapZoomIn:Show()
    MinimapZoomOut:Show()

    if not MM.OnLeaveTimer then
        MM.OnLeaveTimer = MM:ScheduleRepeatingTimer(MM.Minimap_OnLeave, 0.5)
    end
end

function MM:Minimap_OnLeave()
    local isOverAnyChild = false
    local children = { Minimap:GetChildren() }
    for _, object in ipairs(children) do
        if object.IsMouseOver and object:IsMouseOver() then
            return
        end
    end

    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()

    if MM.OnLeaveTimer then
        MM:CancelTimer(MM.OnLeaveTimer)
        MM.OnLeaveTimer = nil
    end
end

function MM:TrackingButton_OnMouseUpDown()
    MiniMapTrackingIcon:ClearAllPoints()
    if MM.config.style == MM.Styles.Modern then
        MiniMapTrackingIcon:SetPoint("CENTER")
        MiniMapTrackingIcon:SetSize(14, 14)
    else
        MiniMapTrackingIcon:SetPoint("TOPLEFT", 6, -6)
        MiniMapTrackingIcon:SetSize(20, 20)
    end
end
