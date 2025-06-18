import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/services/api_service.dart';
import 'profile_update.dart';

void main() {
  runApp(ProfileScreen());
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController kullaniciAdiController = TextEditingController();
  final TextEditingController adController = TextEditingController();
  final TextEditingController soyadController = TextEditingController();
  final TextEditingController numaraController = TextEditingController();
  final TextEditingController sehirController = TextEditingController();
  final TextEditingController epostaController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();
  final TextEditingController yakinNoController = TextEditingController();

  String adSoyad = '';
  String kullaniciAdi = '';
  String eposta = '';
  String numara = '';
  String sehir = '';
  String yakin_no = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _verileriCek(); // SharedPreferences’ten verileri al
  }

  Future<void> _verileriCek() async {
    // TEST: SharedPreferences yerine elle kullanıcı adı ver
    final prefs = await SharedPreferences.getInstance();
    String? kullaniciAdiSP = prefs.getString('kadi');

    if (kullaniciAdiSP == null) {
      print("Kullanıcı adı bulunamadı! Oturum açılmamış olabilir.");
      return;
    }

    print("Giriş yapan kullanıcı adı: $kullaniciAdiSP");

    var bilgiler = await kullaniciBilgileriGetir(kullaniciAdiSP);
    print("Gelen bilgiler: $bilgiler");

    if (bilgiler != null) {
      setState(() {
        kullaniciAdi = bilgiler['kullanici_adi'] ?? '';
        adSoyad = '${bilgiler['ad'] ?? ''} ${bilgiler['soyad'] ?? ''}';
        numara = bilgiler['numara'] ?? '';
        sehir = bilgiler['sehir'] ?? '';
        eposta = bilgiler['e_posta'] ?? '';

        // Controller'lara da aktar
        kullaniciAdiController.text = bilgiler['kullanici_adi'] ?? '';
        adController.text = bilgiler['ad'] ?? '';
        soyadController.text = bilgiler['soyad'] ?? '';
        numaraController.text = bilgiler['numara'] ?? '';
        sehirController.text = bilgiler['sehir'] ?? '';
        epostaController.text = bilgiler['e_posta'] ?? '';
        sifreController.text = bilgiler['sifre'] ?? '';
        yakinNoController.text = bilgiler['yakin_no'] ?? '';
      });
    }
  }

  // SharedPreferences’tan bilgileri okuyacak ve TextEditingController'lara yazacak.
  void _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String kullaniciAdiSP = prefs.getString('kullanici_adi') ?? '';

    print("Kullanıcı adı (SP): $kullaniciAdiSP");

    if (kullaniciAdiSP.isNotEmpty) {
      // API'den kullanıcı bilgilerini getir
      var bilgiler = await kullaniciBilgileriGetir(kullaniciAdiSP);
      if (bilgiler != null) {
        setState(() {
          print("Veriler setState içine geldi!");

          kullaniciAdiController.text = bilgiler['kullanici_adi'] ?? '';
          adController.text = bilgiler['ad'] ?? '';
          soyadController.text = bilgiler['soyad'] ?? '';
          numaraController.text = bilgiler['numara'] ?? '';
          sehirController.text = bilgiler['sehir'] ?? '';
          epostaController.text = bilgiler['e_posta'] ?? '';
          sifreController.text = bilgiler['sifre'] ?? '';
          yakinNoController.text = bilgiler['yakin_no'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AFETNET',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        hintColor: Colors.amber[600],
        cardTheme: CardThemeData( // burası CardTheme'di
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: Scaffold(
        backgroundColor: Color(0xFFF7F6E7),
        appBar: AppBar(
          title: Text(
            'Kişisel Bilgiler',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.brown.shade400,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Kullanıcı Kartı
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.teal, Colors.teal[400]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adSoyad.isNotEmpty ? adSoyad : 'Ad Soyad',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                            SizedBox(height: 4),
                            _buildInfoRow(
                                Icons.credit_card,
                                "Kullanıcı Adı: ${kullaniciAdi.isNotEmpty ? kullaniciAdi : '...'}"),
                            _buildInfoRow(
                              Icons.verified_user,
                              "Role: Volunteer",
                            ),
                            _buildInfoRow(Icons.email,
                                "Email: ${eposta.isNotEmpty ? eposta : '...'}"),
                            _buildInfoRow(Icons.phone,
                                "Telefon: ${numara.isNotEmpty ? numara : '...'}"),
                            _buildInfoRow(Icons.location_on,
                                "Şehir: ${sehir.isNotEmpty ? sehir : '...'}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Acil Durum İletişim Kartı
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber[700],
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Acil Durum İletişim",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.teal[800],
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[300], height: 20),
                      _buildContactInfo("Yakınınızın Telefonu", yakinNoController.text),
                    ],
                  ),
                ),
              ),

              // Bölge ve Aktiviteler
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.assignment, color: Colors.teal),
                          SizedBox(width: 8),
                          Text(
                            "Assigned Region",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32, top: 4),
                        child: Text(
                          "Beypazarı",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.history, color: Colors.teal),
                          SizedBox(width: 8),
                          Text(
                            "Recent Activity Logs",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32, top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Login – 2 hours ago"),
                            Text("Task completed – 5 hours ago"),
                            Text("Location updated – Yesterday"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final updatedUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileUpdateScreen()),
                  );

                  if (updatedUser != null) {
                    setState(() {
                      kullaniciAdi = updatedUser['kullanici_adi'] ?? '';
                      adSoyad =
                          '${updatedUser['ad'] ?? ''} ${updatedUser['soyad'] ?? ''}';
                      eposta = updatedUser['e_posta'] ?? '';
                      numara = updatedUser['numara'] ?? '';
                      sehir = updatedUser['sehir'] ?? '';
                      yakinNoController.text = updatedUser['yakin_no'] ?? '';

                      kullaniciAdiController.text = kullaniciAdi;
                      adController.text = updatedUser['ad'] ?? '';
                      soyadController.text = updatedUser['soyad'] ?? '';
                      numaraController.text = numara;
                      sehirController.text = sehir;
                      epostaController.text = eposta;
                    });
                  }
                },
                child: Text('Bilgileri Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.teal),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildContactInfo(String name, String phone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 2),
          Text(phone, style: TextStyle(color: Colors.teal[700], fontSize: 15)),
        ],
      ),
    );
  }
}
