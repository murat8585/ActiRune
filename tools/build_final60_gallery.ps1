param(
    [string]$DeviceId = ""
)

$ErrorActionPreference = "Stop"
$packageId = "com.example.actirune"
$assetDir = "assets/ui/clean_base_final_60"
$entrypoint = "lib/main_final60_gallery.dart"
$builtApk = "build/app/outputs/flutter-apk/app-debug.apk"
$outputDir = "build/final60"
$outputApk = Join-Path $outputDir "ActiRune-Final60-Gallery-debug.apk"

function Step([string]$message) {
    Write-Host "`n==> $message" -ForegroundColor Cyan
}

function Assert-Exit([string]$label) {
    if ($LASTEXITCODE -ne 0) {
        throw "$label failed with exit code $LASTEXITCODE"
    }
}

Step "Verify repository and Final60 source assets"
if (-not (Test-Path ".git")) {
    throw "Run this script from the ActiRune repository root."
}
if (-not (Test-Path $entrypoint)) {
    throw "Missing $entrypoint. Fetch/reset the current branch first."
}
if (-not (Test-Path $assetDir)) {
    throw "Missing $assetDir"
}
$sourcePngs = @(Get-ChildItem $assetDir -File -Filter *.png | Sort-Object Name)
Write-Host "SOURCE_FINAL60_COUNT=$($sourcePngs.Count)"
if ($sourcePngs.Count -ne 60) {
    throw "Expected exactly 60 source PNG files, found $($sourcePngs.Count)."
}
$head = (git rev-parse HEAD).Trim()
Assert-Exit "git rev-parse"
Write-Host "HEAD=$head"

Step "Verify Flutter toolchain"
flutter --version
Assert-Exit "flutter --version"

Step "Resolve Flutter dependencies"
flutter pub get
Assert-Exit "flutter pub get"

Step "Build Final60 debug APK"
flutter build apk --debug -t $entrypoint
Assert-Exit "flutter build apk"
if (-not (Test-Path $builtApk)) {
    throw "APK was not created at $builtApk"
}

Step "Verify 60 Final60 PNG files are physically inside APK"
Add-Type -AssemblyName System.IO.Compression.FileSystem
$resolvedBuiltApk = (Resolve-Path $builtApk).Path
$zip = [System.IO.Compression.ZipFile]::OpenRead($resolvedBuiltApk)
try {
    $apkPngs = @(
        $zip.Entries | Where-Object {
            $_.FullName -like "assets/flutter_assets/assets/ui/clean_base_final_60/*.png"
        }
    )
    Write-Host "APK_FINAL60_COUNT=$($apkPngs.Count)"
    if ($apkPngs.Count -ne 60) {
        throw "Expected 60 Final60 PNG files inside APK, found $($apkPngs.Count)."
    }
} finally {
    $zip.Dispose()
}

Step "Create stable APK copy and SHA-256"
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
Copy-Item -Force $resolvedBuiltApk $outputApk
$resolvedOutputApk = (Resolve-Path $outputApk).Path
$apkHash = (Get-FileHash $resolvedOutputApk -Algorithm SHA256).Hash
Write-Host "APK=$resolvedOutputApk" -ForegroundColor Green
Write-Host "SHA256=$apkHash" -ForegroundColor Green

Step "Find running Android emulator"
$adbPath = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
if (-not (Test-Path $adbPath)) {
    $adbCommand = Get-Command adb -ErrorAction SilentlyContinue
    if ($adbCommand) {
        $adbPath = $adbCommand.Source
    } else {
        Write-Host "ADB not found. APK build and verification are complete." -ForegroundColor Yellow
        Write-Host "APK=$resolvedOutputApk"
        exit 0
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
        Write-Host "No running emulator. APK build and verification are complete." -ForegroundColor Yellow
        Write-Host "APK=$resolvedOutputApk"
        exit 0
    } else {
        throw "Multiple emulators found: $($devices -join ', '). Re-run with -DeviceId <id>."
    }
}

Step "Remove old ActiRune from $DeviceId"
& $adbPath -s $DeviceId uninstall $packageId | Out-Host

Step "Install verified Final60 gallery APK on $DeviceId"
& $adbPath -s $DeviceId install $resolvedOutputApk | Out-Host
Assert-Exit "adb install"

Step "Launch Final60 gallery"
& $adbPath -s $DeviceId shell monkey -p $packageId -c android.intent.category.LAUNCHER 1 | Out-Host
Assert-Exit "adb launch"

Write-Host "`nDONE" -ForegroundColor Green
Write-Host "HEAD=$head"
Write-Host "SOURCE_FINAL60_COUNT=60"
Write-Host "APK_FINAL60_COUNT=60"
Write-Host "DEVICE=$DeviceId"
Write-Host "APK=$resolvedOutputApk"
Write-Host "SHA256=$apkHash"
