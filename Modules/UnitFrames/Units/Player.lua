local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPlayer()
    local config = UF.config.player
    if not config.enabled then return end

    return UF:SpawnFrame("Player", "player", UF.CreatePlayer, config, UF.defaults.player)
end

function UF:CreatePlayer()
    self.config = UF.config.player
    self.defaults = UF.defaults.player

    self:InitializeFrame()
    self:CreateAdditionalPower()
    self:CreateClassPower()
    self:CreateEnergyManaRegen()
    self:CreateRestingIndicator()

    R:CreateDragFrame(self.Castbar, "PlayerCastbar", self.defaults.castbar.point)

    self.Update = UF.UpdatePlayer
end

function UF:UpdatePlayer()
    if not self then return end

    self:ConfigureFrame()
    self:ConfigureAdditionalPower()
    self:ConfigureClassPower()
    self:ConfigureEnergyManaRegen()
    self:ConfigureRestingIndicator()

    if self.config.castbar.detached then
        self.Castbar:ClearAllPoints()
        self.Castbar:Point(self.config.castbar.point)
    end
end
