import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../models/emotion.dart';
import '../../models/song_list.dart';
import '../../models/song.dart';
import '../song_lists.dart';

class DummySongLists with ChangeNotifier implements SongLists {
  bool _isLoaded = false;

  final _dummySongListIds = {
    Emotion.Happy: [2338927108, 13192938],
    Emotion.Angry: [3059716352, 529752816],
    Emotion.Disgust: [60370321],
    Emotion.Surprise: [140322435, 2581636066],
    Emotion.Neutral: [2862019219, 2485881914],
    Emotion.Fear: [766729894],
    Emotion.Sad: [2041269190, 2531872903],
  };

  final _dummySongLists = {
    Emotion.Angry: [],
    Emotion.Disgust: [],
    Emotion.Fear: [],
    Emotion.Happy: [],
    Emotion.Sad: [],
    Emotion.Surprise: [],
    Emotion.Neutral: [],
  };

  List<SongList> getSongLists(Emotion emotion) {
    return [..._dummySongLists[emotion]];
  }

  @override
  Future<bool> addSongList(Emotion emotion, int songListId) async {
    var isExisting = await checkExistence(emotion, songListId);
    if (isExisting) return false;

    _dummySongListIds[emotion].add(songListId);
    return true;
  }

  @override
  Future<bool> checkExistence(Emotion emotion, int songListId) async {
    return _dummySongListIds[emotion].contains(songListId);
  }

  @override
  Future<void> deleteSongList(Emotion emotion, int songListId) async {
    _dummySongListIds[emotion].remove(songListId);
  }

  @override
  Future<List<int>> fetchSongListIdsOf(Emotion emotion) async {
    return [..._dummySongListIds[emotion]];
  }

  @override
  Future<void> loadSongLists() async {
    if (_isLoaded)
      return;

    final emotions = Emotion.values;
    for (var emotion in emotions) {
      final songListIds = await fetchSongListIdsOf(emotion);
      final result = <SongList>[];
      for (var id in songListIds) {
        final response =
        await http.get('http://musicapi.leanapp.cn/playlist/detail?id=$id');
        final responseData = json.decode(response.body);
        final title = responseData['playlist']['name'];
        final coverUrl = responseData['playlist']['coverImgUrl'];
        final trackCount = responseData['playlist']['trackCount'];
        result.add(SongList(id, title, coverUrl, trackCount));
      }

      _dummySongLists[emotion] = result;
    }

    _isLoaded = true;
  }

  @override
  Future<Song> getRandomSong(Emotion emotion) async {
    final songLists = await getSongLists(emotion);
    final songList = songLists[Random().nextInt(songLists.length)];
    final songIndex = Random().nextInt(songList.trackCount);

    print('Song index: $songIndex');

    var response = await http.get('http://musicapi.leanapp.cn/playlist/detail?id=${songList.id}');
    var responseData = json.decode(response.body);
    final songIds = responseData['playlist']['trackIds'];
    final songId = songIds[songIndex]['id'] as int;
    print('Song ID: $songId');
    response = await http.get('http://musicapi.leanapp.cn/music/url?id=$songId');
    responseData = json.decode(response.body);
    final songUrl = responseData['data'][0]['url'];
    print('Song URL: $songUrl');
    response = await http.get('http://musicapi.leanapp.cn/song/detail?ids=$songId');
    responseData = json.decode(response.body);
    final songTitle = responseData['songs'][0]['name'];
    print('Song title: $songTitle');
    final songArtist = responseData['songs'][0]['ar'][0]['name'];
    print('Song artist: $songArtist');
    final songAlbumPicture = responseData['songs'][0]['al']['picUrl'];
    print('Song album picture: $songAlbumPicture');

    return Song(songId, songTitle, songArtist, songUrl, songAlbumPicture);
  }
}
