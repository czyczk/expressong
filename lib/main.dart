import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/tabs/tabs_screen.dart';
import './screens/recognition_result/recognition_result_screen.dart';
import './screens/tabs/song_lists/emotion_song_lists/emotion_song_lists_screen.dart';
import './screens/settings/settings_screen.dart';
import './providers/recognition_records_impl.dart';
import './providers/emotion_detector_impl.dart';
import './providers/stub/dummy_recognition_records.dart';
import './providers/stub/dummy_emotion_detector.dart';
import './providers/stub/dummy_song_lists.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _primarySwatch = MaterialColor(
    Color.fromRGBO(40, 52, 64, 1).value,
    {
      50: Color.fromRGBO(40, 52, 64, .1),
      100: Color.fromRGBO(40, 52, 64, .2),
      200: Color.fromRGBO(40, 52, 64, .3),
      300: Color.fromRGBO(40, 52, 64, .4),
      400: Color.fromRGBO(40, 52, 64, .5),
      500: Color.fromRGBO(40, 52, 64, .6),
      600: Color.fromRGBO(40, 52, 64, .7),
      700: Color.fromRGBO(40, 52, 64, .8),
      800: Color.fromRGBO(40, 52, 64, .9),
      900: Color.fromRGBO(40, 52, 64, 1),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: RecognitionRecordsImpl(),
        ),
        ChangeNotifierProvider.value(
          value: EmotionDetectorImpl(),
        ),
        ChangeNotifierProvider.value(
          value: DummySongLists(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: _primarySwatch,
          accentColor: Color.fromRGBO(229, 126, 49, 1),
        ),
        routes: {
          '/': (ctx) => TabsScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          RecognitionResultScreen.routeName: (ctx) => RecognitionResultScreen(),
          EmotionSongListsScreen.routeName: (ctx) => EmotionSongListsScreen(),
        },
      ),
    );
  }
}
