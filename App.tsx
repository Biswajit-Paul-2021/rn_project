/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';

import {
  Button,
  SafeAreaView,
  StatusBar,
  useColorScheme,
  View,
} from 'react-native';

import {Colors} from 'react-native/Libraries/NewAppScreen';
import FlutterNativeModule from './src/FlutterNativeModule';

function App(): React.JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <View>
        <Button
          title="Open Flutter Module"
          onPress={() => {
            console.log('====================================');
            console.log(FlutterNativeModule);
            console.log('====================================');
            FlutterNativeModule.showToast('token', 'userID');
          }}
        />
      </View>
    </SafeAreaView>
  );
}

export default App;
