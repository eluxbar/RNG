cfg = {
	Guild_ID = '1267150575699755090',
  	Multiguild = true,
  	Guilds = {
		['Main'] = '1267150575699755090', 
		['Police'] = '1202740731056230511', 
		-- ['NHS'] = '1191769483669418004',
		-- ['HMP'] = '1190718047737102436',
  	},
	RoleList = {},

	CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

cfg.Guild_Roles = {
	['Main'] = {
		['Founder'] = 1267150575930441838, -- 12
		['Lead Developer'] = 1267150575930441836, -- 11
		['Operations Manager'] = 1206277691519664138,
		['Community Manager'] = 1267150575930441834, -- 9
		['Staff Manager'] = 1267150575930441833, -- 8
		['Head Administrator'] = 1267150575930441831, -- 7
		['Senior Administrator'] = 1267150575930441830, -- 6
		['Administrator'] = 1267150575909339185, -- 5
		['Senior Moderator'] = 1268437456714207306, -- 4
		['Moderator'] = 1267150575909339184, -- 3
		['Support Team'] = 1267150575909339183, -- 2
		['Trial Staff'] = 1267150575909339182, -- 1
		['cardev'] = 1152725921762115716,
		['Cinematic'] = 1152725921317523482,
	},

	['Police'] = {
        ['Commissioner'] = 1202740739751153714,
        ['Deputy Commissioner'] = 1202740740770504714,
        ['Assistant Commissioner'] = 1202740741697310811,
        ['Dep. Asst. Commissioner'] = 1202740742519267388,
        ['Commander'] = 1202740743412912208,
		['GC Advisor'] = 1202740745220399114,
        ['Chief Superintendent'] = 1202740750882971648,
        ['Superintendent'] = 1202740751759319150,
        ['Chief Inspector'] = 1202740758684246166,
        ['Inspector'] = 1202740760315699300,
        ['Sergeant'] = 1202740762132094977,
        ['Special Constable'] = 1202740769673314396,
        ['Senior Constable'] = 1202740763876790312,
		['PC'] = 1202740764636086293,
		['PCSO'] = 1202740767643279400,
		['Large Arms Access'] = 1202740862237282385,
		['Police Horse Trained'] = 1202740879719403551,
		['Drone Trained'] = 1202740880688283849,
		['NPAS'] = 1202740846638931998,
		['K9 Trained'] = 1202740881623359520,
	},

	-- ['NHS'] = {
    --     ['NHS Head Chief'] = 1191770092468445204,
    --     ['NHS Deputy Medical Director'] = 1191770104652906538,
    --     ['NHS Assistant Medical Director'] = 1191770098978013244,
    --     ['NHS Specialist Surgeon'] = 1192504900920287282,
    --     ['NHS Surgeon'] =1192504820616151141,
    --     ['NHS Specialist Doctor'] = 1191770221481050162,
    --     ['NHS Senior Doctor'] = 1191770227155947520,
    --     ['NHS Doctor'] = 1191770232168140842,
    --     ['NHS Junior Doctor'] = 1191770237926916156,
    --     ['NHS Critical Care Paramedic'] = 1191770244386144327,
    --     ['NHS Paramedic'] = 1191770249649999994,
    --     ['NHS Trainee Paramedic'] = 1191770255329079396.
    -- },
	
	-- ['HMP'] = {
    --     ['Governor'] = 1190718445013176320,
    --     ['Deputy Governor'] = 1190718563019927572,
    --     ['Divisional Commander'] = 1130156159756681296,
    --     ['Custodial Supervisor'] = 1190731258859376730,
    --     ['Custodial Officer'] = 1190731374135607406,
    --     ['Honourable Guard'] = 1190818099696513044,
    --     ['Supervising Officer'] = 1190731478242430976,
    --     ['Principal Officer'] = 1190731629002506240, 
    --     ['Specialist Officer'] = 1190731838340214804, 
    --     ['Senior Officer'] = 1190731974441189497,
    --     ['Prison Officer'] = 1190732409172410419,
    --     ['Trainee Prison Officer'] = 1190732566286835763, 
	-- },
}

for faction_name, faction_roles in pairs(cfg.Guild_Roles) do
	for role_name, role_id in pairs(faction_roles) do
		cfg.RoleList[role_name] = role_id
	end
end


cfg.Bot_Token = 'MTEyMjY1MDQ2NjU1NjMxMzcxMQ.GC7BxW.CjpGldljV9-CPB8OK85D3bnLgz4yn9FxqePfq0'

return cfg