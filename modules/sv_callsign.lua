function getCallsign(guildType, source, user_id, type)
    local discord_id = exports['rng']:Get_Client_Discord_ID(source)
    if discord_id then
        local guilds_info = exports['rng']:Get_Guilds()
        for guild_name, guild_id in pairs(guilds_info) do
            if guild_name == guildType then
                local nick_name = exports['rng']:Get_Guild_Nickname(guild_id, discord_id)
                if nick_name then
                    local open_bracket = string.find(nick_name, '[', nil, true)
                    local closed_bracket = string.find(nick_name, ']', nil, true)
                    if open_bracket and closed_bracket then
                        local callsign_value = string.sub(nick_name, open_bracket + 1, closed_bracket - 1)
                        return callsign_value, string.gsub(getGroupInGroups(user_id, type), ' Clocked', ''), RNG.getPlayerName(source)
                    else
                        return 'N/A', string.gsub(getGroupInGroups(user_id, type), ' Clocked', ''), RNG.getPlayerName(source)
                    end
                end
            end
        end
    end
end

RegisterServerEvent("RNG:getCallsign")
AddEventHandler("RNG:getCallsign", function(type)
    local source = source
    local user_id = RNG.getUserId(source)
    Wait(1000)
    if type == 'police' and RNG.hasPermission(user_id, 'police.armoury') then
        if getCallsign('Police', source, user_id, 'Police') then
            TriggerClientEvent("RNG:receivePoliceCallsign", source, getCallsign('Police', source, user_id, 'Police'))
        end
        TriggerClientEvent("RNG:setPoliceOnDuty", source, true)
    elseif type == 'prison' and RNG.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent("RNG:receiveHmpCallsign", source, getCallsign('HMP', source, user_id, 'HMP'))
        TriggerClientEvent("RNG:setPrisonGuardOnDuty", source, true)
    end
end)
