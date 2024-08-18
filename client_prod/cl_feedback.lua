local aK = false
RegisterNetEvent("RNG:adminTicketFeedback", function(aL)
    local aM, aN = tRNG.getPlayerVehicle()
    if aM ~= 0 and aN and GetEntitySpeed(aM) > 25.0 or tRNG.getPlayerCombatTimer() > 0 then
        return
    end
    if aK then
        return
    end
    aK = true
    RequestStreamedTextureDict("ticket_response", false)
    while not HasStreamedTextureDictLoaded("ticket_response") do
        Citizen.Wait(0)
    end
    setCursor(1)
    TriggerScreenblurFadeIn(500.0)
    tRNG.hideUI()
    local aO = nil
    while not aO do
        DisableControlAction(0, 202, true)
        drawNativeNotification("Press ~INPUT_FRONTEND_CANCEL~ to stop providing feedback")
        for a1 = 0, 6 do
            DisableControlAction(0, a1, true)
        end
        DrawSprite("ticket_response", "faces", 0.5, 0.575, 0.39, 0.28275, 0.0, 255, 255, 255, 255)
        DrawAdvancedText(0.58, 0.4, 0.01, 0.01, 0.65, "How would you rate your experience with the admin?", 255, 255, 255, 255, 0, 0)
        if CursorInArea(0.304, 0.411, 0.483, 0.669) and IsControlJustPressed(0, 237) then
            aO = "good"
        end
        if CursorInArea(0.446, 0.552, 0.483, 0.669) and IsControlJustPressed(0, 237) then
            aO = "neutral"
        end
        if CursorInArea(0.588, 0.693, 0.483, 0.669) and IsControlJustPressed(0, 237) then
            aO = "bad"
        end
        if IsDisabledControlJustPressed(0, 202) then
            break
        end
        Citizen.Wait(0)
    end
    setCursor(0)
    SetStreamedTextureDictAsNoLongerNeeded("ticket_response")
    if aO then
        TriggerServerEvent("RNG:adminTicketFeedback", aL, aO)
    else
        TriggerServerEvent("RNG:adminTicketNoFeedback", aL)
    end
    tRNG.showUI()
    TriggerScreenblurFadeOut(500.0)
    aK = false
end)

RegisterCommand("adminfeedback", function(source, args, rawCommand)
    TriggerEvent("RNG:adminTicketFeedback")
end, false)
