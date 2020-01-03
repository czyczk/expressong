import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './recognition_history/recognition_history_screen.dart';
import './song_lists/song_lists_screen.dart';
import './widgets/main_drawer.dart';

class _PageEntry {
  final Widget screenInstance;
  final String title;

  const _PageEntry(this.screenInstance, this.title);
}

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<_PageEntry> _pages;

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      _PageEntry(RecognitionHistoryScreen(), '表情识别'),
      _PageEntry(SongListsScreen(), '歌单管理'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pages[_selectedPageIndex].title)),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex].screenInstance,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.insert_emoticon),
            title: Text('表情识别'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.format_list_bulleted),
            title: Text('歌单管理'),
          )
        ],
      ),
    );
  }
}
