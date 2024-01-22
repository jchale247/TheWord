import React from 'react';
import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View, PixelRatio} from 'react-native';
import VerseTitle from './components/VerseTitle.js'
import Verse from './components/Verse.js'

const fontScale = PixelRatio.getFontScale();
const getFontSize = size => size / fontScale;

export default function App() {
  return (
    <View style={styles.container}>
      <VerseTitle info={{title: 'John 3:16 NIV'}}/>
      <Verse info={{verse: 'For God so loved the world that he gave his...', verseNum: '16'}}/>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0047AB',
    opacity: '0.8',
    backgroundImage: 'radial-gradient(circle at center center, #6F8FAF, #0047AB), repeating-radial-gradient(circle at center center, #6F8FAF, #6F8FAF, 10px, transparent 20px, transparent 10px)',
    backgroundBlendMode: 'multiply',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
