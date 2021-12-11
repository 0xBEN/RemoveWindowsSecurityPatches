# RemoveWindowsSecurityPatches
PowerShell script that can be used to create vulnerable Windows targets.

# Usage
1. Install `git` on the Windows target: [git-scm](https://git-scm.com/download/win)
2. Clone this repository: `git clone https://github.com/0xBEN/RemoveWindowsSecurityPatches`
3. Open PowerShell as administrator 
4. Set the execution policy to allow running of unsigned scripts
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
```
5. Change directory to the folder containing this script
```powershell
cd C:\Path\To\RemoveWindowsSecurityPatches
```
6. Run the script
```powershell
.\Remove-SecurityUpdate.ps1
```

# What Makes this Script Different?
Readable output that is just verbose enough, and...
```powershell
$commandTimespan = Measure-Command { Start-Process $process -ArgumentList $arguments -Wait }
if ($commandTimespan.TotalSeconds -lt 5) {
    Write-Warning "Uninstaller died too quickly. Queueing KB$id for retry at end of script."
    $failedPatches += $id
}
else {
    Write-Host "Successfully removed $i of $patchCount`: KB$id" -ForegroundColor Green
}
```
This block of code will account for patch removals that fail when the uninstaller dies to quickly.
The uninstaller is running in the backgroun with no output. This queues failed patches for re-execution later.
The re-execution at the end of the script runs the installer in the foreground, so you can see the output.
I tested `wusa` with the `/log:<somefile.evtx>` parameter, but the information is just not great.
You get better information from `wusa` when it's run in the foreground.

# Thanks for Reading
Have fun out there.
