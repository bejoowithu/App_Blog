import 'package:flutter/material.dart';

import 'api.dart';
import 'detailPage.dart';

class HotBlogPage extends StatefulWidget {
  const HotBlogPage({super.key});

  @override
  State<HotBlogPage> createState() => _HotBlogPageState();
}

class _HotBlogPageState extends State<HotBlogPage> {
  late Future<List<dynamic>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
            ),
          );
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return const Center(
            child: Text('Belum ada hot blog'),
          );
        }

        final artikelUtama = posts.first;
        final artikelLain = posts.skip(1).toList();

        return ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                    size: 35,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Hot Blog',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Artikel Terbaru',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        article: artikelUtama,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      artikelUtama['gambar'] != null &&
                              artikelUtama['gambar']
                                  .toString()
                                  .isNotEmpty
                          ? artikelUtama['gambar']
                          : 'https://via.placeholder.com/300',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        artikelUtama['judul'] ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ...artikelLain.map(
              (article) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Image.network(
                      article['gambar'] != null &&
                              article['gambar']
                                  .toString()
                                  .isNotEmpty
                          ? article['gambar']
                          : 'https://via.placeholder.com/100',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      article['judul'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      article['kategori'] ?? '',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            article: article,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}