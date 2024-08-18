RegisterServerEvent('RNG:playTaserSound')
AddEventHandler('RNG:playTaserSound', function(coords, sound)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent('playTaserSoundClient', -1, coords, sound)
    end
end)

RegisterServerEvent('RNG:reactivatePed')
AddEventHandler('RNG:reactivatePed', function(id)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('RNG:receiveActivation', id)
      TriggerClientEvent('TriggerTazer', id)
    end
end)

RegisterServerEvent('RNG:arcTaser')
AddEventHandler('RNG:arcTaser', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') then
      RNGclient.getNearestPlayer(source, {3}, function(nplayer)
        local nuser_id = RNG.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('RNG:receiveBarbs', nplayer, source)
            TriggerClientEvent('TriggerTazer', id)
        end
      end)
    end
end)

RegisterServerEvent('RNG:barbsNoLongerServer')
AddEventHandler('RNG:barbsNoLongerServer', function(id)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('RNG:barbsNoLonger', id)
    end
end)

RegisterServerEvent('RNG:barbsRippedOutServer')
AddEventHandler('RNG:barbsRippedOutServer', function(id)
    local source = source
    local user_id = RNG.getUserId(source)
    TriggerClientEvent('RNG:barbsRippedOut', id)
end)

RegisterCommand('rt', function(source, args)
  local source = source
  local user_id = RNG.getUserId(source)
  if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('RNG:reloadTaser', source)
  end
end)