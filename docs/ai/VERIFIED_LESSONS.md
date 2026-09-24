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
- Product gate: Ürün yetkili Plank tutuş süresini ve seçilebilir alternatiflerin doğrulayıcılarını tanımlamadan üretim kalibrasyonunu tamamlama.
- Rollback: Kaynak kod düzeltme commit'ini git revert ile geri al.
- Invalidation conditions: Onboarding sözleşmesi, kamera/pose sağlayıcısı, ürün hareket listesi veya yetkili Plank hedefi değişirse yeniden doğrula.
- Evidence paths: validation/calibration/20260925/ROOT_CAUSE.md; validation/calibration/20260925/TEST_RESULTS.md; validation/calibration/20260925/EMULATOR_RESULT.md; test/calibration_wiring_test.dart.
