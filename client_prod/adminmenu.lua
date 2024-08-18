RNGclient = Tunnel.getInterface("RNG", "RNG")
local kills, deaths, kdRatio = nil, nil, nil
local a = 0
local b = false
local c = false
local d = {}
local staff_group = nil
local e = {}
local f = 250
local g = {}
local h
local i = false
local lastSpawnTime = 0
local cooldownTime = 300
local an = nil
local j = nil
local k = nil
local l = nil
local m = nil
local n = {}
local banreasons = module("cfg/cfg_banreasons")
local o = {}
local p = 0
local q = "N/A"
local r = 1
local s = {}
local t = {}
local u = 0
local v
local w = {}
local x = 1
local y = {}
local z = ""
local A = ""
local B
local acbannedplayers = 0
local acadminname = ""
local acbannedplayerstable = {}
local C = false
local a100 = false
local D = {"POV List", "Cinematic", "Police", "NHS"}
local a11 = {"Forums", "Discord", "Support Discord", "Met Police", "NHS"}
local E = 1
local F = {}
admincfg = {}
admincfg.perm = "admin.tickets"
admincfg.IgnoreButtonPerms = false
admincfg.admins_cant_ban_admins = false
local function isSelf(a)
    return tRNG.getUserId() == a
end
local G = {
    "PD (Mission Row)",
    "PD (Sandy)",
    "PD (Paleto)",
    "City Hall",
    "Airport",
    "HMP",
    "Rebel Diner",
    "St Thomas",
    "Tutorial Spawn",
    "Simeons"
}
local a68 = {
    "Legion",
    "Paleto",
    "City Hall",
    "Rebel Diner",
    "St Thomas",
    "Sandy Shores",
    "Vip Island",
    "Paleto Lodges",
    "Simeons",
}

local a209 = {
    "To Player",
    "Player To Me",
    "To Admin Island",
    "Back From Admin Island"
}

local teleportOptionsEvents = {
    "RNG:TeleportToPlayer",
    "RNG:BringPlayer",
    "RNG:Teleport2AdminIsland",
    "RNG:TeleportBackFromAdminZone"
}

local a69 = {
    vec3(159.527908, -1035.066162, 29.184591), -- legion
    vec3(-241.665054, 6325.601074, 32.426285), -- paleto
    vec3(-549.696167, -195.346054, 38.219746), -- city hall 
    vec3(1584.466919, 6445.947754, 25.121088), -- rebel diner
    vec3(362.589966, -588.911560, 28.675251), -- st thomas
    vec3(1841.475952, 3669.057617, 33.680065), -- sandy 
    vec3(-2184.926758, 5155.532227, 9.351744), -- VIP Island
    vec3(-735.186829, 5814.273926, 17.415485), -- Paleto Lodges
    vec3(-52.765713, -1110.200928, 26.438000) -- Simeons
}
local H = {
    vector3(446.72503662109, -982.44342041016, 30.68931579589),
    vector3(1839.3137207031, 3671.0014648438, 34.310436248779),
    vector3(-437.32931518555, 6021.2114257813, 31.490119934082),
    vector3(-551.08221435547, -194.19259643555, 38.219661712646),
    vector3(-1142.0673828125, -2851.802734375, 13.94624710083),
    vector3(1848.2724609375, 2586.7385253906, 45.671997070313),
    vector3(1588.3441162109, 6439.3696289063, 25.123600006104),
    vector3(283.37664794922, -579.45318603516, 43.219303131104),
    vector3(-1035.9499511719, -2734.6240234375, 13.756628036499),
    vector3(-39.604099273682, -1111.8635253906, 26.438835144043)
}
local I = 1
local a74 = 1
local a735 = 1
menuColour = "~w~"
RMenu.Add(
    "adminmenu",
    "main",
    RageUI.CreateMenu(
        "",
        menuColour .. "Administration Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "players",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "main"),
        "",
        menuColour .. "Administration Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "closeplayers",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "main"),
        "",
        menuColour .. "Administration Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "extrainfo",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "main"),
        "",
        menuColour .. "Administration Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "usersgarage",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "main"),
        "",
        menuColour .. "Administration Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
-- RMenu.Add(
--     "adminmenu",
--     "staffmembers",
--     RageUI.CreateSubMenu(
--         RMenu:Get("adminmenu", "main"),
--         "",
--         menuColour .. "Administration Menu",
--         tRNG.getRageUIMenuWidth(),
--         tRNG.getRageUIMenuHeight(),
--         "banners",
--         "adminmenu"
--     )
-- )
RMenu.Add(
    "adminmenu",
    "searchoptions",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "main"),
        "",
        menuColour .. "Admin Player Search Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "functions",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "main"),
        "",
        menuColour .. "Admin Functions Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)

RMenu.Add(
    "adminmenu",
    "devfunctions",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "main"),
        "",
        menuColour .. "Dev Functions Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "communitypot",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "functions"),
        "",
        menuColour .. "Community Pot",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "ticketdata",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "functions"),
        "",
        menuColour .. "Ticket Leaderboard",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "moneymenu",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "functions"),
        "",
        menuColour .. "Money Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "submenu",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "players"),
        "",
        menuColour .. "Administration Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "searchname",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "searchoptions"),
        "",
        menuColour .. "Admin Player Search Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "searchtempid",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "searchoptions"),
        "",
        menuColour .. "Admin Player Search Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "searchpermid",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "searchoptions"),
        "",
        menuColour .. "Admin Player Search Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
-- RMenu.Add(
--     "adminmenu",
--     "searchhistory",
--     RageUI.CreateSubMenu(
--         RMenu:Get("adminmenu", "searchoptions"),
--         "",
--         menuColour .. "Admin Player Search Menu",
--         tRNG.getRageUIMenuWidth(),
--         tRNG.getRageUIMenuHeight(),
--         "banners",
--         "adminmenu"
--     )
-- )
RMenu.Add(
    "adminmenu",
    "criteriasearch",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "searchoptions"),
        "",
        menuColour .. "Administration Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "notespreviewban",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "players"),
        "",
        menuColour .. "Player Notes",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "banselection",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "notespreviewban"),
        "",
        menuColour .. "Ban Menu ~w~- ~o~[Tab] to search bans",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "generatedban",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "banselection"),
        "",
        menuColour .. "Ban Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "notesub",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "players"),
        "",
        menuColour .. "Player Notes",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "groups",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "submenu"),
        "",
        menuColour .. "Admin Groups Menu ~w~- ~o~[Tab] to search groups",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "addgroup",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "groups"),
        "",
        menuColour .. "Admin Groups Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu.Add(
    "adminmenu",
    "removegroup",
    RageUI.CreateSubMenu(
        RMenu:Get("adminmenu", "groups"),
        "",
        menuColour .. "Admin Groups Menu",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight(),
        "banners",
        "admin"
    )
)
RMenu:Get("adminmenu", "main")
local J = {
    ["Supporter"] = "Supporter",
    ["Premium"] = "Premium",
    ["Supreme"] = "Supreme",
    ["Kingpin"] = "King Pin",
    ["Rainmaker"] = "Rainmaker",
    ["Baller"] = "Baller",
    ["pov"] = "POV List",
    ["Copper"] = "Copper License",
    ["Weed"] = "Weed License",
    ["Limestone"] = "Limestone License",
    ["Gang"] = "Gang License",
    ["Cocaine"] = "Cocaine License",
    ["Meth"] = "Meth License",
    ["Heroin"] = "Heroin License",
    ["LSD"] = "LSD License",
    ["Rebel"] = "Rebel License",
    ["AdvancedRebel"] = "Advanced Rebel License",
    ["Advanced Gang"] = "Advanced Gang License",
    ["Gold"] = "Gold License",
    ["Diamond"] = "Diamond License",
    ["DJ"] = "DJ License",
    ["PilotLicense"] = "Pilot License",
    ["polblips"] = "Long Range Emergency Blips",
    ["Highroller"] = "Highrollers License",
    ["TutorialDone"] = "Completed Tutorial",
    ["Royal Mail Driver"] = "Royal Mail Driver",
    ["AA Mechanic"] = "AA Mechanic",
    ["Bus Driver"] = "Bus Driver",
    ["Deliveroo"] = "Deliveroo",
    ["Scuba Diver"] = "Scuba Diver",
    ["G4S Driver"] = "G4S Driver",
    ["Taco Seller"] = "Taco Seller",
    ["Burger Shot Cook"] = "Burger Shot Cook",
    ["Cinematic"] = "Cinematic Menu"
}
local function displayNotes(noteList)
    if noteslist == nil then
        RageUI.Separator("~HC_58~Player notes: Loading...")
    elseif #noteslist == 0 then
        RageUI.Separator("~HC_58~There are no player notes to display.")
    else
        RageUI.Separator("~HC_58~Player notes:")
        for _ = 1, #noteslist do
            RageUI.Separator(
                "~HC_4~[" ..
                    noteslist[_].id ..
                        "] ~HC_58~" .. noteslist[_].note .. " ~HC_4~Issued by UserID: " .. noteslist[_].author
            )
        end
    end
end
RegisterNetEvent("RNG:ReturnNearbyPlayers")
AddEventHandler(
    "RNG:ReturnNearbyPlayers",
    function(K)
        e = K
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if m ~= nil then
                local L = GetEntityCoords(tRNG.getPlayerPed())
                if tRNG.isInSpectate() then
                    L = GetFinalRenderedCamCoord()
                end
                TriggerServerEvent("RNG:GetNearbyPlayers", L, 250)
                Citizen.Wait(1000)
            end
        end
    end
)
local M = "No row in table value"
RegisterNetEvent("RNG:gotCommunityPotAmount")
AddEventHandler(
    "RNG:gotCommunityPotAmount",
    function(N)
        M = tonumber(N)
    end
)
local O = {}
RegisterNetEvent("RNG:GotTicketLeaderboard")
AddEventHandler(
    "RNG:GotTicketLeaderboard",
    function(P)
        O = P
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if m ~= nil then
                local P = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(m)))
                DrawMarker(
                    2,
                    P.x,
                    P.y,
                    P.z + 1.1,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    -180.0,
                    0.0,
                    0.4,
                    0.4,
                    0.4,
                    255,
                    255,
                    0,
                    125,
                    false,
                    true,
                    2,
                    false
                )
            end
        end
    end
)
function tRNG.GetStaffRankColor(rank)
    local colors = {
        ["Founder"] = "~r~",
        ["Lead Developer"] = "~HUD_COLOUR_NET_PLAYER1~",
        ["Operations Manager"] = "~HUD_COLOUR_NET_PLAYER29~",
        ["Community Manager"] = "~HUD_COLOUR_REDLIGHT~",
        ["Staff Manager"] = "~HUD_COLOUR_PINK~",
        ["Head Administrator"] = "~HUD_COLOUR_DAMAGE~",
        ["Senior Administrator"] = "~HUD_COLOUR_G10~",
        ["Administrator"] = "~HUD_COLOUR_ORANGE~",
        ["Senior Moderator"] = "~HUD_COLOUR_NET_PLAYER6~",
        ["Moderator"] = "~HUD_COLOUR_GREEN~",
        ["Support Team"] = "~HUD_COLOUR_GREENDARK~",
        ["Trial Staff"] = "~HUD_COLOUR_RADAR_ARMOUR~"
    }
    local defaultColor = "~w~"
    if colors[rank] then
        return colors[rank]
    else
        return defaultColor
    end
end

RageUI.CreateWhile(
    1.0,
    true,
    function()
        if tRNG.getStaffLevel() >= 1 then
            if RageUI.Visible(RMenu:Get("adminmenu", "main")) then
                RageUI.DrawContent(
                    {header = true, glare = false, instructionalButton = false},
                    function()
                        m = nil
                        o = {}
                        for y, Q in pairs(banreasons) do
                            Q.itemchecked = false
                        end
                        RageUI.ButtonWithStyle(
                            "All Players",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                            end,
                            RMenu:Get("adminmenu", "players")
                        )
                        RageUI.ButtonWithStyle(
                            "Nearby Players",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    local L = GetEntityCoords(tRNG.getPlayerPed())
                                    if tRNG.isInSpectate() then
                                        L = GetFinalRenderedCamCoord()
                                    end
                                    TriggerServerEvent("RNG:GetNearbyPlayers", L, 250)
                                end
                            end,
                            RMenu:Get("adminmenu", "closeplayers")
                        )
                        RageUI.ButtonWithStyle(
                            "Search Players",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                            end,
                            RMenu:Get("adminmenu", "searchoptions")
                        )
                        -- RageUI.ButtonWithStyle(
                        --     "Staff Members",
                        --     "See All Online Staff Members",
                        --     {RightLabel = "→→→"},
                        --     true,
                        --     function(R, S, T)
                        --     end,
                        --     RMenu:Get("adminmenu", "staffmembers")
                        -- )
                        RageUI.ButtonWithStyle(
                            "Functions",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                            end,
                            RMenu:Get("adminmenu", "functions")
                        )
                        RageUI.ButtonWithStyle(
                            "Settings",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                            end,
                            RMenu:Get("SettingsMenu", "MainMenu")
                        )
                    end
                )
            end
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "players")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    for y, Q in pairs(d) do
                        if not tRNG.isUserHidden(Q[3]) then
                            if i == false then
                                RageUI.ButtonWithStyle(
                                    "[" .. Q[2] .. "] " .. Q[1],
                                    "Name: " .. Q[1] .. "\n" ..
                                    Q[4] .. " hours\n" ..
                                    "PermID: " .. Q[3] .. "\n" ..
                                    "TempID: " .. Q[2],
                                    {RightLabel = "→→→"},
                                    true,
                                    function(R, S, T)
                                        if T then
                                            SelectedPlayer = d[y]
                                            j = Q[3]
                                            TriggerServerEvent("RNG:CheckPov", Q[3])
                                            TriggerServerEvent("RNG:getPlayerStats", Q[3])
                                        end
                                    end,
                                    RMenu:Get("adminmenu", "submenu")
                                )                                
                        else
                            if i == true then
                                RageUI.ButtonWithStyle(
                                    "~o~[" .. Q[2] .. "] " .. Q[1],
                                   "~O~Player is on POV List ".. Q[1] .. " (" .. Q[4] .. " hours) PermID: " .. Q[3] .. " TempID: " .. Q[2],
                                    {RightLabel = "→→→"},
                                    true,
                                    function(R, S, T)
                                        if T then
                                            SelectedPlayer = d[y]
                                            j = Q[3]
                                            TriggerServerEvent("RNG:CheckPov", Q[3])
                                            TriggerServerEvent("RNG:getPlayerStats", Q[3])
                                        end
                                    end,
                                    RMenu:Get("adminmenu", "submenu")
                                )
                            end
                        end
                    end
                end
            end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "closeplayers")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.Separator("Displaying players within 100m")
                    if next(e) then
                        for x, Q in pairs(e) do
                            if not tRNG.isUserHidden(Q[3]) then
                                RageUI.ButtonWithStyle(
                                    Q[1] .. " [" .. Q[2] .. "]",
                                    Q[1] .. " (" .. Q[4] .. " hours) PermID: " .. Q[3] .. " TempID: " .. Q[2],
                                    {RightLabel = "→→→"},
                                    true,
                                    function(R, S, T)
                                        if T then
                                            SelectedPlayer = e[x]
                                            j = Q[3]
                                            TriggerServerEvent("RNG:CheckPov", Q[3])
                                            TriggerServerEvent("RNG:getPlayerStats", Q[3])
                                        end
                                        if S then
                                            m = Q[2]
                                        end
                                    end,
                                    RMenu:Get("adminmenu", "submenu")
                                )
                            end
                        end
                    else
                        RageUI.Separator("~r~No players nearby!")
                    end
                end
            )
        end
        -- if RageUI.Visible(RMenu:Get("adminmenu", "staffmembers")) then
        --     RageUI.DrawContent(
        --         {header = true, glare = false, instructionalButton = false},
        --         function()
        --             for y, Q in pairs(d) do
        --                 if not tRNG.isUserHidden(Q[3]) and tRNG.clientGetPlayerIsStaff(Q[3]) then
        --                     RageUI.ButtonWithStyle(
        --                         Q[1] .. " [" .. Q[2] .. "]",
        --                         Q[1] .. " (" .. Q[4] .. " hours) PermID: " .. Q[3] .. " TempID: " .. Q[2],
        --                         {RightLabel = string.format("%s[%s]", tRNG.GetStaffRankColor(Q[5]), Q[5])},
        --                         true,
        --                         function(R, S, T)
        --                             if T then
        --                                 SelectedPlayer = d[y]
        --                                 j = Q[3]
        --                                 TriggerServerEvent("RNG:CheckPov", Q[3])
        --                                 TriggerServerEvent("RNG:getPlayerStats", Q[3])
        --                             end
        --                         end,
        --                         RMenu:Get("adminmenu", "submenu")
        --                     )
        --                 end
        --             end
        --         end
        --     )
        -- end
        if RageUI.Visible(RMenu:Get("adminmenu", "searchoptions")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    b = false
                    RageUI.ButtonWithStyle(
                        "Search by Name",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(R, S, T)
                        end,
                        RMenu:Get("adminmenu", "searchname")
                    )
                    RageUI.ButtonWithStyle(
                        "Search by Perm ID",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(R, S, T)
                        end,
                        RMenu:Get("adminmenu", "searchpermid")
                    )
                    RageUI.ButtonWithStyle(
                        "Search by Temp ID",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(R, S, T)
                        end,
                        RMenu:Get("adminmenu", "searchtempid")
                    )
                    -- RageUI.ButtonWithStyle(
                    --     "Search History",
                    --     nil,
                    --     {RightLabel = "→→→"},
                    --     true,
                    --     function(R, S, T)
                    --     end,
                    --     RMenu:Get("adminmenu", "searchhistory")
                    -- )
                    if tRNG.getStaffLevel() >= 6 then
                        RageUI.List(
                            "Search By Criteria",
                            D,
                            E,
                            nil,
                            {},
                            true,
                            function(S, T, U, V)
                                if V ~= E then
                                    E = V
                                elseif U then
                                    TriggerServerEvent("RNG:searchByCriteria", D[E])
                                end
                            end
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "functions")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if tRNG.getStaffLevel() >= 1 then
                        RageUI.ButtonWithStyle(
                            "Get Coords",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:GetCoords")
                                end
                            end
                        )
                        if tRNG.getStaffLevel() >= 1 then
                            RageUI.ButtonWithStyle(
                                "Get Vector 3 Coords",
                                nil,
                                {RightLabel = "→→→"},
                                true,
                                function(R, S, T)
                                    if T then
                                        TriggerServerEvent("RNG:GetVector3Coords")
                                    end
                                end
                            )
                        end
                        if tRNG.getStaffLevel() >= 1 then
                            RageUI.ButtonWithStyle(
                                "Get Vector 4 Coords",
                                nil,
                                {RightLabel = "→→→"},
                                true,
                                function(R, S, T)
                                    if T then
                                        TriggerServerEvent("RNG:GetVector4Coords")
                                    end
                                end
                            )
                        end
                        RageUI.ButtonWithStyle(
                            "Ticket Leaderboard",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:GetTicketLeaderboard")
                                end
                            end,
                            RMenu:Get("adminmenu", "ticketdata")
                        )
                        RageUI.List(
                            "Teleport",
                            G,
                            I,
                            nil,
                            {},
                            true,
                            function(U, V, W, X)
                                I = X
                                if W then
                                    tRNG.teleport2(vector3(H[I]), true)
                                end
                            end,
                            function()
                            end
                        )
                    end
                    if tRNG.getStaffLevel() >= 5 then
                        RageUI.ButtonWithStyle(
                            "TP To Coords",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:Tp2Coords")
                                end
                            end
                        )
                    end
                    if tRNG.getStaffLevel() >= 2 then
                        RageUI.ButtonWithStyle(
                            "Offline Ban",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    tRNG.clientPrompt(
                                        "Perm ID:",
                                        "",
                                        function(Y)
                                            banningPermID = Y
                                            banningName = "ID: " .. banningPermID
                                            z = nil
                                            o = {}
                                            for y, Q in pairs(banreasons) do
                                                Q.itemchecked = false
                                            end
                                            TriggerServerEvent("RNG:getNotes", banningPermID)
                                        end
                                    )
                                end
                            end,
                            RMenu:Get("adminmenu", "notespreviewban")
                        )
                    end
                    if tRNG.getStaffLevel() >= 5 then
                        RageUI.ButtonWithStyle(
                            "TP To Waypoint",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    local Z = GetFirstBlipInfoId(8)
                                    if Z ~= nil and DoesBlipExist(Z) then
                                        local _ = GetBlipInfoIdCoord(Z)
                                        for a0 = 1, 1000 do
                                            SetPedCoordsKeepVehicle(PlayerPedId(), _.x, _.y, a0 + 0.0)
                                            local a1, a2 = GetGroundZFor_3dCoord(_.x, _.y, a0 + 0.0)
                                            if a1 then
                                                SetPedCoordsKeepVehicle(PlayerPedId(), _.x, _.y, a0 + 0.0)
                                                break
                                            end
                                            Citizen.Wait(5)
                                        end
                                    else
                                        tRNG.notify("~r~You do not have a waypoint set")
                                    end
                                end
                            end
                        )
                    end
                    if tRNG.getStaffLevel() >= 7 then
                        RageUI.ButtonWithStyle(
                            "Unban",
                            "~r~This is Management+",
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:Unban")
                                end
                            end
                        )
                    end
                    if tRNG.getStaffLevel() >= 3 then
                        RageUI.ButtonWithStyle(
                            "Spawn Taxi",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    local currentTime = GetGameTimer() / 1000
                                    if currentTime - lastSpawnTime >= cooldownTime then
                                        local a3 = GetEntityCoords(tRNG.getPlayerPed())
                                        tRNG.spawnVehicle(
                                            "taxi",
                                            a3.x,
                                            a3.y,
                                            a3.z,
                                            GetEntityHeading(tRNG.getPlayerPed()),
                                            true,
                                            true,
                                            true
                                        )
                                        lastSpawnTime = currentTime
                                    else
                                        local remainingTime = cooldownTime - (currentTime - lastSpawnTime)
                                        tRNG.notify("~r~You must wait " .. math.ceil(remainingTime) .. " seconds before spawning another taxi.")
                                    end
                                end
                            end
                        )
                    end                    
                    if tRNG.getStaffLevel() >= 7 then
                        RageUI.ButtonWithStyle(
                            "Revive All Nearby",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    local a4 = tRNG.getPlayerCoords()
                                    for a5, a6 in pairs(GetActivePlayers()) do
                                        local a7 = GetPlayerServerId(a6)
                                        local a8 = GetPlayerPed(a6)
                                        if a7 ~= -1 and a8 ~= 0 then
                                            local a9 = GetEntityCoords(a8, true)
                                            if #(a4 - a9) < 50.0 then
                                                local aa = tRNG.clientGetUserIdFromSource(a7)
                                                if aa > 0 then
                                                    TriggerServerEvent("RNG:RevivePlayer", aa, true)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        )
                        if tRNG.getStaffLevel() >= 7 then
                            RageUI.ButtonWithStyle(
                                "Remove Warning",
                                nil,
                                {RightLabel = "→→→"},
                                true,
                                function(R, S, T)
                                    if T then
                                        tRNG.clientPrompt(
                                            "Enter The Warning ID",
                                            "",
                                            function(inputText)
                                                if inputText then
                                                    TriggerServerEvent("RNG:RemoveWarning", inputText)
                                                end
                                            end
                                        )
                                    end
                                end
                            )
                        end
                    end
                    if tRNG.getStaffLevel() >= 6 then
                        local ac = ""
                        if tRNG.hasStaffBlips() then
                            ac = "~r~Turn off blips"
                        else
                            ac = "~g~Turn on blips"
                        end
                        RageUI.ButtonWithStyle(
                            "Toggle Blips",
                            ac,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    tRNG.staffBlips(not tRNG.hasStaffBlips())
                                end
                            end
                        )
                        RageUI.ButtonWithStyle(
                            "Community Pot Menu",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:getCommunityPotAmount")
                                end
                            end,
                            RMenu:Get("adminmenu", "communitypot")
                        )
                        RageUI.ButtonWithStyle(
                            "RP Zones",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                            end,
                            RMenu:Get("rpzones", "mainmenu")
                        )
                    end
                    if tRNG.isDev() then
                        RageUI.ButtonWithStyle(
                            "Manage Money",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                            end,
                            RMenu:Get("adminmenu", "moneymenu")
                        )
                    end
                    if tRNG.getStaffLevel() >= 10 then
                        RageUI.ButtonWithStyle(
                            "Add Car",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:AddCar")
                                end
                            end,
                            RMenu:Get("adminmenu", "functions")
                        )
                    end
                    RageUI.Checkbox(
                        "Set Globally Hidden",
                        nil,
                        tRNG.isLocalPlayerHidden(),
                        {},
                        function()
                        end,
                        function()
                            TriggerServerEvent("RNG:setUserHidden", true)
                        end,
                        function()
                            TriggerServerEvent("RNG:setUserHidden", false)
                        end
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "moneymenu")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if B ~= nil and sn ~= nil and sc ~= nil and sb ~= nil and sw ~= nil and sch ~= nil then
                        RageUI.Separator("Name: ~y~" .. sn)
                        RageUI.Separator("PermID: ~y~" .. B)
                        RageUI.Separator("TempID: ~y~" .. sc)
                        RageUI.Separator("Bank Balance: ~g~£" .. sb)
                        RageUI.Separator("Cash Balance: ~g~£" .. sw)
                        RageUI.Separator("Casino Chips: ~g~" .. sch)
                        RageUI.Separator("")
                        RageUI.ButtonWithStyle(
                            "Bank Balance ~g~+",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(ad, U, V)
                                if V then
                                    tRNG.clientPrompt(
                                        "Amount:",
                                        "",
                                        function(ae)
                                            if tonumber(ae) then
                                                TriggerServerEvent("RNG:ManagePlayerBank", B, ae, "Increase")
                                            else
                                                tRNG.notify("~r~Invalid Amount")
                                            end
                                        end
                                    )
                                end
                            end
                        )
                        RageUI.ButtonWithStyle(
                            "Bank Balance ~r~-",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(ad, U, V)
                                if V then
                                    tRNG.clientPrompt(
                                        "Amount:",
                                        "",
                                        function(ae)
                                            if tonumber(ae) then
                                                TriggerServerEvent("RNG:ManagePlayerBank", B, ae, "Decrease")
                                            else
                                                tRNG.notify("~r~Invalid Amount")
                                            end
                                        end
                                    )
                                end
                            end
                        )
                        RageUI.ButtonWithStyle(
                            "Cash Balance ~g~+~w~",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(ad, U, V)
                                if V then
                                    tRNG.clientPrompt(
                                        "Amount:",
                                        "",
                                        function(af)
                                            if tonumber(af) then
                                                TriggerServerEvent("RNG:ManagePlayerCash", B, af, "Increase")
                                            else
                                                tRNG.notify("~r~Invalid Amount")
                                            end
                                        end
                                    )
                                end
                            end
                        )
                        RageUI.ButtonWithStyle(
                            "Cash Balance ~r~-",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(ad, U, V)
                                if V then
                                    tRNG.clientPrompt(
                                        "Amount:",
                                        "",
                                        function(af)
                                            if tonumber(af) then
                                                TriggerServerEvent("RNG:ManagePlayerCash", B, af, "Decrease")
                                            else
                                                tRNG.notify("~r~Invalid Amount")
                                            end
                                        end
                                    )
                                end
                            end
                        )
                        RageUI.ButtonWithStyle(
                            "Casino Chips ~g~+",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(ad, U, V)
                                if V then
                                    tRNG.clientPrompt(
                                        "Amount:",
                                        "",
                                        function(af)
                                            if tonumber(af) then
                                                TriggerServerEvent("RNG:ManagePlayerChips", B, af, "Increase")
                                            else
                                                tRNG.notify("~r~Invalid Amount")
                                            end
                                        end
                                    )
                                end
                            end
                        )
                        RageUI.ButtonWithStyle(
                            "Casino Chips ~r~-",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(ad, U, V)
                                if V then
                                    tRNG.clientPrompt(
                                        "Amount:",
                                        "",
                                        function(af)
                                            if tonumber(af) then
                                                TriggerServerEvent("RNG:ManagePlayerChips", B, af, "Decrease")
                                            else
                                                tRNG.notify("~r~Invalid Amount")
                                            end
                                        end
                                    )
                                end
                            end
                        )
                    end
                    RageUI.ButtonWithStyle(
                        "Choose PermID",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(ad, U, V)
                            if V then
                                tRNG.clientPrompt(
                                    "PermID:",
                                    "",
                                    function(ae)
                                        if tonumber(ae) then
                                            B = tonumber(ae)
                                            tRNG.notify("~g~PermID Set To " .. ae)
                                            TriggerServerEvent("RNG:getUserinformation", B)
                                        else
                                            tRNG.notify("~r~Invalid PermID")
                                            B = nil
                                        end
                                    end
                                )
                            end
                        end,
                        RMenu:Get("adminmenu", "moneymenu")
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "ticketdata")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if not O or next(O) == nil then
                        RageUI.Separator("~r~No Tickets")
                    else
                        for a0, ag in pairs(O) do
                            if ag and ag.username and ag.ticket_count and ag.user_id then
                                RageUI.Separator(ag.username .. " - " .. ag.ticket_count)
                            else
                                RageUI.Separator("~r~No Tickets")
                            end
                        end
                    end
                    RageUI.ButtonWithStyle(
                        "View Leaderboard",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(a0, a0, ah)
                            if ah then
                                TriggerServerEvent("RNG:GetTicketLeaderboard")
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "View Self",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(a0, a0, ah)
                            if ah then
                                TriggerServerEvent("RNG:GetTicketLeaderboard", true)
                            end
                        end
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "communitypot")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.Separator("Community Pot Balance: ~g~£" .. getMoneyStringFormatted(M))
                    RageUI.ButtonWithStyle(
                        "Deposit",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(ai, aj, v)
                            if v then
                                tRNG.clientPrompt(
                                    "Enter Amount:",
                                    "",
                                    function(N)
                                        if tonumber(N) then
                                            TriggerServerEvent("RNG:tryDepositCommunityPot", N)
                                        else
                                            tRNG.notify("~r~Invalid Amount.")
                                        end
                                    end
                                )
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Withdraw",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(ai, aj, v)
                            if v then
                                tRNG.clientPrompt(
                                    "Enter Amount:",
                                    "",
                                    function(N)
                                        if tonumber(N) then
                                            TriggerServerEvent("RNG:tryWithdrawCommunityPot", N)
                                        else
                                            tRNG.notify("~r~Invalid Amount.")
                                        end
                                    end
                                )
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Distribute to All Online Players",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(ai, aj, v)
                            if v then
                                tRNG.clientPrompt(
                                    "Enter Amount:",
                                    "",
                                    function(N)
                                        if tonumber(N) then
                                            TriggerServerEvent("RNG:distributeCommunityPot", N)
                                        else
                                            tRNG.notify("~r~Invalid amount.")
                                        end
                                    end
                                )
                            end
                        end
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "searchpermid")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if b == false then
                        searchforPermID = tRNG.KeyboardInput("Enter Perm ID", "", 10)
                        if searchforPermID == nil then
                            searchforPermID = ""
                        end
                    end
                    for y, Q in pairs(d) do
                        b = true
                        if string.find(Q[3], searchforPermID) then
                            if not tRNG.isUserHidden(Q[3]) then
                                RageUI.ButtonWithStyle(
                                    Q[1] .. " [" .. Q[2] .. "]",
                                    Q[1] .. " (" .. Q[4] .. " hours) PermID: " .. Q[3] .. " TempID: " .. Q[2],
                                    {RightLabel = "→→→"},
                                    true,
                                    function(R, S, T)
                                        if T then
                                            SelectedPlayer = d[y]
                                            TriggerServerEvent("RNG:CheckPov", Q[3])
                                            TriggerServerEvent("RNG:getPlayerStats", Q[3])
                                            v = Q[3]
                                            w[x] = v
                                            x = x + 1
                                        end
                                    end,
                                    RMenu:Get("adminmenu", "submenu")
                                )
                            end
                        end
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "searchtempid")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if b == false then
                        searchid = tRNG.KeyboardInput("Enter Temp ID", "", 10)
                        if searchid == nil then
                            searchid = ""
                        end
                    end
                    for y, Q in pairs(d) do
                        b = true
                        if string.find(Q[2], searchid) then
                            if not tRNG.isUserHidden(Q[3]) then
                                RageUI.ButtonWithStyle(
                                    Q[1] .. " [" .. Q[2] .. "]",
                                    Q[1] .. " (" .. Q[4] .. " hours) PermID: " .. Q[3] .. " TempID: " .. Q[2],
                                    {RightLabel = "→→→"},
                                    true,
                                    function(R, S, T)
                                        if T then
                                            SelectedPlayer = d[y]
                                            TriggerServerEvent("RNG:CheckPov", Q[3])
                                            TriggerServerEvent("RNG:getPlayerStats", Q[3])
                                            v = Q[2]
                                            w[x] = v
                                            x = x + 1
                                        end
                                    end,
                                    RMenu:Get("adminmenu", "submenu")
                                )
                            end
                        end
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "searchname")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if b == false then
                        SearchName = tRNG.KeyboardInput("Enter Name", "", 10)
                        if SearchName == nil then
                            SearchName = ""
                        end
                    end
                    for y, Q in pairs(d) do
                        b = true
                        if string.find(string.lower(Q[1]), string.lower(SearchName)) then
                            if not tRNG.isUserHidden(Q[3]) then
                                RageUI.ButtonWithStyle(
                                    Q[1] .. " [" .. Q[2] .. "]",
                                    Q[1] .. " (" .. Q[4] .. " hours) PermID: " .. Q[3] .. " TempID: " .. Q[2],
                                    {RightLabel = "→→→"},
                                    true,
                                    function(R, S, T)
                                        if T then
                                            SelectedPlayer = d[y]
                                            TriggerServerEvent("RNG:CheckPov", Q[3])
                                            TriggerServerEvent("RNG:getPlayerStats", Q[3])
                                            v = Q[1]
                                            w[x] = v
                                            x = x + 1
                                        end
                                    end,
                                    RMenu:Get("adminmenu", "submenu")
                                )
                            end
                        end
                    end
                end
            )
        end
        -- if RageUI.Visible(RMenu:Get("adminmenu", "searchhistory")) then
        --     RageUI.DrawContent(
        --         {header = true, glare = false, instructionalButton = false},
        --         function()
        --             for y, Q in pairs(d) do
        --                 if x > 1 then
        --                     for ak = #w, #w - 10, -1 do
        --                         if w[ak] then
        --                             if tonumber(w[ak]) == Q[3] or tonumber(w[ak]) == Q[2] or w[ak] == Q[1] then
        --                                 RageUI.ButtonWithStyle(
        --                                     "[" .. Q[3] .. "] " .. Q[1],
        --                                     Q[1] .. " Perm ID: " .. Q[3] .. " Temp ID: " .. Q[2],
        --                                     {RightLabel = "→→→"},
        --                                     true,
        --                                     function(R, S, T)
        --                                         if T then
        --                                             SelectedPlayer = d[y]
        --                                             TriggerServerEvent("RNG:CheckPov", Q[3])
        --                                         end
        --                                     end,
        --                                     RMenu:Get("adminmenu", "submenu")
        --                                 )
        --                             end
        --                         end
        --                     end
        --                 end
        --             end
        --         end
        --     )
        -- end
        RageUI.IsVisible(
            RMenu:Get("adminmenu", "extrainfo"),
            true,
            false,
            true,
            function()
                RageUI.Separator("~o~Player Stats")
                if kills and deaths and kdRatio then
                    RageUI.Separator("Kills: " .. kills .. " / Deaths: " .. deaths .. " (" .. kdRatio .. " KD)")
                else
                    RageUI.Separator("~r~Player has no kills or deaths")
                end
                local source = source
                local user_id = tRNG.getUserId(source)
                local jobType = tRNG.getJobType(user_id)

                RageUI.Separator("~o~Job Information")

                if jobType == "metpd" then
                    RageUI.Separator("Part Of The Met Police\n Rank: " .. tRNG.getPoliceRank())
                    RageUI.Separator("")
                elseif jobType == "nhs" then
                    RageUI.Separator("Part Of The National Health Service")
                    RageUI.Separator("")
                elseif jobType == "lfb" then
                    RageUI.Separator("Part Of The London Fire Brigade")
                    RageUI.Separator("")
                elseif jobType == "hmp" then
                    RageUI.Separator("His Majesty's Prison Service")
                    RageUI.Separator("Part Of His Majesty's Prison Service\n Rank: " .. tRNG.getHmpRank())
                    RageUI.Separator("")
                else
                    RageUI.Separator("~r~User Has No Job Information Avaliable")
                end
            end,
            RMenu:Get("adminmenu", "submenu"),
            function()
            end
        )
        if RageUI.Visible(RMenu:Get("adminmenu", "criteriasearch")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if next(F) then
                        for t, N in pairs(F) do
                            if not tRNG.isUserHidden(N[3]) then
                                RageUI.ButtonWithStyle(
                                    (N[5] and "~o~" or "") .. N[1] .. " [" .. N[2] .. "]",
                                    N[1] .. " (" .. N[4] .. " hours) PermID: " .. N[3] .. " TempID: " .. N[2],
                                    {RightLabel = "→→→"},
                                    true,
                                    function(P, Q, R)
                                        if R then
                                            SelectedPlayer = F[t]
                                            TriggerServerEvent("RNG:CheckPov", N[3])
                                            TriggerServerEvent("RNG:getPlayerStats", N[3])
                                            o = N[1]
                                            s[r] = o
                                            r = r + 1
                                        end
                                    end,
                                    RMenu:Get("adminmenu", "submenu")
                                )
                            end
                        end
                    else
                        RageUI.Separator("~r~There are currently no players that match criteria.")
                        RageUI.Separator("~r~" .. D[E])
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "submenu")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    m = nil
                    if tRNG.isUserHidden(SelectedPlayer[3]) then
                        RageUI.ActuallyCloseAll()
                    end
                    if i == nil then
                        RageUI.Separator("~y~Player must provide POV on request: Loading...")
                    elseif i == true then
                        RageUI.Separator("~y~Player must provide POV on request: ~g~true")
                    elseif i == false then
                        RageUI.Separator("~y~Player must provide POV on request: ~r~false")
                    end
                    if tRNG.getStaffLevel() >= 1 then
                        RageUI.ButtonWithStyle(
                            "Extra Information",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                            end,
                            RMenu:Get("adminmenu", "extrainfo")
                        )
                    end
                    if tRNG.getStaffLevel() >= 1 then
                        RageUI.ButtonWithStyle(
                            "Players Notes",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:getNotes", SelectedPlayer[3])
                                end
                            end,
                            RMenu:Get("adminmenu", "notesub")
                        )
                        RageUI.ButtonWithStyle(
                            "Kick Player",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    local al = GetPlayerServerId(PlayerId())
                                    TriggerServerEvent("RNG:KickPlayer", SelectedPlayer[3], SelectedPlayer[2])
                                end
                            end,
                            RMenu:Get("adminmenu", "submenu")
                        )
                    end
                    if tRNG.getStaffLevel() >= 2 then
                        RageUI.ButtonWithStyle(
                            "Ban Player",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    banningPermID = SelectedPlayer[3]
                                    banningName = SelectedPlayer[1]
                                    z = nil
                                    TriggerServerEvent("RNG:getNotes", SelectedPlayer[3])
                                    o = {}
                                    for y, Q in pairs(banreasons) do
                                        Q.itemchecked = false
                                    end
                                end
                            end,
                            RMenu:Get("adminmenu", "notespreviewban")
                        )
                        RageUI.ButtonWithStyle(
                            "Spectate",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    if tonumber(SelectedPlayer[2]) ~= GetPlayerServerId(PlayerId()) then
                                        if not tRNG.isInSpectate() then
                                            inRedZone = false
                                            TriggerServerEvent("RNG:spectatePlayer", SelectedPlayer[3])
                                            c = true
                                            RageUI.Text({message = string.format("~r~Press [E] to stop spectating.")})
                                        else
                                            tRNG.notify("You are already spectating a player.")
                                        end
                                    else
                                        tRNG.notify("You cannot spectate yourself.")
                                    end
                                end
                            end,
                            RMenu:Get("adminmenu", "submenu")
                        )
                    end
                    if tRNG.getStaffLevel() >= 3 then
                        RageUI.ButtonWithStyle(
                            "Revive",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:RevivePlayer", SelectedPlayer[3])
                                end
                            end,
                            RMenu:Get("adminmenu", "submenu")
                        )
                    end
                    -- if tRNG.getStaffLevel() >= 7 then
                    --     RageUI.ButtonWithStyle(
                    --         "Give Armour",
                    --         "~b~Gives The Current User 100% Armour",
                    --         {RightLabel = "→→→"},
                    --         true,
                    --         function(R, S, T)
                    --             if T then
                    --                 TriggerServerEvent("RNG:GivePlayerArmour", SelectedPlayer[3])
                    --             end
                    --         end,
                    --         RMenu:Get("adminmenu", "submenu")
                    --     )
                    -- end
                    if tRNG.getStaffLevel() >= 1 then
                        RageUI.List(
                            "Teleport",
                            a209,
                            a735,
                            nil,
                            {},
                            true,
                            function(U, V, W, X)
                                a735 = X
                                if W then
                                    local selectedEvent = teleportOptionsEvents[a735]
                                    if selectedEvent then
                                        if selectedEvent == "RNG:Teleport2AdminIsland" then
                                            inRedZone = false
                                            savedCoordsBeforeAdminZone = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(SelectedPlayer[2])))
                                            TriggerServerEvent(selectedEvent, SelectedPlayer[2])
                                        elseif selectedEvent == "RNG:TeleportBackFromAdminZone" then
                                            TriggerServerEvent(selectedEvent, SelectedPlayer[2], savedCoordsBeforeAdminZone)
                                        else
                                            TriggerServerEvent(selectedEvent, SelectedPlayer[2])
                                        end
                                    end
                                end
                            end
                        )
                        RageUI.List(
                            "Teleport To",
                            a68,
                            a74,
                            nil,
                            {},
                            true,
                            function(U, V, W, X)
                                a74 = X
                                if W then
                                    TriggerServerEvent("RNG:TeleportPlayer",SelectedPlayer[2], vector3(a69[a74]))
                                end
                            end
                        )
                        RageUI.ButtonWithStyle(
                            "Freeze",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    local al = GetPlayerServerId(PlayerId())
                                    isFrozen = not isFrozen
                                    TriggerServerEvent("RNG:FreezeSV", SelectedPlayer[2], isFrozen)
                                end
                            end,
                            RMenu:Get("adminmenu", "submenu")
                        )
                    end
                    if tRNG.getStaffLevel() >= 7 then
                        RageUI.ButtonWithStyle(
                            "Slap",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    local al = GetPlayerServerId(PlayerId())
                                    TriggerServerEvent("RNG:SlapPlayer", SelectedPlayer[2])
                                end
                            end,
                            RMenu:Get("adminmenu", "submenu")
                        )
                        local source = source
                        local user_id = tRNG.getUserId(source)
                        local jobType1 = tRNG.getJobType(user_id)
                        local jobLabel = SelectedPlayer[1] .. " is Not Clocked On"
                        if jobType1 == "metpd" then
                            jobLabel = "~r~Job: ~w~METPD ~b~Rank: ~w~" .. tRNG.getPoliceRank()
                        elseif jobType1 == "hmp" then
                            jobLabel = "~r~Job: ~w~HMP ~b~Rank: ~w~" .. tRNG.getHMPRank()
                        elseif jobType1 == "nhs" then
                            jobLabel = "~r~Job: ~w~NHS"
                        elseif jobType1 == "lfb" then
                            jobLabel = "~r~Job: ~w~LFB"
                        end
                        RageUI.Button(
                            "Force Clock Off",
                            jobLabel,
                            a100 and {RightLabel = ""} or {RightLabel = "→→→"},
                            jobType1 == "metpd" or jobType1 == "hmp" or jobType1 == "nhs" or jobType1 == "lfb",
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:ForceClockOff", SelectedPlayer[2])
                                    a100 = true
                                    SetTimeout(
                                        20000,
                                        function()
                                            a100 = false
                                        end
                                    )
                                end
                            end,
                            RMenu:Get("adminmenu", "submenu")
                        )
                    end
                    if tRNG.getStaffLevel() >= 1 then
                        RageUI.ButtonWithStyle(
                            "Open F10 Warning Log",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    ExecuteCommand("sw " .. SelectedPlayer[3])
                                end
                            end,
                            RMenu:Get("adminmenu", "submenu")
                        )
                    end
                    if tRNG.getStaffLevel() >= 2 then
                        RageUI.ButtonWithStyle(
                            "Take Screenshot",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    local al = GetPlayerServerId(PlayerId())
                                    TriggerServerEvent("RNG:RequestScreenshot", SelectedPlayer[2])
                                end
                            end,
                            RMenu:Get("adminmenu", "submenu")
                        )
                        RageUI.Button(
                            "Take Video",
                            "This will take a 15 seccond video of " .. SelectedPlayer[1] .. "'s screen",
                            C and {RightLabel = ""} or {RightLabel = "→→→"},
                            not C,
                            function(R, S, T)
                                if T then
                                    local al = GetPlayerServerId(PlayerId())
                                    TriggerServerEvent("RNG:RequestVideo", SelectedPlayer[2])
                                    C = true
                                    SetTimeout(
                                        20000,
                                        function()
                                            C = false
                                        end
                                    )
                                end
                            end,
                            RMenu:Get("adminmenu", "submenu")
                        )
                    end
                    if tRNG.getStaffLevel() >= 6 then
                        RageUI.ButtonWithStyle(
                            "Request Account Info",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:requestAccountInfosv", SelectedPlayer[3])
                                end
                            end,
                            RMenu:Get("adminmenu", "submenu")
                        )
                        if tRNG.getStaffLevel() >= 7 then
                        RageUI.ButtonWithStyle("See Groups", "~r~This is Management+ ~w~Name: "..SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:GetGroups", SelectedPlayer[3])
                                    A = ""
                                end
                            end,
                            RMenu:Get("adminmenu", "groups")
                        )
                    end
                end
            end)
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "notespreviewban")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if tRNG.getStaffLevel() >= 2 then
                        displayNotes(noteslist)
                        RageUI.ButtonWithStyle(
                            "~g~Continue to Ban",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                            end,
                            RMenu:Get("adminmenu", "banselection")
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "banselection")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if tRNG.getStaffLevel() >= 2 then
                        if IsControlJustPressed(0, 37) then
                            tRNG.clientPrompt(
                                "Search for: ",
                                "",
                                function(ao)
                                    if ao ~= "" then
                                        z = string.lower(ao)
                                    else
                                        z = nil
                                    end
                                end
                            )
                        end
                        for y, Q in pairs(banreasons) do
                            local function ap()
                                o[Q.id] = true
                            end
                            local function aq()
                                o[Q.id] = nil
                            end
                            if z == nil or string.match(string.lower(Q.id), z) or string.match(string.lower(Q.name), z) then
                                RageUI.Checkbox(
                                    Q.name,
                                    Q.bandescription,
                                    Q.itemchecked,
                                    {RightBadge = RageUI.CheckboxStyle.Tick},
                                    function(R, T, S, ar)
                                        if T then
                                            if Q.itemchecked then
                                                ap()
                                            end
                                            if not Q.itemchecked then
                                                aq()
                                            end
                                        end
                                        Q.itemchecked = ar
                                    end
                                )
                            end
                        end
                        RageUI.ButtonWithStyle(
                            "Confirm Ban",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    TriggerServerEvent("RNG:GenerateBan", banningPermID, o)
                                end
                            end,
                            RMenu:Get("adminmenu", "generatedban")
                        )
                        RageUI.ButtonWithStyle(
                            "Cancel Ban",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    o = {}
                                    for y, Q in pairs(banreasons) do
                                        Q.itemchecked = false
                                    end
                                    RageUI.ActuallyCloseAll()
                                end
                            end
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "generatedban")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if tRNG.getStaffLevel() >= 2 then
                        if next(o) then
                            if q == "N/A" then
                                RageUI.Separator("~g~Generating ban info, please wait...")
                            else
                                RageUI.Separator(
                                    "~r~You are about to ban " ..
                                        banningName .. " for " .. (a9 and "Permanent" or p .. " hrs"),
                                    function()
                                    end
                                )
                                RageUI.Separator(
                                    "~w~For the following reason(s):",
                                    function()
                                    end
                                )
                                for y, Q in pairs(SeparatorMsg) do
                                    RageUI.Separator(
                                        Q,
                                        function()
                                        end
                                    )
                                end
                                local a9 = false
                                if p == -1 then
                                    a9 = true
                                end
                                -- RageUI.Separator("~w~Total Length: " .. (a9 and "Permanent" or p .. " hrs"))
                                RageUI.ButtonWithStyle(
                                    "Cancel",
                                    "",
                                    {RightLabel = "→→→"},
                                    true,
                                    function(R, S, T)
                                        if T then
                                            o = {}
                                            for y, Q in pairs(banreasons) do
                                                Q.itemchecked = false
                                            end
                                            RageUI.ActuallyCloseAll()
                                        end
                                    end
                                )
                                RageUI.ButtonWithStyle(
                                    "Confirm",
                                    "",
                                    {RightLabel = "→→→"},
                                    true,
                                    function(R, S, T)
                                        if T then
                                            TriggerServerEvent("RNG:BanPlayer", banningPermID, p, q, u)
                                        end
                                    end
                                )
                            end
                        else
                            RageUI.Separator(
                                "You must select at least one ban reason.",
                                function()
                                end
                            )
                        end
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "notesub")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    displayNotes(noteList)
                    if tRNG.getStaffLevel() >= 1 then
                        RageUI.ButtonWithStyle(
                            "Add To Notes:",
                            SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    tRNG.clientPrompt(
                                        "Add To Notes: ",
                                        "",
                                        function(as)
                                            if as ~= "" then
                                                if #noteslist ~= 0 then
                                                    noteslist[#noteslist + 1] = {
                                                        id = #noteslist + 1,
                                                        note = as,
                                                        author = tRNG.getUserId()
                                                    }
                                                else
                                                    noteslist = {{id = 1, note = as, author = tRNG.getUserId()}}
                                                end
                                                TriggerServerEvent(
                                                    "RNG:updatePlayerNotes",
                                                    SelectedPlayer[3],
                                                    noteslist
                                                )
                                            end
                                        end
                                    )
                                end
                            end
                        )
                        RageUI.ButtonWithStyle(
                            "Remove Note",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(R, S, T)
                                if T then
                                    tRNG.clientPrompt(
                                        "Type the ID of the note",
                                        "",
                                        function(as)
                                            if as ~= "" then
                                                as = tonumber(as)
                                                local at = {}
                                                local au = false
                                                for an = 1, #noteslist do
                                                    if noteslist[an].id == as then
                                                        for av = 1, #noteslist do
                                                            if av ~= an then
                                                                at[#at + 1] = {
                                                                    id = #at + 1,
                                                                    note = noteslist[av].note,
                                                                    author = noteslist[av].author
                                                                }
                                                            end
                                                        end
                                                        au = true
                                                        break
                                                    end
                                                end
                                                if au == true then
                                                    if #at == 0 then
                                                        at = nil
                                                        noteslist = {}
                                                    else
                                                        noteslist = at
                                                    end
                                                    TriggerServerEvent("RNG:updatePlayerNotes", SelectedPlayer[3], at)
                                                end
                                            end
                                        end
                                    )
                                end
                            end
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "groups")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if tRNG.getStaffLevel() >= 7 then
                        if IsControlJustPressed(0, 37) then
                            tRNG.clientPrompt(
                                "Search for: ",
                                "",
                                function(a6)
                                    A = string.lower(a6)
                                end
                            )
                        end
                        for y, a6 in pairs(J) do
                            if A == "" or string.find(string.lower(a6), string.lower(A)) then
                                if g[y] then
                                    RageUI.ButtonWithStyle(
                                        "~g~" .. a6,
                                        "~g~User has this group.",
                                        {RightLabel = "→→→"},
                                        true,
                                        function(U, V, W)
                                            if W then
                                                h = y
                                            end
                                        end,
                                        RMenu:Get("adminmenu", "removegroup")
                                    )
                                else
                                    RageUI.ButtonWithStyle(
                                        "~r~" .. a6,
                                        "~r~User does not have this group.",
                                        {RightLabel = "→→→"},
                                        true,
                                        function(U, V, W)
                                            if W then
                                                h = y
                                            end
                                        end,
                                        RMenu:Get("adminmenu", "addgroup")
                                    )
                                end
                            end
                        end
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "addgroup")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Add this group to user",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(R, S, T)
                            if T then
                                TriggerServerEvent("RNG:AddGroup", j, h)
                            end
                        end,
                        RMenu:Get("adminmenu", "groups")
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("adminmenu", "removegroup")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Remove user from group",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(R, S, T)
                            if T then
                                TriggerServerEvent("RNG:RemoveGroup", j, h)
                            end
                        end,
                        RMenu:Get("adminmenu", "groups")
                    )
                end
            )
        end
    end
)
RegisterCommand(
    "cleanup",
    function()
        TriggerServerEvent("RNG:CleanAll")
    end
)
RegisterNetEvent("RNG:SlapPlayer")
AddEventHandler(
    "RNG:SlapPlayer",
    function()
        SetEntityHealth(PlayerPedId(), 0)
    end
)
frozen = false
RegisterNetEvent(
    "RNG:Freeze",
    function()
        local aw = tRNG.getPlayerPed()
        if IsPedSittingInAnyVehicle(aw) then
            local ax = GetVehiclePedIsIn(aw, false)
            TaskLeaveVehicle(aw, ax, 4160)
        end
        if not frozen then
            FreezeEntityPosition(aw, true)
            frozen = true
            while frozen do
                tRNG.setWeapon(aw, "WEAPON_UNARMED", true)
                Wait(0)
            end
        else
            FreezeEntityPosition(aw, false)
            frozen = false
        end
    end
)
RegisterNetEvent(
    "RNG:sendNotes",
    function(as)
        as = json.decode(as)
        if as == nil then
            noteslist = {}
        else
            noteslist = as
        end
    end
)
RegisterNetEvent("RNG:ReturnPov")
AddEventHandler(
    "RNG:ReturnPov",
    function(ay)
        i = ay
    end
)
RegisterNetEvent("RNG:ReturnPlayerGarage")
AddEventHandler(
    "RNG:ReturnPlayerGarage",
    function(a10)
        an = a10
    end
)
RegisterNetEvent("RNG:GotGroups")
AddEventHandler(
    "RNG:GotGroups",
    function(az)
        g = az
    end
)
RegisterNetEvent("RNG:getPlayersInfo")
AddEventHandler(
    "RNG:getPlayersInfo",
    function(aA, aB)
        d = aA
        n = aB
        RageUI.Visible(RMenu:Get("adminmenu", "main"), not RageUI.Visible(RMenu:Get("adminmenu", "main")))
    end
)
RegisterNetEvent("RNG:RecieveBanPlayerData")
AddEventHandler(
    "RNG:RecieveBanPlayerData",
    function(aC, aD, aE, aF)
        p = aC
        q = aD
        SeparatorMsg = aE
        u = aF
        RageUI.Visible(RMenu:Get("adminmenu", "generatedban"), true)
    end
)
RegisterNetEvent("RNG:receivedUserInformation")
AddEventHandler(
    "RNG:receivedUserInformation",
    function(aG, aH, aI, aJ, aK)
        if aG == nil or aH == nil or aI == nil or aJ == nil or aK == nil then
            B = nil
            tRNG.notify("~r~Player does not exist.")
            return
        end
        sc = aG
        sn = aH
        sb = getMoneyStringFormatted(aI)
        sw = getMoneyStringFormatted(aJ)
        sch = getMoneyStringFormatted(aK)
    end
)
function Draw2DText(U, V, aL, aM)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(aM, aM)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(aL)
    DrawText(U, V)
end
RegisterNetEvent("RNG:OpenAdminMenu")
AddEventHandler(
    "RNG:OpenAdminMenu",
    function(aN)
        if aN then
            if not tRNG.inEvent() then
                TriggerServerEvent("RNG:GetPlayerData")
                TriggerServerEvent("RNG:GetNearbyPlayerData")
                TriggerServerEvent("RNG:getAdminLevel")
            else
                tRNG.notify("~y~You cannot open the admin menu whilst in an event.")
            end
        end
    end
)
function DrawHelpMsg(aO)
    SetTextComponentFormat("STRING")
    AddTextComponentString(aO)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function bank_drawTxt(U, V, aP, a0, aM, aL, H, v, aQ, Y, aR)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(aM, aM)
    SetTextColour(H, v, aQ, Y)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if aR then
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(aL)
    DrawText(U - aP / 2, V - a0 / 2 + 0.005)
end
function func_checkSpectatorMode()
    if c then
        if IsControlJustPressed(0, 51) then
            c = false
            TriggerServerEvent("RNG:stopSpectatePlayer")
        end
    end
end
tRNG.createThreadOnTick(func_checkSpectatorMode)
RegisterNetEvent(
    "RNG:takeClientScreenshotAndUpload",
    function(aS)
        local aS = aS
        exports["els"]:requestScreenshotUpload(
            aS,
            "files[]",
            function(aT)
            end
        )
    end
)
RegisterNetEvent(
    "RNG:returnCriteriaSearch",
    function(az)
        F = az
        RageUI.Visible(RMenu:Get("adminmenu", "criteriasearch"), true)
    end
)
RegisterNetEvent(
    "RNG:takeClientVideoAndUpload",
    function(aS)
        local aS = aS
        exports["els"]:requestVideoUpload(
            aS,
            "files[]",
            {headers = {}, isVideo = true, isManual = true, encoding = "mp4"},
            function(aU)
            end
        )
    end
)
local aV = 0
local function aW()
    local aX = GetResourceState("els")
    if aX == "started" then
        exports["els"]:requestKeepAlive(
            function(aY)
                if not aY then
                    aV = GetGameTimer()
                end
            end
        )
    end
    if GetGameTimer() - aV > 60000 then
        TriggerServerEvent("RNG:acType16")
    end
end
AddEventHandler(
    "RNG:onClientSpawn",
    function(aZ, a4)
        if a4 then
            aV = GetGameTimer()
            while true do
                aW()
                Citizen.Wait(5000)
            end
        end
    end
)

RegisterNetEvent(
    "RNG:phoneNotification",
    function(reason, title)
        exports["lb-phone"]:SendNotification(
            {
                app = "Wallet",
                title = title,
                content = reason
            }
        )
    end
)

-- RegisterNetEvent("RNG:sendAnticheatData")
-- AddEventHandler("RNG:sendAnticheatData", function(admin_name, players, table, types)
--     acbannedplayerstable = table
--     acbannedplayers = players
--     acadminname = admin_name
--     anticheatTypes = types
-- end)

RegisterNetEvent("RNG:receivePlayerStats")
AddEventHandler(
    "RNG:receivePlayerStats",
    function(k, d, kd)
        kills, deaths, kdRatio = k, d, kd
    end
)
