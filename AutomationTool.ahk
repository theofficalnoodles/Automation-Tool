#Requires AutoHotkey v1.1
#SingleInstance Force

; ============================================
; AUTOMATION TOOL - PROFESSIONAL VERSION
; ============================================

keySpamRunning := false
autoClickerRunning := false
keySequenceRunning := false

selectedKey1 := "z"
selectedKey2 := ""
keyDelay1 := 50
keyDelay2 := 50

clickerDelay := 50
clickerButton := "Left"

currentProfile := ""

keySeqKeys := []
keySeqDelays := []
Loop, 10
{
    keySeqKeys[A_Index] := ""
    keySeqDelays[A_Index] := 50
}

configFolder := A_AppData "\AutomationTool\Configs"
if !FileExist(configFolder)
    FileCreateDir, %configFolder%

Gui, Color, 2d2d2d
Gui, Font, cFFFFFF s9, Segoe UI

; ============================================
; HEADER & PROFILES
; ============================================
Gui, Add, Text, x10 y10 w800 h25 cFFAA00, AUTOMATION TOOL
Gui, Add, Text, x10 y35 w800 h15 c999999, Universal Macro for Any Task

Gui, Add, GroupBox, x10 y55 w800 h80 cFFFFFF, PROFILES & CONFIGS

Gui, Add, Text, x20 y75 w140 cFFFFFF, Select Saved Config:
Gui, Add, DropDownList, x170 y70 w200 h30 vProfileList
RefreshProfileList()

Gui, Add, Button, x385 y70 w55 h30 gLoadProfile cGreen, Load
Gui, Add, Button, x450 y70 w55 h30 gDeleteProfile cRED, Delete
Gui, Add, Button, x515 y70 w55 h30 gRefreshProfiles cBlue, Refresh

Gui, Add, Text, x20 y110 w140 cFFFFFF, Create New Config:
Gui, Add, Edit, x170 y105 w200 h25 c000000 vNewProfileName,
Gui, Add, Button, x385 y105 w90 h25 gCreateProfile cFFAA00, Save New
Gui, Add, Button, x485 y105 w100 h25 gUpdateProfile cFFFF00, Update Current

; ============================================
; TABS
; ============================================
Gui, Add, Tab3, x10 y145 w810 h470 vMainTab, Key Spam|Auto Clicker|Seq (1-5)|Seq (6-10)|Settings

; ============================================
; TAB 1: KEY SPAM
; ============================================

Gui, Add, GroupBox, x20 y175 w790 h150 cFFFFFF, KEY SPAM SETTINGS

Gui, Add, Text, x30 y195 w200 cFFFFFF, Key 1 (Required):
Gui, Add, Edit, x250 y190 w150 h25 c000000 vKeyInput1, z

Gui, Add, Text, x30 y230 w200 cFFFFFF, Key 2 (Optional):
Gui, Add, Edit, x250 y225 w150 h25 c000000 vKeyInput2,

Gui, Add, Text, x450 y195 w200 cFFFFFF, Key 1 Delay (ms):
Gui, Add, Edit, x700 y190 w80 h25 c000000 vKeyDelay1Input, 50

Gui, Add, Text, x450 y230 w200 cFFFFFF, Key 2 Delay (ms):
Gui, Add, Edit, x700 y225 w80 h25 c000000 vKeyDelay2Input, 50

Gui, Add, Button, x30 y265 w180 h30 gSetKeysAndDelays cFFAA00, Set Keys & Delays
Gui, Add, Text, x230 y270 w350 h20 vKeySpamStatus cGreen, Status: STOPPED

Gui, Add, GroupBox, x20 y355 w790 h125 cFFFFFF, INFO

Gui, Add, Text, x30 y375 w700 cYellow, F7 = START | F8 = STOP
Gui, Add, Text, x30 y400 w700 cYellow, Press Key 1 and Key 2 (if set) repeatedly with delays
Gui, Add, Text, x30 y425 w700 cYellow, Perfect for games needing combo inputs or rapid presses
Gui, Add, Text, x30 y450 w700 vCurrentProfileKeySpam cFFAA00, Current Profile: None

; ============================================
; TAB 2: AUTO CLICKER
; ============================================

Gui, Tab, 2

Gui, Add, GroupBox, x20 y175 w790 h150 cFFFFFF, AUTO CLICKER SETTINGS

Gui, Add, Text, x30 y195 w200 cFFFFFF, Click Button:
Gui, Add, DropDownList, x250 y190 w150 h30 vClickButtonDropdown, Left|Right|Middle
GuiControl, ChooseString, ClickButtonDropdown, Left

Gui, Add, Text, x30 y240 w200 cFFFFFF, Click Delay (ms):
Gui, Add, Edit, x250 y235 w150 h25 c000000 vClickerDelayInput, 50

Gui, Add, Button, x30 y275 w180 h30 gUpdateClickerSpeed cFFAA00, Update Speed
Gui, Add, Text, x230 y280 w350 h20 vAutoClickerStatus cGreen, Status: STOPPED

Gui, Add, GroupBox, x20 y355 w790 h125 cFFFFFF, INFO

Gui, Add, Text, x30 y375 w700 cYellow, F5 = START | F6 = STOP
Gui, Add, Text, x30 y400 w700 cYellow, Automatically click your mouse (Left, Right, or Middle)
Gui, Add, Text, x30 y425 w700 cYellow, Great for clicking games, farming, or repetitive clicking
Gui, Add, Text, x30 y450 w700 vCurrentProfileClicker cFFAA00, Current Profile: None

; ============================================
; TAB 3: KEY SEQUENCE (1-5)
; ============================================

Gui, Tab, 3

Gui, Add, Text, x20 y160 w790 h20 cFFAA00, KEY SEQUENCE - Steps 1 to 5 (Leave blank to skip)
Gui, Add, GroupBox, x20 y185 w790 h280 cFFFFFF, SEQUENCE BUILDER

Gui, Add, Text, x30 y205 w100 cFFFFFF, STEP
Gui, Add, Text, x140 y205 w200 cFFFFFF, KEY
Gui, Add, Text, x350 y205 w200 cFFFFFF, DELAY (ms)

Loop, 5
{
    row := A_Index
    yPos := 235 + (row - 1) * 40
    
    Gui, Add, Text, x30 y%yPos% w100 cFFFFFF, Step %row%:
    Gui, Add, Edit, x140 y%yPos% w200 h25 c000000 vKeySeq%row%,
    Gui, Add, Edit, x350 y%yPos% w100 h25 c000000 vDelaySeq%row%, 50
}

Gui, Add, Button, x30 y525 w180 h30 gSetKeySequence cFFAA00, Save All Sequences
Gui, Add, Text, x230 y530 w350 h20 cYellow, F9 = START | F10 = STOP

; ============================================
; TAB 4: KEY SEQUENCE (6-10)
; ============================================

Gui, Tab, 4

Gui, Add, Text, x20 y160 w790 h20 cFFAA00, KEY SEQUENCE - Steps 6 to 10 (Leave blank to skip)
Gui, Add, GroupBox, x20 y185 w790 h280 cFFFFFF, SEQUENCE BUILDER

Gui, Add, Text, x30 y205 w100 cFFFFFF, STEP
Gui, Add, Text, x140 y205 w200 cFFFFFF, KEY
Gui, Add, Text, x350 y205 w200 cFFFFFF, DELAY (ms)

Loop, 5
{
    row := A_Index + 5
    yPos := 235 + (A_Index - 1) * 40
    
    Gui, Add, Text, x30 y%yPos% w100 cFFFFFF, Step %row%:
    Gui, Add, Edit, x140 y%yPos% w200 h25 c000000 vKeySeq%row%,
    Gui, Add, Edit, x350 y%yPos% w100 h25 c000000 vDelaySeq%row%, 50
}

Gui, Add, Button, x30 y525 w180 h30 gSetKeySequence cFFAA00, Save All Sequences
Gui, Add, Text, x230 y530 w350 h20 cYellow, F9 = START | F10 = STOP

; ============================================
; TAB 5: SETTINGS & INFO
; ============================================

Gui, Tab, 5

Gui, Add, GroupBox, x20 y160 w790 h90 cFFFFFF, ALL HOTKEYS

Gui, Add, Text, x30 y180 w700 cYellow, KEY SPAM: F7 = Start | F8 = Stop
Gui, Add, Text, x30 y205 w700 cYellow, AUTO CLICKER: F5 = Start | F6 = Stop
Gui, Add, Text, x30 y230 w700 cYellow, KEY SEQUENCE: F9 = Start | F10 = Stop

Gui, Add, GroupBox, x20 y265 w790 h210 cFFFFFF, FEATURE INFORMATION

Gui, Add, Text, x30 y285 w700 cFFFFFF, KEY SPAM
Gui, Add, Text, x30 y305 w700 cYellow, Press two keys repeatedly with custom delays. Perfect for combo!

Gui, Add, Text, x30 y335 w700 cFFFFFF, AUTO CLICKER
Gui, Add, Text, x30 y355 w700 cYellow, Click your mouse repeatedly. Great for clicking games!

Gui, Add, Text, x30 y385 w700 cFFFFFF, KEY SEQUENCE
Gui, Add, Text, x30 y405 w700 cYellow, Chain up to 10 keys with delays. Jump + Move + Attack!

Gui, Add, Text, x30 y435 w700 cFFFFFF, PROFILES
Gui, Add, Text, x30 y455 w700 cYellow, Save settings and load them instantly!

; ============================================
; SHOW GUI
; ============================================
Gui, Show, w830 h630, Automation Tool
return

; ============================================
; PROFILE FUNCTIONS
; ============================================

RefreshProfileList()
{
    global configFolder
    profileList := ""
    
    Loop, Files, %configFolder%\*.ini
    {
        profileName := SubStr(A_LoopFileName, 1, -4)
        if (profileList = "")
            profileList := profileName
        else
            profileList := profileList "|" profileName
    }
    
    GuiControl, , ProfileList, |%profileList%
}

RefreshProfiles:
{
    RefreshProfileList()
    ToolTip, Profiles refreshed!
    SetTimer, RemoveToolTip, 2000
}
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

CreateProfile:
{
    global configFolder, selectedKey1, selectedKey2, keyDelay1, keyDelay2, clickerDelay, clickerButton, currentProfile, keySeqKeys, keySeqDelays
    
    GuiControlGet, profileName, , NewProfileName
    
    if (profileName = "")
    {
        ToolTip, Enter a profile name!
        SetTimer, RemoveToolTip, 2000
        return
    }
    
    profileName := RegExReplace(profileName, "[^\w\s-]", "")
    profilePath := configFolder "\" profileName ".ini"
    
    if FileExist(profilePath)
    {
        ToolTip, Profile already exists!
        SetTimer, RemoveToolTip, 2000
        return
    }
    
    SaveProfileData(profilePath, profileName)
}
return

UpdateProfile:
{
    global configFolder, currentProfile
    
    if (currentProfile = "")
    {
        ToolTip, No profile loaded to update! Load one first or create new.
        SetTimer, RemoveToolTip, 2500
        return
    }
    
    profilePath := configFolder "\" currentProfile ".ini"
    SaveProfileData(profilePath, currentProfile)
    ToolTip, Profile "%currentProfile%" updated!
    SetTimer, RemoveToolTip, 2000
}
return

SaveProfileData(profilePath, profileName)
{
    global selectedKey1, selectedKey2, keyDelay1, keyDelay2, clickerDelay, clickerButton, currentProfile, keySeqKeys, keySeqDelays
    
    GuiControlGet, inputValue1, , KeyInput1
    GuiControlGet, inputValue2, , KeyInput2
    GuiControlGet, delayValue1, , KeyDelay1Input
    GuiControlGet, delayValue2, , KeyDelay2Input
    GuiControlGet, delayValueClicker, , ClickerDelayInput
    GuiControlGet, buttonValue, , ClickButtonDropdown
    
    selectedKey1 := inputValue1
    selectedKey2 := inputValue2
    keyDelay1 := delayValue1
    keyDelay2 := delayValue2
    clickerDelay := delayValueClicker
    clickerButton := buttonValue
    
    IniWrite, %inputValue1%, %profilePath%, KeySpam, Key1
    IniWrite, %inputValue2%, %profilePath%, KeySpam, Key2
    IniWrite, %delayValue1%, %profilePath%, KeySpam, Delay1
    IniWrite, %delayValue2%, %profilePath%, KeySpam, Delay2
    
    IniWrite, %delayValueClicker%, %profilePath%, Clicker, Delay
    IniWrite, %buttonValue%, %profilePath%, Clicker, Button
    
    Loop, 10
    {
        GuiControlGet, seqKey, , KeySeq%A_Index%
        GuiControlGet, seqDelay, , DelaySeq%A_Index%
        IniWrite, %seqKey%, %profilePath%, Sequence, Key%A_Index%
        IniWrite, %seqDelay%, %profilePath%, Sequence, Delay%A_Index%
        keySeqKeys[A_Index] := seqKey
        keySeqDelays[A_Index] := seqDelay
    }
    
    currentProfile := profileName
    GuiControl, , NewProfileName,
    RefreshProfileList()
    ToolTip, Profile "%profileName%" saved!
    SetTimer, RemoveToolTip, 2000
    UpdateStatus()
}

LoadProfile:
{
    global configFolder, selectedKey1, selectedKey2, keyDelay1, keyDelay2, clickerDelay, clickerButton, currentProfile, keySeqKeys, keySeqDelays
    
    GuiControlGet, selectedProfile, , ProfileList
    
    if (selectedProfile = "")
    {
        ToolTip, No profile selected!
        SetTimer, RemoveToolTip, 2000
        return
    }
    
    profilePath := configFolder "\" selectedProfile ".ini"
    
    if !FileExist(profilePath)
    {
        ToolTip, Profile not found!
        SetTimer, RemoveToolTip, 2000
        return
    }
    
    IniRead, key1, %profilePath%, KeySpam, Key1, z
    IniRead, key2, %profilePath%, KeySpam, Key2, 
    IniRead, delay1, %profilePath%, KeySpam, Delay1, 50
    IniRead, delay2, %profilePath%, KeySpam, Delay2, 50
    
    IniRead, clickDelay, %profilePath%, Clicker, Delay, 50
    IniRead, button, %profilePath%, Clicker, Button, Left
    
    selectedKey1 := key1
    selectedKey2 := key2
    keyDelay1 := delay1
    keyDelay2 := delay2
    clickerDelay := clickDelay
    clickerButton := button
    currentProfile := selectedProfile
    
    GuiControl, , KeyInput1, %key1%
    GuiControl, , KeyInput2, %key2%
    GuiControl, , KeyDelay1Input, %delay1%
    GuiControl, , KeyDelay2Input, %delay2%
    GuiControl, , ClickerDelayInput, %clickDelay%
    GuiControl, ChooseString, ClickButtonDropdown, %button%
    
    Loop, 10
    {
        IniRead, seqKey, %profilePath%, Sequence, Key%A_Index%, 
        IniRead, seqDelay, %profilePath%, Sequence, Delay%A_Index%, 50
        GuiControl, , KeySeq%A_Index%, %seqKey%
        GuiControl, , DelaySeq%A_Index%, %seqDelay%
        keySeqKeys[A_Index] := seqKey
        keySeqDelays[A_Index] := seqDelay
    }
    
    ToolTip, Profile loaded!
    SetTimer, RemoveToolTip, 2000
    UpdateStatus()
}
return

DeleteProfile:
{
    global configFolder
    
    GuiControlGet, selectedProfile, , ProfileList
    
    if (selectedProfile = "")
    {
        ToolTip, No profile selected!
        SetTimer, RemoveToolTip, 2000
        return
    }
    
    profilePath := configFolder "\" selectedProfile ".ini"
    FileDelete, %profilePath%
    RefreshProfileList()
    ToolTip, Profile deleted!
    SetTimer, RemoveToolTip, 2000
}
return

; ============================================
; KEY SPAM
; ============================================

F7::
{
    global keySpamRunning, selectedKey1, selectedKey2, keyDelay1, keyDelay2
    if (!keySpamRunning)
    {
        keySpamRunning := true
        GuiControl, , KeySpamStatus, Status: RUNNING
        
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
    GuiControl, , KeySpamStatus, Status: STOPPED
    UpdateStatus()
}
return

SetKeysAndDelays:
{
    global selectedKey1, selectedKey2, keyDelay1, keyDelay2
    GuiControlGet, inputValue1, , KeyInput1
    GuiControlGet, inputValue2, , KeyInput2
    GuiControlGet, delayValue1, , KeyDelay1Input
    GuiControlGet, delayValue2, , KeyDelay2Input
    
    if (inputValue1 = "")
    {
        ToolTip, Key 1 cannot be empty!
        SetTimer, RemoveToolTip, 2000
        return
    }
    
    selectedKey1 := inputValue1
    selectedKey2 := inputValue2
    keyDelay1 := delayValue1
    keyDelay2 := delayValue2
    
    ToolTip, Key Spam updated!
    SetTimer, RemoveToolTip, 2000
    UpdateStatus()
}
return

; ============================================
; AUTO CLICKER
; ============================================

F5::
{
    global autoClickerRunning, clickerButton, clickerDelay
    if (!autoClickerRunning)
    {
        autoClickerRunning := true
        GuiControl, , AutoClickerStatus, Status: RUNNING
        
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
    GuiControl, , AutoClickerStatus, Status: STOPPED
    UpdateStatus()
}
return

UpdateClickerSpeed:
{
    global clickerDelay
    GuiControlGet, delayValue, , ClickerDelayInput
    
    if (delayValue <= 0 || delayValue = "")
    {
        ToolTip, Delay must be greater than 0!
        SetTimer, RemoveToolTip, 2000
        return
    }
    
    clickerDelay := delayValue
    ToolTip, Clicker speed updated!
    SetTimer, RemoveToolTip, 2000
    UpdateStatus()
}
return

; ============================================
; KEY SEQUENCE
; ============================================

F9::
{
    global keySequenceRunning, keySeqKeys, keySeqDelays
    if (!keySequenceRunning)
    {
        keySequenceRunning := true
        
        Loop
        {
            if (!keySequenceRunning)
                break
            
            Loop, 10
            {
                if (!keySequenceRunning)
                    break
                
                key := keySeqKeys[A_Index]
                delay := keySeqDelays[A_Index]
                
                if (key != "")
                {
                    Send, %key%
                    Sleep, %delay%
                }
            }
        }
    }
}
return

F10::
{
    global keySequenceRunning
    keySequenceRunning := false
    UpdateStatus()
}
return

SetKeySequence:
{
    global keySeqKeys, keySeqDelays
    
    hasKey := false
    Loop, 10
    {
        GuiControlGet, seqKey, , KeySeq%A_Index%
        GuiControlGet, seqDelay, , DelaySeq%A_Index%
        
        if (seqKey != "")
            hasKey := true
        
        keySeqKeys[A_Index] := seqKey
        keySeqDelays[A_Index] := seqDelay
    }
    
    if (!hasKey)
    {
        ToolTip, Add at least one key to the sequence!
        SetTimer, RemoveToolTip, 2000
        return
    }
    
    ToolTip, Sequence saved!
    SetTimer, RemoveToolTip, 2000
    UpdateStatus()
}
return

; ============================================
; HELPER
; ============================================

UpdateStatus()
{
    global keySpamRunning, autoClickerRunning, selectedKey1, selectedKey2, clickerButton, keyDelay1, keyDelay2, clickerDelay, currentProfile
    
    profileDisplay := currentProfile != "" ? "Current Profile: " currentProfile : "Current Profile: None"
    GuiControl, , CurrentProfileKeySpam, %profileDisplay%
    GuiControl, , CurrentProfileClicker, %profileDisplay%
}

GuiClose:
ExitApp
