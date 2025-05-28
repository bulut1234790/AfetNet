import 'package:afetnet/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Container(
            color: Color(0xFFFFECD9),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo_arkaplansiz.png",
                    width: 200,
                    height: 150,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(
                    height: 50,
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                        filled: true,

                        fillColor: const Color.fromARGB(255, 255, 250, 240),
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        labelText: 'Ad',
                        labelStyle: TextStyle(color: Colors.black87),
                        hintText: 'Lütfen  adınızı girin',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 250, 240),
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        labelStyle: TextStyle(color: Colors.black87),
                        labelText: 'Soyad',
                        hintText: 'Lütfen soyadınızı girin',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 250, 240),
                        prefixIcon: Icon(Icons.location_city),
                        labelStyle: TextStyle(color: Colors.black87),
                        labelText: 'Yaşadığınız Şehir',
                        hintText: 'Lütfen yaşadığınız şehri girin',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 250, 240),
                        prefixIcon: Icon(Icons.phone),
                        labelStyle: TextStyle(color: Colors.black87),
                        labelText: 'Telefon Numarası',
                        hintText: 'Lütfen telefon numaranızı girin',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 250, 240),
                        prefixIcon: Icon(Icons.mail),
                        labelStyle: TextStyle(color: Colors.black87),
                        labelText: 'E-posta',
                        hintText: 'Lütfen e-postanızı girin',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 250, 240),
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        labelStyle: TextStyle(color: Colors.black87),
                        labelText: 'Kullanıcı Adı',
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
                    onPressed: () {},
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Hesabın var mı?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Giriş Yap",
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
      ),
    );
  }
}
