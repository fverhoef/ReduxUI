local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local S = Addon.Modules.Skins

function S:StyleHonorFrame()
    HonorLevelText:SetParent(CharacterNameFrame)
    HonorLevelText:ClearAllPoints()
    HonorLevelText:SetPoint("TOP", CharacterNameFrame, "BOTTOM", 0, -10)
    HonorGuildText:SetParent(CharacterNameFrame)

    S:SecureHook("HonorFrame_SetLevel", function()
        local class = Addon:UnlocalizedClassName(UnitClass("player"))
        local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        HonorLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), Addon:Hex(1, 1, 1) .. UnitRace("player") .. "|r", Addon:Hex(classColor) .. UnitClass("player") .. "|r")
    end)
    S:SecureHook("HonorFrame_SetGuild", function()
        local guildName, title, rank = GetGuildInfo("player")
        if guildName then
            HonorGuildText:SetFormattedText(GUILD_TITLE_TEMPLATE, title, Addon:Hex(S.config.db.profile.colors.guild) .. guildName .. "|r")
        end
    end)
end
