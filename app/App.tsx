import 'react-native-gesture-handler';
import React from 'react';
import Home from './screens/home/ui/home-screen';
import Login from './screens/login/ui/login-screen';
import { View, StyleSheet } from 'react-native';
import { ReactElement } from 'react';
import { StatusBar } from 'expo-status-bar';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator, StackNavigationOptions } from '@react-navigation/stack';

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

const defaultScreenOptions: StackNavigationOptions = {
  headerStyle: { backgroundColor: '#000' },
  headerTintColor: '#fff',
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

export default function App(): ReactElement {
  return (
    <View style={styles.container}>
      <StatusBar style="light" />
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
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
