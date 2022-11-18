local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleVehicleSeatIndicator()
    if not VehicleSeatIndicator or not S.config.vehicleSeat.enabled then return end

    VehicleSeatIndicator.config = S.config.vehicleSeat
    VehicleSeatIndicator.defaults = S.defaults.vehicleSeat
    VehicleSeatIndicator:SetMovable(true)
    VehicleSeatIndicator:SetUserPlaced(true)
    VehicleSeatIndicator:ClearAllPoints()
    VehicleSeatIndicator:SetNormalizedPoint(unpack(VehicleSeatIndicator.config.point))
    VehicleSeatIndicator:CreateMover("Vehicle Seat", VehicleSeatIndicator.defaults.point)
end
