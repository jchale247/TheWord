import {Text, StyleSheet, PixelRatio} from 'react-native';

export default function VerseTitle({info}) {
	return (
		<Text style={styles.Text}>{info.title}</Text>
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
