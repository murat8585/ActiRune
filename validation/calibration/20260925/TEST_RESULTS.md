# İlk kalibrasyon — test ve APK sonuçları

Tarih: 2026-09-25
Kaynak: production/closeout-20260924 @ 95d7a83a529bf7e04ca3939a85e65bd277de4f88
Düzeltme dalı: fix/onboarding-calibration-wiring-20260925
PHONE_BUILD: C:\Users\Murat\Desktop\ActiRune-Calibration-Fix-20260925-arm64-v8a-debug.apk
GITHUB_BRANCH: fix/onboarding-calibration-wiring-20260925
GITHUB_HEAD: f2bb9b4bf94fc884484933e41ed72f3e4212a315 (kod/test/build commit'i; bu satırın rapor düzeltmesi ayrı doküman commit'idir)
RESULT: FAIL

## Doğrulama

- flutter pub get — başarılı.
- flutter analyze — başarılı, sorun bulunmadı.
- flutter test --no-pub test/calibration_wiring_test.dart — 9 test başarılı.
- flutter test --no-pub — 360 test başarılı, başarısız test yok.
- git diff --check — temiz.
- flutter build apk --debug --split-per-abi --target-platform android-x64 — başarılı; APK yalnızca ActiRune_Emulator'a kuruldu.
- flutter build apk --debug --split-per-abi --target-platform android-arm64 — başarılı; masaüstündeki kopya kaynak APK ile aynı SHA-256 değerine sahip.

Yeni testler, istenen A-H kontrollerini kapsar: uygulama kökü bağlantısı; kamera izni reddinde bloklama; kısmi pose hazır oluşunda bloklama; hareket kanıtı yokken sonuç üretmeme; dört gerçek doğrulayıcıyla test sonucuna erişim; ürün Plank süresi yokken bloklama; doğrulanmamış alternatif gereksiniminde bloklama; boş/düşük güvenli pose karelerinde kanıt üretmeme. Ek regresyon testi, düşük güvenli karelerin Plank tutuş süresini yapay olarak tamamlamadığını doğrular. Testte açıkça verilen Plank süresi yalnızca test girdisidir.

## GitHub araştırması

origin: https://github.com/murat8585/ActiRune.git
İncelenen hazırlık dalları:

- calibration-engine-stage-20260923 — 8f951bdae2b5a281ccff175b44ac9b6a3e0b66a6
- four-movement-camera-stage-20260923 — 7f72b8ab44aa38b5eb54f097e7de5b83f1335d56
- plank-stage-20260923 — 352af3ffaa25e5e8e8b6cd40f8075fa552dd6695
- production-evidence-chain-stage-20260923 — 0cd0f041160621c5e8632634b62441528bb081ad
- pushup-stage-20260923 — 84ffeabc09b4337c1d21208932f4421594430d04

Bu dallar ile ürün belgelerinde üretimde kullanılabilecek yetkili Plank süresi veya alternatif hareket doğrulayıcısı bulunmadı. Bu eksik, üretim kalibrasyonunun başarıya geçirilmesini engelliyor.

## APK kimliği

Paket: com.example.actirune
Sürüm: 0.1.0 (versionCode 2001)
Tür: Android debug APK; fiziksel telefona yüklenmedi.
ABI: arm64-v8a
Android izni: android.permission.CAMERA
İmza: Android Debug sertifikasıyla APK Signature Scheme v2 doğrulandı.
Dosya: C:\Users\Murat\Desktop\ActiRune-Calibration-Fix-20260925-arm64-v8a-debug.apk
Boyut: 226425446 bayt
SHA-256: 49CACE6F536F78909790CB7659DA2A452E12C38E55DF19E1593BE6CEE89175CB

Emülatör paketi app-x86_64-debug.apk; ABI x86_64 ve kamera izni doğrulandı.

## Sonuç yorumu

Kod analizi, testler, iki ABI derlemesi ve emülatör kamera önizlemesine kadar akış doğrulandı. Ancak ürünün yetkili Plank süresi ve alternatif hareket doğrulayıcıları yok; bu nedenle dört hareketli üretim kalibrasyonu gerçek kullanıcı için tamamlanmış sayılamaz. Genel sonuç FAIL'dir. Fiziksel telefon doğrulaması da yapılmadı.

Flutter'ın analyzer çalışması analysis_options.yaml dosyasına otomatik düzenleme uygulamıştı; bu iş dışı değişiklik geri alındı. pubspec.lock, pubspec.yaml ile uyumlu çözümleme için flutter pub get sırasında beş transitive sürümde güncellendi.
