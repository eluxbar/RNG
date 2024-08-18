local a = {}
local b = 0
local c = {}
function func_f10warnings()
    if not recordingMode then
        if IsControlJustPressed(0, 57) then
            TriggerServerEvent("RNG:refreshWarningSystem")
            Citizen.Wait(100)
            SetNuiFocus(true, true)
            TriggerScreenblurFadeIn(100.0)
            SendNUIMessage({showF10 = true})
        end
    end
end
RegisterNUICallback(
    "closeRNGF10",
    function(b, d)
        TriggerScreenblurFadeOut(100.0)
        SetNuiFocus(false, false)
    end
)
tRNG.createThreadOnTick(func_f10warnings)
RegisterNetEvent("RNG:recievedRefreshedWarningData")
AddEventHandler(
    "RNG:recievedRefreshedWarningData",
    function(e, f, g)
        a = e
        c = g
        SendNUIMessage({type = "sendWarnings", warnings = json.encode(a), points = f, info = json.encode(c)})
    end
)
RegisterNetEvent("RNG:showWarningsOfUser")
AddEventHandler(
    "RNG:showWarningsOfUser",
    function(e, f, g)
        a = e
        c = g
        SendNUIMessage({type = "sendWarnings", warnings = json.encode(a), points = f, info = json.encode(c)})
        SendNUIMessage({showF10 = true})
        SetNuiFocus(true, true)
        TriggerScreenblurFadeIn(100.0)
    end
)
