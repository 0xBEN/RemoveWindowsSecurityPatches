Write-Host "Gathering security updates...`n"
$securityPatches = Get-HotFix | Where-Object {$_.Description -eq 'Security Update'}
$idNumbers = $securityPatches | ForEach-Object {$_.HotFixId -replace 'kb', ''} | Sort-Object
$patchCount = $idNumbers.Count
$process = 'wusa'
$failedPatches = @()

for ($i = 0; $i -lt $patchCount; $i++) {
    $id = $idNumbers[$i]
    $arguments = "/uninstall /kb:$id /quiet /norestart"
    
    try {
    
        $commandTimespan = Measure-Command { Start-Process $process -ArgumentList $arguments -Wait }
        if ($commandTimespan.TotalSeconds -lt 5) {
            Write-Warning "Uninstaller died too quickly. Queueing KB$id for retry at end of script."
            $failedPatches += $id
        }
        else {
            Write-Host "Successfully removed $i of $patchCount`: KB$id" -ForegroundColor Green
        }
        
    }
    catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

if ($failedPatches) {

@"

Retrying uninstall with GUI output.
WUSA logging function does not provide enough detail.
You should be able to see the reason for failure when a dialogue pops up.

"@ | Write-Host -ForegroundColor White -BackgroundColor Black

    for ($i = 0; $i -lt $failedPatches.Count; $i++) {
        $id = $failedPatches[$i]
        $arguments = "/uninstall /kb:$id /norestart"
        Write-Host "Trying failed patch: KB$id ($($i + 1) of $($failedPatches.Count))"
        Start-Process $process -ArgumentList $arguments -Wait
    }
    
}

Write-Host "`nScript completed. Please reboot your computer." -ForegroundColor Green