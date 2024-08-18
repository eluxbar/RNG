RegisterCommand("me", function(source, args)
    local text = table.concat(args, " ")
    TriggerClientEvent('RNG:sendLocalChat', -1, source, RNG.getPlayerName(source), text)
end)