# ActiRune Android Emulator Validation

Project: ActiRune
Canonical repo: https://github.com/murat8585/ActiRune
Local workspace: C:\ActiRune_Current
Production branch: production/closeout-20260924
Production source HEAD: 95d7a83a529bf7e04ca3939a85e65bd277de4f88
Validation branch: validation/emulator-20260924
Validation run base HEAD: e0edd1e28346d488f6ffc80fcdc2a4b211dc045c
APK build commit: 119889c351192af224a283b7be619f6a5f46358c
APK build commit parent: 95d7a83a529bf7e04ca3939a85e65bd277de4f88
Validation purpose: emulator install and first-launch check
Status: PASS

APK: C:\Users\Murat\Desktop\ActiRune-emulator-x64-debug-119889c35119.apk
APK SHA-256 expected and actual: 48129eb1e4ca9ccf9d1582958c73a926b64b045dea1c99b12994c1e6c8c01bd3
APK metadata: validation/emulator/20260924/APK_METADATA.txt
Package: com.example.actirune
Version: 0.1.0 (versionCode 1)
Launch activity: com.example.actirune.MainActivity
ABI: x86_64; lib/x86_64/libflutter.so is present and loaded successfully
Install: SUCCESS; installed base.apk SHA-256 matches the Desktop APK

AVD: ActiRune_Emulator (Pixel 8 profile)
ADB serial: emulator-5554
Android API/release: 37 / 17
Device model: sdk_gphone64_x86_64
ABI: x86_64
Boot complete: yes
Display resolution: 1080x2400

Launch: one cold launch after target-only logcat clear; am start returned Status=ok and LaunchState=COLD (2343 ms)
Foreground activity: com.example.actirune.MainActivity
App process: remained alive after launch and at screenshot readback
First screen: ActiRune onboarding screen rendered; no black screen
Crash: none observed
Flutter fatal: none observed
Native fatal: none observed
Important log errors: none; non-fatal emulator graphics warnings and skipped startup frames were logged
Screenshot: validation/emulator/20260924/ACTIRUNE_EMULATOR_FIRST_LAUNCH.png
Launch log: validation/emulator/20260924/ACTIRUNE_EMULATOR_FIRST_LAUNCH_LOG.txt
