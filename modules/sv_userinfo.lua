


AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        Citizen.Wait(2000)
        TriggerClientEvent("RNG:requestAccountInfo", source, false)
    end
end)


function RNG.SteamAccountInfo(steam,name, callback)
    -- local steam64 = tonumber(steam:gsub("steam:", ""), 16)
    local info = {}
    -- local url = "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=8D1DF36F763A41498AAEFB7E6F6E3C84&steamids=" .. steam64
    local headers = {["Content-Type"] = "application/json"}
    PerformHttpRequest(url, function(statusCode, text, headers)
        if statusCode == 200 and text then
            local data = json.decode(text)
            local players = data["response"]["players"]
            if players and #players > 0 then
                local player = players[1]
                -- info.steamid = player["steamid"]
                -- info.timecreated = math.floor((os.time() - player["timecreated"]) / 86400) -- for days
                local secondsInDay = 86400
                -- local epoch = os.time() - info.timecreated * secondsInDay
                local dateTable = os.date("*t", epoch)
                -- info.datamade = os.date("%d/%m/%Y", player["timecreated"])
                info.communityVisibility = player["communityvisibilitystate"] or "Not Available"
                info.profileVisibility = player['profilestate'] or "Not Available"
                info.realName = player["realname"] or player["personaname"] or name
                info.countryCode = player["loccountrycode"] or "N/A"
                info.avatarURL = player["avatarfull"]
                info.lastLogOff = player["lastlogoff"]
                -- info.accountAge = player["timecreated"] and math.floor((os.time() - player["timecreated"]) / 86400) or "Not Available"
                info.profileURL = "https://steamcommunity.com/profiles/" .. steam64
            end
        end
        callback(info)
    end, "GET", json.encode({}), headers)
end

RegisterServerEvent("RNG:receivedAccountInformation")
AddEventHandler("RNG:receivedAccountInformation", function(gpu, cpu, userAgent, devices)
    local source = source
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source)
    local ids = RNG.GetPlayerIdentifiers(source)
    -- local steamid = ids.steam
    -- local steam64 = tonumber(steamid:gsub("steam:", ""), 16)
    local formatteddevices = json.encode(devices)

    RNG.SteamAccountInfo(steamid, name, function(steaminfo)
        if steaminfo then
            Wait(1000)
            local function formatEntry(entry)
                return entry.kind .. ': ' .. entry.label .. ' id = ' .. entry.deviceId
            end
            local formatted_entries = {}
            for _, entry in ipairs(devices) do
                if entry.deviceId ~= "communications" then
                    table.insert(formatted_entries, formatEntry(entry))
                end
            end
            local newformat = table.concat(formatted_entries, '\n')
            newformat = newformat:gsub('audiooutput:', 'audiooutput: '):gsub('videoinput:', 'videoinput: ')
            formatteddevices = newformat
            local data = exports["rng"]:executeSync("SELECT * FROM rng_user_info WHERE user_id = @user_id", { user_id = user_id })
            if #data == 1 then
                exports['rng']:execute('UPDATE rng_user_info SET user_id = @user_id, gpu = @gpu, cpu_cores = @cpu_cores, user_agent = @user_agent, steam_id = @steam_id, steam_name = @steam_name, steam_country = @steam_country, steam_creation_date = @steam_creation_date, steam_age = @steam_age, devices = @devices WHERE user_id = @user_id', { user_id = user_id, gpu = gpu, cpu_cores = cpu, user_agent = userAgent, steam_id = steaminfo.steamid, steam_name = steaminfo.realName, steam_country = steaminfo.countryCode, steam_creation_date = steaminfo.datamade, devices = formatteddevices })
            else
                exports['rng']:execute('INSERT INTO rng_user_info (user_id, banned, gpu, cpu_cores, user_agent, steam_id, steam_name, steam_country, steam_creation_date, steam_age, devices) VALUES (@user_id, @banned, @gpu, @cpu_cores, @user_agent, @steam_id, @steam_name, @steam_country, @steam_creation_date, @steam_age, @devices)', { user_id = user_id, banned = false, gpu = gpu, cpu_cores = cpu, user_agent = userAgent, steam_id = steaminfo.steamid, steam_name = steaminfo.realName, steam_country = steaminfo.countryCode, steam_creation_date = steaminfo.datamade, devices = formatteddevices })
            end
            RNG.CheckDevices(user_id, formatteddevices, cpu, gpu, function(banned, userid)
                if banned and userid then
                    RNG.sendWebhook('ban-evaders', 'RNG Ban Evade Logs', "> Player Name: **" .. name .. "**\n> Player Current Perm ID: **" .. user_id .. "**\n> Player Banned PermID: **" .. userid .. "**")
                    RNG.banConsole(user_id, "perm", "1.14 Ban Evading.")
                end
            end)
        end
    end)
end)

function RNG.CheckDevices(user_id, devices, cpu, gpu, callback)
    if devices then
        local rows = exports["rng"]:executeSync("SELECT user_id, banned FROM rng_user_info WHERE devices = @devices AND cpu_cores = @cpu_cores AND gpu = @gpu", { devices = devices, cpu_cores = cpu, gpu = gpu })
        if #rows > 0 then
            for i, row in ipairs(rows) do
                if row.banned and row.user_id ~= user_id then
                    callback(row.banned, row.user_id)
                    return
                end
            end
        end
    end
    callback(false)
end


function RNG.BanUserInfo(user_id, banned) 
    if banned then 
        exports['rng']:execute('UPDATE rng_user_info SET banned = @banned WHERE user_id = @user_id', { banned = true, user_id = user_id })
    else
        exports['rng']:execute('UPDATE rng_user_info SET banned = @banned WHERE user_id = @user_id', { banned = false, user_id = user_id })
    end
end



Citizen.CreateThread(function()
    Wait(2500)
    exports['rng']:execute([[
    CREATE TABLE IF NOT EXISTS `rng_user_info` (
    user_id INT(11) NOT NULL,
    banned BOOLEAN,
    gpu VARCHAR(100),
    cpu_cores VARCHAR(100),
    user_agent VARCHAR(100),
    steam_id VARCHAR(100),
    steam_name VARCHAR(100),
    steam_country VARCHAR(100),
    steam_creation_date VARCHAR(100),
    steam_age INT(11),
    devices VARCHAR(100),
    PRIMARY KEY (user_id)
    );]])
end)