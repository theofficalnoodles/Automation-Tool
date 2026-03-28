# Frequently Asked Questions (FAQ)

## Installation & Setup

### Q: Do I need to pay for AutoHotkey?
**A:** No! AutoHotkey is completely free and open-source. Download from https://www.autohotkey.com

### Q: I installed AutoHotkey but the script still won't run
**A:** 
1. Make sure you installed **v1.1** (not v2)
2. Restart your computer after installing
3. Right-click the script → "Run with AutoHotkey"
4. Try running as Administrator (right-click → Run as administrator)

### Q: Can I run this on Mac or Linux?
**A:** AutoHotkey is Windows-only. For Mac/Linux, you might look into alternatives like:
- **Mac:** Automator, Hammerspoon
- **Linux:** xdotool, AutoKey

---

## Usage Questions

### Q: What's the difference between key spam and auto clicker?
**A:** 
- **Key Spam:** Rapidly presses a keyboard key (z, x, space, etc.)
- **Auto Clicker:** Rapidly clicks your mouse button (left, right, middle)

Use key spam for games that need keyboard input, and auto clicker for games that need mouse clicks.

### Q: Can I use both at the same time?
**A:** Yes! Start key spam with F7, then start the auto clicker with F5. They run independently.

### Q: What speed should I use?
**A:** 
- **Clicker games:** 30-50ms (fast)
- **Idle games:** 100-200ms (slower, less detectable)
- **Action games:** 50-100ms (balanced)
- **Too fast?** Speeds under 10ms may cause issues

### Q: Can I use keys other than z?
**A:** Yes! Type any key in the text field:
- Letters: `a`, `z`, `x`, `c`
- Function keys: `F1`, `F5`, `F12`
- Special keys: `space`, `enter`, `tab`, `shift`, `ctrl`
- Number keys: `1`, `2`, `3`, `4`, `5`

### Q: How do I stop the macro while it's running?
**A:** Press the stop hotkey (default F8 for key spam, F6 for clicker)

### Q: Can I change the hotkeys?
**A:** Yes! In the "HOTKEY SETTINGS" section, click on a hotkey field and press your desired key combination, then click "Apply Hotkeys"

---

## Troubleshooting

### Q: The script opens but nothing happens when I press F7/F8
**A:** 
1. Make sure the target window is in focus (clicked on it)
2. Some applications block hotkeys - try different keys
3. Close other programs using AutoHotkey
4. Run as Administrator

### Q: I got banned! Is it the tool's fault?
**A:** Some services (games, websites) detect and ban macro users. Always check the Terms of Service first. Bans are the responsibility of the user, not this tool.

### Q: The clicks/keys aren't registering
**A:**
1. Try a slower speed (increase milliseconds)
2. Make sure the target window has focus
3. Try running as Administrator
4. Restart the script
5. Try a different hotkey (F1-F12 are most reliable)

### Q: The GUI looks weird/blurry
**A:** 
- You may need to update DirectX
- Try running as Administrator
- On newer Windows, it might be a scaling issue (right-click → Properties → Compatibility)

---

## Advanced Questions

### Q: Can I save my settings?
**A:** Not yet! This is planned for v1.1. For now, you can:
- Edit the script with a text editor and change default values
- Write down your settings and manually enter them each time

### Q: Can I make key sequences (like hold Z then press X)?
**A:** Not with the current version. This is planned for a future update.

### Q: Can I record and replay mouse movements?
**A:** Not yet! This is a planned feature for v2.0.

### Q: How do I edit the script?
**A:** 
1. Right-click `AutomationTool.ahk`
2. Select "Edit Script" or open with Notepad
3. Make changes
4. Save (Ctrl+S)
5. Run the script again

### Q: Can I compile this into an .exe file?
**A:** Yes! Use AutoHotkey's built-in compiler:
1. Right-click the script
2. Select "Compile Script"
3. Wait for it to finish
4. An .exe file will be created

This is useful for sharing without requiring AutoHotkey installation.

---

## Performance Questions

### Q: Will this slow down my computer?
**A:** No, it uses minimal CPU. Even fast speeds (10ms) won't impact performance.

### Q: Can multiple instances run at once?
**A:** No, the script has `#SingleInstance Force` which prevents duplicates.

### Q: Does this work with virtual machines?
**A:** Generally yes, but some VMs (like VMware) may have timing issues. VirtualBox usually works fine.

---

## Legality & Safety

### Q: Is using this legal?
**A:** The tool itself is legal. However, using it to violate a service's terms of service may result in consequences (account ban, etc.). Always check the TOS before using automation on a platform.

### Q: Will this get my account banned?
**A:** It depends on where/how you use it. Many platforms (games, websites) detect and ban macro users. **Use at your own risk and know the rules of the service.**

### Q: What should I NOT use this for?
**A:** 
- Online competitive games (anti-cheat systems)
- Websites that explicitly ban bots/macros
- Any unauthorized automation
- Always read the Terms of Service first!

### Q: Is it safe from viruses?
**A:** Yes! The source code is open for inspection on GitHub. AutoHotkey scripts are text files that don't hide anything. No viruses here!

### Q: Does this collect my data?
**A:** No! This is 100% offline. Nothing is sent anywhere.

---

## Still Have Questions?

- 💬 **Open an Issue:** https://github.com/yourusername/game-automation-tool/issues
- 📖 **Read the README:** Check README.md for more details
- 🔧 **Check the Code:** The script is well-commented and easy to read

---

**Last Updated:** January 2025
