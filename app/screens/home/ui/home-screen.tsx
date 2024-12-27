import PrimaryButton from '../../../shared/ui/primary-button/primary-button';
import { ReactElement } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { RootStackParamList, SCREENS } from '../../../App';
import { MaterialIcons } from '@expo/vector-icons';

type HomeScreenNavigationProp = StackNavigationProp<RootStackParamList, 'HOME'>;

interface HomeProps {
  navigation: HomeScreenNavigationProp;
}

const Home = ({ navigation }: HomeProps): ReactElement => {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>Home Screen</Text>
      <PrimaryButton
        onPress={() => navigation.navigate(SCREENS.LOGIN, { userId: '1234' })}
        text="Go to Login"
        loading={false}
        disabled={false}
        icon={<MaterialIcons name="login" size={24} color="white" />}
        iconPosition="left"
        onLongPress={() => console.log('Long press triggered!')}
      />
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
    marginBottom: 20,
  },
});

export default Home;
