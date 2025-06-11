import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math; // math kütüphanesini doğru şekilde içe aktar

class PusulaSayfasi extends StatefulWidget {
  const PusulaSayfasi({super.key});

  @override
  _PusulaSayfasiState createState() => _PusulaSayfasiState();
}

class _PusulaSayfasiState extends State<PusulaSayfasi> {
  double? _direction; // Pusulanın mevcut yönü (derece olarak)
  String? _errorMessage; // Hata mesajlarını tutmak için

  @override
  void initState() {
    super.initState();
    // Pusula sensöründen gelen olayları dinle
    FlutterCompass.events
        ?.listen((event) {
          if (mounted) {
            // Widget hala ekrandaysa güncelle
            setState(() {
              _direction = event.heading; // Başlık (yön) bilgisini al
              _errorMessage = null; // Hata varsa temizle
            });
          }
        })
        .onError((error) {
          // Sensör hatası durumunda hata mesajını göster
          if (mounted) {
            setState(() {
              _errorMessage =
                  'Pusula sensörüne erişilemiyor. Cihazınızda pusula sensörü olmayabilir veya izinler reddedilmiş olabilir.';
              _direction = null; // Yön bilgisini sıfırla
            });
          }
          debugPrint('Pusula hatası: $error');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusula'),
        backgroundColor: Colors.brown[400], // AppBar rengi
        foregroundColor: Colors.white, // AppBar başlık ve ikon rengi
      ),
      body: Container(
        color: const Color(0xFFF7F6E7), // Arka plan rengi
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hata mesajı varsa göster
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (_direction ==
                  null) // Pusula sensörü bulunamazsa veya henüz veri gelmediyse
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Pusula verisi yükleniyor...'),
                    Text(
                      'Lütfen cihazınızı düz bir zemine koyun veya kalibre edin.',
                    ),
                  ],
                )
              else // Pusula verisi mevcutsa
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pusula kadranı (arka plan resmi)
                    Image.asset(
                      'assets/images/compass_face.png',
                      width: 250, // Sabit genişlik
                      height: 250, // Sabit yükseklik
                      fit: BoxFit.contain, // Resmin kutucuğa sığmasını sağla
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.image_not_supported,
                            size: 150,
                            color: Colors.grey,
                          ),
                    ),
                    // Pusula iğnesi (dönen kısım)
                    Transform.rotate(
                      // `_direction` değeri derece cinsindendir, -1 ile çarparak ters yöne döndürüyoruz (pusula iğnesi kuzeye bakmalı)
                      // `math.pi / 180` ile dereceyi radyana çeviriyoruz.
                      angle: ((_direction ?? 0) * (math.pi / 180) * -1),
                      child: Image.asset(
                        'assets/images/compass.jpg',
                        width: 200, // Kadranın boyutuna göre ayarla
                        height: 200, // Kadranın boyutuna göre ayarla
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.error_outline,
                              size: 100,
                              color: Colors.red,
                            ),
                      ),
                    ),
                    // Derece bilgisini gösteren metin
                    Text(
                      '${_direction!.toStringAsFixed(1)}°', // Dereceyi bir ondalık basamakla göster
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
