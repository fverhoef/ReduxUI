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
    MinimapCluster.ZoneBackground:SetTexture(R.media.textures.minimap.zoneBorder)
    MinimapCluster.ZoneBackground:SetTexCoord(0, 1, 0, 78 / 128)
    MinimapCluster.ZoneBackground:SetHeight(30)
    MinimapCluster.ZoneBackground:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT")
    MinimapCluster.ZoneBackground:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT")

    MinimapBorderTop:Hide()

    Minimap:EnableMouseWheel()
    Minimap:SetScript("OnMouseWheel", MM.Minimap_OnMouseWheel)

    MinimapNorthTag:ClearAllPoints()
    MinimapNorthTag:SetPoint("TOP", Minimap, "TOP", 0, -15)
    MinimapNorthTag.__texture = MinimapNorthTag:GetTexture()

    MM:UpdateMinimap()
end

function MM:UpdateMinimap()
    local width, height = unpack(MM.config.size)
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint(unpack(MM.config.point))

    Minimap:SetMaskTexture([[Interface\Masks\CircleMaskScalable]])
    Minimap:SetSize(width, height)

    MinimapBorder:ClearAllPoints()
    MinimapBorder:SetOutside(Minimap, 5, 5)
    MinimapBorder:SetTexture(R.media.textures.minimap.border)
    MinimapBorder:SetTexCoord(0, 1, 0, 1)

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

    local radius = width / 2 - 5
    local x, y = R:PolarToXY(127, radius)
    MinimapZoomIn:ClearAllPoints()
    MinimapZoomIn:SetPoint("CENTER", Minimap, "CENTER", x, y)

    x, y = R:PolarToXY(143, radius)
    MinimapZoomOut:ClearAllPoints()
    MinimapZoomOut:SetPoint("CENTER", Minimap, "CENTER", x, y)

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
