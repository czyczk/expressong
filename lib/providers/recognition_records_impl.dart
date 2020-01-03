import 'package:flutter/material.dart';

import './recognition_records.dart';
import '../models/emotion.dart';
import '../models/recognition_record.dart';

class RecognitionRecordsImpl with ChangeNotifier implements RecognitionRecords {
  bool _isLoaded = false;

  List<RecognitionRecord> _recognitionRecords = [];

  List<RecognitionRecord> get recognitionRecords {
    var result = [..._recognitionRecords];
    result.sort((a, b) {
      return -a.time.compareTo(b.time);
    });
    return result;
  }

  @override
  Future<void> loadRecognitionRecords() async {
    if (_isLoaded) {
      return;
    }

    _isLoaded = true;
  }

  @override
  Future<void> deleteRecognitionRecord(String id) async {
    _recognitionRecords.remove(id);
    notifyListeners();
    return;
  }

  @override
  Future<void> addRecognitionRecord(RecognitionRecord recognitionRecord) async {
    _recognitionRecords.add(recognitionRecord);
    notifyListeners();
    return;
  }
}
