import {Text, StyleSheet, PixelRatio} from 'react-native';

export default function Verse({info}) {
	return (
		<Text style={styles.Text}><Text style={styles.SubScript}>{info.verseNum}</Text>{info.verse}</Text>
	);
}

const fontScale = PixelRatio.getFontScale();
const getFontSize = size => size / fontScale;


const styles = StyleSheet.create({
	Text: {
		color: 'white',
		paddingTop: '5%',
		paddingLeft: '5%',
		paddingRight: '5%',
		position: 'flex',
		textAlight: 'center',
		fontSize: getFontSize(24),
		fontWeight: '400',
		fontFamily: 'Helvetica',
	},
	SubScript: {
		color: 'white',
		fontFamily: 'Helvetica',
		fontWeight: '400',
		textAlight: 'center',
		fontSize: getFontSize(14),
	},
});
