import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const AfetNetApp());
}

class AfetNetApp extends StatelessWidget {
  const AfetNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AFETNET',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        hintColor: Colors.amber[600],
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: ProfileUpdateScreen(),
    );
  }
}

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  TextEditingController numaraController = TextEditingController();
  TextEditingController sehirController = TextEditingController();
  TextEditingController epostaController = TextEditingController();
  TextEditingController kullaniciAdiController = TextEditingController();
  TextEditingController sifreController = TextEditingController();
  TextEditingController yakinNoController = TextEditingController();

  String kullaniciAdi = '';

  final List<String> turkiyeCities = [
    'Adana',
    'Adıyaman',
    'Afyonkarahisar',
    'Ağrı',
    'Amasya',
    'Ankara',
    'Antalya',
    'Artvin',
    'Aydın',
    'Balıkesir',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Çorum',
    'Denizli',
    'Diyarbakır',
    'Düzce',
    'Edirne',
    'Elazığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Gaziantep',
    'Giresun',
    'Gümüşhane',
    'Hakkari',
    'Hatay',
    'Iğdır',
    'Isparta',
    'İstanbul',
    'İzmir',
    'Kahramanmaraş',
    'Karabük',
    'Karaman',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kilis',
    'Kırıkkale',
    'Kırklareli',
    'Kırşehir',
    'Kocaeli',
    'Konya',
    'Kütahya',
    'Malatya',
    'Manisa',
    'Mardin',
    'Mersin',
    'Muğla',
    'Muş',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Osmaniye',
    'Rize',
    'Sakarya',
    'Samsun',
    'Şanlıurfa',
    'Siirt',
    'Sinop',
    'Sivas',
    'Şırnak',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Uşak',
    'Van',
    'Yalova',
    'Yozgat',
    'Zonguldak',
  ];

  @override
  void initState() {
    super.initState();
    // fetchUserData();
    _kullaniciAdiGetirVeYukle();
  }

  Future<void> _kullaniciAdiGetirVeYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final sakliKadi = prefs.getString('kadi');

    if (sakliKadi != null && sakliKadi.isNotEmpty) {
      kullaniciAdi = sakliKadi;
      kullaniciAdiController.text = kullaniciAdi; // kontrol için
      fetchUserData();
    } else {
      _showErrorDialog(
        "Kullanıcı bilgisi bulunamadı. Lütfen tekrar giriş yapın.",
      );
    }
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2/afetnet-backend/kullanici/get.php?kullanici_adi=$kullaniciAdi',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == null) {
          setState(() {
            adController.text = data['ad'] ?? '';
            soyadController.text = data['soyad'] ?? '';
            numaraController.text = data['numara'] ?? '';
            sehirController.text = data['sehir'] ?? '';
            epostaController.text = data['e_posta'] ?? '';
            kullaniciAdiController.text = data['kullanici_adi'] ?? '';
            sifreController.text = '';
            yakinNoController.text = data['yakin_no'] ?? '';
          });
        } else {
          _showErrorDialog('Kullanıcı bulunamadı.');
        }
      } else {
        _showErrorDialog('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Bağlantı hatası: $e');
    }
  }

  Future<void> updateUser() async {
    //bir altta form dogrulaması yapacagız
    if (_formKey.currentState!.validate()) {
      //güncelleme yapacagımız bilgileri bir json
      Map<String, dynamic> jsonData = {
        "eski_kullanici_adi": kullaniciAdi,
        "ad": adController.text,
        "soyad": soyadController.text,
        "numara": numaraController.text,
        "sehir": sehirController.text,
        "e_posta": epostaController.text,
        "kullanici_adi": kullaniciAdiController.text,
        "sifre": sifreController.text,
        "yakin_no": yakinNoController.text,
      };
      if (sifreController.text.trim().isEmpty) {
        jsonData.remove('sifre');
      }

      try {
        var url = Uri.parse(
          'http://10.0.2.2/afetnet-backend/kullanici/update.php',
        );
        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(jsonData),
        );

        print("Gelen response code: ${response.statusCode}");
        print("Gelen body: ${response.body}");

        if (response.statusCode == 200) {
        
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('success')) { // 'success' anahtarı varsa
          _showUpdateSuccessDialog(); // Başarı diyalogunu göster
                                            
        } else if (responseBody.containsKey('warning')) { // 'warning' anahtarı varsa
          _showErrorDialog(responseBody['warning']); // Uyarıyı göster
        } else if (responseBody.containsKey('error')) { // 'error' anahtarı varsa
          _showErrorDialog(responseBody['error']); // Hatayı göster
        } else {
          // Beklenmedik bir yanıt formatı
          _showErrorDialog('Sunucudan beklenmedik bir yanıt alındı.');
        }
      } else {
        // HTTP durum kodu 200 değilse
        _showErrorDialog('Güncelleme başarısız oldu. Sunucu hatası: ${response.statusCode}.');
      }
    } catch (e) {
      _showErrorDialog('Sunucuya bağlanırken hata oluştu: $e'); // Hata detayını göster
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Güncelleme'),
        centerTitle: true,
        backgroundColor: Colors.brown.shade400,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProfileImage(),
                      const SizedBox(height: 20),
                      _buildTextField('Ad', adController),
                      _buildTextField('Soyad', soyadController),
                      _buildTextField('Telefon Numarası', numaraController),
                      _buildCityDropdown('Yaşadığınız Şehir', sehirController),
                      _buildTextField('E-posta', epostaController),
                      _buildTextField(
                        'Kullanıcı Adı',
                        kullaniciAdiController,
                        enabled: true,
                      ),
                      _buildPasswordField('Şifre', sifreController),
                      _buildTextField('Yakın Numarası', yakinNoController),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: updateUser,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Bilgileri Güncelle",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.teal[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.person, size: 50, color: Colors.white),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.amber[600],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.teal[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bu alan boş bırakılamaz';
          }
          if (label == 'E-posta' && !value.contains('@')) {
            return 'Geçerli bir e-posta girin';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCityDropdown(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value:
            controller.text.isNotEmpty &&
                    turkiyeCities.contains(controller.text)
                ? controller.text
                : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.teal[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        items:
            turkiyeCities.map((String city) {
              return DropdownMenuItem<String>(value: city, child: Text(city));
            }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            controller.text = newValue ?? '';
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Lütfen bir şehir seçin';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.teal[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.teal,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bu alan boş bırakılamaz';
          }
          if (value.length < 6) {
            return 'Şifre en az 6 karakter olmalıdır';
          }
          return null;
        },
      ),
    );
  }

  void _showErrorDialog(String mesaj) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text("Hata"),
              ],
            ),
            content: Text(mesaj),
            actions: [
              TextButton(
                child: const Text('Tamam', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
    );
  }

  void _showUpdateSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.teal),
                SizedBox(width: 8),
                Text("Başarılı"),
              ],
            ),
            content: const Text('Profil bilgileriniz başarıyla güncellendi.'),
            actions: [
              TextButton(
                child: const Text(
                  'Tamam',
                  style: TextStyle(color: Colors.teal),
                ),
          onPressed: () {
            Navigator.pop(context); // Önce diyalogu kapat
            // Diyalog kapandıktan sonra güncellenmiş veriyi bir önceki sayfaya göndererek geri dön.
            // Bu, en son gönderdiğimiz jsonData'dır.
            // Kullanıcı adı değişmişse güncelini, diğerleri için controller'daki değeri gönderiyoruz.
            Navigator.pop(context, {
              "kullanici_adi": kullaniciAdiController.text, // Yeni kullanıcı adı
              "ad": adController.text,
              "soyad": soyadController.text,
              "numara": numaraController.text,
              "sehir": sehirController.text,
              "e_posta": epostaController.text,
              "yakin_no": yakinNoController.text,
            });
          },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
    );
  }
}
