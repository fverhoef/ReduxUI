local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnArenaHeader()
    local config = UF.config.arena
    local default = UF.defaults.arena

    if R.isRetail and config.enabled then
        oUF:RegisterStyle(addonName .. "Arena", UF.CreateArena)
        oUF:SetActiveStyle(addonName .. "Arena")
        for i = 1, MAX_ARENA_FRAMES do
            local arena = oUF:Spawn("arena" .. i, addonName .. "Arena" .. i)
            if (i == 1) then
                arena:Point(unpack(config.point))
            else
                arena:SetPoint(config.point, UF.frames["arena" .. (i - 1)], config.relativePoint, config.xOffset, config.yOffset)
            end
            UF.frames["arena" .. i] = arena

            R:CreateDragFrame(arena, "Arena" .. i, default.point)

            parent.Update = UF.UpdateArenaHeader
        end
    end
end

function UF:UpdateArenaHeader()
    if R.isRetail then
        for i = 1, MAX_ARENA_FRAMES do
            UF:UpdateArena(UF.frames["arena" .. i])
        end
    end
end

function UF:CreateArena()
    self.config = UF.config.arena
    self.defaults = UF.defaults.arena
    self.isGroupUnit = true

    UF:SetupFrame(self)

    self.Update = UF.UpdateArena
end

function UF:UpdateArena()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end
