import 'package:flutter/material.dart';

import './emotion_song_lists/emotion_song_lists_screen.dart';
import '../../../models/emotion.dart';

class SongListsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emotions = Emotion.values;

    return ListView.separated(
      itemBuilder: (ctx, index) => ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: Container(
            width: 42,
            child: Center(
                child: Text(
              emotions[index].emoji,
              style: TextStyle(fontSize: 36),
            ))),
        title: Text(emotions[index].displayText),
        trailing: Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).pushNamed(
            EmotionSongListsScreen.routeName,
            arguments: emotions[index]),
      ),
      itemCount: emotions.length,
      separatorBuilder: (ctx, index) => Divider(height: 0),
    );
  }
}
