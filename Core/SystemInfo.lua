local addonName, ns = ...
local R = _G.ReduxUI
local SI = {
    updateInterval = 30,
    ipTypeHome = "IPv4",
    ipTypeWorld = "IPv4",
    cpuProfiling = 0,
    totalMemory = 0,
    totalCPU = 0,
    bandwidth = 0,
    homePing = 0,
    worldPing = 0,
    framerate = 0,
    memoryTable = {},
    cpuTable = {},
    lastUpdate = GetTime()
}
R.SystemInfo = SI

function SI:RebuildAddonList()
    local addOnCount = GetNumAddOns()
    if (addOnCount == #SI.memoryTable) then return end

    -- Number of loaded addons changed, create new memoryTable for all addons
    wipe(SI.memoryTable)
    wipe(SI.cpuTable)
    for i = 1, addOnCount do
        SI.memoryTable[i] = {i, select(2, GetAddOnInfo(i)), 0}
        SI.cpuTable[i] = {i, select(2, GetAddOnInfo(i)), 0}
    end
end

SI.SortByMemoryOrCPU = function(a, b)
    if a and b then return (a[3] == b[3] and a[2] < b[2]) or a[3] > b[3] end
end

function SI:UpdateMemory()
    -- Update the memory usages of the addons
    UpdateAddOnMemoryUsage()

    -- Load memory usage in table
    local totalMemory = 0
    for i = 1, #SI.memoryTable do
        SI.memoryTable[i][3] = GetAddOnMemoryUsage(SI.memoryTable[i][1])
        totalMemory = totalMemory + SI.memoryTable[i][3]
    end

    -- Sort the table to put the largest addon on top
    sort(SI.memoryTable, SI.SortByMemoryOrCPU)

    return totalMemory
end

function SI:UpdateCPU()
    -- Update the CPU usages of the addons
    UpdateAddOnCPUUsage()

    -- Load cpu usage in table
    local totalCPU = 0
    for i = 1, #SI.cpuTable do
        local addonCPU = GetAddOnCPUUsage(SI.cpuTable[i][1])
        SI.cpuTable[i][3] = addonCPU
        totalCPU = totalCPU + addonCPU
    end

    -- Sort the table to put the largest addon on top
    sort(SI.cpuTable, SI.SortByMemoryOrCPU)

    return totalCPU
end

function SI:Update(fullUpdate)
    local _, _, homePing, worldPing = GetNetStats()
    SI.homePing = homePing
    SI.worldPing = worldPing

    if not fullUpdate then return end

    SI.time = GetTime()
    SI.elapsed = SI.time - SI.lastUpdate
    SI.lastUpdate = SI.time

    SI:RebuildAddonList()

    local cpuProfiling = GetCVar("scriptProfile") == "1"
    local totalCPU = 0
    if cpuProfiling then totalCPU = SI:UpdateCPU() end
    local totalMemory = SI:UpdateMemory()
    local bandwidth = GetAvailableBandwidth()
    local framerate = floor(GetFramerate())
    local useIPv6 = GetCVarBool("useIPv6")
    if useIPv6 then
        local ipTypeHome, ipTypeWorld = GetNetIpTypes()
        SI.ipTypeHome = ipTypeHome
        SI.ipTypeWorld = ipTypeWorld
    else
        SI.ipTypeHome = "IPv4"
        SI.ipTypeWorld = "IPv4"
    end

    SI.cpuProfiling = cpuProfiling
    SI.totalMemory = totalMemory
    SI.totalCPU = totalCPU
    SI.cpuPerSecond = totalCPU / SI.elapsed
    SI.bandwidth = bandwidth
    SI.framerate = framerate
end

function SI:ToggleCPUProfiling()
    SI.cpuProfiling = not SI.cpuProfiling
    SetCVar("scriptProfile", SI.cpuProfiling)
end

function SI:CurrentCPUUsage(addon)
    for i = 1, #SI.cpuTable do
        local ele = SI.cpuTable[i]
        if ele and IsAddOnLoaded(ele[1]) then if ele[2] == addon then return ele[3] end end
    end
end

function SI:CurrentMemoryUsage(addon)
    for i = 1, #SI.memoryTable do
        local ele = SI.memoryTable[i]
        if ele and IsAddOnLoaded(ele[1]) then if ele[2] == addon then return ele[3] end end
    end
end

function SI:GetLatency()
    return SI.homePing > SI.worldPing and SI.homePing or SI.worldPing
end

function SI:FormatMemory(memory)
    local mult = 10 ^ 1
    if memory > 999 then
        local mem = ((memory / 1024) * mult) / mult
        return format("%.2f mb", mem)
    else
        local mem = (memory * mult) / mult
        return format("%d kb", mem)
    end
end
