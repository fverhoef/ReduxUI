local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleHonorFrame()
    HonorLevelText:SetParent(CharacterNameFrame)
    HonorLevelText:ClearAllPoints()
    HonorLevelText:SetPoint("TOP", CharacterNameFrame, "BOTTOM", 0, -10)
    HonorGuildText:SetParent(CharacterNameFrame)

    S:SecureHook("HonorFrame_SetLevel", function()
        local class = R:UnlocalizedClassName(UnitClass("player"))
        local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        HonorLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), R:Hex(1, 1, 1) .. UnitRace("player") .. "|r", R:Hex(classColor) .. UnitClass("player") .. "|r")
    end)
    S:SecureHook("HonorFrame_SetGuild", function()
        local guildName, title, rank = GetGuildInfo("player")
        if guildName then
            HonorGuildText:SetFormattedText(GUILD_TITLE_TEMPLATE, title, R:Hex(R.config.db.profile.modules.skins.colors.guild) .. guildName .. "|r")
        end
    end)
end
