local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnArena()
    local config = UF.config.db.profile.arena
    local default = Addon.config.defaults.profile.modules.unitFrames.arena

    if Addon.IsRetail and config.enabled then
        oUF:RegisterStyle(AddonName .. "Arena", UF.CreateArena)
        oUF:SetActiveStyle(AddonName .. "Arena")
        for i = 1, MAX_ARENA_FRAMES do
            local arena = oUF:Spawn("arena" .. i, AddonName .. "Arena" .. i)
            if (i == 1) then
                arena:SetPoint(unpack(config.point))
            else
                arena:SetPoint(config.point, UF.frames["arena" .. (i - 1)], config.relativePoint, config.xOffset, config.yOffset)
            end
            if config.fader and config.fader.enabled then
                Addon:CreateFrameFader(arena, config.fader)
            end
            UF.frames["arena" .. i] = arena

            Addon:CreateDragFrame(arena, "Arena" .. i, default.point)
        end
    end
end

function UF:CreateArena()
    self.cfg = UF.config.db.profile.arena
end

function UF:UpdateArena()
    if Addon.IsRetail then
        for i = 1, MAX_ARENA_FRAMES do
            local self = UF.frames["arena" .. i]
            if self then
            end
        end
    end
end
