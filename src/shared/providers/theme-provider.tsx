import React, { createContext, useContext, useState, useEffect, ReactElement } from 'react';
import { Appearance, ColorSchemeName } from 'react-native';

type ThemeType = 'light' | 'dark';

export type ThemeContextType = {
  theme: ThemeType;
  setTheme: (theme: ColorSchemeName) => void;
  toggleTheme: () => void;
  isDark: boolean;
  isLight: boolean;
};

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export const ThemeProvider = ({ children }: { children: ReactElement }): ReactElement => {
  const [theme, setTheme] = useState<ColorSchemeName>(Appearance.getColorScheme());

  useEffect(() => {
    const subscription = Appearance.addChangeListener(({ colorScheme }) => {
      setTheme(colorScheme);
    });

    return (): void => subscription.remove();
  }, []);

  const changeTheme = (newTheme: ColorSchemeName): void => {
    setTheme(newTheme);
    Appearance.setColorScheme(newTheme);
  };

  const toggleTheme = (): void => {
    const newTheme: ThemeType = theme === 'dark' ? 'light' : 'dark';
    changeTheme(newTheme);
  };

  const isDark = theme === 'dark';
  const isLight = theme === 'light';

  const currentTheme: ThemeType = theme || 'light';

  return (
    <ThemeContext.Provider value={{ theme: currentTheme, setTheme: changeTheme, toggleTheme, isDark, isLight }}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useThemeContext = (): ThemeContextType => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useThemeContext must be used within a ThemeProvider');
  }
  return context;
};
