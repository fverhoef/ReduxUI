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
    MinimapButtonFrame:ClearAllPoints()
    MinimapButtonFrame:SetPoint("TOPRIGHT", MinimapButtonFrameToggleButton, "BOTTOMLEFT", 5, 5)

    MinimapZoneText:SetSize(190, 10)
    MinimapZoneText:SetPoint("TOP", MinimapCluster, "TOP", 0, -8)
    MinimapZoneText:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    MinimapZoneText:SetJustifyH("CENTER")
    MinimapZoneText:SetShadowColor(0, 0, 0, 0.25)
    MinimapZoneText:SetShadowOffset(1, -2)

    MinimapCluster.ZoneBackground = MinimapCluster:CreateTexture("BACKGROUND")
    MinimapCluster.ZoneBackground:SetTexture(R.media.textures.minimap.vanilla.zoneBorder)
    MinimapCluster.ZoneBackground:SetTexCoord(0, 1, 0, 78 / 128)
    MinimapCluster.ZoneBackground:SetHeight(30)
    MinimapCluster.ZoneBackground:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT")
    MinimapCluster.ZoneBackground:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT")

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
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint(unpack(MM.config.point))

    local radius = width / 2 - 5
    local x, y

    if MM.config.style == MM.Styles.Vanilla then
        Minimap:SetMaskTexture([[Interface\Masks\CircleMaskScalable]])
        Minimap:SetSize(width, height)

        MinimapBorder:ClearAllPoints()
        MinimapBorder:SetOutside(Minimap, 5, 5)
        MinimapBorder:SetTexture(R.media.textures.minimap.vanilla.border)
        MinimapBorder:SetTexCoord(0, 1, 0, 1)

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
    elseif MM.config.style == MM.Styles.Dragonflight then
        Minimap:SetMaskTexture(R.media.textures.minimap.dragonflight.mask)
        Minimap:SetSize(width, height + (height / 220) * 6)
    
        MinimapBackdrop:ClearAllPoints()
        MinimapBackdrop:SetPoint("TOPLEFT", -5, 5)
        MinimapBackdrop:SetPoint("BOTTOMRIGHT", 8, -6)
        
        MinimapBorder:SetTexture(R.media.textures.minimap.dragonflight.atlas)
        MinimapBorder:SetTexCoord(0, 440 / 512, 57 / 1024, 509 / 1024)

        x, y = R:PolarToXY(129, radius + 15)
        MinimapZoomIn:SetSize(24, 24)
        MinimapZoomIn:ClearAllPoints()
        MinimapZoomIn:SetPoint("CENTER", Minimap, "CENTER", x, y)
        MinimapZoomIn:SetNormalTexture(R.media.textures.minimap.dragonflight.atlas)
        MinimapZoomIn:GetNormalTexture():SetTexCoord(0, 36 / 512, 551 / 1024, 587 / 1024)
        MinimapZoomIn:SetPushedTexture(R.media.textures.minimap.dragonflight.atlas)
        MinimapZoomIn:GetPushedTexture():SetTexCoord(0, 36 / 512, 587 / 1024, 623 / 1024)
        MinimapZoomIn:SetHighlightTexture(R.media.textures.minimap.dragonflight.atlas)
        MinimapZoomIn:GetHighlightTexture():SetTexCoord(0, 36 / 512, 623 / 1024, 659 / 1024)
        MinimapZoomIn:SetDisabledTexture(R.media.textures.minimap.dragonflight.atlas)
        MinimapZoomIn:GetDisabledTexture():SetTexCoord(0, 36 / 512, 659 / 1024, 695 / 1024)
    
        x, y = R:PolarToXY(141, radius + 15)
        MinimapZoomOut:SetSize(24, 24)
        MinimapZoomOut:ClearAllPoints()
        MinimapZoomOut:SetPoint("CENTER", Minimap, "CENTER", x, y)
        MinimapZoomOut:SetNormalTexture(R.media.textures.minimap.dragonflight.atlas)
        MinimapZoomOut:GetNormalTexture():SetTexCoord(180 / 512, 216 / 512, 511 / 1024, 547 / 1024)
        MinimapZoomOut:SetPushedTexture(R.media.textures.minimap.dragonflight.atlas)
        MinimapZoomOut:GetPushedTexture():SetTexCoord(216 / 512, 252 / 512, 511 / 1024, 547 / 1024)
        MinimapZoomOut:SetHighlightTexture(R.media.textures.minimap.dragonflight.atlas)
        MinimapZoomOut:GetHighlightTexture():SetTexCoord(252 / 512, 288 / 512, 511 / 1024, 547 / 1024)
        MinimapZoomOut:SetDisabledTexture(R.media.textures.minimap.dragonflight.atlas)
        MinimapZoomOut:GetDisabledTexture():SetTexCoord(288 / 512, 324 / 512, 511 / 1024, 547 / 1024)
    end

    MinimapNorthTag:SetTexture(MM.config.showNorthTag and MinimapNorthTag.__texture or nil)

    MinimapZoneText:SetShown(MM.config.zoneText.enabled)
    if MM.config.zoneText.enabled then
        MinimapCluster:SetSize(width, height + 35)
        Minimap:SetPoint("TOP", 0, -35)
    else
        MinimapCluster:SetSize(width, height)
        Minimap:SetPoint("TOP", 0, 0)
    end
    MinimapZoneText:SetFont(MM.config.zoneText.font, MM.config.zoneText.fontSize, MM.config.zoneText.fontOutline)
    MinimapZoneText:SetJustifyH(MM.config.zoneText.justifyH)
    MinimapZoneText:SetShadowOffset(MM.config.zoneText.fontShadow and 1 or 0, MM.config.zoneText.fontShadow and -2 or 0)
    
    MinimapCluster.ZoneBackground:SetShown(MM.config.zoneText.enabled and MM.config.zoneText.showBorder)

    LoadAddOn("Blizzard_TimeManager")
    TimeManagerClockButton:ClearAllPoints()
    TimeManagerClockButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 23)
    TimeManagerClockButton:SetSize(1.1 * 60, 1.1 * 28)

    MinimapButtonFrame:SetWidth(width)
    MinimapButtonFrame:Update()

    x, y = R:PolarToXY(35, radius)
    GameTimeFrame:ClearAllPoints()
    GameTimeFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)

    x, y = R:PolarToXY(55, radius)
    MiniMapWorldMapButton:ClearAllPoints()
    MiniMapWorldMapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)

    x, y = R:PolarToXY(72, radius)
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)

    x, y = R:PolarToXY(225, radius)
    MinimapButtonFrameToggleButton:ClearAllPoints()
    MinimapButtonFrameToggleButton:SetPoint("CENTER", Minimap, "CENTER", x, y)

    x, y = R:PolarToXY(-35, radius)
    MiniMapInstanceDifficulty:ClearAllPoints()
    MiniMapInstanceDifficulty:SetPoint("CENTER", Minimap, "CENTER", x, y)

    x, y = R:PolarToXY(-55, radius)
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetPoint("CENTER", Minimap, "CENTER", x, y)

    x, y = R:PolarToXY(-72, radius)
    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)

    x, y = R:PolarToXY(-72, radius)
    MiniMapLFGFrame:ClearAllPoints()
    MiniMapLFGFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)
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
