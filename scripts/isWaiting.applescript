on isWaiting(processName)
    tell application "System Events"
        tell process "Xcode"
            set myOutlines to every outline of scroll area 1 of group 1 of window "Placeholder Ñ Placeholder.xcodeproj"
            
            -- Iterate through each outline
            repeat with anOutline in myOutlines
                set myRows to every row of anOutline
                
                -- Iterate through each row
                repeat with aRow in myRows
                    set firstCell to first UI element of aRow
                    set staticTexts to every static text of firstCell
                    
                    if (count of staticTexts) ³ 2 then
                        if (value of item 1 of staticTexts as text) is processName then
                            if (value of item 2 of staticTexts as text) is "Waiting to Attach" then
                                return true
                            end if
                        end if
                    end if
                end repeat
            end repeat
        end tell
    end tell
    return false
end isWaiting

-- Let's run the script with a process name as an argument
on run argv
    set processName to item 1 of argv
    return isWaiting(processName)
end run