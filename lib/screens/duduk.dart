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
    // Loop ayarını her çalmadan önce yap
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Düdük"),
        backgroundColor: Colors.brown.shade400, // AppBar rengi
        foregroundColor: Colors.white, // Başlık rengi
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sesi Çal butonu (tasarımı korunmuştur)
            ElevatedButton.icon(
              onPressed: _playAlarm, // _playAlarm fonksiyonunu çağır
              icon: const Icon(Icons.volume_up, size: 30),
              label: const Text("Sesi Çal", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Sesi Durdur butonu (tasarımı korunmuştur)
            ElevatedButton.icon(
              onPressed: _stopAlarm, // _stopAlarm fonksiyonunu çağır
              icon: const Icon(Icons.volume_off, size: 30),
              label: const Text("Sesi Durdur", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
