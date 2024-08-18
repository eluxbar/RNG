local a = nil
local b = {}
local c = ""
IsInWardrobeMenu = false
local function d()
    if next(b) then
        return true
    end
    return false
end
RMenu.Add(
    "rngwardrobe",
    "mainmenu",
    RageUI.CreateMenu("", "", tRNG.getRageUIMenuWidth(), tRNG.getRageUIMenuHeight(), "rng_wardrobeui", "rng_wardrobeui")
)
RMenu:Get("rngwardrobe", "mainmenu"):SetSubtitle("HOME")
RMenu.Add(
    "rngwardrobe",
    "listoutfits",
    RageUI.CreateSubMenu(
        RMenu:Get("rngwardrobe", "mainmenu"),
        "",
        "Wardrobe",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "rngwardrobe",
    "equip",
    RageUI.CreateSubMenu(
        RMenu:Get("rngwardrobe", "listoutfits"),
        "",
        "Wardrobe",
        tRNG.getRageUIMenuWidth(),
        tRNG.getRageUIMenuHeight()
    )
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("rngwardrobe", "mainmenu")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    RageUI.Button(
                        "List Outfits",
                        "",
                        {RightLabel = "→→→"},
                        d(),
                        function(e, f, g)
                        end,
                        RMenu:Get("rngwardrobe", "listoutfits")
                    )
                    RageUI.Button(
                        "Save Outfit",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                            if g then
                                c = getGenericTextInput("outfit name:")
                                if c then
                                    if not tRNG.isPlayerInAnimalForm() then
                                        TriggerServerEvent("RNG:saveWardrobeOutfit", c)
                                    else
                                        tRNG.notify("Cannot save animal in wardrobe.")
                                    end
                                else
                                    tRNG.notify("~r~Invalid outfit name")
                                end
                            end
                        end
                    )
                    RageUI.Button(
                        "Get Outfit Code",
                        "Gets a code for your current outfit which can be shared with other players.",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                            if g then
                                if tRNG.isPlusClub() or tRNG.isPlatClub() then
                                    TriggerServerEvent("RNG:getCurrentOutfitCode")
                                else
                                    tRNG.notify(
                                        "~y~You need to be a subscriber of RNG Plus or RNG Platinum to use this feature."
                                    )
                                    tRNG.notify("~y~Available @ store.rngstudios.co.uk")
                                end
                            end
                        end,
                        nil
                    )
                end,
                function()
                end
            )
        end
        if RageUI.Visible(RMenu:Get("rngwardrobe", "listoutfits")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    if b ~= {} then
                        for h, i in pairs(b) do
                            RageUI.Button(
                                h,
                                "",
                                {RightLabel = "→→→"},
                                true,
                                function(e, f, g)
                                    if g then
                                        c = h
                                    end
                                end,
                                RMenu:Get("rngwardrobe", "equip")
                            )
                        end
                    else
                        RageUI.Button(
                            "No outfits saved",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(e, f, g)
                            end,
                            RMenu:Get("rngwardrobe", "mainmenu")
                        )
                    end
                end,
                function()
                end
            )
        end
        if RageUI.Visible(RMenu:Get("rngwardrobe", "equip")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    RageUI.Button(
                        "Equip Outfit",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("RNG:equipWardrobeOutfit", c)
                            end
                        end,
                        RMenu:Get("rngwardrobe", "listoutfits")
                    )
                    RageUI.Button(
                        "Delete Outfit",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("RNG:deleteWardrobeOutfit", c)
                            end
                        end,
                        RMenu:Get("rngwardrobe", "listoutfits")
                    )
                end,
                function()
                end
            )
        end
    end
)
local function j()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("rngwardrobe", "mainmenu"), true)
    IsInWardrobeMenu = true
end
local function k()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("rngwardrobe", "mainmenu"), false)
    IsInWardrobeMenu = false
end
RegisterNetEvent(
    "RNG:openOutfitMenu",
    function(l)
        if l then
            b = l
        else
            TriggerServerEvent("RNG:initWardrobe")
        end
        j()
    end
)
RegisterNetEvent(
    "RNG:refreshOutfitMenu",
    function(l)
        b = l
    end
)
RegisterNetEvent(
    "RNG:closeOutfitMenu",
    function()
        k()
    end
)
