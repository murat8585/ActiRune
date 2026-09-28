# ACTIRUNE MASTER HANDOFF — 2026-09-28

Bu dal yalnızca devir paketidir. Uygulama kodu değildir.

## En önemli durum
- Ürün: ActiRune
- Repo: murat8585/ActiRune
- Production otoritesi: `production/closeout-20260924`
- Flutter entegrasyon dalı: `codex/clean-base-flutter-integration-20260927`
- Görsel üretim: TAMAMLANDI
- Final clean-base ekran: 60/60 PASS
- Final görseller GitHub'a yüklendi: `assets/ui/clean_base_final_60/`
- Kritik bulgu: GitHub final dosya numaraları canonical ekran numaralarıyla güvenilir biçimde eşleşmiyor.
- Bu nedenle dosya numarasına bakıp route bağlamak yasak.
- Yanlış Home/Adventure asset bağlantıları geri alındı.

## Sonraki kesin adım
1. Working branch HEAD oku.
2. Production authority ile karşılaştır.
3. 60 final PNG'yi görsel içerikten tek tek tanımla.
4. `filename -> visual identity -> canonical screen -> Flutter screen -> route` manifesti çıkar.
5. İlk playable 10 ekranı doğrula.
6. Sonra Flutter'a bağla ve test et.

İlk playable zincir:
Home -> Quest Center -> Daily/Weekly -> Adventure -> Battle Prep -> Camera Prep -> Live Battle -> Victory/Defeat.
