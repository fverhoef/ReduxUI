local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnBossHeader()
    local config = UF.config.boss
    local default = UF.defaults.boss

    if R.isRetail and config.enabled then
        local parent = CreateFrame("Frame", addonName .. "Boss")
        parent:Point(unpack(config.point))
        parent:SetSize(200, 40)
        parent:Show()
        parent.bosses = {}

        oUF:RegisterStyle(addonName .. "Boss", UF.CreateBoss)
        oUF:SetActiveStyle(addonName .. "Boss")
        for i = 1, MAX_BOSS_FRAMES do
            local boss = oUF:Spawn("boss" .. i, addonName .. "Boss" .. i)
            boss:SetParent(parent)

            if (i == 1) then
                boss:Point(unpack(config.point))
            else
                boss:SetPoint(config.point, UF.frames["boss" .. (i - 1)], config.relativePoint, config.xOffset, config.yOffset)
            end

            parent.bosses[i] = boss
        end

        R:CreateDragFrame(parent, "Boss", default.point)

        parent.Update = UF.UpdateBossHeader

        return parent
    end
end

function UF:UpdateBossHeader()
end

function UF:CreateBoss()
    self.config = UF.config.boss
    self.defaults = UF.defaults.boss
    self.isGroupUnit = true

    UF:SetupFrame(self)

    self.Update = UF.UpdateBoss
end

function UF:UpdateBoss()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end
