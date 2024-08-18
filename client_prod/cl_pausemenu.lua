local isPauseMenuOpen = false
local urlIsOpen = false
RegisterKeyMapping("rngTogglePauseMenu", "", "keyboard", "ESCAPE")
RegisterKeyMapping("rngTogglePauseMenuController", "", "controller", "START")
local function togglePauseMenu()
    if IsPauseMenuActive() then
        return
    end

    if isPauseMenuOpen then
        rngClosePauseMenu()
    elseif not tRNG.isInComa() then
        TriggerServerEvent('RNG:getPlayerListData')
        rngShowPauseMenu()
    end
end
RegisterCommand('rngTogglePauseMenu', togglePauseMenu)
RegisterCommand('rngTogglePauseMenuController', togglePauseMenu)

function tRNG.isPauseMenuOpen()
    return isPauseMenuOpen
end

local userplaytime = 0
RegisterNetEvent('RNG:getUsertimeforpausemenu',function(time)
    local asdasduserplaytime = time/60
    local formattedtime = string.format("%.2f", asdasduserplaytime)
    userplaytime = formattedtime
end)

function rngShowPauseMenu()
    if IsPauseMenuActive() and tRNG.isInComa() then
        return
    end
    SetPauseMenuActive(true)
    DisableIdleCamera(true)
    ExecuteCommand('hideui')
    SetNuiFocusKeepInput(false)
    TriggerScreenblurFadeIn(5.0)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "rngTogglePauseMenu",
        toggle = true,
        rngDLastName = userplaytime, -- PLAYTIME
        rngDBirthdate = tRNG.getEmploymentStatus(), -- EMPLOYMENT
        totalPlayers = #GetPlayers() .. "/" .. GetConvar("sv_maxclients", "64"), -- TOTAL PLAYERS ONLINE
        rngDGender = getMoneyStringFormatted(tRNG.getUserId()), -- ID
        deathmatchPlayers = "0/" .. GetConvar("sv_maxclients", "64"), -- TOTAL DEATHMATCH PLAYERS ONLINE
        rngPlrName = tRNG.getPlayerName(PlayerId()), -- NAME
    })
    isPauseMenuOpen = true
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetPauseMenuActive(false)
    end
end)

RegisterNUICallback('Close', function(data)
    rngClosePauseMenu()
end)

RegisterNUICallback('Settings', function(data)
    rngClosePauseMenu()
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'),0,-1) 
end)

RegisterNUICallback('Dispute', function(data)
    rngClosePauseMenu()
    ExecuteCommand('dispute')
end)

RegisterNUICallback('ReadRules', function(data)
    if not urlIsOpen then
        urlIsOpen = true
        tRNG.OpenUrl('https://rng.net/rules/rules-redirect.html')
    else
        tRNG.notify('~r~You are being rate limited. Please wait a few seconds before trying again.')
    end
end)

RegisterNUICallback('DeathMatchDiscord', function(data)
    if not urlIsOpen then
        urlIsOpen = true
        tRNG.OpenUrl('https://discord.gg/rngdm')
    else
        tRNG.notify('~r~You are being rate limited. Please wait a few seconds before trying again.')
    end
end)

RegisterNUICallback('DeathMatchF8', function(data)
    if not urlIsOpen then
        urlIsOpen = true
        TriggerEvent("RNG:showNotification",
            {
                text = "F8 Connect Copied To Clipboard.",
                height = "200px",
                width = "auto",
                colour = "#FFF",
                background = "#32CD32",
                pos = "bottom-right",
                icon = "good"
            }, 5000
        )
        tRNG.CopyToClipBoard("deathmatch.rng.city")
    else
        tRNG.notify('~r~You are being rate limited. Please wait a few seconds before trying again.')
    end
end)


RegisterNUICallback('Rules', function(data)
    if not urlIsOpen then
        urlIsOpen = true
        tRNG.OpenUrl('https://rng.net/rules/fivem-rules.html')
    else
        tRNG.notify('~r~You are being rate limited. Please wait a few seconds before trying again.')
    end
end)

RegisterNUICallback('ComRules', function(data)
    if not urlIsOpen then
        urlIsOpen = true
        tRNG.OpenUrl('https://rng.net/rules/community-rules.html')
    else
        tRNG.notify('~r~You are being rate limited. Please wait a few seconds before trying again.')
    end
end)

RegisterNUICallback('RNGDiscord', function(data)
    if not urlIsOpen then
        urlIsOpen = true
        tRNG.OpenUrl('https://discord.gg/rnguk')
    else
        tRNG.notify('~r~You are being rate limited. Please wait a few seconds before trying again.')
    end
end)

RegisterNUICallback('Guide', function(data)
    if not urlIsOpen then
        urlIsOpen = true
        tRNG.OpenUrl('https://wiki.rng.net/')
    else
        tRNG.notify('~r~You are being rate limited. Please wait a few seconds before trying again.')
    end
end)

RegisterNUICallback('Twitter', function(data)
    if not urlIsOpen then
        urlIsOpen = true
        tRNG.OpenUrl('https://x.com/RNGFiveM')
    else
        tRNG.notify('~r~You are being rate limited. Please wait a few seconds before trying again.')
    end
end)

RegisterNUICallback('Website', function(data)
    if not urlIsOpen then
        urlIsOpen = true
        tRNG.OpenUrl('https://rng.net')
    else
        tRNG.notify('~r~You are being rate limited. Please wait a few seconds before trying again.')
    end
end)

RegisterNUICallback('Store', function(data)
    if not urlIsOpen then
        urlIsOpen = true
        tRNG.OpenUrl('https://store.rng.net')
    else
        tRNG.notify('~r~You are being rate limited. Please wait a few seconds before trying again.')
    end
end)

RegisterNUICallback('Map', function(data)
    rngClosePauseMenu()
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'),0,-1)
end)

RegisterNUICallback('Disconnect', function(data)
    rngClosePauseMenu()
	TriggerServerEvent('kick:PauseMenu')
end)

function rngClosePauseMenu()
    if IsPauseMenuActive() then
        return
    end
    ExecuteCommand('showui')
    DisableIdleCamera(false)
    TriggerScreenblurFadeOut(5.0)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SetFrontendActive(false) -- Close the frontend menu
    SendNUIMessage({
        type = "rngTogglePauseMenu",
        toggle = false
    })
    isPauseMenuOpen = false
end

Citizen.CreateThread(function()
    while true do
        Wait(1500) -- 1.5 seconds
        if urlIsOpen then
           urlIsOpen = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 
        if IsControlJustReleased(0, 199) then

            if isPauseMenuOpen then
                rngClosePauseMenu()
            elseif not tRNG.isInComa() then
                rngShowPauseMenu()
            end
        end
    end
end)

RegisterNetEvent('RNG:callOpenPReport')
AddEventHandler('RNG:callOpenPReport', function(data)
    tRNG.OpenUrl(data)
end)

RegisterNetEvent('rngHidePauseMenu')
AddEventHandler('rngHidePauseMenu', function()
	rngClosePauseMenu()
end)

RegisterNetEvent('rngShowPauseMenu')
AddEventHandler('rngShowPauseMenu', function()
	rngShowPauseMenu()
end)