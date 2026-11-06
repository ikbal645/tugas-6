import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.post});

  final Post post;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _postService = PostService();
  late Future<List<PostComment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _postService.fetchComments(widget.post.id);
  }

  void _reloadComments() {
    setState(() {
      _commentsFuture = _postService.fetchComments(widget.post.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengumuman')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(post.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          Text('Komentar', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          FutureBuilder<List<PostComment>>(
            future: _commentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tidak dapat memuat komentar.\n${snapshot.error}'),
                    TextButton(
                      onPressed: _reloadComments,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                );
              }

              final comments = snapshot.data ?? const <PostComment>[];
              if (comments.isEmpty) {
                return const Text('Belum ada komentar.');
              }

              return Column(
                children: [
                  for (final comment in comments)
                    Card(
                      child: ListTile(
                        title: Text(comment.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment.email),
                            const SizedBox(height: 8),
                            Text(comment.body),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
