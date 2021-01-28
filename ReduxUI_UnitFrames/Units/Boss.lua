local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnBoss()
    local config = R.config.db.profile.modules.unitFrames.boss
    local default = R.config.defaults.profile.modules.unitFrames.boss
    
    if R.isRetail and config.enabled then
        oUF:RegisterStyle(addonName .. "Boss", UF.CreateBoss)
        oUF:SetActiveStyle(addonName .. "Boss")
        for i = 1, MAX_BOSS_FRAMES do
            local boss = oUF:Spawn("boss" .. i, addonName .. "Boss" .. i)
            if (i == 1) then
                boss:SetPoint(unpack(config.point))
            else
                boss:SetPoint(config.point, UF.frames["boss" .. (i - 1)], config.relativePoint, config.xOffset, config.yOffset)
            end
            if config.fader and config.fader.enabled then
                R:CreateFrameFader(boss, config.fader)
            end
            UF.frames["boss" .. i] = boss

            R:CreateDragFrame(boss, "Boss" .. i, default.point)
        end
    end
end

function UF:CreateBoss()
    self.cfg = R.config.db.profile.modules.unitFrames.boss
end

function UF:UpdateBoss()    
    if R.isRetail then
        for i = 1, MAX_BOSS_FRAMES do
            local self = UF.frames["boss" .. i]
            if self then
            end
        end
    end
end
