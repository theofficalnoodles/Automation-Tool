#Requires AutoHotkey v1.1
#SingleInstance Force

; ============================================
; AUTOMATION TOOL
; ============================================
; Features: Key Spam, Auto Clicker, Hotkey Customization
; Compatible with any game, application, or workflow

; Variables
keySpamRunning := false
autoClickerRunning := false
selectedKey := "z"
keySpamDelay := 50
clickerDelay := 50
clickerButton := "Left"

; Create Main GUI
Gui, Color, 2d2d2d
Gui, Font, cFFFFFF s10, Segoe UI

; Title
Gui, Add, Text, x10 y10 w300 h25 cFFAA00, AUTOMATION TOOL
Gui, Add, Text, x10 y35 w300 h20 c999999, Universal Macro for Any Task

; ============================================
; KEY SPAM SECTION
; ============================================
Gui, Add, GroupBox, x10 y60 w310 h140 cFFFFFF, KEY SPAM
Gui, Add, Text, x20 y80 w100 cFFFFFF, Select Key:
Gui, Add, Edit, x150 y75 w160 h25 c000000 vKeyInput, z
Gui, Add, Button, x20 y110 w140 h30 gSetKey cFFAA00, Set Key
Gui, Add, Text, x170 y110 w150 h30 vKeySpamStatus cGreen, Status: STOPPED

Gui, Add, Text, x20 y150 w100 cFFFFFF, Spam Speed (ms):
Gui, Add, Edit, x150 y145 w160 h25 c000000 vKeySpamDelayInput, 50
Gui, Add, Button, x20 y180 w140 h30 gUpdateKeySpeed cFFAA00, Update Speed
Gui, Add, Text, x170 y180 w150 h25 cYellow, F7: Start | F8: Stop

; ============================================
; AUTO CLICKER SECTION
; ============================================
Gui, Add, GroupBox, x10 y210 w310 h140 cFFFFFF, AUTO CLICKER
Gui, Add, Text, x20 y230 w100 cFFFFFF, Click Button:
Gui, Add, DropDownList, x150 y225 w160 h30 vClickButtonDropdown, Left|Right|Middle
GuiControl, ChooseString, ClickButtonDropdown, Left

Gui, Add, Text, x20 y265 w100 cFFFFFF, Click Speed (ms):
Gui, Add, Edit, x150 y260 w160 h25 c000000 vClickerDelayInput, 50
Gui, Add, Button, x20 y295 w140 h30 gUpdateClickerSpeed cFFAA00, Update Speed
Gui, Add, Text, x170 y295 w150 h25 cYellow, F5: Start | F6: Stop

; ============================================
; HOTKEY CUSTOMIZATION SECTION
; ============================================
Gui, Add, GroupBox, x10 y360 w310 h120 cFFFFFF, HOTKEY SETTINGS
Gui, Add, Text, x20 y380 w80 cFFFFFF, Key Spam Start:
Gui, Add, Hotkey, x110 y375 w150 h25 vKeySpamStartHotkey, F7

Gui, Add, Text, x20 y415 w80 cFFFFFF, Key Spam Stop:
Gui, Add, Hotkey, x110 y410 w150 h25 vKeySpamStopHotkey, F8

Gui, Add, Text, x20 y450 w80 cFFFFFF, Clicker Start:
Gui, Add, Hotkey, x110 y445 w150 h25 vClickerStartHotkey, F5

Gui, Add, Text, x20 y485 w80 cFFFFFF, Clicker Stop:
Gui, Add, Hotkey, x110 y480 w150 h25 vClickerStopHotkey, F6

Gui, Add, Button, x20 y525 w140 h30 gApplyHotkeys cFFAA00, Apply Hotkeys
Gui, Add, Text, x170 y525 w150 h35 cYellow, Changes apply immediately

; ============================================
; INFO SECTION
; ============================================
Gui, Add, GroupBox, x10 y570 w310 h60 cFFFFFF, CURRENT STATUS
Gui, Add, Text, x20 y590 w290 vCurrentStatus cLime, Key Spam: Stopped | Clicker: Stopped

; Show GUI
Gui, Show, w330 h665, Automation Tool
return

; ============================================
; KEY SPAM FUNCTIONS
; ============================================

F7::
{
    global keySpamRunning, selectedKey, keySpamDelay
    if (!keySpamRunning)
    {
        keySpamRunning := true
        GuiControl, +cGreen, KeySpamStatus, Status: RUNNING ▶
        UpdateStatus()
        
        Loop
        {
            if (!keySpamRunning)
                break
            Send, %selectedKey%
            Sleep, %keySpamDelay%
        }
    }
}
return

F8::
{
    global keySpamRunning
    keySpamRunning := false
    GuiControl, +cRed, KeySpamStatus, Status: STOPPED
    UpdateStatus()
}
return

SetKey:
{
    global selectedKey
    GuiControlGet, inputValue, , KeyInput
    if (inputValue != "")
    {
        selectedKey := inputValue
        MsgBox, 64, Success, Key changed to: %selectedKey%
    }
}
return

UpdateKeySpeed:
{
    global keySpamDelay
    GuiControlGet, delayValue, , KeySpamDelayInput
    if (delayValue > 0)
    {
        keySpamDelay := delayValue
        MsgBox, 64, Success, Key Spam speed updated to: %delayValue%ms
    }
    else
    {
        MsgBox, 48, Error, Please enter a value greater than 0
    }
}
return

; ============================================
; AUTO CLICKER FUNCTIONS
; ============================================

F5::
{
    global autoClickerRunning, clickerButton, clickerDelay
    if (!autoClickerRunning)
    {
        autoClickerRunning := true
        GuiControl, +cGreen, AutoClickerStatus, Status: RUNNING ▶
        UpdateStatus()
        
        Loop
        {
            if (!autoClickerRunning)
                break
            Click, %clickerButton%
            Sleep, %clickerDelay%
        }
    }
}
return

F6::
{
    global autoClickerRunning
    autoClickerRunning := false
    GuiControl, +cRed, AutoClickerStatus, Status: STOPPED
    UpdateStatus()
}
return

UpdateClickerSpeed:
{
    global clickerDelay
    GuiControlGet, delayValue, , ClickerDelayInput
    if (delayValue > 0)
    {
        clickerDelay := delayValue
        MsgBox, 64, Success, Clicker speed updated to: %delayValue%ms
    }
    else
    {
        MsgBox, 48, Error, Please enter a value greater than 0
    }
}
return

; ============================================
; HOTKEY CUSTOMIZATION
; ============================================

ApplyHotkeys:
{
    global keySpamRunning, autoClickerRunning
    
    ; Stop running macros
    keySpamRunning := false
    autoClickerRunning := false
    
    GuiControlGet, newKeySpamStart, , KeySpamStartHotkey
    GuiControlGet, newKeySpamStop, , KeySpamStopHotkey
    GuiControlGet, newClickerStart, , ClickerStartHotkey
    GuiControlGet, newClickerStop, , ClickerStopHotkey
    GuiControlGet, newClickButton, , ClickButtonDropdown
    
    if (newClickButton != "")
    {
        global clickerButton
        clickerButton := newClickButton
    }
    
    MsgBox, 64, Success, Hotkeys updated! Script will restart with new settings.`n`nKey Spam Start: %newKeySpamStart%`nKey Spam Stop: %newKeySpamStop%`nClicker Start: %newClickerStart%`nClicker Stop: %newClickerStop%
}
return

; ============================================
; HELPER FUNCTIONS
; ============================================

UpdateStatus()
{
    global keySpamRunning, autoClickerRunning, selectedKey, clickerButton, keySpamDelay, clickerDelay
    
    keySpamText := keySpamRunning ? "RUNNING" : "STOPPED"
    clickerText := autoClickerRunning ? "RUNNING" : "STOPPED"
    
    statusMsg := "Key Spam (" selectedKey ", " keySpamDelay "ms): " keySpamText " | Clicker (" clickerButton ", " clickerDelay "ms): " clickerText
    GuiControl, , CurrentStatus, %statusMsg%
}

; ============================================
; GUI CLOSE
; ============================================

GuiClose:
ExitApp
