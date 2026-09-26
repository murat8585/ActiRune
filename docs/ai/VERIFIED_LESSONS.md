# ActiRune doğrulanmış proje dersleri

## LESSON-ID: ACTIRUNE-FIRST-CALIBRATION-ENTRY
- Status: VERIFIED_PROJECT
- Scope: C:\ActiRune_Current / Flutter onboarding ve kamera kalibrasyonu
- Symptom fingerprint: İlk Kalibrasyon hotspot'u onboarding ekranında kalır; kamera/pose rotası açılmaz.
- Preconditions: ActiRuneApp GoRouter onboarding rotasını OnboardingScreen runner olmadan oluşturur.
- Root cause: Runner null olduğu için CTA eylemi kapalıdır; uygulama kökü gerçek kalibrasyon ekranını bağlamamıştır.
- Failed approach: Hotspot'u doğrudan sonuç ekranına yönlendirmek veya sahte pose kanıtı üretmek.
- Verified route: Uygulama kökünden gerçek FirstCalibrationFlowScreen rotasına bağla; profil girdisi, Android kamera izni, kamera hazır oluşu, pose ve hareket doğrulamasını koru. Tam-vücut güveni kaybolunca etkin doğrulayıcıyı yeniden başlat; tekrarlar veya Plank zamanı eksik karelerin üzerinden taşınmasın.
- Verification commands: flutter test test/calibration_wiring_test.dart (9/9); flutter test (360/360); flutter analyze; x86_64 emülatör kurulumu ve kamera önizlemesi.
- Expected evidence: Testte A-H kontrolleri ve pose-kaybı regresyonu geçer; kullanıcı girişi gerçek kamerayı başlatır; eksik pose/hareket kanıtı sonuç üretmez ve görünmeyen Plank süresi sayılmaz.
- Product gate: Bu Plank koşulu 2026-09-26 P5B ilk kalibrasyon hareket değişikliğiyle geçersiz oldu; güncel ilk kalibrasyon koşulu aşağıdaki P5B kaydındadır. Gameplay Plank için yetkili tutuş süresi koşulu sürer.
- Rollback: Kaynak kod düzeltme commit'ini git revert ile geri al.
- Invalidation conditions: Onboarding sözleşmesi, kamera/pose sağlayıcısı, ürün hareket listesi veya yetkili Plank hedefi değişirse yeniden doğrula.
- Evidence paths: validation/calibration/20260925/ROOT_CAUSE.md; validation/calibration/20260925/TEST_RESULTS.md; validation/calibration/20260925/EMULATOR_RESULT.md; test/calibration_wiring_test.dart.

## LESSON-ID: ACTIRUNE-P5B-STANDING-CALIBRATION
- Status: VERIFIED_PROJECT (synthetic and widget tests only; device behavior pending P5C)
- Scope: ActiRune first-calibration movement sequence and pose detectors.
- Symptom fingerprint: First calibration still uses Lunge/Push-up/Plank or its Start action remains disabled after the standing-movement decision.
- Preconditions: P5A base `cf3617e8546d5471f424d1c7501f79efd2f3394a`; required order is Squat, Reverse Lunge, High Knee, Cross Body Knee Raise.
- Root cause: P5A deliberately disabled production Start while its sequence and persisted completed profiles still described the old movements. Generic Lunge knee angles alone cannot establish backward travel.
- Verified route: Keep gameplay Lunge/Push-up/Plank; use a separate four-movement sequence. Require joint-specific rearward ankle depth relative to a standing baseline for Reverse Lunge and fail closed when depth is missing. Invalidate legacy completed calibration profiles and persist a new completed profile only after real detector evidence and a successful store write.
- Verification commands: `dart format --output=none --set-exit-if-changed lib test`; `flutter analyze --no-pub`; `flutter test --no-pub`.
- Expected evidence: Format 0 changed, analyze no issues, 432 Flutter tests pass; detector, scale, false-positive, sequence, onboarding and persistence tests cover the changed contract. Physical camera reliability remains unverified until P5C.
- Rollback: Revert the P5B branch commit; restore this file from `C:\ActiRune_RuntimeRecovery_20260926\VERIFIED_LESSONS.pre-P5B.md` if needed.
- Invalidation conditions: Camera/ML Kit depth behavior, movement contract, detector thresholds or persistence schema changes; revalidate with a real pose corpus and device audit.
- Evidence paths: `test/standing_calibration_detectors_test.dart`; `test/calibration_standing_sequence_test.dart`; `test/calibration_wiring_test.dart`; `test/calibration_app_state_test.dart`.

## LESSON-ID: ACTIRUNE-APPROVED-ART-NO-DRAWN-PANELS
- Status: VERIFIED_PROJECT (Home, Friends, Inbox and Quest Center visual check; other routes remain audit pending)
- Scope: ActiRune approved 3D/2.5D screen presentation and transparent hotspots.
- Symptom fingerprint: Flutter text panels, sample-data masks, or extra route cards visibly cover approved artwork on an emulator screenshot.
- Preconditions: The route has approved full-screen artwork and the user requires actions through its visible controls, without persistent Flutter writing over the image.
- Root cause: `ArtworkOverlay` instances placed opaque sample masks and local-state panels over the selected PNG; screenshots showed the approved composition obscured.
- Failed approach: Treat an approved full-screen PNG as a backdrop for large Flutter cards and warning labels.
- Verified route: Render the original approved artwork bytes with `ArtworkInteractionSurface` and transparent `ArtworkHotspot` controls. Keep state owners and fail-closed action gates; report baked fixture data and absent state-specific visuals as unverified rather than drawing new permanent panels.
- Verification commands: `flutter analyze --no-pub`; `flutter test --no-pub --reporter compact`; x86_64 emulator update install, cold launch, screenshots and APK/base.apk SHA-256 comparison.
- Expected evidence: Analyzer has no issues, 461/461 tests pass, Home/Friends/Inbox/Quest Center screenshots show artwork without added cards/text, and unavailable social actions do not mutate an account.
- Rollback: Revert the visual-recovery branch commit; pre-edit byte backups are under `C:\ActiRune_RuntimeRecovery_20260927\overlay_backups`.
- Invalidation conditions: User approves dynamic artwork or a screen-specific state visual; new source artwork has blank dynamic fields; state owner or route geometry changes.
- Evidence paths: `C:\ActiRune_RuntimeRecovery_20260927\social_visual_emulator\05_home_no_overlays_stable.png`; `06_social_no_overlays.png`; `08_inbox_no_overlays.png`; `09_quest_center_no_overlays.png`; `flutter_test_final_safety.log`.
