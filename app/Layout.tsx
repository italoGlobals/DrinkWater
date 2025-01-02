import { ReactElement } from 'react';
import { useThemeContext } from './shared/providers/theme-provider';
import { View } from 'react-native';
import { StatusBar, StatusBarStyle } from 'expo-status-bar';

interface LayoutProps {
  children: ReactElement;
}

const Layout = ({ children }: LayoutProps): ReactElement => {
  const { isDark } = useThemeContext();

  const statusBarStyle: StatusBarStyle = isDark ? 'light' : 'dark';

  return (
    <View style={{ flex: 1 }}>
      <StatusBar style={statusBarStyle} />
      { children }
    </View>
  );
};

export default Layout;
