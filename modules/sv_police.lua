
-- this module define some police tools and functions
local lang = RNG.lang
local a = module("rng-weapons", "cfg/weapons")

local isStoring = {}
local choice_store_weapons = function(player, choice)
    local user_id = RNG.getUserId(player)
    local data = RNG.getUserDataTable(user_id)
    RNGclient.getWeapons(player,{},function(weapons)
      if not isStoring[player] then
        RNG.getSubscriptions(user_id, function(cb, plushours, plathours)
          if cb then
            local maxWeight = 30
            if user_id == -1 then
              maxWeight = 1000
            elseif plathours > 0 then
              maxWeight = 50
            elseif plushours > 0 then
              maxWeight = 40
            end
            if RNG.getInventoryWeight(user_id) <= maxWeight then
              isStoring[player] = true
              RNGclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                  if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                    RNG.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                      for i,c in pairs(a.weapons) do
                        if i == k and c.class ~= 'Melee' then
                          if v.ammo > 250 then
                            v.ammo = 250
                          end
                          RNG.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                        end   
                      end
                    end
                  end
                end
                RNGclient.notify(player,{"~g~Weapons Stored"})
                TriggerEvent('RNG:RefreshInventory', player)
                RNGclient.ClearWeapons(player,{})
                data.weapons = {}
                SetTimeout(3000,function()
                    isStoring[player] = nil 
                end)
              end)
            else
              RNGclient.notify(player,{'~r~You do not have enough Weight to store Weapons.'})
            end
          end
        end)
      end 
    end)
end

local cooldowns = {}

RegisterServerEvent("RNG:forceStoreSingleWeapon")
AddEventHandler("RNG:forceStoreSingleWeapon", function(model)
    local source = source
    local user_id = RNG.getUserId(source)
    local currentTime = os.time()
    
    if cooldowns[source] and currentTime - cooldowns[source] < 3 then
        RNGclient.notify(source, {"~r~Store weapon cooldown. Please wait"})
    else
        cooldowns[source] = currentTime

        if model ~= nil then
            RNGclient.getWeapons(source, {}, function(weapons)
                for k, v in pairs(weapons) do
                    if k == model then
                        local new_weight = RNG.getInventoryWeight(user_id) + RNG.getItemWeight(model)
                        if new_weight <= RNG.getInventoryMaxWeight(user_id) then
                            RemoveWeaponFromPed(GetPlayerPed(source), k)
                            RNGclient.removeWeapon(source, {k})
                            RNG.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                            if v.ammo > 0 then
                                for i, c in pairs(a.weapons) do
                                    if i == model and c.class ~= 'Melee' then
                                        RNG.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

RegisterCommand('storeallweapons', function(source)
    local source = source
    local currentTime = os.time()

    if cooldowns[source] and currentTime - cooldowns[source] < 3 then
        RNGclient.notify(source, {"~r~Store weapon cooldown. Please wait"})
    else
        choice_store_weapons(source)
        cooldowns[source] = currentTime
    end
end)

RegisterCommand('shield', function(source, args)
  local source = source
  local user_id = RNG.getUserId(source)
  if RNG.hasPermission(user_id, 'police.armoury') then
    TriggerClientEvent('RNG:toggleShieldMenu', source)
  end
end)

RegisterCommand('cuff', function(source, args)
  local source = source
  local user_id = RNG.getUserId(source)
  RNGclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      RNGclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and RNG.hasPermission(user_id, 'admin.tickets')) or RNG.hasPermission(user_id, 'police.armoury') then
          RNGclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = RNG.getUserId(nplayer)
              if (not RNG.hasPermission(nplayer_id, 'police.armoury') or RNG.hasPermission(nplayer_id, 'police.undercover')) then
                RNGclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('RNG:uncuffAnim', source, nplayer, false)
                    TriggerClientEvent('RNG:unHandcuff', source, false)
                  else
                    TriggerClientEvent('RNG:arrestCriminal', nplayer, source)
                    TriggerClientEvent('RNG:arrestFromPolice', source)
                  end
                  TriggerClientEvent('RNG:toggleHandcuffs', nplayer, false)
                  TriggerClientEvent('RNG:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              RNGclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

RegisterCommand('frontcuff', function(source, args)
  local source = source
  local user_id = RNG.getUserId(source)
  RNGclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      RNGclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and RNG.hasPermission(user_id, 'admin.tickets')) or RNG.hasPermission(user_id, 'police.armoury') then
          RNGclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = RNG.getUserId(nplayer)
              if (not RNG.hasPermission(nplayer_id, 'police.armoury') or RNG.hasPermission(nplayer_id, 'police.undercover')) then
                RNGclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('RNG:uncuffAnim', source, nplayer, true)
                    TriggerClientEvent('RNG:unHandcuff', source, true)
                  else
                    TriggerClientEvent('RNG:arrestCriminal', nplayer, source)
                    TriggerClientEvent('RNG:arrestFromPolice', source)
                  end
                  TriggerClientEvent('RNG:toggleHandcuffs', nplayer, true)
                  TriggerClientEvent('RNG:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              RNGclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

function RNG.handcuffKeys(source)
  local source = source
  local user_id = RNG.getUserId(source)
  if RNG.getInventoryItemAmount(user_id, 'handcuffkeys') >= 1 then
    RNGclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = RNG.getUserId(nplayer)
        RNGclient.isHandcuffed(nplayer,{},function(handcuffed)
          if handcuffed then
            RNG.tryGetInventoryItem(user_id, 'handcuffkeys', 1)
            TriggerClientEvent('RNG:uncuffAnim', source, nplayer, false)
            TriggerClientEvent('RNG:unHandcuff', source, false)
            TriggerClientEvent('RNG:toggleHandcuffs', nplayer, false)
            TriggerClientEvent('RNG:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        RNGclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

function RNG.handcuff(source)
  local source = source
  local user_id = RNG.getUserId(source)
  if RNG.getInventoryItemAmount(user_id, 'handcuff') >= 1 then
    RNGclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = RNG.getUserId(nplayer)
        RNGclient.isHandcuffed(nplayer,{},function(handcuffed)
          if not handcuffed then
            RNG.tryGetInventoryItem(user_id, 'handcuff', 1)
            TriggerClientEvent('RNG:toggleHandcuffs', nplayer, true)
            TriggerClientEvent('RNG:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        RNGclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

local section60s = {}
RegisterCommand('s60', function(source, args)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.announce') then
        if args[1] ~= nil and args[2] ~= nil then
            local radius = tonumber(args[1])
            local duration = tonumber(args[2])*60
            local section60UUID = #section60s+1
            section60s[section60UUID] = {radius = radius, duration = duration, uuid = section60UUID}
            TriggerClientEvent("RNG:addS60", -1, GetEntityCoords(GetPlayerPed(source)), radius, section60UUID)
        else
            RNGclient.notify(source,{'~r~Invalid Arguments.'})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(section60s) do
            if section60s[k].duration > 0 then
                section60s[k].duration = section60s[k].duration-1 
            else
                TriggerClientEvent('RNG:removeS60', -1, section60s[k].uuid)
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand('handbook', function(source, args)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('RNG:toggleHandbook', source)
    end
end)

local draggingPlayers = {}

RegisterServerEvent('RNG:dragPlayer')
AddEventHandler('RNG:dragPlayer', function(playersrc)
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id ~= nil and (RNG.hasPermission(user_id, "police.armoury") or RNG.hasPermission(user_id, "hmp.menu")) then
      if playersrc ~= nil then
        local nuser_id = RNG.getUserId(playersrc)
          if nuser_id ~= nil then
            RNGclient.isHandcuffed(playersrc,{},function(handcuffed)
                if handcuffed then
                    if draggingPlayers[user_id] then
                      TriggerClientEvent("RNG:undrag", playersrc, source)
                      draggingPlayers[user_id] = nil
                    else
                      TriggerClientEvent("RNG:drag", playersrc, source)
                      draggingPlayers[user_id] = playersrc
                    end
                else
                    RNGclient.notify(source,{"~r~Player is not handcuffed."})
                end
            end)
          else
              RNGclient.notify(source,{"~r~There is no player nearby"})
          end
      else
          RNGclient.notify(source,{"~r~There is no player nearby"})
      end
    end
end)

RegisterServerEvent('RNG:putInVehicle')
AddEventHandler('RNG:putInVehicle', function(playersrc)
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id ~= nil and RNG.hasPermission(user_id, "police.armoury") then
      if playersrc ~= nil then
        RNGclient.isHandcuffed(playersrc,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            RNGclient.putInNearestVehicleAsPassenger(playersrc, {10})
          else
            RNGclient.notify(source,{lang.police.not_handcuffed()})
          end
        end)
      end
    end
end)

RegisterServerEvent('RNG:ejectFromVehicle')
AddEventHandler('RNG:ejectFromVehicle', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id ~= nil and RNG.hasPermission(user_id, "police.armoury") then
      RNGclient.getNearestPlayer(source,{10},function(nplayer)
        local nuser_id = RNG.getUserId(nplayer)
        if nuser_id ~= nil then
          RNGclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
              RNGclient.ejectVehicle(nplayer, {})
            else
              RNGclient.notify(source,{lang.police.not_handcuffed()})
            end
          end)
        else
          RNGclient.notify(source,{lang.common.no_player_near()})
        end
      end)
    end
end)


RegisterServerEvent("RNG:Knockout")
AddEventHandler('RNG:Knockout', function()
    local source = source
    local user_id = RNG.getUserId(source)
    RNGclient.getNearestPlayer(source, {2}, function(nplayer)
        local nuser_id = RNG.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('RNG:knockOut', nplayer)
            SetTimeout(30000, function()
                TriggerClientEvent('RNG:knockOutDisable', nplayer)
            end)
        end
    end)
end)

RegisterServerEvent("RNG:KnockoutNoAnim")
AddEventHandler('RNG:KnockoutNoAnim', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasGroup(user_id, 'Founder') or RNG.hasGroup(user_id, 'Developer') or RNG.hasGroup(user_id, 'Lead Developer') then
      RNGclient.getNearestPlayer(source, {2}, function(nplayer)
          local nuser_id = RNG.getUserId(nplayer)
          if nuser_id ~= nil then
              TriggerClientEvent('RNG:knockOut', nplayer)
              SetTimeout(30000, function()
                  TriggerClientEvent('RNG:knockOutDisable', nplayer)
              end)
          end
      end)
    end
end)

RegisterServerEvent("RNG:requestPlaceBagOnHead")
AddEventHandler('RNG:requestPlaceBagOnHead', function()
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.getInventoryItemAmount(user_id, 'Headbag') >= 1 then
      RNGclient.getNearestPlayer(source, {10}, function(nplayer)
          local nuser_id = RNG.getUserId(nplayer)
          if nuser_id ~= nil then
              RNG.tryGetInventoryItem(user_id, 'Headbag', 1, true)
              TriggerClientEvent('RNG:placeHeadBag', nplayer)
          end
      end)
    end
end)

RegisterServerEvent('RNG:gunshotTest')
AddEventHandler('RNG:gunshotTest', function(playersrc)
    local source = source
    local user_id = RNG.getUserId(source)
    if user_id ~= nil and RNG.hasPermission(user_id, "police.armoury") then
      if playersrc ~= nil then
        RNGclient.hasRecentlyShotGun(playersrc,{}, function(shotagun)
          if shotagun then
            RNGclient.notify(source, {"~r~Player has recently shot a gun."})
          else
            RNGclient.notify(source, {"~r~Player has no gunshot residue on fingers."})
          end
        end)
      end
    end
end)

RegisterServerEvent('RNG:tryTackle')
AddEventHandler('RNG:tryTackle', function(id)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') or RNG.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('RNG:playTackle', source)
        TriggerClientEvent('RNG:getTackled', id, source)
    end
end)

RegisterCommand('drone', function(source, args)
  local source = source
  local user_id = RNG.getUserId(source)
  if RNG.hasGroup(user_id, 'Drone Trained') or RNG.hasGroup(user_id, 'Lead Developer') then
      TriggerClientEvent('toggleDrone', source)
  end
end)

RegisterCommand('trafficmenu', function(source, args)
  local source = source
  local user_id = RNG.getUserId(source)
  if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('RNG:toggleTrafficMenu', source)
  end
end)

RegisterServerEvent('RNG:startThrowSmokeGrenade')
AddEventHandler('RNG:startThrowSmokeGrenade', function(name)
    local source = source
    TriggerClientEvent('RNG:displaySmokeGrenade', -1, name, GetEntityCoords(GetPlayerPed(source)))
end)

RegisterCommand('breathalyse', function(source, args)
  local source = source
  local user_id = RNG.getUserId(source)
  if RNG.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('RNG:breathalyserCommand', source)
  end
end)

RegisterServerEvent('RNG:breathalyserRequest')
AddEventHandler('RNG:breathalyserRequest', function(temp)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('RNG:beingBreathalysed', temp)
      TriggerClientEvent('RNG:breathTestResult', source, math.random(0, 100), RNG.getPlayerName(temp))
    end
end)

seizeBullets = {
  ['9mm Bullets'] = true,
  ['7.62mm Bullets'] = true,
  ['.357 Bullets'] = true,
  ['12 Gauge Bullets'] = true,
  ['.308 Sniper Rounds'] = true,
  ['5.56mm NATO'] = true,
}

RegisterServerEvent('RNG:seizeWeapons')
AddEventHandler('RNG:seizeWeapons', function(playerSrc)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
        RNGclient.isHandcuffed(playerSrc, {}, function(handcuffed)
            if handcuffed then
                RemoveAllPedWeapons(GetPlayerPed(playerSrc), true)
                local player_id = RNG.getUserId(playerSrc)
                local cdata = RNG.getUserDataTable(player_id)

                for a, b in pairs(cdata.inventory) do
                    if string.find(a, 'wbody|') then
                        c = a:gsub('wbody|', '')
                        cdata.inventory[c] = b
                        cdata.inventory[a] = nil
                    end
                end

                for k, v in pairs(a.weapons) do
                    if cdata.inventory[k] ~= nil then
                        if not v.policeWeapon then
                            cdata.inventory[k] = nil
                        end
                    end
                end

                for c, d in pairs(cdata.inventory) do
                    if seizeBullets[c] then
                        cdata.inventory[c] = nil
                    end
                end

                TriggerEvent('RNG:RefreshInventory', playerSrc)

                -- local officerRank = RNG.getRank(source)
                local officerName = GetPlayerName(source)

                RNGclient.notify(source, {'~r~Seized weapons.'})
                RNGclient.notify(playerSrc, {'~r~Your weapons have been seized by ' .. officerName .. '.'}) -- .. officerRank .. ' 
            end
        end)
    end
end)


seizeDrugs = {
  ['Weed leaf'] = true,
  ['Weed'] = true,
  ['Coca leaf'] = true,
  ['Cocaine'] = true,
  ['Opium Poppy'] = true,
  ['Heroin'] = true,
  ['Ephedra'] = true,
  ['Meth'] = true,
  ['Frogs legs'] = true,
  ['Lysergic Acid Amide'] = true,
  ['LSD'] = true,
}
RegisterServerEvent('RNG:seizeIllegals')
AddEventHandler('RNG:seizeIllegals', function(playerSrc)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') then
      local player_id = RNG.getUserId(playerSrc)
      local cdata = RNG.getUserDataTable(player_id)
      for a,b in pairs(cdata.inventory) do
          for c,d in pairs(seizeDrugs) do
              if a == c then
                cdata.inventory[a] = nil
              end
          end
      end
      TriggerEvent('RNG:RefreshInventory', playerSrc)
      exports["rng"]:execute("INSERT INTO rng_police_hours (user_id, total_players_searched) VALUES (@user_id, 1) ON DUPLICATE KEY UPDATE total_players_searched = total_players_searched + 1", {
        ['@user_id'] = user_id
    })
      RNGclient.notify(source, {'~r~Seized illegals.'})
      RNGclient.notify(playerSrc, {'~r~Your illegals have been seized.'})
    end
end)

RegisterServerEvent("RNG:newPanic")
AddEventHandler("RNG:newPanic", function(a,b)
	local source = source
	local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'police.armoury') or RNG.hasPermission(user_id, 'hmp.menu') or RNG.hasPermission(user_id, 'nhs.menu') or RNG.hasPermission(user_id, 'lfb.onduty.permission') then
        TriggerClientEvent("RNG:returnPanic", -1, nil, a, b)
    end
end)

RegisterNetEvent("RNG:flashbangThrown")
AddEventHandler("RNG:flashbangThrown", function(coords)   
    TriggerClientEvent("RNG:flashbangExplode", -1, coords)
end)

RegisterNetEvent("RNG:updateSpotlight")
AddEventHandler("RNG:updateSpotlight", function(a)  
  local source = source 
  TriggerClientEvent("RNG:updateSpotlight", -1, source, a)
end)

RegisterCommand('wc', function(source, args)
  local source = source
  local user_id = RNG.getUserId(source)
  if RNG.hasPermission(user_id, 'police.armoury') then
    RNGclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        RNGclient.getPoliceCallsign(source, {}, function(callsign)
          RNGclient.getPoliceRank(source, {}, function(rank)
            RNGclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            RNGclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank.."\n~b~Name: ~w~"..RNG.getPlayerName(source),"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('RNG:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)

RegisterCommand('wca', function(source, args)
  local source = source
  local user_id = RNG.getUserId(source)
  if RNG.hasPermission(user_id, 'police.armoury') then
    RNGclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        RNGclient.getPoliceCallsign(source, {}, function(callsign)
          RNGclient.getPoliceRank(source, {}, function(rank)
            RNGclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            RNGclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank,"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('RNG:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)
