local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleDurabilityFrame()
    if not DurabilityFrame or not S.config.durability.enabled then return end

    DurabilityFrame.config = S.config.durability
    DurabilityFrame:SetMovable(true)
    DurabilityFrame:SetUserPlaced(true)
    DurabilityFrame:ClearAllPoints()
    R:SetPoint(DurabilityFrame, unpack(DurabilityFrame.config.point))
    R:CreateMover(DurabilityFrame, "Durability Frame", DurabilityFrame.config.point)
    R:SecureHook(DurabilityFrame, "SetPoint", function(self, point, anchor, relativePoint, x, y)
        if point ~= self.config.point[1] or anchor ~= self.config.point[2] or relativePoint ~= self.config.point[3] then
            self:ClearAllPoints()
            R:SetPoint(self, self.config.point)
        end
    end)
end