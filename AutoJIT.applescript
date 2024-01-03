-- This function will open xcode
on openXcode()
    tell application "Xcode"
        activate
    end tell
end openXcode

-- Select device from the menu
-- We select the device because if you have multiple devices connected, Xcode likes to select the wrong one
on selectDevice(argv)
    tell application "System Events"
        tell process "Xcode"
            tell menu bar 1
                tell menu bar item "Product"
                    tell menu "Product"
                        tell menu item "Destination"
                            tell menu "Destination"
                                click menu item (item 2 of argv)
                            end tell
                        end tell
                    end tell
                end tell
            end tell
        end tell
    end tell
end selectDevice

-- Select Debug > Attach to Process by PID or NameÉ
on selectDebug()
    tell application "System Events"
        tell process "Xcode"
            tell menu bar 1
                tell menu bar item "Debug"
                    tell menu "Debug"
                        click menu item "Attach to Process by PID or NameÉ"
                    end tell
                end tell
            end tell
        end tell
    end tell
end selectDebug

-- Select the Attach button from the "Attach to Process by PID or Name" window
on selectAttachToProcess(argv)
    tell application "System Events"
        tell process "Xcode"
            tell window 1
                tell sheet 1
                    set value of text field 1 to item 1 of argv
                    click button "Attach"
                end tell
            end tell
        end tell
    end tell
end selectAttachToProcess


-- Select Debug > Detach from <process name>
-- This will not give us any indication if this succeeds/fails
on selectDetachFromProcess(argv)
    tell application "System Events"
        tell process "Xcode"
            tell menu bar 1
                tell menu bar item "Debug"
                    tell menu "Debug"
                        click menu item ("Detach from " & item 1 of argv)
                    end tell
                end tell
            end tell
        end tell
    end tell
end selectDetachFromProcess

-- Check if we get a pop up saying we are already attached to the process
-- It'd be nice if we could just check if the process is attached, but the ui hierarchy makes it significantly more complicated
on checkIfAlreadyAttached()
    delay 3
    set returnValue to false
    tell application "System Events"
        tell process "Xcode"
            tell window 1
                if exists sheet 1 then
                    tell sheet 1
                        if exists button "OK" then
                            click button "OK"
                            set returnValue to true
                        end if
                    end tell
                end if
            end tell
        end tell
    end tell
    return returnValue
end checkIfAlreadyAttached

-- Check for an optional "-d" flag
-- This flag determines if we detach the process
on checkForDetachFlag(argv)
    set numberOfArguments to count of argv -- count the number of arguments
    return numberOfArguments > 2 and item 3 of argv is "-d"
end run

-- Function to check for an optional "-r" flag
-- This flag determines if we reattach the process
-- I don't use this anymore, but I left it in here in case I need it later
on checkForReattachFlag(argv)
    -- count the number of arguments
    set numberOfArguments to count of argv

    -- return true if the number of arguments is more than 2 and the third argument is "-r"
    return numberOfArguments > 2 and item 3 of argv is "-r"
end run

-- Main function
on run argv
    openXcode()
    selectDevice(argv)

    -- check for the detach flag
    if checkForDetachFlag(argv) then
        selectDetachFromProcess(argv)
        return true
    end if

    -- check for the reattach flag
    if checkForReattachFlag(argv) then
        selectDetachFromProcess(argv)
    end if

    selectDebug()
    selectAttachToProcess(argv)

    -- return false if checkIfAlreadyAttached() is true
    if checkIfAlreadyAttached() then
        return false
    end if

    return true
end run