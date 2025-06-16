import 'dart:convert';
import 'package:afetnet/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'fener.dart';
import "pusula.dart";
import "duduk.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Font Awesome importu

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();

  // Acil Durum Seçenekleri animasyonu için kontrolcüler
  late AnimationController _emergencyAnimationController;
  late Animation<double> _emergencyAnimation;

  // Araçlar Seçenekleri animasyonu için kontrolcüler
  late AnimationController _toolsAnimationController;
  late Animation<double> _toolsAnimation;

  double? temperature;
  bool isWeatherLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fetchWeather();

    // Acil Durum animasyon kontrolcüsü başlatılıyor
    _emergencyAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _emergencyAnimation = CurvedAnimation(
      parent: _emergencyAnimationController,
      curve: Curves.easeInOut,
    );

    // Araçlar animasyon kontrolcüsü başlatılıyor
    _toolsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _toolsAnimation = CurvedAnimation(
      parent: _toolsAnimationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> fetchWeather() async {
    double lat = _currentLocation?.latitude ?? 41.0082;
    double lon = _currentLocation?.longitude ?? 28.9784;

    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = data['current_weather']['temperature'];
          isWeatherLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isWeatherLoading = false;
      });
      // debugPrint('Hava durumu alınamadı: $e');
    }
  }

  @override
  void dispose() {
    _emergencyAnimationController
        .dispose(); // Acil Durum animasyon kontrolcüsünü temizle
    _toolsAnimationController
        .dispose(); // Araçlar animasyon kontrolcüsünü temizle
    super.dispose();
  }

  // Acil Durum butonlarının görünürlüğünü yöneten fonksiyon
  void _toggleEmergencyOptions() {
    setState(() {
      if (_emergencyAnimationController.isCompleted) {
        _emergencyAnimationController.reverse();
      } else {
        _emergencyAnimationController.forward();
        // Diğer menü açıksa kapat
        if (_toolsAnimationController.isCompleted) {
          _toolsAnimationController.reverse();
        }
      }
    });
  }

  // Araçlar butonlarının görünürlüğünü yöneten fonksiyon
  void _toggleToolsOptions() {
    setState(() {
      if (_toolsAnimationController.isCompleted) {
        _toolsAnimationController.reverse();
      } else {
        _toolsAnimationController.forward();
        // Diğer menü açıksa kapat
        if (_emergencyAnimationController.isCompleted) {
          _emergencyAnimationController.reverse();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? LatLng(41.015137, 28.979530),
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.afetnet_2',
              ),
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80,
                      height: 80,
                      point: _currentLocation!,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Hava Durumu Kutusu (sol üst)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.thermostat, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    isWeatherLoading
                        ? 'Yükleniyor...'
                        : '${temperature?.toStringAsFixed(1) ?? '--'} °C',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Yardım Noktaları ve Bildirimler Butonları (sağ üst)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: Column(
              // Yardım Noktaları ve Bildirimler için Column
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final Uri url = Uri.parse(
                      'https://www.afad.gov.tr/yardim-noktalari',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('URL açılamıyor.')),
                      );
                    }
                  },
                  child: const Text("Yardım Noktaları"),
                ),
                const SizedBox(height: 10), // Butonlar arası boşluk
                ElevatedButton.icon(
                  // Bildirimler butonu eklendi
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.amber.shade700, // Cırtlak olmayan sarı
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bildirimler butonuna tıklandı'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text("Bildirimler"),
                ),
              ],
            ),
          ),

          // --- Animasyonlu Acil Durum Seçenekleri ---
          // Konumumu Gör butonunun yerini alan Sağlık butonunun tam üstüne gelecek
          Positioned(
            bottom: 120, // Alt menü barının biraz üstünde
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizeTransition(
                sizeFactor: _emergencyAnimation,
                axis: Axis.vertical,
                axisAlignment:
                    1.0, // Alt kısımdan yukarı doğru açılmasını sağlar
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Sadece içeriği kadar yer kapla
                  children: [
                    emergencyButton("Enkaz Altındayım", () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enkaz Altındayım talebi gönderildi!'),
                        ),
                      );
                      _emergencyAnimationController.reverse();
                    }),
                    emergencyButton("Sele Yakalandım", () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sele Yakalandım talebi gönderildi!'),
                        ),
                      );
                      _emergencyAnimationController.reverse();
                    }),
                    emergencyButton("Yangın Var", () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Yangın Var talebi gönderildi!'),
                        ),
                      );
                      _emergencyAnimationController.reverse();
                    }),
                    emergencyButton("Diğer", () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Diğer talep gönderildi!'),
                        ),
                      );
                      _emergencyAnimationController.reverse();
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Araçlar Seçenekleri (Animasyonlu) - Sağ alt köşede
          Positioned(
            bottom: 120, // Alt menü barının biraz üstünde
            right: 20,
            child: SizeTransition(
              sizeFactor: _toolsAnimation,
              axis: Axis.vertical,
              axisAlignment: 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  toolButton(
                    FontAwesomeIcons.lightbulb,
                    Colors.amber.shade600,
                    () {
                      // Fener için sarı/turuncu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FenerSayfasi(),
                        ),
                      );
                      _toolsAnimationController.reverse();
                    },
                  ),
                  const SizedBox(height: 8),
                  toolButton(
                    FontAwesomeIcons.compass,
                    Colors.blueGrey.shade700,
                    () {
                      // Pusula için koyu mavi-gri
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PusulaSayfasi(),
                        ),
                      );
                      _toolsAnimationController.reverse();
                    },
                  ),
                  const SizedBox(height: 8),
                  toolButton(
                    FontAwesomeIcons.volumeHigh,
                    Colors.teal.shade400,
                    () {
                      // Düdük için teal tonu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DudukSayfasi(),
                        ),
                      );
                      _toolsAnimationController.reverse();
                    },
                  ),
                ],
              ),
            ),
          ),

          // Alt Menü Butonları (Güncellendi)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Menü Butonu
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuSayfasi(),
                        ),
                      );
                    },
                  ),
                  // Mevcut Konumumu Göster Butonu (Yeni, mavi ve yuvarlak)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue.shade700, // Mavi rengin koyu tonu
                      shape: const CircleBorder(), // Yuvarlak şekil
                      padding: const EdgeInsets.all(12), // Boyut ayarlaması
                      foregroundColor: Colors.white,
                      elevation: 8, // Daha belirgin gölge
                      shadowColor: Colors.blue.shade300, // Gölge rengi
                    ),
                    onPressed: _getCurrentLocation, // Mevcut konum fonksiyonu
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 28,
                    ), // Konum ikonu
                  ),
                  // SAĞLIK Butonu (Ortada, kırmızı ve yuvarlak)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors
                              .red
                              .shade700, // Kırmızı rengi koru ve koyulaştır
                      shape: const CircleBorder(), // Yuvarlak şekil
                      padding: const EdgeInsets.all(12), // Boyut ayarlaması
                      foregroundColor: Colors.white,
                      elevation: 8, // Daha belirgin gölge
                      shadowColor: Colors.red.shade300, // Gölge rengi
                    ),
                    onPressed:
                        _toggleEmergencyOptions, // Acil durum seçeneklerini göster/gizle
                    child: const Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                      size: 28,
                    ), // Sağlık ikonu
                  ),
                  // Araçlar Butonu
                  IconButton(
                    icon: const Icon(
                      Icons.construction,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _toggleToolsOptions,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // emergencyButton fonksiyonu da tıklama eylemi alacak şekilde güncellendi
  Widget emergencyButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.red.shade400, // Kırmızı tonunu daha yumuşak yap
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          foregroundColor: Colors.white,
          elevation: 4, // Gölge ekle
        ),
        onPressed: onPressed, // Dışarıdan gelen onPressed'ı kullan
        child: Text(text),
      ),
    );
  }

  // `toolButton` widget'ı Font Awesome ikonları için uyarlanmış ve tematik renkler eklenmiş hali
  Widget toolButton(
    IconData icon,
    Color backgroundColor,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor, // Tema rengi kullanıldı
        shape: BoxShape.circle, // Dairesel şekil
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Basit gölge
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        icon: FaIcon(
          icon,
          color: Colors.white,
          size: 28,
        ), // İkon rengi beyaz kaldı
        onPressed: onPressed,
        padding: const EdgeInsets.all(16),
        splashRadius: 24,
      ),
    );
  }

  // Bu fonksiyon artık kullanılmıyor olabilir, ancak eski kodda olduğu için bırakıldı.
  // İhtiyaç yoksa kaldırılabilir.
  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      foregroundColor: Colors.white,
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konum servisleri kapalı. Lütfen açınız.'),
        ),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Konum izni reddedildi.')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Konum izni kalıcı olarak reddedildi. Uygulama ayarlarından izinleri kontrol ediniz.',
          ),
        ),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation!, 16.0);
    });
  }
}
