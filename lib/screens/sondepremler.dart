import 'package:flutter/material.dart';
import 'package:afetnet/models/depremm.dart';
import 'package:afetnet/services/deprem_service.dart';

class DepremlerSayfasi extends StatefulWidget {
  const DepremlerSayfasi({super.key});

  @override
  _DepremlerSayfasiState createState() => _DepremlerSayfasiState();
}

class _DepremlerSayfasiState extends State<DepremlerSayfasi> {
  late Future<List<Deprem>> futureDepremler;

  @override
  void initState() {
    super.initState();
    futureDepremler = DepremService.fetchDepremler();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Son Depremler',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        elevation: 0,
      ),
      body: FutureBuilder<List<Deprem>>(
        future: futureDepremler,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 16),
                  Text(
                    'Deprem verileri yükleniyor...',
                    style: TextStyle(color: Colors.teal[700]),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Veri alınırken hata oluştu:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: Text('Tekrar Dene'),
                    onPressed: () {
                      setState(() {
                        futureDepremler = DepremService.fetchDepremler();
                      });
                    },
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, color: Colors.teal, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Son 24 saat içinde deprem kaydedilmemiş',
                    style: TextStyle(fontSize: 16, color: Colors.teal[700]),
                  ),
                ],
              ),
            );
          }

          final depremler = snapshot.data!;
          return RefreshIndicator(
            color: Colors.teal,
            onRefresh: () async {
              setState(() {
                futureDepremler = DepremService.fetchDepremler();
              });
            },
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: depremler.length,
              itemBuilder: (context, index) {
                final deprem = depremler[index];
                return _buildDepremCard(deprem);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDepremCard(Deprem deprem) {
    // Büyüklüğe göre arkaplan rengi
    Color cardColor = _getCardColor(deprem.buyukluk);

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(12),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _getMagnitudeColor(deprem.buyukluk),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                deprem.buyukluk.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          title: Text(
            deprem.yer,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text('${deprem.tarih} • ${deprem.saat}'),
              SizedBox(height: 4),
              Text('Derinlik: ${deprem.derinlik} km'),
            ],
          ),
          trailing: Icon(
            deprem.buyukluk >= 4.0 ? Icons.warning_amber : Icons.info_outline,
            color: deprem.buyukluk >= 4.0 ? Colors.red : Colors.teal,
          ),
          onTap: () {
            // Detay sayfasına yönlendirme
          },
        ),
      ),
    );
  }

  Color _getCardColor(double buyukluk) {
    if (buyukluk >= 4.0) return Colors.red[100]!;
    if (buyukluk >= 3.0) return Colors.orange[100]!;
    return Colors.grey[100]!;
  }

  Color _getMagnitudeColor(double buyukluk) {
    if (buyukluk >= 5.0) return Colors.red;
    if (buyukluk >= 4.0) return Colors.orange;
    if (buyukluk >= 3.0) return Colors.amber;
    return Colors.teal;
  }
}
