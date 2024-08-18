local a = 0
local b = 0
local c = 0
local d = 3
proximityIdToString = {[1] = "Whisper", [2] = "Talking", [3] = "Shouting"}
local e, f = GetActiveScreenResolution()
local g = {}
local h = GetResourceKvpString("rng_custom_pfp") or ""
g["Custom"] = h
RegisterNetEvent("RNG:showHUD")
AddEventHandler(
    "RNG:showHUD",
    function(i)
        showhudUI(i)
    end
)
AddEventHandler(
    "pma-voice:setTalkingMode",
    function(j)
        d = j
        local k = tRNG.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, k.rightX * k.resX)
    end
)
function updateMoneyUI(l, m, n, o, k, p)
    SendNUIMessage(
        {
            updateMoney = true,
            cash = l,
            bank = m,
            redmoney = n,
            proximity = proximityIdToString[o],
            topLeftAnchor = k,
            yAnchor = p
        }
    )
end
function showhudUI(i)
    SendNUIMessage({showMoney = i})
end
RegisterNetEvent("RNG:setProfilePictures")
AddEventHandler(
    "RNG:setProfilePictures",
    function(q)
        g = q
    end
)
RegisterNetEvent("RNG:setDisplayMoney")
RegisterNetEvent(
    "RNG:setDisplayMoney",
    function(r)
        local s = tostring(math.floor(r))
        a = getMoneyStringFormatted(s)
        local k = tRNG.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, k.rightX * k.resX)
    end
)
RegisterNetEvent("RNG:setDisplayBankMoney")
AddEventHandler(
    "RNG:setDisplayBankMoney",
    function(r)
        local s = tostring(math.floor(r))
        b = getMoneyStringFormatted(s)
        local k = tRNG.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, k.rightX * k.resX)
    end
)
RegisterNetEvent("RNG:setDisplayRedMoney")
AddEventHandler(
    "RNG:setDisplayRedMoney",
    function(r)
        local s = tostring(math.floor(r))
        c = getMoneyStringFormatted(s)
        local k = tRNG.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, k.rightX * k.resX)
    end
)
RegisterNetEvent("RNG:initMoney")
AddEventHandler(
    "RNG:initMoney",
    function(l, m)
        local t = tostring(math.floor(l))
        a = getMoneyStringFormatted(t)
        local s = tostring(math.floor(m))
        b = getMoneyStringFormatted(s)
        local k = tRNG.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, k.rightX * k.resX)
        TriggerServerEvent("RNG:RequestUserID")
        TriggerServerEvent("RNG:RequestUserHours")
    end
)
Citizen.CreateThread(
    function()
        Wait(4000)
        while tRNG.getUserId() == nil do
            Wait(100)
        end
        TriggerServerEvent("RNG:requestPlayerBankBalance")
        local u = false
        while true do
            Citizen.Wait(100)
            local v, w = GetActiveScreenResolution()
            if v ~= e or w ~= f then
                e, f = GetActiveScreenResolution()
                cachedMinimapAnchor = GetMinimapAnchor()
                updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, cachedMinimapAnchor.rightX * cachedMinimapAnchor.resX)
            end
            if NetworkIsPlayerTalking(PlayerId()) then
                if not u then
                    u = true
                    SendNUIMessage({moneyTalking = true})
                end
            else
                if u then
                    u = false
                    SendNUIMessage({moneyTalking = false})
                end
            end
            Wait(0)
        end
    end
)
RegisterNUICallback(
    "moneyUILoaded",
    function(x, y)
        local k = tRNG.getCachedMinimapAnchor()
        updateMoneyUI("£" .. tostring(a), "£" .. tostring(b), "£" .. tostring(c), d, k.rightX * k.resX)
        TriggerServerEvent("RNG:RequestUserID")
        TriggerServerEvent("RNG:RequestUserHours")
    end
)

RegisterNetEvent('RNG:receiveUserId')
AddEventHandler('RNG:receiveUserId', function(user_id)
    SendNUIMessage({
        type = "displayUserId",
        user_id = user_id
    })
end)
RegisterNetEvent('RNG:receiveUserHours')
AddEventHandler('RNG:receiveUserHours', function(hours)
    SendNUIMessage({
        type = "displayUserHours",
        hours = hours
    })
end)
function tRNG.updatePFPType(z)
    -- if z == "Custom" then
    --     SendNUIMessage({setPFP = GetResourceKvpString("rng_custom_pfp")})
    -- else
    SendNUIMessage({setPFP = g[z]})
end
function tRNG.updatePFPSize(A)
    SendNUIMessage({setPFPSize = A})
end
function tRNG.getUserProfilePFP()
    if g["Discord"] ~= nil then
        return g["Discord"]
    else
        return "rng"
    end
end