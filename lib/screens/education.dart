import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Montserrat'),
      home: EducationPage(),
    ),
  );
}

class EducationPage extends StatelessWidget {
  final Map<String, String> topics = {
    "Deprem": "https://youtu.be/oZeI0X40EEY?si=a5ReATUoRZJl0j-Q",
    "Sel": "https://youtu.be/OKYgIFOiur8?si=C2vB7-OVBICOTk48",
    "Çığ": "https://youtu.be/1f6-6j7FlAo?si=mexCU0TsNb80G9qz",
    "Yangın": "https://youtu.be/Suyeb3Jsp08?si=RujfBbEH0_mW9oFe",
    "Heyelan": "https://youtu.be/nPUcxKI3PEs?si=GKFK-PJXVfcL-wGH",
  };

  EducationPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8D6E63),
        title: const Text(
          'Afet Eğitimleri',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Afet Türlerini Öğrenin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Aşağıdaki konulardan birini seçerek eğitim videolarını izleyebilirsiniz:',
              style: TextStyle(color: Color(0xFF666666)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children:
                    topics.entries.map((entry) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE67F22).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.play_circle_fill,
                              color: Color(0xFFE74C3C),
                              size: 30,
                            ),
                          ),
                          title: Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () => _launchURL(entry.value),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info,
                    color: Color(0xFF3498DB),
                    size: 28,
                  ),
                ),
                title: const Text(
                  'Afetlere Yönelik Bilinçlendirme',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: const Text('Detaylı bilgi için tıklayınız'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InfoPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bilinçlendirme Metni',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE67F22),
        elevation: 5,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFDF2E9), Color(0xFFF5F5F5)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emergency_share,
                        size: 50,
                        color: Color(0xFFE74C3C),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Afetlere Karşı Hazırlıklı Olun',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF34495E),
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'Afetlere karşı bilinçli olmak ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'hayati öneme sahiptir. Deprem, sel, yangın gibi doğal afetlerde önceden alınan önlemler can kayıplarını azaltır.Deprem, sel, yangın, heyelan gibi doğal afetler, dünyanın her yerinde yaşanmakta ve maalesef önceden haber vermezler. Ancak bu, çaresiz olduğumuz anlamına gelmez.'
                                  'Önceden alınan tedbirler ve bilinçli davranışlar, can ve mal kayıplarını büyük ölçüde azaltır, hayatları kurtarır.'
                                  'Her birey afetlere karşı hazırlıklı olmalı ve afet anında ne yapacağını bilmelidir.'
                                  'Bu hazırlık, sadece kendimiz için değil, sevdiklerimiz ve toplumumuz için de bir sorumluluktur'
                                  'Afet bilinci, sadece afet anında değil, öncesi, sırası ve sonrasını kapsayan bir yaşam alışkanlığıdır.\n\n',
                            ),
                            TextSpan(
                              text: 'Temel Afet Bilgileri:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  '• Acil çıkış yollarını öğrenin\n'
                                  '• Acil durum çantanızı hazır tutun\n'
                                  '• Toplanma alanlarınızı bilin\n'
                                  '• Aile afet planı yapın\n'
                                  '• İlk yardım eğitimi alın',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
