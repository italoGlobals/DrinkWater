import Home from './screens/home/ui/home-screen';
import Login from './screens/login/ui/login-screen';
import { ReactElement } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { CardStyleInterpolators, createStackNavigator, StackNavigationOptions } from '@react-navigation/stack';
import { useThemeContext } from './shared/providers/theme-provider';
import { useColorContext } from './shared/providers/color-provider';
import { TransitionSpec } from '@react-navigation/stack/lib/typescript/commonjs/src/types';

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
  const { color } = useColorContext();
  const { theme } = useThemeContext();

  const defaultNavigationTransition: TransitionSpec = {
    animation: 'timing',
    config: { duration: 1000 },
  };

  const defaultScreenOptions: StackNavigationOptions = {
    headerStyle: { backgroundColor: color.background },
    headerTintColor: color.text,
    headerTitleStyle: { fontWeight: 'bold' },
    headerMode: 'screen',
    cardStyleInterpolator: CardStyleInterpolators.forHorizontalIOS,
    transitionSpec: {
      open: defaultNavigationTransition,
      close: defaultNavigationTransition
    },
  };

  const homeScreenOptions: StackNavigationOptions = {
    title: `Tela Inicial - ${theme[0].toLocaleUpperCase() + theme.slice(1)} Theme`,
    headerShown: true,
    headerTitleAlign: 'left',
  };

  const loginScreenOptions: StackNavigationOptions = {
    title: `Login de Usuário - ${theme[0].toLocaleUpperCase() + theme.slice(1)} Theme`,
    headerShown: true,
    headerTitleAlign: 'left',
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
