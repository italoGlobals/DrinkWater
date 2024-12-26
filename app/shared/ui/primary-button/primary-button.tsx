import { ReactElement } from 'react';
import { StyleSheet, View } from 'react-native';

const PrimaryButton = (): ReactElement => {
  return (
    <View style={styles.container}>
      PrimaryButton Component
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default PrimaryButton;
