voteCooldown = 1800
currentWeather = "CLEAR"

weatherVoterCooldown = voteCooldown

RegisterServerEvent("RNG:vote") 
AddEventHandler("RNG:vote", function(weatherType)
    TriggerClientEvent("RNG:voteStateChange",-1,weatherType)
end)

RegisterServerEvent("RNG:tryStartWeatherVote")
AddEventHandler("RNG:tryStartWeatherVote", function()
    local source = source
    local user_id = RNG.getUserId(source)
    
    if weatherVoterCooldown >= voteCooldown then
        TriggerClientEvent("RNG:startWeatherVote", -1)
        weatherVoterCooldown = 0
    else
        TriggerClientEvent("chatMessage", source, "Another vote can be started in " .. tostring(voteCooldown - weatherVoterCooldown) .. " seconds!", {255, 0, 0})
    end

    if RNG.hasPermission(source) then
        RNGclient.notify(source, {'~r~You do not have permission for this.'})
    end
end)


RegisterServerEvent("RNG:getCurrentWeather") 
AddEventHandler("RNG:getCurrentWeather", function()
    local source = source
    TriggerClientEvent("RNG:voteFinished",source,currentWeather)
end)

RegisterServerEvent("RNG:setCurrentWeather")
AddEventHandler("RNG:setCurrentWeather", function(newWeather)
	currentWeather = newWeather
end)

Citizen.CreateThread(function()
	while true do
		weatherVoterCooldown = weatherVoterCooldown + 1
		Citizen.Wait(1000)
	end
end)