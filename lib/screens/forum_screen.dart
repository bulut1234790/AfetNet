import 'package:afetnet/screens/fener.dart';
import 'package:afetnet/screens/menu.dart';
import 'package:afetnet/screens/profile_screen.dart';
import 'package:afetnet/screens/pusula.dart';
import 'package:afetnet/screens/settings.dart';
import 'package:afetnet/screens/sondepremler.dart';
import 'package:flutter/material.dart';
import '../models/forum_post.dart';
import 'package:afetnet/services/forum_service.dart';
import 'package:intl/intl.dart';
import 'package:afetnet/services/comment_service.dart';
import '../models/forum_comment.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  late Future<List<ForumPost>> futurePosts;
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String? _selectedCategory;

  ForumPost? _selectedPost;

  late Future<List<ForumComment>> futureComments; // Yorumları tutacak Future

  @override
  void initState() {
    super.initState();
    _loadPosts();
    futureComments = Future.value([]);
  }

  void _loadPosts() {
    setState(() {
      futurePosts = ForumService.fetchPosts();
    });
  }

  // Seçilen bir post'un yorumlarını yükleme metodu
  void _loadCommentsForPost(int postId) {
    setState(() {
      futureComments = CommentService.fetchCommentsForPost(postId);
    });
  }

  void _addComment() async {
    if (_selectedPost == null || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Yorum eklemek için bir gönderi seçmeli ve yorum girmelisiniz.',
          ),
        ),
      );
      return;
    }

    try {
      await CommentService.addComment(
        _selectedPost!.id,
        _commentController.text,
      );
      _commentController
          .clear(); // Yorum gönderildikten sonra metin kutusunu temizle
      _loadCommentsForPost(_selectedPost!.id); // Yorumları yenile
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Yorum başarıyla eklendi!')));
    } catch (e) {
      print('DEBUG: Yorum eklerken hata: $e'); // Hata konsola yazdır
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yorum eklenirken bir hata oluştu: ${e.toString()}'),
        ),
      );
    }
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "deprem":
        return Colors.orange.shade700;
      case "yardım":
        return Colors.brown.shade600;
      case "acil":
        return Colors.red.shade700;
      case "bilgi":
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  void _showPostDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Yeni Gönderi',
              style: TextStyle(color: Colors.brown),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _headerController,
                  decoration: InputDecoration(
                    labelText: 'Başlık',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLength: 100,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'İçerik',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  items:
                      ['Deprem', 'Yardım', 'Acil', 'Bilgi']
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final baslik = _headerController.text.trim();
                  final icerik = _contentController.text.trim();
                  final kategori = _selectedCategory;

                  if (baslik.isEmpty || icerik.isEmpty || kategori == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
                    );
                    return;
                  }
                  try {
                    await ForumService.addPost(baslik, icerik, kategori);
                    Navigator.pop(context);
                    _loadPosts();
                    _contentController.clear();
                    _headerController.clear();
                  } catch (e) {
                    print('Hata oluştu: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gönderi başarısız oldu.')),
                    );
                  }

                  _loadPosts();
                },
                child: const Text(
                  'Gönder',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
    );
  }

  void _showPostDetail(ForumPost post) {
    setState(() {
      _selectedPost = post;

      futureComments = Future.value([]);
      _loadCommentsForPost(post.id);
    });
  }

  void _closePostDetail() {
    setState(() {
      _selectedPost = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AfetNet Forum",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.brown.shade400,
        centerTitle: true,
        elevation: 4,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<ForumPost>>(
            future: futurePosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.brown),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Hata: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        onPressed: _loadPosts,
                        child: const Text(
                          "Tekrar Dene",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final posts = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return GestureDetector(
                    onTap: () => _showPostDetail(post),
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  backgroundColor: Colors.brown.shade100,
                                  label: Text(
                                    '@${post.username}',
                                    style: TextStyle(
                                      color: Colors.brown.shade800,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat(
                                        'd MMM y',
                                      ).format(post.dateTime),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              post.header,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              post.content,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getCategoryColor(post.category),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    post.category.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('HH:mm').format(post.dateTime),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.comment,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${post.commentCount}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (_selectedPost != null) ...[
            Positioned.fill(child: Container(color: Colors.black54)),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '@${_selectedPost!.username}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade800,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: _closePostDetail,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _selectedPost!.header,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _selectedPost!.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Yorumlar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Yorum listesi buraya gelecek -> FutureBuilder ekliyoruz!
                            SizedBox(
                              height:
                                  200, // Yorum listesi için sabit bir yükseklik verin
                              child: FutureBuilder<List<ForumComment>>(
                                future:
                                    futureComments, // _loadCommentsForPost ile güncellenen futureComments
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    print(
                                      'DEBUG: Yorumlar yükleniyor (Waiting state)',
                                    );
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    print(
                                      'DEBUG: Yorumları yüklerken hata oluştu: ${snapshot.error}',
                                    );
                                    return Center(
                                      child: Text(
                                        'Yorumlar yüklenirken hata oluştu: ${snapshot.error}',
                                      ),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    print(
                                      'DEBUG: Yorum verisi yok veya boş. HasData: ${snapshot.hasData}, Data Empty: ${snapshot.data?.isEmpty}',
                                    );
                                    return const Center(
                                      child: Text('Henüz yorum yok.'),
                                    );
                                  } else {
                                    print(
                                      'DEBUG: Yorumlar başarıyla yüklendi, liste hazırlanıyor. Yorum sayısı: ${snapshot.data!.length}',
                                    );
                                    return ListView.builder(
                                      shrinkWrap:
                                          true, // Listeyi içindeki içeriğe göre küçült
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final comment = snapshot.data![index];
                                        return Card(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  comment.username,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(comment.content),
                                                Text(
                                                  DateFormat(
                                                    'dd/MM/yyyy HH:mm',
                                                  ).format(comment.dateTime),
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: 'Yorum yaz...',
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.brown,
                                  ),
                                  onPressed: () {
                                    _addComment();
                                    _commentController.clear();
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Yorum listesi buraya gelecek
                            const Center(child: Text('Henüz yorum yok')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPostDialog,
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Forum sekmesi aktif
        selectedItemColor: Colors.brown.shade800,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MenuSayfasi()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DepremlerSayfasi()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Menü"),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: "Son Depremler",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: "Forum"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    _headerController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}
