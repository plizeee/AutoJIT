-- detach from a process in Xcode
-- this assumes we have the correct process selected in the debug navigator (selectProcess.applescript)
on selectDetachFromProcess(processName)
    activate application "Xcode"
    tell application "System Events"
        tell process "Xcode"
            tell menu bar 1
                tell menu bar item "Debug"
                    tell menu "Debug"
                        click menu item ("Detach from " & processName)
                    end tell
                end tell
            end tell
        end tell
    end tell
end selectDetachFromProcess

on run argv
    set processName to item 1 of argv
    selectDetachFromProcess(processName)
end run
