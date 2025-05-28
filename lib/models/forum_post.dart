class ForumPost {
  final String username;
  final String content;
  final String category;
  final DateTime dateTime;

  ForumPost({
    required this.username,
    required this.content,
    required this.category,
    required this.dateTime,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      username: json['username'],
      content: json['content'],
      category: json['category'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
