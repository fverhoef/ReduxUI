local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleTicketStatusFrame()
    if not VehicleSeatIndicator or not S.config.vehicleSeat.enabled then return end

    VehicleSeatIndicator.config = S.config.vehicleSeat
    VehicleSeatIndicator:SetMovable(true)
    VehicleSeatIndicator:SetUserPlaced(true)
    VehicleSeatIndicator:ClearAllPoints()
    R:SetPoint(VehicleSeatIndicator, unpack(VehicleSeatIndicator.config.point))
    R:CreateMover(VehicleSeatIndicator, "Vehicle Seat", VehicleSeatIndicator.config.point)
end
