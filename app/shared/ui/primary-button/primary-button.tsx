import { ReactElement } from 'react';
import { StyleSheet, Text, TouchableOpacity, View, ActivityIndicator } from 'react-native';
import { useState } from 'react';

interface PrimaryButtonProps {
  onPress: () => void;
  text: string;
  loading?: boolean;
  disabled?: boolean;
  onLongPress?: () => void;
  icon?: ReactElement;
  iconPosition?: 'left' | 'right';
}

const PrimaryButton = ({
  onPress,
  text,
  loading = false,
  disabled = false,
  onLongPress,
  icon,
  iconPosition = 'left',
}: PrimaryButtonProps): ReactElement => {
  const [pressed, setPressed] = useState(false);

  const handlePressIn = (): void => setPressed(true);
  const handlePressOut = (): void => setPressed(false);

  const renderIcon = icon && iconPosition === 'left' ? (
    <View style={styles.iconContainer}>{icon}</View>
  ) : null;

  const renderText = (
    <Text style={[styles.text, disabled && styles.disabledText]}>
      {text}
    </Text>
  );

  return (
    <TouchableOpacity
      style={[
        styles.container,
        {
          backgroundColor: disabled ? '#D3D3D3' : pressed ? '#003366' : '#00154D',
        },
      ]}
      onPress={onPress}
      onPressIn={handlePressIn}
      onPressOut={handlePressOut}
      disabled={disabled || loading}
      onLongPress={onLongPress}
      activeOpacity={0.7}
    >
      <View style={styles.innerContainer}>
        {icon && iconPosition === 'left' && !loading ? renderIcon : null}
        {loading ? <ActivityIndicator color="#FFFFFF" /> : renderText}
        {icon && iconPosition === 'right' && !loading ? renderIcon : null}
      </View>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: {
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
    paddingVertical: 15,
    paddingHorizontal: 20,
    borderRadius: 8,
  },
  innerContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    textAlign: 'center',
    fontSize: 16,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  iconContainer: {
    marginRight: 8,
  },
  disabledText: {
    color: '#B0B0B0',
  },
});

export default PrimaryButton;
