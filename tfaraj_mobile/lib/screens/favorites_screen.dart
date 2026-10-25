import 'package:flutter/material.dart';
import '../models/media_model.dart';
import '../services/media_repository.dart';
import '../widgets/media_card.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<MediaModel> _favs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    setState(() => _isLoading = true);
    final list = await MediaRepository.getFavorites();
    setState(() {
      _favs = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمتي المفضلة'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favs.isEmpty
              ? const Center(
                  child: Text(
                    'لم تقم بإضافة أي محتوى لمفضلتك بعد',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _favs.length,
                  itemBuilder: (context, index) {
                    final item = _favs[index];
                    return MediaCard(
                      media: item,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(media: item),
                          ),
                        );
                        _loadFavs();
                      },
                    );
                  },
                ),
    );
  }
}
