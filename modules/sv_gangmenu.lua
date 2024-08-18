local gangWithdraw = {}
local gangDeposit = {}
local gangTable = {}
local playerinvites = {}
local fundscooldown = {}
local cooldown = 5
local blockedGangName ={"nigger","nigga","wog","coon","paki","faggot","anal","kys","homosexual","lesbian","suicide","negro","queef","queer","allahu akbar","terrorist","wanker","n1gger","f4ggot","n0nce","d1ck","h0m0","n1gg3r","h0m0s3xual","nazi","hitler","fag","fa5"}
MySQL.createCommand("rng_edituser", "UPDATE rng_user_gangs SET gangname = @gangname WHERE user_id = @user_id")
MySQL.createCommand("rng_adduser", "INSERT IGNORE INTO rng_user_gangs (user_id,gangname) VALUES (@user_id,@gangname)")
RegisterServerEvent('RNG:CreateGang', function(gangName)
    local source = source
    local user_id = RNG.getUserId(source)
    local username = RNG.getPlayerName(source)
    if RNG.hasGroup(user_id, "Gang") then
        local hasgang = RNG.getGangName(user_id)
        for word in pairs(blockedGangName) do
            if (string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(gangName:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedGangName[word])) then
                RNGclient.notify(source, {"~r~That Gang Name Is BlackListed"})
                return
            end
        end
        if hasgang == nil or hasgang == "" then
            exports['rng']:execute("SELECT * FROM rng_user_gangs WHERE gangname = @gang", { gang = gangName }, function(gangData)
                if #gangData <= 0 then
                    local gangTable = { [tostring(user_id)] = { ["rank"] = 4, ["gangPermission"] = 4, ["color"] = "Red" } }
                    gangTables = json.encode(gangTable)
                    RNGclient.notify(source, {"~g~Gang created."})
                    MySQL.execute("rng_edituser", { user_id = user_id, gangname = gangName })
                    exports['rng']:execute("INSERT INTO rng_gangs (gangname,gangmembers,funds,logs,username) VALUES(@gangname,@gangmembers,@funds,@logs,@username)", { gangname = gangName, gangmembers = gangTables, funds = 0, logs = "NOTHING", username = username }, function() end)
                    TriggerClientEvent("RNG:gangNameNotTaken", source)
                    TriggerClientEvent("RNG:ForceRefreshData", source)
                else
                    RNGclient.notify(source, {"~r~Gang already exists."})
                end
            end)
        else
            exports['rng']:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", { gangname = RNG.getGangName(user_id) }, function(ganginfo)
                if ganginfo[1].gangname then
                    RNGclient.notify(source, {"~r~Please Contact A Developer With Your Perm ID"})
                    return
                else
                    MySQL.execute("rng_edituser", { user_id = user_id, gangname = nil })
                    RNGclient.notify(source, {"~g~Please Re-Create Your Gang."})
                end
            end)
        end
    else
        RNGclient.notify(source, {"~r~You do not have a gang license."})
    end
end)

RegisterServerEvent("RNG:GetGangData",function()
    local source = source
    local user_id = RNG.getUserId(source)
    local gangName = RNG.getGangName(user_id)
    local isAdvanced = false
    if gangName and gangName ~= "" then
        local gangmembers = {}
        local gangData = {}
        local ganglogs = {}
        local memberids = {}
        local gangpermission = {}
        exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangName}, function(result)
            if result and result[1] then
                local gangInfo = result[1]
                local gangMembers = json.decode(gangInfo.gangmembers)
                gangData["money"] = math.floor(gangInfo.funds)
                gangData["id"] = gangName
                gangpermission = tonumber(gangMembers[tostring(user_id)].gangPermission)
                ganglogs = json.decode(gangInfo.logs)
                ganglock = tobool(gangInfo.lockedfunds)
                for member_id, member_data in pairs(gangMembers) do
                   memberids[#memberids+1] = tostring(member_id)
                end
                local placeholders = string.rep('?,', #memberids):sub(1, -2)
                local playerData = exports['rng']:executeSync('SELECT * FROM rng_users WHERE id IN (' .. placeholders .. ')', memberids)
                local userData = exports['rng']:executeSync('SELECT * FROM rng_user_data WHERE user_id IN (' .. placeholders .. ')', memberids)
                for _,playerRow in ipairs(playerData) do
                   local member_id = tonumber(playerRow.id)
                   local gangpermission = tonumber(gangMembers[tostring(member_id)].gangPermission)
                   local online
                   if playerRow.banned then
                       online = '~r~Banned'
                   elseif RNG.getUserSource(member_id) then
                       online = '~g~Online'
                   elseif playerRow.last_login then
                       online = '~y~Offline'
                   else
                       online = '~r~Never joined'
                   end
                   local playtime = 0

                   for _, userData in ipairs(userData) do
                       if userData.user_id == member_id and userData.dkey == 'RNG:datatable' then
                           local data = json.decode(userData.dvalue)

                           playtime = math.ceil((data.PlayerTime or 0) / 60)
                           if playtime < 1 then
                               playtime = 0
                           end
                           break
                       end
                   end
                   table.insert(gangmembers,{playerRow.username,member_id,gangpermission,online,playtime})
                end
                for _,member_id in ipairs(memberids) do
                    local tempid = RNG.getUserSource(tonumber(member_id))
                    if RNG.hasGroup(user_id, "Advanced Gang") then
                        isAdvanced = true
                    end
                    if tempid then
                        TriggerClientEvent('RNG:GotGangData',tempid,gangData,gangmembers,gangpermission,ganglogs,ganglock,false,isAdvanced)
                    end
                end
            end
        end)
    end
end)

RegisterServerEvent("RNG:purchaseAdvancedGangLicense", function()
    local source = source
    local user_id = RNG.getUserId(source)
    local gangname = RNG.getGangName(user_id)
    exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if RNG.tryFullPayment(user_id, 50000000) then
                        local advanced = not tobool(ganginfo[1].advanced)
                        exports["rng"]:execute("UPDATE rng_gangs SET advanced = @advanced WHERE gangname = @gangname", {advanced = advanced, gangname = gangname}) 
                        RNGclient.notify(source, {"~g~You have " ..(advanced and "purchased") .." the advanced gang license."})
                        TriggerClientEvent("RNG:ForceRefreshData",source)
                    else
                        RNGclient.notify(source, {"~r~You do not have enough money."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("RNG:addUserToGang",function(gangName)
    local source = source
    local user_id = RNG.getUserId(source)
    if table.includes(playerinvites[source],gangName) then
        exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname",{gangname = gangName}, function(ganginfo)
            if json.encode(ganginfo) == "[]" and ganginfo == nil and json.encode(ganginfo) == nil then
                RNGclient.notify(source, {"~b~Gang no longer exists."})
                return
            end
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(ganginfo) do
                gangmembers[tostring(user_id)] = {["rank"] = 1,["gangPermission"] = 1,["color"] = "White"}
                exports["rng"]:execute("UPDATE rng_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname",{gangmembers = json.encode(gangmembers),gangname = gangName})
                MySQL.execute("rng_edituser", {user_id = user_id, gangname = gangName})
                TriggerClientEvent("RNG:ForceRefreshData",source)
                syncRadio(source)
            end
        end)
    else
        RNGclient.notify(source, {"~r~You have not been invited to this gang."})
    end
end)
local colourwait = false
RegisterServerEvent("RNG:setPersonalGangBlipColour")
AddEventHandler("RNG:setPersonalGangBlipColour", function(color)
    local source = source
    local user_id = RNG.getUserId(source)
    local gangName = RNG.getGangName(user_id)
    if gangName and gangName ~= "" then
        exports['rng']:execute('SELECT * FROM rng_gangs WHERE gangname = @gangname', {gangname = gangName}, function(gangs)
            if #gangs > 0 then
                local gangmembers = json.decode(gangs[1].gangmembers)
                gangmembers[tostring(user_id)] = {["rank"] = gangmembers[tostring(user_id)].rank, ["gangPermission"] = gangmembers[tostring(user_id)].gangPermission,["color"] = color}
                exports['rng']:execute("UPDATE rng_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangName})
                TriggerClientEvent("RNG:setGangMemberColour",-1,user_id,color)
            end
        end)
    end
end)

RegisterServerEvent("RNG:depositGangBalance",function(gangname, amount)
    local source = source
    local user_id = RNG.getUserId(source)
    exports['rng']:execute('SELECT * FROM rng_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        RNGclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    if tonumber(RNG.getBankMoney(user_id)) < tonumber(amount) then
                        RNGclient.notify(source,{"~r~Not enough Money."})
                    else
                        RNG.setBankMoney(user_id, (RNG.getBankMoney(user_id))-tonumber(amount))
                        RNGclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                        addGangLog(RNG.getPlayerName(source),user_id,"Deposited","£"..getMoneyStringFormatted(amount))
                        exports['rng']:execute("UPDATE rng_gangs SET funds = @funds WHERE gangname = @gangname", {funds = tonumber(amount)+tonumber(funds), gangname = gangname})
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("RNG:depositAllGangBalance", function()
    local source = source
    local user_id = RNG.getUserId(source)
    local gangName = exports['rng']:executeSync("SELECT * FROM rng_user_gangs WHERE user_id = @user_id", {user_id = user_id})[1].gangname
    local currenttime = os.time()

    if gangName and gangName ~= "" then
        if not fundscooldown[source] or (currenttime - fundscooldown[source]) >= cooldown then
            fundscooldown[source] = currenttime
            local bank = RNG.getBankMoney(user_id)
            exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
                if #ganginfo > 0 then
                    local gangmembers = json.decode(ganginfo[1].gangmembers)
                    for A, B in pairs(gangmembers) do
                        if tostring(user_id) == A then
                            local gangfunds = ganginfo[1].funds
                            if tonumber(bank) < 0 then
                                RNGclient.notify(source, {"~r~Invalid Amount"})
                                return
                            end
                            RNG.setBankMoney(user_id, 0)
                            RNGclient.notify(source, {"~g~Deposited £" .. getMoneyStringFormatted(bank) .. "\n£" .. getMoneyStringFormatted(tonumber(bank) * 0.02) .. " tax paid."})
                            addGangLog(RNG.getPlayerName(source), user_id, "Deposited", "£" .. getMoneyStringFormatted(bank))
                            local newbal = tonumber(bank) + tonumber(gangfunds) - tonumber(bank) * 0.02
                            exports["rng"]:execute("UPDATE rng_gangs SET funds = @funds WHERE gangname = @gangname", {funds = tostring(newbal), gangname = gangName})
                        end
                    end
                end
            end)
        else
            RNGclient.notify(source, {"~r~Cooldown Wait " .. (cooldown - (currenttime - fundscooldown[source])) .. " seconds"})
        end
    end
end)

RegisterServerEvent("RNG:withdrawAllGangBalance", function()
    local source = source
    local user_id = RNG.getUserId(source)
    local gangName = exports['rng']:executeSync("SELECT * FROM rng_user_gangs WHERE user_id = @user_id", {user_id = user_id})[1].gangname
    local currenttime = os.time()
    if gangName and gangName ~= "" then
        if not fundscooldown[source] or (currenttime - fundscooldown[source]) >= cooldown then
            fundscooldown[source] = currenttime
            exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
                if #ganginfo > 0 then
                    local gangmembers = json.decode(ganginfo[1].gangmembers)
                    for A, B in pairs(gangmembers) do
                        if tostring(user_id) == A then
                            local gangfunds = ganginfo[1].funds
                            if tonumber(gangfunds) < 0 then
                                RNGclient.notify(source, {"~r~Invalid Amount"})
                                return
                            end
                            RNG.setBankMoney(user_id, (RNG.getBankMoney(user_id)) + tonumber(gangfunds))
                            RNGclient.notify(source, {"~g~Withdrew £" .. getMoneyStringFormatted(gangfunds)})
                            addGangLog(RNG.getPlayerName(source), user_id, "Withdrew", "£" .. getMoneyStringFormatted(gangfunds))
                            exports["rng"]:execute("UPDATE rng_gangs SET funds = @funds WHERE gangname = @gangname", {funds = 0, gangname = gangName})
                        end
                    end
                end
            end)
        else
            RNGclient.notify(source, {"~r~Cooldown Wait " .. (cooldown - (currenttime - fundscooldown[source])) .. " seconds"})
        end
    end
end)



RegisterServerEvent("RNG:withdrawGangBalance",function(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    local gangName = RNG.getGangName(user_id)
    if gangName and gangName ~= "" then
        if not gangWithdraw[source] then
            gangWithdraw[source] = true
            exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
                if #ganginfo > 0 then
                    local gangmembers = json.decode(ganginfo[1].gangmembers)
                    for A,B in pairs(gangmembers) do
                        if tostring(user_id) == A then
                            local gangfunds = ganginfo[1].funds
                            if tonumber(amount) < 0 then
                                RNGclient.notify(source,{"~r~Invalid Amount"})
                                return
                            end
                            if tonumber(gangfunds) < tonumber(amount) then
                                RNGclient.notify(source,{"~r~Not enough Money."})
                            else
                                RNG.setBankMoney(user_id, (RNG.getBankMoney(user_id))+tonumber(amount))
                                RNGclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                                addGangLog(RNG.getPlayerName(source),user_id,"Withdrew","£"..getMoneyStringFormatted(amount))
                                exports["rng"]:execute("UPDATE rng_gangs SET funds = @funds WHERE gangname = @gangname", {funds = tonumber(gangfunds)-tonumber(amount), gangname = gangName})
                            end
                        end
                    end
                    gangWithdraw[source] = false
                end
            end)
        end
    end
end)

RegisterServerEvent("RNG:PromoteUser", function(gangname, memberid)
    local source = source
    local user_id = RNG.getUserId(source)
    exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A, B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank >= 4 then
                        local rank = gangmembers[tostring(memberid)].rank
                        local gangpermission = gangmembers[tostring(memberid)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= A then
                            RNGclient.notify(source, {"~r~Only the leader can promote."})
                            return
                        end
                        if gangmembers[tostring(memberid)].rank == 3 and gangpermission == 3 and tostring(user_id) == A then
                            RNGclient.notify(source, {"~r~There can only be one leader."})
                            return
                        end
                        if tonumber(memberid) == tonumber(user_id) and rank == 4 and gangpermission == 4 then
                            RNGclient.notify(source, {"~r~You are already the highest rank."})
                            return
                        end
                        if gangmembers[tostring(memberid)].rank == 4 and gangmembers[tostring(memberid)].gangPermission == 4 then
                            RNGclient.notify(source, {"~r~This user is already a leader."})
                            return
                        end
                        gangmembers[tostring(memberid)].rank = tonumber(rank) + 1
                        gangmembers[tostring(memberid)].gangPermission = tonumber(gangpermission) + 1
                        RNGclient.notify(source, {"~g~Promoted User."})
                        addGangLog(RNG.getPlayerName(source), user_id, "Promoted", "ID: " .. memberid)
                        exports["rng"]:execute("UPDATE rng_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangname})
                    end
                end
            end
        end
    end)
end)


RegisterServerEvent("RNG:DemoteUser", function(gangname,member)
    local source = source
    local user_id = RNG.getUserId(source)
    exports["rng"]:execute("SELECT * FROM rng_gang WHERE gangname = @gangname", {gangname = gangname},function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank >= 4 then
                        local rank = gangmembers[tostring(member)].rank
                        local gangpermission = gangmembers[tostring(member)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= A then
                            RNGclient.notify(source, {"~r~Only the leader can demote."})
                            return
                        end
                        if gangmembers[tostring(member)].rank == 1 and gangpermission == 1 and tostring(user_id) == A then
                            RNGclient.notify(source, {"~r~There can only be one leader."})
                        end
                        if tonumber(member) == tonumber(user_id) and rank == 1 and gangpermission == 1 then
                            RNGclient.notify(source, {"~r~You are already the lowest rank."})
                            return
                        end
                        gangmembers[tostring(member)].rank = tonumber(rank)-1
                        gangmembers[tostring(member)].gangPermission = tonumber(gangpermission)-1
                        gangmembers = json.encode(gangmembers)
                        RNGclient.notify(source, {"~g~Demoted User."})
                        addGangLog(RNG.getPlayerName(source),user_id,"Demoted","ID: "..member)
                        exports["rng"]:execute("UPDATE rng_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = gangmembers, gangname = gangname})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("RNG:KickUser",function(gangname,member)
    local source = source
    local user_id = RNG.getUserId(source)
    local membersource = RNG.getUserSource(member)
    exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    local memberrank = gangmembers[tostring(member)].rank
                    local leaderrank = gangmembers[tostring(user_id)].rank
                    if B.rank >= 3 then
                        if tonumber(member) == tonumber(user_id) then
                            RNGclient.notify(source, {"~r~You cannot kick yourself."})
                            return
                        end
                        if tonumber(memberrank) >= leaderrank then
                            RNGclient.notify(source, {"~r~You do not have permission to kick this member from this gang"})
                            return
                        end
                        gangmembers[tostring(member)] = nil
                        addGangLog(RNG.getPlayerName(source),user_id,"Kicked","ID: "..member)
                        exports["rng"]:execute("UPDATE rng_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangname})
                        MySQL.execute("rng_edituser", {user_id = member, gangname = nil})
                        if membersource then
                            RNGclient.notify(membersource, {"~r~You have been kicked from the gang."})
                            syncRadio(membersource)
                            TriggerClientEvent("RNG:disbandedGang",membersource)
                        end
                    else
                        RNGclient.notify(source, {"~r~You do not have permission to kick this member from this gang"})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("RNG:LeaveGang", function(gangname)
    local source = source
    local user_id = RNG.getUserId(source)
    exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        RNGclient.notify(source, {"~r~You cannot leave the gang as you are the leader."})
                        return
                    end
                    gangmembers[tostring(user_id)] = nil
                    exports["rng"]:execute("UPDATE rng_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangname})
                    MySQL.execute("rng_edituser", {user_id = user_id, gangname = nil})
                    if RNG.getUserSource(user_id) ~= nil then
                        RNGclient.notify(source, {"~r~You have left the gang."})
                        syncRadio(source)
                        TriggerClientEvent("RNG:disbandedGang",source)
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("RNG:InviteUser",function(gangname,playerid)
    local source = source
    local user_id = RNG.getUserId(source)
    local playersource = RNG.getUserSource(tonumber(playerid))
    if source ~= playersource then
        if playersource == nil then
            RNGclient.notify(source, {"~r~Player is not online."})
            return
        else
            table.insert(playerinvites[playersource],gangname)
            addGangLog(RNG.getPlayerName(source),user_id,"Invited","ID: "..playerid)
            TriggerClientEvent("RNG:InviteReceived",playersource,"~g~Gang invite received from: " ..RNG.getPlayerName(source),gangname)
            RNGclient.notify(source, {"~g~Successfully invited " ..RNG.getPlayerName(playersource).. " to the gang."})
        end
    else
        RNGclient.notify(source, {"~r~You cannot invite yourself."})
    end
end)

RegisterServerEvent("RNG:DeleteGang",function(gangname)
    local source = source
    local user_id = RNG.getUserId(source)
    exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        exports["rng"]:execute("DELETE FROM rng_gangs WHERE gangname = @gangname", {gangname = gangname})
                        for A,B in pairs(gangmembers) do
                            MySQL.execute("rng_edituser", {user_id = A, gangname = nil})
                            if RNG.getUserSource(tonumber(A)) ~= nil then
                                syncRadio(RNG.getUserSource(tonumber(A)))
                                TriggerClientEvent("RNG:disbandedGang",RNG.getUserSource(tonumber(A)))
                            else
                                print("User is not online, unable to disbanded gang for them.")
                            end
                        end
                        
                        RNGclient.notify(source, {"~r~You have disbanded the gang."})
                    else
                        RNGclient.notify(source, {"~r~You do not have permission to disband this gang."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("RNG:RenameGang", function(gangname,newname)
    local source = source
    local user_id = RNG.getUserId(source)
    local gangnamecheck = exports["rng"]:scalarSync("SELECT gangname FROM rng_gangs WHERE gangname = @gangname", {gangname = newname})
    if gangnamecheck == nil then
        exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
            if #ganginfo > 0 then
                local gangmembers = json.decode(ganginfo[1].gangmembers)
                for A,B in pairs(gangmembers) do
                    if tostring(user_id) == A then
                        if B.rank == 4 then
                            exports["rng"]:execute("UPDATE rng_gangs SET gangname = @gangname WHERE gangname = @oldgangname", {gangname = newname, oldgangname = gangname})
                            for A,B in pairs(gangmembers) do
                                MySQL.execute("rng_edituser", {user_id = A, gangname = newname})
                                syncRadio(RNG.getUserSource(tonumber(A)))
                            end
                            RNGclient.notify(source, {"~g~You have renamed the gang to: " ..newname})
                        else
                            RNGclient.notify(source, {"~r~You do not have permission to rename this gang."})
                        end
                    end
                end
            end
        end)
    else
        RNGclient.notify(source, {"~r~Gang name is already taken."})
        return
    end
end)

RegisterServerEvent("RNG:SetGangWebhook")
AddEventHandler("RNG:SetGangWebhook", function(gangid)
    local source = source 
    local user_id = RNG.getUserId(source)
    exports['rng']:execute('SELECT * FROM rng_gangs WHERE gangname = @gangname', {gangname = gangid}, function(G)
        for K, V in pairs(G) do
            local array = json.decode(V.gangmembers) -- Convert the JSON string to a table
            for I, L in pairs(array) do
                if tostring(user_id) == I then
                    if L["rank"] == 4 then
                        RNG.prompt(source, "Webhook (Enter the webhook here): ", "", function(source, webhook)
                            local pattern = "^/%d+/%S+$"
                            if webhook ~= nil and string.match(webhook, pattern) then 
                                exports['rng']:execute("UPDATE rng_gangs SET webhook = @webhook WHERE gangname = @gangname", {gangname = gangid, webhook = webhook}, function(gotGangs) end)
                                RNGclient.notify(source, {"~g~Webhook set."})
                                TriggerClientEvent('RNG:ForceRefreshData', -1)
                            else
                                RNGclient.notify(source, {"~r~Invalid value."})
                            end
                        end)
                    else
                        RNGclient.notify(source, {"~r~you do not have permission."})
                    end
                end
            end
        end
    end)
end)


RegisterServerEvent("RNG:LockGangFunds", function(gangname)
    local source = source
    local user_id = RNG.getUserId(source)
    exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        local newlocked = not tobool(ganginfo[1].lockedfunds)
                        exports["rng"]:execute("UPDATE rng_gangs SET lockedfunds = @lockedfunds WHERE gangname = @gangname", {lockedfunds = newlocked, gangname = gangname}) 
                        RNGclient.notify(source, {"~g~You have " ..(newlocked and "locked" or "unlocked") .." the gang funds."})
                        TriggerClientEvent("RNG:ForceRefreshData",source)
                    else
                        RNGclient.notify(source, {"~r~You do not have permission to lock the gang funds."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("RNG:sendGangMarker",function(Gangname,coords)
    local source = source
    local user_id = RNG.getUserId(source)
    exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = Gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    for C,D in pairs(gangmembers) do
                        local temp = RNG.getUserSource(tonumber(C))
                        if temp ~= nil then
                            TriggerClientEvent("RNG:drawGangMarker",temp,RNG.getPlayerName(source),coords)
                        end
                    end
                    break
                end
            end
        end
    end)
end)

RegisterServerEvent("RNG:setGangFit",function(gangName)
    local source = source
    local user_id = RNG.getUserId(source)
    exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        RNGclient.getCustomization(source,{},function(customization)
                            exports["rng"]:execute("UPDATE rng_gangs SET gangfit = @gangfit WHERE gangname = @gangname", {gangfit = json.encode(customization), gangname = gangName})
                            RNGclient.notify(source, {"~g~You have set the gang fit."})
                            TriggerClientEvent("RNG:ForceRefreshData",source)
                        end)
                    else
                        RNGclient.notify(source, {"~r~You do not have permission to set the gang fit."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("RNG:applyGangFit", function(gangName)
    local source = source
    local user_id = RNG.getUserId(source)
    exports["rng"]:execute("SELECT gangfit FROM rng_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
        if #ganginfo > 0 then
            RNGclient.setCustomization(source, {json.decode(ganginfo[1].gangfit)}, function()
                RNGclient.notify(source, {"~g~You have applied the gang fit."})
            end)
        end
    end)
end)

AddEventHandler("RNG:playerSpawn", function(user_id,source,fspawn)
    if fspawn then
        playerinvites[source] = {}
        exports["rng"]:execute("INSERT IGNORE INTO rng_user_gangs (user_id) VALUES (@user_id)", {user_id = user_id})
    end
end)

function addGangLog(playername,userid,action,actionvalue)
    local gangname = RNG.getGangName(userid)
    if gangname and gangname ~= "" then
        exports["rng"]:execute("SELECT * FROM rng_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
            if #ganginfo > 0 then
                local ganglogs = {}
                if ganginfo[1].logs == "NOTHING" then
                    ganglogs = {}
                else
                    ganglogs = json.decode(ganginfo[1].logs)
                end
                if ganginfo[1].webhook then
                    RNG.sendWebhook(ganginfo[1].webhook, gangname.."Gang Logs", "**Name:** " ..playername.. "**\n**User ID:** " ..userid.. "\n**Action:** " ..actionvalue)
                end
                table.insert(ganglogs,1,{playername,userid,os.date("%d/%m/%Y at %X"),action,actionvalue})
                exports["rng"]:execute("UPDATE rng_gangs SET logs = @logs WHERE gangname = @gangname", {logs = json.encode(ganglogs), gangname = gangname})
                TriggerClientEvent("RNG:ForceRefreshData",RNG.getUserSource(userid))
            end
        end)
    end
end

function RNG.getGangName(user_id)
    return exports["rng"]:scalarSync("SELECT gangname FROM rng_user_gangs WHERE user_id = @user_id", {user_id = user_id}) or ""
end
RegisterServerEvent("RNG:newGangPanic")
AddEventHandler("RNG:newGangPanic", function(a,playerName)
    local source = source
    local user_id = RNG.getUserId(source)   
    local peoplesids = {}
    local gangmembers = {}
    exports['rng']:execute('SELECT * FROM rng_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    isingang = true
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermission)
                    end
                    exports['rng']:execute('SELECT * FROM rng_users', function(gotUser)
                        for J,G in pairs(gotUser) do
                            if peoplesids[tostring(G.id)] ~= nil then
                                local player = RNG.getUserSource(tonumber(G.id))
                                if player ~= nil then
                                    TriggerClientEvent("RNG:returnPanic", player, player, a, playerName)
                                end
                            end
                        end
                    end)
                    break
                end
            end
        end
    end)
end)


local gangtable = {}
Citizen.CreateThread(function()
    while true do
        Wait(10000)
        for _,a in pairs(GetPlayers()) do
            local user_id = RNG.getUserId(a)
            if user_id ~= nil then
                gangtable[user_id] = {health = GetEntityHealth(GetPlayerPed(a)), armor = GetPedArmour(GetPlayerPed(a))}
            end
        end
        TriggerClientEvent("RNG:sendGangHPStats", -1, gangtable)
    end
end)
Citizen.CreateThread(function()
    Wait(2500)
    exports['rng']:execute([[
    CREATE TABLE IF NOT EXISTS `rng_user_gangs` (
    `user_id` int(11) NOT NULL,
    `gangname` VARCHAR(100) NULL,
    PRIMARY KEY (`user_id`)
    );]])
end)


RegisterCommand("gangconvert",function(source)
    if source == 0 then
        exports['rng']:execute("SELECT * FROM rng_gangs",{},function(gangs)
            for A,B in pairs(gangs) do
                local gangmembers = json.decode(B.gangmembers)
                for C,D in pairs(gangmembers) do
                    print("Setting gang for user: "..C.." to "..B.gangname)
                    MySQL.execute("rng_adduser", {user_id = C, gangname = B.gangname})
                end
            end
        end)
    end
end)