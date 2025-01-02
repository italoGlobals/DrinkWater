import PrimaryButton from '../../../shared/ui/primary-button/primary-button';
import Container from '../../../shared/ui/container/container';
import { ReactElement, useEffect } from 'react';
import { Alert, AlertButton, AlertOptions, BackHandler, StyleSheet, Text } from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { MaterialIcons } from '@expo/vector-icons';
import { MainNavigator, RootStackParamList, SCREENS } from '../../../Navigation';
import { useThemeContext } from '../../../shared/providers/theme-provider';
import { useColorContext } from '../../../shared/providers/color-provider';

type HomeScreenNavigationProp = StackNavigationProp<RootStackParamList, 'HOME', MainNavigator>;

interface HomeProps {
  navigation: HomeScreenNavigationProp;
}

const Home = ({ navigation }: HomeProps): ReactElement => {
  const { toggleTheme, theme } = useThemeContext();
  const { color } = useColorContext();

  useEffect(() => {
    const backAction = (): boolean => {
      if (navigation.getState().index === 0) {
        const alertTitle: string = 'Fechar';
        const alertMessage: string = 'O app será fechado, deseja continuar?';
        const alertButtons: AlertButton[] = [
          {
            text: 'Não'
          },
          {
            text: 'Sim',
            onPress: (): void => BackHandler.exitApp()
          },
        ];
        const alertOptions: AlertOptions = {
          cancelable: true,
          userInterfaceStyle: theme
        };
        Alert.alert(alertTitle, alertMessage, alertButtons, alertOptions);
        return true;
      }
      return false;
    };

    BackHandler.addEventListener('hardwareBackPress', backAction);

    return (): void => {
      BackHandler.removeEventListener('hardwareBackPress', backAction);
    };
  }, []);

  return (
    <Container>
      <Text style={{...styles.text, color: color.text}}>Home Screen</Text>
      <PrimaryButton
        onPress={() => navigation.navigate(SCREENS.LOGIN, { userId: '1234' })}
        text="Go to Login"
        loading={false}
        disabled={false}
        icon={<MaterialIcons name="login" size={24} color={'#FFFFFF'} />}
        iconPosition="left"
        onLongPress={() => console.log('Long press triggered!')}
      />
      <PrimaryButton
        onPress={toggleTheme}
        text="Toggle Theme"
        loading={false}
        disabled={false}
        icon={<MaterialIcons name="color-lens" size={24} color={'#FFFFFF'} />}
        iconPosition="left"
        onLongPress={() => console.log('Long press triggered!')}
      />
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

export default Home;
