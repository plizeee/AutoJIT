global isAttachedFile, isWaitingFile, selectDeviceFile, attachToProcessFile, detachFromProcessFile, selectProcessFile

-- Initialization function
on initialize()
    -- Get the path to the current script file
    set scriptPath to do shell script "dirname " & quoted form of POSIX path of (path to me)

    -- Set the path to isAttached.applescript and isWaiting.applescript in the scripts folder in the same directory as the current script
    set scriptsPath to scriptPath & "/scripts/"
    set isAttachedPath to scriptsPath & "isAttached.applescript"
    set isWaitingPath to scriptsPath & "isWaiting.applescript"
    set selectDevicePath to scriptsPath & "selectDevice.applescript"
    set attachToProcessPath to scriptsPath & "attachToProcess.applescript"
    set detachFromProcessPath to scriptsPath & "detachFromProcess.applescript"
    set selectProcessPath to scriptsPath & "selectProcess.applescript"

    -- Convert the isAttachedPath and isWaitingPath string to a file reference
    set isAttachedFile to POSIX file isAttachedPath
    set isWaitingFile to POSIX file isWaitingPath
    set selectDeviceFile to POSIX file selectDevicePath
    set attachToProcessFile to POSIX file attachToProcessPath
    set detachFromProcessFile to POSIX file detachFromProcessPath
    set selectProcessFile to POSIX file selectProcessPath
end initialize

-- We want to pass the name of the app and the device name
on run argv
    -- Call the initialization function
    initialize()

    -- Get the arguments passed to the script
    set processName to item 1 of argv
    set deviceName to item 2 of argv

    -- Escape any single quotes in the process name
    set processName to escapeQuotes(processName)
    set deviceName to escapeQuotes(deviceName)

    -- debug print the arguments
    log "processName: " & processName
    log "deviceName: " & deviceName

    -- Select the device we want to attach to
    selectDevice(deviceName)

    set isProcessAttached to isAttached(processName)
    set isProcessWaiting to isWaiting(processName)

    log "isAttached: " & isProcessAttached & " \nisWaiting: " & isProcessWaiting

    
    if isProcessWaiting then
        -- waitUntilAttached(processName, 15)
        -- we don't need to update isProcessWaiting because we're not using it again
        set isProcessAttached to waitUntilAttached(processName, 30)
    end if

    -- TODO rename isAttached to isAttachedOrWaiting or change the logic to be more clear
    -- Check if the app is detached
    if not isProcessAttached then
        log processName & " is not attached"

        -- Attach to the process
        attachToProcess(processName)

        -- Wait until the app is attached
        set isProcessAttached to waitUntilAttached(processName, 30)
    end if

    -- Check if the app is attached
    if isProcessAttached then
        log processName & " is attached"

        -- Select the process
        selectProcess(processName)

        -- Detach from the process
        detachFromProcess(processName)

        -- Wait until the app is detached
        set isProcessAttached to waitUntilDetached(processName, 30) -- returns true if we didn't time out

        log processName & " is detached: " & isProcessAttached
    end if

    -- Return the result of the script
    return "success"
end run

on waitUntilAttached(processName, timeoutSeconds)
    log "Waiting for " & processName & " to attach"
    -- set isProcessWaiting to true
    set isProcessAttached to false
    log "before repeat"
    repeat until isProcessAttached or timeoutSeconds is equal to 0
        log "Waiting for " & processName & " to attach... " & timeoutSeconds & " seconds remaining"
        -- set isProcessAttached to isAttached(processName)
        -- we need to do a shell command directly because applescript has very limited scope
        -- set isProcessWaiting to (do shell script "osascript " & quoted form of POSIX path of isWaitingFile & " " & processName) is equal to "true"
        set isProcessAttached to (do shell script "osascript " & quoted form of POSIX path of isAttachedFile & " " & processName) is equal to "true"
        delay 1
        set timeoutSeconds to timeoutSeconds - 1
    end repeat

    return timeoutSeconds is not equal to 0 -- return true if we didn't time out
end waitUntilAttached

on waitUntilDetached(processName, timeoutSeconds)
    log "Waiting for " & processName & " to detach"
    set isProcessAttached to true
    repeat until not isProcessAttached or timeoutSeconds is equal to 0
        set isProcessAttached to (do shell script "osascript " & quoted form of POSIX path of isAttachedFile & " " & processName) is equal to "true"
        log "Waiting for " & processName & " to detach... " & timeoutSeconds & " seconds remaining"
        delay 1
        set timeoutSeconds to timeoutSeconds - 1
    end repeat

    return timeoutSeconds is not equal to 0 -- return true if we didn't time out
end waitUntilDetached

-- TODO move this to utils
on escapeQuotes(inputText)
    set AppleScript's text item delimiters to "'"
    set the itemList to every text item of inputText
    set AppleScript's text item delimiters to "\\'"
    set escapedText to the itemList as string
    set AppleScript's text item delimiters to ""
    return escapedText
end escapeQuotes

-- Check if the app is attached to the device
-- This includes both attached and waiting for attach
on isAttached(processName)
    -- Get the result of the isAttached.applescript script
    set isAttached to (do shell script "osascript " & quoted form of POSIX path of isAttachedFile & " " & processName)

    -- returns a string because of the way osascript works
    return isAttached is equal to "true"
end isAttached

-- Check if the app is waiting for attach
on isWaiting(processName)
    -- Get the result of the isWaiting.applescript script
    set isWaiting to (do shell script "osascript " & quoted form of POSIX path of isWaitingFile & " " & processName)

    -- returns a string because of the way osascript works
    return isWaiting is equal to "true"
end isWaiting

-- Select the device we want to attach to
on selectDevice(deviceName)
    -- Get the result of the selectDevice.applescript script
    set result to (do shell script "osascript " & quoted form of POSIX path of selectDeviceFile & " " & deviceName)
    return result
end selectDevice

-- Select the device we want to attach to and the process we want to attach to
-- The steps are: Debug -> Attach to Process by PID or Name -> Select the process
on attachToProcess(processName)
    -- Get the result of the attachToProcess.applescript script
    set result to (do shell script "osascript " & quoted form of POSIX path of attachToProcessFile & " " & processName)
    return result
end attachToProcess

on detachFromProcess(processName)
    -- Get the result of the detachFromProcess.applescript script
    set result to (do shell script "osascript " & quoted form of POSIX path of detachFromProcessFile & " " & processName)
    return result
end detachFromProcess

on selectProcess(processName)
    -- Get the result of the selectProcess.applescript script
    set result to (do shell script "osascript " & quoted form of POSIX path of selectProcessFile & " " & processName)
    return result
end selectProcess