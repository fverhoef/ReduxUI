local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateArtwork()
    self.Artwork = CreateFrame("Frame", "$parentArtwork", self)
    self.Artwork:SetAllPoints(self)

    self.Artwork.Background = self.Artwork:CreateTexture("$parentBackground", "BORDER")
    self.Artwork.Highlight = self.Artwork:CreateTexture("$parentHighlight", "BORDER")
    self.Artwork.Elite = self.Artwork:CreateTexture("$parentElite", "BORDER")
    self.Artwork.Rare = self.Artwork:CreateTexture("$parentRare", "BORDER")
    self.Artwork.RareElite = self.Artwork:CreateTexture("$parentRareElite", "BORDER")
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

        if config.background then
            artwork.Background:ClearAllPoints()
            artwork.Background:SetTexture(config.background.texture)
            artwork.Background:SetTexCoord(unpack(config.background.coords))
            artwork.Background:Point(unpack(config.background.point))
            artwork.Background:SetSize(unpack(config.background.size))
            artwork.Background:SetVertexColor(unpack(config.background.color))
        end

        if config.highlight then
            artwork.Highlight:ClearAllPoints()
            artwork.Highlight:SetTexture(config.highlight.texture)
            artwork.Highlight:SetTexCoord(unpack(config.highlight.coords))
            artwork.Highlight:Point(unpack(config.highlight.point))
            artwork.Highlight:SetSize(unpack(config.highlight.size))
        end

        if config.elite then
            artwork.Elite:ClearAllPoints()
            artwork.Elite:SetTexture(config.elite.texture)
            artwork.Elite:SetTexCoord(unpack(config.elite.coords))
            artwork.Elite:Point(unpack(config.elite.point))
            artwork.Elite:SetSize(unpack(config.elite.size))
        end

        if config.rare then
            artwork.Rare:ClearAllPoints()
            artwork.Rare:SetTexture(config.rare.texture)
            artwork.Rare:SetTexCoord(unpack(config.rare.coords))
            artwork.Rare:Point(unpack(config.rare.point))
            artwork.Rare:SetSize(unpack(config.rare.size))
        end

        if config.rareElite then
            artwork.RareElite:ClearAllPoints()
            artwork.RareElite:SetTexture(config.rareElite.texture)
            artwork.RareElite:SetTexCoord(unpack(config.rareElite.coords))
            artwork.RareElite:Point(unpack(config.rareElite.point))
            artwork.RareElite:SetSize(unpack(config.rareElite.size))
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
