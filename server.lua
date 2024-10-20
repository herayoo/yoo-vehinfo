local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('yoo:permkontrolu', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player and Player.PlayerData and Player.PlayerData.job and Player.PlayerData.job.name then
        for _, job in pairs(Config.Jobs) do
            if Player.PlayerData.job.name == job then
                cb(true)
                return 
            end
        end
    end

    cb(false)
end)
