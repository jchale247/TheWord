import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TheWord());
}

class TheWord extends StatelessWidget {
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'TheWord',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Color(0xFFFDFDFD),
            primarySwatch: Colors.indigo,
            textTheme: GoogleFonts.merriweatherTextTheme().apply(
              bodyColor: Colors.black87,
              displayColor: Colors.black87,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0.5,
            ),
            cardColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.grey[800]),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Color(0xFF121212),
            primarySwatch: Colors.indigo,
            textTheme: GoogleFonts.merriweatherTextTheme().apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
            ),
            cardColor: Color(0xFF1E1E1E),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          home: VerseScreen(
            onToggleTheme: () {
              _themeMode.value =
                  _themeMode.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
          ),
        );
      },
    );
  }
}

class VerseScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  VerseScreen({required this.onToggleTheme});

  @override
  _VerseScreenState createState() => _VerseScreenState();
}

class _VerseScreenState extends State<VerseScreen> {
  String _verseText = '';
  String _verseRef = '';
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _fetchVerse();
    _loadFavorites();
  }

  Future<void> _fetchVerse() async {
    try {
      final url = Uri.parse('https://labs.bible.org/api/?passage=votd');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = response.body;
        final regex = RegExp(r"<b>(.*?)<\/b>\s*(.*?)(?=<b>|$)", dotAll: true);
        final matches = regex.allMatches(body);

        List<String> refs = [];
        List<String> texts = [];

        for (final match in matches) {
          final ref = match.group(1)?.trim() ?? '';
          final text = match.group(2)?.trim() ?? '';
          if (ref.isNotEmpty && text.isNotEmpty) {
            refs.add(ref);
            texts.add(text);
          }
        }

        final verseText = texts
            .join('\n\n')
            .replaceAll(RegExp(r'[\s,.;:!?]+$'), '');
        final verseRef = refs.length == 1 ? refs.first : refs.join(' | ');

        setState(() {
          _verseRef = verseRef;
          _verseText = verseText;
        });

        // Push to Home Widget
        await HomeWidget.setAppGroupId('group.com.JCH.theword');
        await HomeWidget.saveWidgetData<String>('verseText', verseText);
        await HomeWidget.saveWidgetData<String>('verseRef', verseRef);
      } else {
        setState(() {
          _verseRef = '';
          _verseText = 'Failed to load verse.';
        });
      }
    } catch (e) {
      setState(() {
        _verseRef = '';
        _verseText = 'Error fetching verse: $e';
      });
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
  }

  String get _currentVerseKey => '${_verseRef.trim()} - ${_verseText.trim()}';
  bool get _isFavorite => _favorites.contains(_currentVerseKey);

  Future<void> _toggleFavorite() async {
    setState(() {
      if (_isFavorite) {
        _favorites.remove(_currentVerseKey);
      } else {
        _favorites.add(_currentVerseKey);
      }
    });
    await _saveFavorites();
  }

  Future<void> _removeFavorite(int index) async {
    if (index >= 0 && index < _favorites.length) {
      setState(() {
        _favorites.removeAt(index);
      });
      await _saveFavorites();
      Navigator.pop(context);
      _showFavorites();
    }
  }

  void _showFavorites() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                _favorites.isEmpty
                    ? Center(child: Text('No favorites yet.'))
                    : ListView.builder(
                      itemCount: _favorites.length,
                      itemBuilder:
                          (context, index) => Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(_favorites[index])),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => _removeFavorite(index),
                                ),
                              ],
                            ),
                          ),
                    ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subscriptColor =
        Theme.of(context).brightness == Brightness.light
            ? Colors.blue[600]
            : Colors.blue[400];

    final verseNumber = _verseRef.split(':').last;

    return Scaffold(
      appBar: AppBar(
        title: Text('TheWord'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchVerse,
            tooltip: "Refresh",
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _showFavorites,
            tooltip: "Show Favorites List",
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
            tooltip: "Toggle Theme",
          ),
        ],
      ),
      body: Center(
        child:
            _verseText.isEmpty
                ? CircularProgressIndicator()
                : Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.merriweather(
                              fontSize: 18,
                              height: 1.5,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                            children: [
                              TextSpan(
                                text: verseNumber,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subscriptColor,
                                  fontWeight: FontWeight.bold,
                                  height: 2,
                                  textBaseline: TextBaseline.alphabetic,
                                ),
                              ),
                              TextSpan(text: ' $_verseText'),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _verseRef,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: subscriptColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: IconButton(
                            key: ValueKey(_isFavorite),
                            icon: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.pinkAccent,
                              size: 28,
                            ),
                            onPressed: _toggleFavorite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
