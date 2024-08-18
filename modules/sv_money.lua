local lang = RNG.lang
--Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)

MySQL.createCommand("RNG/money_init_user","INSERT IGNORE INTO rng_user_moneys(user_id,wallet,bank,dirtycash,offshore) VALUES(@user_id,@wallet,@bank,@dirtycash,@offshore)")
MySQL.createCommand("RNG/get_money","SELECT wallet,bank,dirtycash,offshore FROM rng_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("RNG/set_money","UPDATE rng_user_moneys SET wallet = @wallet, bank = @bank, dirtycash = @dirtycash, offshore = @offshore WHERE user_id = @user_id")

-- get money
-- cbreturn nil if error
function RNG.getMoney(user_id)
  local tmp = RNG.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money

    -- get offshore
    function RNG.getOffshoreMoney(user_id)
      local tmp = RNG.getUserTmpTable(user_id)
      if tmp then
        return tmp.offshore or 0
      else
        return 0
      end
    end
  
    -- set offshore money
    function RNG.setOffshoreMoney(user_id,value)
      local tmp = RNG.getUserTmpTable(user_id)
      if tmp then
        tmp.offshore = value
      end
  
    -- update client display
    local source = RNG.getUserSource(user_id)
    if source ~= nil then
      TriggerClientEvent('RNG:setDisplayOffshore', source, tmp.offshore)
    end
  end
  
      -- give offshore money
      function RNG.giveOffshoreMoney(user_id,amount)
        local money = RNG.getOffshoreMoney(user_id)
        RNG.setOffshoreMoney(user_id,money+amount)
      end

















    -- get dirtycash
    function RNG.getDirtyCash(user_id)
      local tmp = RNG.getUserTmpTable(user_id)
      if tmp then
        return tmp.dirtycash or 0
      else
        return 0
      end
    end
  
    -- set dirty money
    function RNG.setDirtyCash(user_id,value)
      local tmp = RNG.getUserTmpTable(user_id)
      if tmp then
        tmp.dirtycash = value
      end
  
    -- update client display
    local source = RNG.getUserSource(user_id)
    if source ~= nil then
      TriggerClientEvent('RNG:setDisplayRedMoney', source, tmp.dirtycash)
    end
  end
  
      -- give dirty money
      function RNG.giveDirtyCash(user_id,amount)
        local money = RNG.getDirtyCash(user_id)
        RNG.setDirtyCash(user_id,money+amount)
      end
  
  -- try a payment
  -- return true or false (debited if true)
  function RNG.tryPayment(user_id,amount)
    local money = RNG.getMoney(user_id)
    if amount >= 0 and money >= amount then
      RNG.setMoney(user_id,money-amount)
      return true
    else
      return false
    end
  end

function RNG.tryBankPayment(user_id,amount)
  local bank = RNG.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    RNG.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function RNG.giveMoney(user_id,amount)
  local money = RNG.getMoney(user_id)
  RNG.setMoney(user_id,money+amount)
end

-- get bank money
function RNG.getBankMoney(user_id)
  local tmp = RNG.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function RNG.setBankMoney(user_id,value)
  local tmp = RNG.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = RNG.getUserSource(user_id)
  if source ~= nil then
    RNGclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(RNG.getBankMoney(user_id))})})
    TriggerClientEvent('RNG:initMoney', source, RNG.getMoney(user_id), RNG.getBankMoney(user_id))
  end
end

-- give bank money
function RNG.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = RNG.getBankMoney(user_id)
    RNG.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function RNG.tryWithdraw(user_id,amount)
  local money = RNG.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    RNG.setBankMoney(user_id,money-amount)
    RNG.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function RNG.tryDeposit(user_id,amount)
  if amount > 0 and RNG.tryPayment(user_id,amount) then
    RNG.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function RNG.tryFullPayment(user_id,amount)
  local money = RNG.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return RNG.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if RNG.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return RNG.tryPayment(user_id, amount)
    end
  end

  return false
end

function GetProfiles(source)
  local ids = RNG.GetPlayerIdentifiers(source)
  local PFPs = {}

  for _, id in pairs(ids) do
      local key, value = string.match(id, "([^:]+):(.+)")
      if key and value then
          if key == "steam" then
            PerformHttpRequest("http://steamcommunity.com/profiles/"..tonumber(ids.steam:gsub("steam:", ""), 16).."/?xml=1", function(err, text, headers)
                  if text then
                      local SteamProfileSplitted = stringsplit(text, '\n')
                      for i, Line in ipairs(SteamProfileSplitted) do
                          if Line:find('<avatarFull>') then
                              PFPs["Steam"] = Line:gsub('<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
                              break
                          end
                      end
                  end
              end)
          end
      end
  end
  PFPs["Steam"] = PFPs["Steam"] or "None"
  PFPs["Discord"] = GetDiscordAvatar(source) or "None"
  PFPs["None"] = "https://imgur.com/a/vMgE7Et"
  TriggerClientEvent("RNG:setProfilePictures", source, PFPs)
end

local startingCash = 55000
local startingBank = 5000000

-- events, init user account if doesn't exist at connection
AddEventHandler("RNG:playerJoin",function(user_id,source,name,last_login)
    MySQL.query("RNG/money_init_user", {user_id = user_id, wallet = startingCash, bank = startingBank, dirtycash = 0, offshore = 0}, function(affected)
      local tmp = RNG.getUserTmpTable(user_id)
      if tmp then
        MySQL.query("RNG/get_money", {user_id = user_id}, function(rows, affected)
          if #rows > 0 then
            tmp.bank = rows[1].bank
            tmp.wallet = rows[1].wallet
            tmp.dirtycash = rows[1].dirtycash
            tmp.offshore = rows[1].offshore
          end
        end)
      end
    end)
  end)
  
  -- save money on leave
  AddEventHandler("RNG:playerLeave",function(user_id,source)
    -- (wallet,bank)
    local tmp = RNG.getUserTmpTable(user_id)
    if tmp and tmp.wallet ~= nil and tmp.bank ~= nil and tmp.dirtycash ~= nil and tmp.offshore ~= nil then
      MySQL.execute("RNG/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank, dirtycash = tmp.dirtycash, offshore = tmp.offshore})
    end
  end)
  
  -- save money (at same time that save datatables)
  AddEventHandler("RNG:save", function()
    for k,v in pairs(RNG.user_tmp_tables) do
      if v.wallet ~= nil and v.bank ~= nil then
        MySQL.execute("RNG/set_money", {user_id = k, wallet = v.wallet, bank = v.bank, dirtycash = v.dirtycash, offshore = v.offshore})
      end
    end
  end)

RegisterNetEvent('RNG:giveCashToPlayer')
AddEventHandler('RNG:giveCashToPlayer', function(nplayer)
  local source = source
  local user_id = RNG.getUserId(source)
  if user_id ~= nil then
    if nplayer ~= nil then
      local nuser_id = RNG.getUserId(nplayer)
      if nuser_id ~= nil then
        RNG.prompt(source,lang.money.give.prompt(),"",function(source,amount)
          local amount = parseInt(amount)
          if amount > 0 and RNG.tryPayment(user_id,amount) then
            RNG.giveMoney(nuser_id,amount)
            RNGclient.notify(source,{lang.money.given({getMoneyStringFormatted(math.floor(amount))})})
            RNGclient.notify(nplayer,{lang.money.received({getMoneyStringFormatted(math.floor(amount))})})
            RNG.sendWebhook('give-cash', "RNG Give Cash Logs", "> Player Name: **"..RNG.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..RNG.getPlayerName(nplayer).."**\n> Target PermID: **"..nuser_id.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**")
          else
            RNGclient.notify(source,{lang.money.not_enough()})
          end
        end)
      else
        RNGclient.notify(source,{lang.common.no_player_near()})
      end
    else
      RNGclient.notify(source,{lang.common.no_player_near()})
    end
  end
end)


function Comma(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

RegisterServerEvent("RNG:takeAmount")
AddEventHandler("RNG:takeAmount", function(amount)
    local source = source
    local user_id = RNG.getUserId(source)
    if RNG.tryFullPayment(user_id,amount) then
      RNGclient.notify(source,{'~g~Paid £'..getMoneyStringFormatted(amount)..'.'})
      return
    end
end)

RegisterServerEvent('RNG:requestPlayerBankBalance')
AddEventHandler('RNG:requestPlayerBankBalance', function()
    local user_id = RNG.getUserId(source)
    local bank = RNG.getBankMoney(user_id)
    local wallet = RNG.getMoney(user_id)
    local dirtycash = RNG.getDirtyCash(user_id)
    local offshore = RNG.getOffshoreMoney(user_id)
    local hours = RNG.GetPlayTime(user_id)
    TriggerClientEvent('RNG:setDisplayMoney', source, wallet)
    TriggerClientEvent('RNG:setDisplayBankMoney', source, bank)
    TriggerClientEvent('RNG:initMoney', source, wallet, bank, hours)
    TriggerClientEvent('RNG:setDisplayRedMoney', source, dirtycash)
    TriggerClientEvent('RNG:setDisplayOffshore', source, offshore)
end)

RegisterServerEvent('RNG:phonebalance')
AddEventHandler('RNG:phonebalance', function()
    local bankM = RNG.getBankMoney(user_id)
    TriggerClientEvent('RNG:initMoney', source, bankM)
end)

RegisterServerEvent("RNG:addbankphone")
AddEventHandler("RNG:addbankphone", function(id, amount)
    local source = source
    local user_id = RNG.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if RNG.getUserSource(id) then
      RNG.giveBankMoney(id, amount)
    end
end)

RegisterServerEvent("RNG:removebankphone")
AddEventHandler("RNG:removebankphone", function(id, amount)
    local source = source
    local user_id = RNG.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if RNG.getUserSource(id) then
      RNG.tryBankPayment(id, amount)
    end
end)