local MySQL = {}
local Queries = {}

-- Modified Version of MySQL - RNG

function MySQL.createCommand(queryname, query)
    if not Queries[queryname] then 
        Queries[queryname] = query
    else 
        --print('RNG_DB_DRIVER: Error query already exists.')
    end 
end

function MySQL.execute(queryname, variables)
    if Queries[queryname] then 
        if variables then 
            exports['rng']:execute(Queries[queryname], variables)
        else 
            exports['rng']:execute(Queries[queryname])
        end 
    else 
        --print('RNG_DB_DRIVER: Error query does not exist!')
    end 
end




function MySQL.asyncQuery(queryname, variables)
    if Queries[queryname] then 
        if variables then 
            local rows = exports['rng']:executeSync(Queries[queryname], variables)
            return rows
        end 
    else 
        cb({{},nil})
    end 
end



function MySQL.query(queryname, variables, cb)
    if Queries[queryname] then 
        if variables then 
            exports['rng']:execute(Queries[queryname], variables, function(rows, affected)
                if cb then 
                    cb(rows, affected)
                end 
            end)
        end 
    else 
        --print('RNG_DB_DRIVER: Error query does not exist!')
        cb({{},nil})
    end 
end


function MySQL.SingleQuery(query)
    exports['rng']:execute(query)
end

return MySQL
