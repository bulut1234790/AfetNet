class ForumPost {
  final int id;
  final String username;
  final String content;
  final String category;
  final DateTime dateTime;

  ForumPost({
    required this.id,
    required this.username,
    required this.content,
    required this.category,
    required this.dateTime,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: int.parse(json['id']),
      username: json['username'],
      content: json['icerik'],
      category: json['kategori'],
      dateTime: DateTime.parse(json['tarih_saat']),
    );
  }
}
