import { ReactElement } from 'react';
import { StyleSheet, View } from 'react-native';

const {{PascalCaseName}} = (): ReactElement => {
  return (
    <View style={styles.container}>
      {{PascalCaseName}} Component
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default {{PascalCaseName}};
