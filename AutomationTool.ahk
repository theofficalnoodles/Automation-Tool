#Requires AutoHotkey v1.1
#SingleInstance Force

; ============================================
; AUTOMATION TOOL - FEATURE-RICH VERSION
; ============================================

keySpamRunning := false
autoClickerRunning := false
keySequenceRunning := false
keySequencePaused := false

selectedKey1 := "z"
selectedKey2 := ""
keyDelay1 := 50
keyDelay2 := 50

clickerDelay := 50
clickerButton := "Left"

currentProfile := ""
loopCount := 0

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

Gui, Add, Text, x10 y52 w400 h15 cGreen vActiveMacro, [IDLE] No macro running

Gui, Add, GroupBox, x10 y70 w800 h75 cFFFFFF, PROFILES & CONFIGS

Gui, Add, Text, x20 y88 w130 cFFFFFF, Select Saved Config:
Gui, Add, DropDownList, x160 y83 w200 h30 vProfileList
RefreshProfileList()

Gui, Add, Button, x375 y83 w55 h30 gLoadProfile cGreen, Load
Gui, Add, Button, x440 y83 w55 h30 gDeleteProfile cRED, Delete
Gui, Add, Button, x505 y83 w55 h30 gRefreshProfiles cBlue, Refresh

Gui, Add, Text, x20 y120 w130 cFFFFFF, Create New Config:
Gui, Add, Edit, x160 y115 w200 h25 c000000 vNewProfileName,
Gui, Add, Button, x375 y115 w85 h25 gCreateProfile cFFAA00, Save New
Gui, Add, Button, x470 y115 w95 h25 gUpdateProfile cFFFF00, Update Curr

; ============================================
; TABS
; ============================================
Gui, Add, Tab3, x10 y155 w800 h470 vMainTab, Key Spam|Auto Clicker|Seq (1-5)|Seq (6-10)|Settings

; ============================================
; TAB 1: KEY SPAM
; ============================================

Gui, Add, GroupBox, x20 y185 w780 h140 cFFFFFF, KEY SPAM SETTINGS

Gui, Add, Text, x30 y205 w150 cFFFFFF, Key 1:
Gui, Add, Edit, x190 y200 w100 h25 c000000 vKeyInput1, z

Gui, Add, Text, x30 y240 w150 cFFFFFF, Key 2 (optional):
Gui, Add, Edit, x190 y235 w100 h25 c000000 vKeyInput2,

Gui, Add, Text, x320 y205 w150 cFFFFFF, Delay 1 (ms):
Gui, Add, Edit, x480 y200 w80 h25 c000000 vKeyDelay1Input, 50

Gui, Add, Text, x320 y240 w150 cFFFFFF, Delay 2 (ms):
Gui, Add, Edit, x480 y235 w80 h25 c000000 vKeyDelay2Input, 50

Gui, Add, Button, x30 y270 w160 h30 gSetKeysAndDelays cFFAA00, Set Keys & Delays
Gui, Add, Text, x210 y275 w280 h20 vKeySpamStatus cGreen, Status: STOPPED

Gui, Add, GroupBox, x20 y340 w780 h130 cFFFFFF, SPEED PRESETS

Gui, Add, Button, x30 y360 w100 h30 gKeySpamSlow cGreen, SLOW (200ms)
Gui, Add, Button, x145 y360 w100 h30 gKeySpamNormal cBlue, NORMAL (50ms)
Gui, Add, Button, x260 y360 w100 h30 gKeySpamFast cRED, FAST (10ms)

Gui, Add, Text, x30 y400 w420 cYellow, F7 = START | F8 = STOP
Gui, Add, Text, x30 y425 w420 cYellow, Perfect for combo inputs and rapid key presses

; ============================================
; TAB 2: AUTO CLICKER
; ============================================

Gui, Tab, 2

Gui, Add, GroupBox, x20 y185 w780 h140 cFFFFFF, AUTO CLICKER SETTINGS

Gui, Add, Text, x30 y205 w150 cFFFFFF, Click Button:
Gui, Add, DropDownList, x190 y200 w100 h30 vClickButtonDropdown, Left|Right|Middle
GuiControl, ChooseString, ClickButtonDropdown, Left

Gui, Add, Text, x30 y245 w150 cFFFFFF, Click Delay (ms):
Gui, Add, Edit, x190 y240 w100 h25 c000000 vClickerDelayInput, 50

Gui, Add, Button, x30 y280 w160 h30 gUpdateClickerSpeed cFFAA00, Apply Speed
Gui, Add, Text, x210 y285 w280 h20 vAutoClickerStatus cGreen, Status: STOPPED

Gui, Add, GroupBox, x20 y340 w780 h130 cFFFFFF, SPEED PRESETS

Gui, Add, Button, x30 y360 w100 h30 gClickerSlow cGreen, SLOW (200ms)
Gui, Add, Button, x145 y360 w100 h30 gClickerNormal cBlue, NORMAL (50ms)
Gui, Add, Button, x260 y360 w100 h30 gClickerFast cRED, FAST (10ms)

Gui, Add, Text, x30 y400 w420 cYellow, F5 = START | F6 = STOP
Gui, Add, Text, x30 y425 w420 cYellow, Works with Left, Right, Middle buttons

; ============================================
; TAB 3: KEY SEQUENCE (1-5)
; ============================================

Gui, Tab, 3

Gui, Add, Text, x20 y160 w780 h20 cFFAA00, KEY SEQUENCE - Steps 1 to 5

Gui, Add, GroupBox, x20 y185 w780 h270 cFFFFFF, SEQUENCE BUILDER

Gui, Add, Text, x30 y205 w100 cFFFFFF, STEP
Gui, Add, Text, x140 y205 w150 cFFFFFF, KEY
Gui, Add, Text, x300 y205 w150 cFFFFFF, DELAY (ms)

Loop, 5
{
    row := A_Index
    yPos := 235 + (row - 1) * 40
    
    Gui, Add, Text, x30 y%yPos% w100 cFFFFFF, Step %row%:
    Gui, Add, Edit, x140 y%yPos% w150 h25 c000000 vKeySeq%row%,
    Gui, Add, Edit, x300 y%yPos% w80 h25 c000000 vDelaySeq%row%, 50
}

Gui, Add, Button, x30 y520 w160 h30 gSetKeySequence cFFAA00, Save Sequence
Gui, Add, Text, x210 y525 w300 h20 cYellow, F9 = START | F10 = STOP (PAUSE)

; ============================================
; TAB 4: KEY SEQUENCE (6-10)
; ============================================

Gui, Tab, 4

Gui, Add, Text, x20 y160 w780 h20 cFFAA00, KEY SEQUENCE - Steps 6 to 10

Gui, Add, GroupBox, x20 y185 w780 h270 cFFFFFF, SEQUENCE BUILDER

Gui, Add, Text, x30 y205 w100 cFFFFFF, STEP
Gui, Add, Text, x140 y205 w150 cFFFFFF, KEY
Gui, Add, Text, x300 y205 w150 cFFFFFF, DELAY (ms)

Loop, 5
{
    row := A_Index + 5
    yPos := 235 + (A_Index - 1) * 40
    
    Gui, Add, Text, x30 y%yPos% w100 cFFFFFF, Step %row%:
    Gui, Add, Edit, x140 y%yPos% w150 h25 c000000 vKeySeq%row%,
    Gui, Add, Edit, x300 y%yPos% w80 h25 c000000 vDelaySeq%row%, 50
}

Gui, Add, Button, x30 y520 w160 h30 gSetKeySequence cFFAA00, Save Sequence
Gui, Add, Text, x210 y525 w300 h20 vLoopCounterDisplay cYellow, Loops: 0

; ============================================
; TAB 5: SETTINGS & INFO
; ============================================

Gui, Tab, 5

Gui, Add, GroupBox, x20 y160 w780 h100 cFFFFFF, ALL HOTKEYS

Gui, Add, Text, x30 y180 w350 cYellow, KEY SPAM: F7 = Start | F8 = Stop
Gui, Add, Text, x30 y205 w350 cYellow, AUTO CLICKER: F5 = Start | F6 = Stop
Gui, Add, Text, x30 y230 w350 cYellow, KEY SEQUENCE: F9 = Start | F10 = Pause

Gui, Add, GroupBox, x20 y275 w780 h180 cFFFFFF, FEATURES

Gui, Add, Text, x30 y295 w350 cFFFFFF, KEY SPAM
Gui, Add, Text, x30 y315 w350 cYellow, Two keys + custom delays. Speed presets!

Gui, Add, Text, x30 y350 w350 cFFFFFF, AUTO CLICKER
Gui, Add, Text, x30 y370 w350 cYellow, Click any button. Speed presets included!

Gui, Add, Text, x30 y405 w350 cFFFFFF, KEY SEQUENCE
Gui, Add, Text, x30 y425 w350 cYellow, Chain 10 keys. Pause/Resume support!

; ============================================
; SHOW GUI
; ============================================
Gui, Show, w820 h640, Automation Tool
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
    SetTimer, RemoveToolTip, 1500
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
        ToolTip, Enter profile name!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    profileName := RegExReplace(profileName, "[^\w\s-]", "")
    profilePath := configFolder "\" profileName ".ini"
    
    if FileExist(profilePath)
    {
        ToolTip, Profile exists!
        SetTimer, RemoveToolTip, 1500
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
        ToolTip, Load a profile first!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    profilePath := configFolder "\" currentProfile ".ini"
    SaveProfileData(profilePath, currentProfile)
    ToolTip, Updated!
    SetTimer, RemoveToolTip, 1500
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
    ToolTip, Saved!
    SetTimer, RemoveToolTip, 1500
    UpdateStatus()
}

LoadProfile:
{
    global configFolder, selectedKey1, selectedKey2, keyDelay1, keyDelay2, clickerDelay, clickerButton, currentProfile, keySeqKeys, keySeqDelays
    
    GuiControlGet, selectedProfile, , ProfileList
    
    if (selectedProfile = "")
    {
        ToolTip, Select profile!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    profilePath := configFolder "\" selectedProfile ".ini"
    
    if !FileExist(profilePath)
    {
        ToolTip, Not found!
        SetTimer, RemoveToolTip, 1500
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
    
    ToolTip, Loaded!
    SetTimer, RemoveToolTip, 1500
    UpdateStatus()
}
return

DeleteProfile:
{
    global configFolder
    
    GuiControlGet, selectedProfile, , ProfileList
    
    if (selectedProfile = "")
    {
        ToolTip, Select profile!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    profilePath := configFolder "\" selectedProfile ".ini"
    FileDelete, %profilePath%
    RefreshProfileList()
    ToolTip, Deleted!
    SetTimer, RemoveToolTip, 1500
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
        GuiControl, , ActiveMacro, [ACTIVE] Key Spam Running
        
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
    GuiControl, , ActiveMacro, [IDLE] No macro running
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
        ToolTip, Key 1 required!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    selectedKey1 := inputValue1
    selectedKey2 := inputValue2
    keyDelay1 := delayValue1
    keyDelay2 := delayValue2
    
    ToolTip, Updated!
    SetTimer, RemoveToolTip, 1500
}
return

KeySpamSlow:
{
    global keyDelay1, keyDelay2
    keyDelay1 := 200
    keyDelay2 := 200
    GuiControl, , KeyDelay1Input, 200
    GuiControl, , KeyDelay2Input, 200
    ToolTip, SLOW preset set!
    SetTimer, RemoveToolTip, 1500
}
return

KeySpamNormal:
{
    global keyDelay1, keyDelay2
    keyDelay1 := 50
    keyDelay2 := 50
    GuiControl, , KeyDelay1Input, 50
    GuiControl, , KeyDelay2Input, 50
    ToolTip, NORMAL preset set!
    SetTimer, RemoveToolTip, 1500
}
return

KeySpamFast:
{
    global keyDelay1, keyDelay2
    keyDelay1 := 10
    keyDelay2 := 10
    GuiControl, , KeyDelay1Input, 10
    GuiControl, , KeyDelay2Input, 10
    ToolTip, FAST preset set!
    SetTimer, RemoveToolTip, 1500
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
        GuiControl, , ActiveMacro, [ACTIVE] Auto Clicker Running
        
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
    GuiControl, , ActiveMacro, [IDLE] No macro running
}
return

UpdateClickerSpeed:
{
    global clickerDelay
    GuiControlGet, delayValue, , ClickerDelayInput
    
    if (delayValue <= 0 || delayValue = "")
    {
        ToolTip, Delay > 0!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    clickerDelay := delayValue
    ToolTip, Speed updated!
    SetTimer, RemoveToolTip, 1500
}
return

ClickerSlow:
{
    global clickerDelay
    clickerDelay := 200
    GuiControl, , ClickerDelayInput, 200
    ToolTip, SLOW preset set!
    SetTimer, RemoveToolTip, 1500
}
return

ClickerNormal:
{
    global clickerDelay
    clickerDelay := 50
    GuiControl, , ClickerDelayInput, 50
    ToolTip, NORMAL preset set!
    SetTimer, RemoveToolTip, 1500
}
return

ClickerFast:
{
    global clickerDelay
    clickerDelay := 10
    GuiControl, , ClickerDelayInput, 10
    ToolTip, FAST preset set!
    SetTimer, RemoveToolTip, 1500
}
return

; ============================================
; KEY SEQUENCE
; ============================================

F9::
{
    global keySequenceRunning, keySequencePaused, keySeqKeys, keySeqDelays, loopCount
    
    if (!keySequenceRunning)
    {
        keySequenceRunning := true
        keySequencePaused := false
        loopCount := 0
        GuiControl, , ActiveMacro, [ACTIVE] Key Sequence Running
        
        Loop
        {
            if (!keySequenceRunning)
                break
            
            if (keySequencePaused)
            {
                Sleep, 100
                continue
            }
            
            loopCount++
            GuiControl, , LoopCounterDisplay, Loops: %loopCount%
            
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
    else if (keySequenceRunning && !keySequencePaused)
    {
        keySequencePaused := true
        GuiControl, , ActiveMacro, [PAUSED] Key Sequence Paused
    }
    else if (keySequenceRunning && keySequencePaused)
    {
        keySequencePaused := false
        GuiControl, , ActiveMacro, [ACTIVE] Key Sequence Running
    }
}
return

F10::
{
    global keySequenceRunning, keySequencePaused, loopCount
    keySequenceRunning := false
    keySequencePaused := false
    loopCount := 0
    GuiControl, , LoopCounterDisplay, Loops: 0
    GuiControl, , ActiveMacro, [IDLE] No macro running
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
        ToolTip, Add at least one key!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    ToolTip, Sequence saved!
    SetTimer, RemoveToolTip, 1500
}
return

; ============================================
; HELPER
; ============================================

UpdateStatus()
{
    global currentProfile
    profileDisplay := currentProfile != "" ? currentProfile : "None"
    ; Status updates handled by individual feature labels
}

GuiClose:
ExitApp
