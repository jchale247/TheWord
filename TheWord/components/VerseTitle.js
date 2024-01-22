import {Text, StyleSheet, PixelRatio} from 'react-native';

export default function VerseTitle() {
	return (
		<Text style={styles.Text}>John 3:16 NIV</Text>
	);
}

const fontScale = PixelRatio.getFontScale();
const getFontSize = size => size / fontScale;


const styles = StyleSheet.create({
	Text: {
		color: 'white',
		fontSize: getFontSize(30),
		fontWeight: 'bold',
		fontFamily: 'Helvetica',
	},
});
