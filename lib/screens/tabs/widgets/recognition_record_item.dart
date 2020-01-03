import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/recognition_record.dart';
import '../../../models/emotion.dart';

class RecognitionRecordItem extends StatelessWidget {
  final RecognitionRecord _recognitionRecord;
  final bool isDeletable;

  const RecognitionRecordItem(this._recognitionRecord,
      {this.isDeletable = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
//      child: Card(
      key: ValueKey(_recognitionRecord.id),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        leading: Container(
            width: 42,
            child: Center(
                child: Text(
              _recognitionRecord.emotion.emoji,
              style: TextStyle(fontSize: 36),
            ))),
        title: Text(_recognitionRecord.emotion.displayText),
        subtitle: Text(
            DateFormat('yyyy-MM-dd HH:mm:ss').format(_recognitionRecord.time)),
      ),
    );
  }
}
