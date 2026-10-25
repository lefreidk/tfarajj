import 'package:flutter_test/flutter_test.dart';
import 'package:tfaraj_mobile/models/media_model.dart';

void main() {
  group('MediaModel Tests', () {
    test('MediaModel.fromMap parses valid data correctly', () {
      final map = {
        'id': 'tt1234567',
        'title': 'Test Movie',
        'category': 'Action',
        'rating': '8.5',
        'year': '2024',
        'poster': 'https://example.com/poster.jpg',
        'description': 'A great test movie.',
        'type': 'movies',
        'views': 10,
      };

      final media = MediaModel.fromMap(map);

      expect(media.id, 'tt1234567');
      expect(media.title, 'Test Movie');
      expect(media.category, 'Action');
      expect(media.rating, '8.5');
      expect(media.year, '2024');
      expect(media.effectivePosterUrl, 'https://example.com/poster.jpg');
      expect(media.streamUrl, 'https://streamimdb.ru/embed/tv/tt1234567/');
      expect(media.views, 10);
    });

    test('MediaModel.fromMap handles missing/null fields gracefully', () {
      final map = <String, dynamic>{};

      final media = MediaModel.fromMap(map);

      expect(media.id, '');
      expect(media.title, '');
      expect(media.category, 'عام');
      expect(media.rating, 'N/A');
      expect(media.year, '');
      expect(media.effectivePosterUrl, '');
      expect(media.description, 'لم يتم إضافة وصف توضيحي لهذا العمل بعد، مشاهدة ممتعة.');
      expect(media.views, 0);
    });

    test('OMDB fallback poster generation for tt IDs', () {
      final media = MediaModel(
        id: 'tt0062622',
        title: 'Space Odyssey',
        category: 'Sci-Fi',
        rating: '8.3',
        year: '1968',
        poster: '',
        description: 'Epic journey',
      );

      expect(media.effectivePosterUrl, 'https://img.omdbapi.com/?i=tt0062622&apikey=trilogy');
    });
  });
}
