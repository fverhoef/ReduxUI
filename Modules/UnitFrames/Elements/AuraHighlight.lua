local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateAuraHighlight = function(self)
    self.AuraHighlight = self:CreateTexture("$parentAuraHighlight", "OVERLAY")
	Addon:SetInside(self.AuraHighlight, self.Health.backdrop)
	self.AuraHighlight:SetTexture(Addon.media.textures.Blank)
	self.AuraHighlight:SetVertexColor(0, 0, 0, 0)
	self.AuraHighlight:SetBlendMode("ADD")
	self.AuraHighlight.PostUpdate = UF.PostUpdate_AuraHighlight

	self.AuraHightlightGlow = Addon:CreateShadow(self, nil, true)
	self.AuraHightlightGlow:Hide()

	self.AuraHighlightFilter = false
    self.AuraHighlightFilterTable = {}

	if self.Health then
		self.AuraHighlight:SetParent(self.Health)
		self.AuraHightlightGlow:SetParent(self.Health)
	end
    
    return self.AuraHighlight
end

UF.UpdateAuraHighlight = function(self)
    local cfg = self.cfg.auraHighlight
    if cfg and cfg.enabled then
        self:EnableElement("AuraHighlight")

		self.AuraHighlight:SetBlendMode(UF.config.db.profile.colors.auraHighlight.blendMode)
        self.AuraHighlight:SetAllPoints(self.Health:GetStatusBarTexture())
        
		if cfg.mode == 'GLOW' then
			self.AuraHighlightBackdrop = true
			if self.ThreatIndicator then
				self.AuraHightlightGlow:SetAllPoints(self.ThreatIndicator.MainGlow)
			elseif self.TargetGlow then
				self.AuraHightlightGlow:SetAllPoints(self.TargetGlow)
			end
		else
			self.AuraHighlightBackdrop = false
		end
    else
        self:EnableElement("AuraHighlight")
    end
end

function UF:PostUpdate_AuraHighlight(object, debuffType, _, wasFiltered)
	if debuffType and not wasFiltered then
		local color = UF.config.db.profile.colors.debuffHighlight[debuffType]
		if object.AuraHighlightBackdrop and object.AuraHightlightGlow then
			object.AuraHightlightGlow:SetBackdropBorderColor(unpack(color))
		else
			object.AuraHighlight:SetVertexColor(unpack(color))
		end
	end
end
