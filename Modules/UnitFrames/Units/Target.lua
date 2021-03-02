local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTarget()
    local config = UF.config.target
    local default = UF.defaults.target

    if config.enabled then
        return UF:SpawnFrame("Target", "target", UF.CreateTarget, config, default)
    end
end

function UF:CreateTarget()
    self.config = UF.config.target
    self.defaults = UF.defaults.target

    UF:SetupFrame(self)

    self:CreateRange()

    if R.isClassic then
        self:CreateComboFrame()
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD", UF.TargetFrame_OnEvent)
    self:RegisterEvent("PLAYER_REGEN_DISABLED", UF.TargetFrame_OnEvent, true)
    self:RegisterEvent("PLAYER_REGEN_ENABLED", UF.TargetFrame_OnEvent, true)
    self:RegisterEvent("PLAYER_TARGET_CHANGED", UF.TargetFrame_OnEvent)
    self:RegisterEvent("UNIT_TARGETABLE_CHANGED", UF.TargetFrame_OnEvent)
    self:RegisterEvent("UNIT_FACTION", UF.TargetFrame_OnEvent)
    self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UF.TargetFrame_OnEvent)
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UF.TargetFrame_OnEvent)
    self:RegisterEvent("UNIT_LEVEL", UF.TargetFrame_OnEvent)

    self.Update = UF.UpdateTarget
end

function UF:UpdateTarget()
    if not self then
        return
    end
    
    UF:Target_ApplyTheme(UF.config.theme)
    UF:UpdateFrame(self)
end

UF.TargetFrame_OnEvent = function(self, event)
    if event == "PLAYER_TARGET_CHANGED" then
        if UnitExists(self.unit) and not IsReplacingUnit() then
            if UnitIsEnemy(self.unit, "player") then
                PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
            elseif UnitIsFriend("player", self.unit) then
                PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
            else
                PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
            end
        end
        CloseDropDownMenus()
    end

    self:UpdateArtwork()
end
