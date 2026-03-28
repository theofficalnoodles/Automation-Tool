# Automation Tool 🤖

A powerful, universal automation tool for **any task**. Includes **auto clicker** and **key spam** functionality with an easy-to-use UI. Perfect for games, apps, workflows, and more!

## Features ✨

- **🖱️ Auto Clicker** - Click any mouse button automatically (Left, Right, Middle)
- **⌨️ Key Spam** - Repeatedly press any key
- **⚡ Adjustable Speed** - Control click/key speed in milliseconds
- **🔧 Custom Hotkeys** - Set your own hotkeys for start/stop
- **🎨 Modern UI** - Clean, user-friendly interface
- **⚙️ Real-time Status** - See what's running at a glance
- **🔄 Multi-feature** - Run clicker and key spam independently
- **💾 Lightweight** - Small file size, runs fast

## System Requirements

- **Windows 7+** (or any Windows version)
- **AutoHotkey v1.1** - [Download here](https://www.autohotkey.com/download/1.1/)

## Installation

1. **Download AutoHotkey v1.1**
   - Visit https://www.autohotkey.com/download/1.1/
   - Run the installer
   - Choose "Install for all users" (recommended)

2. **Download This Script**
   - Click **Code** → **Download ZIP**
   - OR clone with git: `git clone https://github.com/yourusername/game-automation-tool.git`
   - Extract the ZIP file

3. **Run the Script**
   - Double-click `AutomationTool.ahk`
   - The GUI window will open

## How to Use

### Key Spam (F7/F8)
1. Type a key in the **"Select Key"** field (e.g., `z`, `x`, `space`, `enter`)
2. Click **"Set Key"** to apply
3. Adjust spam speed with the **"Spam Speed"** slider (milliseconds)
4. Press **F7** to start spamming
5. Press **F8** to stop

### Auto Clicker (F5/F6)
1. Choose a mouse button from the dropdown (**Left**, **Right**, or **Middle**)
2. Adjust click speed (milliseconds)
3. Press **F5** to start clicking
4. Press **F6** to stop clicking

### Custom Hotkeys
1. Click in a **Hotkey** field under "HOTKEY SETTINGS"
2. Press your desired key combo (e.g., `F5`, `Ctrl+1`, `Alt+C`)
3. Click **"Apply Hotkeys"** to save

## Default Hotkeys

| Function | Default Hotkey |
|----------|---|
| Start Key Spam | F7 |
| Stop Key Spam | F8 |
| Start Auto Clicker | F5 |
| Stop Auto Clicker | F6 |

## Common Speeds

- **Very Fast:** 10-25ms (risky, may cause issues)
- **Fast:** 25-50ms (good for most games)
- **Normal:** 50-100ms (safe, noticeable delay)
- **Slow:** 100-200ms (very visible clicks/keys)

## Examples

### Gaming 🎮
- **Clicker Game:** Left click at 30ms, let it run
- **Idle Game:** Key spam (z key) at 150ms
- **Fast-Paced:** Auto clicker 50ms + key spam simultaneously

### Productivity 📊
- **Repetitive Forms:** Spam spacebar to fill forms quickly
- **Data Entry:** Auto-click and tab through fields
- **Testing:** Automate UI testing workflows

### Other Uses 💡
- **Art/Design:** Rapidly apply effects or transformations
- **Video Editing:** Timeline automation
- **Presentations:** Auto-advance slides
- **Chat/Social:** Quick responses (use responsibly!)
- **Accessibility:** Help for users with mobility needs

## ⚠️ Important Notes

- **Use Responsibly** - Know when automation is appropriate for your use case
- **Some services ban macros** - Gaming platforms, certain websites may detect and flag automation
- **Check Terms of Service** - Always verify you're allowed to use macros
- **Not for cheating online** - This tool is meant for single-player, personal productivity, or authorized use
- **Run as Administrator** - For best compatibility with applications and games

## Troubleshooting

### Script won't run?
- Make sure AutoHotkey v1.1 is installed
- Right-click the script → "Run with AutoHotkey"

### Hotkeys not working?
- Some games intercept hotkeys - try different keys (F1-F12, etc.)
- Make sure the game window has focus

### Clicks/keys not registering?
- Close other programs that use AutoHotkey
- Try running as Administrator

## Advanced Settings

You can edit `AutomationTool.ahk` with any text editor:

```autohotkey
selectedKey := "z"        ; Change default key
keySpamDelay := 50        ; Change default spam speed
clickerDelay := 50        ; Change default click speed
```

## Legal

This tool is provided as-is for automation and productivity purposes. Users are responsible for compliance with applicable terms of service, website policies, and local laws. The authors are not responsible for account bans, service violations, or other consequences. Always check if automation is permitted before using this tool.

## Contributing

Found a bug? Have a feature idea? Submit an issue or pull request!

### Ideas for Improvements:
- [ ] Save/load profiles
- [ ] Scheduled macros
- [ ] Multiple key sequences
- [ ] Mouse movement recording
- [ ] GUI themes
- [ ] Collision/detection features

## License

MIT License - see [LICENSE](LICENSE) file for details

## Support

- 💬 Open an issue on GitHub
- 📖 Check the troubleshooting section above
- 🐛 Report bugs with details and screenshots

---

**Made with ❤️ for automation and productivity**

If you find this useful, please star the repo! ⭐
