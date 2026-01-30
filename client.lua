-- Debug function
local function debug(message)
    if Config and Config.EnableDebug then
        print("[DEBUG]: " .. message)
    end
end

debug("Phone Alert client.lua script loaded")

-- Handle opening the input box for alerts
RegisterNetEvent("phonealert:OpenInputBox")
AddEventHandler("phonealert:OpenInputBox", function(departmentKey, alertType)
    debug("Received OpenInputBox event with departmentKey: " .. departmentKey .. ", alertType: " .. alertType)

    -- Open the keyboard input and capture the message
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 255)

    -- Wait until the user finishes typing or cancels
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    -- Get the result of the keyboard input
    local message = GetOnscreenKeyboardResult()
    if message and message ~= "" then
        -- Send the message back to the server along with the department key and alert type
        TriggerServerEvent("phonealert:submitMessage", message, departmentKey, alertType)
        debug("Submitted message to server: " .. message)
    else
        debug("No message entered for phone alert.")
    end
end)
