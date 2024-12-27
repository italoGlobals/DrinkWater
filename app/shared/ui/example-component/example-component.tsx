import { ReactElement } from 'react';
import { StyleSheet, Text, View } from 'react-native';

interface ExampleComponentProps {

};

const ExampleComponent = (): ReactElement => {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>
        ExampleComponent Component
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

export default ExampleComponent;

