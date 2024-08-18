insideDiamondCasino = false
AddEventHandler(
    "RNG:onClientSpawn",
    function(a, b)
        if b then
            local c = vector3(1121.7922363281, 239.42251586914, -50.440742492676)
            local d = function(e)
                insideDiamondCasino = true
                tRNG.setCanAnim(false)
                tRNG.overrideTime(12, 0, 0)
                TriggerEvent("RNG:enteredDiamondCasino")
                TriggerServerEvent("RNG:getChips")
            end
            local f = function(e)
                insideDiamondCasino = false
                tRNG.setCanAnim(true)
                tRNG.cancelOverrideTimeWeather()
                TriggerEvent("RNG:exitedDiamondCasino")
            end
            local g = function(e)
            end
            tRNG.createArea("Diamondcasino", c, 100.0, 20, d, f, g, {})
        end
    end
)

