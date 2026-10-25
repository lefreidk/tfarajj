import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/media_model.dart';

class MediaRepository {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Local static lists mirroring original web app data (movies.js, series.js, anime.js)
  static final List<MediaModel> staticMovies = [
    MediaModel(
      id: "tt13053580",
      title: "The Mandalorian & Grogu",
      category: "خيال علمي / مغامرة",
      rating: "N/A",
      year: "2026",
      poster: "",
      description: "مغامرة سينمائية ضخمة تجمع صائد الجوائز ماندو مع الطفل غروغو في مهمة عبر المجرة.",
      type: "movies",
    ),
    MediaModel(
      id: "tt0062622",
      title: "2001: A Space Odyssey",
      category: "خيال علمي / مغامرة",
      rating: "8.3",
      year: "1968",
      poster: "",
      description: "رحلة ملحمية عبر الفضاء والزمن تبدأ من فجر البشرية وصولاً إلى مستقبل غامض، حيث يكتشف طاقم مركبة فضائية سراً كونياً.",
      type: "movies",
    ),
    MediaModel(
      id: "tt21357150",
      title: "Avengers: Doomsday",
      category: "أكشن / خيال علمي",
      rating: "N/A",
      year: "2026",
      poster: "",
      description: "أكبر تجمع للمنتقمين لمواجهة تهديد كوني وجودي يهدد بتدمير كل الأكوان المتعددة.",
      type: "movies",
    ),
  ];

  static final List<MediaModel> staticSeries = [
    MediaModel(
      id: "tt0903747",
      title: "Breaking Bad",
      category: "جريمة / دراما",
      rating: "9.5",
      year: "2008",
      poster: "",
      description: "مدرس كيمياء يتحول إلى إنتاج الميث للسرطان بعد تشخيص إصابته بمرض عضال، في رحلة من التحول المظلم.",
      type: "series",
    ),
    MediaModel(
      id: "tt0944947",
      title: "Game of Thrones",
      category: "فانتازيا / دراما",
      rating: "9.2",
      year: "2011",
      poster: "",
      description: "عائلات نبيلة تتصارع للسيطرة على العرش الحديدي في عالم مهدد بالزحف الأبيض والشتاء القادم.",
      type: "series",
    ),
  ];

  static final List<MediaModel> staticAnime = [
    MediaModel(
      id: "tt0111161", // placeholder ID example
      title: "Attack on Titan / Shingeki no Kyojin",
      category: "أنمي / أكشن / دراما",
      rating: "9.1",
      year: "2013",
      poster: "",
      description: "بشرية تعيش خلف أسوار ضخمة حماية لها من عمالقة تاكل البشر، حتى يتقاطع مصير إيرين ييغر مع الحقيقة.",
      type: "anime",
    ),
  ];

  // Fetch all content (combined local + Firestore if available)
  static Future<Map<String, List<MediaModel>>> fetchAllContent() async {
    List<MediaModel> movies = List.from(staticMovies);
    List<MediaModel> series = List.from(staticSeries);
    List<MediaModel> anime = List.from(staticAnime);

    try {
      final snapshot = await _db.collection('content').get();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = data['id'] ?? doc.id;
        final media = MediaModel.fromMap(data);
        if (media.type == 'movies') {
          if (!movies.any((m) => m.id == media.id)) movies.add(media);
        } else if (media.type == 'series') {
          if (!series.any((s) => s.id == media.id)) series.add(media);
        } else if (media.type == 'anime') {
          if (!anime.any((a) => a.id == media.id)) anime.add(media);
        }
      }
    } catch (e) {
      // Offline / unconfigured fallback
    }

    return {
      'movies': movies,
      'series': series,
      'anime': anime,
    };
  }

  // Favorites local persistence via SharedPreferences
  static Future<List<MediaModel>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favsString = prefs.getString('tfaraj_favs');
      if (favsString == null) return [];
      final List<dynamic> decoded = jsonDecode(favsString);
      return decoded.map((item) => MediaModel.fromMap(item)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> toggleFavorite(MediaModel media) async {
    final prefs = await SharedPreferences.getInstance();
    List<MediaModel> favs = await getFavorites();
    final index = favs.indexWhere((item) => item.id == media.id);
    if (index >= 0) {
      favs.removeAt(index);
    } else {
      favs.add(media);
    }
    await prefs.setString(
      'tfaraj_favs',
      jsonEncode(favs.map((i) => i.toMap()).toList()),
    );
  }

  static Future<bool> isFavorite(String id) async {
    final favs = await getFavorites();
    return favs.any((item) => item.id == id);
  }
}
