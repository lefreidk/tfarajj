import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/media_model.dart';
import '../services/media_repository.dart';
import '../constants/app_theme.dart';

class DetailsScreen extends StatefulWidget {
  final MediaModel media;

  const DetailsScreen({super.key, required this.media});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isFav = false;
  late WebViewController _webViewController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
    _initController();
  }

  void _initController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.media.streamUrl));
  }

  Future<void> _checkFavorite() async {
    final fav = await MediaRepository.isFavorite(widget.media.id);
    setState(() => _isFav = fav);
  }

  Future<void> _toggleFav() async {
    await MediaRepository.toggleFavorite(widget.media);
    await _checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.media.effectivePosterUrl.isNotEmpty
                      ? Image.network(
                          widget.media.effectivePosterUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[900]),
                        )
                      : Container(color: Colors.grey[900]),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.media.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        widget.media.year,
                        style: const TextStyle(color: AppTheme.subtitleColor),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.media.category,
                        style: const TextStyle(color: AppTheme.subtitleColor),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.media.rating,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(
                        'مشاهدة الآن',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        setState(() => _isPlaying = true);
                      },
                    ),
                  ),
                  if (_isPlaying) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'مشغل الفيديو',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 220,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: WebViewWidget(controller: _webViewController),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'القصة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.media.description,
                    style: const TextStyle(
                      color: AppTheme.subtitleColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentColor,
        child: Icon(_isFav ? Icons.favorite : Icons.favorite_border, color: Colors.black),
        onPressed: _toggleFav,
      ),
    );
  }
}
