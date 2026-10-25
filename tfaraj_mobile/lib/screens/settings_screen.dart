import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const SettingsScreen({super.key, required this.onLanguageChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = true;
  bool _isAdBlock = false;
  String _currentLang = 'ar';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getString('tfaraj_theme') != 'light';
      _isAdBlock = prefs.getBool('tfaraj_adblock') ?? false;
      _currentLang = prefs.getString('tfaraj_lang') ?? 'ar';
    });
  }

  Future<void> _toggleTheme(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tfaraj_theme', val ? 'dark' : 'light');
    setState(() => _isDarkMode = val);
  }

  Future<void> _toggleAdBlock(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tfaraj_adblock', val);
    setState(() => _isAdBlock = val);
  }

  Future<void> _changeLanguage(String? lang) async {
    if (lang == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tfaraj_lang', lang);
    setState(() => _currentLang = lang);
    widget.onLanguageChanged(Locale(lang, lang == 'ar' ? 'SA' : 'US'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
            SwitchListTile(
              title: const Text('الوضع الداكن'),
              activeThumbColor: AppTheme.accentColor,
              value: _isDarkMode,
              onChanged: _toggleTheme,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('مانع الإعلانات والنوافذ المنبثقة'),
              activeThumbColor: AppTheme.accentColor,
              value: _isAdBlock,
              onChanged: _toggleAdBlock,
            ),
            const Divider(),
            ListTile(
              title: const Text('لغة التطبيق'),
              trailing: DropdownButton<String>(
                dropdownColor: Colors.grey[900],
                value: _currentLang,
                items: const [
                  DropdownMenuItem(value: 'ar', child: Text('🇸🇦 العربية')),
                  DropdownMenuItem(value: 'en', child: Text('🇬🇧 English')),
                ],
                onChanged: _changeLanguage,
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('حول التطبيق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text('تطبيق عصري لمشاهدة المحتوى السينمائي بدقة عالية وسرعة فائقة.', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 12),
                Text('برمجة وتصميم', style: TextStyle(color: Colors.white38, fontSize: 12)),
                Text('Lefreid Khalil', style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
