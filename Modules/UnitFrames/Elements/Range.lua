local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateRange = function(self)
    self.Range = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
        Update = function(self, inRange, checkedRange, connected)
            if self.fader and not self:IsShown() then
                R:StartFadeIn(self, {
                    fadeInAlpha = self.Range[inRange and "insideAlpha" or "outsideAlpha"],
                    fadeInDuration = self.faderConfig.fadeInDuration,
                    fadeInSmooth = self.faderConfig.fadeInSmooth
                })
            else
                self:SetAlpha(self.Range[inRange and "insideAlpha" or "outsideAlpha"])
            end
        end
    }
    
    return self.Range
end

oUF:RegisterMetaFunction("CreateRange", UF.CreateRange)