RegisterCommand("a", function(source,args, rawCommand)
    if #args <= 0 then return end
	local name = RNG.getPlayerName(source)
    local message = table.concat(args, " ")
    local user_id = RNG.getUserId(source)

    if RNG.hasPermission(user_id, "admin.tickets") then
        RNG.sendWebhook('staff', "RNG Chat Logs", "```"..message.."```".."\n> Admin Name: **"..name.."**\n> Admin PermID: **"..user_id.."**\n> Admin TempID: **"..source.."**")
        for k, v in pairs(RNG.getUsers({})) do
            if RNG.hasPermission(k, 'admin.tickets') then
                TriggerClientEvent('chatMessage', v, "^3Admin Chat | " .. name..": " , { 128, 128, 128 }, message, "ooc")
            end
        end
    end
end)
RegisterServerEvent("RNG:PoliceChat", function(source, args, rawCommand)
    if #args <= 0 then return end
    local source = source
    local user_id = RNG.getUserId(source)   
    local message = args
    if RNG.hasPermission(user_id, "police.armoury") then
        local callsign = ""
        if getCallsign('Police', source, user_id, 'Police') then
            callsign = "["..getCallsign('Police', source, user_id, 'Police').."]"
        end
        local playerName =  "^4Police Chat | "..callsign.." "..RNG.getPlayerName(source)..": "
        for k, v in pairs(RNG.getUsers({})) do
            if RNG.hasPermission(k, 'police.armoury') then
                TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, message, "ooc", "Police")
            end
        end
    end
end)

RegisterCommand("p", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("RNG:PoliceChat", source, message)
end)
RegisterServerEvent("RNG:Nchat", function(source, args, rawCommand)
    if #args <= 0 then return end
    local source = source
    local user_id = RNG.getUserId(source)   
    local message = args
    if RNG.hasPermission(user_id, "nhs.menu") then
        local playerName =  "^2NHS Chat | "..RNG.getPlayerName(source)..": "
        for k, v in pairs(RNG.getUsers({})) do
            if RNG.hasPermission(k, 'nhs.menu') then
                TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, message, "ooc", "NHS")
            end
        end
    end
end)
RegisterCommand("n", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("RNG:Nchat", source, message)
end)

RegisterCommand("g", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("RNG:GangChat", source, message)
end)
RegisterServerEvent("RNG:GangChat", function(source, message)
    local source = source
    local user_id = RNG.getUserId(source)   
    local msg = message
    if RNG.hasGroup(user_id,"Gang") then
        local gang = exports['rng']:executeSync('SELECT gangname FROM rng_user_gangs WHERE user_id = @user_id', {user_id = user_id})[1].gangname
        if gang then
            exports["rng"]:execute("SELECT * FROM rng_user_gangs WHERE gangname = @gangname", {gangname = gang},function(ganginfo)
                for A,B in pairs(ganginfo) do
                    local playersource = RNG.getUserSource(B.user_id)
                    if playersource then
                        TriggerClientEvent('chatMessage',playersource,"^2[Gang Chat] " .. RNG.getPlayerName(source)..": ",{ 128, 128, 128 },msg,"ooc", "Gang")
                    end
                end
                RNG.sendWebhook('gang', "RNG Chat Logs", "```"..msg.."```".."\n> Player Name: **"..RNG.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
            end)
        end
    end
end)

