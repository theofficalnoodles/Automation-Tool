# Contributing to Automation Tool

We love your input! We want to make contributing to this project as easy and transparent as possible.

## How to Contribute

### Report Bugs 🐛
- Use the GitHub Issues tab
- Include a clear title and description
- Provide screenshots or error messages
- Mention your Windows version and AutoHotkey version
- Describe the exact steps to reproduce the issue

**Example:**
```
Title: F7 hotkey not working with target application

Description:
When I press F7 in my application, the key spam doesn't start.
Other hotkeys work fine in other applications.

Environment: Windows 10, AutoHotkey v1.1.35
Application: XYZ App (fullscreen)
```

### Suggest Features 💡
- Open an Issue with the label "enhancement"
- Describe the use case
- Explain why this feature would be useful
- Be open to discussion!

**Example:**
```
Feature: Save/Load profiles
This would let users save their favorite settings for different games
and quickly switch between them.
```

### Submit Code Changes 🔧

1. **Fork the repository**
   - Click "Fork" in the top right

2. **Create a feature branch**
   ```bash
   git checkout -b feature/YourFeatureName
   ```

3. **Make your changes**
   - Test thoroughly
   - Follow the existing code style
   - Add comments for complex logic

4. **Commit with clear messages**
   ```bash
   git commit -m "Add feature: Profile saving"
   git commit -m "Fix: F7 hotkey not working in fullscreen games"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/YourFeatureName
   ```

6. **Open a Pull Request**
   - Describe what you changed and why
   - Reference any related issues (#123)
   - Include before/after screenshots if applicable

## Code Style Guidelines

- Use **camelCase** for variable names
- Add comments for sections and complex logic
- Keep functions small and focused
- Test on Windows 10 minimum

**Example:**
```autohotkey
; ============================================
; AUTO CLICKER SECTION (clear section headers)
; ============================================

; Start clicking loop
autoClickerRunning := true  ; camelCase variables
GuiControl, +cGreen, AutoClickerStatus, Status: RUNNING ▶

Loop
{
    if (!autoClickerRunning)
        break
    Click, %clickerButton%
    Sleep, %clickerDelay%
}
```

## Testing

Before submitting a PR, please test:

- [ ] Key spam works with various keys (a, z, space, enter, etc.)
- [ ] Auto clicker works with left/right/middle buttons
- [ ] Hotkeys can be changed and reapplied
- [ ] Speed settings work (test 10ms, 50ms, 100ms)
- [ ] Script works with multiple games if possible
- [ ] GUI doesn't have visual glitches

## Development Setup

1. Install AutoHotkey v1.1
2. Edit `AutomationTool.ahk` with any text editor
3. Run the script to test changes
4. Repeat until satisfied

## Pull Request Process

1. Update README.md with any new features/changes
2. Test your code thoroughly
3. Make sure your commits are clear and well-documented
4. We'll review and merge once approved!

## Questions?

Feel free to open an issue or discussion. Don't be shy!

---

**Thank you for helping make this project better!** 🎉
