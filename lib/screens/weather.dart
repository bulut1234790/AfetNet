import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double? temperature;
  String? weatherDescription;
  IconData? weatherIcon;
  bool isLoading = true;
  String? errorMessage; // Hata mesajlarını tutmak için yeni değişken

  @override
  void initState() {
    super.initState();
    _determinePositionAndFetchWeather();
  }

  // Konum belirleme ve hava durumu çekme fonksiyonu
  Future<void> _determinePositionAndFetchWeather() async {
    setState(() {
      isLoading = true; // Konum ve hava durumu yüklenirken göstergeyi aç
      errorMessage = null; // Önceki hataları temizle
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Konum servisi açık mı kontrol et
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Konum servisleri kapalı. Lütfen açınız.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('Konum izni reddedildi. Hava durumu bilgisi alınamıyor.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError(
        'Konum izni kalıcı olarak reddedildi. Uygulama ayarlarından izinleri kontrol ediniz.',
      );
      return;
    }

    try {
      // Mevcut konumu al
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      _showError('Konum alınırken bir hata oluştu: $e');
    }
  }

  // Hava durumu verisi çekme fonksiyonu
  Future<void> _fetchWeather(double lat, double lon) async {
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final weather = data['current_weather'];
        final weatherCode = weather['weathercode'] as int;
        final info = _getWeatherInfo(weatherCode);

        setState(() {
          temperature = weather['temperature'];
          weatherDescription = info['desc'];
          weatherIcon = info['icon'];
          isLoading = false;
          errorMessage = null; // Başarılı olunca hata mesajını temizle
        });
      } else {
        throw Exception(
          "API'den veri alınamadı. Durum kodu: ${response.statusCode}",
        );
      }
    } catch (e) {
      _showError('Hava durumu verisi alınırken bir hata oluştu: $e');
    }
  }

  // Hata mesajını göstermek ve yükleme durumunu kapatmak için yardımcı fonksiyon
  void _showError(String message) {
    setState(() {
      errorMessage = message;
      isLoading = false;
      temperature = null; // Hata durumunda sıcaklığı da sıfırla
      weatherDescription = null; // Hata durumunda açıklamayı sıfırla
      weatherIcon = null; // Hata durumunda ikonu sıfırla
    });
    // Kullanıcıya anlık bildirim verebiliriz
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Hava durumu kodlarına göre bilgileri (açıklama ve ikon) döndüren fonksiyon
  Map<String, dynamic> _getWeatherInfo(int code) {
    switch (code) {
      case 0:
        return {"desc": "Açık ve Güneşli", "icon": Icons.wb_sunny};
      case 1:
        return {"desc": "Çoğunlukla Açık", "icon": Icons.cloud_queue};
      case 2:
        return {"desc": "Parçalı Bulutlu", "icon": Icons.cloud};
      case 3:
        return {"desc": "Kapalı", "icon": Icons.cloud_off};
      case 45:
      case 48:
        return {"desc": "Sisli", "icon": Icons.foggy};
      case 51:
      case 53:
      case 55:
        return {"desc": "Hafif Çiseleyen Yağmur", "icon": Icons.grain};
      case 56:
      case 57:
        return {"desc": "Dondurucu Çiseli Yağmur", "icon": Icons.ac_unit};
      case 61:
        return {"desc": "Hafif Yağmurlu", "icon": Icons.beach_access};
      case 63:
        return {"desc": "Orta Şiddetli Yağmur", "icon": Icons.umbrella};
      case 65:
        return {"desc": "Yoğun Yağmurlu", "icon": Icons.cloudy_snowing};
      case 66:
      case 67:
        return {
          "desc": "Dondurucu Yağmur",
          "icon": Icons.ac_unit,
        }; // Icons.snowing_sharp yerine Icons.ac_unit veya Icons.cloudy_snowing kullanıldı
      case 71:
        return {"desc": "Hafif Karlı", "icon": Icons.cloudy_snowing};
      case 73:
        return {"desc": "Orta Şiddetli Kar", "icon": Icons.snowing};
      case 75:
        return {"desc": "Yoğun Kar Yağışı", "icon": Icons.snowing};
      case 77:
        return {"desc": "Dolu", "icon": Icons.cloudy_snowing};
      case 80:
        return {"desc": "Hafif Sağanak Yağmur", "icon": Icons.cloud_queue};
      case 81:
        return {"desc": "Orta Şiddetli Sağanak", "icon": Icons.water_drop};
      case 82:
        return {"desc": "Şiddetli Sağanak Yağmur", "icon": Icons.storm};
      case 85:
        return {"desc": "Hafif Kar Sağanağı", "icon": Icons.cloudy_snowing};
      case 86:
        return {"desc": "Yoğun Kar Sağanağı", "icon": Icons.snowing};
      case 95: // Fırtına: Hafif veya orta
        return {"desc": "Gök Gürültülü Fırtına", "icon": Icons.thunderstorm};
      case 96: // Fırtına: Hafif dolu ile
      case 99: // Fırtına: Yoğun dolu ile
        return {"desc": "Şiddetli Fırtına ve Dolu", "icon": Icons.thunderstorm};
      default:
        return {"desc": "Bilinmeyen Durum", "icon": Icons.help_outline};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hava Durumu'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white, // AppBar başlık ve ikon rengi
      ),
      body: Center(
        child:
            isLoading
                ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Konum alınıyor ve hava durumu yükleniyor..."),
                  ],
                )
                : errorMessage != null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _determinePositionAndFetchWeather,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Tekrar Dene"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                )
                : temperature != null &&
                    weatherDescription != null &&
                    weatherIcon != null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(weatherIcon!, size: 100, color: Colors.blue.shade700),
                    const SizedBox(height: 20),
                    Text(
                      weatherDescription!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sıcaklık: ${temperature!.toStringAsFixed(1)} °C',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Van, Van, Türkiye", // Konum bilgisi
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                )
                : Column(
                  // Hiçbir veri alınamayan ama hata da oluşmayan durum
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'Hava durumu bilgisi mevcut değil.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _determinePositionAndFetchWeather,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Tekrar Dene"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
