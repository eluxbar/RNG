local a = false
local b = true
RegisterCommand(
    "togglekillfeed",
    function()
        if not a then
            b = not b
            if b then
                tRNG.notify("~g~Killfeed is now enabled")
                SendNUIMessage({type = "killFeedEnable"})
            else
                tRNG.notify("~r~Killfeed is now disabled")
                SendNUIMessage({type = "killFeedDisable"})
            end
        end
    end
)
RegisterNetEvent(
    "RNG:showHUD",
    function(c)
        a = not c
        if b then
            if c then
                SendNUIMessage({type = "killFeedEnable"})
            else
                SendNUIMessage({type = "killFeedDisable"})
            end
        end
    end
)
-- RegisterNetEvent(
--     "RNG:newKillFeed",
--     function(d, e, f, g, h, i, j, headshotKill)
--         if GetIsLoadingScreenActive() then
--             return
--         end
--         local k = "other"
--         local l = tRNG.getPlayerName(tRNG.getPlayerId())
--         if e == l or d == l then
--             k = "self"
--         end
--         local m = GetResourceKvpString("rng_oldkillfeed") or "false"
--         if m == "false" then
--             oldKillfeed = false
--         else
--             oldKillfeed = true
--         end
--         if oldKillfeed and (tRNG.isPlatClub() or tRNG.isPlusClub()) then
--             if g then
--             elseif headshotKill then
--                 tRNG.notify('~o~'..d..' ~w~headshotted ~o~'..e..'~w~.')
--             else
--                 tRNG.notify("~o~" .. d .. " ~w~killed ~o~" .. e .. "~w~.")
--             end
--         else
--             SendNUIMessage(
--                 {
--                     type = "addKill",
--                     victim = e,
--                     killer = d,
--                     weapon = f,
--                     suicide = g,
--                     victimGroup = i,
--                     killerGroup = j,
--                     range = h,
--                     uuid = tRNG.generateUUID("kill", 10, "alphabet"),
--                     category = k,
--                     isHeadshot = headshotKill
--                 }
--             )
--         end
--     end
-- )
function tRNG.takeClientVideoAndUploadKills(a)
    exports["els"]:requestVideoUpload(
        a,
        "files[]",
        {headers = {}, isVideo = true, isManual = true, encoding = "mp4"},
        function(n)
            RNGserver.killProcessed()
        end
    )
end
