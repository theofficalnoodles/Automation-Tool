#Requires AutoHotkey v1.1
#SingleInstance Force

; Automation Tool
darkModeEnabled := true
configFile := A_AppData "\AutomationTool\config.ini"
IniRead, darkModeEnabled, %configFile%, Theme, DarkMode, true

; Define colors based on theme
if (darkModeEnabled)
{
    bgColor := "2d2d2d"
    fgColor := "FFFFFF"
    textColor := "cFFFFFF"
    textSecondary := "cAAAAAA"
    statusGreen := "c6FCF6F"
}
else
{
    bgColor := "FFFFFF"
    fgColor := "000000"
    textColor := "c000000"
    textSecondary := "c666666"
    statusGreen := "c008800"
}

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

antiDetectionEnabled := false
jitterAmount := 5
actionCount := 0
clickCount := 0
startTime := 0

comboBuilderActive := false
comboSteps := []
comboRepeatCount := 1
currentComboName := "Default"

scheduledMacros := []
schedulerEnabled := false
scheduledTime1 := "12:00"
scheduledMacro1 := "Key Spam"
scheduledRepeat1 := 1

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

Gui, Color, %bgColor%
Gui, Font, %textColor% s10, Segoe UI
Gui, Add, Text, x10 y10 w800 h22, Automation Tool
Gui, Font, %textColor% s9, Segoe UI
Gui, Add, Text, x10 y32 w800 h15 c999999, Key spam, auto clicker, sequences, and combos
Gui, Add, Text, x10 y50 w400 h15 %statusGreen% vActiveMacro, Idle

Gui, Add, GroupBox, x10 y68 w800 h75 %textColor%, Profiles

Gui, Add, Text, x20 y86 w100 %textColor%, Saved:
Gui, Add, DropDownList, x120 y82 w220 h30 vProfileList
RefreshProfileList()

Gui, Add, Button, x355 y82 w60 h28 gLoadProfile, Load
Gui, Add, Button, x425 y82 w60 h28 gDeleteProfile, Delete
Gui, Add, Button, x495 y82 w60 h28 gRefreshProfiles, Refresh

Gui, Add, Text, x20 y118 w100 %textColor%, New name:
Gui, Add, Edit, x120 y114 w220 h25 c000000 vNewProfileName,
Gui, Add, Button, x355 y114 w90 h25 gCreateProfile, Save as new
Gui, Add, Button, x455 y114 w100 h25 gUpdateProfile, Update current

Gui, Add, Tab3, x10 y152 w800 h470 vMainTab, Key Spam|Auto Clicker|Seq (1-5)|Seq (6-10)|Combo Builder|Scheduler|Advanced|Settings|Preferences

Gui, Add, GroupBox, x20 y182 w780 h140 %textColor%, Key spam

Gui, Add, Text, x30 y202 w150 %textColor%, Key 1:
Gui, Add, Edit, x190 y197 w100 h25 c000000 vKeyInput1, z

Gui, Add, Text, x30 y237 w150 %textColor%, Key 2 (optional):
Gui, Add, Edit, x190 y232 w100 h25 c000000 vKeyInput2,

Gui, Add, Text, x320 y202 w150 %textColor%, Delay 1 (ms):
Gui, Add, Edit, x480 y197 w80 h25 c000000 vKeyDelay1Input, 50

Gui, Add, Text, x320 y237 w150 %textColor%, Delay 2 (ms):
Gui, Add, Edit, x480 y232 w80 h25 c000000 vKeyDelay2Input, 50

Gui, Add, Button, x30 y267 w120 h28 gSetKeysAndDelays, Apply
Gui, Add, Text, x170 y272 w280 h20 %statusGreen% vKeySpamStatus, Stopped

Gui, Add, GroupBox, x20 y332 w780 h95 %textColor%, Presets

Gui, Add, Button, x30 y352 w100 h28 gKeySpamSlow, Slow (200ms)
Gui, Add, Button, x145 y352 w100 h28 gKeySpamNormal, Normal (50ms)
Gui, Add, Button, x260 y352 w100 h28 gKeySpamFast, Fast (10ms)

Gui, Add, Text, x30 y392 w420 %textSecondary%, F7 to start, F8 to stop

Gui, Tab, 2

Gui, Add, GroupBox, x20 y157 w370 h230 %textColor%, Simple

Gui, Add, Text, x30 y177 w100 %textColor%, Button:
Gui, Add, DropDownList, x130 y172 w150 h30 vClickButtonDropdown, Left|Right|Middle
GuiControl, ChooseString, ClickButtonDropdown, Left

Gui, Add, Text, x30 y222 w100 %textColor%, Speed:
Gui, Add, DropDownList, x130 y217 w150 h30 vClickerSpeedDropdown, Slow (2 CPS)|Normal (5 CPS)|Fast (10 CPS)|Ultra (20 CPS)
GuiControl, ChooseString, ClickerSpeedDropdown, Normal (5 CPS)

Gui, Add, Text, x30 y262 w320 %textSecondary%, F5 to start, F6 to stop

Gui, Add, Button, x30 y290 w150 h36 gStartClickerSimple, Start (F5)
Gui, Add, Button, x200 y290 w150 h36 gStopClickerSimple, Stop (F6)

Gui, Add, Text, x30 y335 w320 %statusGreen% vAutoClickerStatus, Stopped

Gui, Add, GroupBox, x420 y157 w380 h230 %textColor%, Advanced

Gui, Add, Text, x430 y177 w100 %textColor%, CPS:
Gui, Add, Edit, x530 y172 w80 h25 c000000 vClickerCPSInput, 5
Gui, Add, Text, x625 y177 w100 %textSecondary%, clicks/sec

Gui, Add, Text, x430 y217 w100 %textColor%, Hold (ms):
Gui, Add, Edit, x530 y212 w80 h25 c000000 vClickerHoldInput, 10

Gui, Add, Text, x430 y257 w100 %textColor%, Variation (ms):
Gui, Add, Edit, x530 y252 w80 h25 c000000 vClickerVariationInput, 1

Gui, Add, Button, x430 y295 w340 h28 gApplyAdvancedClicker, Apply settings
Gui, Add, Text, x430 y335 w340 %statusGreen% vAutoClickerStats, CPS: --

Gui, Add, GroupBox, x20 y400 w780 h55 %textColor%, Presets

Gui, Add, Button, x30 y415 w140 h28 gClickerSlow, Slow (2 CPS)
Gui, Add, Button, x185 y415 w140 h28 gClickerNormal, Normal (5 CPS)
Gui, Add, Button, x340 y415 w140 h28 gClickerFast, Fast (10 CPS)
Gui, Add, Button, x495 y415 w140 h28 gClickerSuper, Ultra (20 CPS)

Gui, Tab, 3

Gui, Add, GroupBox, x20 y182 w780 h270 %textColor%, Steps 1-5

Gui, Add, Text, x30 y202 w100 %textColor%, Step
Gui, Add, Text, x140 y202 w150 %textColor%, Key
Gui, Add, Text, x300 y202 w150 %textColor%, Delay (ms)

Loop, 5
{
    row := A_Index
    yPos := 232 + (row - 1) * 40
    
    Gui, Add, Text, x30 y%yPos% w100 %textColor%, Step %row%:
    Gui, Add, Edit, x140 y%yPos% w150 h25 c000000 vKeySeq%row%,
    Gui, Add, Edit, x300 y%yPos% w80 h25 c000000 vDelaySeq%row%, 50
}

Gui, Add, Button, x30 y517 w120 h28 gSetKeySequence, Save sequence
Gui, Add, Text, x170 y522 w300 h20 %textSecondary%, F9 start/pause, F10 stop

Gui, Tab, 4

Gui, Add, GroupBox, x20 y182 w780 h270 %textColor%, Steps 6-10

Gui, Add, Text, x30 y202 w100 %textColor%, Step
Gui, Add, Text, x140 y202 w150 %textColor%, Key
Gui, Add, Text, x300 y202 w150 %textColor%, Delay (ms)

Loop, 5
{
    row := A_Index + 5
    yPos := 232 + (A_Index - 1) * 40
    
    Gui, Add, Text, x30 y%yPos% w100 %textColor%, Step %row%:
    Gui, Add, Edit, x140 y%yPos% w150 h25 c000000 vKeySeq%row%,
    Gui, Add, Edit, x300 y%yPos% w80 h25 c000000 vDelaySeq%row%, 50
}

Gui, Add, Button, x30 y517 w120 h28 gSetKeySequence, Save sequence
Gui, Add, Text, x170 y522 w300 h20 %textSecondary% vLoopCounterDisplay, Loops: 0

Gui, Tab, 5

Gui, Add, GroupBox, x20 y157 w780 h130 %textColor%, Combo

Gui, Add, Text, x30 y177 w100 %textColor%, Name:
Gui, Add, Edit, x130 y172 w250 h25 c000000 vComboNameInput, My Combo

Gui, Add, Text, x30 y212 w100 %textColor%, Action:
Gui, Add, Edit, x130 y207 w150 h25 c000000 vComboActionInput, a
Gui, Add, Text, x300 y212 w60 %textColor%, Repeat:
Gui, Add, Edit, x370 y207 w60 h25 c000000 vComboRepeatInput, 1

Gui, Add, Button, x30 y245 w100 h28 gAddComboAction, Add
Gui, Add, Button, x145 y245 w100 h28 gSaveCombo, Save
Gui, Add, Button, x260 y245 w100 h28 gLoadCombo, Load
Gui, Add, Button, x375 y245 w100 h28 gStartCombo, Run (F11)
Gui, Add, Button, x490 y245 w100 h28 gClearComboActions, Clear

Gui, Add, GroupBox, x20 y300 w780 h160 %textColor%, Actions

Gui, Add, ListBox, x30 y320 w740 h105 vComboActionsList, No actions yet.
Gui, Add, Text, x30 y435 w740 %statusGreen% vComboStatus, Ready

Gui, Tab, 6

Gui, Add, GroupBox, x20 y157 w780 h200 %textColor%, Schedule

Gui, Add, Text, x30 y182 w80 %textColor%, Time 1:
Gui, Add, Edit, x120 y177 w70 h25 c000000 vScheduleTime1Input, 12:00
Gui, Add, Text, x210 y182 w60 %textColor%, Action:
Gui, Add, DropDownList, x280 y177 w130 h30 vScheduleMacro1Dropdown, Key Spam|Auto Clicker|Key Sequence|Combo
Gui, Add, Text, x430 y182 w60 %textColor%, Repeat:
Gui, Add, Edit, x500 y177 w70 h25 c000000 vScheduleRepeat1Input, 1

Gui, Add, Text, x30 y222 w80 %textColor%, Time 2:
Gui, Add, Edit, x120 y217 w70 h25 c000000 vScheduleTime2Input, 18:00
Gui, Add, Text, x210 y222 w60 %textColor%, Action:
Gui, Add, DropDownList, x280 y217 w130 h30 vScheduleMacro2Dropdown, Key Spam|Auto Clicker|Key Sequence|Combo
Gui, Add, Text, x430 y222 w60 %textColor%, Repeat:
Gui, Add, Edit, x500 y217 w70 h25 c000000 vScheduleRepeat2Input, 1

Gui, Add, GroupBox, x20 y370 w780 h95 %textColor%, Controls

Gui, Add, Checkbox, x30 y390 w200 vSchedulerEnabledCheck, Enable scheduler
Gui, Add, Text, x30 y415 w500 %textSecondary%, Time format: HH:MM (24-hour)

Gui, Add, Button, x30 y440 w90 h28 gApplyScheduler, Apply
Gui, Add, Button, x135 y440 w90 h28 gStartScheduler, Start
Gui, Add, Button, x240 y440 w90 h28 gStopScheduler, Stop
Gui, Add, Button, x345 y440 w90 h28 gViewSchedulerLog, View log
Gui, Add, Text, x450 y445 w300 %statusGreen% vSchedulerStatus, Disabled

Gui, Tab, 7

Gui, Add, GroupBox, x20 y157 w780 h120 %textColor%, Variable timing

Gui, Add, Checkbox, x30 y182 w300 vAntiDetectionCheck, Add random delay variation
Gui, Add, Text, x30 y212 w100 %textColor%, Jitter (ms):
Gui, Add, Edit, x130 y207 w60 h25 c000000 vJitterInput, 5
Gui, Add, Button, x200 y207 w100 h28 gApplyAdvanced, Apply

Gui, Add, GroupBox, x20 y290 w780 h100 %textColor%, Performance

Gui, Add, Text, x30 y315 w500 %statusGreen% vPerfStats, CPS: 0 | Actions: 0 | Time: 0s
Gui, Add, Button, x30 y345 w100 h28 gResetStats, Reset stats

Gui, Tab, 8

Gui, Add, GroupBox, x20 y157 w780 h130 %textColor%, Hotkeys

Gui, Add, Text, x30 y182 w400, Key spam: F7 start, F8 stop
Gui, Add, Text, x30 y207 w400, Auto clicker: F5 start, F6 stop
Gui, Add, Text, x30 y232 w400, Key sequence: F9 start/pause, F10 stop
Gui, Add, Text, x30 y257 w400, Combo: F11 run

Gui, Add, GroupBox, x20 y300 w780 h100 %textColor%, Logs

Gui, Add, Button, x30 y325 w140 h28 gViewKeyHistory, Keystroke history
Gui, Add, Button, x185 y325 w100 h28 gClearLogs, Clear logs
Gui, Add, Button, x300 y325 w100 h28 gAboutTool, About

Gui, Tab, 9

Gui, Add, GroupBox, x20 y157 w780 h130 %textColor%, Appearance

Gui, Add, Checkbox, x30 y182 w200 vDarkModeCheck, Dark mode
if (darkModeEnabled)
    GuiControl,, DarkModeCheck, 1
Gui, Add, Text, x30 y210 w500 %textSecondary%, Restart the tool after changing theme.
Gui, Add, Button, x30 y235 w120 h28 gApplyTheme, Apply

Gui, Show, w820 h635, Automation Tool
return

; Profiles

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
    GuiControlGet, cpsValue, , ClickerCPSInput
    GuiControlGet, buttonValue, , ClickButtonDropdown
    
    selectedKey1 := inputValue1
    selectedKey2 := inputValue2
    keyDelay1 := delayValue1
    keyDelay2 := delayValue2
    clickerButton := buttonValue
    
    IniWrite, %inputValue1%, %profilePath%, KeySpam, Key1
    IniWrite, %inputValue2%, %profilePath%, KeySpam, Key2
    IniWrite, %delayValue1%, %profilePath%, KeySpam, Delay1
    IniWrite, %delayValue2%, %profilePath%, KeySpam, Delay2
    
    IniWrite, %cpsValue%, %profilePath%, Clicker, CPS
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
    
    IniRead, clickCPS, %profilePath%, Clicker, CPS,
    IniRead, clickDelay, %profilePath%, Clicker, Delay, 50
    IniRead, button, %profilePath%, Clicker, Button, Left
    
    if (clickCPS = "")
        clickCPS := (clickDelay > 0) ? Round(1000 / clickDelay) : 5
    
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
    GuiControl, , ClickerCPSInput, %clickCPS%
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

; Key spam

F7::
{
    global keySpamRunning, selectedKey1, selectedKey2, keyDelay1, keyDelay2, actionCount, startTime, antiDetectionEnabled, jitterAmount
    if (!keySpamRunning)
    {
        keySpamRunning := true
        GuiControl, , KeySpamStatus, Running
        GuiControl, , ActiveMacro, Running: key spam
        startTime := A_TickCount
        
        ; Cache values for faster access
        key1 := selectedKey1
        key2 := selectedKey2
        dly1 := keyDelay1
        dly2 := keyDelay2
        antiDet := antiDetectionEnabled
        jitter := jitterAmount
        hasKey2 := (key2 != "")
        statsCounter := 0
        
        Loop
        {
            if (!keySpamRunning)
                break
            Send, %key1%
            actionCount++
            statsCounter++
            
            if (antiDet)
            {
                Random, variation, -%jitter%, %jitter%
                delay1 := dly1 + variation
                if (delay1 <= 0)
                    delay1 := dly1
            }
            else
                delay1 := dly1
            
            Sleep, %delay1%
            
            if (hasKey2)
            {
                Send, %key2%
                actionCount++
                statsCounter++
                
                if (antiDet)
                {
                    Random, variation, -%jitter%, %jitter%
                    delay2 := dly2 + variation
                    if (delay2 <= 0)
                        delay2 := dly2
                }
                else
                    delay2 := dly2
                
                Sleep, %delay2%
            }
            
            ; Only update stats every 5 actions (less GUI overhead)
            if (statsCounter >= 5)
            {
                UpdateStats()
                statsCounter := 0
            }
        }
        
        ; Final stats update
        UpdateStats()
    }
}
return

F8::
{
    global keySpamRunning
    keySpamRunning := false
    GuiControl, , KeySpamStatus, Stopped
    GuiControl, , ActiveMacro, Idle
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
    ToolTip, Slow preset
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
    ToolTip, Normal preset
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
    ToolTip, Fast preset
    SetTimer, RemoveToolTip, 1500
}
return

; Auto clicker

F5::
{
    global autoClickerRunning, clickerButton, clickerDelay, clickerCPS, clickerHold, clickerVariation, actionCount, clickCount, startTime
    if (!autoClickerRunning)
    {
        autoClickerRunning := true
        GuiControl, , AutoClickerStatus, Running
        GuiControl, , ActiveMacro, Running: auto clicker
        startTime := A_TickCount
        
        ; Get current settings
        GuiControlGet, cps, , ClickerCPSInput
        GuiControlGet, hold, , ClickerHoldInput
        GuiControlGet, variation, , ClickerVariationInput
        GuiControlGet, btnClick, , ClickButtonDropdown
        
        ; Convert CPS to delay (1000ms / CPS = delay between clicks)
        if (cps <= 0)
            cps := 1
        baseDelay := 1000 / cps
        
        clickCount := 0
        statsCounter := 0
        
        Loop
        {
            if (!autoClickerRunning)
                break
            
            ; Click with hold duration
            Click, %btnClick%
            
            if (hold > 0)
                Sleep, %hold%
            
            clickCount++
            actionCount++
            statsCounter++
            
            ; Calculate delay with variation
            if (variation > 0)
            {
                Random, var, -%variation%, %variation%
                dly := baseDelay + var
                if (dly <= 0)
                    dly := baseDelay
            }
            else
                dly := baseDelay
            
            ; Only update stats every 5 clicks
            if (statsCounter >= 5)
            {
                cpsActual := (clickCount * 1000) / (A_TickCount - startTime)
                GuiControl, , AutoClickerStats, CPS: %cpsActual% (Target: %cps%)
                statsCounter := 0
            }
            
            Sleep, %dly%
        }
        
        ; Final stats
        elapsed := (A_TickCount - startTime) / 1000
        cpsActual := clickCount / elapsed
        GuiControl, , AutoClickerStats, CPS: %cpsActual% (Total: %clickCount% clicks)
    }
}
return

F6::
{
    global autoClickerRunning
    autoClickerRunning := false
    GuiControl, , AutoClickerStatus, Stopped
    GuiControl, , ActiveMacro, Idle
}
return

ClickerSuper:
{
    GuiControl, , ClickerSpeedDropdown, Ultra (20 CPS)
    GuiControl, , ClickerCPSInput, 20
    GuiControl, , ClickerHoldInput, 5
    GuiControl, , ClickerVariationInput, 2
    ToolTip, 20 CPS
    SetTimer, RemoveToolTip, 1500
}
return

ClickerFast:
{
    GuiControl, , ClickerSpeedDropdown, Fast (10 CPS)
    GuiControl, , ClickerCPSInput, 10
    GuiControl, , ClickerHoldInput, 10
    GuiControl, , ClickerVariationInput, 1
    ToolTip, 10 CPS
    SetTimer, RemoveToolTip, 1500
}
return

ClickerNormal:
{
    GuiControl, , ClickerSpeedDropdown, Normal (5 CPS)
    GuiControl, , ClickerCPSInput, 5
    GuiControl, , ClickerHoldInput, 15
    GuiControl, , ClickerVariationInput, 0
    ToolTip, 5 CPS
    SetTimer, RemoveToolTip, 1500
}
return

ClickerSlow:
{
    GuiControl, , ClickerSpeedDropdown, Slow (2 CPS)
    GuiControl, , ClickerCPSInput, 2
    GuiControl, , ClickerHoldInput, 20
    GuiControl, , ClickerVariationInput, 0
    ToolTip, 2 CPS
    SetTimer, RemoveToolTip, 1500
}
return

StartClickerSimple:
{
    GuiControlGet, speed, , ClickerSpeedDropdown
    
    ; Parse speed from dropdown
    if (InStr(speed, "2 CPS"))
        cps := 2
    else if (InStr(speed, "5 CPS"))
        cps := 5
    else if (InStr(speed, "10 CPS"))
        cps := 10
    else if (InStr(speed, "20 CPS"))
        cps := 20
    else
        cps := 5
    
    ; Update advanced inputs
    GuiControl, , ClickerCPSInput, %cps%
    GuiControl, , ClickerHoldInput, 15
    GuiControl, , ClickerVariationInput, 1
    
    ; Start clicking
    Send, {F5}
}
return

StopClickerSimple:
{
    Send, {F6}
}
return

ApplyAdvancedClicker:
GuiControlGet, cps, , ClickerCPSInput
GuiControlGet, hold, , ClickerHoldInput
GuiControlGet, variation, , ClickerVariationInput
if (cps <= 0)
{
    ToolTip, CPS must be greater than 0!
    SetTimer, RemoveToolTip, 1500
    return
}
ToolTip, Settings applied
SetTimer, RemoveToolTip, 2000
return

ApplyTheme:
GuiControlGet, darkMode, , DarkModeCheck
configFile := A_AppData "\AutomationTool\config.ini"
configFolder := A_AppData "\AutomationTool"
if (!FileExist(configFolder))
    FileCreateDir, %configFolder%
IniWrite, %darkMode%, %configFile%, Theme, DarkMode
if (darkMode)
{
    ToolTip, Dark Mode will be active on restart!
}
else
{
    ToolTip, Light Mode will be active on restart!
}
SetTimer, RemoveToolTip, 2000
return

; Key sequence

F9::
{
    global keySequenceRunning, keySequencePaused, keySeqKeys, keySeqDelays, loopCount, antiDetectionEnabled, jitterAmount, actionCount
    
    if (!keySequenceRunning)
    {
        keySequenceRunning := true
        keySequencePaused := false
        loopCount := 0
        GuiControl, , ActiveMacro, Running: key sequence
        
        ; Cache values for faster access
        antiDet := antiDetectionEnabled
        jitter := jitterAmount
        guiUpdateCounter := 0
        
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
            guiUpdateCounter++
            
            ; Only update GUI every 10 loops (massive performance gain)
            if (guiUpdateCounter >= 10)
            {
                GuiControl, , LoopCounterDisplay, Loops: %loopCount%
                guiUpdateCounter := 0
            }
            
            Loop, 10
            {
                if (!keySequenceRunning)
                    break
                
                key := keySeqKeys[A_Index]
                delay := keySeqDelays[A_Index]
                
                if (key != "")
                {
                    Send, %key%
                    actionCount++
                    
                    if (antiDet)
                    {
                        Random, variation, -%jitter%, %jitter%
                        finalDelay := delay + variation
                        if (finalDelay <= 0)
                            finalDelay := delay
                    }
                    else
                        finalDelay := delay
                    
                    Sleep, %finalDelay%
                }
            }
        }
        
        ; Final GUI update
        GuiControl, , LoopCounterDisplay, Loops: %loopCount%
    }
    else if (keySequenceRunning && !keySequencePaused)
    {
        keySequencePaused := true
        GuiControl, , ActiveMacro, Paused: key sequence
    }
    else if (keySequenceRunning && keySequencePaused)
    {
        keySequencePaused := false
        GuiControl, , ActiveMacro, Running: key sequence
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
    GuiControl, , ActiveMacro, Idle
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

; Helpers

UpdateStatus()
{
    global currentProfile
    if (currentProfile != "")
        profileDisplay := currentProfile
    else
        profileDisplay := "None"
    ; Status updates handled by individual feature labels
}

ApplyAdvanced:
{
    global antiDetectionEnabled, jitterAmount
    GuiControlGet, antiDetectionEnabled, , AntiDetectionCheck
    GuiControlGet, jitterAmount, , JitterInput
    ToolTip, Settings updated
    SetTimer, RemoveToolTip, 1500
}
return

ResetStats:
{
    global actionCount, clickCount, startTime
    actionCount := 0
    clickCount := 0
    startTime := 0
    GuiControl, , PerfStats, CPS: 0 | Actions: 0 | Time: 0s
    ToolTip, Stats reset
    SetTimer, RemoveToolTip, 1500
}
return

ApplyJitter(baseDelay)
{
    global antiDetectionEnabled, jitterAmount
    if (!antiDetectionEnabled)
        return baseDelay
    
    Random, variation, -%jitterAmount%, %jitterAmount%
    newDelay := baseDelay + variation
    if (newDelay > 0)
        return newDelay
    else
        return baseDelay
}

UpdateStats()
{
    global actionCount, clickCount, startTime
    if (startTime = 0)
        startTime := A_TickCount
    
    ; Optimize by only recalculating every 500ms to reduce overhead
    static lastUpdate := 0
    currentTime := A_TickCount
    if ((currentTime - lastUpdate) < 500)
        return
    lastUpdate := currentTime
    
    elapsedSeconds := Round((currentTime - startTime) / 1000)
    if (elapsedSeconds > 0)
        cps := Round(clickCount / elapsedSeconds, 1)
    else
        cps := 0
    
    statText := "CPS: " cps " | Actions: " actionCount " | Time: " elapsedSeconds "s"
    GuiControl, , PerfStats, %statText%
}


ViewKeyHistory:
{
    logFile := A_AppData "\AutomationTool\macro_history.log"
    if FileExist(logFile)
    {
        Run, notepad.exe %logFile%
        ToolTip, Opening keystroke history...
    }
    else
    {
        ToolTip, No history yet.
    }
    SetTimer, RemoveToolTip, 2500
}
return

AboutTool:
{
    MsgBox, 64, About, Automation Tool`n`nKey spam, auto clicker, key sequences, combos, and scheduling.
}
return

ClearLogs:
{
    logFile := A_AppData "\AutomationTool\macro_history.log"
    if FileExist(logFile)
    {
        FileDelete, %logFile%
        ToolTip, Logs cleared
    }
    else
    {
        ToolTip, No logs to clear
    }
    SetTimer, RemoveToolTip, 1500
}
return

; Combo builder

AddComboAction:
{
    global comboSteps
    GuiControlGet, actionValue, , ComboActionInput
    GuiControlGet, repeatValue, , ComboRepeatInput
    
    if (actionValue = "")
    {
        ToolTip, Enter an action!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    action := {key: actionValue, repeat: repeatValue}
    comboSteps.Push(action)
    
    listText := ""
    Loop, % comboSteps.Length()
    {
        if (listText != "")
            listText .= "|"
        listText .= A_Index ". " comboSteps[A_Index].key " x" comboSteps[A_Index].repeat
    }
    
    GuiControl, , ComboActionsList, %listText%
    ToolTip, Action added!
    SetTimer, RemoveToolTip, 1500
}
return

SaveCombo:
{
    global comboSteps, currentComboName
    GuiControlGet, comboName, , ComboNameInput
    
    if (comboSteps.Length() = 0)
    {
        ToolTip, Add actions first!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    currentComboName := comboName
    comboFile := A_AppData "\AutomationTool\Combos\" comboName ".combo"
    
    if !FileExist(A_AppData "\AutomationTool\Combos")
        FileCreateDir, %A_AppData%\AutomationTool\Combos
    
    ; Save combo to file
    FileDelete, %comboFile%
    Loop, % comboSteps.Length()
        FileAppend, % comboSteps[A_Index].key "|" comboSteps[A_Index].repeat "`n", %comboFile%
    
    ToolTip, Combo "%comboName%" saved!
    SetTimer, RemoveToolTip, 1500
}
return

LoadCombo:
{
    global comboSteps
    GuiControlGet, comboName, , ComboNameInput
    
    comboFile := A_AppData "\AutomationTool\Combos\" comboName ".combo"
    
    if !FileExist(comboFile)
    {
        ToolTip, Combo not found!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    comboSteps := []
    Loop, Read, %comboFile%
    {
        parts := StrSplit(A_LoopReadLine, "|")
        if (parts.Length() >= 2)
            comboSteps.Push({key: parts[1], repeat: parts[2]})
    }
    
    listText := ""
    Loop, % comboSteps.Length()
    {
        if (listText != "")
            listText .= "|"
        listText .= A_Index ". " comboSteps[A_Index].key " x" comboSteps[A_Index].repeat
    }
    
    GuiControl, , ComboActionsList, %listText%
    ToolTip, Combo "%comboName%" loaded!
    SetTimer, RemoveToolTip, 1500
}
return

StartCombo:
{
    global comboSteps
    
    if (comboSteps.Length() = 0)
    {
        ToolTip, No combo loaded!
        SetTimer, RemoveToolTip, 1500
        return
    }
    
    ToolTip, Running combo...
    SetTimer, RemoveToolTip, 2000
    
    Loop, % comboSteps.Length()
    {
        key := comboSteps[A_Index].key
        repeat := comboSteps[A_Index].repeat
        
        Loop, %repeat%
            Send, %key%
        
        Sleep, 50
    }
    
    ToolTip, Combo complete!
    SetTimer, RemoveToolTip, 1500
}
return

ClearComboActions:
{
    global comboSteps
    comboSteps := []
    GuiControl, , ComboActionsList, No actions yet.
    ToolTip, All actions cleared!
    SetTimer, RemoveToolTip, 1500
}
return

; Scheduler

ApplyScheduler:
{
    global scheduledTime1, scheduledMacro1, scheduledRepeat1
    GuiControlGet, time1, , ScheduleTime1Input
    GuiControlGet, macro1, , ScheduleMacro1Dropdown
    GuiControlGet, repeat1, , ScheduleRepeat1Input
    
    scheduledTime1 := time1
    scheduledMacro1 := macro1
    scheduledRepeat1 := repeat1
    
    ToolTip, Schedule applied!
    SetTimer, RemoveToolTip, 1500
}
return

StartScheduler:
{
    global schedulerEnabled, scheduledTime1, scheduledMacro1
    schedulerEnabled := true
    GuiControl, , SchedulerStatus, Enabled
    
    ToolTip, Scheduler started!
    SetTimer, RemoveToolTip, 1500
    
    ; Start timer to check scheduled times
    SetTimer, CheckScheduledTimes, 60000
}
return

StopScheduler:
{
    global schedulerEnabled
    schedulerEnabled := false
    GuiControl, , SchedulerStatus, Disabled
    SetTimer, CheckScheduledTimes, Off
    
    ToolTip, Scheduler stopped!
    SetTimer, RemoveToolTip, 1500
}
return

CheckScheduledTimes:
{
    global schedulerEnabled, scheduledTime1, scheduledMacro1, scheduledRepeat1
    
    if (!schedulerEnabled)
        return
    
    ; Get current time
    FormatTime, currentTime, , HH:mm
    
    ; Check if scheduled time matches
    if (currentTime = scheduledTime1)
    {
        ; Run the scheduled macro
        if (scheduledMacro1 = "Key Spam")
            Send, {F7}
        else if (scheduledMacro1 = "Auto Clicker")
            Send, {F5}
        else if (scheduledMacro1 = "Key Sequence")
            Send, {F9}
        
        ToolTip, Running scheduled macro: %scheduledMacro1%
        SetTimer, RemoveToolTip, 2000
    }
}
return

ViewSchedulerLog:
{
    logFile := A_AppData "\AutomationTool\scheduler_log.txt"
    if FileExist(logFile)
        Run, notepad.exe %logFile%
    else
    {
        ToolTip, No scheduler log yet!
        SetTimer, RemoveToolTip, 1500
    }
}
return

GuiClose:
ExitApp
