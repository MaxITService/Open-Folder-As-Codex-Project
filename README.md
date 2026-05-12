# Open Folder As Codex Project

Small Windows helper that adds **Open project in Codex** to File Explorer.

It lets you right-click a folder and open it directly in the Codex desktop app.

![Open project in Codex in the classic context menu](<Media-GitHub/How it works classical menu.png>)

## Install

Run **OpenWithCodex.bat**:

```cmd
OpenWithCodex.bat
```

---

## Uninstall

Run **OpenWithCodex.bat** again.

If the context menu entry is already installed, the same batch file asks whether
to uninstall, reinstall/update, or cancel.

The installer keeps the console open and writes a log to `open-with-codex.log`.

## Useful Options

Use a custom Codex Desktop path:

```cmd
OpenWithCodex.bat -CodexExe "C:\Path\To\Codex.exe"
```

Install for every user, from an elevated PowerShell:

```powershell
.\Install-OpenWithCodex.ps1 -Scope AllUsers
```

## What It Does

The installer:

1. finds Codex Desktop, or uses `-CodexExe`,
2. adds **Open project in Codex** to the classic File Explorer context menu,
3. registers folder, folder background, and drive entries,
4. removes old broken entries from earlier versions of this script.

The default install is for the current Windows user only, so it does not need
admin rights.

## Use

Right-click a folder, a drive, or empty space inside a folder, then choose:

**Open project in Codex**

On Windows 11 it may appear under **Show more options**.

## PowerShell

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Install-OpenWithCodex.ps1
```

Uninstall:

```powershell
.\Install-OpenWithCodex.ps1 -Uninstall
```

## Notes

- Requires the Codex desktop app for Windows.
- Uses the desktop app directly, so no console window should flash.
- If the icon does not appear immediately, restart Explorer.

## Related Version

This is the classic registry-based version.

Want a native Windows 11 modern context menu item instead of **Show more options**?
Use [Open-Folder-As-Codex-Project-Modern](https://github.com/MaxITService/Open-Folder-As-Codex-Project-Modern).

## License

MIT License.

---

## My Other Projects

- [AivoRelay: AI Voice Relay for Windows](https://github.com/MaxITService/AIVORelay)
- [OneClickPrompts: Your Quick Prompt Companion for Multiple AI Chats](https://github.com/MaxITService/OneClickPrompts)
- [Console2Ai: Send PowerShell buffer to AI](https://github.com/MaxITService/Console2Ai)
- [AI for Complete Beginners: Guide to LLMs](https://medium.com/@maxim.fomins/ai-for-complete-beginners-guide-llms-f19c4b8a8a79)
- [Ping-Plotter: PowerShell-only ping plotting script](https://github.com/MaxITService/Ping-Plotter-PS51)
