import 'dart:convert';
import 'package:afetnet/screens/menu.dart';
import 'package:afetnet/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'fener.dart';
import "pusula.dart";
import "duduk.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();

  bool showEmergencyOptions = false;

  late AnimationController _toolsAnimationController;
  late Animation<double> _toolsAnimation;

  double? temperature;
  bool isWeatherLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fetchWeather();

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
    }
  }

  @override
  void dispose() {
    _toolsAnimationController.dispose();
    super.dispose();
  }

  void _toggleToolsOptions() {
    setState(() {
      if (_toolsAnimationController.isCompleted) {
        _toolsAnimationController.reverse();
      } else {
        _toolsAnimationController.forward();
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

          // Hava Durumu
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

          // Yardım Noktaları Butonu
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: ElevatedButton(
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
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('URL açılamıyor.')),
                  );
                }
              },
              child: const Text("Yardım Noktaları"),
            ),
          ),

          // Acil Yardım Seçenekleri
          Positioned(
            bottom: 120,
            left: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: showEmergencyOptions ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !showEmergencyOptions,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    emergencyButton("Enkaz Altındayım"),
                    emergencyButton("Sele Yakalandım"),
                    emergencyButton("Yangın Var"),
                    emergencyButton("Diğer"),
                  ],
                ),
              ),
            ),
          ),

          // Araçlar Seçenekleri
          Positioned(
            bottom: 120,
            right: 20,
            child: SizeTransition(
              sizeFactor: _toolsAnimation,
              axis: Axis.vertical,
              axisAlignment: 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  toolButton(FontAwesomeIcons.lightbulb, "El Feneri", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FenerSayfasi(),
                      ),
                    );
                    _toolsAnimationController.reverse();
                  }),
                  const SizedBox(height: 8),
                  toolButton(FontAwesomeIcons.compass, "Pusula", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PusulaSayfasi(),
                      ),
                    );
                    _toolsAnimationController.reverse();
                  }),
                  const SizedBox(height: 8),
                  toolButton(FontAwesomeIcons.volumeHigh, "Düdük", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DudukSayfasi(),
                      ),
                    );
                    _toolsAnimationController.reverse();
                  }),
                ],
              ),
            ),
          ),

          // Alt Menü Butonları
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
                  IconButton(
                    tooltip: "Menü",
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
                  IconButton(
                    tooltip: "Harita",
                    icon: const Icon(Icons.map, color: Colors.white, size: 28),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Harita butonuna tıklandı'),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      foregroundColor: Colors.white,
                      elevation: 4,
                    ),
                    onPressed: _getCurrentLocation,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    tooltip: "Araçlar",
                    icon: const Icon(
                      Icons.construction,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _toggleToolsOptions,
                  ),
                  IconButton(
                    tooltip: "Bildirim",
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bildirim butonuna tıklandı'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emergencyButton(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$text talebi gönderildi!')));
        },
        child: Text(text),
      ),
    );
  }

  Widget toolButton(IconData icon, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: onPressed,
      ),
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
