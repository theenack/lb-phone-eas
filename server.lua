-- Debug function
local function debug(message)
    if Config and Config.EnableDebug then
        print("[DEBUG]: " .. message)
    end
end

-- Check if a player is an admin
local function isAdmin(source)
    return IsPlayerAceAllowed(source, "phonealert.admin")
end

-- Get department name from the key
local function getDepartmentName(departmentKey)
    return Config.Departments[departmentKey]
end

-- Send a log to Discord
local function logToDiscord(message, departmentName, alertType, source)
    if not Config.EnableDiscordLogging then
        debug("Discord logging is disabled; skipping log.")
        return
    end

    local playerName = GetPlayerName(source)
    local identifiers = GetPlayerIdentifiers(source)
    local steamID, discordID = "Unknown", "Unknown"

    for _, identifier in ipairs(identifiers) do
        if identifier:match("^steam:") then
            steamID = identifier
        elseif identifier:match("^discord:") then
            discordID = identifier:gsub("discord:", "")
        end
    end

    local payload = {
        username = Config.WebhookUsername,
        avatar_url = Config.WebhookAvatar,
        embeds = {
            {
                title = "Phone Emergency Alert Sent",
                description = string.format(
                    "**Message:** %s\n**Department:** %s\n**Type:** %s\n**Player Name:** %s\n**FiveM ID:** %d\n**Steam ID:** %s\n**Discord ID:** %s",
                    message, departmentName, alertType, playerName, source, steamID, discordID
                ),
                color = 16711680, -- Red
                footer = {
                    text = os.date("Date/Time: %Y-%m-%d %H:%M:%S")
                }
            }
        }
    }

    debug("Sending log to Discord webhook.")
    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers)
        if err == 200 or err == 204 then
            debug("Log successfully sent to Discord. HTTP Code: " .. tostring(err))
        else
            print("^1[ERROR]: Failed to send log to Discord. HTTP Code: " .. tostring(err) .. "^0")
        end
    end, "POST", json.encode(payload), { ["Content-Type"] = "application/json" })
end

-- Notify all clients
local function SendEmergencyNotificationToAllClients(message, title, icon)
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        debug("Sending emergency notification to player ID " .. tostring(playerId))
        exports["lb-phone"]:EmergencyNotification(tonumber(playerId), {
            title = title,
            content = message,
            icon = icon
        })
    end
end

-- Main script logic
RegisterCommand("phonealert", function(source, args, rawCommand)
    if isAdmin(source) then
        local departmentKey = args[1]

        -- Check if department key is provided and valid
        if not departmentKey or not getDepartmentName(departmentKey) then
            TriggerClientEvent('chat:addMessage', source, { 
                args = { 
                    '^1Error:', 
                    'Department key is required. Please specify a valid department key.' 
                } 
            })
            debug("Invalid or missing department key. Command execution stopped.")
            return
        end

        local alertType = args[2] or "warning"
        TriggerClientEvent("phonealert:OpenInputBox", source, departmentKey, alertType)
        debug("Authorized player issued /phonealert command with departmentKey: " .. departmentKey)
    else
        TriggerClientEvent('chat:addMessage', source, { 
            args = { '^1Error:', 'You do not have permission to use this command.' } 
        })
        debug("Unauthorized player attempted to use /phonealert command.")
    end
end)

RegisterServerEvent("phonealert:submitMessage")
AddEventHandler("phonealert:submitMessage", function(message, departmentKey, alertType)
    local source = source
    if isAdmin(source) then
        local departmentName = getDepartmentName(departmentKey)
        if not departmentName then
            TriggerClientEvent('chat:addMessage', source, { 
                args = { 
                    '^1Error:', 
                    'Invalid department key. Please specify a valid department key.' 
                } 
            })
            debug("Invalid department key in submitMessage event: " .. tostring(departmentKey))
            return
        end

        -- Send emergency notification
        SendEmergencyNotificationToAllClients(
            message,
            "Emergency Alert - " .. departmentName,
            alertType
        )
        logToDiscord(message, departmentName, alertType, source)
        debug(string.format(
            "Emergency notification sent: [Department: %s, Message: %s, Type: %s]",
            departmentName, message, alertType
        ))
    else
        TriggerClientEvent('chat:addMessage', source, { 
            args = { '^1Error:', 'You do not have permission to use this command.' } 
        })
        debug("Unauthorized player attempted to submit a message via phonealert:submitMessage.")
    end
end)

print("^2LB Phone EAS Script Loaded Successfully. Have fun and enjoy scaring people!^0")
