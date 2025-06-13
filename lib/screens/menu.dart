import "package:afetnet/screens/education.dart";
import "package:afetnet/screens/profile_screen.dart";
import "package:afetnet/screens/sondepremler.dart";
import 'package:flutter/material.dart';
import "settings.dart"; // SettingsScreen dosyanın doğru yolda olduğundan emin ol
import "forum_screen.dart"; // ForumScreen dosyasını import etmeyi unutmayın!

class MenuSayfasi extends StatelessWidget {
  const MenuSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekran genişliğini alarak responsive tasarım için kullanacağız
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AfetNet",
          style: TextStyle(
            color: Colors.white,
          ), // AppBar başlık rengini beyaz yap
        ),
        backgroundColor: Colors.brown[400],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white, // Geri buton rengini beyaz yap
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: const Color(0xFFF7F6E7), // Arka plan rengi
        child: Column(
          children: [
            Expanded(
              child: GridView(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, // Her bir kartın maksimum genişliği
                  mainAxisSpacing: 20, // Dikey boşluk
                  crossAxisSpacing: 20, // Yatay boşluk
                  // Kartların en boy oranı: yüksekliği genişliğinin 1.1 katı olacak
                  // Bu, ikon ve metin için yeterli alan sağlar.
                  childAspectRatio: 1 / 1.1,
                ),
                children: [
                  _menuButonu(
                    "menu_education.png",
                    "Eğitim",
                    context,
                    screenWidth,
                  ),
                  _menuButonu(
                    "menu_forum.png",
                    "Forum",
                    context,
                    screenWidth,
                  ), // Forum butonu
                  _menuButonu(
                    "menu_person.png",
                    "Kişisel Bilgiler",
                    context,
                    screenWidth,
                  ),
                  _menuButonu(
                    "menu_earthquake.png",
                    "Son Depremler",
                    context,
                    screenWidth,
                  ),
                  _menuButonu(
                    "menu_family.png",
                    "Yakın Bilgisi",
                    context,
                    screenWidth,
                  ),
                  _menuButonu(
                    "menu_settings.png",
                    "Ayarlar",
                    context,
                    screenWidth,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Daha az yuvarlak kenar
                  ),
                  foregroundColor:
                      Colors.white, // Buton metin rengini beyaz yap
                ),
                onPressed: () {
                  Navigator.pop(context); // Anasayfaya geri dön
                },
                child: const Text(
                  "ANASAYFA",
                  style: TextStyle(
                    fontSize: 16,
                  ), // Font boyutunu sabit tutabiliriz
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Yardımcı Widget: _menuButonu ---
  Widget _menuButonu(
    String imageName,
    String metin,
    BuildContext context,
    double screenWidth,
  ) {
    // Ekran genişliğine göre ikon boyutu belirle
    // Örneğin, 600 pikselden küçük ekranlarda 80, daha büyüklerde 100
    double iconSize = screenWidth < 600 ? 80 : 100;
    // Ekran genişliğine göre font boyutu belirle
    double fontSize = screenWidth < 600 ? 14 : 16;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // Kartın iç padding'ini esnek yapabiliriz, ya da sabitte tutabiliriz
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: () {
        if (metin == "Ayarlar") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => SettingsScreen(
                    isDarkMode: false, // Uygulama durumuna göre ayarlanmalı
                    notificationsEnabled:
                        true, // Uygulama durumuna göre ayarlanmalı
                    onThemeChanged: (value) {
                      debugPrint("Tema değiştirildi: $value");
                      // Burada uygulamanın ana temasını güncelleyecek kodu çağırabilirsin
                    },
                    onNotificationsChanged: (value) {
                      debugPrint("Bildirim durumu: $value");
                      // Burada bildirim ayarını güncelleyecek kodu çağırabilirsin
                    },
                  ),
            ),
          );
        } else if (metin == "Forum") {
          // BURASI EKLENDİ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => const ForumScreen(), // ForumScreen'e yönlendirme
            ),
          );
        } else if (metin == "Eğitim") {
          // BURASI EKLENDİ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => EducationPage(), // ForumScreen'e yönlendirme
            ),
          );
        } else if (metin == "Kişisel Bilgiler") {
          // BURASI EKLENDİ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProfileScreen(), // ForumScreen'e yönlendirme
            ),
          );
        } else if (metin == "Son Depremler") {
          // BURASI EKLENDİ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DepremlerSayfasi(), // ForumScreen'e yönlendirme
            ),
          );
        } else {
          // Diğer butonlara basıldığında geçici bir Snack Bar göster
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$metin açılıyor...')));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // İçeriği dikeyde ortala
        children: [
          // İkonu Image.asset yerine Image widget'ı ile yükle
          Image.asset(
            'assets/menuicon/$imageName',
            width: iconSize, // Dinamik ikon genişliği
            height: iconSize, // Dinamik ikon yüksekliği
            fit: BoxFit.contain, // İçine sığacak şekilde ayarla
            errorBuilder:
                (context, error, stackTrace) => const Icon(
                  Icons
                      .broken_image, // Resim yüklenemediğinde hata ikonu göster
                  size: 50, // Hata ikon boyutu da dinamik olabilir
                  color: Colors.red,
                ),
          ),
          const SizedBox(height: 10), // İkon ve metin arası boşluk
          Text(
            metin,
            style: TextStyle(
              fontSize: fontSize, // Dinamik font boyutu
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center, // Metni ortala
          ),
        ],
      ),
    );
  }
}
