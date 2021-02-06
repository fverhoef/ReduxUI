local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnBossHeader()
    local config = UF.config.boss
    local default = UF.defaults.boss
    
    if R.isRetail and config.enabled then
        local parent = CreateFrame("Frame", addonName .. "Boss")
        parent:SetPoint(unpack(config.point))
        parent:SetSize(200, 40)
        parent:Show()
        parent.bosses = {}

        oUF:RegisterStyle(addonName .. "Boss", UF.CreateBoss)
        oUF:SetActiveStyle(addonName .. "Boss")
        for i = 1, MAX_BOSS_FRAMES do
            local boss = oUF:Spawn("boss" .. i, addonName .. "Boss" .. i)
            boss:SetParent(parent)

            if (i == 1) then
                boss:SetPoint(unpack(config.point))
            else
                boss:SetPoint(config.point, UF.frames["boss" .. (i - 1)], config.relativePoint, config.xOffset, config.yOffset)
            end

            if config.fader and config.fader.enabled then
                R:CreateFrameFader(boss, config.fader)
            end

            parent.bosses[i] = boss
        end

        R:CreateDragFrame(parent, "Boss", default.point)

        return parent
    end
end

function UF:UpdateBossHeader()  
    if R.isRetail then
        for i = 1, MAX_BOSS_FRAMES do
            UF:UpdateBoss(UF.bossHeader.bosses[i])  
        end
    end
end

function UF:CreateBoss()
    self.cfg = UF.config.boss

    self:CreateBorder(self.cfg.border.size)
    self:SetBorderPadding(1, 1, 0, 0)
    self:CreateShadow()
    self:SetShadowPadding(1, 1, 0, 0)
end

function UF:UpdateBoss(self)
    if not self then
        return
    end
    
    UF:UpdateFrame(self)
end
