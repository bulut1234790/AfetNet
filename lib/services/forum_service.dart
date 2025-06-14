import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forum_post.dart';
import 'package:shared_preferences/shared_preferences.dart'; // küçük veri parçalarını (kullanıcı ayarları, oturum bilgileri) saklamayı sağlayan kütüphane

class ForumService {
  static Future<List<ForumPost>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/afetnet-backend/forum/forum.php'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ForumPost.fromJson(json)).toList();
    } else {
      throw Exception("Veriler alınamadı");
    }
  }

  static Future<void> addPost(
    String baslik,
    String icerik,
    String kategori,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final int? kullaniciIdFromPrefs = prefs.getInt('user_id');

    final int kullaniciId =
        kullaniciIdFromPrefs ?? 999; // Test amaçlı varsayılan ID

    // Debug çıktıları ekliyoruz
    print('ForumService: Gönderilecek Kullanıcı ID: $kullaniciId');
    print('ForumService: Gönderilecek Başlık: $baslik');
    print(
      'ForumService: Gönderilecek İçerik (ilk 50 karakter): ${icerik.substring(0, icerik.length > 50 ? 50 : icerik.length)}...',
    );
    print('ForumService: Gönderilecek Kategori: $kategori');

    final url = Uri.parse('http://10.0.2.2/afetnet-backend/forum/forum.php');
    print('ForumService: Hedef URL: $url');

    final bodyData = json.encode({
      // JSON formatında kodlama
      'kullanici_id': kullaniciId,
      'baslik': baslik,
      'icerik': icerik,
      'kategori': kategori,
    });
    print('ForumService: Gönderilecek JSON Body: $bodyData');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        }, // Content-Type başlığı burada
        body: bodyData, // Kodlanmış JSON body'yi gönderiyoruz
      );

      print('ForumService: Sunucu Yanıt Kodu: ${response.statusCode}');
      print('ForumService: Sunucu Yanıtı: ${response.body}');

      if (response.statusCode == 201) {
        print("Gönderi başarıyla eklendi.");
      } else {
        throw Exception(
          'Gönderi eklenirken hata oluştu. Sunucu kodu: ${response.statusCode}, Yanıt: ${response.body}',
        );
      }
    } catch (e) {
      print('ForumService: HTTP isteği sırasında hata oluştu: $e');
      rethrow;
    }
  }
}
