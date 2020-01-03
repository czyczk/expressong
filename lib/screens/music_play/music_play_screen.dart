import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:http/http.dart' as http;
import 'package:audioplayer/audioplayer.dart';

import '../../models/song.dart';
import '../../models/emotion.dart';
import '../../providers/stub/dummy_song_lists.dart';

class MusicPlayScreen extends StatefulWidget {
  final Emotion _emotion;

  const MusicPlayScreen(this._emotion);

  @override
  _MusicPlayScreenState createState() => _MusicPlayScreenState();
}

class _MusicPlayScreenState extends State<MusicPlayScreen> {
  var _isLoaded = false;
  var _isLoading = false;
  Song _song;
  var _isSongDownloaded = false;
  String _songFilePath;
  var _isSongPlaying = false;
  AudioPlayer _audioPlayer = AudioPlayer();

  Future<Uint8List> _loadFileBytes(BuildContext context, String url) async {
    Uint8List result;

    try {
      final response = await http.get(url);
      result = response.bodyBytes;
    } on http.ClientException {
      final snackBar = SnackBar(
        content: Text('下载音乐失败。'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }

    return result;
  }

  void _toggleMusicPlay() {
    if (_audioPlayer.state == AudioPlayerState.PLAYING) {
      _audioPlayer.pause().then((_) {
        setState(() {
          _isSongPlaying = false;
        });
      });
    } else {
      _audioPlayer.play(_songFilePath, isLocal: true).then((_) {
        setState(() {
          _isSongPlaying = true;
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (_isLoaded) return;

    setState(() {
      _isLoading = true;
    });

    Provider.of<DummySongLists>(context, listen: false)
        .loadSongLists()
        .then((_) {
      Provider.of<DummySongLists>(context, listen: false)
          .getRandomSong(widget._emotion)
          .catchError((_) {
        final snackBar = SnackBar(content: Text('无法读取歌曲。'));
        Scaffold.of(context).showSnackBar(snackBar);
      }).then((song) {
        setState(() {
          _song = song;
          _isLoaded = true;
          _isLoading = false;
        });

        _loadFileBytes(context, song.url).then((bytes) {
          pathProvider.getTemporaryDirectory().then((dir) {
            final file = File('${dir.path}/audio.mp3');
            file.writeAsBytesSync(bytes);

            setState(() {
              _songFilePath = file.path;
              _isSongDownloaded = true;
            });
          });
        });
      });

      super.didChangeDependencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('音乐播放')),
      body: (!_isLoaded || _isLoading)
          ? Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(
                vertical: 32,
              ),
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    alignment: Alignment.center,
                    child: Material(
                      elevation: 10,
                      shape: ContinuousRectangleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        _song.albumCoverUrl,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 24,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${_song.artist} - ${_song.title}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  alignment: Alignment.bottomCenter,
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    alignment: Alignment.center,
                    child: _isSongDownloaded
                        ? InkWell(
                            child: _isSongPlaying ? Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: 50,
                            ) : Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                            onTap: _toggleMusicPlay,
                          )
                        : CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}
