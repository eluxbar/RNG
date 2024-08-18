RegisterNUICallback(
    "exit",
    function(a)
        SetDisplay(false)
        stopAnim()
    end
)
RegisterNUICallback(
    "personsearch",
    function(a)
        TriggerServerEvent("RNG:searchPerson", a.firstname, a.lastname)
    end
)
RegisterNUICallback(
    "platesearch",
    function(a)
        TriggerServerEvent("RNG:searchPlate", a.plate)
    end
)
RegisterNUICallback(
    "submitfine",
    function(a)
        TriggerServerEvent("RNG:finePlayer", a.user_id, a.charges, a.amount, a.notes)
    end
)
RegisterNUICallback(
    "addnote",
    function(a)
        TriggerServerEvent("RNG:addNote", a.user_id, a.note)
    end
)
RegisterNUICallback(
    "removenote",
    function(a)
        TriggerServerEvent("RNG:removeNote", a.user_id, a.note)
    end
)
RegisterNUICallback(
    "addattentiondrawn",
    function(a)
        TriggerServerEvent("RNG:addAttentionDrawn", a)
    end
)
RegisterNUICallback(
    "removeattentiondrawn",
    function(a)
        TriggerServerEvent("RNG:removeAttentionDrawn", a.ad)
    end
)
RegisterNUICallback(
    "savenotes",
    function(a)
        TriggerServerEvent("RNG:updateVehicleNotes", a.notes, a.user_id, a.vehicle)
    end
)
RegisterNUICallback(
    "savepersonnotes",
    function(a)
        TriggerServerEvent("RNG:updatePersonNote", a.user_id, a.notes)
    end
)
RegisterNUICallback(
    "generatewarrant",
    function(a)
        TriggerServerEvent("RNG:getWarrant")
    end
)
RegisterNUICallback(
    "addpoint",
    function(a)
        TriggerServerEvent("RNG:addPoints", a.points, a.id)
    end
)
RegisterNUICallback(
    "addmarker",
    function(a, b)
        TriggerServerEvent("RNG:addWarningMarker", tonumber(a.id), a.type, a.reason)
        b()
    end
)
RegisterNUICallback(
    "wipeallmarkers",
    function(a, b)
        TriggerServerEvent("RNG:wipeAllMarkers", a.code)
        b()
    end
)
RegisterNetEvent(
    "RNG:sendSearcheduser",
    function(c)
        SendNUIMessage({type = "addPersons", user = c})
    end
)
RegisterNetEvent(
    "RNG:sendSearchedvehicle",
    function(d)
        SendNUIMessage({type = "displaySearchedVehicle", vehicle = d})
    end
)
RegisterNetEvent(
    "RNG:addADToClient",
    function(e)
        SendNUIMessage({type = "updateAttentionDrawn", ad = e})
    end
)
RegisterNetEvent(
    "RNG:verifyFineSent",
    function(f, g)
        SendNUIMessage({type = "verifyFine", sentornah = f, msg = g})
    end
)
RegisterNetEvent(
    "RNG:novehFound",
    function(g)
        SendNUIMessage({type = "noveh", message = g or "No vehicles found!"})
    end
)
RegisterNetEvent(
    "RNG:openPNC",
    function(h, i, e)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "ui",
                status = true,
                id = tRNG.getUserId(),
                name = GetPlayerName(PlayerId()),
                gc = h,
                news = i,
                ad = e
            }
        )
        startAnim()
    end
)
RegisterNetEvent(
    "RNG:updateAttentionDrawn",
    function(j)
        SendNUIMessage({type = "updateAttentionDrawn", ad = j})
    end
)
RegisterNetEvent(
    "RNG:setNameFields",
    function(k, l)
        SendNUIMessage({type = "setNameFields", lname = k, fname = l})
    end
)
RegisterNetEvent(
    "RNG:noPersonsFound",
    function()
        SendNUIMessage({type = "NoPersonsFound"})
    end
)
CreateThread(
    function()
        while true do
            if IsControlJustPressed(0, 168) then
                Citizen.Wait(100)
                TriggerServerEvent("RNG:checkForPolicewhitelist")
            end
            Citizen.Wait(0)
        end
    end
)
function startAnim()
    CreateThread(
        function()
            RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
            while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
                Citizen.Wait(0)
            end
            attachObject()
            TaskPlayAnim(
                tRNG.getPlayerPed(),
                "amb@world_human_seat_wall_tablet@female@base",
                "base",
                8.0,
                -8.0,
                -1,
                50,
                0,
                false,
                false,
                false
            )
        end
    )
end
function attachObject()
    tab = CreateObject("prop_cs_tablet", 0, 0, 0, true, true, true)
    AttachEntityToEntity(
        tab,
        tRNG.getPlayerPed(),
        GetPedBoneIndex(tRNG.getPlayerPed(), 57005),
        0.17,
        0.10,
        -0.13,
        24.0,
        180.0,
        180.0,
        true,
        true,
        false,
        true,
        1,
        true
    )
end
function stopAnim()
    StopAnimTask(tRNG.getPlayerPed(), "amb@world_human_seat_wall_tablet@female@base", "base", 8.0)
    DeleteEntity(tab)
end
function SetDisplay(f)
    SetNuiFocus(f, f)
    SendNUIMessage({type = "ui", status = f, name = GetPlayerName(PlayerId())})
end
function PoliceSeizeTrunk(m, n)
    TriggerServerEvent("RNG:policeClearVehicleTrunk", m, n)
end
RegisterNetEvent(
    "RNG:notifyAD",
    function(g, o)
        tRNG.notifyPicture("met_logo", "met_logo1", g, "Met Control", o, "police", 2)
    end
)
