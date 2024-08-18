
local client_areas = {}

-- free client areas when leaving
AddEventHandler("RNG:playerLeave",function(user_id,source)
  client_areas[source] = nil 
end)

-- create/update a player area
function RNG.setArea(source,name,x,y,z,radius,height,cb_enter,cb_leave)
  local areas = client_areas[source] or {}
  client_areas[source] = areas

  areas[name] = {enter=cb_enter,leave=cb_leave}
  RNGclient.setArea(source,{name,x,y,z,radius,height})
end

-- delete a player area
function RNG.removeArea(source,name)
  -- delete remote area
  RNGclient.removeArea(source,{name})

  -- delete local area
  local areas = client_areas[source]
  if areas then
    areas[name] = nil
  end
end

-- TUNNER SERVER API
RegisterNetEvent("RNG:enterArea")
AddEventHandler("RNG:enterArea",function(name)
  RNG.enterArea(name)
end)
function RNG.enterArea(name)
  local areas = client_areas[source]
  if areas then
    local area = areas[name] 
    if area and area.enter then -- trigger enter callback
      area.enter(source,name)
    end
  end
end
RegisterNetEvent("RNG:leaveArea")
AddEventHandler("RNG:leaveArea",function(name)
  RNG.leaveArea(name)
end)
function RNG.leaveArea(name)
  local areas = client_areas[source]

  if areas then
    local area = areas[name] 
    if area and area.leave then -- trigger leave callback
      area.leave(source,name)
    end
  end
end

