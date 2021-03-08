local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateArtwork()
    self.Artwork = CreateFrame("Frame", "$parentArtwork", self)
    self.Artwork:SetAllPoints(self)

    self.Artwork.Background = self.Artwork:CreateTexture("$parentBackground", "BACKGROUND", nil, 2)
    self.Artwork.Highlight = self.Artwork:CreateTexture("$parentHighlight", "BACKGROUND", nil, 1)
    self.Artwork.Elite = self.Artwork:CreateTexture("$parentElite", "ARTWORK")
    self.Artwork.Rare = self.Artwork:CreateTexture("$parentRare", "ARTWORK")
    self.Artwork.RareElite = self.Artwork:CreateTexture("$parentRareElite", "ARTWORK")
end

oUF:RegisterMetaFunction("CreateArtwork", UF.CreateArtwork)

function UF:UpdateArtwork()
    local artwork = self.Artwork
    if not artwork then
        return
    end

    local config = self.config.artwork
    if config.enabled then
        artwork:Show()

        if config.background and config.background.enabled then
            artwork.Background:Show()
            artwork.Background:ClearAllPoints()
            artwork.Background:SetTexture(config.background.texture)
            artwork.Background:SetTexCoord(unpack(config.background.coords))
            artwork.Background:Point(unpack(config.background.point))
            artwork.Background:SetSize(unpack(config.background.size))
            artwork.Background:SetVertexColor(unpack(config.background.color))
        else
            artwork.Background:Hide()
        end

        if config.highlight and config.highlight.enabled then
            artwork.Highlight:Show()
            artwork.Highlight:ClearAllPoints()
            artwork.Highlight:SetTexture(config.highlight.texture)
            artwork.Highlight:SetTexCoord(unpack(config.highlight.coords))
            artwork.Highlight:Point(unpack(config.highlight.point))
            artwork.Highlight:SetSize(unpack(config.highlight.size))
        else
            artwork.Highlight:Hide()
        end

        if config.elite and config.elite.enabled then
            artwork.Elite:Show()
            artwork.Elite:ClearAllPoints()
            artwork.Elite:SetTexture(config.elite.texture)
            artwork.Elite:SetTexCoord(unpack(config.elite.coords))
            artwork.Elite:Point(unpack(config.elite.point))
            artwork.Elite:SetSize(unpack(config.elite.size))
        else
            artwork.Elite:Hide()
        end

        if config.rare and config.rare.enabled then
            artwork.Rare:Show()
            artwork.Rare:ClearAllPoints()
            artwork.Rare:SetTexture(config.rare.texture)
            artwork.Rare:SetTexCoord(unpack(config.rare.coords))
            artwork.Rare:Point(unpack(config.rare.point))
            artwork.Rare:SetSize(unpack(config.rare.size))
        else
            artwork.Rare:Hide()
        end

        if config.rareElite and config.rareElite.enabled then
            artwork.RareElite:Show()
            artwork.RareElite:ClearAllPoints()
            artwork.RareElite:SetTexture(config.rareElite.texture)
            artwork.RareElite:SetTexCoord(unpack(config.rareElite.coords))
            artwork.RareElite:Point(unpack(config.rareElite.point))
            artwork.RareElite:SetSize(unpack(config.rareElite.size))
        else
            artwork.RareElite:Hide()
        end

        local classification = UnitClassification(self.unit)
        if (classification == "rare") then
            artwork.Elite:Hide()
            artwork.Rare:Show()
            artwork.RareElite:Hide()
        elseif (classification == "rareelite") then
            artwork.Elite:Hide()
            artwork.Rare:Hide()
            artwork.RareElite:Show()
        elseif (classification == "elite" or classification == "worldboss" or classification == "boss") then
            artwork.Elite:Show()
            artwork.Rare:Hide()
            artwork.RareElite:Hide()
        else
            artwork.Elite:Hide()
            artwork.Rare:Hide()
            artwork.RareElite:Hide()
        end
    else
        artwork:Hide()
    end
end

oUF:RegisterMetaFunction("UpdateArtwork", UF.UpdateArtwork)
