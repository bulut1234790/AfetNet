import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/forum_comment.dart'; // Yeni yorum modelimizi import et

class CommentService {

  static const String BASE_URL = 'http://10.0.2.2/afetnet-backend/forum/comments.php'; 

  // Bir post'a ait yorumları çekme
  static Future<List<ForumComment>> fetchCommentsForPost(int postId) async {
    final url = Uri.parse('$BASE_URL?post_id=$postId');
    print('DEBUG: Yorumlar için gönderilen URL: $url'); // Yeni eklendi
    try {
      final response = await http.get(url);
      print('DEBUG: Yorumlar GET Response Status Code: ${response.statusCode}'); // Yeni eklendi
      print('DEBUG: Yorumlar GET Response Body: ${response.body}'); // Yeni eklendi

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        print('DEBUG: Yorumlar JSON decode sonrası: $data'); // Yeni eklendi
        List<ForumComment> comments = data.map((json) => ForumComment.fromJson(json)).toList();
        print('DEBUG: Toplam yüklenen yorum sayısı: ${comments.length}'); // Yeni eklendi
        return comments;
      } else {
        throw Exception("Yorumlar alınamadı: ${response.body}");
      }
    } catch (e) {
      print('DEBUG: Yorumları çekerken ağ/parsing hatası: $e'); // Yeni eklendi
      throw Exception("Yorumları çekerken bir hata oluştu: $e");
    }
  }

  // Yeni yorum ekleme (bu kısım zaten çalışıyorsa dokunmuyoruz, ancak buraya da debug eklemek iyi olurdu)
  static Future<void> addComment(int postId, String commentContent) async {
    final prefs = await SharedPreferences.getInstance();
    final int? kullaniciIdFromPrefs = prefs.getInt('user_id');

    final int kullaniciId = kullaniciIdFromPrefs ?? 3; // Varsayılan test kullanıcısı ID'si

    final bodyData = jsonEncode({
      'post_id': postId,
      'kullanici_id': kullaniciId,
      'icerik': commentContent,
    });

    print('DEBUG: Yorum ekleme için gönderilen veri: $bodyData'); // Yeni eklendi
    try {
      final response = await http.post(
        Uri.parse(BASE_URL),
        headers: {'Content-Type': 'application/json'},
        body: bodyData,
      );

      print('DEBUG: Yorum POST Response Status Code: ${response.statusCode}'); // Yeni eklendi
      print('DEBUG: Yorum POST Response Body: ${response.body}'); // Yeni eklendi

      if (response.statusCode == 201) {
        print('DEBUG: Yorum başarıyla eklendi'); // Mevcut print güncellendi
      } else {
        throw Exception('Yorum eklenirken hata oluştu: ${response.body}');
      }
    } catch (e) {
      print('DEBUG: Yorum eklerken ağ/istek hatası: $e'); // Yeni eklendi
      throw Exception("Yorum eklenirken bir hata oluştu: $e");
    }
  }
}