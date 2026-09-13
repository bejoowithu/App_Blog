import 'package:flutter/material.dart';

import 'api.dart';
import 'formPage.dart';

class DetailPage extends StatefulWidget {
  final dynamic article;

  const DetailPage({
    super.key,
    required this.article,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late dynamic article;

  @override
  void initState() {
    super.initState();
    article = widget.article;
  }

  Future<void> editArtikel() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(
          id: article['id'],
          judulLama: article['judul'],
          isiLama: article['isi'],
          gambarLama: article['gambar'],
          kategoriLama: article['kategori'],
        ),
      ),
    );

    if (result == true) {
      final data = await getPostById(article['id']);

      setState(() {
        article = data;
      });
    }
  }

  Future<void> hapusArtikel() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Artikel'),
          content: const Text(
            'Yakin ingin menghapus artikel ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (yakin != true) return;

    try {
      await deletePost(article['id']);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Artikel berhasil dihapus'),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Artikel'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: editArtikel,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: hapusArtikel,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Image.network(
              article['gambar'] != null &&
                      article['gambar']
                          .toString()
                          .isNotEmpty
                  ? article['gambar']
                  : 'https://via.placeholder.com/300',
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    article['kategori'] ?? '',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    article['judul'] ?? '',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    article['isi'] ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}