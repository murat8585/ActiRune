# ActiRune Remaining 13 Visuals — Selected Finals

Date: 2026-09-21

Bu paket, kullanıcının her ekran için ürettiği iki aday arasından görsel kalite, ActiRune canonical kimliği, navigation doğruluğu, terminoloji, hotspot kurulabilirliği ve prompt uyumu esas alınarak seçilen 13 görseli içerir.

## Kurallar
- PNG pixel verileri değiştirilmedi ve yeniden encode edilmedi; yalnız dosya adları standardize edilerek byte-for-byte kopyalandı.
- Bu seçimler production visual reference/final candidate olarak kullanılabilir.
- Dynamic fixture değerleri (tarih, sayaç, skor, progress vb.) runtime'da engine/state verisiyle değiştirilmelidir.
- Artwork üstüne yeni görünür Flutter menü/kart mimarisi bindirilmemeli; görünür kontroller transparent hotspot + route/state/engine ile çalıştırılmalıdır.
- Permanent navigation yalnız: Ana Dünya / Macera / Savaş / Kahraman / Profil.

## Seçilen ekranlar
1. Events
2. Event Detail popup
3. Daily Summary popup
4. Weekly League Result popup
5. Onboarding Welcome
6. Calibration Result
7. Rune Shrine Result
8. Settings Account
9. Settings Notifications
10. Settings Privacy
11. Settings Permissions
12. Settings Accessibility
13. Profile History

`SELECTION_MANIFEST.tsv` hangi kaynak adayın seçildiğini ve kısa gerekçeyi içerir.
`SHA256SUMS.txt` paket içindeki dosyaların hashlerini içerir.
