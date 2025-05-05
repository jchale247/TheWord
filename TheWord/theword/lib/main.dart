import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(BibleVerseApp());
}

class BibleVerseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible Verse App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: VerseScreen(),
    );
  }
}

class VerseScreen extends StatefulWidget {
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
    final url = Uri.parse('https://labs.bible.org/api/?passage=votd&type=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = response.body;
      final regex = RegExp(r"<b>(.*?)<\/b>\s*(.*)");
      final match = regex.firstMatch(body);

      if (match != null) {
        setState(() {
          _verseRef = match.group(1)!;
          _verseText = match.group(2)!;
        });
      } else {
        setState(() {
          _verseRef = 'Unknown';
          _verseText = body.trim();
        });
      }
    } else {
      setState(() {
        _verseRef = '';
        _verseText = 'Failed to load verse.';
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

  String get _currentVerseKey => '$_verseRef - $_verseText';

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

  // Updated remove method with validation
  Future<void> _removeFavorite(int index) async {
  if (index >= 0 && index < _favorites.length) {
    setState(() {
      _favorites.removeAt(index);
    });
    await _saveFavorites();
    Navigator.pop(context); // Close the modal immediately after removing the verse
    _showFavorites(); // Reopen the modal to reflect the updated list
  }
}

  void _showFavorites() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_favorites[index]),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _removeFavorite(index), // Remove item and update live
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Bible Verse'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _showFavorites,
          )
        ],
      ),
      body: Center(
        child: _verseText.isEmpty
            ? CircularProgressIndicator()
            : Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _verseText,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        _verseRef,
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: _toggleFavorite,
                          ),
                          ElevatedButton(
                            onPressed: _fetchVerse,
                            child: Text('New Verse'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
