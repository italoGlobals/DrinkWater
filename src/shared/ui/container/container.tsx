import { ReactElement } from 'react';
import { View } from 'react-native';
import { useColorContext } from '../../providers/color-provider';

interface ContainerProps {
  children: ReactElement[];
}

const Container = ({ children }: ContainerProps): ReactElement => {
  const { color } = useColorContext();

  return (
    <View style={{
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
      backgroundColor: color.background
    }}>
      { children }
    </View>
  );
};

export default Container;
