local a = false
SetNuiFocus(false, false)
function func_playerlistControl()
    if IsUsingKeyboard(2) then
        if IsControlJustPressed(0, 212) then
            a = not a
            TriggerServerEvent("RNG:getPlayerListData")
            Wait(100)
            sendFullPlayerListData()
            SetNuiFocus(true, true)
            TriggerScreenblurFadeIn(100.0)
            SendNUIMessage({showPlayerList = true})
        end
    end
end
tRNG.createThreadOnTick(func_playerlistControl)
RegisterNUICallback(
    "closeRNGPlayerList",
    function(b, c)
        TriggerScreenblurFadeOut(100.0)
        SetNuiFocus(false, false)
    end
)
AddEventHandler(
    "RNG:onClientSpawn",
    function(d, e)
        if e then
            TriggerServerEvent("RNG:getPlayerListData")
        end
    end
)
RegisterNetEvent(
    "RNG:gotFullPlayerListData",
    function(f, g, h, i, j, k)
        sortedPlayersStaff = f
        sortedPlayersPolice = g
        sortedPlayersNHS = h
        sortedPlayersLFB = i
        sortedPlayersHMP = j
        sortedPlayersCivillians = k
    end
)
local l, m, n
RegisterNetEvent(
    "RNG:playerListMetaUpdate",
    function(o)
        l, m, n = table.unpack(o)
        SendNUIMessage({wipeFooterPlayerList = true})
        SendNUIMessage({appendToFooterPlayerList = '<span class="foot">Server #1 | </span>'})
        SendNUIMessage(
            {
                appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..
                    tostring(l) .. "</span>"
            }
        )
        SendNUIMessage(
            {
                appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..
                    tostring(m) .. "/" .. tostring(n) .. "</span>"
            }
        )
    end
)
function getLength(p)
    local q = 0
    for r in pairs(p) do
        q = q + 1
    end
    return q
end

function tRNG.getEmploymentStatus()
    local playerId = tRNG.getUserId()
    local ranks = {
        Police = sortedPlayersPolice[playerId] and sortedPlayersPolice[playerId].rank or "Unemployed",
        NHS = sortedPlayersNHS[playerId] and sortedPlayersNHS[playerId].rank or "Unemployed",
        LFB = sortedPlayersLFB[playerId] and sortedPlayersLFB[playerId].rank or "Unemployed",
        HMP = sortedPlayersHMP[playerId] and sortedPlayersHMP[playerId].rank or "Unemployed",
        -- AA = sortedPlayersAA[playerId] and sortedPlayersAA[playerId].rank or "Unemployed",
        -- UKBF = sortedPlayersUKBF[playerId] and sortedPlayersUKBF[playerId].rank or "Unemployed",
        Civillians = sortedPlayersCivillians[playerId] and sortedPlayersCivillians[playerId].rank or "Unemployed"
    }

    for _, rank in pairs(ranks) do
        if rank ~= "Unemployed" then
            return rank
        end
    end

    return "Unemployed"
end

function sendFullPlayerListData()
    local s = getLength(sortedPlayersStaff)
    local t = getLength(sortedPlayersPolice)
    local u = getLength(sortedPlayersNHS)
    local v = getLength(sortedPlayersLFB)
    local w = getLength(sortedPlayersHMP)
    local x = getLength(sortedPlayersCivillians)
    SendNUIMessage({wipePlayerList = true})
    SendNUIMessage({clearServerMetaData = true})
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/rng.png" align="top" width="20px",height="20px"><span class="staff">' ..
                tostring(s) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/nhs.png" align="top" width="20",height="20"><span class="nhs">' ..
                tostring(u) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/lfb.png" align="top" width="20",height="20"><span class="lfb">' ..
                tostring(v) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/met.png" align="top"  width="24",height="24"><span class="police">' ..
                tostring(t) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/hmp.png" align="top"  width="24",height="24"><span class="hmp">' ..
                tostring(w) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/danny.png" align="top" width="20",height="20"><span class="aa">' ..
                tostring(x) .. "</span>"
        }
    )
    SendNUIMessage({wipeFooterPlayerList = true})
    SendNUIMessage({appendToFooterPlayerList = '<span class="foot">Server #1 | </span>'})
    SendNUIMessage(
        {
            appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..
                tostring(l) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..
                tostring(m) .. "/" .. tostring(n) .. "</span>"
        }
    )
    if s >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_staff">Staff</span>'})
    end
    for y, z in pairs(sortedPlayersStaff) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersStaff[y].name) .. '(' ..
                        tostring(sortedPlayersStaff[y].user_id) .. ')' ..
                            '</span><span class="job">' ..
                                tostring(sortedPlayersStaff[y].rank) ..
                                    '</span><span class="playtime">' ..
                                        tostring(sortedPlayersStaff[y].hours) .. "hrs</span><br/>"
            }
        )
    end    
    if t >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_police">MET Police</span>'})
    end
    for y, z in pairs(sortedPlayersPolice) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersPolice[y].name) .. '(' ..
                    tostring(sortedPlayersPolice[y].user_id) .. ')' ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersPolice[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersPolice[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if u >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_nhs">NHS</span>'})
    end
    for y, z in pairs(sortedPlayersNHS) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' .. 
                    tostring(sortedPlayersNHS[y].name) .. ')' ..
                    tostring(sortedPlayersNHS[y].user_id) .. ')' ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersNHS[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersNHS[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if v >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_lfb">LFB</span>'})
    end
    for y, z in pairs(sortedPlayersLFB) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersLFB[y].name) .. ')' ..
                    tostring(sortedPlayersLFB[y].user_id) .. ')' ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersLFB[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersLFB[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if w >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_hmp">HMP</span>'})
    end
    for y, z in pairs(sortedPlayersHMP) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersHMP[y].name) .. ')' ..
                    tostring(sortedPlayersHMP[y].user_id) .. ')' ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersHMP[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersHMP[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if x >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_civs">Civilians</span>'})
    end
    for y, z in pairs(sortedPlayersCivillians) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersCivillians[y].name) .. '(' ..
                    tostring(sortedPlayersCivillians[y].user_id) .. ')' ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersCivillians[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersCivillians[y].hours) .. "hrs</span><br/>"
            }
        )
    end
end

local userplaytime = 0

RegisterNetEvent('RNG:getUsertimeforpausemenu', function(time)
    userplaytime = tRNG.getUserPlaytime(time)
end)

function tRNG.getUserPlaytime(time)
    local asdasduserplaytime = time / 60
    local formattedtime = string.format("%.2f", asdasduserplaytime)
    return formattedtime
end

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        if tRNG.getUserId() then
            local userId = tRNG.getUserId()
            local jobDisplayName = ""
            local playerHours = 0
            local isStaff = false
            local staffRank = ""
            for _, staff in ipairs(sortedPlayersStaff) do
                if staff.user_id == userId then
                    isStaff = true
                    staffRank = staff.rank
                    break
                end
            end
            for _, player in ipairs(sortedPlayersCivillians) do
                if player.user_id == userId then
                    playerHours = player.hours
                    break
                end
            end
            if isStaff then
                jobDisplayName = staffRank
            end
            SetDiscordAppId(1122650466556313711)
            SetDiscordRichPresenceAsset("rng")
            SetDiscordRichPresenceAction(1, "Join RNG", "fivem://connect/s1.rngstudios.uk")
            SetDiscordRichPresenceAssetSmall(tRNG.getUserProfilePFP())
            SetDiscordRichPresenceAssetSmallText(tRNG.getPlayerName(PlayerId()))
            SetDiscordRichPresenceAssetText("discord.gg/rnguk")
            SetRichPresence("[ID: " .. tostring(userId) .. "] | " .. #GetPlayers() .. "/" .. GetConvar("sv_maxclients", "64") .. " | (" .. playerHours .. " Hours)\n" .. tRNG.getPlayerName(PlayerId()) .. " - " .. tostring(jobDisplayName))
        end
        Wait(15000)
    end
end)