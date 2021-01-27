local AddonName, AddonTable = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnArena()
    local config = R.config.db.profile.modules.unitFrames.arena
    local default = R.config.defaults.profile.modules.unitFrames.arena

    if R.IsRetail and config.enabled then
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
                R:CreateFrameFader(arena, config.fader)
            end
            UF.frames["arena" .. i] = arena

            R:CreateDragFrame(arena, "Arena" .. i, default.point)
        end
    end
end

function UF:CreateArena()
    self.cfg = R.config.db.profile.modules.unitFrames.arena
end

function UF:UpdateArena()
    if R.IsRetail then
        for i = 1, MAX_ARENA_FRAMES do
            local self = UF.frames["arena" .. i]
            if self then
                UF:UpdateFrame(self)

                if UF:IsBlizzardTheme() then
                else
                end
            end
        end
    end
end
