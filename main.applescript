global isAttachedFile, isWaitingFile

-- Initialization function
on initialize()
    -- Get the path to the current script file
    set scriptPath to do shell script "dirname " & quoted form of POSIX path of (path to me)

    -- Set the path to isAttached.applescript and isWaiting.applescript in the scripts folder in the same directory as the current script
    set scriptsPath to scriptPath & "/scripts/"
    set isAttachedPath to scriptsPath & "isAttached.applescript"
    set isWaitingPath to scriptsPath & "isWaiting.applescript"

    -- Convert the isAttachedPath and isWaitingPath string to a file reference
    set isAttachedFile to POSIX file isAttachedPath
    set isWaitingFile to POSIX file isWaitingPath
end initialize

-- We want to pass the name of the app and the device name
on run argv
    -- Call the initialization function
    initialize()

    -- Get the arguments passed to the script
    set appName to item 1 of argv
    set deviceName to item 2 of argv

    set isAttached to isAttached(appName)
    set isWaiting to isWaiting(appName)

    set result to "isAttached: " & isAttached & " \nisWaiting: " & isWaiting

    return result
end run

on isAttached(appName)
    -- Get the result of the isAttached.applescript script
    set isAttached to (do shell script "osascript " & quoted form of POSIX path of isAttachedFile & " " & appName)
    return isAttached
end isAttached

on isWaiting(appName)
    -- Get the result of the isWaiting.applescript script
    set isWaiting to (do shell script "osascript " & quoted form of POSIX path of isWaitingFile & " " & appName)
    return isWaiting
end isWaiting

