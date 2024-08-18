-- local CharSetLookup = {}
-- local over = true
-- local theString = ""
-- local theReward = 0

-- local function generateRandomLetters()
--     local chars = {}
--     for loop = 1, 5 do
--         local randomChar = string.char(math.random(65, 90)) -- ASCII values for A to Z
--         chars[loop] = randomChar
--     end
--     return table.concat(chars)
-- end

-- theString = {}
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(20000)
--         over = false
--         theString = generateRandomLetters()
--         theString = string.upper(theString)
--         print("Generated string: " .. theString)
--         theReward = math.random(10000, 50000) * 2
--         TriggerClientEvent('chatMessage', -1, "^2[Mini-Event] Who writes the word: " .. theString .. " first gets £" .. theReward)
--         SetTimeout(10000, function()
--             if not over then
--                 TriggerClientEvent('chatMessage', -1, "^2[Mini-Event] Time is over, no one wrote the word!")
--                 over = true
--                 theReward = 0
--                 theString = ""
--             end
--         end)
--     end
-- end)

-- -- AddEventHandler('chatMessage', function(source, name, message)
-- --     local upperMessage = string.upper(message)
-- --     print("Typed message: " .. message)
-- --     if upperMessage == theString then
-- --         local user_id = RNG.getUserId(source)
-- --         print("Correct word typed by: " .. RNG.getPlayerName(source))
-- --         TriggerClientEvent('chatMessage', -1, "^2[Mini-Event] ^1" .. RNG.getPlayerName(source) .. " ^2wrote the word and won £" .. theReward)
-- --         over = true
-- --         local newReward = theReward / 2
-- --         RNG.giveMoney(user_id, newReward)
-- --     else
-- --         print("Incorrect word typed by: " .. RNG.getPlayerName(source))
-- --     end
-- -- end)

RegisterServerEvent("RNG:ChatReward:Pay", function(source, code, price)
    TriggerClientEvent('chatMessage', -1, "^2[Mini-Event] ^1" .. RNG.getPlayerName(source) .. " ^2wrote the word and won ^1£" .. price, "ooc")
    RNG.giveMoney(RNG.getUserId(source), price)
end)