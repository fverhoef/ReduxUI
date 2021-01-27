local AddonName, AddonTable = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnBoss()
    local config = R.config.db.profile.modules.unitFrames.boss
    local default = R.config.defaults.profile.modules.unitFrames.boss
    
    if R.IsRetail and config.enabled then
        oUF:RegisterStyle(AddonName .. "Boss", UF.CreateBoss)
        oUF:SetActiveStyle(AddonName .. "Boss")
        for i = 1, MAX_BOSS_FRAMES do
            local boss = oUF:Spawn("boss" .. i, AddonName .. "Boss" .. i)
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
    if R.IsRetail then
        for i = 1, MAX_BOSS_FRAMES do
            local self = UF.frames["boss" .. i]
            if self then
            end
        end
    end
end
