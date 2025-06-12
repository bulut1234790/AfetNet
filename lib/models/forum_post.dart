class ForumPost {
  final int id;
  final String username; // JSON'dan 'kullanici_adi' olarak geliyor
  final String content;
  final String header;
  final String category;
  final DateTime dateTime;

  ForumPost({
    required this.id,
    required this.username,
    required this.content,
    required this.header,
    required this.category,
    required this.dateTime,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'],
      username: json['kullanici_adi'],
      header: json["baslik"],
      content: json['icerik'],
      category: json['kategori'],
      dateTime: DateTime.parse(json['tarih_saat']),
    );
  }

  get commentCount => null;
}
