import 'package:afetnet/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _kullanciadi = TextEditingController();

  final _sifre = TextEditingController();

  void _saveUserToDevice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("kadi", _kullanciadi.text);
    prefs.setString("sifre", _sifre.text);
  }

  void _checkUserFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final String? kadi = prefs.getString("kadi");
    final String? sifre = prefs.getString("sifre");
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
            fontStyle: FontStyle.normal,
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
                    controller: _kullanciadi,
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
                    _saveUserToDevice();
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
                          MaterialPageRoute(builder: (context) => MyWidget()),
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
