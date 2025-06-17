import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> kullaniciGuncelle({
  required String eskiKullaniciAdi,
  required String kullaniciAdi,
  required String ad,
  required String soyad,
  required String numara,
  required String sehir,
  required String eposta,
  required String sifre,
  required String yakin_no,
}) async {
  print("Fonksiyon başladı");

  Map<String, dynamic> jsonData = {
    "eski_kullanici_adi": eskiKullaniciAdi,
    "kullanici_adi": kullaniciAdi,
    "ad": ad,
    "soyad": soyad,
    "numara": numara,
    "sehir": sehir,
    "e_posta": eposta,
    "sifre": sifre,
    "yakin_no": yakin_no,
  };

  print("GÖNDERİLEN VERİ:");
  print(jsonData);

  var url = Uri.parse(
    'http://10.0.2.2/afetnet-backend/kullanici/update.php',
  );

  final body = jsonEncode(jsonData);

  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  print("Gönderilen veri: $body");
  print("Durum Kodu: ${response.statusCode}");
  print("Cevap: ${response.body}");

  if (response.statusCode == 200) {
    print("Gelen yanıt: ${response.body}");
    var sonuc = jsonDecode(response.body);
    if (sonuc['success'] != null) {
      print("✅ Güncelleme başarılı: ${sonuc['success']}");
    } else {
      print("❌ Hata: ${sonuc['error']}");
    }
  } else {
    print("Hata oluştu: ${response.statusCode}");
  }
}

//kullanıcı bilgisi için
Future<Map<String, dynamic>?> kullaniciBilgileriGetir(
  String kullaniciAdi,
) async {
  var url = Uri.parse(
    'http://10.0.2.2/afetnet-backend/kullanici/get.php?kullanici_adi=$kullaniciAdi',
  );

  var response = await http.get(url);

  print("Gelen veri: ${response.body}");

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data.containsKey('error')) {
      // Hata varsa null döndür
      return null;
    }
    return data;
  } else {
    return null;
  }
}
