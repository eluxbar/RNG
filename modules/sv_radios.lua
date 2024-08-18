local cfg = module("cfg/cfg_radios")

local function getRadioType(user_id)
    if RNG.hasPermission(user_id, "police.armoury") then
        return "Police"
    elseif RNG.hasPermission(user_id, "nhs.menu") then
        return "NHS"
    elseif RNG.hasPermission(user_id, "hmp.menu") then
        return "HMP"
    end
    return false
end

local radioChannels = {
    ['Police'] = {
        name = 'Police',
        players = {},
        channel = 1,
        callsign = true,
    },
    ['NHS'] = {
        name = 'NHS',
        players = {},
        channel = 2,
    },
    ['HMP'] = {
        name = 'HMP',
        players = {},
        channel = 3,
    },
}

function createRadio(source)
    local source = source
    local user_id = RNG.getUserId(source)
    local radioType = getRadioType(user_id)
    
    if radioType then
        Wait(1000)
        for k,v in pairs(cfg.sortOrder[radioType]) do
            if RNG.hasPermission(user_id, v) then
                local sortOrder = k
                local name = RNG.getPlayerName(source)
                local callsign = getCallsign(radioType, source, user_id, radioType)
                if radioChannels[radioType].callsign then
                    if callsign then
                        name = name.." ["..callsign.."]"
                    end
                end
                radioChannels[radioType]['players'][source] = {name = name, sortOrder = sortOrder}
                TriggerClientEvent('RNG:radiosCreateChannel', source, radioChannels[radioType].channel, radioChannels[radioType].name, radioChannels[radioType].players, true)
                TriggerClientEvent('RNG:radiosAddPlayer', -1, radioChannels[radioType].channel, source, {name = name, sortOrder = sortOrder})
                TriggerEvent("RNG:ChatClockOn", source, radioType, true)
            end
        end
    else
        local gang = RNG.getGangName(user_id)
        if gang and gang ~= "" then
            if not radioChannels[gang] then
                radioChannels[gang] = {name = gang, players = {}, channel = math.random(5, 1000)}
            end
            
            local name = RNG.getPlayerName(source)
            radioChannels[gang]['players'][source] = {name = name, sortOrder = 1}
            TriggerClientEvent('RNG:radiosCreateChannel', source, radioChannels[gang].channel, radioChannels[gang].name, radioChannels[gang].players, true)
            TriggerClientEvent('RNG:radiosAddPlayer', -1, radioChannels[gang].channel, source, {name = name, sortOrder = 1})
        end
    end
end




function removeRadio(source)
    for a,b in pairs(radioChannels) do
        if next(radioChannels[a]['players']) then
            for k,v in pairs(radioChannels[a]['players']) do
                if k == source then
                    if a then
                        TriggerEvent("RNG:ChatClockOn", source, a, false)
                    end
                    TriggerClientEvent('RNG:radiosRemovePlayer', -1, radioChannels[a].channel, k)
                    radioChannels[a]['players'][source] = nil
                end
            end
        end
    end
end

RegisterServerEvent("RNG:clockedOnCreateRadio")
AddEventHandler("RNG:clockedOnCreateRadio", function(source)
    local source = source
    syncRadio(source)
end)

RegisterServerEvent("RNG:clockedOffRemoveRadio")
AddEventHandler("RNG:clockedOffRemoveRadio", function(source)
    local source = source
    syncRadio(source)
end)

AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    syncRadio(source)
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    removeRadio(source)
end)

RegisterCommand("reconnectradio", function(source, args, rawCommand) -- To Recoonect Source To Radio
    local source = source
    syncRadio(source)
end)

function syncRadio(source)
    removeRadio(source)
    TriggerClientEvent('RNG:radiosClearAll', source)
    Wait(500)
    createRadio(source)
end

RegisterServerEvent("RNG:radiosSetIsMuted")
AddEventHandler("RNG:radiosSetIsMuted", function(mutedState)
    local source = source
    local user_id = RNG.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        for k,v in pairs(radioChannels[radioType]['players']) do
            if k == source then
                TriggerClientEvent('RNG:radiosSetPlayerIsMuted', -1, radioChannels[radioType].channel, k, mutedState)
            end
        end
    else
        local gang = RNG.getGangName(user_id)
        if gang then
            for k,v in pairs(radioChannels[gang]['players']) do
                if k == source then
                    TriggerClientEvent('RNG:radiosSetPlayerIsMuted', -1, radioChannels[gang].channel, k, mutedState)
                end
            end
        end
    end
end)


AddEventHandler("RNG:ChatClockOn", function(source, mode, state)
    local policechat = {
        name = "Police",
        displayName = "Police",
        isChannel = "Police",
        color = {255, 0, 0},
        isGlobal = false,
    }
    local nhschat = {
        name = "NHS",
        displayName = "NHS",
        isChannel = "NHS",
        color = {255, 0, 0},
        isGlobal = false,
    }
    local hmpchat = {
        name = "HMP",
        displayName = "HMP",
        isChannel = "HMP",
        color = {255, 0, 0},
        isGlobal = false,
    }
    if state then
        if mode == "Police" then
            TriggerClientEvent('chat:addMode', source, policechat)
        elseif mode == "NHS" then
            TriggerClientEvent('chat:addMode', source, nhschat)
        elseif mode == "HMP" then
            TriggerClientEvent('chat:addMode', source, hmpchat)
        end
    else
        TriggerClientEvent('chat:removeMode', source, mode)
    end
end)
        