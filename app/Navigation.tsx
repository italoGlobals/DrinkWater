import Home from './screens/home/ui/home-screen';
import Login from './screens/login/ui/login-screen';
import { ReactElement } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator, StackNavigationOptions } from '@react-navigation/stack';
import { useThemeContext } from './shared/providers/theme-provider';

type ScreensType = {
  readonly HOME: 'HOME';
  readonly LOGIN: 'LOGIN';
};

export const SCREENS: ScreensType = {
  HOME: 'HOME',
  LOGIN: 'LOGIN',
};

export type RootStackParamList = {
  HOME: undefined;
  LOGIN: { userId: string };
};

const MainStack = createStackNavigator<RootStackParamList, 'MAIN_NAVIGATOR'>();

const Navigation = (): ReactElement => {
  const { isDark } = useThemeContext();

  const defaultScreenOptions: StackNavigationOptions = {
    headerStyle: { backgroundColor: isDark ? '#000' : '#fff' },
    headerTintColor: isDark ? '#fff' : '#000',
    headerTitleStyle: { fontWeight: 'bold' },
    headerMode: 'screen',
    headerShown: true,
  };

  const homeScreenOptions: StackNavigationOptions = {
    title: 'Tela Inicial',
  };

  const loginScreenOptions: StackNavigationOptions = {
    title: 'Login de Usuário',
  };

  return (
    <NavigationContainer>
      <MainStack.Navigator
        id={'MAIN_NAVIGATOR'}
        initialRouteName={SCREENS.HOME}
        screenOptions={defaultScreenOptions}
      >
        <MainStack.Screen
          name={SCREENS.HOME}
          component={Home}
          options={homeScreenOptions}
        />
        <MainStack.Screen
          name={SCREENS.LOGIN}
          component={Login}
          initialParams={{ userId: '1234' }}
          options={loginScreenOptions}
        />
      </MainStack.Navigator>
    </NavigationContainer>
  );
};

export default Navigation;
