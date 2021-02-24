local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateArtwork()
    local config = AB.config.artwork

    local artwork = CreateFrame("Frame", addonName .. "MainMenuBarArtwork", UIParent)
    artwork:SetSize(552, 51)
    artwork:SetPoint("BOTTOM", _G.UIParent, "BOTTOM", 0, 0)
    artwork.config = config

    artwork.Texture = artwork:CreateTexture("ARTWORK", 0)
    artwork.Texture:SetSize(552, 45)
    artwork.Texture:SetTexture(R.media.textures.actionBars.mainMenuBar)
    artwork.Texture:SetAllPoints()

    artwork.TopEndCap = artwork:CreateTexture("ARTWORK", 1)

    artwork.LeftEndCap = artwork:CreateTexture("ARTWORK", 2)
    artwork.LeftEndCap:SetPoint("BOTTOMRIGHT", artwork, "BOTTOMLEFT", 32, 0)

    artwork.RightEndCap = artwork:CreateTexture("ARTWORK", 2)
    artwork.RightEndCap:SetPoint("BOTTOMLEFT", artwork, "BOTTOMRIGHT", -32, 0)

    artwork:CreateFader(R.config.faders.onShow)

    return artwork
end

function AB:UpdateArtwork()
    local config = AB.config.artwork
    local rightBarConfig = AB.config.multiBarBottomRight
    local artwork = AB.bars.Artwork

    if config.enabled then
        artwork:LinkFader(AB.bars.MainMenuBar)

        if rightBarConfig.enabled and not rightBarConfig.detached and rightBarConfig.attachedPoint == AB.ATTACHMENT_POINTS.Right then
            artwork:SetWidth(806)
        else
            artwork:SetWidth(552)
        end

        artwork.Texture:Show()
        artwork.TopEndCap:Show()
        artwork.LeftEndCap:Show()
        artwork.RightEndCap:Show()

        local isExpBarShown = _G.MainMenuExpBar:IsShown()
        local isRepBarShown = _G.ReputationWatchBar:IsShown()

        local offset = 0
        if isExpBarShown and isRepBarShown then
            offset = 22
        else
            offset = 10
        end

        artwork.Texture:ClearAllPoints()
        artwork.Texture:SetPoint("BOTTOMLEFT", artwork, "BOTTOMLEFT", 0, offset)
        artwork.Texture:SetPoint("BOTTOMRIGHT", artwork, "BOTTOMRIGHT", 0, offset)

        artwork.LeftEndCap:SetPoint("BOTTOMRIGHT", artwork, "BOTTOMLEFT", 32, -1)
        artwork.RightEndCap:SetPoint("BOTTOMLEFT", artwork, "BOTTOMRIGHT", -32, -1)

        local endCapWidth, endCapHeight
        if config.theme == AB.ARTWORK_THEMES.Default then
            endCapWidth = 128
            endCapHeight = 76

            artwork.Texture:SetTexture(R.media.textures.actionBars.mainMenuBar)
            if rightBarConfig.enabled and not rightBarConfig.detached then
                artwork.Texture:SetTexCoord(113 / 1024, (113 + 806) / 1024, 115 / 255, 165 / 255)
            else
                artwork.Texture:SetTexCoord(113 / 1024, (113 + 552) / 1024, 64 / 255, 114 / 255)
            end

            artwork.TopEndCap:Hide()

            artwork.LeftEndCap:SetTexture(R.media.textures.actionBars.mainMenuBar)
            artwork.LeftEndCap:SetTexCoord(115 / 1024, (115 + endCapWidth) / 1024, 168 / 255, (168 + endCapHeight) / 255)
            artwork.LeftEndCap:SetSize(endCapWidth, endCapHeight)

            artwork.RightEndCap:SetTexture(R.media.textures.actionBars.mainMenuBar)
            artwork.RightEndCap:SetTexCoord((115 + endCapWidth) / 1024, 115 / 1024, 168 / 255, (168 + endCapHeight) / 255)
            artwork.RightEndCap:SetSize(endCapWidth, endCapHeight)
        else
            endCapWidth = 128
            endCapHeight = 105
            local endCapScale = 0.85

            local texture = R.media.textures.actionBars["mainMenuBar_" .. config.theme]
            if config.theme == AB.ARTWORK_THEMES.Faction then
                if UnitFactionGroup("player") == "Horde" then
                    texture = R.media.textures.actionBars.mainMenuBar_Horde
                else
                    texture = R.media.textures.actionBars.mainMenuBar_Alliance
                end
            end
            artwork.Texture:SetTexture(texture)
            artwork.Texture:SetTexCoord(0, 1, 90 / 512, 184 / 512)
            artwork.Texture:SetDrawLayer("ARTWORK", 0)

            artwork.TopEndCap:Show()
            artwork.TopEndCap:SetTexture(texture, true)
            artwork.TopEndCap:SetTexCoord(0 / 512, 512 / 512, 2 / 512, 29 / 512)
            artwork.TopEndCap:SetHorizTile(true)
            artwork.TopEndCap:SetHeight(16)
            artwork.TopEndCap:SetWidth(artwork:GetWidth())
            artwork.TopEndCap:SetPoint("TOPLEFT", artwork.LeftEndCap, "TOPRIGHT", -30,
                                       endCapScale * ((isExpBarShown and isRepBarShown and -15) or -28))
            artwork.TopEndCap:SetPoint("TOPRIGHT", artwork.RightEndCap, "TOPLEFT", 30,
                                       endCapScale * ((isExpBarShown and isRepBarShown and -15) or -28))
            artwork.TopEndCap:SetDrawLayer("ARTWORK", 1)

            artwork.LeftEndCap:SetTexture(texture)
            artwork.LeftEndCap:SetTexCoord(0 / 512, 176 / 512, 365 / 512, 510 / 512)
            artwork.LeftEndCap:SetSize(endCapScale * endCapWidth, endCapScale * endCapHeight)
            artwork.LeftEndCap:SetDrawLayer("ARTWORK", 2)

            artwork.RightEndCap:SetTexture(texture)
            artwork.RightEndCap:SetTexCoord(176 / 512, 0 / 512, 365 / 512, 510 / 512)
            artwork.RightEndCap:SetSize(endCapScale * endCapWidth, endCapScale * endCapHeight)
            artwork.RightEndCap:SetDrawLayer("ARTWORK", 2)
        end
    else
        artwork:UnlinkFader(AB.bars.MainMenuBar)

        artwork.Texture:Hide()
        artwork.TopEndCap:Hide()
        artwork.LeftEndCap:Hide()
        artwork.RightEndCap:Hide()
    end
end
