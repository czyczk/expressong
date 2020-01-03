import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/emotion.dart';
import '../../models/detection_result_entry.dart';
import '../../models/recognition_record.dart';
import '../../providers/stub/dummy_recognition_records.dart';
import '../../providers/recognition_records_impl.dart';
import '../music_play/music_play_screen.dart';

class RecognitionResultScreen extends StatefulWidget {
  static const String routeName = '/recognition-result';

  @override
  _RecognitionResultScreenState createState() =>
      _RecognitionResultScreenState();
}

class _RecognitionResultScreenState extends State<RecognitionResultScreen> {
  var _selectedIndex = 0;

  void _showNextDetectionEntry(List<DetectionResultEntry> detectionResults) {
    if (_selectedIndex + 1 == detectionResults.length) {
      // No more results to show. Alert and pop the screen.
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('检测失败'),
              content: Text('猜不着，再拍张试试？'),
              actions: <Widget>[
                FlatButton(
                  child: Text('返回'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          }).then((_) => Navigator.of(context).pop());
      return;
    }

    setState(() {
      _selectedIndex++;
    });
  }

  Future<void> _confirmDetectionEntry(
      DetectionResultEntry detectionResultEntry) async {
    // Add to the database
    final dateTime = DateTime.now();
    await Provider.of<RecognitionRecordsImpl>(context).addRecognitionRecord(
        RecognitionRecord(dateTime.millisecondsSinceEpoch.toString(), dateTime,
            detectionResultEntry.emotion));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => MusicPlayScreen(detectionResultEntry.emotion)));
  }

  @override
  Widget build(BuildContext context) {
    final detectionResult =
        ModalRoute.of(context).settings.arguments as List<DetectionResultEntry>;

    return Scaffold(
      appBar: AppBar(
        title: Text('检测结果'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            detectionResult[_selectedIndex].emotion.emoji,
            style: TextStyle(fontSize: 56),
          ),
          SizedBox(height: 16),
          Text(
            detectionResult[_selectedIndex].emotion.displayText,
            style: TextStyle(fontSize: 24),
          ),
          Text(
            '概率：${(detectionResult[_selectedIndex].probability * 100).toStringAsFixed(2)} %',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Divider(
            height: 48,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('识别有误'),
                onPressed: () => _showNextDetectionEntry(detectionResult),
              ),
              SizedBox(
                width: 20,
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('正确'),
                onPressed: () =>
                    _confirmDetectionEntry(detectionResult[_selectedIndex]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
