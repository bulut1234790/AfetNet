import 'package:flutter/material.dart';

void main() {
  runApp(ProfileUpdateScreen());
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
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: ProfileUpdateScreen(),
    );
  }
}

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Kullanıcının mevcut bilgileri (varsayılan değerler)
  Map<String, String> userInfo = {
    'Ad': 'Mustafa',
    'Soyad': 'Yılmaz',
    'Yaşadığınız Şehir': 'Ankara',
    'Telefon Numarası': '+90 312 000 00 00',
    'E-posta': 'myilmaz@example.com',
    'Kullanıcı Adı': 'mustafay',
    'Şifre': '********', // Gerçek uygulamada şifre bu şekilde saklanmamalı
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Güncelleme',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4E342E),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.brown.shade400,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                      SizedBox(height: 20),
                      _buildTextField('Ad', userInfo['Ad']!),
                      _buildTextField('Soyad', userInfo['Soyad']!),
                      _buildTextField(
                        'Yaşadığınız Şehir',
                        userInfo['Yaşadığınız Şehir']!,
                      ),
                      _buildTextField(
                        'Telefon Numarası',
                        userInfo['Telefon Numarası']!,
                      ),
                      _buildTextField('E-posta', userInfo['E-posta']!),
                      _buildTextField(
                        'Kullanıcı Adı',
                        userInfo['Kullanıcı Adı']!,
                      ),
                      _buildPasswordField('Şifre', userInfo['Şifre']!),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form doğrulama başarılı ise güncelleme işlemi
                    _showUpdateSuccessDialog();
                  }
                },
                child: Row(
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
              SizedBox(height: 20),
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
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.amber[600],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.teal[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bu alan boş bırakılamaz';
          }
          return null;
        },
        onSaved: (newValue) {
          userInfo[label] = newValue!;
        },
      ),
    );
  }

  Widget _buildPasswordField(String label, String initialValue) {
    bool _obscureText = true;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            initialValue: initialValue,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.teal[800]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.teal),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.teal, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
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
            onSaved: (newValue) {
              userInfo[label] = newValue!;
            },
          ),
        );
      },
    );
  }

  void _showUpdateSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.teal),
                SizedBox(width: 8),
                Text("Başarılı"),
              ],
            ),
            content: Text("Profil bilgileriniz başarıyla güncellendi."),
            actions: [
              TextButton(
                child: Text("Tamam", style: TextStyle(color: Colors.teal)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
    );
  }
}
