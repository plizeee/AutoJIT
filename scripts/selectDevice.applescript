-- select device we want to attach to
-- go to menu bar 1, select menu bar item "Product", select menu item "Destination", select menu item devce name

on selectDevice(deviceName)
    tell application "System Events"
        tell process "Xcode"
            tell menu bar 1
                tell menu bar item "Product"
                    tell menu 1
                        tell menu item "Destination"
                            click
                            tell menu 1
                                tell menu item deviceName
                                    click
                                end tell
                            end tell
                        end tell
                    end tell
                end tell
            end tell
        end tell
    end tell
end selectDevice

on run argv
    set deviceName to item 1 of argv
    selectDevice(deviceName)
end run