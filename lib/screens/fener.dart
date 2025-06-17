import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class FenerSayfasi extends StatefulWidget {
  const FenerSayfasi({super.key});

  @override
  State<FenerSayfasi> createState() => _FenerSayfasiState();
}

class _FenerSayfasiState extends State<FenerSayfasi> {
  bool _isOn = false; // Fenerin açık/kapalı durumu

  Future<void> _toggleFlashlight() async {
    try {
      if (_isOn) {
        await TorchLight.disableTorch(); // Feneri kapat
      } else {
        await TorchLight.enableTorch(); // Feneri aç
      }
      setState(() {
        _isOn = !_isOn; // Durumu tersine çevir
      });
    } on Exception catch (e) {
      // Fener açma/kapama sırasında hata oluşursa kullanıcıya bildir
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fener açma/kapama hatası: $e')));
    }
  }

  @override
  void dispose() {
    // Sayfa kapatılırken fener açıksa kapat
    if (_isOn) {
      TorchLight.disableTorch();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'El Feneri',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Başlığı daha belirgin yap
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900, // AppBar rengini koyu gri yap
        foregroundColor: Colors.white, // Başlık ve ikon rengi
        elevation: 8, // AppBar'a gölge ekle
      ),
      body: Container(
        // Ekranın tamamını kapla ve gradient arka plan ver
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade800, // Koyu gri başlangıç
              Colors.black, // Siyah bitiş
              Colors.grey.shade900, // Koyu gri tonu
            ],
          ),
        ),
        child: Center(
          child: GestureDetector(
            // Tıklanabilir alan için GestureDetector
            onTap: _toggleFlashlight, // Feneri aç/kapa
            child: AnimatedContainer(
              // Animasyonlu geçiş için AnimatedContainer
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 180, // Butonun genişliği
              height: 180, // Butonun yüksekliği
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Dairesel buton şekli
                color:
                    _isOn
                        ? Colors.yellow.shade700
                        : Colors.grey.shade700, // Duruma göre renk
                boxShadow: [
                  BoxShadow(
                    color:
                        _isOn
                            ? Colors.yellow.shade500.withOpacity(0.6)
                            : Colors.black.withOpacity(0.4),
                    blurRadius: _isOn ? 30 : 15, // Açıksa daha belirgin parlama
                    spreadRadius: _isOn ? 8 : 4,
                  ),
                ],
                border: Border.all(
                  color: _isOn ? Colors.yellow.shade200 : Colors.grey.shade500,
                  width: 4,
                ),
              ),
              child: Icon(
                _isOn
                    ? Icons.flashlight_on
                    : Icons.flashlight_off, // Duruma göre ikon
                color: _isOn ? Colors.white : Colors.white70, // İkon rengi
                size: 100, // İkon boyutu
              ),
            ),
          ),
        ),
      ),
    );
  }
}
