# İlk kalibrasyon bağlantısı — kök neden

Tarih: 2026-09-25
Kaynak dalı: production/closeout-20260924
Kaynak SHA: 95d7a83a529bf7e04ca3939a85e65bd277de4f88
Düzeltme dalı: fix/onboarding-calibration-wiring-20260925

## Doğrulanan kök neden

Uygulama kökü lib/app/actirune_app.dart içinde OnboardingScreen'i kalibrasyon çalıştırıcısı olmadan oluşturuyordu. lib/features/onboarding/onboarding_screen.dart içindeki İlk Kalibrasyon çağrısı, çalıştırıcı null olduğunda kapalı kalıyordu. Böylece ilk kalibrasyon çizimindeki hotspot gerçek kamera/pose akışına ulaşamıyordu.

## Düzeltme

- Uygulama kökü, onboarding callback'ini gerçek FirstCalibrationFlowScreen rotasına bağlar.
- Profil hedefi, günlük dakika ve deneyim bilgileri ekranda kullanıcıdan alınır; varsayılan sahte profil eklenmez.
- Dört hareketin uygunluğu kullanıcıdan istenir. Kamera izni reddedilirse sonuç üretilmez; yeniden deneme ve Android uygulama ayarlarını açma eylemleri bulunur.
- Hareket kanıtı mevcut squat, lunge, push-up ve plank doğrulayıcılarından gelir. Başlangıç profili ancak gerçek doğrulanmış kanıtla oluşturulur.
- Tam-vücut pose güveni kaybolduğunda etkin hareket doğrulayıcısı yeniden başlatılır; doğrulanmamış kare aralıkları tekrar veya Plank süresi olarak kullanılamaz.
- Kanonik görsel ve hotspot geometrisi değiştirilmedi.

## Ürün sözleşmesinden kaynaklanan açık engel

ACTIRUNE_MASTER_PRODUCT_BIBLE_20260919.md kalibrasyonda kısa plank hareketini tarif ediyor; gerekli tutuş süresini sayısal olarak tanımlamıyor. İncelenen GitHub hazırlık dallarında da bu süre için yetkili değer veya seçilebilir alternatifleri doğrulayan üretim hareket doğrulayıcısı bulunmadı. Bu nedenle üretimde Plank hedefi yokken ve alternatif hareket seçilmişken kalibrasyon tamamlanamaz. Teste özel süre üretim varsayılanı yapılmadı.

## Geri alma

Değişikliği geri almak gerekirse kaynak kod düzeltme commit'ini git revert ile geri al. İlk kaynak noktası 95d7a83a529bf7e04ca3939a85e65bd277de4f88 olarak sabittir.
