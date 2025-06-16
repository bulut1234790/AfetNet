class ForumComment {
  final int id;
  final int postId;
  final int userId;
  final String username; // Yorumu yapan kullanıcının adı
  final String content;
  final DateTime dateTime;

  ForumComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.content,
    required this.dateTime,
  });

  factory ForumComment.fromJson(Map<String, dynamic> json) {
    return ForumComment(
      id: json['id'],
      postId: json['post_id'],
      userId: json['kullanici_id'],
      username: json['kullanici_adi'], 
      content: json['icerik'],
      dateTime: DateTime.parse(json['tarih_saat']),
    );
  }
}