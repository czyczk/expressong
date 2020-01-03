import 'package:flutter/foundation.dart';

import '../../models/recognition_record.dart';
import '../../models/emotion.dart';
import '../recognition_records.dart';

class DummyRecognitionRecords
    with ChangeNotifier
    implements RecognitionRecords {
  bool _isLoaded = false;

  final _dummyRecords = [
    RecognitionRecord(
        'fill1', DateTime(2019, 10, 24, 10, 24, 21), Emotion.Disgust),
    RecognitionRecord(
        'fill2', DateTime(2019, 10, 24, 10, 25, 22), Emotion.Disgust),
    RecognitionRecord(
        'fill3', DateTime(2019, 10, 24, 10, 26, 23), Emotion.Disgust),
    RecognitionRecord('1', DateTime(2019, 12, 24, 16, 30, 12), Emotion.Neutral),
    RecognitionRecord(
        '2', DateTime(2019, 12, 31, 13, 22, 12), Emotion.Surprise),
    RecognitionRecord('3', DateTime(2019, 12, 31, 16, 47, 15), Emotion.Sad),
    RecognitionRecord('4', DateTime(2019, 12, 31, 17, 47, 24), Emotion.Happy),
    RecognitionRecord('5', DateTime(2019, 12, 31, 17, 48, 27), Emotion.Fear),
    RecognitionRecord('6', DateTime(2019, 12, 31, 17, 49, 34), Emotion.Disgust),
    RecognitionRecord('7', DateTime(2019, 12, 31, 17, 49, 52), Emotion.Angry),
  ];

  final returnEmptyList = false;

  List<RecognitionRecord> get recognitionRecords {
    var result = [..._dummyRecords];
    result.sort((a, b) {
      return -a.time.compareTo(b.time);
    });
    return result;
  }

  /**
   * Delay for 1 second and do nothing.
   */
  @override
  Future<void> loadRecognitionRecords() async {
    if (_isLoaded) {
      print('no need to load');
      return;
    }
    print('about to load');
    if (returnEmptyList) {
      _dummyRecords.clear();
    }
    await Future.delayed(Duration(seconds: 1));
    _isLoaded = true;
  }

  /**
   * Delay for 1 second and do nothing.
   */
  @override
  Future<void> deleteRecognitionRecord(String id) {
    return Future.delayed(Duration(seconds: 1), () => notifyListeners());
  }

  /**
   * Delay for 1 second and add another dummy record.
   */
  @override
  Future<void> addRecognitionRecord(RecognitionRecord recognitionRecord) {
    return Future.delayed(Duration(seconds: 1), () {
      _dummyRecords.add(
        RecognitionRecord(
            '7', DateTime(2019, 12, 31, 17, 50, 52), Emotion.Angry),
      );
      print('added');
      notifyListeners();
    });
  }
}
