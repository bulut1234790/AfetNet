import 'package:flutter/material.dart';
import '../models/forum_post.dart';
import 'package:afetnet/services/forum_service.dart';
import 'package:intl/intl.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  late Future<List<ForumPost>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = ForumService.fetchPosts();
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "deprem":
        return Colors.orange;
      case "yardım":
        return Colors.brown;
      case "acil":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum"),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: FutureBuilder<List<ForumPost>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '@${post.username}',
                            style: TextStyle(
                              backgroundColor: Colors.black12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14),
                              const SizedBox(width: 4),
                              Text(DateFormat('d MMM y').format(post.dateTime)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(post.content),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getCategoryColor(post.category),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              post.category,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14),
                              const SizedBox(width: 4),
                              Text(DateFormat('HH.mm').format(post.dateTime)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber),
            label: "Acil",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Yeni"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Bildirim",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
        ],
        selectedItemColor: Colors.brown,
      ),
    );
  }
}
