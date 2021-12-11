# RemoveWindowsSecurityPatches
PowerShell script that can be used to create vulnerable Windows targets.

# Usage
1. Download the `Remove-SecurityUpdate.ps1` file to the Windows host.
2. Open PowerShell as administrator 
3. Set the execution policy to allow running of unsigned scripts
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
```
4. Change directory to the folder containing this script
```powershell
cd C:\Path\To\RemoveWindowsSecurityPatches
```
5. Run the script
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
