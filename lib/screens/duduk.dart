import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class DudukSayfasi extends StatefulWidget {
  const DudukSayfasi({super.key});

  @override
  State<DudukSayfasi> createState() => _DudukSayfasiState();
}

class _DudukSayfasiState extends State<DudukSayfasi> {
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // AudioPlayer örneği oluşturuldu

  @override
  void initState() {
    super.initState();
    // Sesin döngüde çalmasını sağlamak için ReleaseMode'u ayarla
    // Bu ayar sayesinde, ses bittiğinde otomatik olarak baştan başlayacak.
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void _playAlarm() async {
    // Ses dosyasını asset'ten yükle ve çal.
    // initState'te yapılan setReleaseMode(ReleaseMode.loop) ayarı sayesinde
    // bu ses durdurulana kadar tekrarlayacak.
    await _audioPlayer.play(AssetSource('sound/alarm.ogg'));
  }

  void _stopAlarm() async {
    // Çalmakta olan sesi durdur
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    // Widget ekrandan kaldırıldığında, AudioPlayer'ı temizle
    // Bu, bellek sızıntılarını önler ve kaynakları serbest bırakır.
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Butonlar için ortak bir genişlik tanımlayalım
    const double buttonWidth = 250.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Düdük",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Başlığı daha belirgin yap
          ),
        ),
        backgroundColor: Colors.brown.shade700, // AppBar rengini koyulaştıralım
        foregroundColor: Colors.white, // Başlık rengi
        elevation: 8, // AppBar'a gölge ekleyelim
        shape: const RoundedRectangleBorder(
          // AppBar'ın alt kenarına yuvarlaklık verelim
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        // Ekranın tamamını kapla ve gradient arka plan ver
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.brown.shade200, // Açık kahverengi tonu
              Colors.grey.shade300, // Açık gri tonu
              Colors.blueGrey.shade100, // Çok hafif mavimsi gri
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ses ikonu veya görseli
              Icon(
                Icons.volume_up_sharp, // Daha belirgin bir ikon
                size: 100, // Büyük ikon
                color: Colors.brown.shade800, // Koyu kahverengi ikon rengi
              ),
              const SizedBox(height: 40), // İkon ile butonlar arasına boşluk
              // Sesi Çal butonu
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(
                  onPressed: _playAlarm,
                  icon: const Icon(Icons.play_arrow, size: 30), // Play ikonu
                  label: const Text(
                    "Sesi Çal",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.redAccent.shade700, // Kırmızı tonunu koyulaştır
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 18,
                    ), // Dikey padding'i biraz daha artır
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Köşeleri biraz daha yuvarla
                    ),
                    elevation: 8, // Butona gölge ekle
                    shadowColor: Colors.redAccent.shade200, // Gölge rengi
                  ),
                ),
              ),
              const SizedBox(height: 25), // Butonlar arasına boşluk
              // Sesi Durdur butonu
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(
                  onPressed: _stopAlarm,
                  icon: const Icon(Icons.stop, size: 30), // Stop ikonu
                  label: const Text(
                    "Sesi Durdur",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blueGrey.shade700, // Mavi-gri tonunu koyulaştır
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 18,
                    ), // Dikey padding'i biraz daha artır
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Köşeleri biraz daha yuvarla
                    ),
                    elevation: 8, // Butona gölge ekle
                    shadowColor: Colors.blueGrey.shade200, // Gölge rengi
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
