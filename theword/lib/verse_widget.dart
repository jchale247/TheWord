import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  runApp(VerseWidgetApp());
}

class VerseWidgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verse Widget',
      home: Container(), // No UI needed for the main widget app
    );
  }
}

class VerseWidget extends StatelessWidget {
  final String verseText;
  final String verseRef;

  VerseWidget({required this.verseText, required this.verseRef});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Verse number as superscript
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 18, color: Colors.black),
              children: [
                TextSpan(
                  text: verseRef.split(":").last, // Extract the verse number
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    height: 2,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
                TextSpan(text: ' $verseText'),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            verseRef,
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
