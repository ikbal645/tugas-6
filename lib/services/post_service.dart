import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  static const _baseUrl = 'jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final url = Uri.https(_baseUrl, '/posts');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat pengumuman (${response.statusCode}).');
    }


    final json = jsonDecode(response.body) as List<dynamic>;
    return json
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<PostComment>> fetchComments(int postId) async {
    final url = Uri.https(_baseUrl, '/posts/$postId/comments');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat komentar (${response.statusCode}).');
    }

    final json = jsonDecode(response.body) as List<dynamic>;
    return json
        .map((item) => PostComment.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Post> createPost({required String title, required String body}) async {
    final url = Uri.https(_baseUrl, '/posts');
    final response = await http.post(
      url,
      headers: const {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': title, 'body': body, 'userId': 1}),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal membuat pengumuman (${response.statusCode}).');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Post.fromJson(json);
  }
}
