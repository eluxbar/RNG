function tRNG.request(a,b,c)
    SendNUIMessage({act="request",id=a,text=tostring(b),time=c})
    tRNG.playSound("HUD_MINI_GAME_SOUNDSET","5_SEC_WARNING")
  end

  RegisterNUICallback("request",function(d,e)
    if d.act=="response"then 
        RNGserver.requestResult({d.id,d.ok})
    end 
  end)
function tRNG.announce(f, g)
    SendNUIMessage({act = "announce", background = f, content = g})
end
function tRNG.setDiv(h, i, g)
    SendNUIMessage({act = "set_div", name = h, css = i, content = g})
end
function tRNG.setDivCss(h, i)
    SendNUIMessage({act = "set_div_css", name = h, css = i})
end
function tRNG.setDivContent(h, g)
    SendNUIMessage({act = "set_div_content", name = h, content = g})
end
function tRNG.divExecuteJS(h, j)
    SendNUIMessage({act = "div_execjs", name = h, js = j})
end
function tRNG.removeDiv(h)
    SendNUIMessage({act = "remove_div", name = h})
end
local k = false
function tRNG.isPaused()
    return k
end
local l = {
    phone = {
        up = {3, 172},
        down = {3, 173},
        left = {3, 174},
        right = {3, 175},
        select = {3, 176},
        cancel = {3, 177},
        open = {3, 31123}
    },
    request = {yes = {0, 83}, no = {0, 84}}
}
Citizen.CreateThread(
    function()
        while true do
            if IsDisabledControlJustPressed(table.unpack(l.request.yes)) then
                SendNUIMessage({act = "event", event = "requestAccept"})
            end
            if IsDisabledControlJustPressed(table.unpack(l.request.no)) then
                SendNUIMessage({act = "event", event = "requestDeny"})
            end
            local m = IsPauseMenuActive()
            if m and not k then
                k = true
                TriggerEvent("rng:pauseChange", k)
            elseif not m and k then
                k = false
                TriggerEvent("rng:pauseChange", k)
            end
            Wait(0)
        end
    end
)
AddEventHandler(
    "rng:pauseChange",
    function(k)
        SendNUIMessage({act = "pause_change", paused = k})
    end
)
