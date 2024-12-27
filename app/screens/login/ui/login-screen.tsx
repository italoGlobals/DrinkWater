import PrimaryButton from '../../../shared/ui/primary-button/primary-button';
import { ReactElement } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { RootStackParamList, SCREENS } from '../../../App';
import { MaterialIcons } from '@expo/vector-icons';

type LoginScreenNavigationProp = StackNavigationProp<RootStackParamList, 'LOGIN'>;

interface LoginProps {
  navigation: LoginScreenNavigationProp;
}

const Login = ({ navigation }: LoginProps): ReactElement => {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>Login Screen</Text>
      <PrimaryButton
        onPress={() => navigation.navigate(SCREENS.HOME)}
        text="Go to Home"
        loading={false}
        disabled={false}
        icon={<MaterialIcons name="home" size={24} color="white" />}
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

export default Login;
