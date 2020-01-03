import 'package:flutter/foundation.dart';

import '../models/emotion.dart';
import '../models/song.dart';

abstract class SongLists with ChangeNotifier {
  Future<List<int>> fetchSongListIdsOf(Emotion emotion);

  Future<bool> addSongList(Emotion emotion, int songListId);

  Future<bool> checkExistence(Emotion emotion, int songListId);

  Future<void> deleteSongList(Emotion emotion, int songListId);

  Future<void> loadSongLists();

  Future<Song> getRandomSong(Emotion emotion);
}