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
    MinimapCluster:CreateFader(MM.config.fader)
    MinimapCluster:CreateMover("Minimap", MM.config.point)

    if MM.config.visibility then
        MinimapCluster.visibility = MM.config.visibility
        RegisterStateDriver(MinimapCluster, "visibility", MM.config.visibility)
    end

    MinimapButtonFrameToggleButton = CreateFrame("CheckButton", "MinimapButtonFrameToggleButton", Minimap, "MinimapButtonFrameToggleButtonTemplate")
    MinimapButtonFrameToggleButton:SetChecked(not MM.config.buttonFrame.collapsed)

    MinimapButtonFrame = CreateFrame("Frame", "MinimapButtonFrame", Minimap, "MinimapButtonFrameTemplate")
    MinimapButtonFrame:SetShown(not MM.config.buttonFrame.collapsed)
    MinimapButtonFrame:CreateFader(MM.config.buttonFrame.fader, MinimapButtonFrame.Buttons)

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
    MinimapBorder:SetOutside(Minimap, 3, 3)
    MinimapBorder:SetTexture(R.media.textures.minimap.border)
    MinimapBorder:SetTexCoord(0, 1, 0, 1)

    MinimapNorthTag:SetTexture(MM.config.showNorthTag and MinimapNorthTag.__texture or nil)
    MiniMapMailBorder:SetShown(MM.config.enableMailGlow)

    MinimapZoneText:SetShown(MM.config.zoneText.enabled)
    if MM.config.zoneText.enabled then
        MinimapCluster.ZoneBackground:Show()
        MinimapCluster:SetSize(width, height + 35)
        Minimap:SetPoint("TOP", 0, -35)
    else
        MinimapCluster.ZoneBackground:Hide()
        MinimapCluster:SetSize(width, height)
        Minimap:SetPoint("TOP", 0, 0)
    end
    MinimapZoneText:SetFont(MM.config.zoneText.font, MM.config.zoneText.fontSize, MM.config.zoneText.fontOutline)
    MinimapZoneText:SetJustifyH(MM.config.zoneText.justifyH)
    MinimapZoneText:SetShadowOffset(MM.config.zoneText.fontShadow and 1 or 0, MM.config.zoneText.fontShadow and -2 or 0)

    LoadAddOn("Blizzard_TimeManager")
    TimeManagerClockButton:ClearAllPoints()
    TimeManagerClockButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 20)

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

    x, y = R:PolarToXY(-45, radius)
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

function MM:Minimap_OnMouseWheel(direction)
    if (direction > 0) then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end
