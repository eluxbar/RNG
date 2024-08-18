local verifyCodes = {}

-- Cleanup old verifyCodes every 5 minutes
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) -- 5 minutes
        local currentTime = os.time()
        for k, v in pairs(verifyCodes) do
            if currentTime - v.timestamp > 300 then -- 5 minutes
                verifyCodes[k] = nil
            end
        end
    end
end)

RegisterServerEvent('RNG:changeLinkedDiscord')
AddEventHandler('RNG:changeLinkedDiscord', function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.prompt(source, "Enter Discord Id:", "", function(source, discordid)
        if discordid and discordid ~= "" then
            TriggerClientEvent('RNG:gotDiscord', source)
            generateUUID("linkcode", 5, "alphanumeric", function(code)
                verifyCodes[user_id] = { code = code, discordid = discordid, timestamp = os.time() }
                exports['rng']:dmUser(source, { discordid, code, user_id }, function() end)
            end)
        else
            RNGclient.notify(source, { '~r~Invalid Discord ID.' })
        end
    end)
end)

RegisterServerEvent('RNG:enterDiscordCode')
AddEventHandler('RNG:enterDiscordCode', function()
    local source = source
    local user_id = RNG.getUserId(source)
    local currentTimestamp = os.time()
    local verification = verifyCodes[user_id]

    if verification and (currentTimestamp - verification.timestamp <= 300) then
        RNG.prompt(source, "Enter Code:", "", function(source, code)
            if code and code ~= "" then
                if verification.code == code then
                    exports['rng']:execute("UPDATE `rng_verification` SET discord_id = @discord_id WHERE user_id = @user_id", 
                    { user_id = user_id, discord_id = verification.discordid }, function() end)
                    RNGclient.notify(source, { '~g~Your discord has been successfully updated.' })
                    verifyCodes[user_id] = nil -- Clean up after successful verification
                else
                    RNGclient.notify(source, { '~r~Invalid code.' })
                end
            else
                RNGclient.notify(source, { '~r~You need to enter a code!' })
            end
        end)
    else
        RNGclient.notify(source, { '~r~Your code has expired.' })
    end
end)
