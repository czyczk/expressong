import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/emotion.dart';
import '../../../../models/song_list.dart';
import '../../../../providers/stub/dummy_song_lists.dart';

class EmotionSongListsScreen extends StatelessWidget {
  static const routeName = '/song-lists/emotion-song-list';

  @override
  Widget build(BuildContext context) {
    var emotion = ModalRoute.of(context).settings.arguments as Emotion;

    return Scaffold(
      appBar: AppBar(title: Text('歌单管理')),
      body: FutureBuilder<void>(
        future:
            Provider.of<DummySongLists>(context, listen: false).loadSongLists(),
        builder: (ctx, snapshot) => snapshot == ConnectionState.waiting
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 32,
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : Consumer<DummySongLists>(
                builder: (ctx, songListsProvider, child) {
                  final songList = songListsProvider.getSongLists(emotion);
                  if (songList.length > 0) {
                    return ListView.separated(
                      itemBuilder: (ctx, index) => ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Image.network(
                          songList[index].coverUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                        title: Text(songList[index].title),
                        trailing: Text('${songList[index].trackCount} 首',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      itemCount: songList.length,
                      separatorBuilder: (ctx, index) => Divider(height: 0),
                    );
                  } else {
                    return child;
                  }
                },
                child: Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(
                      vertical: 32,
                    ),
//                  child: const Text(
//                    '此分类下暂无歌单',
//                    style: TextStyle(
//                      color: Colors.grey,
//                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 32,
                        ),
                        Center(child: CircularProgressIndicator()),
                      ],
                    )),
              ),
      ),
    );
  }
}
