RegisterServerEvent("RNG:adminTicketFeedback")
AddEventHandler("RNG:adminTicketFeedback", function(AdminID, FeedBackType)
    local AdminID = RNG.getUserId(AdminID)
    local FeedBackType = FeedBackType
    local AdminID = AdminID or "N/A"
    if AdminID ~= nil then
        if FeedBackType == "good" then
            RNG.giveBankMoney(AdminID, 25000)
            RNGclient.notify(source, {"~g~You Have Been Given Good Feedback Keep Up The Good Work. 🙂"})
        elseif FeedBackType == "neutral" then
            RNG.giveBankMoney(AdminID, 10000)
            RNGclient.notify(source, {"~y~You Have Been Given Neutral Feedback."})
        elseif FeedBackType == "bad" then
            RNG.giveBankMoney(AdminID, 5000)
            RNGclient.notify(source, {"~r~You Have Been Given Bad Feedback. 😞"})
        end
        RNG.sendWebhook('adminfeedback', 'Admin Feeback Logs', "> Players Name: **"..RNG.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    end
end)



RegisterServerEvent("RNG:adminTicketNoFeedback")
AddEventHandler("RNG:adminTicketNoFeedback", function(admin)
    local adminid = RNG.getUserId(admin)
    local adminname = RNG.getPlayerName(adminid)
    if adminid ~= nil then 
        RNGclient.notify(admin, {"~r~The player did not provide feedback."})
    end
end)