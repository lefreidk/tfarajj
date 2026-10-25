class MediaModel {
  final String id;
  final String title;
  final String category;
  final String rating;
  final String year;
  final String poster;
  final String description;
  final String type; // 'movies', 'series', 'anime'
  final int views;

  MediaModel({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.year,
    required this.poster,
    required this.description,
    this.type = 'movies',
    this.views = 0,
  });

  // Effective poster URL matching web logic:
  // posterUrl = item.poster ? item.poster : 'https://img.omdbapi.com/?i=' + item.id + '&apikey=trilogy';
  String get effectivePosterUrl {
    if (poster.trim().isNotEmpty) {
      return poster.trim();
    }
    if (id.startsWith('tt')) {
      return 'https://img.omdbapi.com/?i=$id&apikey=trilogy';
    }
    return '';
  }

  // Stream URL matching web logic:
  // player.src = 'https://streamimdb.ru/embed/tv/' + item.id + '/';
  String get streamUrl {
    return 'https://streamimdb.ru/embed/tv/$id/';
  }

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      category: (map['category'] ?? 'عام').toString(),
      rating: (map['rating'] ?? 'N/A').toString(),
      year: (map['year'] ?? '').toString(),
      poster: (map['poster'] ?? '').toString(),
      description: (map['description'] ?? 'لم يتم إضافة وصف توضيحي لهذا العمل بعد، مشاهدة ممتعة.').toString(),
      type: (map['type'] ?? 'movies').toString(),
      views: map['views'] is int ? map['views'] : int.tryParse(map['views']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'rating': rating,
      'year': year,
      'poster': poster,
      'description': description,
      'type': type,
      'views': views,
    };
  }
}
