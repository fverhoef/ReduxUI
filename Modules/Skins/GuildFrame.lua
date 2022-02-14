local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleGuildFrame()
    if R.isRetail or not S.config.guild.enabled then return end

    local button, level, name, class, statusButton, statusName

    for i = 1, _G.GUILDMEMBERS_TO_DISPLAY do
        button = _G["GuildFrameButton" .. i]
        class = _G["GuildFrameButton" .. i .. "Class"]

        button.icon = button:CreateTexture("$parentIcon", "ARTWORK")
        button.icon:SetPoint("LEFT", class, "LEFT", -20, 0)
        button.icon:SetSize(15, 15)
        button.icon:SetTexture([[Interface\WorldStateFrame\Icons-Classes]])

        R:Offset(class, 20, 0)
    end

    GuildMemberDetailFrame.icon = GuildMemberDetailFrame:CreateTexture("$parentIcon", "ARTWORK")
    GuildMemberDetailFrame.icon:SetPoint("TOPLEFT", GuildMemberDetailName, "TOPLEFT", -30, 0)
    GuildMemberDetailFrame.icon:SetSize(25, 25)
    GuildMemberDetailFrame.icon:SetTexture([[Interface\WorldStateFrame\Icons-Classes]])

    R:Offset(GuildMemberDetailName, 30, 0)
    R:Offset(GuildMemberDetailZoneLabel, -30, 0)

    S:SecureHook("GuildStatus_Update", function()
        local _, level, class, zone, online, classFileName
        local button, buttonText, classTextColor, levelTextColor
        local playerZone = GetRealZoneText()

        if FriendsFrame.playerStatusFrame then
            for i = 1, GUILDMEMBERS_TO_DISPLAY, 1 do
                button = _G["GuildFrameButton" .. i]
                _, _, _, level, class, zone, _, _, online = GetGuildRosterInfo(button.guildIndex)

                classFileName = R:UnlocalizedClassName(class)
                if classFileName then
                    if online then
                        classTextColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classFileName] or
                                             RAID_CLASS_COLORS[classFileName]
                        levelTextColor = GetQuestDifficultyColor(level)

                        buttonText = _G["GuildFrameButton" .. i .. "Name"]
                        buttonText:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b)
                        buttonText = _G["GuildFrameButton" .. i .. "Class"]
                        buttonText:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b)
                        buttonText = _G["GuildFrameButton" .. i .. "Level"]
                        buttonText:SetTextColor(levelTextColor.r, levelTextColor.g, levelTextColor.b)
                        buttonText = _G["GuildFrameButton" .. i .. "Zone"]
                        buttonText:SetTextColor(1, 1, 1)

                        if zone == playerZone then
                            buttonText:SetTextColor(0, 1, 0)
                        end
                    end

                    if button.icon then
                        button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
                    end
                end
            end
        else
            for i = 1, _G.GUILDMEMBERS_TO_DISPLAY, 1 do
                button = _G["GuildFrameGuildStatusButton" .. i]
                _, _, _, _, class, _, _, _, online = GetGuildRosterInfo(button.guildIndex)

                classFileName = R:UnlocalizedClassName(class)
                if classFileName then
                    if online then
                        classTextColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classFileName] or
                                             RAID_CLASS_COLORS[classFileName]
                        _G["GuildFrameGuildStatusButton" .. i .. "Name"]:SetTextColor(classTextColor.r, classTextColor.g,
                                                                                      classTextColor.b)
                        _G["GuildFrameGuildStatusButton" .. i .. "Online"]:SetTextColor(1, 1, 1)
                    end
                end
            end
        end

        local selection = GetGuildRosterSelection()
        if selection then
            local fullName, rank, rankIndex, level, class, zone, note, officernote, online = GetGuildRosterInfo(selection)
            classFileName = R:UnlocalizedClassName(class)
            classTextColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classFileName] or RAID_CLASS_COLORS[classFileName]
            if classTextColor then
                levelTextColor = GetQuestDifficultyColor(level)
                GuildMemberDetailName:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b)
                GuildMemberDetailLevel:SetTextColor(levelTextColor.r, levelTextColor.g, levelTextColor.b)
                if GuildMemberDetailFrame.icon then
                    GuildMemberDetailFrame.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
                end
            end
        end
    end)
end
