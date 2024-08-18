function RNG.updateCurrentPlayerInfo()
  local currentPlayersInformation = {}
  local playersJobs = {}
  for k,v in pairs(RNG.getUsers()) do
    table.insert(playersJobs, {user_id = k, jobs = RNG.getUserGroups(k)})
  end
  currentPlayersInformation['currentStaff'] = RNG.getUsersByPermission('admin.tickets')
  currentPlayersInformation['jobs'] = playersJobs
  TriggerClientEvent("RNG:receiveCurrentPlayerInfo", -1, currentPlayersInformation)
end


AddEventHandler("RNG:playerSpawn", function(user_id, source, first_spawn)
  if first_spawn then
    RNG.updateCurrentPlayerInfo()
  end
end)