import Home from './screens/home/ui/home-screen';
import { View } from 'react-native';
import { ReactElement } from 'react';
import { StatusBar } from 'expo-status-bar';

export default function App(): ReactElement {
  return (
    <View style={{ flex: 1 }}>
      <StatusBar style="dark" />
      <Home />
    </View>
  );
}
