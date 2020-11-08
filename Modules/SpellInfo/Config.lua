local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local SI = Addon.Modules.SpellInfo

Addon.config.defaults.profile.modules.spellInfo = {
    modifySpellDamage = true,
    showNextRank = true
}

Addon.config.options.args.spellInfo = {    
    type = "group",
    name = "Spell Info",
    order = 10,
    args = {
        header = {type = "header", name = Addon.title .. " > Spell Info", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if SI.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return SI.config.db.profile.enabled
            end,
            set = function(_, val)
                SI.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.SpellInfo:OnInitialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 1}
    }
}

function SI:SetupConfig()
    SI.config = {}
    SI.config.db = {
        profile = Addon.config.db.profile.modules.spellInfo
    }
end