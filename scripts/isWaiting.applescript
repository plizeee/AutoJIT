on isWaiting(processName)
    set isWaiting to true
    set doesProcessExist to false

    tell application "System Events"
        tell process "Xcode"
            -- this is the list of all elements in the debug navigator
            -- we need to iterate through each one because they aren't labeled at this level
            -- the items here could include the elements containing the process name/PID, CPU, Memory, Energy Impact, Disk, and Network
            -- set debugNavigatorOutlines to every outline of scroll area 1 of group 1 of window "Placeholder Ñ Placeholder.xcodeproj"
            set debugNavigatorOutlines to every outline of scroll area 1 of group 1 of window 1
            
            -- Iterate through each outline
            repeat with anOutline in debugNavigatorOutlines
                set myRows to every row of anOutline
                
                -- Iterate through each row
                repeat with aRow in myRows
                    set firstCell to first UI element of aRow -- each row has only one cell
                    set staticTexts to every static text of firstCell -- cells can have multiple static texts

                    set item1 to value of item 1 of staticTexts as text

                    if item1 is processName then
                        set doesProcessExist to true
                    else if doesProcessExist and item1 is "CPU" then
                        -- display notification item1 with title "Xcode"
                        return false
                    end if
                end repeat
            end repeat
        end tell
    end tell
    return doesProcessExist
end isWaiting

-- Let's run the script with a process name as an argument
on run argv
    set processName to item 1 of argv
    return isWaiting(processName)
end run