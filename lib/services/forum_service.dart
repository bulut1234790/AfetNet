import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forum_post.dart';

class ForumService {
  static Future<List<ForumPost>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('http://localhost/afetnet-backend/forum/forum.php'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ForumPost.fromJson(json)).toList();
    } else {
      throw Exception("Veriler alınamadı");
    }
  }

  static Future<void> addPost(String baslik, String icerik, String kategori) async {
    final url = Uri.parse('http://localhost/afetnet-backend/forum/forum.php'); // 

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'kullanici_id': 1,  // Sabit değer; oturum sistemin varsa ona göre değiştir
        'baslik': baslik,
        'icerik': icerik,
        'kategori': kategori,
      }),
    );


  if (response.statusCode == 201) {
    print('Gönderi başarıyla eklendi');
  } else {
    print('Hata: ${response.body}');
  }
  }
}


