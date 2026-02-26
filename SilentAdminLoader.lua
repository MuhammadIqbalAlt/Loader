-- [[ CREDITS & LICENSE ]]
-- Source Code: https://github.com/MuhammadIqbalSL/NotALuaScript
-- Author: Swarman
-- Licensed under MIT License
-- [[ CONFIGURATION ]]
local SCRIPT_URL = "https://raw.githubusercontent.com/BALL-blub/NotALuaScript/main/NotAscript.lua"
local MAX_RETRIES = 3
local RETRY_DELAY = 2 -- detik

-- [[ STABLE LOADER ]]
local function SecureLoad(url)
    local attempts = 0
    local success, content = false, nil

    repeat
        attempts = attempts + 1
        -- Anti-Cache: Append timestamp to force GitHub to serve the latest version
        local finalUrl = url .. "?t=" .. os.time()
        
        print("Attempting to load script... (Try " .. attempts .. "/" .. MAX_RETRIES .. ")")
        
        success, content = pcall(function()
            return game:HttpGet(finalUrl)
        end)

        if not success or not content or #content < 5 then
            warn("Failed to fetch script. Retrying in " .. RETRY_DELAY .. "s...")
            task.wait(RETRY_DELAY)
        else
            break
        end
    until attempts >= MAX_RETRIES

    if success and content and #content > 5 then
        local executable, err = loadstring(content)
        if executable then
            print("Script loaded successfully!")
            executable() -- Execute the script
        else
            warn("Syntax Error in script: " .. tostring(err))
        end
    else
        warn("Critical Error: Unable to fetch script after " .. MAX_RETRIES .. " attempts.")
    end
end

-- Run the loader
SecureLoad(SCRIPT_URL)
