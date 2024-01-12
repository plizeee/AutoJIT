on isAttached(processName)
    activate application "Xcode"
    delay 1 -- wait for Xcode to activate
    tell application "System Events"
        tell process "Xcode"
            -- this is the list of all elements in the debug navigator
            -- we need to iterate through each one because they aren't labeled at this level
            -- the items here could include the elements containing the process name/PID, CPU, Memory, Energy Impact, Disk, and Network
            set debugNavigatorOutlines to every outline of scroll area 1 of group 1 of window "Placeholder Ñ Placeholder.xcodeproj"
            
            -- Iterate through each outline
            repeat with anOutline in debugNavigatorOutlines
                set myRows to every row of anOutline
                
                -- Iterate through each row
                repeat with aRow in myRows
                    set firstCell to first UI element of aRow -- each row has only one cell
                    set staticTexts to every static text of firstCell -- cells can have multiple static texts
                    
                    if (count of staticTexts) ³ 1 then
                        -- if this this is the correct row, the first static text will be the process name
                        -- and if the above is true, the second static text will either be the PID or Waiting to Attach (we don't check for that since it's not needed here, but good to know)
                        if (value of item 1 of staticTexts as text) is processName then
                            return true
                        end if
                    end if
                end repeat
            end repeat
        end tell
    end tell
    return false
end isAttached

--Let's run the script with a process name as an argument
on run argv
    set processName to item 1 of argv
    isAttached(processName)
end run