import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View, PixelRatio} from 'react-native';

const fontScale = PixelRatio.getFontScale();
const getFontSize = size => size / fontScale;

export default function App() {
  return (
    <View style={styles.container}>
      <Text style={styles.titleText}>John 3:16 NIV</Text>
      <Text style={styles.baseText}><Text style={styles.subScript}>16</Text>For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.</Text>
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
  titleText: {
    fontSize: getFontSize(30),
    color: 'white',
    fontWeight: 'bold',
    fontFamily: 'Helvetica',
  },
  baseText: {
    color: 'white',
    paddingTop: '5%',
    fontFamily: 'Helvetica',
    fontWeight: '400',
    textAlign: 'center',
    fontSize: getFontSize(24),
    paddingLeft: '5%',
    paddingRight: '5%',
    position: 'flex',
  },
  subScript: {
    color: 'white',
    fontFamily: 'Helvetica',
    fontWeight: '400',
    textAlign: 'center',
    fontSize: getFontSize(14),
  }
});
