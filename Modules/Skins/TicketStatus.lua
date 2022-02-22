local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleTicketStatusFrame()
    if not TicketStatusFrame or not S.config.ticketStatus.enabled then return end

    TicketStatusFrame.config = S.config.ticketStatus
    TicketStatusFrame:SetMovable(true)
    TicketStatusFrame:SetUserPlaced(true)
    TicketStatusFrame:ClearAllPoints()
    R:SetPoint(TicketStatusFrame, unpack(TicketStatusFrame.config.point))
    R:CreateMover(TicketStatusFrame, "GM Ticket Status", TicketStatusFrame.config.point)
end
