-- select device we want to attach to
-- go to menu bar 1, select menu bar item "Product", select menu item "Destination", select menu item devce name

on selectDevice(deviceName)
    -- set frontmost of application "Xcode" to true
    -- activate application "Xcode"
    tell application "System Events"
        tell process "Xcode"
            tell menu bar 1
                tell menu bar item "Product"
                    tell menu "Product"
                        tell menu item "Destination"
                            tell menu "Destination"
                                set menuItemNames to name of every menu item
                                -- log menuItemNames
                                -- Rest of your code to click the menu item
                                click menu item deviceName
                            end tell
                        end tell
                    end tell
                end tell
            end tell
        end tell
    end tell

end selectDevice

-- TODO move this to utils
on removeEscapeCharacters(argv)
    -- we need to remove escape characters from device name so that we don't split it into multiple arguments
    -- e.g. "Pliz\'s iPhone" should be "Pliz's iPhone"
    set deviceName to ""
    repeat with i from 1 to count of argv
        if i > 1 then
            set deviceName to deviceName & " "
        end if
        set deviceName to deviceName & item i of argv
    end repeat
    return deviceName
end removeEscapeCharacters


on run argv
    set deviceName to removeEscapeCharacters(argv)

    selectDevice(deviceName)

    return deviceName
end run