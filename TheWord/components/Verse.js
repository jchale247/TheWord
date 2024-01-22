import {Text, StyleSheet, PixelRatio} from 'react-native';

export default function Verse() {
	return (
		<Text style={styles.Text}><Text style={styles.SubScript}>16</Text>For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.</Text>
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
