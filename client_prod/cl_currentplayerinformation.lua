local a = {}
RegisterNetEvent("RNG:receiveCurrentPlayerInfo")
AddEventHandler(
    "RNG:receiveCurrentPlayerInfo",
    function(b)
        a = b
    end
)
function tRNG.getCurrentPlayerInfo(c)
    for d, e in pairs(a) do
        if d == c then
            return e
        end
    end
end
function tRNG.clientGetPlayerIsStaff(f)
    local g = tRNG.getCurrentPlayerInfo("currentStaff")
    if g then
        for h, i in pairs(g) do
            if i == f then
                return true
            end
        end
        return false
    end
end
