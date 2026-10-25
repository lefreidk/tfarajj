import 'package:flutter/material.dart';
import '../models/media_model.dart';
import '../services/media_repository.dart';
import '../widgets/media_card.dart';
import '../constants/app_theme.dart';
import 'details_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const HomeScreen({super.key, required this.onLanguageChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  List<MediaModel> _movies = [];
  List<MediaModel> _series = [];
  List<MediaModel> _anime = [];
  List<MediaModel> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await MediaRepository.fetchAllContent();
    setState(() {
      _movies = data['movies'] ?? [];
      _series = data['series'] ?? [];
      _anime = data['anime'] ?? [];
      _isLoading = false;
    });
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    final all = [..._movies, ..._series, ..._anime];
    final results = all.where((item) => item.title.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeTab(),
      _buildGridTab(_movies, 'أفلام سينمائية'),
      _buildGridTab(_series, 'مسلسلات تلفزيونية'),
      _buildGridTab(_anime, 'أنمي'),
      const FavoritesScreen(),
      SettingsScreen(onLanguageChanged: widget.onLanguageChanged),
    ];

    return Scaffold(
      appBar: _selectedIndex == 5 ? null : AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Text(
          'TFARAJ | تفرج',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppTheme.accentColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'ابحث عن فيلم أو مسلسل...',
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
          : _isSearching
              ? _buildSearchResults()
              : pages[_selectedIndex > 4 ? 4 : _selectedIndex], // handle index mapping if needed
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 4 ? 4 : _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.primaryColor,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: Colors.white54,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          const BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'أفلام'),
          const BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'مسلسلات'),
          const BottomNavigationBarItem(icon: Icon(Icons.animation), label: 'أنمي'),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'المفضلة'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🔥 أفلام مميزة'),
            _buildHorizontalGrid(_movies),
            _buildSectionTitle('📺 أحدث المسلسلات'),
            _buildHorizontalGrid(_series),
            _buildSectionTitle('🎎 أقوى الأنميات'),
            _buildHorizontalGrid(_anime),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTab(List<MediaModel> items, String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title), automaticallyImplyLeading: false),
      body: items.isEmpty
          ? const Center(child: Text('لا توجد عناصر حالياً'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => MediaCard(
                media: items[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsScreen(media: items[index])),
                ),
              ),
            ),
    );
  }

  Widget _buildSearchResults() {
    return _searchResults.isEmpty
        ? const Center(child: Text('لا توجد نتائج مطابقة لبحثك'))
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) => MediaCard(
              media: _searchResults[index],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailsScreen(media: _searchResults[index])),
              ),
            ),
          );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHorizontalGrid(List<MediaModel> items) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => SizedBox(
          width: 140,
          child: MediaCard(
            media: items[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsScreen(media: items[index])),
            ),
          ),
        ),
      ),
    );
  }
}
