$currentLocation = Get-Location
$appPath = "D:\Projects\catfish\Catfish\Catfish.PatchRunner\bin\Release\"
$settingPath = "D:\Projects\catfish\Catfish\Presentation\Nop.Web\App_Data\Settings.txt"
$csvPath = "D:\Projects\catfish\Catfish\Catfish.PatchUpdates\TextResource\English.csv" # Variable for CSV path

Set-Location $appPath

if (-not (Test-Path "$appPath\Settings.txt")) {
    Write-Host "Settings.txt does not exist in $appPath" -ForegroundColor Red
    Copy-Item $settingPath $appPath
    Write-Host "Settings.txt copied to $appPath" -ForegroundColor Green
}

# Read the CSV file
$csvContent = Get-Content $csvPath

# Find duplicate lines based on text before the first comma
$duplicates = $csvContent | Group-Object { ($_ -split ',')[0].Trim() } | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group | Select-Object -First 1 }

if ($duplicates) {
    Write-Host "Duplicate lines found in the CSV file (based on content before the first comma):" -ForegroundColor Blue
    $duplicates | ForEach-Object { Write-Host "`t$_" -ForegroundColor Red }
    
    # Remove duplicate lines
    $uniqueLines = $csvContent | Group-Object { ($_ -split ',')[0].Trim() } | ForEach-Object { $_.Group | Select-Object -First 1 }
    $uniqueLines | Set-Content $csvPath
    Write-Host "Duplicates have been removed from the CSV file. Please build and rerun the patchrunner" -ForegroundColor Green
	
    return
} else {
    Write-Host "No duplicate lines found in the CSV file." -ForegroundColor Green
}

pause
