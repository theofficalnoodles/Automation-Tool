#Requires AutoHotkey v1.1
#SingleInstance Force

; ============================================
; AUTOMATION TOOL - WITH CONFIGS
; ============================================
; Features: Key Spam, Auto Clicker, Config Profiles
; Compatible with any game, application, or workflow

; Variables
keySpamRunning := false
autoClickerRunning := false
selectedKey1 := "z"
selectedKey2 := ""
keyDelay1 := 50
keyDelay2 := 50
clickerDelay := 50
clickerButton := "Left"
currentProfile := ""

; Create configs folder if it doesn't exist
configFolder := A_AppData "\AutomationTool\Configs"
if !FileExist(configFolder)
{
    FileCreateDir, %configFolder%
}

; Create Main GUI
Gui, Color, 2d2d2d
Gui, Font, cFFFFFF s9, Segoe UI

; ============================================
; TITLE SECTION
; ============================================
Gui, Add, Text, x10 y10 w500 h25 cFFAA00, AUTOMATION TOOL
Gui, Add, Text, x10 y35 w500 h15 c999999, Universal Macro for Any Task

; ============================================
; PROFILES SECTION (TOP)
; ============================================
Gui, Add, GroupBox, x10 y55 w510 h90 cFFFFFF, PROFILES & CONFIGS

Gui, Add, Text, x20 y75 w150 cFFFFFF, Select Saved Config:
Gui, Add, DropDownList, x180 y70 w200 h30 vProfileList
RefreshProfileList()

Gui, Add, Button, x390 y70 w60 h30 gLoadProfile cGreen, Load
Gui, Add, Button, x460 y70 w50 h30 gDeleteProfile cRED, Delete

Gui, Add, Text, x20 y110 w150 cFFFFFF, Create New Config:
Gui, Add, Edit, x180 y105 w200 h25 c000000 vNewProfileName, 
Gui, Add, Button, x390 y105 w120 h25 gCreateProfile cFFAA00, Save as Config

Gui, Add, Text, x20 y140 w490 vProfileStatus cYellow, Ready to save/load configs

; ============================================
; KEY SPAM SECTION
; ============================================
Gui, Add, GroupBox, x10 y155 w510 h120 cFFFFFF, KEY SPAM

; Key 1
Gui, Add, Text, x20 y175 w150 cFFFFFF, Key 1:
Gui, Add, Edit, x180 y170 w100 h25 c000000 vKeyInput1, z
Gui, Add, Text, x300 y175 w80 cFFFFFF, Delay (ms):
Gui, Add, Edit, x400 y170 w80 h25 c000000 vKeyDelay1Input, 50

; Key 2
Gui, Add, Text, x20 y210 w150 cFFFFFF, Key 2 (Optional):
Gui, Add, Edit, x180 y205 w100 h25 c000000 vKeyInput2,
Gui, Add, Text, x300 y210 w80 cFFFFFF, Delay (ms):
Gui, Add, Edit, x400 y205 w80 h25 c000000 vKeyDelay2Input, 50

Gui, Add, Button, x20 y240 w140 h30 gSetKeysAndDelays cFFAA00, Set Keys & Delays
Gui, Add, Text, x180 y245 w160 h20 vKeySpamStatus cGreen, Status: STOPPED
Gui, Add, Text, x380 y245 w100 h20 cFFFF00, F7: Start | F8: Stop

; ============================================
; AUTO CLICKER SECTION
; ============================================
Gui, Add, GroupBox, x10 y285 w510 h100 cFFFFFF, AUTO CLICKER

Gui, Add, Text, x20 y305 w150 cFFFFFF, Click Button:
Gui, Add, DropDownList, x180 y300 w100 h30 vClickButtonDropdown, Left|Right|Middle
GuiControl, ChooseString, ClickButtonDropdown, Left

Gui, Add, Text, x300 y305 w80 cFFFFFF, Delay (ms):
Gui, Add, Edit, x400 y300 w80 h25 c000000 vClickerDelayInput, 50

Gui, Add, Button, x20 y340 w140 h30 gUpdateClickerSpeed cFFAA00, Update Speed
Gui, Add, Text, x180 y345 w160 h20 vAutoClickerStatus cYellow, F5: Start | F6: Stop

; ============================================
; STATUS SECTION
; ============================================
Gui, Add, GroupBox, x10 y395 w510 h120 cFFFFFF, CURRENT STATUS
Gui, Add, Text, x20 y415 w490 vCurrentStatus cLime, Key Spam: Stopped | Clicker: Stopped
Gui, Add, Text, x20 y445 w490 cYellow, F7 = Start Key Spam | F8 = Stop Key Spam
Gui, Add, Text, x20 y465 w490 cYellow, F5 = Start Clicker | F6 = Stop Clicker
Gui, Add, Text, x20 y485 w490 vCurrentProfile cFFAA00, Current Profile: None

; Show GUI
Gui, Show, w530 h530, Automation Tool
return

; ============================================
; PROFILE FUNCTIONS
; ============================================

RefreshProfileList()
{
    global configFolder
    
    profileList := ""
    
    ; Get all config files
    Loop, Files, %configFolder%\*.ini
    {
        profileName := SubStr(A_LoopFileName, 1, -4)
        if (profileList = "")
            profileList := profileName
        else
            profileList := profileList "|" profileName
    }
    
    ; Update dropdown
    GuiControl, , ProfileList, |%profileList%
}

CreateProfile:
{
    global configFolder, selectedKey1, selectedKey2, keyDelay1, keyDelay2, clickerDelay, clickerButton, currentProfile
    
    GuiControlGet, profileName, , NewProfileName
    
    if (profileName = "")
    {
        GuiControl, , ProfileStatus, ❌ Please enter a profile name!
        return
    }
    
    ; Sanitize profile name (remove invalid characters)
    profileName := RegExReplace(profileName, "[^\w\s-]", "")
    
    ; Check if profile already exists
    profilePath := configFolder "\" profileName ".ini"
    if FileExist(profilePath)
    {
        GuiControl, , ProfileStatus, ❌ Profile already exists! Use a different name.
        return
    }
    
    GuiControlGet, inputValue1, , KeyInput1
    GuiControlGet, inputValue2, , KeyInput2
    GuiControlGet, delayValue1, , KeyDelay1Input
    GuiControlGet, delayValue2, , KeyDelay2Input
    GuiControlGet, delayValueClicker, , ClickerDelayInput
    GuiControlGet, buttonValue, , ClickButtonDropdown
    
    if (inputValue1 = "")
    {
        GuiControl, , ProfileStatus, ❌ Key 1 cannot be empty!
        return
    }
    
    selectedKey1 := inputValue1
    selectedKey2 := inputValue2
    keyDelay1 := delayValue1
    keyDelay2 := delayValue2
    clickerDelay := delayValueClicker
    clickerButton := buttonValue
    
    ; Make sure directory exists
    if !FileExist(configFolder)
        FileCreateDir, %configFolder%
    
    ; Save to INI file
    IniWrite, %inputValue1%, %profilePath%, Keys, Key1
    IniWrite, %inputValue2%, %profilePath%, Keys, Key2
    IniWrite, %delayValue1%, %profilePath%, Delays, KeyDelay1
    IniWrite, %delayValue2%, %profilePath%, Delays, KeyDelay2
    IniWrite, %delayValueClicker%, %profilePath%, Delays, ClickerDelay
    IniWrite, %buttonValue%, %profilePath%, Clicker, Button
    
    ; Verify file was created
    if !FileExist(profilePath)
    {
        GuiControl, , ProfileStatus, ❌ Failed to save profile!
        return
    }
    
    currentProfile := profileName
    GuiControl, , NewProfileName,
    RefreshProfileList()
    GuiControl, , ProfileStatus, ✓ Profile "%profileName%" saved! Now select and load it.
    UpdateStatus()
}
return

LoadProfile:
{
    global configFolder, selectedKey1, selectedKey2, keyDelay1, keyDelay2, clickerDelay, clickerButton, currentProfile
    
    GuiControlGet, selectedProfile, , ProfileList
    
    if (selectedProfile = "")
    {
        GuiControl, , ProfileStatus, ❌ No profile selected! Pick one from the list above.
        return
    }
    
    profilePath := configFolder "\" selectedProfile ".ini"
    
    if !FileExist(profilePath)
    {
        GuiControl, , ProfileStatus, ❌ Profile file not found!
        return
    }
    
    ; Read from INI file
    IniRead, key1, %profilePath%, Keys, Key1, ERROR
    IniRead, key2, %profilePath%, Keys, Key2, 
    IniRead, delay1, %profilePath%, Delays, KeyDelay1, 50
    IniRead, delay2, %profilePath%, Delays, KeyDelay2, 50
    IniRead, clickDelay, %profilePath%, Delays, ClickerDelay, 50
    IniRead, button, %profilePath%, Clicker, Button, Left
    
    if (key1 = "ERROR")
    {
        GuiControl, , ProfileStatus, ❌ Could not read profile!
        return
    }
    
    ; Update variables
    selectedKey1 := key1
    selectedKey2 := key2
    keyDelay1 := delay1
    keyDelay2 := delay2
    clickerDelay := clickDelay
    clickerButton := button
    currentProfile := selectedProfile
    
    ; Update GUI
    GuiControl, , KeyInput1, %key1%
    GuiControl, , KeyInput2, %key2%
    GuiControl, , KeyDelay1Input, %delay1%
    GuiControl, , KeyDelay2Input, %delay2%
    GuiControl, , ClickerDelayInput, %clickDelay%
    GuiControl, ChooseString, ClickButtonDropdown, %button%
    
    GuiControl, , ProfileStatus, ✓ Profile "%selectedProfile%" loaded successfully!
    UpdateStatus()
}
return

DeleteProfile:
{
    global configFolder
    
    GuiControlGet, selectedProfile, , ProfileList
    
    if (selectedProfile = "")
    {
        MsgBox, 48, Error, Please select a profile to delete!
        return
    }
    
    MsgBox, 4, Confirm, Delete profile "%selectedProfile%"?
    IfMsgBox, No
        return
    
    profilePath := configFolder "\" selectedProfile ".ini"
    FileDelete, %profilePath%
    
    RefreshProfileList()
    MsgBox, 64, Success, Profile deleted!
}
return

; ============================================
; KEY SPAM HOTKEYS
; ============================================

F7::
{
    global keySpamRunning, selectedKey1, selectedKey2, keyDelay1, keyDelay2
    if (!keySpamRunning)
    {
        keySpamRunning := true
        GuiControl, +cGreen, KeySpamStatus, Status: RUNNING ▶
        UpdateStatus()
        
        Loop
        {
            if (!keySpamRunning)
                break
            Send, %selectedKey1%
            Sleep, %keyDelay1%
            if (selectedKey2 != "")
            {
                Send, %selectedKey2%
                Sleep, %keyDelay2%
            }
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

; ============================================
; AUTO CLICKER HOTKEYS
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

; ============================================
; BUTTON CALLBACKS
; ============================================

SetKeysAndDelays:
{
    global selectedKey1, selectedKey2, keyDelay1, keyDelay2
    GuiControlGet, inputValue1, , KeyInput1
    GuiControlGet, inputValue2, , KeyInput2
    GuiControlGet, delayValue1, , KeyDelay1Input
    GuiControlGet, delayValue2, , KeyDelay2Input
    
    if (inputValue1 = "")
    {
        MsgBox, 48, Error, Key 1 cannot be empty!
        return
    }
    
    if (delayValue1 <= 0 || delayValue1 = "")
    {
        MsgBox, 48, Error, Key 1 delay must be greater than 0!
        return
    }
    
    if (inputValue2 != "" && (delayValue2 <= 0 || delayValue2 = ""))
    {
        MsgBox, 48, Error, Key 2 delay must be greater than 0!
        return
    }
    
    selectedKey1 := inputValue1
    selectedKey2 := inputValue2
    keyDelay1 := delayValue1
    keyDelay2 := delayValue2
    
    msgText := "Key 1: " inputValue1 " (" delayValue1 "ms)"
    if (inputValue2 != "")
    {
        msgText := msgText "`nKey 2: " inputValue2 " (" delayValue2 "ms)"
    }
    else
    {
        msgText := msgText "`nKey 2: (empty)"
    }
    
    MsgBox, 64, Success, %msgText%
    UpdateStatus()
}
return

UpdateClickerSpeed:
{
    global clickerDelay
    GuiControlGet, delayValue, , ClickerDelayInput
    
    if (delayValue <= 0 || delayValue = "")
    {
        MsgBox, 48, Error, Please enter a value greater than 0
        return
    }
    
    clickerDelay := delayValue
    MsgBox, 64, Success, Clicker speed updated to: %delayValue%ms
    UpdateStatus()
}
return

; ============================================
; HELPER FUNCTIONS
; ============================================

UpdateStatus()
{
    global keySpamRunning, autoClickerRunning, selectedKey1, selectedKey2, clickerButton, keyDelay1, keyDelay2, clickerDelay, currentProfile
    
    keySpamText := keySpamRunning ? "RUNNING" : "STOPPED"
    clickerText := autoClickerRunning ? "RUNNING" : "STOPPED"
    
    keyDisplay := selectedKey1 " [" keyDelay1 "ms]"
    if (selectedKey2 != "")
    {
        keyDisplay := keyDisplay " + " selectedKey2 " [" keyDelay2 "ms]"
    }
    
    statusMsg := "Key Spam: " keyDisplay " - " keySpamText " | Clicker: " clickerButton " [" clickerDelay "ms] - " clickerText
    GuiControl, , CurrentStatus, %statusMsg%
    
    profileDisplay := currentProfile != "" ? "Current Profile: " currentProfile : "Current Profile: None"
    GuiControl, , CurrentProfile, %profileDisplay%
}

; ============================================
; GUI CLOSE
; ============================================

GuiClose:
ExitApp
