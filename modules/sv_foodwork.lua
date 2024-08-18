local a = {
    ["burger"] = {
        [1] = 'bun',
        [2] = 'lettuce',
        [3] = 'tomato',
        [4] = 'onion',
        [5] = 'cheese',
        [6] = 'beef_patty',
        [7] = 'bbq',
    }
}

local cookingStages = {}
RegisterNetEvent('RNG:requestStartCooking')
AddEventHandler('RNG:requestStartCooking', function(recipe)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'Burger Shot Cook') then
        for k,v in pairs(a) do
            if k == recipe then
                cookingStages[user_id] = 1
                TriggerClientEvent('RNG:beginCooking', source, recipe)
                TriggerClientEvent('RNG:cookingInstruction', source, v[cookingStages[user_id]])
            end
        end
    else
        RNGclient.notify(source, {"You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)

RegisterNetEvent('RNG:pickupCookingIngredient')
AddEventHandler('RNG:pickupCookingIngredient', function(recipe, ingredient)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'Burger Shot Cook') then
        if ingredient == 'bbq' and cookingStages[user_id] == 7 then
            cookingStages[user_id] = nil
            TriggerClientEvent('RNG:finishedCooking', source)
            RNG.giveBankMoney(user_id, grindBoost*4000)
            TriggerClientEvent("RNG:phoneNotification", source, "You received £"..getMoneyStringFormatted(grindBoost*4000), "Food Work")
        else
            for k,v in pairs(a) do
                if k == recipe then
                    cookingStages[user_id] = cookingStages[user_id] + 1
                    TriggerClientEvent('RNG:cookingInstruction', source, v[cookingStages[user_id]])
                end
            end
        end
    else
        RNGclient.notify(source, {"You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)