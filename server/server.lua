
local playerRobberyTimestamps = {}
local VORPcore = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)


RegisterServerEvent('zaps:payday')
AddEventHandler('zaps:payday', function(amount)
    local xPlayer = VORPcore.getUser(source)
    local currentTime = os.time()

    local lastRobberyTime = playerRobberyTimestamps[source]
    if lastRobberyTime then
        if currentTime - lastRobberyTime < 200 then
            print(('Player %s tried to finish robbery too quickly'):format(xPlayer.identifier))
            DropPlayer(source, 'Player %s tried to finish robbery too quickly'):format(xPlayer.identifier)

            return
        end
    end

    playerRobberyTimestamps[source] = currentTime

    if xPlayer then
        if amount > 1500 then
            print(('Player %s tried to claim an invalid amount: %s'):format(xPlayer.identifier, amount))
            DropPlayer(source, 'Player %s tried to claim an invalid amount: %s'):format(xPlayer.identifier, amount)
            return
        end
        local Player = VORPcore.getUser(source).getUsedCharacter
        Player.addCurrency(0, Config.rewardAmount)
    end
end)


RegisterNetEvent('zaps:storeRobberyStarted')
AddEventHandler('zaps:storeRobberyStarted', function(storeName)
  
end)



function zapsupdatee()
    local githubRawUrl = "https://raw.githubusercontent.com/Zaps6000/base/main/api.json"
    local resourceName = "bankrobbery" 
    
    PerformHttpRequest(githubRawUrl, function(statusCode, responseText, headers)
        if statusCode == 200 then
            local responseData = json.decode(responseText)
    
            if responseData[resourceName] then
                local remoteVersion = responseData[resourceName].version
                local description = responseData[resourceName].description
                local changelog = responseData[resourceName].changelog
    
                local manifestVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
    
                print("Resource: " .. resourceName)
                print("Manifest Version: " .. manifestVersion)
                print("Remote Version: " .. remoteVersion)
                print("Description: " .. description)
    
                if manifestVersion ~= remoteVersion then
                    print("Status: Out of Date (New Version: " .. remoteVersion .. ")")
                    print("Changelog:")
                    for _, change in ipairs(changelog) do
                        print("- " .. change)
                    end
                    print("Link to Updates: https://zaps6000.tebex.io/ https://discord.gg/cfxdev")
                else
                    print("Status: Up to Date")
                end
            else
                print("Resource name not found in the response.")
            end
        else
            print("HTTP request failed with status code: " .. statusCode)
        end
    end, "GET", nil, json.encode({}), {})
    end
  AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
if resource == 'zaps_bankrobbery' then
zapsupdatee()
else 
print("[ALERT!!! Please rename your resource to zaps_bankrobbery") -- Please do not edit this is how I keep track of how many servers use it.
end
end
end)
