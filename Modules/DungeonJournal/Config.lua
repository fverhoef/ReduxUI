local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local DJ = Addon.Modules.DungeonJournal

Addon.config.defaults.profile.modules.dungeonJournal = {
}

Addon.config.options.args.dungeonJournal = {    
    type = "group",
    name = "Dungeon Journal",
    order = 8,
    args = {
        header = {type = "header", name = Addon.title .. " > Dungeon Journal", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if DJ.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return DJ.config.db.profile.enabled
            end,
            set = function(_, val)
                DJ.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.DungeonJournal:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 1}
    }
}

function DJ:SetupConfig()
    DJ.config = {}
    DJ.config.db = {
        profile = Addon.config.db.profile.modules.dungeonJournal
    }
end
