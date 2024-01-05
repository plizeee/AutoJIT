-- script to select a specific xcode process from the debug menu
-- this is gonna be a little bit tricky, but hopefully we can use similar logic to isAttached and isWaiting

on selectProcess(processName)
    tell application "System Events"
        tell process "Xcode"
            set debugNavigatorOutlines to every outline of scroll area 1 of group 1 of window "Placeholder Ñ Placeholder.xcodeproj"
            
            repeat with anOutline in debugNavigatorOutlines
                set myRows to every row of anOutline
                
                repeat with aRow in myRows
                    set firstCell to first UI element of aRow
                    set staticTexts to every static text of firstCell
                    
                    if (count of staticTexts) ³ 1 then
                        if (value of item 1 of staticTexts as text) is processName then
                            set selected of aRow to true
                            return true
                        end if
                    end if
                end repeat
            end repeat
        end tell
    end tell
    return false
end selectProcess

on run argv
    set processName to item 1 of argv
    return selectProcess(processName)
end run