# İlk kalibrasyon — emülatör sonucu

Tarih: 2026-09-25
AVD adı: ActiRune_Emulator
ADB seri numarası: emulator-5554
Sistem: Android 17, x86_64

## Gerçek emülatör kontrolü

1. x86_64 debug APK temiz kuruldu; son kod değişikliğinden sonra aynı APK veri silmeden adb install -r ile güncellendi; paket com.example.actirune açıldı.
2. Onboarding girişinden İlk Kalibrasyon hotspot'u ile profil formuna ulaşıldı.
3. Formdaki gerekli alanlar ve dört hareket tercihi emülatörde girilince kamera hazırlık ekranına geçildi.
4. Android'in kamera izni penceresinde uygulama kullanılırken izin verildi. Paket yöneticisi sonrasında CAMERA iznini granted=true olarak gösterdi.
5. Son derlemede kamera durumu Hazır oldu ve CameraPreview emülatör kamera akışını gösterdi. Bu, kamera izni ve önizlemenin bu emülatörde çalıştığını kanıtlar.

## Sınırlar

- Emülatör görüntüsünde insan bulunmadığından kişi/pose ve tüm-vücut hazır durumu oluşmadı; hareket başlatma düğmesi kapalı kaldı.
- Squat, Lunge, Push-up ve Plank gerçek cihazda yapılmadı; emülatörde doğrulanmış hareket kanıtı veya sonuç ekranı yoktur.
- Emülatörde ön kamera mevcut değildi. Kamera katmanı kullanılabilir kameraya geri düştü; CameraX'in ön kamera denetim uyarısı görüldü. Bu uyarı uygulamanın arka kamera önizlemesini açmasını engellemedi.
- Fiziksel telefon APK'sı kurulu değildir; ARM64 APK yalnızca masaüstüne kopyalanıp SHA-256 ile kaynak çıktıya karşı doğrulandı.
- Bu kontrol Play yayını, release imzası veya fiziksel cihaz uyumluluğu kanıtı değildir.

## Sonuç

Emülatör kurulumu, uygulama açılışı, onboarding geçişi, Android kamera izni ve canlı kamera önizlemesi başarılıdır. Pose algılaması, hareket kanıtı ve fiziksel telefon doğrulaması kanıtlanmadı.
