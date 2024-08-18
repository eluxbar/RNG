local function safeParameters(parameters)
  if parameters == nil then
    return {[''] = ''}
  end
  return parameters
end

exports('executeSync', function (query, parameters)
  local res = {}
  local finishedQuery = false
  exports.rng:execute(query, safeParameters(parameters), function (result)
    res = result
    finishedQuery = true
  end, GetInvokingResource())
  repeat Citizen.Wait(0) until finishedQuery == true
  return res
end)

exports('scalarSync', function (query, parameters)
  local res = {}
  local finishedQuery = false
  exports.rng:scalar(query, safeParameters(parameters), function (result)
    res = result
    finishedQuery = true
  end, GetInvokingResource())
  repeat Citizen.Wait(0) until finishedQuery == true
  return res
end)

exports('transactionSync', function (query, parameters)
  local res = {}
  local finishedTransaction = false
  exports.rng:transaction(query, safeParameters(parameters), function (result)
    res = result
    finishedTransaction = true
  end, GetInvokingResource())
  repeat Citizen.Wait(0) until finishedTransaction == true
  return res
end)

exports('storeSync', function (query)
  local res = {}
  local finishedStore = false
  exports.rng:store(query, function (result)
    res = result
    finishedStore = true
  end, GetInvokingResource())
  repeat Citizen.Wait(0) until finishedStore == true
  return res
end)
