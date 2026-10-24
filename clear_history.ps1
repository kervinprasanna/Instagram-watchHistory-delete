Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Instagram Watch History Auto-Cleaner (PowerShell)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Auto-locate adb.exe across common locations, or auto-download if not found
$possiblePaths = @(
    "adb",
    "$PSScriptRoot\platform-tools\adb.exe",
    "$env:USERPROFILE\platform-tools\adb.exe",
    "$env:USERPROFILE\Downloads\platform-tools\adb.exe",
    "$env:USERPROFILE\Downloads\platform-tools-latest-windows\platform-tools\adb.exe",
    "C:\platform-tools\adb.exe"
)

$adbPath = $null
foreach ($path in $possiblePaths) {
    if ($path -eq "adb") {
        if (Get-Command "adb" -ErrorAction SilentlyContinue) {
            $adbPath = "adb"
            break
        }
    } elseif (Test-Path $path) {
        $adbPath = $path
        break
    }
}

if (-not $adbPath) {
    Write-Host "ADB not found. Automatically downloading Android tools (takes 5 seconds)..." -ForegroundColor Yellow
    $zipPath = "$PSScriptRoot\platform-tools.zip"
    Invoke-WebRequest -Uri "https://dl.google.com/android/repository/platform-tools-latest-windows.zip" -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath "$PSScriptRoot" -Force
    Remove-Item $zipPath -Force
    $adbPath = "$PSScriptRoot\platform-tools\adb.exe"
    Write-Host "Download complete!" -ForegroundColor Green
}

function Invoke-Adb($cmd) {
    & $adbPath shell $cmd
}

# Check ADB devices
Write-Host "`nChecking connected phone..." -ForegroundColor Yellow
& $adbPath devices

Write-Host "`nInstructions:" -ForegroundColor Green
Write-Host "1. Open Instagram on your phone."
Write-Host "2. Go to: Profile -> Menu (3 lines) -> Your activity -> Watch history."
Write-Host "3. Tap 'Select' in the top right corner."
Write-Host "--------------------------------------------------"

Read-Host "Press ENTER when you are on the 'Select' screen on your phone"

Write-Host "`nStarting in 3 seconds... Do not touch your phone screen!" -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Auto-detect screen resolution
$screenRaw = & $adbPath shell wm size
$screenWidth = 720
$screenHeight = 1604

if ($screenRaw -match '(\d+)x(\d+)') {
    $screenWidth = [int]$matches[1]
    $screenHeight = [int]$matches[2]
}
Write-Host "Detected phone screen resolution: ${screenWidth}x${screenHeight}" -ForegroundColor Cyan

# Instagram 3-column grid coordinates for 720x1604:
# Column X centers:
$col1 = 120
$col2 = 360
$col3 = 600

# Row Y centers:
# Row 1 (top row of reels): Y = 460
# Row 2 (middle row of reels): Y = 890
$row1 = 460
$row2 = 890

# 6 videos selected per batch (Row 1 + Row 2 across all 3 columns)
$batchPoints = @(
    @($col1, $row1), @($col2, $row1), @($col3, $row1),
    @($col1, $row2), @($col2, $row2), @($col3, $row2)
)

# Large decisive swipe: Starts at Y=1250 and drags up to Y=350 (900px distance)
# This completely pushes Row 1 and Row 2 off-screen so they CANNOT be re-tapped!
$swipeX = 360
$swipeStartY = 1250
$swipeEndY = 350

# Total batches (15 batches x 6 videos = 90 videos)
$totalBatches = 15

for ($b = 1; $b -le $totalBatches; $b++) {
    Write-Host "Batch $b of $totalBatches - Selecting 6 videos..." -ForegroundColor White
    
    # 1. Tap Row 1 (3 videos) and Row 2 (3 videos)
    foreach ($pt in $batchPoints) {
        $x = $pt[0]
        $y = $pt[1]
        Invoke-Adb "input tap $x $y"
        Start-Sleep -Milliseconds 130
    }
    
    # 2. Large decisive swipe to push both rows completely off-screen
    Invoke-Adb "input swipe $swipeX $swipeStartY $swipeX $swipeEndY 400"
    Start-Sleep -Milliseconds 900
}

Write-Host "`n==================================================" -ForegroundColor Green
Write-Host "Finished selecting videos!" -ForegroundColor Green
Write-Host "Now look at your phone and tap 'Delete' / 'Clear' at the bottom." -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
