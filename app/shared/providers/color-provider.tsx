import { createContext, useContext, ReactNode } from 'react';
import { ColorValue } from 'react-native';
import { useThemeContext } from './theme-provider';

export interface ColorScheme {
  primary: string;
  secondary: string;
  accent: string;
  background: ColorValue;
  surface: ColorValue;
  text: string;
  textSecondary: string;
  error: string;
  warning: string;
  success: string;
  info: string;
  border: string;
  shadow: string;
  disabled: string;
}

export interface ColorSchemeName {
  light: ColorScheme;
  dark: ColorScheme;
}

export interface ColorContextType {
  color: ColorScheme;
}

const defaultColor: ColorSchemeName = {
  light: {
    primary: '#1A73E8',
    secondary: '#6D9EEB',
    accent: '#FFAB00',
    background: '#FFFFFF',
    surface: '#F5F5F5',
    text: '#000000',
    textSecondary: '#5F6368',
    error: '#D32F2F',
    warning: '#FBC02D',
    success: '#388E3C',
    info: '#1976D2',
    border: '#E0E0E0',
    shadow: '#0000001A',
    disabled: '#BDBDBD',
  },
  dark: {
    primary: '#BB86FC',
    secondary: '#03DAC6',
    accent: '#CF6679',
    background: '#121212',
    surface: '#1F1F1F',
    text: '#FFFFFF',
    textSecondary: '#B3B3B3',
    error: '#CF6679',
    warning: '#FFA000',
    success: '#4CAF50',
    info: '#2196F3',
    border: '#373737',
    shadow: '#00000040',
    disabled: '#646464',
  },
};

const ColorContext = createContext<ColorContextType | undefined>(undefined);

export const ColorProvider = ({ children }: { children: ReactNode }): React.ReactElement => {
  const { theme } = useThemeContext();
  const themeColor = defaultColor[theme];

  return (
    <ColorContext.Provider value={{ color: themeColor }}>
      {children}
    </ColorContext.Provider>
  );
};

export const useColorContext = (): ColorContextType => {
  const context = useContext(ColorContext);
  if (!context) {
    throw new Error('useColorContext must be used within a ColorProvider');
  }
  return context;
};
