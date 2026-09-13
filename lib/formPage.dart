import 'package:flutter/material.dart';

import 'api.dart';

class FormPage extends StatefulWidget {
  final int? id;
  final String? judulLama;
  final String? isiLama;
  final String? gambarLama;
  final String? kategoriLama;

  const FormPage({
    super.key,
    this.id,
    this.judulLama,
    this.isiLama,
    this.gambarLama,
    this.kategoriLama,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final judulController = TextEditingController();
  final isiController = TextEditingController();
  final gambarController = TextEditingController();
  final kategoriController = TextEditingController();

  bool isLoading = false;

  bool get modeEdit {
    return widget.id != null;
  }

  @override
  void initState() {
    super.initState();

    judulController.text = widget.judulLama ?? '';
    isiController.text = widget.isiLama ?? '';
    gambarController.text = widget.gambarLama ?? '';
    kategoriController.text =
        widget.kategoriLama ?? '';
  }

  Future<void> simpanArtikel() async {
    if (judulController.text.isEmpty ||
        isiController.text.isEmpty ||
        gambarController.text.isEmpty ||
        kategoriController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data wajib diisi'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (modeEdit) {
        await updatePost(
          widget.id!,
          judulController.text,
          isiController.text,
          gambarController.text,
          kategoriController.text,
        );
      } else {
        await createPost(
          judulController.text,
          isiController.text,
          gambarController.text,
          kategoriController.text,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            modeEdit
                ? 'Artikel berhasil diubah'
                : 'Artikel berhasil ditambahkan',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    judulController.dispose();
    isiController.dispose();
    gambarController.dispose();
    kategoriController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          modeEdit ? 'Edit Artikel' : 'Tambah Artikel',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText: 'Judul Artikel',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: kategoriController,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: gambarController,
              decoration: const InputDecoration(
                labelText: 'URL Gambar',
                hintText: 'https://contoh.com/gambar.jpg',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: isiController,
              maxLines: 7,
              decoration: const InputDecoration(
                labelText: 'Isi Artikel',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : simpanArtikel,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        modeEdit
                            ? 'Simpan Perubahan'
                            : 'Tambah Artikel',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}