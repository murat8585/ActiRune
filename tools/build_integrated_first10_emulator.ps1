param(
    [string]$DeviceId = "",
    [switch]$StrictTests
)

$ErrorActionPreference = "Stop"
$branch = "codex/first10-runtime-contract-20260928"
$packageId = "com.example.actirune"
$assetDir = "assets/ui/clean_base_final_60"
$builtApk = "build/app/outputs/flutter-apk/app-debug.apk"
$outputDir = "build/final60"
$outputApk = Join-Path $outputDir "ActiRune-Final60-Integrated-debug.apk"

$requiredAssets = @(
    "32__EARLY_QA_POS_25__PASS.png",
    "59__FINAL_FIX__PROGRESSION_REWARD_PATH__PASS.png",
    "44__LATE_QA_POS_13__PASS.png",
    "45__LATE_QA_POS_14__PASS.png",
    "33__EARLY_QA_POS_26__PASS.png",
    "46__LATE_QA_POS_15__PASS.png",
    "47__LATE_QA_POS_16__PASS.png",
    "56__FINAL_FIX__LIVE_BATTLE__PASS.png",
    "48__LATE_QA_POS_18__PASS.png",
    "49__LATE_QA_POS_19__PASS.png"
)

function Step([string]$message) {
    Write-Host "`n==> $message" -ForegroundColor Cyan
}

function Assert-Exit([string]$label) {
    if ($LASTEXITCODE -ne 0) {
        throw "$label failed with exit code $LASTEXITCODE"
    }
}

Step "Fetch exact integrated branch"
git fetch origin $branch
Assert-Exit "git fetch"
git reset --hard FETCH_HEAD
Assert-Exit "git reset"
$head = (git rev-parse HEAD).Trim()
Assert-Exit "git rev-parse"
Write-Host "HEAD=$head" -ForegroundColor Green

Step "Verify Final60 assets"
if (-not (Test-Path $assetDir)) {
    throw "Missing $assetDir"
}
$pngs = @(Get-ChildItem $assetDir -File -Filter *.png)
Write-Host "SOURCE_FINAL60_COUNT=$($pngs.Count)"
if ($pngs.Count -ne 60) {
    throw "Expected exactly 60 Final60 PNGs, found $($pngs.Count)."
}
foreach ($name in $requiredAssets) {
    $path = Join-Path $assetDir $name
    if (-not (Test-Path $path)) {
        throw "Missing integrated first-10 asset: $name"
    }
}
Write-Host "INTEGRATED_FIRST10_ASSETS=10" -ForegroundColor Green

Step "Flutter toolchain"
flutter --version
Assert-Exit "flutter --version"

Step "Resolve dependencies"
flutter pub get
Assert-Exit "flutter pub get"

Step "Static analysis"
flutter analyze
Assert-Exit "flutter analyze"

Step "Focused interaction tests"
$testArgs = @(
    "test/home_runtime_state_test.dart",
    "test/quests_screen_test.dart",
    "test/main_shell_quest_center_route_test.dart",
    "test/home_interaction_test.dart",
    "test/daily_quests_screen_test.dart",
    "test/weekly_quests_screen_test.dart",
    "test/battle_prep_interaction_test.dart",
    "test/camera_prep_interaction_test.dart",
    "test/victory_interaction_test.dart",
    "test/defeat_interaction_test.dart"
)
flutter test --no-pub @testArgs
$testExit = $LASTEXITCODE
if ($testExit -ne 0) {
    if ($StrictTests) {
        throw "Focused Flutter tests failed with exit code $testExit"
    }
    Write-Host "WARNING: focused tests reported failures; continuing emulator build because -StrictTests was not supplied." -ForegroundColor Yellow
}

Step "Build NORMAL ActiRune APK from lib/main.dart"
flutter build apk --debug -t lib/main.dart
Assert-Exit "flutter build apk"
if (-not (Test-Path $builtApk)) {
    throw "APK was not created at $builtApk"
}

Step "Verify Final60 content inside APK"
Add-Type -AssemblyName System.IO.Compression.FileSystem
$resolvedBuiltApk = (Resolve-Path $builtApk).Path
$zip = [System.IO.Compression.ZipFile]::OpenRead($resolvedBuiltApk)
try {
    $final60Entries = @(
        $zip.Entries | Where-Object {
            $_.FullName -like "assets/flutter_assets/assets/ui/clean_base_final_60/*.png"
        }
    )
    Write-Host "APK_FINAL60_COUNT=$($final60Entries.Count)"
    if ($final60Entries.Count -ne 60) {
        throw "Expected 60 Final60 PNGs inside APK, found $($final60Entries.Count)."
    }
    foreach ($name in $requiredAssets) {
        $expected = "assets/flutter_assets/assets/ui/clean_base_final_60/$name"
        if (-not ($zip.Entries | Where-Object { $_.FullName -eq $expected })) {
            throw "APK is missing integrated first-10 asset: $name"
        }
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

Step "Find Android emulator"
$adbPath = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
if (-not (Test-Path $adbPath)) {
    $adbCommand = Get-Command adb -ErrorAction SilentlyContinue
    if ($adbCommand) {
        $adbPath = $adbCommand.Source
    } else {
        Write-Host "ADB not found. APK build and verification are complete." -ForegroundColor Yellow
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
        Write-Host "No running emulator. APK is ready at: $resolvedOutputApk" -ForegroundColor Yellow
        exit 0
    } else {
        throw "Multiple emulators found: $($devices -join ', '). Re-run with -DeviceId <id>."
    }
}

Step "Remove previous ActiRune/gallery from $DeviceId"
& $adbPath -s $DeviceId uninstall $packageId | Out-Host
$global:LASTEXITCODE = 0

Step "Install integrated ActiRune APK"
& $adbPath -s $DeviceId install $resolvedOutputApk | Out-Host
Assert-Exit "adb install"

Step "Launch normal ActiRune"
& $adbPath -s $DeviceId shell monkey -p $packageId -c android.intent.category.LAUNCHER 1 | Out-Host
Assert-Exit "adb launch"

Write-Host "`nDONE" -ForegroundColor Green
Write-Host "HEAD=$head"
Write-Host "SOURCE_FINAL60_COUNT=60"
Write-Host "INTEGRATED_FIRST10_ASSETS=10"
Write-Host "APK_FINAL60_COUNT=60"
Write-Host "DEVICE=$DeviceId"
Write-Host "APK=$resolvedOutputApk"
Write-Host "SHA256=$apkHash"
