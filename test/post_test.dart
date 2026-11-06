import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_info/models/post.dart';

void main() {
  group('Post', () {
    test('parses JSON and serializes it back to JSON', () {
      final post = Post.fromJson({
        'id': 7,
        'userId': 3,
        'title': 'Info',
        'body': 'Pengumuman',
      });

      expect(post.id, 7);
      expect(post.userId, 3);
      expect(post.title, 'Info');
      expect(post.body, 'Pengumuman');
      expect(post.toJson(), {
        'id': 7,
        'userId': 3,
        'title': 'Info',
        'body': 'Pengumuman',
      });
    });
  });
}
