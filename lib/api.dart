import 'dart:convert';

import 'package:http/http.dart' as http;

// GET semua artikel
Future<List<dynamic>> getPosts() async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/api/posts'),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 &&
      data['success'] == true) {
    return data['data'];
  }

  throw Exception(data['message']);
}

// GET detail artikel
Future<dynamic> getPostById(int id) async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/api/posts/$id'),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 &&
      data['success'] == true) {
    return data['data'];
  }

  throw Exception(data['message']);
}

// TAMBAH ARTIKEL
Future<void> createPost(
  String judul,
  String isi,
  String gambar,
  String kategori,
) async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/api/posts'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'judul': judul,
      'isi': isi,
      'gambar': gambar,
      'kategori': kategori,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode != 201 ||
      data['success'] != true) {
    throw Exception(data['message']);
  }
}

// EDIT ARTIKEL
Future<void> updatePost(
  int id,
  String judul,
  String isi,
  String gambar,
  String kategori,
) async {
  final response = await http.put(
    Uri.parse('http://localhost:3000/api/posts/$id'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'judul': judul,
      'isi': isi,
      'gambar': gambar,
      'kategori': kategori,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode != 200 ||
      data['success'] != true) {
    throw Exception(data['message']);
  }
}

// HAPUS ARTIKEL
Future<void> deletePost(int id) async {
  final response = await http.delete(
    Uri.parse('http://localhost:3000/api/posts/$id'),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode != 200 ||
      data['success'] != true) {
    throw Exception(data['message']);
  }
}