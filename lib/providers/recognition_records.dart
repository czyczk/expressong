import 'package:flutter/foundation.dart';

import '../models/recognition_record.dart';

abstract class RecognitionRecords with ChangeNotifier {
  List<RecognitionRecord> get recognitionRecords;

  Future<void> loadRecognitionRecords();

  Future<void> deleteRecognitionRecord(String id);

  Future<void> addRecognitionRecord(RecognitionRecord recognitionRecord);
}