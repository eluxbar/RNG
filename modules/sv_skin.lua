RegisterNetEvent("RNG:saveFaceData")
AddEventHandler("RNG:saveFaceData", function(faceSaveData)
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.setUData(user_id,"RNG:Face:Data",json.encode(faceSaveData))
end)

RegisterNetEvent("RNG:saveClothingHairData") -- this updates hair from clothing stores
AddEventHandler("RNG:saveClothingHairData", function(hairtype, haircolour)
    local source = source
    local user_id = RNG.getUserId(source)
    local facesavedata = {}
    RNG.getUData(user_id, "RNG:Face:Data", function(data)
        if data ~= nil and data ~= 0 and hairtype ~= nil and haircolour ~= nil then
            facesavedata = json.decode(data)
            if facesavedata == nil then
                facesavedata = {}
            end
            facesavedata["hair"] = hairtype
            facesavedata["haircolor"] = haircolour
            RNG.setUData(user_id,"RNG:Face:Data",json.encode(facesavedata))
        end
    end)
end)

RegisterNetEvent("RNG:getPlayerHairstyle")
AddEventHandler("RNG:getPlayerHairstyle", function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.getUData(user_id,"RNG:Face:Data", function(data)
        if data ~= nil and data ~= 0 then
            TriggerClientEvent("RNG:setHairstyle", source, json.decode(data))
        end
    end)
end)

AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = RNG.getUserId(source)
        RNG.getUData(user_id,"RNG:Face:Data", function(data)
            if data ~= nil and data ~= 0 then
                TriggerClientEvent("RNG:setHairstyle", source, json.decode(data))
            end
        end)
    end)
end)