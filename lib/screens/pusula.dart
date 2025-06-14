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
        title: const Text(
          'Pusula',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Başlığı daha belirgin yap
          ),
        ),
        backgroundColor:
            Colors.brown.shade700, // AppBar rengini koyu kahverengi yap
        foregroundColor: Colors.white, // Başlık ve ikon rengi
        elevation: 8, // AppBar'a gölge ekle
        shape: const RoundedRectangleBorder(
          // AppBar'ın alt kenarına yuvarlaklık ver
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
              Colors.brown.shade800, // Koyu kahverengi başlangıç
              Colors.brown.shade900, // Daha koyu kahverengi bitiş
              Colors.grey.shade900, // Hafif koyu gri tonu
            ],
          ),
        ),
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
                      color:
                          Colors
                              .red
                              .shade400, // Hata mesajı için daha yumuşak kırmızı
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (_direction ==
                  null) // Pusula sensörü bulunamazsa veya henüz veri gelmediyse
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ), // Beyaz yükleme göstergesi
                    SizedBox(height: 16),
                    Text(
                      'Pusula verisi yükleniyor...',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      'Lütfen cihazınızı düz bir zemine koyun veya kalibre edin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                )
              else // Pusula verisi mevcutsa
                // Derece bilgisini gösteren metin (En üste taşındı)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    '${_direction!.toStringAsFixed(0)}°', // Dereceyi tam sayı olarak göster
                    style: const TextStyle(
                      fontSize: 48, // Daha büyük font boyutu
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Beyaz renk
                      shadows: [
                        // Metne gölge ekleme
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Pusula Kadranı (arka plan)
                  Container(
                    width: 280, // Genişletilmiş boyut
                    height: 280, // Genişletilmiş boyut
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Colors
                              .blueGrey
                              .shade800, // Koyu gri-mavi kadran rengi
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 8,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade600, width: 4),
                    ),
                    child: Stack(
                      // Kadran içindeki yön etiketleri için Stack kullanıldı
                      children: [
                        // Kuzey
                        Positioned(
                          top: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              'KUZEY',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Doğu
                        Positioned(
                          right: 20,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Text(
                              'DOĞU',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(
                                      -1.0,
                                      1.0,
                                    ), // Gölge yönü ayarlandı
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Güney
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              'GÜNEY',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(
                                      1.0,
                                      -1.0,
                                    ), // Gölge yönü ayarlandı
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Batı
                        Positioned(
                          left: 20,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Text(
                              'BATI',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Pusula İğnesi (dönen kısım)
                  Transform.rotate(
                    // `_direction` değeri derece cinsindendir, -1 ile çarparak ters yöne döndürüyoruz (pusula iğnesi kuzeye bakmalı)
                    // `math.pi / 180` ile dereceyi radyana çeviriyoruz.
                    angle: ((_direction ?? 0) * (math.pi / 180) * -1),
                    child: Container(
                      width: 250, // Kadranın biraz daha küçük
                      height: 250,
                      child: CustomPaint(
                        painter: _CompassNeedlePainter(), // Özel iğne çizimi
                      ),
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

  // Dereceye göre ana yönü döndüren yardımcı fonksiyon (Artık ana yön harfleri kadran üzerinde sabit)
  String _getCardinalDirection(double degree) {
    // Bu fonksiyon artık kadranın kendisi üzerinde sabit "KUZEY" vb. yazıları için kullanılmıyor.
    // Ancak ileride iğnenin ucuna bir etiket eklenmek istenirse kullanılabilir.
    // Şimdilik boş bir dize döndürüyor.
    return '';
  }
}

// Özel Pusula İğnesi Çizimi
class _CompassNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(centerX, centerY);

    // Kırmızı üçgen (Kuzey yönü)
    final redPaint = Paint()..color = Colors.red.shade700;
    final redPath = Path();
    redPath.moveTo(centerX, centerY - radius * 0.8); // Üst nokta (Kuzey)
    redPath.lineTo(centerX - radius * 0.15, centerY);
    redPath.lineTo(centerX + radius * 0.15, centerY);
    redPath.close();
    canvas.drawPath(redPath, redPaint);

    // Gri üçgen (Güney yönü)
    final greyPaint = Paint()..color = Colors.grey.shade400;
    final greyPath = Path();
    greyPath.moveTo(centerX, centerY + radius * 0.8); // Alt nokta (Güney)
    greyPath.lineTo(centerX - radius * 0.15, centerY);
    greyPath.lineTo(centerX + radius * 0.15, centerY);
    greyPath.close();
    canvas.drawPath(greyPath, greyPaint);

    // Ortadaki daire
    final centerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(centerX, centerY), radius * 0.1, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // İğne her zaman aynı çizilir, tekrar çizmeye gerek yok
  }
}
