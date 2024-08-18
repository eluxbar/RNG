RegisterServerEvent('RNG:saveTattoos')
AddEventHandler('RNG:saveTattoos', function(tattooData, price)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.tryFullPayment(user_id, price) then
        RNG.setUData(user_id, "RNG:Tattoo:Data", json.encode(tattooData))
    end
end)

RegisterServerEvent('RNG:getPlayerTattoos')
AddEventHandler('RNG:getPlayerTattoos', function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.getUData(user_id, "RNG:Tattoo:Data", function(data)
        if data ~= nil then
            TriggerClientEvent('RNG:setTattoos', source, json.decode(data))
        end
    end)
end)
