import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: EmergencyContactsScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
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
  final _formKey = GlobalKey<FormState>();

  void _addContact(String name, String phone) {
    setState(() {
      contacts.add({'name': name, 'phone': phone});
    });
  }

  void _showAddContactDialog() {
    String name = '';
    String phone = '';
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "Yeni Kişi Ekle",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Ad Soyad",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir isim girin';
                      }
                      return null;
                    },
                    onChanged: (value) => name = value,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Telefon Numarası",
                      prefixIcon: Icon(Icons.phone),
                      hintText: "05XXXXXXXXX",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen telefon numarası girin';
                      }
                      if (!value.startsWith('05')) {
                        return 'Telefon numarası geçersiz';
                      }
                      if (value.length != 11) {
                        return 'Telefon numarası geçersiz';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Sadece rakam girin';
                      }
                      return null;
                    },
                    onChanged: (value) => phone = value,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "İptal",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Kaydet"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addContact(name, phone);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$name başarıyla eklendi"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  void _removeContact(int index) {
    final removedName = contacts[index]['name'];
    setState(() {
      contacts.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$removedName listeden silindi"),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Geri Al',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              contacts.insert(index, {
                'name': removedName!,
                'phone': contacts[index]['phone']!,
              });
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Yakın Bilgisi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8D6E63),
        elevation: 5,
      ),
      backgroundColor: Color(0xFFF7F6E7),
      body:
          contacts.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.contact_phone,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Henüz kayıtlı kişi yok",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Alttaki + butonuna basarak ekleyin",
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal[100],
                        child: Text(
                          contacts[index]['name']![0],
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        contacts[index]['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(contacts[index]['phone']!),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeContact(index),
                      ),
                      onTap: () {
                        // TODO: Arama işlevi eklenebilir
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, size: 32),
        elevation: 5,
      ),
    );
  }
}
