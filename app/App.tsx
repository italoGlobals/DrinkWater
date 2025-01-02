import 'react-native-gesture-handler';
import Layout from './Layout';
import Navigation from './Navigation';
import { ReactElement } from 'react';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { ThemeProvider } from './shared/providers/theme-provider';
import { ColorProvider } from './shared/providers/color-provider';

export default function App(): ReactElement {
  return (
    <SafeAreaProvider>
      <ThemeProvider>
        <ColorProvider>
          <Layout>
            <Navigation />
          </Layout>
        </ColorProvider>
      </ThemeProvider>
    </SafeAreaProvider>
  );
}
