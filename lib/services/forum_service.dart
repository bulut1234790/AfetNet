import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forum_post.dart';

class ForumService {
  static Future<List<ForumPost>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://seninapi.com/forum'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ForumPost.fromJson(json)).toList();
    } else {
      throw Exception("Veriler alınamadı");
    }
  }
}
