local chatCooldown = {}
local lastmsg = nil
local blockedWords = {
    "nigger",
    "nigga",
    "wog",
    "coon",
    "paki",
	"swift5m",
	"arma",
	"xtra",
    "faggot",
    "anal",
    "kys",
    "homosexual",
    "lesbian",
    "suicide",
    "negro",
    "queef",
    "queer",
    "allahu akbar",
    "terrorist",
    "wanker",
    "n1gger",
    "f4ggot",
    "n0nce",
    "d1ck",
    "h0m0",
    "n1gg3r",
    "h0m0s3xual",
    "nazi",
    "hitler",
	"fag",
	"fa5",
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		for k,v in pairs(chatCooldown) do
			chatCooldown[k] = nil
		end
	end
end)

RegisterCommand("anon", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("RNG:Anon", source, message)  -- Pass the source and message directly
end)

-- Dispatch Message
RegisterServerEvent("RNG:Anon")
AddEventHandler("RNG:Anon", function(source, message)  -- Define the event handler with correct parameters
    if #message <= 0 then 
        return 
    end

    local name = RNG.getPlayerName(source)
    local user_id = RNG.getUserId(source)

    if name then 
        for _, word in pairs(blockedWords) do
            if string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(message:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(word) then
                TriggerClientEvent('RNG:chatFilterScaleform', source, 10, 'That word is not allowed.')
                CancelEvent()
                return
            end
        end

        RNG.sendWebhook('anon', "RNG Chat Logs", "```" .. message .. "```" .. "\n> Player Name: **" .. name .. "**\n> Player PermID: **" .. user_id .. "**\n> Player TempID: **" .. source .. "**")
        TriggerClientEvent('chatMessage', -1, "^4Twitter @^1Anonymous: ", { 128, 128, 128 }, message, "ooc", "Anonymous")    
    end
end)


function RNG.ooc(source, args, raw)
	if #args <= 0 then 
		return 
	end
	local source = source
	local name = RNG.getPlayerName(source)
	local message = args
	local user_id = RNG.getUserId(source)
	if not chatCooldown[source] then 
		for word in pairs(blockedWords) do
			if(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(args:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedWords[word])) then
				TriggerClientEvent('RNG:chatFilterScaleform', source, 10, 'That word is not allowed.')
				CancelEvent()
				return
			end
		end
		if RNG.hasGroup(user_id, "Founder") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^8 Founder ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
		elseif RNG.hasGroup(user_id, "Lead Developer") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^8 Lead Developer ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
		elseif RNG.hasGroup(user_id, "Operations Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Operations Manager ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
		elseif RNG.hasGroup(user_id, "Community Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Community Manager ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Staff Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^6 Staff Manager ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Head Administrator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Head Administrator ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Senior Administrator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Senior Administrator ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "OOC")	
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Administrator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^4 Administrator ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")			
			chatCooldown[source] = true			
		elseif RNG.hasGroup(user_id, "Senior Moderator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Senior Moderator ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")				
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Moderator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Moderator ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")				
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Support Team") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Support Team ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Trial Staff") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^5 Trial Staff ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Baller") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^3" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Rainmaker") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^4" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Kingpin") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^1" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Supreme") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^5" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Premium") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^6" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif RNG.hasGroup(user_id, "Supporter") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^2" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		else
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^7" .. RNG.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		end
		RNG.sendWebhook('ooc', "RNG Chat Logs", "```"..message.."```".."\n> Player Name: **"..RNG.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
	else
		TriggerClientEvent('chatMessage', source, "^1[RNG]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert", "OOC")
		chatCooldown[source] = true
	end
end
RegisterServerEvent("RNG:ooc", function(source, args)
	RNG.ooc(source, args)
end)

RegisterCommand("ooc", function(source, args, raw)
    local message = table.concat(args, " ")
    RNG.ooc(source, message)
end)

RegisterCommand("/", function(source, args, raw)
	local message = table.concat(args, " ")
	message = message:sub(1)
    RNG.ooc(source, message)
end)

RegisterCommand('cc', function(source, args, rawCommand)
    local user_id = RNG.getUserId(source)
    if RNG.hasPermission(user_id, 'admin.ban') then
        TriggerClientEvent('chat:clear',-1)             
    end
end, false)


RegisterServerEvent("RNG:TwitterLogs")
AddEventHandler("RNG:TwitterLogs", function(source,message)
	local user_id = RNG.getUserId(source)
	RNG.sendWebhook("twitter", "RNG Chat Logs", "```"..message.."```".."\n> Player Name: **"..RNG.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
end)
function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function cleanMessage(message)
	local replacements = {
	  [" "] = "",
	  ["-"] = "",
	  ["."] = "",
	  ["$"] = "s",
	  ["€"] = "e",
	  [","] = "",
	  [";"] = "",
	  [":"] = "",
	  ["*"] = "",
	  ["_"] = "",
	  ["|"] = "",
	  ["/"] = "",
	  ["<"] = "",
	  [">"] = "",
	  ["ß"] = "ss",
	  ["&"] = "",
	  ["+"] = "",
	  ["¦"] = "",
	  ["§"] = "s",
	  ["°"] = "",
	  ["#"] = "",
	  ["@"] = "a",
	  ["\""] = "",
	  ["("] = "",
	  [")"] = "",
	  ["="] = "",
	  ["?"] = "",
	  ["!"] = "",
	  ["´"] = "",
	  ["`"] = "",
	  ["'"] = "",
	  ["^"] = "",
	  ["~"] = "",
	  ["["] = "",
	  ["]"] = "",
	  ["{"] = "",
	  ["}"] = "",
	  ["£"] = "e",
	  ["¨"] = "",
	  ["ç"] = "c",
	  ["¬"] = "",
	  ["\\"] = "",
	  ["1"] = "i",
	  ["3"] = "e",
	  ["4"] = "a",
	  ["5"] = "s",
	  ["0"] = "o"
	}
  
	local finalmessage = message:lower()
	finalmessage = finalmessage:gsub(".", function(c)
	  return replacements[c] or c
	end)
  
	return finalmessage
  end