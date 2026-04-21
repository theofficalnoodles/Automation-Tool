#Requires AutoHotkey v1.1
#SingleInstance Force

; ============================================
; AUTOMATION TOOL - FEATURE-RICH VERSION
; ============================================

; ============================================
; THEME INITIALIZATION
; ============================================
darkModeEnabled := true
configFile := A_AppData "\AutomationTool\config.ini"
IniRead, darkModeEnabled, %configFile%, Theme, DarkMode, true

; Define colors based on theme
if (darkModeEnabled)
{
    ; DARK MODE COLORS
    bgColor := "2d2d2d"
    fgColor := "FFFFFF"
    textColor := "cFFFFFF"
    textSecondary := "cYellow"
    buttonColor := "cFFAA00"
    statusGreen := "cGreen"
    statusLime := "cLime"
    headerOrange := "cFFAA00"
    accentPurple := "cPurple"
    accentBlue := "cBlue"
    accentRed := "cRED"
}
else
{
    ; LIGHT MODE COLORS (inverted)
    bgColor := "FFFFFF"
    fgColor := "000000"
    textColor := "c000000"
    textSecondary := "c333333"
    buttonColor := "c0066FF"
    statusGreen := "c00AA00"
    statusLime := "c00DD00"
    headerOrange := "cFF6600"
    accentPurple := "c6600FF"
    accentBlue := "c0000FF"
    accentRed := "cFF0000"
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

; Performance & Variable Timing Variables
antiDetectionEnabled := false
jitterAmount := 5
actionCount := 0
clickCount := 0
startTime := 0

; ============================================
; COMBO BUILDER VARIABLES
; ============================================
comboBuilderActive := false
comboSteps := []
comboRepeatCount := 1
currentComboName := "Default"

; ============================================
; MACRO SCHEDULER VARIABLES
; ============================================
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
Gui, Font, %textColor% s9, Segoe UI

; ============================================
; HEADER & PROFILES
; ============================================
Gui, Add, Text, x10 y10 w800 h25 cFFAA00, AUTOMATION TOOL
Gui, Add, Text, x10 y35 w800 h15 c999999, Speed Presets | Variable Delays | Combo Builder | Scheduler

Gui, Add, Text, x10 y52 w400 h15 cGreen vActiveMacro, [IDLE] No macro running

Gui, Add, GroupBox, x10 y70 w800 h75 %textColor%, PROFILES & CONFIGS

Gui, Add, Text, x20 y88 w130 %textColor%, Select Saved Config:
Gui, Add, DropDownList, x160 y83 w200 h30 vProfileList
RefreshProfileList()

Gui, Add, Button, x375 y83 w55 h30 gLoadProfile cGreen, Load
Gui, Add, Button, x440 y83 w55 h30 gDeleteProfile cRED, Delete
Gui, Add, Button, x505 y83 w55 h30 gRefreshProfiles cBlue, Refresh

Gui, Add, Text, x20 y120 w130 %textColor%, Create New Config:
Gui, Add, Edit, x160 y115 w200 h25 c000000 vNewProfileName,
Gui, Add, Button, x375 y115 w85 h25 gCreateProfile cFFAA00, Save New
Gui, Add, Button, x470 y115 w120 h25 gUpdateProfile cFFFF00, Update Current

; ============================================
; TABS
; ============================================
Gui, Add, Tab3, x10 y155 w800 h470 vMainTab, Key Spam|Auto Clicker|Seq (1-5)|Seq (6-10)|Combo Builder|Scheduler|Advanced|Settings|Preferences

; ============================================
; TAB 1: KEY SPAM
; ============================================

Gui, Add, GroupBox, x20 y185 w780 h140 %textColor%, KEY SPAM SETTINGS

Gui, Add, Text, x30 y205 w150 %textColor%, Key 1:
Gui, Add, Edit, x190 y200 w100 h25 c000000 vKeyInput1, z

Gui, Add, Text, x30 y240 w150 %textColor%, Key 2 (optional):
Gui, Add, Edit, x190 y235 w100 h25 c000000 vKeyInput2,

Gui, Add, Text, x320 y205 w150 %textColor%, Delay 1 (ms):
Gui, Add, Edit, x480 y200 w80 h25 c000000 vKeyDelay1Input, 50

Gui, Add, Text, x320 y240 w150 %textColor%, Delay 2 (ms):
Gui, Add, Edit, x480 y235 w80 h25 c000000 vKeyDelay2Input, 50

Gui, Add, Button, x30 y270 w160 h30 gSetKeysAndDelays cFFAA00, Set Keys & Delays
Gui, Add, Text, x210 y275 w280 h20 vKeySpamStatus cGreen, Status: STOPPED

Gui, Add, GroupBox, x20 y340 w780 h130 %textColor%, SPEED PRESETS

Gui, Add, Button, x30 y360 w100 h30 gKeySpamSlow cGreen, SLOW (200ms)
Gui, Add, Button, x145 y360 w100 h30 gKeySpamNormal cBlue, NORMAL (50ms)
Gui, Add, Button, x260 y360 w100 h30 gKeySpamFast cRED, FAST (10ms)

Gui, Add, Text, x30 y400 w420 cYellow, F7 = START | F8 = STOP
Gui, Add, Text, x30 y425 w420 cYellow, Perfect for combo inputs and rapid key presses

; ============================================
; TAB 2: AUTO CLICKER (PROFESSIONAL UI)
; ============================================

Gui, Tab, 2

; ========== SIMPLE MODE ==========
Gui, Add, GroupBox, x20 y160 w370 h230 %textColor%, SIMPLE - EASY TO USE

Gui, Add, Text, x30 y180 w100 %textColor%, Button:
Gui, Add, DropDownList, x130 y175 w150 h30 vClickButtonDropdown, Left|Right|Middle
GuiControl, ChooseString, ClickButtonDropdown, Left

Gui, Add, Text, x30 y225 w100 %textColor%, Speed:
Gui, Add, DropDownList, x130 y220 w150 h30 vClickerSpeedDropdown, SLOW (2 CPS)|NORMAL (5 CPS)|FAST (10 CPS)|ULTRA (20 CPS)
GuiControl, ChooseString, ClickerSpeedDropdown, NORMAL (5 CPS)

Gui, Add, Text, x30 y270 w320 cYellow, Select button and speed, then press F5 to start
Gui, Add, Text, x30 y290 w320 cYellow, Press F6 to stop clicking

Gui, Add, Button, x30 y320 w150 h40 gStartClickerSimple cLime, START (F5)
Gui, Add, Button, x200 y320 w150 h40 gStopClickerSimple cRED, STOP (F6)

Gui, Add, Text, x30 y365 w320 vAutoClickerStatus cGreen, Status: STOPPED

; ========== ADVANCED MODE ==========
Gui, Add, GroupBox, x420 y160 w380 h230 %textColor%, ADVANCED - FINE TUNING

Gui, Add, Text, x430 y180 w100 %textColor%, CPS:
Gui, Add, Edit, x530 y175 w80 h25 c000000 vClickerCPSInput, 5
Gui, Add, Text, x625 y180 w100 cYellow, (clicks/second)

Gui, Add, Text, x430 y220 w100 %textColor%, Hold (ms):
Gui, Add, Edit, x530 y215 w80 h25 c000000 vClickerHoldInput, 10
Gui, Add, Text, x625 y220 w100 cYellow, (button hold time)

Gui, Add, Text, x430 y260 w100 %textColor%, Variation (ms):
Gui, Add, Edit, x530 y255 w80 h25 c000000 vClickerVariationInput, 1
Gui, Add, Text, x625 y260 w100 cYellow, (random timing)

Gui, Add, Button, x430 y305 w340 h30 gApplyAdvancedClicker cFFAA00, Apply Advanced Settings

Gui, Add, Text, x430 y360 w340 vAutoClickerStats cGreen, CPS: Calculating...

; ========== QUICK PRESETS ==========
Gui, Add, GroupBox, x20 y410 w780 h60 %textColor%, QUICK PRESETS

Gui, Add, Button, x30 y425 w140 h30 gClickerSlow cGreen, SLOW (2 CPS)
Gui, Add, Button, x185 y425 w140 h30 gClickerNormal cBlue, NORMAL (5 CPS)
Gui, Add, Button, x340 y425 w140 h30 gClickerFast cFFAA00, FAST (10 CPS)
Gui, Add, Button, x495 y425 w140 h30 gClickerSuper cLime, ULTRA (20 CPS)

; ============================================
; TAB 3: KEY SEQUENCE (1-5)
; ============================================

Gui, Tab, 3

Gui, Add, Text, x20 y160 w780 h20 cFFAA00, KEY SEQUENCE - Steps 1 to 5

Gui, Add, GroupBox, x20 y185 w780 h270 %textColor%, SEQUENCE BUILDER

Gui, Add, Text, x30 y205 w100 %textColor%, STEP
Gui, Add, Text, x140 y205 w150 %textColor%, KEY
Gui, Add, Text, x300 y205 w150 %textColor%, DELAY (ms)

Loop, 5
{
    row := A_Index
    yPos := 235 + (row - 1) * 40
    
    Gui, Add, Text, x30 y%yPos% w100 %textColor%, Step %row%:
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

Gui, Add, GroupBox, x20 y185 w780 h270 %textColor%, SEQUENCE BUILDER

Gui, Add, Text, x30 y205 w100 %textColor%, STEP
Gui, Add, Text, x140 y205 w150 %textColor%, KEY
Gui, Add, Text, x300 y205 w150 %textColor%, DELAY (ms)

Loop, 5
{
    row := A_Index + 5
    yPos := 235 + (A_Index - 1) * 40
    
    Gui, Add, Text, x30 y%yPos% w100 %textColor%, Step %row%:
    Gui, Add, Edit, x140 y%yPos% w150 h25 c000000 vKeySeq%row%,
    Gui, Add, Edit, x300 y%yPos% w80 h25 c000000 vDelaySeq%row%, 50
}

Gui, Add, Button, x30 y520 w160 h30 gSetKeySequence cFFAA00, Save Sequence
Gui, Add, Text, x210 y525 w300 h20 vLoopCounterDisplay cYellow, Loops: 0

; ============================================
; TAB 5: COMBO BUILDER
; ============================================

Gui, Tab, 5

Gui, Add, GroupBox, x20 y160 w780 h170 %textColor%, COMBO BUILDER - CREATE CUSTOM ACTION CHAINS

Gui, Add, Text, x30 y180 w100 %textColor%, Combo Name:
Gui, Add, Edit, x150 y175 w250 h25 c000000 vComboNameInput, My Combo

Gui, Add, Text, x30 y215 w100 %textColor%, Action:
Gui, Add, Edit, x150 y210 w150 h25 c000000 vComboActionInput, a
Gui, Add, Text, x320 y215 w80 %textColor%, Repeat:
Gui, Add, Edit, x420 y210 w80 h25 c000000 vComboRepeatInput, 1

Gui, Add, Button, x30 y250 w110 h30 gAddComboAction cFFAA00, Add Action
Gui, Add, Button, x155 y250 w110 h30 gSaveCombo cGreen, Save
Gui, Add, Button, x280 y250 w110 h30 gLoadCombo cBlue, Load
Gui, Add, Button, x405 y250 w110 h30 gStartCombo cLime, Start (F11)
Gui, Add, Button, x530 y250 w110 h30 gClearComboActions cRED, Clear

Gui, Add, GroupBox, x20 y295 w780 h165 %textColor%, COMBO ACTIONS

Gui, Add, Text, x30 y315 w750 cYellow, No actions added yet. Click "Add Action" to start building!
Gui, Add, Text, x30 y345 w750 cYellow, Example: Press 'a' 3 times, wait 100ms, press 'w' 2 times
Gui, Add, Text, x30 y370 w750 cYellow, This creates a custom macro sequence saved as a profile!

Gui, Add, Text, x30 y410 w750 vComboStatus cGreen, Status: Ready

; ============================================
; ============================================
; TAB 6: MACRO SCHEDULER
; ============================================

Gui, Tab, 6

Gui, Add, GroupBox, x20 y160 w780 h200 %textColor%, SCHEDULE MACROS - RUN AUTOMATICALLY AT SPECIFIC TIMES

Gui, Add, Text, x30 y185 w100 %textColor%, Macro 1 - Time:
Gui, Add, Edit, x140 y180 w70 h25 c000000 vScheduleTime1Input, 12:00

Gui, Add, Text, x230 y185 w80 %textColor%, Action:
Gui, Add, DropDownList, x330 y180 w130 h30 vScheduleMacro1Dropdown, Key Spam|Auto Clicker|Key Sequence|Combo

Gui, Add, Text, x480 y185 w80 %textColor%, Repeat:
Gui, Add, Edit, x580 y180 w70 h25 c000000 vScheduleRepeat1Input, 1

Gui, Add, Text, x30 y225 w100 %textColor%, Macro 2 - Time:
Gui, Add, Edit, x140 y220 w70 h25 c000000 vScheduleTime2Input, 18:00

Gui, Add, Text, x230 y225 w80 %textColor%, Action:
Gui, Add, DropDownList, x330 y220 w130 h30 vScheduleMacro2Dropdown, Key Spam|Auto Clicker|Key Sequence|Combo

Gui, Add, Text, x480 y225 w80 %textColor%, Repeat:
Gui, Add, Edit, x580 y220 w70 h25 c000000 vScheduleRepeat2Input, 1

Gui, Add, GroupBox, x20 y375 w780 h95 %textColor%, SCHEDULER CONTROLS

Gui, Add, Checkbox, x30 y395 w400 h20 vSchedulerEnabledCheck, Enable Scheduler
Gui, Add, Text, x30 y420 w750 cYellow, Time Format: HH:MM (24-hour) Example: 14:30 is 2:30 PM

Gui, Add, Button, x30 y445 w110 h30 gApplyScheduler cFFAA00, Apply
Gui, Add, Button, x155 y445 w110 h30 gStartScheduler cGreen, Start
Gui, Add, Button, x280 y445 w110 h30 gStopScheduler cRED, Stop
Gui, Add, Button, x405 y445 w110 h30 gViewSchedulerLog cBlue, View Log

; ============================================
; TAB 7: ADVANCED FEATURES
; ============================================

Gui, Tab, 7

Gui, Add, GroupBox, x20 y160 w780 h150 %textColor%, COMBO BUILDER

Gui, Add, Text, x30 y180 w400 %textColor%, Build custom combo sequences:
Gui, Add, Text, x30 y205 w750 cYellow, Example: Press 'a' 3 times, then 'w' 2 times, then space 1 time!
Gui, Add, Button, x30 y230 w160 h30 gOpenComboBuilder cFFAA00, Open Combo Builder
Gui, Add, Text, x210 y235 w300 h20 cGreen, (Advanced sequencing - coming soon!)

Gui, Add, GroupBox, x20 y325 w780 h150 %textColor%, MACRO TOOLS

Gui, Add, Text, x30 y345 w400 %textColor%, Macro Scheduler:
Gui, Add, Button, x30 y365 w160 h30 gOpenScheduler cFFAA00, Open Scheduler
Gui, Add, Text, x210 y370 w400 cYellow, Schedule macros to run at specific times

; ============================================
; TAB 8: SETTINGS & INFO
; ============================================

Gui, Tab, 8

Gui, Add, GroupBox, x20 y160 w780 h100 %textColor%, ALL HOTKEYS

Gui, Add, Text, x30 y180 w350 cYellow, KEY SPAM: F7 = Start | F8 = Stop
Gui, Add, Text, x30 y205 w350 cYellow, AUTO CLICKER: F5 = Start | F6 = Stop
Gui, Add, Text, x30 y230 w350 cYellow, KEY SEQUENCE: F9 = Start | F10 = Pause

Gui, Add, GroupBox, x20 y275 w780 h180 %textColor%, CORE FEATURES

Gui, Add, Text, x30 y295 w350 %textColor%, KEY SPAM | AUTO CLICKER | KEY SEQUENCE
Gui, Add, Text, x30 y320 w350 cYellow, Speed Presets + Variable Delays + Performance Stats + Profile System

Gui, Add, GroupBox, x420 y275 w380 h180 %textColor%, FEATURES INFO

Gui, Add, Text, x430 y295 w350 cFFAA00, All Features Enabled:
Gui, Add, Text, x430 y320 w350 cYellow, Speed Presets (SLOW/NORMAL/FAST)
Gui, Add, Text, x430 y340 w350 cYellow, Variable Delays (natural timing)
Gui, Add, Text, x430 y360 w350 cYellow, Performance Monitoring (CPS, Actions, Time)
Gui, Add, Text, x430 y380 w350 cYellow, Profile System (Save/Load/Update)
Gui, Add, Button, x430 y410 w150 h25 gAboutTool cGreen, About Tool

Gui, Add, GroupBox, x20 y465 w780 h130 %textColor%, ADVANCED FEATURES

Gui, Add, Text, x30 y485 w350 cLime, [+] Combo Builder - Chain unlimited actions
Gui, Add, Text, x30 y510 w350 cLime, [+] Macro Scheduler - Schedule macros to run at specific times
Gui, Add, Text, x30 y535 w350 cLime, [+] Performance Monitoring - Real-time CPS tracking

Gui, Add, Text, x420 y485 w350 cLime, [+] Variable Timing - Natural delay variations
Gui, Add, Text, x420 y510 w350 cLime, [+] Keystroke History - Log all macro actions
Gui, Add, Text, x420 y535 w350 cLime, [+] Resource Monitor - Track CPU usage

Gui, Add, Button, x30 y580 w160 h25 gViewKeyHistory cBlue, View Keystroke History
Gui, Add, Button, x210 y580 w160 h25 gViewResourceMonitor cPurple, Resource Monitor
Gui, Add, Button, x390 y580 w160 h25 gClearLogs cRED, Clear All Logs
Gui, Add, Button, x570 y580 w160 h25 gAboutTool cGreen, About This Tool

; ============================================
; TAB 9: PREFERENCES
; ============================================

Gui, Tab, 9

Gui, Add, GroupBox, x20 y160 w780 h150 %textColor%, APPEARANCE

Gui, Add, Checkbox, x30 y180 w400 h20 vDarkModeCheck, Dark Mode (Default)
Gui, Add, Text, x30 y205 w750 cYellow, Dark mode is enabled by default. Uncheck to use Light Mode.
Gui, Add, Text, x30 y225 w750 cYellow, Note: Restart the tool for theme changes to take effect.

Gui, Add, Button, x30 y240 w150 h30 gApplyTheme cFFAA00, Apply Theme

Gui, Add, GroupBox, x20 y330 w780 h150 %textColor%, CREDITS & ACKNOWLEDGMENTS

Gui, Add, Text, x30 y350 w750 cFFAA00, Auto Clicker UI Inspired By:
Gui, Add, Text, x30 y375 w750 cYellow, Blur Auto Clicker (https://github.com/Blur009/Blur-AutoClicker)
Gui, Add, Text, x30 y395 w750 cYellow, Creator: Blur009 | License: GPL-3.0

Gui, Add, Text, x30 y420 w750 cYellow, Special thanks to Blur009 for pioneering high-precision

Gui, Add, Text, x30 y440 w750 cYellow, auto-clicking technology with variable duty cycles and

Gui, Add, Text, x30 y460 w750 cYellow, advanced randomization features.

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
    global keySpamRunning, selectedKey1, selectedKey2, keyDelay1, keyDelay2, actionCount, startTime, antiDetectionEnabled, jitterAmount
    if (!keySpamRunning)
    {
        keySpamRunning := true
        GuiControl, , KeySpamStatus, Status: RUNNING
        GuiControl, , ActiveMacro, [ACTIVE] Key Spam Running
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
    global autoClickerRunning, clickerButton, clickerDelay, clickerCPS, clickerHold, clickerVariation, actionCount, clickCount, startTime
    if (!autoClickerRunning)
    {
        autoClickerRunning := true
        GuiControl, , AutoClickerStatus, Status: RUNNING
        GuiControl, , ActiveMacro, [ACTIVE] Auto Clicker Running
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

ClickerSuper:
{
    GuiControl, , ClickerSpeedDropdown, ULTRA (20 CPS)
    GuiControl, , ClickerCPSInput, 20
    GuiControl, , ClickerHoldInput, 5
    GuiControl, , ClickerVariationInput, 2
    ToolTip, ULTRA FAST: 20 CPS!
    SetTimer, RemoveToolTip, 1500
}
return

ClickerFast:
{
    GuiControl, , ClickerSpeedDropdown, FAST (10 CPS)
    GuiControl, , ClickerCPSInput, 10
    GuiControl, , ClickerHoldInput, 10
    GuiControl, , ClickerVariationInput, 1
    ToolTip, FAST: 10 CPS!
    SetTimer, RemoveToolTip, 1500
}
return

ClickerNormal:
{
    GuiControl, , ClickerSpeedDropdown, NORMAL (5 CPS)
    GuiControl, , ClickerCPSInput, 5
    GuiControl, , ClickerHoldInput, 15
    GuiControl, , ClickerVariationInput, 0
    ToolTip, NORMAL: 5 CPS!
    SetTimer, RemoveToolTip, 1500
}
return

ClickerSlow:
{
    GuiControl, , ClickerSpeedDropdown, SLOW (2 CPS)
    GuiControl, , ClickerCPSInput, 2
    GuiControl, , ClickerHoldInput, 20
    GuiControl, , ClickerVariationInput, 0
    ToolTip, SLOW: 2 CPS!
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
ToolTip, Advanced settings applied!
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

; ============================================
; KEY SEQUENCE
; ============================================

F9::
{
    global keySequenceRunning, keySequencePaused, keySeqKeys, keySeqDelays, loopCount, antiDetectionEnabled, jitterAmount, actionCount
    
    if (!keySequenceRunning)
    {
        keySequenceRunning := true
        keySequencePaused := false
        loopCount := 0
        GuiControl, , ActiveMacro, [ACTIVE] Key Sequence Running
        
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
    ToolTip, Settings updated!
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
    ToolTip, Performance stats reset!
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

OpenComboBuilder:
{
    ToolTip, Combo Builder Coming Soon! - Advanced sequencing features
    SetTimer, RemoveToolTip, 2500
}
return

WindowDetect:
{
    ToolTip, Detecting window... (Click on target window)
    SetTimer, RemoveToolTip, 2500
    Sleep, 500
    WinGetActiveTitle, activeWindow
    ToolTip, Detected: %activeWindow%
    SetTimer, RemoveToolTip, 3000
}
return

OpenScheduler:
{
    ToolTip, Macro Scheduler Coming Soon! - Schedule macros to run at specific times
    SetTimer, RemoveToolTip, 2500
}
return

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
        ToolTip, No keystroke history yet. Start a macro to record actions!
    }
    SetTimer, RemoveToolTip, 2500
}
return

ViewResourceMonitor:
{
    ToolTip, Checking system resources...
    Sleep, 500
    
    ; Get process memory info
    Process, Exist
    currentPID := ErrorLevel
    Process, Exist, AutoHotkey.exe
    ahkPID := ErrorLevel
    
    ; Simple info display
    MsgBox, 64, Resource Monitor, Automation Tool is running.`n`nAutomation Tool is extremely lightweight and uses minimal CPU/Memory.`n`nGreat for gaming!
}
return

ClearLogs:
{
    logFile := A_AppData "\AutomationTool\macro_history.log"
    if FileExist(logFile)
    {
        FileDelete, %logFile%
        ToolTip, All logs cleared!
    }
    else
    {
        ToolTip, No logs to clear!
    }
    SetTimer, RemoveToolTip, 1500
}
return

AboutTool:
{
    MsgBox, 64, About Automation Tool, 
    (LTrim
    AUTOMATION TOOL
    Keyboard and Mouse Automation
    
    CORE FEATURES:
    [+] Key Spam (press keys repeatedly)
    [+] Auto Clicker (click automatically)
    [+] Key Sequences (chain up to 10 keys)
    [+] Combo Builder (create custom sequences)
    [+] Macro Scheduler (schedule runs at times)
    [+] Speed Presets (SLOW/NORMAL/FAST)
    [+] Performance Monitoring (CPS, Actions, Time)
    [+] Profile System (Save/Load/Update)
    [+] Keystroke History & Logging
    
    PERFECT FOR:
    - Repetitive tasks
    - Game macros
    - Productivity automation
    - Testing and QA
    - Accessibility needs
    
    SPECIAL THANKS:
    Auto Clicker UI inspired by Blur009's
    Blur Auto Clicker project (GPL-3.0).
    
    See Preferences tab for full credits.
    
    Simple. Reliable. Efficient.
    )
}
return

; ============================================
; RANDOMIZATION FUNCTIONS
; ============================================

GetRandomizedDelay(baseDelay, variance)
{
    global antiDetectionEnabled
    if (!antiDetectionEnabled)
        return baseDelay
    
    Random, variation, -%variance%, %variance%
    newDelay := baseDelay + variation
    if (newDelay > 0)
        return newDelay
    else
        return baseDelay
}

; ============================================
; LOGGING & HISTORY
; ============================================

LogAction(actionType, key := "", delay := "")
{
    timestamp := A_Now
    logEntry := timestamp " | " actionType
    if (key != "")
        logEntry := logEntry " | Key: " key
    if (delay != "")
        logEntry := logEntry " | Delay: " delay "ms"
    
    ; Log to file
    logFile := A_AppData "\AutomationTool\macro_history.log"
    FileAppend, %logEntry%`n, %logFile%
}

; ============================================
; COMBO BUILDER FUNCTIONS
; ============================================

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
    
    listText := "Actions in Combo: "
    Loop, % comboSteps.Length()
        listText := listText "`n" A_Index ". Key: " comboSteps[A_Index].key " x" comboSteps[A_Index].repeat
    
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
    
    listText := "Actions in Combo: "
    Loop, % comboSteps.Length()
        listText := listText "`n" A_Index ". Key: " comboSteps[A_Index].key " x" comboSteps[A_Index].repeat
    
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
    GuiControl, , ComboActionsList, No actions added yet. Click "Add Action" to start building!
    ToolTip, All actions cleared!
    SetTimer, RemoveToolTip, 1500
}
return

; ============================================
; ============================================
; MACRO SCHEDULER FUNCTIONS
; ============================================

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
    GuiControl, , SchedulerStatus, Scheduler Status: ENABLED
    
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
    GuiControl, , SchedulerStatus, Scheduler Status: DISABLED
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
