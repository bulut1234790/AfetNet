import 'package:afetnet/screens/profile_update.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ProfileScreen());
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AFETNET',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        hintColor: Colors.amber[600],
        cardTheme: CardThemeData(
          // burası CardTheme'di
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'AFETNET',
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
                              "Mustafa Yılmaz",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                            SizedBox(height: 4),
                            _buildInfoRow(Icons.credit_card, "ID: 12345678900"),
                            _buildInfoRow(
                              Icons.verified_user,
                              "Role: Volunteer",
                            ),
                            _buildInfoRow(Icons.email, "myilmaz@example.com"),
                            _buildInfoRow(Icons.phone, "+90 312 000 00 00"),
                            _buildInfoRow(Icons.location_on, "Ankara, Turkey"),
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
                      _buildContactInfo("Ayşe Yılmaz", "0123 456 78 90"),
                      _buildContactInfo("Mehmet Yılmaz", "0987 654 32 10"),
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

              // Eklenen "Bilgileri Güncelle" butonu
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileUpdateScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, color: Colors.white),
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
