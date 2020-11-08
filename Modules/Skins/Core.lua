local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local S = Addon.Modules.Skins

function S:OnEnable()
    S.Stats:Update()

    S:StylePaperDollFrame()
    S:StyleHonorFrame()
    
    S:StyleFriendsFrame()
    S:StyleWhoFrame()
    S:StyleGuildFrame()

    S:StyleClassTrainerFrame()
    S:StyleQuestLogFrame()
    S:StyleTradeSkillFrame()

    S:StyleWorldMapFrame()

    S:RegisterEvent("PLAYER_DAMAGE_DONE_MODS", S.OnEvent)
    S:RegisterEvent("PLAYER_ENTERING_WORLD", S.OnEvent)
    S:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", S.OnEvent)
    S:RegisterEvent("PLAYER_GUILD_UPDATE", S.OnEvent)
    S:RegisterEvent("PLAYER_LEVEL_UP", S.OnEvent)
    S:RegisterEvent("PLAYER_UPDATE_RESTING", S.OnEvent)
    S:RegisterEvent("PLAYER_XP_UPDATE", S.OnEvent)
    S:RegisterEvent("SKILL_LINES_CHANGED", S.OnEvent)
    S:RegisterEvent("UNIT_ATTACK", S.OnEvent)
    S:RegisterEvent("UNIT_ATTACK_POWER", S.OnEvent)
    S:RegisterEvent("UNIT_ATTACK_SPEED", S.OnEvent)
    S:RegisterEvent("UNIT_DAMAGE", S.OnEvent)
    S:RegisterEvent("UNIT_LEVEL", S.OnEvent)
    S:RegisterEvent("UNIT_MODEL_CHANGED", S.OnEvent)
    S:RegisterEvent("UNIT_RANGED_ATTACK_POWER", S.OnEvent)
    S:RegisterEvent("UNIT_RANGEDDAMAGE", S.OnEvent)
    S:RegisterEvent("UNIT_RESISTANCES", S.OnEvent)
    S:RegisterEvent("UNIT_STATS", S.OnEvent)

    CharacterFrame:HookScript("OnShow", S.UpdatePaperDollFrame)
end

S.OnEvent = function(event, ...)
    if string.find(event, "UNIT_") then
        local unitTarget = select(1, ...)
        if unitTarget == "player" then
            S:UpdatePaperDollFrame()
        end
    else
        S:UpdatePaperDollFrame()
    end
end
