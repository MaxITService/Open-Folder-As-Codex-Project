# Open Folder As Codex Project

Small Windows helper that adds **Open project in Codex** to File Explorer.

It lets you right-click a folder and open it directly in the Codex desktop app.

## Install

Open PowerShell in this folder and run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Install-OpenWithCodex.ps1
```

The default install is for the current Windows user only, so it does not need
admin rights.

## Use

Right-click a folder, a drive, or empty space inside a folder, then choose:

**Open project in Codex**

On Windows 11 it may appear under **Show more options**.

## Uninstall

```powershell
.\Install-OpenWithCodex.ps1 -Uninstall
```

## Options

Install for every user, from an elevated PowerShell:

```powershell
.\Install-OpenWithCodex.ps1 -Scope AllUsers
```

Use a custom Codex Desktop path:

```powershell
.\Install-OpenWithCodex.ps1 -CodexExe "C:\Path\To\Codex.exe"
```

## Notes

- Requires the Codex desktop app for Windows.
- Uses the desktop app directly, so no console window should flash.
- If the icon does not appear immediately, restart Explorer.

## Related Version

Want the native Windows 11 modern context menu instead of **Show more options**?
Use the separate modern package:

[Open-Folder-As-Codex-Project-Modern](https://github.com/MaxITService/Open-Folder-As-Codex-Project-Modern)

## License

MIT License.

---

## My Other Projects

- [AivoRelay: AI Voice Relay for Windows](https://github.com/MaxITService/AIVORelay)
- [OneClickPrompts: Your Quick Prompt Companion for Multiple AI Chats](https://github.com/MaxITService/OneClickPrompts)
- [Console2Ai: Send PowerShell buffer to AI](https://github.com/MaxITService/Console2Ai)
- [AI for Complete Beginners: Guide to LLMs](https://medium.com/@maxim.fomins/ai-for-complete-beginners-guide-llms-f19c4b8a8a79)
- [Ping-Plotter: PowerShell-only ping plotting script](https://github.com/MaxITService/Ping-Plotter-PS51)
