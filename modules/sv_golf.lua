RegisterServerEvent("RNG:takeGolfMoney", function()
    local source = source 
    local user_id = RNG.getUserId(source)
    local amount = 5000
    if user_id ~= nil then
        RNG.tryBankPayment(source, amount)
        TriggerClientEvent("RNG:startGolf", source)
    else
        RNGclient.notify(source, "~r~Not Enough Money To Play")
    end    
end)