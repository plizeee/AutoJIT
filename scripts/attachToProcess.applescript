-- This will attach to the process

-- Select Debug > Attach to Process by PID or Name…
on selectAttachToProcess()
    activate application "Xcode"
    tell application "System Events"
        tell process "Xcode"
            tell menu bar 1
                tell menu bar item "Debug"
                    tell menu "Debug"
                        click menu item "Attach to Process by PID or Name…"
                    end tell
                end tell
            end tell
        end tell
    end tell
end selectAttachToProcess

-- select the attach button in the dialog
on selectAttachButton(argv)
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

on run argv
    selectAttachToProcess()
    selectAttachButton(argv)
end run