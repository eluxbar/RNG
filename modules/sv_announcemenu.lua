local announceTables = {
    {permission = 'admin.managecommunitypot', info = {name = "Server Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/FZMys0F.png'},
    {permission = 'police.announce', info = {name = "PD Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/I7c5LsN.png'},
    {permission = 'nhs.announce', info = {name = "NHS Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/SypLbMo.png'},
    {permission = 'lfb.announce', info = {name = "LFB Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/AFqPgYk.png'},
    {permission = 'hmp.announce', info = {name = "HMP Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/rPF5FgQ.png'},
}

RegisterServerEvent("RNG:getAnnounceMenu")
AddEventHandler("RNG:getAnnounceMenu", function()
    local source = source
    local user_id = RNG.getUserId(source)
    local hasPermsFor = {}
    for k,v in pairs(announceTables) do
        if RNG.hasPermission(user_id, v.permission) or RNG.hasGroup(user_id, 'Founder') or RNG.hasGroup(user_id, 'Lead Developer') then
            table.insert(hasPermsFor, v.info)
        end
    end
    if #hasPermsFor > 0 then
        TriggerClientEvent("RNG:buildAnnounceMenu", source, hasPermsFor)
    end
end)

RegisterServerEvent("RNG:serviceAnnounce")
AddEventHandler("RNG:serviceAnnounce", function(announceType)
    local source = source
    local user_id = RNG.getUserId(source)
    for k,v in pairs(announceTables) do
        if v.info.name == announceType then
            if RNG.hasPermission(user_id, v.permission) or RNG.hasGroup(user_id, 'Founder') or RNG.hasGroup(user_id, 'Operations Manager') or RNG.hasGroup(user_id, 'Lead Developer') then
                if RNG.tryFullPayment(user_id, v.info.price) then
                    RNG.prompt(source,"Input text to announce","",function(source,data) 
                        TriggerClientEvent('RNG:serviceAnnounceCl', -1, v.image, data)
                        if v.info.price > 0 then
                            RNGclient.notify(source, {"~g~Purchased a "..v.info.name.." for £"..v.info.price.." with content ~b~"..data})
                            RNG.sendWebhook('announce', "RNG Announcement Logs", "```"..data.."```".."\n> Player Name: **"..RNG.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
                        else
                            RNGclient.notify(source, {"~g~Sending a "..v.info.name.." with content ~b~"..data})
                            RNG.sendWebhook('announce', "RNG Announcement Logs", "```"..data.."```".."\n> Player Name: **"..RNG.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
                        end
                    end)
                else
                    RNGclient.notify(source, {"~r~You do not have enough money to do this."})
                end
            else
                TriggerEvent("RNG:acBan", user_id, 11, RNG.getPlayerName(source), source, 'Attempted to Trigger an announcement')
            end
        end
    end
end)



RegisterCommand("consoleannounce", function(source, args)
    local source = source
    if source == 0 then
        local data = table.concat(args, " ")
        print("[RNG Announcement] "..data)
        TriggerClientEvent('RNG:serviceAnnounceCl', -1, 'https://i.imgur.com/FZMys0F.png', data)
        RNG.sendWebhook('announce', "RNG Announcement Logs", "```"..data.."```")
    else
        RNGclient.notify(source, {"~r~You do not have permission to do this."})
    end
end)