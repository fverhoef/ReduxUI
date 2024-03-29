local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleWidgets()
    if not S.config.widgets.enabled then return end

    UIWidgetTopCenterContainerFrame.config = S.config.widgets.top
    UIWidgetTopCenterContainerFrame.defaults = S.defaults.widgets.top
    UIWidgetTopCenterContainerFrame:SetMovable(true)
    UIWidgetTopCenterContainerFrame:SetUserPlaced(true)
    UIWidgetTopCenterContainerFrame:ClearAllPoints()
    UIWidgetTopCenterContainerFrame:SetNormalizedPoint(UIWidgetTopCenterContainerFrame.config.point)
    UIWidgetTopCenterContainerFrame:CreateMover("Top Widgets Frame", UIWidgetTopCenterContainerFrame.defaults.point, 200, 20)
    R:SecureHook(UIWidgetTopCenterContainerFrame, "SetPoint", function(self, point, anchor, relativePoint, x, y)
        if point ~= self.config.point[1] or anchor ~= self.config.point[2] or relativePoint ~= self.config.point[3] then
            self:ClearAllPoints()
            self:SetNormalizedPoint(self.config.point)
        end
    end)

    UIWidgetBelowMinimapContainerFrame.config = S.config.widgets.belowMinimap
    UIWidgetBelowMinimapContainerFrame.defaults = S.defaults.widgets.belowMinimap
    UIWidgetBelowMinimapContainerFrame:SetMovable(true)
    UIWidgetBelowMinimapContainerFrame:SetUserPlaced(true)
    UIWidgetBelowMinimapContainerFrame:ClearAllPoints()
    UIWidgetBelowMinimapContainerFrame:SetNormalizedPoint(UIWidgetBelowMinimapContainerFrame.config.point)
    UIWidgetBelowMinimapContainerFrame:CreateMover("Minimap Widgets Frame", UIWidgetBelowMinimapContainerFrame.defaults.point, 200, 20)
    R:SecureHook(UIWidgetBelowMinimapContainerFrame, "SetPoint", function(self, point, anchor, relativePoint, x, y)
        if point ~= self.config.point[1] or anchor ~= self.config.point[2] or relativePoint ~= self.config.point[3] then
            self:ClearAllPoints()
            self:SetNormalizedPoint(self.config.point)
        end
    end)

    if UIWidgetPowerBarContainerFrame then
        UIWidgetPowerBarContainerFrame.config = S.config.widgets.powerbar
        UIWidgetPowerBarContainerFrame.defaults = S.defaults.widgets.powerbar
        UIWidgetPowerBarContainerFrame:SetMovable(true)
        UIWidgetPowerBarContainerFrame:SetUserPlaced(true)
        UIWidgetPowerBarContainerFrame:ClearAllPoints()
        UIWidgetPowerBarContainerFrame:SetNormalizedPoint(UIWidgetPowerBarContainerFrame.config.point)
        UIWidgetPowerBarContainerFrame:CreateMover("Powerbar Widgets Frame", UIWidgetPowerBarContainerFrame.defaults.point, 200, 20)
        R:SecureHook(UIWidgetPowerBarContainerFrame, "SetPoint", function(self, point, anchor, relativePoint, x, y)
            if point ~= self.config.point[1] or anchor ~= self.config.point[2] or relativePoint ~= self.config.point[3] then
                self:ClearAllPoints()
                self:SetNormalizedPoint(self.config.point)
            end
        end)
    end
end