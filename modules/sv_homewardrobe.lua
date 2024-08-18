local outfitCodes = {}

RegisterNetEvent("RNG:saveWardrobeOutfit")
AddEventHandler("RNG:saveWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.getUData(user_id, "RNG:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        RNGclient.getCustomization(source,{},function(custom)
            sets[outfitName] = custom
            RNG.setUData(user_id,"RNG:home:wardrobe",json.encode(sets))
            RNGclient.notify(source,{"~g~Saved outfit "..outfitName.." to wardrobe!"})
            TriggerClientEvent("RNG:refreshOutfitMenu", source, sets)
        end)
    end)
end)

RegisterNetEvent("RNG:deleteWardrobeOutfit")
AddEventHandler("RNG:deleteWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.getUData(user_id, "RNG:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        sets[outfitName] = nil
        RNG.setUData(user_id,"RNG:home:wardrobe",json.encode(sets))
        RNGclient.notify(source,{"Remove outfit "..outfitName.." from wardrobe!"})
        TriggerClientEvent("RNG:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("RNG:equipWardrobeOutfit")
AddEventHandler("RNG:equipWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.getUData(user_id, "RNG:home:wardrobe", function(data)
        local sets = json.decode(data)
        RNGclient.setCustomization(source, {sets[outfitName]})
        RNGclient.getHairAndTats(source, {})
    end)
end)

RegisterNetEvent("RNG:initWardrobe")
AddEventHandler("RNG:initWardrobe", function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNG.getUData(user_id, "RNG:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        TriggerClientEvent("RNG:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("RNG:getCurrentOutfitCode")
AddEventHandler("RNG:getCurrentOutfitCode", function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNGclient.getCustomization(source,{},function(custom)
        RNGclient.generateUUID(source, {"outfitcode", 5, "alphanumeric"}, function(uuid)
            local uuid = string.upper(uuid)
            outfitCodes[uuid] = custom
            RNGclient.CopyToClipBoard(source, {uuid})
            RNGclient.notify(source, {"~g~Outfit code copied to clipboard."})
            RNGclient.notify(source, {"The code ~y~"..uuid.."~w~ will persist until restart."})
        end)
    end)
end)

RegisterNetEvent("RNG:applyOutfitCode")
AddEventHandler("RNG:applyOutfitCode", function(outfitCode)
    local source = source
    local user_id = RNG.getUserId(source)
    if outfitCodes[outfitCode] ~= nil then
        RNGclient.setCustomization(source, {outfitCodes[outfitCode]})
        RNGclient.notify(source, {"~g~Outfit code applied."})
        RNGclient.getHairAndTats(source, {})
    else
        RNGclient.notify(source, {"Outfit code not found."})
    end
end)

RegisterCommand('wardrobe', function(source)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'Founder') or RNG.hasGroup(user_id, 'Developer') or RNG.hasGroup(user_id, 'Lead Developer') then
        TriggerClientEvent("RNG:openOutfitMenu", source)
    end
end)

RegisterCommand('copyfit', function(source, args)
    local source = source
    local user_id = RNG.getUserId(source)
    local permid = tonumber(args[1])
    if RNG.hasGroup(user_id, 'Founder') or RNG.hasGroup(user_id, 'Developer') or RNG.hasGroup(user_id, 'Lead Developer') then
        RNGclient.getCustomization(RNG.getUserSource(permid),{},function(custom)
            RNGclient.setCustomization(source, {custom})
        end)
    end
end)

RegisterServerEvent("RNG:copyOutfit")
AddEventHandler("RNG:copyOutfit", function(permid)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'Founder') or RNG.hasGroup(user_id, 'Developer') or RNG.hasGroup(user_id, 'Lead Developer') then
        RNGclient.getCustomization(RNG.getUserSource(permid), {}, function(custom)
            RNGclient.setCustomization(source, {custom})
            RNGclient.notify(source, {"~g~Succesfully Copied PermID "..permid.." Outfit"})
        end)
    end
end)
