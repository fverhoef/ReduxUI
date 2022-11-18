local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleTicketStatusFrame()
    if not TicketStatusFrame or not S.config.ticketStatus.enabled then return end

    TicketStatusFrame.config = S.config.ticketStatus
    TicketStatusFrame.defaults = S.defaults.ticketStatus
    TicketStatusFrame:SetMovable(true)
    TicketStatusFrame:SetUserPlaced(true)
    TicketStatusFrame:ClearAllPoints()
    TicketStatusFrame:SetNormalizedPoint(unpack(TicketStatusFrame.config.point))
    TicketStatusFrame:CreateMover("GM Ticket Status", TicketStatusFrame.defaults.point)
end
