param(
    [string]$DeviceId = "",
    [switch]$SkipFullTests
)

$ErrorActionPreference = "Stop"
$branch = "codex/first10-runtime-contract-20260928"
$packageId = "com.example.actirune"
$apkPath = "build/app/outputs/flutter-apk/app-debug.apk"

function Step([string]$message) {
    Write-Host "`n==> $message" -ForegroundColor Cyan
}

Step "Verify clean git working tree"
$dirty = git status --porcelain
if ($dirty) {
    throw "Working tree is not clean. Commit/stash local changes before running this script."
}

Step "Fetch and switch to exact after-60 branch"
git fetch origin $branch
git switch $branch
git pull --ff-only origin $branch
$head = (git rev-parse HEAD).Trim()
Write-Host "HEAD=$head"

Step "Verify final 60 clean-base assets"
$assetDir = "assets/ui/clean_base_final_60"
if (-not (Test-Path $assetDir)) {
    throw "Missing $assetDir"
}
$pngCount = (Get-ChildItem $assetDir -File -Filter *.png).Count
Write-Host "FINAL60_PNG_COUNT=$pngCount"
if ($pngCount -ne 60) {
    throw "Expected 60 PNG files, found $pngCount"
}

Step "Flutter toolchain"
flutter --version

Step "Resolve dependencies"
flutter pub get

Step "Verify formatting"
dart format --output=none --set-exit-if-changed lib test

Step "Analyze"
flutter analyze

Step "Run focused first-10 tests"
flutter test --no-pub `
    test/home_runtime_state_test.dart `
    test/quests_screen_test.dart `
    test/main_shell_quest_center_route_test.dart `
    test/home_interaction_test.dart `
    test/daily_quests_screen_test.dart `
    test/weekly_quests_screen_test.dart `
    test/battle_prep_interaction_test.dart `
    test/camera_prep_interaction_test.dart `
    test/victory_interaction_test.dart `
    test/defeat_interaction_test.dart

if (-not $SkipFullTests) {
    Step "Run full Flutter test suite"
    flutter test --no-pub
}

Step "Build debug APK"
flutter build apk --debug
if (-not (Test-Path $apkPath)) {
    throw "APK was not created at $apkPath"
}
$apk = (Resolve-Path $apkPath).Path
Write-Host "APK=$apk" -ForegroundColor Green

Step "Find Android emulator"
$adb = Get-Command adb -ErrorAction SilentlyContinue
if (-not $adb) {
    Write-Host "ADB is not on PATH. APK build is complete; install manually from: $apk" -ForegroundColor Yellow
    exit 0
}

if (-not $DeviceId) {
    $devices = @(
        adb devices |
            Select-Object -Skip 1 |
            ForEach-Object { ($_ -split "\s+")[0] } |
            Where-Object { $_ -match '^emulator-\d+$' }
    )
    if ($devices.Count -eq 1) {
        $DeviceId = $devices[0]
    } elseif ($devices.Count -eq 0) {
        Write-Host "No running Android emulator found. APK build is complete: $apk" -ForegroundColor Yellow
        exit 0
    } else {
        Write-Host "Multiple emulators found: $($devices -join ', ')" -ForegroundColor Yellow
        Write-Host "Re-run with -DeviceId <emulator-id>. APK: $apk"
        exit 0
    }
}

Step "Install APK on $DeviceId"
adb -s $DeviceId install -r $apk

Step "Launch ActiRune on $DeviceId"
adb -s $DeviceId shell monkey -p $packageId -c android.intent.category.LAUNCHER 1 | Out-Host

Write-Host "`nDONE" -ForegroundColor Green
Write-Host "HEAD=$head"
Write-Host "DEVICE=$DeviceId"
Write-Host "APK=$apk"
