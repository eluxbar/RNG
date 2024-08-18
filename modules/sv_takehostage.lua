local takingHostage = {}
--takingHostage[source] = targetSource, source is takingHostage targetSource
local takenHostage = {}
--takenHostage[targetSource] = source, targetSource is being takenHostage by source

RegisterServerEvent("RNG:takeHostageSync")
AddEventHandler("RNG:takeHostageSync", function(targetSrc)
	local source = source
	TriggerClientEvent("RNG:takeHostageSyncTarget", targetSrc, source)
	takingHostage[source] = targetSrc
	takenHostage[targetSrc] = source
end)

RegisterServerEvent("RNG:takeHostageReleaseHostage")
AddEventHandler("RNG:takeHostageReleaseHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("RNG:takeHostageReleaseHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("RNG:takeHostageKillHostage")
AddEventHandler("RNG:takeHostageKillHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("RNG:takeHostageKillHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("RNG:takeHostageStop")
AddEventHandler("RNG:takeHostageStop", function(targetSrc)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("RNG:takeHostageCl_stop", targetSrc)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	elseif takenHostage[source] then
		TriggerClientEvent("RNG:takeHostageCl_stop", targetSrc)
		takenHostage[source] = nil
		takingHostage[targetSrc] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("RNG:takeHostageCl_stop", takingHostage[source])
		takenHostage[takingHostage[source]] = nil
		takingHostage[source] = nil
	end
	if takenHostage[source] then
		TriggerClientEvent("RNG:takeHostageCl_stop", takenHostage[source])
		takingHostage[takenHostage[source]] = nil
		takenHostage[source] = nil
	end
end)