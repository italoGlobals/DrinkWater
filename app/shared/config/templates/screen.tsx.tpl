import { ReactElement } from 'react';
import { StyleSheet, Text, View } from 'react-native';

interface {{PascalCaseName}}Props {

};

const {{PascalCaseName}} = (): ReactElement => {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>
        {{PascalCaseName}} Screen
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  text: {
    fontSize: 20,
    textAlign: 'center',
  },
});

export default {{PascalCaseName}};
