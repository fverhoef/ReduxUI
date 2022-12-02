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

    Minimap.Border = MinimapBorder or MinimapCompassTexture
    Minimap.BorderTop = MinimapCluster.BorderTop or MinimapBorderTop
    Minimap.InstanceDifficulty = MinimapCluster.InstanceDifficulty or MiniMapInstanceDifficulty
    Minimap.MailFrame = MinimapCluster.MailFrame or MiniMapMailFrame
    Minimap.MailFrame.Border = MiniMapMailBorder or Minimap.MailFrame:CreateTexture("$parentBorder", "BACKGROUND") -- TODO: set vanilla border texture
    Minimap.Tracking = MinimapCluster.Tracking or MiniMapTracking
    Minimap.Tracking.Button = Minimap.Tracking.Button or MiniMapTrackingButton
    Minimap.ZoneTextButton = MinimapCluster.ZoneTextButton or MinimapZoneTextButton
    Minimap.ZoomIn = Minimap.ZoomIn or MinimapZoomIn
    Minimap.ZoomOut = Minimap.ZoomOut or MinimapZoomOut

    Minimap.ZonePanel = CreateFrame("Frame", "MinimapZonePanel", MinimapCluster)
    Minimap.ZonePanel:SetSize(140, 12)
    Minimap.ZonePanel:SetPoint("TOP", 0, -2)
    Minimap.ZonePanel.Background = MinimapCluster:CreateTexture("BACKGROUND")
    Minimap.ZonePanel.Background:SetTexture(R.media.textures.minimap.vanilla.zoneBorder)
    Minimap.ZonePanel.Background:SetTexCoord(0, 1, 0, 78 / 128)
    Minimap.ZonePanel.Background:SetPoint("TOPLEFT", Minimap.ZonePanel, "TOPLEFT", 0, 2)
    Minimap.ZonePanel.Background:SetPoint("BOTTOMRIGHT", Minimap.ZonePanel, "BOTTOMRIGHT", 0, -2)
    Minimap.ZonePanel.BackgroundLeft = Minimap.ZonePanel:CreateTexture("$parentBackgroundLeft", "BACKGROUND")
    Minimap.ZonePanel.BackgroundLeft:SetTexture(R.media.textures.minimap.modern.atlas)
    Minimap.ZonePanel.BackgroundLeft:SetTexCoord(443 / 512, 451 / 512, 404 / 1024, 440 / 1024)
    Minimap.ZonePanel.BackgroundLeft:SetWidth(4)
    Minimap.ZonePanel.BackgroundLeft:SetPoint("TOPLEFT", Minimap.ZonePanel, "TOPLEFT", 0, 0)
    Minimap.ZonePanel.BackgroundLeft:SetPoint("BOTTOMLEFT", Minimap.ZonePanel, "BOTTOMLEFT", 0, 0)
    Minimap.ZonePanel.BackgroundMiddle = Minimap.ZonePanel:CreateTexture("$parentBackgroundMiddle", "BACKGROUND")
    Minimap.ZonePanel.BackgroundMiddle:SetTexture(R.media.textures.minimap.modern.atlas)
    Minimap.ZonePanel.BackgroundMiddle:SetTexCoord(452 / 512, 470 / 512, 404 / 1024, 440 / 1024)
    Minimap.ZonePanel.BackgroundMiddle:SetPoint("TOPLEFT", Minimap.ZonePanel, "TOPLEFT", 4, 0)
    Minimap.ZonePanel.BackgroundMiddle:SetPoint("BOTTOMRIGHT", Minimap.ZonePanel, "BOTTOMRIGHT", -4, 0)
    Minimap.ZonePanel.BackgroundRight = Minimap.ZonePanel:CreateTexture("$parentBackgroundRight", "BACKGROUND")
    Minimap.ZonePanel.BackgroundRight:SetTexture(R.media.textures.minimap.modern.atlas)
    Minimap.ZonePanel.BackgroundRight:SetTexCoord(471 / 512, 479 / 512, 404 / 1024, 440 / 1024)
    Minimap.ZonePanel.BackgroundRight:SetWidth(4)
    Minimap.ZonePanel.BackgroundRight:SetPoint("TOPRIGHT", Minimap.ZonePanel, "TOPRIGHT", 0, 0)
    Minimap.ZonePanel.BackgroundRight:SetPoint("BOTTOMRIGHT", Minimap.ZonePanel, "BOTTOMRIGHT", 0, 0)

    MinimapZoneText:ClearAllPoints()
    MinimapZoneText:SetAllPoints()

    Minimap.BorderTop:Hide()

    Minimap.ButtonFrameToggleButton = CreateFrame("CheckButton", "MinimapButtonFrameToggleButton", Minimap, "MinimapButtonFrameToggleButtonTemplate")
    Minimap.ButtonFrameToggleButton:SetChecked(not MM.config.buttonFrame.collapsed)
    Minimap.ButtonFrameToggleButton:CreateFader(R.config.faders.onShow)

    Minimap.ButtonFrame = CreateFrame("Frame", "MinimapButtonFrame", Minimap, "MinimapButtonFrameTemplate")
    Minimap.ButtonFrame:SetShown(not MM.config.buttonFrame.collapsed)
    Minimap.ButtonFrame:CreateFader(MM.config.buttonFrame.fader, Minimap.ButtonFrame.Buttons)

    if not R.isRetail then
        MinimapZoomHitArea = CreateFrame("Frame", "MinimapZoomHitArea", Minimap)
        MinimapZoomHitArea:EnableMouse(true)
        MinimapZoomHitArea:SetPoint("TOPRIGHT", MinimapZoomIn, "TOPRIGHT")
        MinimapZoomHitArea:SetPoint("BOTTOMLEFT", MinimapZoomOut, "BOTTOMLEFT")

        Minimap.ZoomIn:CreateFader(R.config.faders.onShow)
        Minimap.ZoomOut:CreateFader(R.config.faders.onShow)

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
        MM:SecureHookScript(Minimap.MailFrame, "OnLeave", MM.Minimap_OnLeave)
        MM:SecureHookScript(Minimap.ButtonFrameToggleButton, "OnLeave", MM.Minimap_OnLeave)
        MM:SecureHookScript(Minimap.InstanceDifficulty, "OnLeave", MM.Minimap_OnLeave)
        MM:SecureHookScript(MiniMapTracking, "OnLeave", MM.Minimap_OnLeave)
        MM:SecureHookScript(MiniMapBattlefieldFrame, "OnLeave", MM.Minimap_OnLeave)
        MM:SecureHookScript(MiniMapLFGFrame, "OnLeave", MM.Minimap_OnLeave)
    end

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

        Minimap.Border:ClearAllPoints()
        Minimap.Border:SetAllPoints()
        Minimap.Border:SetTexture(R.media.textures.minimap.vanilla.border)
        Minimap.Border:SetTexCoord(0, 1, 0, 1)
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

        Minimap.Border:ClearAllPoints()
        Minimap.Border:SetAllPoints()
        Minimap.Border:SetTexture(R.media.textures.minimap.modern.atlas)
        Minimap.Border:SetTexCoord(0, 440 / 512, 57 / 1024, 509 / 1024)
    end

    if MinimapNorthTag then
        MinimapNorthTag:SetTexture(MM.config.showNorthTag and MinimapNorthTag.__texture or nil)
    end

    MM:UpdateZoom(radius)
    MM:UpdateTracking(radius)
    MM:UpdateTimeManager(radius)
    MM:UpdateZonePanel(width, height)
    MM:UpdateCalendar(radius)
    MM:UpdateMail(radius)
    MM:UpdateButtonFrame(radius, width)

    if not R.isRetail then
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
    end

    x, y = R:PolarToXY(-35, radius)
    Minimap.InstanceDifficulty:ClearAllPoints()
    Minimap.InstanceDifficulty:SetPoint("TOPRIGHT", Minimap.BorderTop, "TOPRIGHT", 0, -15)

    if not R.isRetail then
        x, y = R:PolarToXY(-72, radius)
        MiniMapBattlefieldFrame:ClearAllPoints()
        MiniMapBattlefieldFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)

        x, y = R:PolarToXY(-72, radius)
        MiniMapLFGFrame:ClearAllPoints()
        MiniMapLFGFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end
end

function MM:UpdateZoom(radius)
    local x, y
    if MM.config.style == MM.Styles.Vanilla then
        x, y = R:PolarToXY(127, radius)
        Minimap.ZoomIn:SetSize(32, 32)
        Minimap.ZoomIn:ClearAllPoints()
        Minimap.ZoomIn:SetPoint("CENTER", Minimap, "CENTER", x, y)
        Minimap.ZoomIn:SetNormalTexture([[Interface\Minimap\UI-Minimap-ZoomInButton-Up]])
        Minimap.ZoomIn:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
        Minimap.ZoomIn:SetPushedTexture([[Interface\Minimap\UI-Minimap-ZoomInButton-Down]])
        Minimap.ZoomIn:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
        Minimap.ZoomIn:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
        Minimap.ZoomIn:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
        Minimap.ZoomIn:SetDisabledTexture([[Interface\Minimap\UI-Minimap-ZoomInButton-Disabled]])
        Minimap.ZoomIn:GetDisabledTexture():SetTexCoord(0, 1, 0, 1)

        x, y = R:PolarToXY(143, radius)
        Minimap.ZoomOut:SetSize(32, 32)
        Minimap.ZoomOut:ClearAllPoints()
        Minimap.ZoomOut:SetPoint("CENTER", Minimap, "CENTER", x, y)
        Minimap.ZoomOut:SetNormalTexture([[Interface\Minimap\UI-Minimap-ZoomOutButton-Up]])
        Minimap.ZoomOut:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
        Minimap.ZoomOut:SetPushedTexture([[Interface\Minimap\UI-Minimap-ZoomOutButton-Down]])
        Minimap.ZoomOut:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
        Minimap.ZoomOut:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
        Minimap.ZoomOut:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
        Minimap.ZoomOut:SetDisabledTexture([[Interface\Minimap\UI-Minimap-ZoomOutButton-Disabled]])
        Minimap.ZoomOut:GetDisabledTexture():SetTexCoord(0, 1, 0, 1)
    elseif MM.config.style == MM.Styles.Modern then
        x, y = R:PolarToXY(129, radius + 15)
        Minimap.ZoomIn:SetSize(24, 24)
        Minimap.ZoomIn:ClearAllPoints()
        Minimap.ZoomIn:SetPoint("CENTER", Minimap, "CENTER", x, y)
        Minimap.ZoomIn:SetNormalTexture(R.media.textures.minimap.modern.atlas)
        Minimap.ZoomIn:GetNormalTexture():SetTexCoord(0, 36 / 512, 551 / 1024, 587 / 1024)
        Minimap.ZoomIn:SetPushedTexture(R.media.textures.minimap.modern.atlas)
        Minimap.ZoomIn:GetPushedTexture():SetTexCoord(0, 36 / 512, 587 / 1024, 623 / 1024)
        Minimap.ZoomIn:SetHighlightTexture(R.media.textures.minimap.modern.atlas)
        Minimap.ZoomIn:GetHighlightTexture():SetTexCoord(0, 36 / 512, 623 / 1024, 659 / 1024)
        Minimap.ZoomIn:SetDisabledTexture(R.media.textures.minimap.modern.atlas)
        Minimap.ZoomIn:GetDisabledTexture():SetTexCoord(0, 36 / 512, 659 / 1024, 695 / 1024)

        x, y = R:PolarToXY(141, radius + 15)
        Minimap.ZoomOut:SetSize(24, 24)
        Minimap.ZoomOut:ClearAllPoints()
        Minimap.ZoomOut:SetPoint("CENTER", Minimap, "CENTER", x, y)
        Minimap.ZoomOut:SetNormalTexture(R.media.textures.minimap.modern.atlas)
        Minimap.ZoomOut:GetNormalTexture():SetTexCoord(180 / 512, 216 / 512, 511 / 1024, 547 / 1024)
        Minimap.ZoomOut:SetPushedTexture(R.media.textures.minimap.modern.atlas)
        Minimap.ZoomOut:GetPushedTexture():SetTexCoord(216 / 512, 252 / 512, 511 / 1024, 547 / 1024)
        Minimap.ZoomOut:SetHighlightTexture(R.media.textures.minimap.modern.atlas)
        Minimap.ZoomOut:GetHighlightTexture():SetTexCoord(252 / 512, 288 / 512, 511 / 1024, 547 / 1024)
        Minimap.ZoomOut:SetDisabledTexture(R.media.textures.minimap.modern.atlas)
        Minimap.ZoomOut:GetDisabledTexture():SetTexCoord(288 / 512, 324 / 512, 511 / 1024, 547 / 1024)
    end
end

function MM:UpdateTracking(radius)
    local x, y
    if MM.config.style == MM.Styles.Vanilla then
        x, y = R:PolarToXY(-55, radius)
        Minimap.Tracking:ClearAllPoints()
        Minimap.Tracking:SetPoint("CENTER", Minimap, "CENTER", x, y)
        Minimap.Tracking:SetSize(32, 32)

        if Minimap.Tracking.Background then
            Minimap.Tracking.Background:Hide()
        end

        Minimap.Tracking.Button:SetSize(32, 32)

        if Minimap.Tracking.Button.HighlightTexture then
            Minimap.Tracking.Button:SetHighlightTexture(Minimap.Tracking.Button.HighlightTexture)
        end

        MiniMapTrackingBackground:Show()
        MiniMapTrackingButtonBorder:Show()

        MM:TrackingButton_OnMouseUpDown()
        if MiniMapTrackingIconOverlay.Texture then
            MiniMapTrackingIconOverlay:SetTexture(MiniMapTrackingIconOverlay.Texture)
        end
    elseif MM.config.style == MM.Styles.Modern then

        Minimap.Tracking:ClearAllPoints()
        Minimap.Tracking:SetPoint("TOPRIGHT", Minimap.ZonePanel, "TOPLEFT", -2, -1)
        Minimap.Tracking:SetSize(16, 15)

        Minimap.Tracking.Background = Minimap.Tracking.Background or Minimap.Tracking:CreateTexture("$parentBackground", "BACKGROUND")
        Minimap.Tracking.Background:SetTexture(R.media.textures.minimap.modern.atlas)
        Minimap.Tracking.Background:SetTexCoord(443 / 512, 479 / 512, 404 / 1024, 440 / 1024)
        Minimap.Tracking.Background:SetPoint("TOPLEFT", -1, 1)
        Minimap.Tracking.Background:SetPoint("BOTTOMRIGHT", 1, -2)

        Minimap.Tracking.Button:SetSize(14, 14)
        Minimap.Tracking.Button.HighlightTexture = Minimap.Tracking.Button.HighlightTexture or Minimap.Tracking.Button:GetHighlightTexture()
        Minimap.Tracking.Button:SetHighlightTexture("")
        if not MM:IsHooked(Minimap.Tracking.Button, "OnMouseDown") then
            MM:SecureHookScript(Minimap.Tracking.Button, "OnMouseDown", MM.TrackingButton_OnMouseUpDown)
        end
        if not MM:IsHooked(Minimap.Tracking.Button, "OnMouseUp") then
            MM:SecureHookScript(Minimap.Tracking.Button, "OnMouseUp", MM.TrackingButton_OnMouseUpDown)
        end

        if not R.isRetail then
            MiniMapTrackingBackground:Hide()
            MiniMapTrackingButtonBorder:Hide()

            MM:TrackingButton_OnMouseUpDown()
            MiniMapTrackingIconOverlay.Texture = MiniMapTrackingIconOverlay.Texture or MiniMapTrackingIconOverlay:GetTexture()
            MiniMapTrackingIconOverlay:SetTexture(nil)
        end
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
        TimeManagerClockButton:SetPoint("TOPRIGHT", Minimap.ZonePanel, "TOPRIGHT", -5, -2)
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
        Minimap.ZoneTextButton:SetSize(190, 10)
        Minimap.ZoneTextButton:ClearAllPoints()
        Minimap.ZoneTextButton:SetPoint("CENTER", Minimap.ZonePanel, "CENTER", 0, 0)

        Minimap.ZonePanel:ClearAllPoints()
        Minimap.ZonePanel:SetPoint("TOPLEFT", 0, -2)
        Minimap.ZonePanel:SetSize(width, 24)
        Minimap.ZonePanel.Background:Show()
        Minimap.ZonePanel.BackgroundLeft:Hide()
        Minimap.ZonePanel.BackgroundMiddle:Hide()
        Minimap.ZonePanel.BackgroundRight:Hide()
    elseif MM.config.style == MM.Styles.Modern then
        Minimap.ZoneTextButton:SetSize(135, 12)
        Minimap.ZoneTextButton:ClearAllPoints()
        Minimap.ZoneTextButton:SetPoint("TOPLEFT", Minimap.ZonePanel, "TOPLEFT", 5, -2)

        Minimap.ZonePanel:ClearAllPoints()
        Minimap.ZonePanel:SetPoint("TOP", 0, 0)
        Minimap.ZonePanel:SetSize(188, 18)
        Minimap.ZonePanel.Background:Hide()
        Minimap.ZonePanel.BackgroundLeft:Show()
        Minimap.ZonePanel.BackgroundMiddle:Show()
        Minimap.ZonePanel.BackgroundRight:Show()
    end

    MinimapZoneText:SetShown(MM.config.zonePanel.enabled and MM.config.zonePanel.zoneText.enabled)
    MinimapZoneText:SetFont(MM.config.zonePanel.zoneText.font, MM.config.zonePanel.zoneText.fontSize, MM.config.zonePanel.zoneText.fontOutline)
    MinimapZoneText:SetJustifyH(MM.config.zonePanel.zoneText.justifyH)
    MinimapZoneText:SetShadowOffset(MM.config.zonePanel.zoneText.fontShadow and 1 or 0, MM.config.zonePanel.zoneText.fontShadow and -2 or 0)

    Minimap.ZonePanel:SetShown(MM.config.zonePanel.enabled and MM.config.zonePanel.showBorder)
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
        GameTimeFrame:SetPoint("TOPLEFT", Minimap.ZonePanel, "TOPRIGHT", 2, -1)
        GameTimeFrame:SetSize(16, 15)
        GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
        GameTimeFrame.NormalTexture = GameTimeFrame.NormalTexture or GameTimeFrame:GetNormalTexture()
        GameTimeFrame:SetNormalTexture(R.media.textures.minimap.modern.calendarBlank)
        GameTimeFrame:GetNormalTexture():SetTexCoord(30 / 64, 45 / 64, 0, 16 / 64)
        GameTimeFrame.PushedTexture = GameTimeFrame.PushedTexture or GameTimeFrame:GetPushedTexture()
        GameTimeFrame:SetPushedTexture(R.media.textures.minimap.modern.calendarBlank)
        GameTimeFrame:GetPushedTexture():SetTexCoord(30 / 64, 45 / 64, 0, 16 / 64)
        GameTimeFrame.HighlightTexture = GameTimeFrame.HighlightTexture or GameTimeFrame:GetHighlightTexture()
        GameTimeFrame:SetHighlightTexture("")
        if R.isRetail then
            GameTimeFrame:SetNormalFontObject(GameFontHighlightSmall)
        else
            GameTimeFrame:GetFontString():SetFont(MM.config.calendarText.font, MM.config.calendarText.fontSize, MM.config.calendarText.fontOutline)
            GameTimeFrame:GetFontString():SetPoint("CENTER", 0.5, 0)
        end

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
        Minimap.MailFrame:ClearAllPoints()
        Minimap.MailFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)
        Minimap.MailFrame:SetSize(33, 33)
        Minimap.MailFrame.Border:Show()
        MiniMapMailIcon:ClearAllPoints()
        MiniMapMailIcon:SetPoint("TOPLEFT", 7, -6)
        MiniMapMailIcon:SetSize(18, 18)
        MiniMapMailIcon:SetTexture([[Interface\Icons\INV_Letter_15]])
        MiniMapMailIcon:SetTexCoord(0, 1, 0, 1)
    elseif MM.config.style == MM.Styles.Modern then
        Minimap.MailFrame:SetFrameLevel(Minimap.Tracking:GetFrameLevel() + 1)
        Minimap.MailFrame:ClearAllPoints()
        Minimap.MailFrame:SetPoint("TOP", Minimap.Tracking, "BOTTOM", 0, -5)
        Minimap.MailFrame:SetSize(20, 15)
        Minimap.MailFrame.Border:Hide()
        MiniMapMailIcon:ClearAllPoints()
        MiniMapMailIcon:SetAllPoints()
        MiniMapMailIcon:SetTexture(R.media.textures.minimap.modern.atlas)
        MiniMapMailIcon:SetTexCoord(41 / 512, 82 / 512, 519 / 1024, 551 / 1024)
    end
end

function MM:UpdateButtonFrame(radius, width)
    local x, y
    if MM.config.style == MM.Styles.Vanilla then
        Minimap.ButtonFrame:SetWidth(width)
        Minimap.ButtonFrame:ClearAllPoints()
        Minimap.ButtonFrame:SetPoint("TOPRIGHT", Minimap.ButtonFrameToggleButton, "BOTTOMLEFT", 5, 5)

        x, y = R:PolarToXY(225, radius)
        Minimap.ButtonFrameToggleButton:ClearAllPoints()
        Minimap.ButtonFrameToggleButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
        Minimap.ButtonFrameToggleButton:SetNormalTexture(R.media.textures.minimap.vanilla.buttonFrameToggle)
        Minimap.ButtonFrameToggleButton:SetPushedTexture(R.media.textures.minimap.vanilla.buttonFrameToggle)
        Minimap.ButtonFrameToggleButton:SetHighlightTexture(R.media.textures.minimap.vanilla.minimapButtonHighlight)
    elseif MM.config.style == MM.Styles.Modern then
        Minimap.ButtonFrame:SetWidth(width - 30)
        Minimap.ButtonFrame:ClearAllPoints()
        Minimap.ButtonFrame:SetPoint("TOP", Minimap.ButtonFrameToggleButton, "BOTTOM", 0, 0)

        Minimap.ButtonFrameToggleButton:ClearAllPoints()
        Minimap.ButtonFrameToggleButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 20)
        Minimap.ButtonFrameToggleButton:SetNormalTexture(R.media.textures.minimap.modern.buttonFrameToggle)
        Minimap.ButtonFrameToggleButton:SetPushedTexture(R.media.textures.minimap.modern.buttonFrameToggle)
        Minimap.ButtonFrameToggleButton:SetHighlightTexture(R.media.textures.minimap.modern.buttonFrameToggle_Highlight)
    end
    Minimap.ButtonFrame:Update()
end

function MM:Minimap_OnMouseWheel(direction)
    if (direction > 0) then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

function MM:Minimap_OnEnter()
    Minimap.ZoomIn:Show()
    Minimap.ZoomOut:Show()

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

    Minimap.ZoomIn:Hide()
    Minimap.ZoomOut:Hide()

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
