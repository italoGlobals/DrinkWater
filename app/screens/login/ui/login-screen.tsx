import PrimaryButton from '../../../shared/ui/primary-button/primary-button';
import Container from '../../../shared/ui/container/container';
import { ReactElement } from 'react';
import { StyleSheet, Text } from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { MaterialIcons } from '@expo/vector-icons';
import { MainNavigator, RootStackParamList, SCREENS } from '../../../Navigation';
import { useColorContext } from '../../../shared/providers/color-provider';
import { useThemeContext } from '../../../shared/providers/theme-provider';

type LoginScreenNavigationProp = StackNavigationProp<RootStackParamList, 'LOGIN', MainNavigator>;

interface LoginProps {
  navigation: LoginScreenNavigationProp;
}

const Login = ({ navigation }: LoginProps): ReactElement => {
  const { color } = useColorContext();
  const { theme } = useThemeContext();

  return (
    <Container>
      <Text style={{
          ...styles.text,
          color: color.text,
        }}
      >
        Login Screen
      </Text>
      <PrimaryButton
        onPress={() => navigation.navigate(SCREENS.HOME)}
        text="Go to Home"
        loading={false}
        disabled={false}
        icon={<MaterialIcons name="home" size={24} color="white" />}
        iconPosition="left"
        onLongPress={() => console.log('Long press triggered!')}
      />
      <Text style={{
          ...styles.text,
          color: color.text,
        }}
      >
        { theme } theme
      </Text>
    </Container>
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
