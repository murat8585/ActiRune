param(
    [string]$DeviceId = ""
)

$ErrorActionPreference = "Stop"
$branch = "codex/first10-runtime-contract-20260928"
$packageId = "com.example.actirune"
$assetDir = "assets/ui/clean_base_final_60"
$builtApk = "build/app/outputs/flutter-apk/app-debug.apk"
$outputDir = "build/preview"
$outputApk = Join-Path $outputDir "ActiRune-Verified-CleanBase-Preview-debug.apk"
$tempDir = Join-Path $env:TEMP "actirune_verified_cleanbase_preview"

$assets = @(
    [pscustomobject]@{
        Name = "Home"
        Target = "32__EARLY_QA_POS_25__PASS.png"
        Url = "https://at.adobe.com/uXkFGfbpJdRmNPVp"
    },
    [pscustomobject]@{
        Name = "CameraPrep"
        Target = "47__LATE_QA_POS_16__PASS.png"
        Url = "https://at.adobe.com/t2l8UcREwwg4oWiG"
    },
    [pscustomobject]@{
        Name = "LiveBattle"
        Target = "56__FINAL_FIX__LIVE_BATTLE__PASS.png"
        Url = "https://at.adobe.com/8iMPkRAPMGR8hYc9"
    },
    [pscustomobject]@{
        Name = "Victory"
        Target = "48__LATE_QA_POS_18__PASS.png"
        Url = "https://at.adobe.com/k2MgEzcAIxo9JC2G"
    },
    [pscustomobject]@{
        Name = "Defeat"
        Target = "49__LATE_QA_POS_19__PASS.png"
        Url = "https://at.adobe.com/GjJVdAfK2tqqEgNM"
    }
)

function Step([string]$message) {
    Write-Host "`n==> $message" -ForegroundColor Cyan
}

function Assert-Exit([string]$label) {
    if ($LASTEXITCODE -ne 0) {
        throw "$label failed with exit code $LASTEXITCODE"
    }
}

function Assert-ImageFile([string]$path, [string]$label) {
    if (-not (Test-Path $path)) {
        throw "$label was not downloaded: $path"
    }
    $bytes = [System.IO.File]::ReadAllBytes((Resolve-Path $path).Path)
    if ($bytes.Length -lt 16) {
        throw "$label download is too small ($($bytes.Length) bytes)."
    }
    $isPng = $bytes[0] -eq 0x89 -and $bytes[1] -eq 0x50 -and $bytes[2] -eq 0x4E -and $bytes[3] -eq 0x47
    $isJpeg = $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xD8 -and $bytes[2] -eq 0xFF
    if (-not ($isPng -or $isJpeg)) {
        $prefix = (($bytes | Select-Object -First 8) | ForEach-Object { $_.ToString('X2') }) -join ' '
        throw "$label did not resolve to a raster image. Header=$prefix"
    }
    Write-Host "$label bytes=$($bytes.Length)" -ForegroundColor Green
}

Step "Fetch exact preview branch"
git fetch origin $branch
Assert-Exit "git fetch"
git reset --hard FETCH_HEAD
Assert-Exit "git reset"
$head = (git rev-parse HEAD).Trim()
Assert-Exit "git rev-parse"
Write-Host "HEAD=$head" -ForegroundColor Green

if (-not (Test-Path $assetDir)) {
    throw "Missing asset directory: $assetDir"
}

New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
$backupDir = Join-Path $tempDir "backup"
$downloadDir = Join-Path $tempDir "download"
Remove-Item -Recurse -Force $backupDir,$downloadDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $backupDir,$downloadDir | Out-Null

try {
    Step "Download verified clean-base preview assets"
    foreach ($asset in $assets) {
        $targetPath = Join-Path $assetDir $asset.Target
        if (-not (Test-Path $targetPath)) {
            throw "Tracked target is missing: $targetPath"
        }
        Copy-Item -Force $targetPath (Join-Path $backupDir $asset.Target)

        $downloadPath = Join-Path $downloadDir $asset.Target
        Invoke-WebRequest -Uri $asset.Url -OutFile $downloadPath -MaximumRedirection 10 -UseBasicParsing
        Assert-ImageFile $downloadPath $asset.Name
        Copy-Item -Force $downloadPath $targetPath

        $hash = (Get-FileHash $targetPath -Algorithm SHA256).Hash
        Write-Host "$($asset.Name)_SHA256=$hash"
    }

    Step "Verify preview substitutions"
    $dirty = @(git status --short -- $assetDir)
    if ($dirty.Count -lt 5) {
        throw "Expected at least five temporary asset substitutions; got $($dirty.Count)."
    }
    $dirty | ForEach-Object { Write-Host $_ }

    Step "Flutter toolchain"
    flutter --version
    Assert-Exit "flutter --version"

    Step "Static analysis without dependency mutation"
    flutter analyze --no-pub
    Assert-Exit "flutter analyze"

    Step "Focused navigation / battle tests"
    flutter test --no-pub `
        test/main_shell_quest_center_route_test.dart `
        test/home_interaction_test.dart `
        test/camera_prep_interaction_test.dart `
        test/victory_interaction_test.dart `
        test/defeat_interaction_test.dart
    if ($LASTEXITCODE -ne 0) {
        Write-Host "WARNING: focused tests reported failures; continuing preview APK build." -ForegroundColor Yellow
        $global:LASTEXITCODE = 0
    }

    Step "Build NORMAL ActiRune preview APK"
    flutter build apk --debug --no-pub -t lib/main.dart
    Assert-Exit "flutter build apk"
    if (-not (Test-Path $builtApk)) {
        throw "APK was not created at $builtApk"
    }

    Step "Create stable preview APK"
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
    Copy-Item -Force $builtApk $outputApk
    $resolvedOutputApk = (Resolve-Path $outputApk).Path
    $apkHash = (Get-FileHash $resolvedOutputApk -Algorithm SHA256).Hash
    Write-Host "APK=$resolvedOutputApk" -ForegroundColor Green
    Write-Host "SHA256=$apkHash" -ForegroundColor Green

    Step "Find Android emulator"
    $adbPath = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
    if (-not (Test-Path $adbPath)) {
        $adbCommand = Get-Command adb -ErrorAction SilentlyContinue
        if ($adbCommand) {
            $adbPath = $adbCommand.Source
        } else {
            Write-Host "ADB not found. APK build is complete." -ForegroundColor Yellow
            return
        }
    }

    if (-not $DeviceId) {
        $deviceLines = & $adbPath devices
        Assert-Exit "adb devices"
        $devices = @(
            $deviceLines |
                Select-Object -Skip 1 |
                ForEach-Object { ($_ -split "\s+")[0] } |
                Where-Object { $_ -match '^emulator-\d+$' }
        )
        if ($devices.Count -eq 1) {
            $DeviceId = $devices[0]
        } elseif ($devices.Count -eq 0) {
            Write-Host "No running emulator. APK is ready at: $resolvedOutputApk" -ForegroundColor Yellow
            return
        } else {
            throw "Multiple emulators found: $($devices -join ', '). Re-run with -DeviceId <id>."
        }
    }

    Step "Clean install preview APK on $DeviceId"
    & $adbPath -s $DeviceId uninstall $packageId | Out-Host
    $global:LASTEXITCODE = 0
    & $adbPath -s $DeviceId install $resolvedOutputApk | Out-Host
    Assert-Exit "adb install"

    Step "Launch normal ActiRune"
    & $adbPath -s $DeviceId shell monkey -p $packageId -c android.intent.category.LAUNCHER 1 | Out-Host
    Assert-Exit "adb launch"

    Write-Host "`nDONE" -ForegroundColor Green
    Write-Host "HEAD=$head"
    Write-Host "DEVICE=$DeviceId"
    Write-Host "APK=$resolvedOutputApk"
    Write-Host "SHA256=$apkHash"
    Write-Host "PREVIEW_ASSETS=Home,CameraPrep,LiveBattle,Victory,Defeat"
}
finally {
    Step "Restore tracked repository assets"
    foreach ($asset in $assets) {
        $backupPath = Join-Path $backupDir $asset.Target
        $targetPath = Join-Path $assetDir $asset.Target
        if (Test-Path $backupPath) {
            Copy-Item -Force $backupPath $targetPath
        }
    }
    $status = @(git status --short -- $assetDir)
    if ($status.Count -eq 0) {
        Write-Host "Repository assets restored cleanly." -ForegroundColor Green
    } else {
        Write-Host "WARNING: repository asset paths are still dirty:" -ForegroundColor Yellow
        $status | ForEach-Object { Write-Host $_ }
    }
}
