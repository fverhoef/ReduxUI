local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local CS = R.Modules.CharacterStats
local oUF = ns.oUF or oUF

function UF:SpawnPlayer()
    local config = UF.config.player
    local default = UF.defaults.player

    if config.enabled then
        return UF:SpawnFrame("Player", "player", UF.CreatePlayer, config, default)
    end
end

function UF:CreatePlayer()
    self.config = UF.config.player
    self.defaults = UF.defaults.player

    UF:SetupFrame(self)

    self:CreateAdditionalPower()
    self:CreatePowerPrediction()
    self:CreateEnergyManaRegen()
    
    -- TODO: optionally hide level when combat/resting shows?
    --self:CreateTab()

    -- TODO: replace with oUF class power?
    if not R.isClassic then
        self:CreateComboFrame()
    end

    self:RegisterEvent("GROUP_ROSTER_UPDATE", UF.Player_OnEvent, true)
    self:RegisterEvent("PLAYER_TARGET_CHANGED", UF.Player_OnEvent, true)

    R:CreateDragFrame(self.Power, "Player Power", UF.defaults.player.power.point)
    R:CreateDragFrame(self.CastbarParent, "Player Castbar", UF.defaults.player.castbar.point)

    self.Update = UF.UpdatePlayer
end

function UF:UpdatePlayer()
    if not self then
        return
    end

    UF:Player_ApplyTheme(UF.config.theme)
    UF:UpdateFrame(self)
end

UF.Player_OnEvent = function(self, event, ...)
    local arg1 = ...
    if event == "GROUP_ROSTER_UPDATE" then
        UF.UpdateTab(self)
    elseif event == "PLAYER_TARGET_CHANGED" then
        UF.frames.target:UpdateArtwork()
    end
end
