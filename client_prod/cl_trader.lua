local a = nil
local b = module("cfg/cfg_trader")
local inVehicle = false
globalWeedCommissionPercent = 0
globalCocaineCommissionPercent = 0
globalMethCommissionPercent = 0
globalHeroinCommissionPercent = 0
globalLargeArmsCommission = 0
globalLSDNorthCommissionPercent = 0
globalLSDSouthCommissionPercent = 0
local c = {
    ["Weed"] = 0,
    ["Cocaine"] = 0,
    ["Meth"] = 0,
    ["Heroin"] = 0,
    ["LSDNorth"] = 0,
    ["LSDSouth"] = 0,
    ["Copper"] = 0,
    ["Limestone"] = 0,
    ["Gold"] = 0,
    ["Diamond"] = 0
}
RegisterNetEvent("RNG:updateTraderCommissions",function(d, e, f, g, h, i, j)
    globalWeedCommissionPercent = d
    globalCocaineCommissionPercent = e
    globalMethCommissionPercent = f
    globalHeroinCommissionPercent = g
    globalLargeArmsCommission = h
    globalLSDNorthCommissionPercent = i
    globalLSDSouthCommissionPercent = j
end)

Citizen.CreateThread(function()
    local k = tRNG.loadAnimDict("mini@strip_club@idles@bouncer@base")
    for l, m in pairs(b.trader) do
        tRNG.addMarker(m.position.x,m.position.y,m.position.z,0.7,0.7,0.5,m.colour.r,m.colour.g,m.colour.b,125,50,29,true,true)
        tRNG.createDynamicPed(m.dealerModel,m.dealerPos + vector3(0.0, 0.0, -1.0),m.dealerHeading,true,"mini@strip_club@idles@bouncer@base","base",100,false)
    end
end)

Citizen.CreateThread(function()
    while true do
        if GetVehiclePedIsIn(tRNG.getPlayerPed(), false) == 0 then
            inVehicle = false
        else
            inVehicle = true
        end
        Citizen.Wait(1000)
    end
end)

local c = {
    ["Weed"] = 0,
    ["Cocaine"] = 0,
    ["Meth"] = 0,
    ["Heroin"] = 0,
    ["LSDNorth"] = 0,
    ["LSDSouth"] = 0,
    ["Copper"] = 0,
    ["Limestone"] = 0,
    ["Gold"] = 0,
    ["Diamond"] = 0
}

RMenu.Add("trader","seller",RageUI.CreateMenu("RNG Trader","Sell your goods!",tRNG.getRageUIMenuWidth(),tRNG.getRageUIMenuHeight(),nil,nil,0,0,255,255))
RageUI.CreateWhile(1.0,true,function()
    if RageUI.Visible(RMenu:Get("trader", "seller")) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = false},function()
            if a == "Legal" then
                sellItem("Sell Copper", "RNG:sellCopper", "Copper", "Copper")
                sellItem("Sell Limestone", "RNG:sellLimestone", "Limestone", "Limestone")
                sellItem("Sell Gold", "RNG:sellGold", "Gold", "Gold")
                sellItem("Sell Diamond", "RNG:sellDiamond", "Diamond", "Diamond")
                sellItem("Sell ALL", "RNG:sellAll")
            elseif a == "Weed" then

                sellItem("Sell Weed", "RNG:sellWeed", "Weed", "Weed")
                sellItem("Sell ALL Weed", "RNG:sellAllDrugs", "Weed", "Weed")
            elseif a == "Cocaine" then

                sellItem("Sell Cocaine", "RNG:sellCocaine", "Cocaine", "Cocaine")
                sellItem("Sell ALL Cocaine", "RNG:sellAllDrugs", "Cocaine", "Cocaine")
            elseif a == "Meth" then

                sellItem("Sell Meth", "RNG:sellMeth", "Meth", "Meth")
                sellItem("Sell ALL Meth", "RNG:sellAllDrugs", "Meth", "Meth")
            elseif a == "Heroin" then

                sellItem("Sell Heroin", "RNG:sellHeroin", "Heroin", "Heroin")
                sellItem("Sell ALL Heroin", "RNG:sellAllDrugs", "Heroin", "Heroin")
            elseif a == "LSDNorth" then

                sellItem("Sell LSD", "RNG:sellLSDNorth", "LSD", "LSDNorth")
                sellItem("Sell ALL LSD", "RNG:sellAllDrugs", "LSD", "LSDNorth")
            elseif a == "LSDSouth" then

                sellItem("Sell LSD", "RNG:sellLSDSouth", "LSD", "LSDSouth")
                sellItem("Sell ALL LSD", "RNG:sellAllDrugs", "LSD", "LSDSouth")
            end
        end)
    end
end)

function sellItem(itemName, serverEvent, drugName, drugLocation)
    if not inVehicle then
        RageUI.ButtonWithStyle(itemName,"£"..getMoneyStringFormatted(c[drugLocation] or 0),{RightLabel = "→→→"},true,function(m, n, o)
            if o then
                TriggerServerEvent(serverEvent, drugName, drugLocation)
            end
        end)
    else
        tRNG.notify("Exit your vehicle.")
    end
end

AddEventHandler("RNG:onClientSpawn",function(p, q)
    if q then
        local r = function(s)
        end
        local t = function(s)
            RageUI.Visible(RMenu:Get("trader", "seller"), false)
            RageUI.ActuallyCloseAll()
        end
        local u = function(s)
            if IsControlJustPressed(1, 38) then
                a = s.traderName
                RageUI.Visible(RMenu:Get("trader", "seller"), not RageUI.Visible(RMenu:Get("trader", "seller")))
            end
            local v, w, x = table.unpack(GetFinalRenderedCamCoord())
            DrawText3D(b.trader[s.traderId].position.x,b.trader[s.traderId].position.y,b.trader[s.traderId].position.z,"Press [E] to open seller",v,w,x)
        end
        for y, l in pairs(b.trader) do
            tRNG.createArea("trader_" .. y, l.position, 1.5, 6, r, t, u, {traderId = y, traderName = l.type})
        end
    end
end)

RegisterNetEvent("RNG:updateTraderPrices",function(z, A, B, C, i, j, D, E, F, G)
    c["Weed"] = z or 0
    c["Cocaine"] = A or 0
    c["Meth"] = B or 0
    c["Heroin"] = C or 0
    c["LSDNorth"] = i or 0
    c["LSDSouth"] = j or 0
    c["Copper"] = D or 0
    c["Limestone"] = E or 0
    c["Gold"] = F or 0
    c["Diamond"] = G or 0
end)