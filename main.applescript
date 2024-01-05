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

    set isAttached to isAttached(processName)
    set isWaiting to isWaiting(processName)

    log "isAttached: " & isAttached & " \nisWaiting: " & isWaiting

    -- If the app is not attached or waiting for attach, attach to the process
    if isAttached is equal to "false" and isWaiting is equal to "false" then
        log "Attaching to process"
        attachToProcess(processName)
    else if isAttached is equal to "true" then
        log "Detaching from process"
        detachFromProcess(processName)
    else if isWaiting is equal to "true" then
        log "Selecting process"
        selectProcess(processName)
    end if

    -- Return the result of the script
    return "success"
end run

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
    return isAttached
end isAttached

-- Check if the app is waiting for attach
on isWaiting(processName)
    -- Get the result of the isWaiting.applescript script
    set isWaiting to (do shell script "osascript " & quoted form of POSIX path of isWaitingFile & " " & processName)
    return isWaiting
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