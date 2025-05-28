import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: EmergencyContactsScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  EmergencyContactsScreenState createState() => EmergencyContactsScreenState();
}

class EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<Map<String, String>> contacts = [];

  void _addContact(String name, String phone) {
    setState(() {
      contacts.add({'name': name, 'phone': phone});
    });
  }

  void _showAddContactDialog() {
    String name = '';
    String phone = '';
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Yeni Kişi Ekle"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Ad Soyad"),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Telefon Numarası"),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => phone = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("İptal"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text("Ekle"),
                onPressed: () {
                  if (name.isNotEmpty && phone.isNotEmpty) {
                    _addContact(name, phone);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
    );
  }

  void _removeContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yakın Bilgileri"),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(icon: Icon(Icons.person), onPressed: () {}),
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      backgroundColor: Color(0xFFFFFDE7),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade100],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: Text("Ad Soyad: ${contacts[index]['name']}"),
              subtitle: Text("Tel No: ${contacts[index]['phone']}"),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeContact(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        backgroundColor: Colors.green,
        child: Icon(Icons.add, size: 32),
      ),
    );
  }
}
