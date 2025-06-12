import 'package:afetnet/models/depremm.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:charset_converter/charset_converter.dart'; // ← yeni eklendi

class DepremService {
  static Future<List<Deprem>> fetchDepremler() async {
    final response = await http.get(
      Uri.parse('http://localhost/afetnet-backend/sondeprem/fetch_deprem.php'),
    );
    // Uri.parse('http://10.0.2.2/afetnet-backend/sondeprem/fetch_deprem.php

    if (response.statusCode == 200) {
      // ISO-8859-9 çözümlemesi
      final decodedBody = await CharsetConverter.decode(
        "iso-8859-9",
        response.bodyBytes,
      );
      Document document = parse(decodedBody);

      final preTag = document.getElementsByTagName('pre');

      if (preTag.isNotEmpty) {
        final lines = preTag.first.text.trim().split('\n');
        final dataLines =
            lines
                .skipWhile((line) => !line.contains(RegExp(r'\d{4}\.\d{2}')))
                .toList();

        return dataLines
            .map((line) {
              final parts = line.trim().split(RegExp(r'\s+'));
              if (parts.length < 7) return null;

              final double? buyukluk = double.tryParse(parts[6]);
              if (buyukluk == null) return null;

              return Deprem(
                tarih: parts[0],
                saat: parts[1],
                enlem: parts[2],
                boylam: parts[3],
                derinlik: parts[4],
                buyukluk: buyukluk,
                yer: parts.sublist(7).join(' '),
              );
            })
            .whereType<Deprem>()
            .toList();
      }
    }

    throw Exception('Veriler alınamadı');
  }
}
