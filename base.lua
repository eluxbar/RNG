MySQL = module("modules/MySQL")

Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")
local whitelisted = false
local verify_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "",
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "In order to connect to RNG you must be in our discord and verify your account",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "Join the RNG discord (discord.gg/rnguk)",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "In the #verify channel, type the following command",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["text"] = "verify NULL",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["text"] = "Your account has not beem verified yet. (Attempt 0)",
                    ["wrap"] = false,
                }
            }
        },
        {
            ['type'] = 'ActionSet',
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ['actions'] = {
                {
                    ['type'] = 'Action.Submit',
                    ['title'] = 'Enter RNG',
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ['id'] = 'connectButton',
                    ['data'] = {
                        ['action'] = 'connectClicked',
                    },
                },             
            },
        },
    }
}
local connecting_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "",
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Medium",
                    ["color"] = "Warning",
                    ["text"] = "",
                    ["wrap"] = false,
                    ["isSubtle"] = true,
                },
            }
        },
        {
            ["type"] = "TextBlock",
            ["horizontalAlignment"] = "left",
            ["size"] = "Medium",
            ["color"] = "good",
            ["text"] = "You are connecting to RNG",
            ["wrap"] = false,
            ["isSubtle"] = true,
        },
    }
}


local ban_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "RNG Public",
            ["highlight"] = true,
            ["horizontalAlignment"] = "Center",
            ["size"] = "Medium",
            ["wrap"] = true,
            ["weight"] = "Bolder",
        },
        {
            ["type"] = "Container",
            ["horizontalAlignment"] = "Center",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "Ban expires in NULL",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,

                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "Your ID: NULL",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["text"] = "Reason: NULL",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Medium",
                    ["color"] = "Warning",
                    ["text"] = "If you believe this ban is invalid, please appeal on our discord",
                    ["wrap"] = false,
                    ["isSubtle"] = true,
                },
            }
        },
        {
            ['type'] = 'ActionSet',
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ['actions'] = {
                {
                    ['type'] = 'Action.OpenUrl',
                    ['title'] = 'RNG Discord',
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["url"] = "https://discord.gg/rnguk",
                },
                {
                    ['type'] = 'Action.OpenUrl',
                    ['title'] = 'RNG Support',
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["url"] = "",
                },
            },
        }
    }
}

local blockedusernames = {
    "nigger",
    "nigga",
    "wog",
    "coon",
    "paki",
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
    "nica",
    "nicca",
}




Debug.active = config.debug
RNG = {}
Proxy.addInterface("RNG",RNG)

tRNG = {}
Tunnel.bindInterface("RNG",tRNG) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
RNG.lang = Lang.new(dict)

-- init
RNGclient = Tunnel.getInterface("RNG","RNG") -- server -> client tunnel

RNG.users = {} -- will store logged users (id) by first identifier
RNG.rusers = {} -- store the opposite of users
RNG.user_tables = {} -- user data tables (logger storage, saved to database)
RNG.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
RNG.user_sources = {} -- user sources 
Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(100),
    username VARCHAR(100),
    license VARCHAR(100),
    banned BOOLEAN,
    bantime VARCHAR(100) NOT NULL DEFAULT "",
    banreason VARCHAR(1000) NOT NULL DEFAULT "",
    banadmin VARCHAR(100) NOT NULL DEFAULT "",
    baninfo VARCHAR(2000) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS cardevs (
    userid varchar(255),
    reportscompleted int,
    currentreport int,
    PRIMARY KEY(userid)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS cardev (
    reportid int NOT NULL AUTO_INCREMENT,
    spawncode varchar(255),
    issue varchar(255), 
    reporter varchar(255), 
    claimed varchar(255),
    completed boolean,
    notes varchar(255),
    PRIMARY KEY (reportid)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS completedauctions (
    auctionid int NOT NULL AUTO_INCREMENT,
    userid varchar(255),
    spawncode varchar(255),
    amount int,
    winner_discord_id varchar(255),
    admin_discord_id varchar(255),
    PRIMARY KEY (auctionid)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES rng_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_user_moneys(
    user_id INTEGER,
    wallet bigint,
    bank bigint,
    dirtycash bigint,
    offshore bigint,
    compensation bigint DEFAULT 0,
    total_amount_robbed bigint DEFAULT 0,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES rng_users(id) ON DELETE CASCADE
    );
    ]]);   
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    locked BOOLEAN NOT NULL DEFAULT 0,
    fuel_level FLOAT NOT NULL DEFAULT 100,
    impounded BOOLEAN NOT NULL DEFAULT 0,
    impound_info varchar(2048) NOT NULL DEFAULT '',
    impound_time VARCHAR(100) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES rng_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES rng_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_warnings (
    warning_id INT AUTO_INCREMENT,
    user_id INT,
    warning_type VARCHAR(25),
    duration INT,
    admin VARCHAR(100),
    warning_date DATE,
    reason VARCHAR(2000),
    point INT,
    PRIMARY KEY (warning_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_gangs (
    gangname VARCHAR(255) NULL DEFAULT NULL,
    username VARCHAR(255) NULL DEFAULT NULL,
    gangmembers VARCHAR(3000) NULL DEFAULT NULL,
    funds BIGINT NULL DEFAULT NULL,
    logs VARCHAR(3000) NULL DEFAULT NULL,
    gangfit TEXT DEFAULT NULL,
    lockedfunds BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (gangname)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_user_notes (
    user_id INT,
    info VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_homes PRIMARY KEY(home),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES rng_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_bans_offenses(
    UserID INTEGER AUTO_INCREMENT,
    Rules TEXT NULL DEFAULT NULL,
    points INT(10) NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(UserID)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_dvsa(
    user_id INT(11),
    licence VARCHAR(100) NULL DEFAULT NULL,
    testsaves VARCHAR(1000) NULL DEFAULT NULL,
    points VARCHAR(500) NULL DEFAULT NULL,
    id VARCHAR(500) NULL DEFAULT NULL,
    datelicence VARCHAR(500) NULL DEFAULT NULL,
    penalties VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_subscriptions (
    user_id INT(11),
    plathours FLOAT(10) NULL DEFAULT NULL,
    plushours FLOAT(10) NULL DEFAULT NULL,
    last_used VARCHAR(100) NOT NULL DEFAULT "",
    redeemed INT DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY (user_id)
    );
    ]]);      
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_casino_chips(
    user_id INT(11),
    chips bigint NOT NULL DEFAULT 0,
    rateback bigint NOT NULL DEFAULT 0,
    total_bets bigint NOT NULL DEFAULT 0,
    wins bigint NOT NULL DEFAULT 0,
    losses bigint NOT NULL DEFAULT 0,
    money_won bigint NOT NULL DEFAULT 0,
    money_lost bigint NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_verification(
    user_id INT(11),
    code VARCHAR(100) NULL DEFAULT NULL,
    discord_id VARCHAR(100) NULL DEFAULT NULL,
    verified TINYINT NULL DEFAULT NULL,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_community_pot (
    value BIGINT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (value)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_lottery (
    pot_value BIGINT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (pot_value)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_quests (
    user_id INT(11),
    quests_completed INT(11) NOT NULL DEFAULT 0,
    reward_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_weapon_whitelists (
    user_id INT(11),
    weapon_info varchar(2048) DEFAULT '{}',
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_weapon_codes (
    user_id INT(11),
    spawncode varchar(2048) NOT NULL DEFAULT '',
    weapon_code int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (weapon_code)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_prison (
    user_id INT(11),
    prison_time INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_staff_tickets (
    user_id INT(11),
    ticket_count INT(11) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_daily_rewards (
    user_id INT(11),
    last_reward INT(11) NOT NULL DEFAULT 0,
    streak INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS `rng_user_tokens` (
    `token` varchar(200) NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `banned` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`token`)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS `rng_user_device` (
    `devices` longtext NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `banned` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`user_id`)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_nhs_hours (
    user_id INT(11),
    weekly_hours FLOAT(10) NOT NULL DEFAULT 0,
    total_hours FLOAT(10) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    last_clocked_date VARCHAR(100) NOT NULL,
    last_clocked_rank VARCHAR(100) NOT NULL,
    total_players_revived INT(11) NOT NULL DEFAULT 0,
    total_players_bodybagged INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_police_hours (
    user_id INT(11),
    weekly_hours FLOAT(10) NOT NULL DEFAULT 0,
    total_hours FLOAT(10) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    last_clocked_date VARCHAR(100) NOT NULL,
    last_clocked_rank VARCHAR(100) NOT NULL,
    total_players_fined INT(11) NOT NULL DEFAULT 0,
    total_players_jailed INT(11) NOT NULL DEFAULT 0,
    total_players_searched INT(11) NOT NULL DEFAULT 0,
    total_amount_fined INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_stores (
    code VARCHAR(255) NOT NULL,
    item VARCHAR(255) NOT NULL,
    user_id INT(11),
    PRIMARY KEY (code)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_wager_matchhistory (
    match_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    user_id INT(11) NOT NULL,
    match_date DATETIME NOT NULL,
    opponent INT(11) NOT NULL,
    bet_amount INT(11) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (opponent) REFERENCES users(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS rng_wagers (
    user_id INT(11) NOT NULL PRIMARY KEY,
    games_played INT(11) NOT NULL,
    games_won INT(11) NOT NULL,
    games_lossed INT(11) NOT NULL,
    amount_won INT(11) NOT NULL,
    amount_lossed INT(11) NOT NULL,
    );
    ]])
    MySQL.SingleQuery("ALTER TABLE rng_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE rng_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE rng_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE rng_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE rng_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE rng_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("RNGls/create_modifications_column", "alter table rng_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("RNGls/update_vehicle_modifications", "update rng_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("RNGls/get_vehicle_modifications", "select modifications, vehicle_plate from rng_user_vehicles where user_id = @user_id and vehicle = @vehicle")
	MySQL.execute("RNGls/create_modifications_column")
    print("[RNG] ^2Base tables initialised.^0")
end)

MySQL.createCommand('RNG/CreateUser', 'INSERT INTO rng_users(license,banned) VALUES(@license,false)')
MySQL.createCommand('RNG/GetUserByLicense', 'SELECT id FROM rng_users WHERE license = @license')
MySQL.createCommand("RNG/AddIdentifier", "INSERT INTO rng_user_ids (identifier, user_id, banned) VALUES(@identifier, @user_id, false)")
MySQL.createCommand("RNG/GetUserByIdentifier", "SELECT user_id FROM rng_user_ids WHERE identifier = @identifier")
MySQL.createCommand("RNG/GetIdentifiers", "SELECT identifier FROM rng_user_ids WHERE user_id = @user_id")
MySQL.createCommand("RNG/BanIdentifier", "UPDATE rng_user_ids SET banned = @banned WHERE identifier = @identifier")

MySQL.createCommand("RNG/identifier_all","SELECT * FROM rng_user_ids WHERE identifier = @identifier")
MySQL.createCommand("RNG/select_identifier_byid_all","SELECT * FROM rng_user_ids WHERE user_id = @id")

MySQL.createCommand("RNG/set_userdata","REPLACE INTO rng_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("RNG/get_userdata","SELECT dvalue FROM rng_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("RNG/set_srvdata","REPLACE INTO rng_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("RNG/get_srvdata","SELECT dvalue FROM rng_srv_data WHERE dkey = @key")

MySQL.createCommand("RNG/get_banned","SELECT banned FROM rng_users WHERE id = @user_id")
MySQL.createCommand("RNG/set_banned","UPDATE rng_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin, baninfo = @baninfo WHERE id = @user_id")
MySQL.createCommand("RNG/set_identifierbanned","UPDATE rng_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("RNG/getbanreasontime", "SELECT * FROM rng_users WHERE id = @user_id")

MySQL.createCommand("RNG/set_last_login","UPDATE rng_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("RNG/get_last_login","SELECT last_login FROM rng_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("RNG/add_token","INSERT INTO rng_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("RNG/check_token","SELECT user_id, banned FROM rng_user_tokens WHERE token = @token")
MySQL.createCommand("RNG/check_token_userid","SELECT token FROM rng_user_tokens WHERE user_id = @id")
MySQL.createCommand("RNG/ban_token","UPDATE rng_user_tokens SET banned = @banned WHERE token = @token")
MySQL.createCommand("RNG/delete_token","DELETE FROM rng_user_tokens WHERE token = @token")
--Device Banning
MySQL.createCommand("device/add_info", "INSERT IGNORE INTO rng_user_device SET user_id = @user_id")
MySQL.createCommand("RNG/get_device", "SELECT devices FROM rng_user_device WHERE user_id = @user_id")
MySQL.createCommand("RNG/set_device", "UPDATE rng_user_device SET devices = @devices WHERE user_id = @user_id")
MySQL.createCommand("RNG/get_device_banned", "SELECT banned FROM rng_user_device WHERE devices = @devices")
MySQL.createCommand("RNG/check_device_userid","SELECT devices FROM rng_user_device WHERE user_id = @id")
MySQL.createCommand("RNG/ban_device","UPDATE rng_user_device SET banned = @banned WHERE devices = @devices")
MySQL.createCommand("RNG/check_device","SELECT user_id, banned FROM rng_user_device WHERE devices = @devices")
MySQL.createCommand("ac/delete_ban","DELETE FROM rng_anticheat WHERE @user_id = user_id")
timestamp = os.date("%H:%M:%S")
function RNG.getUsers()
    local users = {}
    for k,v in pairs(RNG.user_sources) do
        users[k] = v
    end
    return users
end
-- [[ Discord Names ]] --

discordnames = {}
function RNG.GetDiscordName(source, user_id)
    local discord_id = exports["rng"]:executeSync("SELECT discord_id FROM `rng_verification` WHERE user_id = @user_id", {user_id = user_id})[1].discord_id
    local nickname = Get_Guild_Nickname(1267150575699755090, discord_id)
    if nickname then
        discordnames[user_id] = nickname
        for k, v in pairs(RNG.getUsers()) do
            RNGclient.addDiscordNames(v, {user_id, nickname})
        end
    end
end
function RNG.SetDiscordNameAdmin(user_id, name)
    discordnames[user_id] = name
    for k,v in pairs(RNG.getUsers()) do
        RNGclient.setDiscordNames(v, {discordnames})
    end
end


RegisterServerEvent("RNG:SetDiscordName")
AddEventHandler("RNG:SetDiscordName", function()
    local source = source
    local user_id = RNG.getUserId(source)
    while user_id == nil do
        Citizen.Wait(0)
        user_id = RNG.getUserId(source)
    end
    RNG.GetDiscordName(source, user_id)
	RNGclient.setDiscordNames(source, {discordnames})
    RNGclient.addDiscordNames(-1, {user_id, nickname})
end)

function RNG.getPlayerName(source , user_id)
    if not user_id then
		user_id = RNG.getUserId(source)
	end
	return discordnames[user_id] or GetPlayerName(source)
end

Citizen.CreateThread(function()
    while true do 
        for i,v in pairs(RNG.getUsers()) do
            local source = v
            RNGclient.setDiscordNames(source, {discordnames})
        end
        Citizen.Wait(60000)
    end
end)
exports('GetDiscordName', function(source)
    return RNG.getPlayerName(source)
end)

exports('GetDiscordAvatar', function(source)
    return GetDiscordAvatar(source)
end)


-- [[ User Information ]] --


function RNG.checkidentifiers(userid,identifier,cb)
    for A,B in pairs(identifier) do
        MySQL.query("RNG/GetUserByIdentifier", {identifier = B}, function(rows, affected)
            if rows[1] then
                if rows[1].id ~= userid then
                    RNG.isBanned(rows[1].id, function(banned)
                        if banned then
                            cb(true, rows[1].id,"Ban Evading",B)
                        else
                            cb(true, rows[1].id,"Multi Accounting",B)
                        end
                    end)
                end
            else
                if A ~= "ip" then
                    MySQL.query("RNG/AddIdentifier", {identifier = B, user_id = userid})
                end
            end
        end)
    end
end

function RNG.getUserByLicense(license, cb)
    MySQL.query('RNG/GetUserByLicense', {license = license}, function(rows, affected)
        if rows[1] then
            cb(rows[1].id)
        else
            MySQL.query('RNG/CreateUser', {license = license}, function(rows, affected)
                if rows.affectedRows > 0 then
                    RNG.getUserByLicense(license, cb)
                end
            end)
            for k, v in pairs(RNG.getUsers()) do
                TriggerClientEvent("RNG:phoneNotification", v, "You have received £100,000 as someone new has joined the server", "Paycheck")
                RNG.giveBankMoney(k, 69)
            end
        end
    end)
end


function RNG.SetIdentifierban(user_id,banned)
    MySQL.query("RNG/GetIdentifiers", {user_id = user_id}, function(rows)
        if banned then
            for i=1, #rows do
                MySQL.query("RNG/BanIdentifier", {identifier = rows[i].identifier, banned = true})
                Wait(50)
            end
        else
            for i=1, #rows do
                MySQL.query("RNG/BanIdentifier", {identifier = rows[i].identifier, banned = false})
            end
        end
    end)
end

-- return identification string for the source (used for non RNG identifications, for rejected players)
function RNG.getSourceIdKey(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(Identifiers) do
        idk = idk..v
    end
    return idk
end

--- sql

function RNG.ReLoadChar(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if ids.license then
        RNG.getUserByLicense(ids.license, function(user_id)
            RNG.GetDiscordName(source, user_id)
            Wait(100)
            if user_id ~= nil then
                local name = RNG.getPlayerName(source, user_id) or discordnames[user_id]
                RNG.StoreTokens(source, user_id) 
                if RNG.rusers[user_id] == nil then
                    RNG.users[Identifiers[1]] = user_id
                    RNG.rusers[user_id] = Identifiers[1]
                    RNG.user_tables[user_id] = {}
                    RNG.user_tmp_tables[user_id] = {}
                    RNG.user_sources[user_id] = source
                    RNG.getUData(user_id, "RNG:datatable", function(sdata)
                        local data = json.decode(sdata)
                        if type(data) == "table" then RNG.user_tables[user_id] = data end
                        local tmpdata = RNG.getUserTmpTable(user_id)
                        RNG.getLastLogin(user_id, function(last_login)
                            tmpdata.last_login = last_login or ""
                            tmpdata.spawns = 0
                            local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                            MySQL.execute("RNG/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                            print("[^2"..timestamp.."^0] [^2RNG^0] "..name.." Joined | Perm ID: "..user_id)                            
                            TriggerEvent("RNG:playerJoin", user_id, source, name, tmpdata.last_login)
                            TriggerClientEvent("RNG:CheckIdRegister", source)
                        end)
                    end)
                else -- already connected
                    print("[^2"..timestamp.."^0] [^2RNG^0] "..name.." Re-Joined | Perm ID: "..user_id)     
                    TriggerEvent("RNG:playerRejoin", user_id, source, name)
                    TriggerClientEvent("RNG:CheckIdRegister", source)
                    local tmpdata = RNG.getUserTmpTable(user_id)
                    tmpdata.spawns = 0
                end
            end
        end)
    end
end

exports("rng", function(method_name, params, cb)
    if cb then 
        cb(RNG[method_name](table.unpack(params)))
    else 
        return RNG[method_name](table.unpack(params))
    end
end)

RegisterNetEvent("RNG:CheckID")
AddEventHandler("RNG:CheckID", function()
    local source = source
    local user_id = RNG.getUserId(source)
    if not user_id then
        RNG.ReLoadChar(source)
    end
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function RNG.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("RNG/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end
function RNG.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("RNG/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function RNG.fetchBanReasonTime(user_id,cbr)
    MySQL.query("RNG/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function RNG.setUData(user_id,key,value)
    MySQL.execute("RNG/set_userdata", {user_id = user_id, key = key, value = value})
end

function RNG.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    MySQL.query("RNG/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function RNG.setSData(key,value)
    MySQL.execute("RNG/set_srvdata", {key = key, value = value})
end

function RNG.getSData(key, cbr)
    local task = Task(cbr,{""})
    MySQL.query("RNG/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for RNG internal persistant connected user storage
function RNG.getUserDataTable(user_id)
    return RNG.user_tables[user_id]
end

function RNG.getUserTmpTable(user_id)
    return RNG.user_tmp_tables[user_id]
end

function RNG.isConnected(user_id)
    return RNG.rusers[user_id] ~= nil
end

function RNG.isFirstSpawn(user_id)
    local tmp = RNG.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function RNG.getUserId(source)
    if source ~= nil then
        local Identifiers = GetPlayerIdentifiers(source)
        if Identifiers ~= nil and #Identifiers > 0 then
            return RNG.users[Identifiers[1]]
        end
    end
    return nil
end

-- return source or nil
function RNG.getUserSource(user_id)
    return RNG.user_sources[user_id]
end

function RNG.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('RNG/identifier_all', {identifier = v}, function(rows)
            for i = 1,#rows do 
                if rows[i].banned then 
                    if user_id ~= rows[i].user_id then 
                        cb(true, rows[i].user_id, v)
                    end 
                end
            end
        end)
    end
end

function RNG.BanIdentifiers(user_id, value)
    MySQL.query('RNG/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("RNG/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

local Playtimes = {}

function RNG.GetPlayTime(user_id)
    local PlayerTimeInHours = Playtimes[user_id]
    
    if PlayerTimeInHours == nil then
        local data = RNG.getUserDataTable(user_id)
        if data then
            local playtime = data.PlayerTime or 0
            PlayerTimeInHours = math.floor(playtime / 60)
            Playtimes[user_id] = PlayerTimeInHours
        else
            PlayerTimeInHours = 0
        end
    end
    
    return PlayerTimeInHours
end



function calculateTimeRemaining(expireTime)
    local datetime = ''
    local expiry = os.date("%d/%m/%Y at %H:%M", tonumber(expireTime))
    local hoursLeft = ((tonumber(expireTime)-os.time()))/3600
    local minutesLeft = nil
    if hoursLeft < 1 then
        minutesLeft = hoursLeft * 60
        minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
        datetime = minutesLeft .. " mins" 
        return datetime
    else
        hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
        datetime = hoursLeft .. " hours" 
        return datetime
    end
    return datetime
end

function RNG.setBanned(user_id,banned,time,reason,admin,baninfo)
    if banned then 
        MySQL.execute("RNG/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin, baninfo = baninfo})
        RNG.BanIdentifiers(user_id, true)
        RNG.BanTokens(user_id, true)
        RNG.BanUserInfo(user_id, true)
    else 
        MySQL.execute("RNG/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  "", baninfo = ""})
        RNG.BanIdentifiers(user_id, false)
        RNG.BanTokens(user_id, false)
        RNG.BanUserInfo(user_id, false)
        MySQL.execute("ac/delete_ban", {user_id = user_id})
    end 
end

function RNG.ban(adminsource,permid,time,reason,baninfo)
    local adminPermID = RNG.getUserId(adminsource)
    local PlayerSource = RNG.getUserSource(tonumber(permid))
    local getBannedPlayerSrc = RNG.getUserSource(tonumber(permid))
    local adminname = RNG.getPlayerName(adminsource, adminPermID) or discordnames[adminPermID]
    if getBannedPlayerSrc then 
        if tonumber(time) then
            RNG.setBucket(PlayerSource, permid)
            RNG.setBanned(permid,true,time,reason,adminname,baninfo)
            RNG.kick(getBannedPlayerSrc,"Ban expires in: "..calculateTimeRemaining(time).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/rnguk") 
        else
            RNG.setBucket(PlayerSource, permid)
            RNG.setBanned(permid,true,"perm",reason,adminname,baninfo)
            RNG.kick(getBannedPlayerSrc,"Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/rnguk") 
        end
        RNGclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    else 
        if tonumber(time) then 
            RNG.setBanned(permid,true,time,reason,adminname,baninfo)
        else 
            RNG.setBanned(permid,true,"perm",reason,adminname,baninfo)
        end
        RNGclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    end
end

function RNG.banConsole(permid,time,reason)
    local adminPermID = "RNG"
    local getBannedPlayerSrc = RNG.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            RNG.setBanned(permid,true,banTime,reason, adminPermID)
            RNG.kick(getBannedPlayerSrc,"Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by RNG \nAppeal @ discord.gg/rnguk") 
        else 
            RNG.setBanned(permid,true,"perm",reason, adminPermID)
            RNG.kick(getBannedPlayerSrc,"Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by RNG \nAppeal @ discord.gg/rnguk") 
        end
        print("Successfully banned Perm ID: " .. permid)
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            RNG.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            RNG.setBanned(permid,true,"perm",reason, adminPermID)
        end
        print("Successfully banned Perm ID: " .. permid)
    end
end
function RNG.banAnticheat(permid,time,reason)
    local adminPermID = "RNG"
    local getBannedPlayerSrc = RNG.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            RNG.setBanned(permid,true,banTime,reason, adminPermID)
            Citizen.Wait(20000)
            RNG.kick(getBannedPlayerSrc,"Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by RNG \nAppeal @ discord.gg/rnguk") 
        else 
            RNG.setBanned(permid,true,"perm",reason, adminPermID)
            Citizen.Wait(20000)
            RNG.kick(getBannedPlayerSrc,"Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by RNG \nAppeal @ discord.gg/rnguk") 
        end
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            RNG.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            RNG.setBanned(permid,true,"perm",reason, adminPermID)
        end
    end
end

function RNG.banDiscord(permid,time,reason,adminPermID,baninfo)
    local getBannedPlayerSrc = RNG.getUserSource(tonumber(permid))
    if tonumber(time) then 
        local banTime = os.time()
        banTime = banTime  + (60 * 60 * tonumber(time))
        RNG.setBanned(permid,true,banTime,reason, adminPermID, baninfo)
        if getBannedPlayerSrc then 
            RNG.kick(getBannedPlayerSrc,"Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/rnguk") 
        end
    else 
        RNG.setBanned(permid,true,"perm",reason,  adminPermID)
        if getBannedPlayerSrc then
            RNG.kick(getBannedPlayerSrc,"Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/rnguk") 
        end
    end
end

function RNG.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("RNG/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("RNG/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function RNG.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("RNG/check_token", {token = token, user_id = user_id})
                if #rows > 0 then 
                if rows[1].banned then 
                    return rows[1].banned, rows[1].user_id
                end
            end
        end
    else 
        return false; 
    end
end

function RNG.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("RNG/check_token_userid", {id = user_id}, function(id)
            sleep = banned and 50 or 0
            for i = 1, #id do
                if banned then
                    MySQL.execute("RNG/ban_token", {token = id[i].token, banned = banned})

                else
                    MySQL.execute("RNG/delete_token", {token = id[i].token})
                end
                Wait(sleep)
            end
        end)
    end
end

function RNG.kick(source,reason)
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("RNG:save")
    Debug.pbegin("RNG save datatables")
    for k,v in pairs(RNG.user_tables) do
        RNG.setUData(k,"RNG:datatable",json.encode(v))
    end
    Debug.pend()
    SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()
function RNG.GetPlayerIdentifiers(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    return ids
end
local forbiddenNames = {
	"%^1",
	"%^2",
	"%^3",
	"%^4",
	"%^5",
	"%^6",
	"%^7",
	"%^8",
	"%^9",
	"%^%*",
	"%^_",
	"%^=",
	"%^%~",
	"admin",
    "nigger",
    "faggot",
    "*"
}

-- userForUpdates = {
--     ["kerr"] = "1041903927253286952",
--     ["editz"] = "1254206519873114263",
--     ["cnr"] = "609044650019258407"
-- }

-- function userUpdates(source)
-- 	if source and source > 0 then
-- 		local workingdiscord=0
-- 		for k,v in pairs(GetPlayerIdentifiers(source))do
-- 			if string.sub(v,1,string.len("discord:"))=="discord:"then
-- 				workingdiscord=string.sub(v,string.len("discord::"),#v)
-- 			end
-- 		end
-- 		return workingdiscord
-- 	end
-- 	return 0
-- end

local whitelist = false

AddEventHandler("playerConnecting", function(name, setMessage, deferrals)
    deferrals.defer()
    local source = source
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if GetNumPlayerTokens(source) <= 0 then
        deferrals.done("Please restart your game and try again.")
        return
    end
    -- if not ids.steam then
    --     deferrals.done("You Must Have Steam Running To Join This Server.")
    --     return
    -- end
    if ids.license then
        deferrals.update("[RNG] Checking For UserID...")
        RNG.getUserByLicense(ids.license, function(user_id)
            deferrals.update("[RNG] Checking For Identifiers...")
            RNG.checkidentifiers(user_id, ids, function(banned, userid, reason, identifier)
                if banned and reason == "Ban Evading" then
                    deferrals.done("\n[RNG] Permanently Banned\nUser ID: "..user_id.."\nReason: "..reason.."\nAppeal: https://discord.gg/rnguk")
                    RNG.setBanned(user_id,true,"perm","Ban Evading","RNG","ID Banned: "..userid)
                    RNG.sendWebhook('ban-evaders', 'RNG Ban Evade Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Banned PermID: **"..userid.."**\n> Banned Identifier: **"..identifier.."**")
                    return
                end
            end)
            if user_id ~= nil then
                deferrals.update("[RNG] Checking If Verified...")
                local verified = exports["rng"]:executeSync("SELECT * FROM rng_verification WHERE user_id = @user_id", { user_id = user_id })
                if #verified == 0 then
                    exports["rng"]:executeSync("INSERT IGNORE INTO rng_verification(user_id,verified) VALUES(@user_id,false)", {user_id = user_id})
                    verified = { { verified = 0 } }
                end
                Wait(1)
                if verified[1] and verified[1].verified == 0 then
                    if code == nil then
                        code = string.upper(generateUUID("verifycode", 6, "alphanumeric"))
                        exports["rng"]:executeSync("UPDATE rng_verification SET code = @code WHERE user_id = @user_id", { user_id = user_id, code = code })
                    else
                        code = string.upper(generateUUID("verifycode", 6, "alphanumeric"))
                        exports["rng"]:executeSync("UPDATE rng_verification SET code = @code WHERE user_id = @user_id", { user_id = user_id, code = code })
                    end
                    while code == nil do
                        deferrals.update("[RNG] Generating Verification Code...")
                        Wait(1000)
                    end
                    show_auth_card(code, deferrals, function(data)
                        check_verified(deferrals, code, user_id)
                    end)
                    Wait(100000)
                end
                if #verified == 1 then
                    deferrals.update("[RNG] Checking Account Identifiers...")
                    RNG.StoreTokens(source, user_id) 
                    RNG.isBanned(user_id, function(banned)
                        if not banned then
                            deferrals.update("[RNG] Fetching Token...")
                            if not RNG.checkForRole(user_id, '1267894844743745728') then
                                deferrals.done("[RNG]: Your Perm ID Is [".. user_id .."] you are required to be in the discord to join (discord.gg/rnguk)")
                                return
                            end
                            if whitelist then
                                if not RNG.checkForRole(user_id, '1267894844743745728') then
                                    deferrals.done("[RNG]: Server Is On Whitelist")
                                    return
                                end
                            end
                            deferrals.update("[RNG] Checking Ban Status...")
                            RNG.GetDiscordName(source, user_id)  
                            Wait(100)                            
                            if RNG.CheckTokens(source, user_id) then 
                                deferrals.done("[RNG]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                RNG.banConsole(user_id, "perm", "1.11 Ban Evading")
                                return
                            end
                            Wait(2000)
                            -- RNG.SteamAgeCheck(ids.steam, user_id, name)
                            deferrals.update("[RNG] Proccessing Steam Account")
                            Citizen.Wait(1000)
                            RNG.users[Identifiers[1]] = user_id
                            RNG.rusers[user_id] = Identifiers[1]
                            RNG.user_tables[user_id] = {}
                            RNG.user_tmp_tables[user_id] = {}
                            RNG.user_sources[user_id] = source
                            deferrals.update("[RNG] Checking Discord Verification Level...")
                            RNG.getUData(user_id, "RNG:datatable", function(sdata)
                                local data = json.decode(sdata)
                                if type(data) == "table" then 
                                    RNG.user_tables[user_id] = data 
                                end
                                local tmpdata = RNG.getUserTmpTable(user_id)
                                RNG.getLastLogin(user_id, function(last_login)
                                    tmpdata.last_login = last_login or ""
                                    tmpdata.spawns = 0
                                    local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                    MySQL.execute("RNG/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                    print("[^2"..timestamp.."^0] [^2RNG^0] "..RNG.getPlayerName(source).." Joined | Perm ID: "..user_id)     
                                    TriggerEvent("RNG:playerJoin", user_id, source, RNG.getPlayerName(source), tmpdata.last_login)
                                    Wait(500)
                                    deferrals.done()
                                end)
                            end)
                        else
                            RNG.fetchBanReasonTime(user_id, function(bantime, banreason, banadmin)
                                if tonumber(bantime) then 
                                    local timern = os.time()
                                    if timern > tonumber(bantime) then 
                                        RNG.setBanned(user_id, false)
                                        if RNG.rusers[user_id] == nil then
                                            RNG.users[Identifiers[1]] = user_id
                                            RNG.rusers[user_id] = Identifiers[1]
                                            RNG.user_tables[user_id] = {}
                                            RNG.user_tmp_tables[user_id] = {}
                                            RNG.user_sources[user_id] = source
                                            RNG.getUData(user_id, "RNG:datatable", function(sdata)
                                                local data = json.decode(sdata)
                                                if type(data) == "table" then 
                                                    RNG.user_tables[user_id] = data 
                                                end
                                                local tmpdata = RNG.getUserTmpTable(user_id)
                                                RNG.getLastLogin(user_id, function(last_login)
                                                    tmpdata.last_login = last_login or ""
                                                    tmpdata.spawns = 0
                                                    local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                    MySQL.execute("RNG/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                    print("[RNG] "..RNG.getPlayerName(source).." ^3Joined after their ban expired.^0 (Perm ID = "..user_id..")")
                                                    TriggerEvent("RNG:playerJoin", user_id, source, RNG.getPlayerName(source), tmpdata.last_login)
                                                    deferrals.done()
                                                end)
                                            end)
                                        else
                                            print("[RNG] "..RNG.getPlayerName(source).." ^3Re-joined after their ban expired.^0 | Perm ID = "..user_id)
                                            TriggerEvent("RNG:playerRejoin", user_id, source, RNG.getPlayerName(source))
                                            deferrals.done()
                                            local tmpdata = RNG.getUserTmpTable(user_id)
                                            tmpdata.spawns = 0
                                        end
                                    end

                                    print("[RNG] "..GetPlayerName(source).." ^1Rejected: "..banreason.."^0 | Perm ID = "..user_id)
                                    local baninfo = {}
                                    local calbantime = calculateTimeRemaining(bantime)
                                    baninfo[user_id] = {user_id = user_id, time = calbantime, reason = banreason}
                                    show_ban_card(baninfo[user_id], deferrals)
                                    --deferrals.done("\n[RNG] Ban expires in "..calculateTimeRemaining(bantime).."\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/rnguk")
                                else 
                                    print("[RNG] "..GetPlayerName(source).." ^1Rejected: "..banreason.."^0 | Perm ID = "..user_id)
                                    local baninfo = {}
                                    baninfo[user_id] = {user_id = user_id, time = "perm", reason = banreason}
                                    show_ban_card(baninfo[user_id], deferrals)
                                    --deferrals.done("\n[RNG] Permanent Ban\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/rnguk")
                                end
                            end)
                        end
                    end)
                end
            end
        end)
    end
end)
local trys = {}
function show_auth_card(code, deferrals, callback)
    if trys[code] == nil then
        trys[code] = 0
    end
    verify_card["body"][2]["items"][4]["text"] = "verify "..code
    verify_card["body"][2]["items"][4]["color"] = "Good"
    verify_card["body"][2]["items"][5]["text"] = "Your account has not been verified yet. (Attempt "..trys[code]..")"
    deferrals.presentCard(verify_card, callback)
end

function check_verified(deferrals, code, user_id, data)
    local data_verified = exports["rng"]:executeSync("SELECT verified FROM rng_verification WHERE user_id = @user_id", { user_id = user_id })
    if trys[code] == nil then
        trys[code] = 0
    end
    if trys[code] ~= 5 then
        verify_card["body"][2]["items"][4]["text"] = "Checking Verification..."
        verify_card["body"][2]["items"][4]["color"] = "Good"
        verify_card["body"][2]["items"][1]["text"] = ""
        verify_card["body"][2]["items"][2]["text"] = ""
        verify_card["body"][2]["items"][3]["text"] = ""
        verify_card["body"][2]["items"][5]["text"] = ""
        deferrals.presentCard(verify_card, callback)
        Wait(2000)
        verify_card["body"][2]["items"][1]["text"] = "In order to connect to RNG you must be in our discord and verify your account"
        verify_card["body"][2]["items"][2]["text"] = "Join the RNG discord (discord.gg/rnguk)"
        verify_card["body"][2]["items"][3]["text"] = "In the #verify channel, type the following command"
        verify_card["body"][2]["items"][4]["text"] = "verify "..code
    else
        verify_card["body"][2]["items"][1]["text"] = ""
        verify_card["body"][2]["items"][2]["text"] = ""
        verify_card["body"][2]["items"][3]["text"] = ""
        verify_card["body"][2]["items"][4]["text"] = ""
        verify_card["body"][2]["items"][5]["text"] = "You Have Reached The Maximum Amount Of Attempts"
        deferrals.presentCard(verify_card, callback)
        Wait(2000)
        deferrals.done("[RNG]: Failed to verify your account, please try again.")
        return
    end
    if data_verified[1] and data_verified[1].verified == 1 then

        verify_card["body"][2]["items"][4]["text"] = "Verification Successful!"
        verify_card["body"][2]["items"][4]["color"] = "Good"
        verify_card["body"][2]["items"][1]["text"] = ""
        verify_card["body"][2]["items"][2]["text"] = ""
        verify_card["body"][2]["items"][3]["text"] = ""
        verify_card["body"][2]["items"][5]["text"] = ""
        verify_card["body"][3] = false
        deferrals.presentCard(verify_card, callback)
        Wait(3000)
        deferrals.update("[RNG] Checking Account Identifiers...")
        if not RNG.checkForRole(user_id, '1267894844743745728') then
            deferrals.done("[RNG]: Your Perm ID Is [".. user_id .."] you are required to be in the discord to join (discord.gg/rnguk)")
            return
        end
        if whitelist then
            if not RNG.checkForRole(user_id, '1267894844743745728') then
                deferrals.done("[RNG]: Server Is On Whitelist")
                return
            end
        end
        Wait(1000)
        deferrals.update("[RNG] Getting User Name...")
        Wait(1000)
        deferrals.update("[RNG] Checking User Data...")
        Wait(1000)
        deferrals.done()
        print("[^2"..timestamp.."^0] [^2RNG^0] "..RNG.getPlayerName(user_id).." Newly Verified | Perm ID: "..user_id)
    end
    trys[code] = trys[code] + 1
    show_auth_card(code, deferrals, callback)
end
function show_ban_card(baninfo, deferrals, callback)
    if baninfo.time == "perm" then
        ban_card["body"][2]["items"][1]["text"] = "Permanent Ban"
        ban_card["body"][2]["items"][2]["text"] = "Your ID: "..baninfo.user_id
        ban_card["body"][2]["items"][3]["text"] = "Reason: "..baninfo.reason
    else
        ban_card["body"][2]["items"][1]["text"] = "Ban expires in ".. baninfo.time
        ban_card["body"][2]["items"][2]["text"] = "Your ID: "..baninfo.user_id
        ban_card["body"][2]["items"][3]["text"] = "Reason: "..baninfo.reason
    end
    deferrals.presentCard(ban_card, callback)
end

AddEventHandler('playerConnecting', function(_, _, deferrals)
    local source = source
    local user_id = RNG.getUserId(source)
    while user_id == nil do
        Wait(100)
        user_id = RNG.getUserId(source)
    end
    local discordname = RNG.getPlayerName(source) or discordnames[user_id]
    local discordpfp = GetDiscordAvatar(source)
    local numplayers = #GetPlayers() + 1
    local maxplayers = GetConvar("sv_maxclients", "32")
    local online = numplayers.."/"..maxplayers
    local discordtable = {
        response = {
            players = {
                {
                    discordname = discordname,
                    discordpfp = discordpfp,
                    online = online,
                    user_id = "ID:"..user_id,
                }
            }
        }
    }    
    discordtable = json.encode(discordtable)
    deferrals.handover({
        json = discordtable,
        rngloading = "discord"
    })
end)

AddEventHandler("playerDropped", function(reason)
    local source = source
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source, user_id) or discordnames[user_id]
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if user_id ~= nil then
        TriggerEvent("RNG:playerLeave", user_id, source)
        RNG.setUData(user_id, "RNG:datatable", json.encode(RNG.getUserDataTable(user_id)))
        print("[RNG] " .. name .. " ^1Disconnected^0 | Perm ID: "..user_id)
        RNG.users[RNG.rusers[user_id]] = nil
        RNG.rusers[user_id] = nil
        RNG.user_tables[user_id] = nil
        RNG.user_tmp_tables[user_id] = nil
        RNG.user_sources[user_id] = nil
        RNG.sendWebhook('leave', "RNG Leave Logs", "> Name: **" .. name .. "**\n> PermID: **" .. user_id .. "**\n> Temp ID: **" .. source .. "**\n> Reason: **" .. reason .. "**\n```"..ids.license.."```")
    else
        print('[RNG] SEVERE ERROR: Failed to save data for: ' .. name .. ' Rollback expected!')
    end
    RNGclient.removeBasePlayer(-1, {source})
    RNGclient.removePlayer(-1, {source})
end)

MySQL.createCommand("RNG/setusername", "UPDATE rng_users SET username = @username WHERE id = @user_id")

RegisterServerEvent("RNGcli:playerSpawned")
AddEventHandler("RNGcli:playerSpawned", function()
    local source = source
    local Identifiers = GetPlayerIdentifiers(source)
    local Tokens = GetNumPlayerTokens(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    local user_id = RNG.getUserId(source)
    local name = RNG.getPlayerName(source, user_id) or discordnames[user_id] or GetPlayerName(source)
    local player = source
    RNGclient.addBasePlayer(-1, {player, user_id})
    if user_id ~= nil then
        RNG.user_sources[user_id] = source
        local tmp = RNG.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns + 1
        local first_spawn = (tmp.spawns == 1)
        local playertokens = {} 
        for i = 1, Tokens do
            local token = GetPlayerToken(source, i)
            if token then
                if not playertokens[source] then
                    playertokens[source] = {} 
                end
                table.insert(playertokens[source], token)
            end
        end   
        RNG.sendWebhook('join', "RNG Join Logs", "> Name : **" .. name .. "**\n> TempID: **" .. source .. "**\n> PermID: **" .. user_id .. "**\n```"..ids.license.."\n\n"..table.concat(playertokens[source], "\n\n").."```")
        if first_spawn then
            for k, v in pairs(RNG.user_sources) do
                RNGclient.addPlayer(source, {v})
            end
            RNGclient.addPlayer(-1, {source})
            MySQL.execute("RNG/setusername", {user_id = user_id, username = name})
        end
        TriggerEvent("RNG:playerSpawn", user_id, player, first_spawn)
        TriggerClientEvent("RNG:onClientSpawn", player, user_id, first_spawn)
        -- TriggerEvent('RNG:sendPLAYTIME')
    end
end)
RegisterServerEvent("RNG:playerRespawned")
AddEventHandler("RNG:playerRespawned", function()
    local source = source
    TriggerClientEvent('RNG:ForceRefreshData', -1)
    TriggerClientEvent('RNG:onClientSpawn', source)
end)

local Online = true
exports("getServerStatus", function(params, cb)
    if not Online then
        cb("🛑 Offline")
    else
        cb("✅ Online")
    end
end)

exports("getConnected", function(params, cb)
    if RNG.getUserSource(params[1]) then
        cb('connected')
    else
        cb('not connected')
    end
end)

function RNG.SteamAgeCheck(steam, user_id,name)
    local steam64 = tonumber(steam:gsub("steam:", ""), 16)
    PerformHttpRequest("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=8D1DF36F763A41498AAEFB7E6F6E3C84&steamids=" .. steam64, function(statusCode, text, headers)
        if statusCode == 200 and text ~= nil then
            local data = json.decode(text)
            if data["response"]["players"][1] and data["response"]["players"][1]["timecreated"] then
                timecreated = data["response"]["players"][1]["timecreated"]
                timecreated = math.floor((os.time() - timecreated) / 86400)
            else
                timecreated = false
            end
            profileVisibility = data['response']['players'][1]['communityvisibilitystate']
        else
            timecreated = 20
        end
        gotAccount = true
        if timecreated < 20 then
            RNG.sendWebhook('steam', 'Steam Account Age', "> Player Name: **" .. name .. "**\n> Player Perm ID: **" .. user_id .. "**\n> Steam Account Age: **" .. timecreated .. "**\n> Steam: **" .. steam .. "**")
        end
    end, "GET", json.encode({}), {["Content-Type"] = 'application/json'})
end


function RNG.NameCheck(name, cb)
    for v in pairs(forbiddenNames) do
        if(string.gsub(string.gsub(string.gsub(string.gsub(name:lower(), "-", ""), ",", ""), "%.", ""), " ", ""):find(forbiddenNames[v])) then
            cb(true)
            return
        end
    end
end


local devs = {
    [1] = true,
    [2] = true,
    [3] = false,
}


function RNG.isDeveloper(user_id)
    if user_id ~= nil then
        return devs[tonumber(user_id)]
    end
end