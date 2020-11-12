local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnBoss()
    local config = UF.config.db.profile.boss
    local default = Addon.config.defaults.profile.modules.unitFrames.boss
    
    if Addon.IsRetail and config.enabled then
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
                Addon:CreateFrameFader(boss, config.fader)
            end
            UF.frames["boss" .. i] = boss

            Addon:CreateDragFrame(boss, "Boss" .. i, default.point)
        end
    end
end

function UF:CreateBoss()
    self.cfg = UF.config.db.profile.boss
end

function UF:UpdateBoss()    
    if Addon.IsRetail then
        for i = 1, MAX_BOSS_FRAMES do
            local self = UF.frames["boss" .. i]
            if self then
            end
        end
    end
end
