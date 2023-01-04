local lib = LibStub:NewLibrary("LibSpellCache-1.0", 1)

-- already loaded
if not lib then
    return
end

local spellCache
local knownSpellCache

local function BuildCache(knownOnly, update)
    if ((knownOnly and knownSpellCache) or (not knownOnly and cache)) and not update then
        return
    end

    local cache = {}
    for id = 1, 99999 do
        local name = (not knownOnly or IsSpellKnown(id)) and select(1, GetSpellInfo(id))

        if name and name ~= "" then
            cache[name] = cache[name] or {}
            table.insert(cache[name], id)
        end
    end

    if knownOnly then
        knownSpellCache = cache
    else
        spellCache = cache
    end
end

-- This function computes the Levenshtein distance between two strings
-- It is used in this program to match spell icon textures with "good" spell names; i.e.,
-- spell names that are very similar to the name of the texture
local function Lev(str1, str2)
    local matrix = {};
    for i = 0, str1:len() do
        matrix[i] = {[0] = i};
    end
    for j = 0, str2:len() do
        matrix[0][j] = j;
    end
    for j = 1, str2:len() do
        for i = 1, str1:len() do
            if (str1:sub(i, i) == str2:sub(j, j)) then
                matrix[i][j] = matrix[i - 1][j - 1];
            else
                matrix[i][j] = math.min(matrix[i - 1][j], matrix[i][j - 1], matrix[i - 1][j - 1]) + 1;
            end
        end
    end

    return matrix[str1:len()][str2:len()];
end

local function BestKeyMatch(nearkey, knownOnly)
    local cache = knownOnly and knownSpellCache or SpellCache

    local bestKey = ""
    local bestDistance = math.huge
    local partialMatches = {}
    if cache[nearkey] then
        return nearkey
    end

    for key, value in pairs(cache) do
        if key:lower() == nearkey:lower() then
            return key
        end
        if key:lower():find(nearkey:lower(), 1, true) then
            partialMatches[key] = value
        end
    end
    for key, value in pairs(partialMatches) do
        local distance = Lev(nearkey, key)
        if (distance < bestDistance) then
            bestKey = key
            bestDistance = distance
        end
    end

    return bestKey
end

local function SafeToNumber(input)
    local number = tonumber(input)
    return number and (number < 2147483648 and number > -2147483649) and number or nil
end

function lib:GetSpells(name, update)
    local spellId = SafeToNumber(name)
    if spellId and GetSpellInfo(spellId) then
        return { spellId }
    end

    if not spellCache or update then
        BuildCache(false, update)
    end

    return spellCache[name] or {}
end

function lib:GetKnownSpells(name, update)
    local spellId = SafeToNumber(name)
    if spellId and GetSpellInfo(spellId) and IsSpellKnown(spellId) then
        return { spellId }
    end

    if not knownSpellCache or update then
        BuildCache(true, update)
    end

    return knownSpellCache[name] or {}
end

function lib:MatchSpellName(input, knownOnly)
    if (knownOnly and not knownSpellCache) or (not knownOnly and not spellCache) then
        BuildCache(knownOnly)
    end

    local cache = knownOnly and knownSpellCache or spellCache

    local spellId = SafeToNumber(input)
    if spellId then
        local name = GetSpellInfo(spellId)
        if name then
            return name, spellId
        end
    else
        local ret = BestKeyMatch(input, knownOnly)
        if ret then
            return ret, nil
        end
    end
end