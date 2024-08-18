
local items = {}
local a = module("rng-weapons", "cfg/weapons")

items["repairkit"] = {"Repair Kit","Used to repair vehicles.",nil,0.5}
items["Headbag"] = {"Head Bag","Used to cover someone's head.",nil,0.5}
items["Shaver"] = {"Shaver","Used to shave someone's head.",nil,0.5}
items["handcuffkeys"] = {"Handcuff Keys","Used to uncuff someone.",nil,0.5}
items["handcuff"] = {"Handcuff","Used to cuff someone.",nil,0.5}
items["rock"] = {"Rock","This Is Useless.",nil,0.5}
items["hackingDevice"] = {"Hacking Device", "This Is For Jewelry Hiest",nil,2.5}
items["sapphire"] = {"Sapphire", "",nil,0.5}
items["jewelry_necklace"] = {"Necklace", "",nil,0.5}
items["jewelry_watch"] = {"Watch", "",nil,0.5}
items["jewelry_ring"] = {"Ring", "",nil,0.5}

-- give "wbody|WEAPON_PISTOL" and "wammo|WEAPON_PISTOL" to have pistol body and pistol bullets

local get_wname = function(weapon_id)
  for k,v in pairs(a.weapons) do
    if k == weapon_id then
      return v.name
    end
  end
end

--- weapon body
local wbody_name = function(args)
  return get_wname(args[2])
end

local wbody_desc = function(args)
  return ""
end

local wbody_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")

  choices["Equip"] = {function(player,choice)
    local user_id = RNG.getUserId(player)
    if user_id ~= nil then
      if RNG.tryGetInventoryItem(user_id, fullidname, 1, true) then
        local weapons = {}
        weapons[args[2]] = {ammo = 0}
        for k,v in pairs(a.weapons) do
          if k == args[2] then
            if v.policeWeapon then
              if RNG.hasPermission(user_id, 'police.armoury') then
                RNGclient.giveWeapons(player, {weapons, false})
              else
                RNGclient.notify(player, {'You can not equip this weapon.'})
              end
            else
              RNGclient.giveWeapons(player, {weapons, false})
            end
          end
        end
      end
    end
  end}

  return choices
end

local wbody_weight = function(args)
  for k,v in pairs(a.weapons) do
    for c,d in pairs(args) do
      if k == d then
        if v.class == "Melee" then
          return 1.00
        elseif v.class == "Pistol" then
          return 5.00
        elseif v.class == "SMG" or v.class == "Shotgun" then
          return 7.50
        elseif v.class == "AR" then
          return 10.00
        elseif v.class == "Heavy" or v.class == "LMG" then
          return 15.00
        else
          return 1.00
        end
      end
    end
  end
end

items["wbody"] = {wbody_name,wbody_desc,wbody_choices,wbody_weight}

--- weapon ammo
local wammo_name = function(args)
  --print('helloo', json.encode(args))
  return args[1]
end

local wammo_desc = function(args)
  return ""
end

local wammo_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")
  local ammotype = nil;
  ammotype = args[1]

  choices["Load"] = {function(player,choice)
    local user_id = RNG.getUserId(player)
    if user_id ~= nil then
      local amount = RNG.getInventoryItemAmount(user_id, fullidname)
      if string.find(fullidname, "Police") and not RNG.hasPermission(user_id, 'police.armoury') then
        RNGclient.notify(player, {'You cannot load this ammo.'})
        local bulletAmount = RNG.getInventoryItemAmount(user_id, fullidname)
        RNG.tryGetInventoryItem(user_id, fullidname, bulletAmount, false)
        return
      end
      RNG.prompt(player, "Amount to load ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)
        RNGclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
          for k,v in pairs(a.weapons) do -- goes through new weapons cfg
            for c,d in pairs(uweapons) do -- goes through current weapons
              if k == c then  -- if weapon in new cfg is the same as in current weapons
                if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                  if RNG.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- take ammo from inv
                    local weapons = {}
                    weapons[k] = {ammo = ramount}
                    RNGclient.giveWeapons(player, {weapons,false})
                    TriggerEvent('RNG:RefreshInventory', player)
                    return
                  end
                end
              end
            end
          end
        end)
      end)
    end
  end}
  choices["LoadAll"] = {function(player,choice)
    local user_id = RNG.getUserId(player)
    if user_id ~= nil then
      ramount = parseInt(RNG.getInventoryItemAmount(user_id, fullidname))
      if ramount > 250 then ramount = 250 end
      if string.find(fullidname, "Police") and not RNG.hasPermission(user_id, 'police.armoury') then
        RNGclient.notify(player, {'You cannot load this ammo.'})
        local bulletAmount = RNG.getInventoryItemAmount(user_id, fullidname)
        RNG.tryGetInventoryItem(user_id, fullidname, bulletAmount, false)
        return
      end
      RNGclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
        for k,v in pairs(a.weapons) do -- goes through new weapons cfg
          for c,d in pairs(uweapons) do -- goes through current weapons
            if k == c then  -- if weapon in new cfg is the same as in current weapons
              if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                if RNG.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- take ammo from inv
                  local weapons = {}
                  weapons[k] = {ammo = ramount}
                  RNGclient.giveWeapons(player, {weapons,false})
                  TriggerEvent('RNG:RefreshInventory', player)
                  return
                end
              end
            end
          end
        end
      end)
    end
  end}
  choices["GiveAll"] = {
    function(idname, player, choice)
        local user_id = RNG.getUserId(player)

        if user_id == nil then
            return
        end

        local itemAmount = RNG.getInventoryItemAmount(user_id, idname)

        if itemAmount <= 0 then
            RNGclient.notify(player, {'You don\'t have any of that item to give!'})
            return
        end

        RNGclient.getNearestPlayers(player, {10}, function(nplayers)
            local numPlayers = 0
            local nplayerIds = {}

            for k, _ in pairs(nplayers) do
                numPlayers = numPlayers + 1
                table.insert(nplayerIds, k)
            end

            if numPlayers == 1 then
                local nplayerId = nplayerIds[1]
                local nuser_id = RNG.getUserId(nplayerId)

                if nuser_id ~= nil then
                    local inventoryWeight = RNG.getInventoryWeight(nuser_id)
                    local itemWeight = RNG.getItemWeight(idname)
                    local maxWeight = RNG.getInventoryMaxWeight(nuser_id)
                    local availableSpace = math.floor((maxWeight - inventoryWeight) / itemWeight)
                    local amountToGive = math.min(itemAmount, availableSpace)

                    if amountToGive > 0 then
                        if RNG.tryGetInventoryItem(user_id, idname, amountToGive, true) then
                            RNG.giveInventoryItem(nuser_id, idname, amountToGive, true)
                            TriggerEvent('RNG:RefreshInventory', player)
                            TriggerEvent('RNG:RefreshInventory', nplayerId)
                            RNGclient.playAnim(player, {true, {{"mp_common", "givetake1_a", 1}}, false})
                            RNGclient.playAnim(nplayerId, {true, {{"mp_common", "givetake2_a", 1}}, false})
                        else
                            RNGclient.notify(player, {'Invalid value.'})
                        end
                    end
                else
                    RNGclient.notify(player, {'Invalid Temp ID for Player ' .. nplayerId})
                end
            elseif numPlayers > 1 then
                local usrList = ""

                for k, _ in pairs(nplayers) do
                    usrList = usrList .. "[" .. k .. "]" .. GetPlayerName(k) .. " | "
                end

                RNG.prompt(player, "Players Nearby: " .. usrList, "", function(player, nplayer)
                    nplayer = tonumber(nplayer)

                    if nplayer and nplayers[nplayer] then
                        local selectedPlayerId = nplayer
                        local selectedPlayer = nplayers[selectedPlayerId]
                        local nuser_id = RNG.getUserId(selectedPlayerId)

                        if nuser_id ~= nil then
                            local inventoryWeight = RNG.getInventoryWeight(nuser_id)
                            local itemWeight = RNG.getItemWeight(idname)
                            local maxWeight = RNG.getInventoryMaxWeight(nuser_id)
                            local availableSpace = math.floor((maxWeight - inventoryWeight) / itemWeight)
                            local amountToGive = math.min(itemAmount, availableSpace)

                            if amountToGive > 0 then
                                if RNG.tryGetInventoryItem(user_id, idname, amountToGive, true) then
                                    RNG.giveInventoryItem(nuser_id, idname, amountToGive, true)
                                    TriggerEvent('RNG:RefreshInventory', player)
                                    TriggerEvent('RNG:RefreshInventory', selectedPlayerId)
                                    RNGclient.playAnim(player, {true, {{"mp_common", "givetake1_a", 1}}, false})
                                    RNGclient.playAnim(selectedPlayerId, {true, {{"mp_common", "givetake2_a", 1}}, false})
                                else
                                    RNGclient.notify(player, {'Invalid value.'})
                                end
                            end
                        else
                            RNGclient.notify(player, {'Invalid Temp ID for Player ' .. selectedPlayerId})
                        end
                    else
                        RNGclient.notify(player, {'Invalid selection or player.'})
                    end
                end)
            else
                RNGclient.notify(player, {'No players nearby!'})
            end
        end)
    end
}





  return choices
end

local Cooldown = {}
local armour_seq = {{"oddjobs@basejump@ig_15","puton_parachute", 1}} --Armour Seq

items["heavyarmour"] = {"Heavy Armour Plate","Armour",function(args)
  local choices = {}
  choices['Equip'] = {function(player, choice)
    local PermID = RNG.getUserId(player)
    local Ped = GetPlayerPed(player)
    local PedArmour = GetPedArmour(Ped)
    
    if Cooldown[player] then
      RNGclient.notify(player,{"~r~Server is still processing your request, if you see this message within 60s please contact a developer."})
      return
    end

    if PermID ~= nil then
      if PedArmour == 100 then
        RNGclient.notify(player,{"~r~You already have an armour plate equipped."})
      else
        if RNG.tryGetInventoryItem(PermID, "heavyarmour", 1, false) then
          RNGclient.setArmour(player, {100, true})
          Cooldown[player] = true
          RNGclient.playAnim(player, {false, armour_seq, false}) -- anim
          Wait(2500)
          SetPedArmour(Ped, 100)
          RNGclient.notify(player,{"~g~Applied Heavy Armour"})
          Cooldown[player] = false
        end
      end
    end
  end}
  return choices
end, 7.50}

items["lightarmour"] = {"Light Armour Plate","Armour",function(args)
  local choices = {}
  choices['Equip'] = {function(player, choice)
    local PermID = RNG.getUserId(player)
    local Ped = GetPlayerPed(player)
    local PedArmour = GetPedArmour(Ped)
    
    if Cooldown[player] then
      RNGclient.notify(player,{"~r~Server is still processing your request, if you see this message within 60s please contact a developer."})
      return
    end

    if PermID ~= nil then
      if PedArmour > 45 then
        RNGclient.notify(player,{"~r~You already have armour."})
      else
        if RNG.tryGetInventoryItem(PermID, "lightarmour", 1, false) then
          Cooldown[player] = true
          RNGclient.playAnim(player, {false, armour_seq, false}) -- anim
          Wait(2500)
          RNGclient.setArmour(player, {50, true})
          RNGclient.notify(player,{"~g~Applied Light Armour"})
          Cooldown[player] = false
        end
      end
    end
  end}
  return choices
end, 5.00}

items["stimshot"] = {"Stim Shot","Used to heal up a likkle yk!",function(args)
  local choices = {}
  local idname = args[1]
  choices["Equip"] = {function(player, choice)
    local user_id = RNG.getUserId(player)
    if user_id ~= nil then
      local Ped = GetPlayerPed(player)
      local Health = GetEntityHealth(Ped)
      if Health < 180 then
        if RNG.tryGetInventoryItem(user_id, idname, 1, false) then
          RNGclient.notify(player,{"~g~Injected 1 Stim Shot"})
          -- RNGclient.setEffectMeds(player)
          SetEntityHealth(Ped, Health + 20)
        end
      else
        RNGclient.notify(player,{"~g~You're healthy."})
      end
    end
  end}
  return choices
end, 5.00}

local wammo_weight = function(args)
  return 0.01
end

for i,v in pairs(RNGAmmoTypes) do
  items[i] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}
end

items["wammo"] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}

return items
