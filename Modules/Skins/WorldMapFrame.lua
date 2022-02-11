local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleWorldMapFrame()
    if R.isRetail or not S.config.worldMap.enabled then return end

    local scale = S.config.worldMap.scale
    local movingOpacity = S.config.worldMap.movingOpacity
    local stationaryOpacity = S.config.worldMap.stationaryOpacity

    WorldMapFrame:SetScale(scale)
    WorldMapFrame.__setScale = WorldMapFrame.SetScale
    WorldMapFrame.SetScale = R.EmptyFunction
    WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
        local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(f)
        local s = WorldMapFrame:GetScale()
        return x / s, y / s
    end
    WorldMapFrame:EnableKeyboard(false)
    WorldMapFrame:EnableMouse(false)

    WorldMapFrame.ScrollContainer:HookScript("OnMouseWheel", function(self, delta)
        local zoomOut, zoomIn = self:GetCurrentZoomRange()
        if delta == 1 then
            if zoomIn > self:GetCanvasScale() then
                local x, y = self:GetNormalizedCursorPosition()
                self:InstantPanAndZoom(zoomIn, x, y)
            end
        else
            if zoomOut < self:GetCanvasScale() then
                local x, y = self:GetNormalizedCursorPosition()
                self:InstantPanAndZoom(zoomOut, x, y)
            end
        end
    end)

    PlayerMovementFrameFader.AddDeferredFrame(WorldMapFrame, movingOpacity, stationaryOpacity, 0.5, function()
        return not WorldMapFrame:IsMouseOver()
    end)

    WorldMapFrame.BlackoutFrame.Blackout:SetTexture()
    WorldMapFrame.BlackoutFrame:EnableMouse(false)

    WorldMapFrame.Coordinates = CreateFrame("Frame", "WorldMapFrameCoordinates", WorldMapFrame)
    WorldMapFrame.Coordinates:SetPoint("BOTTOMLEFT", WorldMapFrame.ScrollContainer, "BOTTOMLEFT", 5, 5)
    WorldMapFrame.Coordinates:SetFrameLevel(WorldMapFrame:GetFrameLevel() + 2)
    WorldMapFrame.Coordinates.Player = WorldMapFrame.Coordinates:CreateFontString(nil, "OVERLAY")
    WorldMapFrame.Coordinates.Player:SetPoint("BOTTOMLEFT", WorldMapFrame.ScrollContainer, "BOTTOMLEFT", 0, -20)
    WorldMapFrame.Coordinates.Player:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    WorldMapFrame.Coordinates.Player:SetText(PLAYER .. ":   0, 0")
    WorldMapFrame.Coordinates.Mouse = WorldMapFrame.Coordinates:CreateFontString(nil, "OVERLAY")
    WorldMapFrame.Coordinates.Mouse:SetPoint("BOTTOMRIGHT", WorldMapFrame.ScrollContainer, "BOTTOMRIGHT", 0, -20)
    WorldMapFrame.Coordinates.Mouse:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    WorldMapFrame.Coordinates.Mouse:SetText(MOUSE_LABEL .. ":   0, 0")

    WorldMapFrame:HookScript("OnShow", function()
        S:UpdateWorldMapCoordinates()
        if not WorldMapFrame.Timer then
            WorldMapFrame.Timer = S:ScheduleRepeatingTimer("UpdateWorldMapCoordinates", 0.1)
        end
    end)
    WorldMapFrame:HookScript("OnHide", function()
        S:CancelTimer(WorldMapFrame.Timer)
        WorldMapFrame.Timer = nil
    end)

    tinsert(UISpecialFrames, WorldMapFrame:GetName())
end

local worldMapTitleRegion
function S:GetWorldMapTitleText()
    if not worldMapTitleRegion then
        local regions = WorldMapFrame.BorderFrame:GetRegions()
        for i, region in next, regions do
            if region.SetText then
                worldMapTitleRegion = region
                break
            end
        end
    end

    return worldMapTitleRegion
end

function S:UpdateWorldMapCoordinates()
    if not WorldMapFrame:IsShown() then
        return
    end

    if WorldMapFrame.ScrollContainer:IsMouseOver() then
        local x, y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
        if x and y and x >= 0 and y >= 0 then
            WorldMapFrame.Coordinates.Mouse:SetFormattedText("%s:   %.2f, %.2f", MOUSE_LABEL, x * 100, y * 100)
        else
            WorldMapFrame.Coordinates.Mouse:SetText("")
        end
    else
        WorldMapFrame.Coordinates.Mouse:SetText("")
    end

    local position
    local mapID = C_Map.GetBestMapForUnit("player")
    if mapID then
        position = C_Map.GetPlayerMapPosition(mapID, "player")
    end
    if position and position.x ~= 0 and position.y ~= 0 then
        WorldMapFrame.Coordinates.Player:SetFormattedText("%s:   %.2f, %.2f", PLAYER, position.x * 100, position.y * 100)
    else
        WorldMapFrame.Coordinates.Player:SetFormattedText("%s:   %s", PLAYER, "N/A")
    end
end
