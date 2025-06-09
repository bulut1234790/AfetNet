import 'package:afetnet/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _kullaniciAdi = TextEditingController();
  final _sifre = TextEditingController();

  void _loginUser() async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/afetnet-back/auth/login.php"),
      body: {"kullanici_adi": _kullaniciAdi.text, "sifre": _sifre.text},
    );

    if (response.body.contains("success")) {
      _saveUserToDevice();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş başarılı!")),
      );
      // TODO: Ana sayfaya yönlendirme
    } else if (response.body.contains("Şifre yanlış")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Şifre yanlış.")),
      );
    } else if (response.body.contains("Kullanıcı bulunamadı")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı bulunamadı.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: ${response.body}")),
      );
    }
  }

  void _saveUserToDevice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("kadi", _kullaniciAdi.text);
    prefs.setString("sifre", _sifre.text);
  }

  void _checkUserFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final String? kadi = prefs.getString("kadi");
    final String? sifre = prefs.getString("sifre");
    // Gerekirse burada otomatik giriş yapılabilir
  }

  @override
  void initState() {
    _checkUserFromDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AFETNET",
          style: TextStyle(
            color: Color(0xFF4E342E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown.shade400,
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xFFFFECD9),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo_arkaplansiz.png",
                  width: 200,
                  height: 320,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 50,
                  width: 320,
                  child: TextField(
                    controller: _kullaniciAdi,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 250, 240),
                      labelStyle: TextStyle(color: Colors.black87),
                      labelText: 'Kullanıcı Adı',
                      prefixIcon: Icon(Icons.account_circle_rounded),
                      hintText: 'Lütfen kullanıcı adınızı girin',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 320,
                  child: TextField(
                    obscureText: true,
                    controller: _sifre,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 250, 240),
                      prefixIcon: Icon(Icons.lock),
                      labelStyle: TextStyle(color: Colors.black87),
                      labelText: 'Şifre',
                      hintText: 'Lütfen şifrenizi girin',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _loginUser();
                  },
                  child: Text(
                    "Giriş yap",
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Hesabın yok mu?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        "Kayıt Ol",
                        style: TextStyle(color: Color(0xFF4E342E)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
