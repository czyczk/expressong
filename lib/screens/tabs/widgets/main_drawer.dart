import 'package:flutter/material.dart';

import '../../settings/settings_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
        leading: Icon(
          icon,
          size: 24,
        ),
        title: Text(title,
            style: TextStyle(
              fontSize: 16,
            )),
        onTap: tapHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        Container(
          height: 100,
          width: double.infinity,
          padding: EdgeInsets.all(20) +
              EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          alignment: Alignment.centerLeft,
          color: Theme.of(context).primaryColor,
          child: Text('Expressong',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Theme.of(context).accentColor,
              )),
        ),
        SizedBox(
          height: 20,
        ),
        _buildListTile('表情识别', Icons.insert_emoticon, () {
          Navigator.of(context).pushReplacementNamed('/');
        }),
        _buildListTile('设置', Icons.settings, () {
          Navigator.of(context).pushReplacementNamed(SettingsScreen.routeName);
        }),
      ],
    ));
  }
}
