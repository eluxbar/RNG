RegisterCommand('cinematicmenu', function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'Cinematic') then
        TriggerClientEvent('RNG:openCinematicMenu', source)
    end
end)