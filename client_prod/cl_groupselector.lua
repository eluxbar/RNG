local a = module("cfg/cfg_groupselector")
local b = a.selectors
local c = {}
local d = false
local e = ""
local f = 15634
local mpdstats = {}
RMenu.Add("main","groupselector",RageUI.CreateMenu("", "", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "menus", "rng_licenseui"))
RMenu.Add("groupselector","mpdstats",RageUI.CreateMenu("", "", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "menus", "rng_licenseui"))
RMenu:Get("main", "groupselector"):SetSubtitle("Select a job.")
RMenu:Get("groupselector", "mpdstats"):SetSubtitle("Met Police Stats.")
AddEventHandler("RNG:onClientSpawn",function(f, g)
    if g and not tRNG.isPurge() and not tRNG.inEvent() then
        TriggerServerEvent("RNG:getJobSelectors")
        TriggerServerEvent("RNG:getFactionWhitelistedGroups")
        TriggerServerEvent("RNG:getPaycheckAmount")
    end
end)

RegisterNetEvent("RNG:gotJobSelectors",function(h)
    c = h
    local i = function(j)
        e = j.selectorId
    end
    local k = function(j)
        RageUI.ActuallyCloseAll()
        RageUI.Visible(RMenu:Get("main", "groupselector"), false)
    end
    local l = function(j)
        if IsControlJustPressed(1, 38) then
            TriggerServerEvent("RNG:getPaycheckAmount")
            local m = b[j.selectorId].type
            RageUI.ActuallyCloseAll()
            RMenu:Get("main", "groupselector"):SetSpriteBanner(a.selectorTypes[m]._config.TextureDictionary,a.selectorTypes[m]._config.texture)
            RageUI.Visible(RMenu:Get("main", "groupselector"), true)
        end
        local n, o, p = table.unpack(GetFinalRenderedCamCoord())
        DrawText3D(b[j.selectorId].position.x,b[j.selectorId].position.y,b[j.selectorId].position.z,"~w~Press ~b~[E]~w~ to open Job Selector.",n,o,p)
    end
    for q, r in pairs(c) do
        tRNG.createArea("selector_" .. q, r.position, 1.5, 6, i, k, l, {selectorId = q})
        tRNG.addMarker(r.position.x, r.position.y, r.position.z - 1, 1.0, 1.0, 1.0, 255, 0, 0, 170, 50, 27)
        tRNG.addBlip(r.position.x,r.position.y,r.position.z,r._config.blipid,r._config.blipcolor,r._config.name)
    end
end)

RageUI.CreateWhile(1.0,true,function()
    if RageUI.Visible(RMenu:Get("main", "groupselector")) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = false},function()
            for q, r in pairs(c) do
                if q == e then
                    for s, t in pairs(r.jobs) do
                        RageUI.ButtonWithStyle(t[1],r._config.name,{RightLabel = "→→→"},true,function(u, v, w)
                            if w then
                                TriggerServerEvent("RNG:jobSelector", q, t[1])
                                SetTimeout(1000,function()
                                    TriggerServerEvent("RNG:refreshGaragePermissions")
                                    ExecuteCommand("blipson")
                                end)
                            end
                        end)
                    end
                    local source = source
                    local user_id = tRNG.getUserId(source)
                    local JobType = tRNG.getJobType(user_id)
                    local JobLabel = "You Are Not Clocked On"
                    if JobType == "metpd" then
                        JobLabel = "Clock Off"
                    elseif JobType == "hmp" then
                        JobLabel = "Clock Off"
                    elseif JobType == "nhs" then
                        JobLabel = "Clock Off"
                    elseif JobType == "lfb" then
                        JobLabel = "Clock Off"
                    end
                    RageUI.Button("Unemployed", JobLabel, b8 and {RightLabel = ""} or {RightLabel = "→→→"}, JobType == "metpd",function(u, v, w)
                        if w then
                            TriggerServerEvent("RNG:jobSelector", q, "Unemployed")
                            b8 = true
                            SetTimeout(20000, function()
                                b8 = false
                            end)
                            SetTimeout(1000,function()
                                TriggerServerEvent("RNG:refreshGaragePermissions")
                            end)
                        end
                    end)
                    RageUI.Button("Claim Pay Check (£" .. getMoneyStringFormatted(f) .. ")", "£" .. getMoneyStringFormatted(f), b9 and {RightLabel = ""} or {RightLabel = "→→→"}, f > 0, function(u, v, w)
                        if w then
                            if f > 0 then
                                TriggerServerEvent("RNG:acceptPaycheck")
                                b9 = true
                                SetTimeout(20000, function()
                                    b9 = false
                                end)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(
                        "View Stats",
                        "~b~Your Met Police history throughout RNG.",
                        {RightLabel = "→→→"},
                        true,
                        function(_, _, selected)
                            if selected then
                                TriggerServerEvent("RNG:getMPDStats")
                            end
                        end,
                        RMenu:Get("groupselector", "mpdstats")
                    )
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get("groupselector", "mpdstats")) then
        RageUI.DrawContent(
            {header = true, glare = false, instructionalButton = false},
            function()
                if #mpdstats > 0 then
                    for _, stat in ipairs(mpdstats) do
                        RageUI.Separator("Total Hours: " .. string.format("%.2f", stat.total_hours))
                        RageUI.Separator("Total Hours This Week: " .. stat.weekly_hours)
                        RageUI.Separator("Last Clocked On As: " .. stat.last_clocked_rank)
                        -- if stat.last_clocked_date then
                        --     RageUI.Separator("Last Clocked On Date: " .. string.format("%02d/%02d/%02d", stat.last_clocked_date))
                        -- else
                        --     RageUI.Separator("Last Clocked On Date: N/A")
                        -- end
                        RageUI.Separator("Total Players Jailed This Week: " .. stat.total_players_fined)
                        RageUI.Separator("Total Players Fined This Week: " .. stat.total_players_jailed)
                    end
                else
                    RageUI.Separator("~r~You have no met police stats to display.")
                end
                RageUI.ButtonWithStyle(
                    "Back",
                    nil,
                    {RightLabel = "→→→"},
                    true,
                    function(_, _, _) end,
                    RMenu:Get("main", "groupselector")
                )
            end
        )
    end
end)


RegisterNetEvent("RNG:setMPDStats")
AddEventHandler("RNG:setMPDStats", function(stats)
    mpdstats = stats
end)

RegisterNetEvent("RNG:gotPaycheckAmount", function(g)
    f = g
end)

RegisterNetEvent("RNG:claimedPaycheck", function()
    RageUI.ActuallyCloseAll()
    f = 0
end)