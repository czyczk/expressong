import 'package:flutter/foundation.dart';

import '../models/detection_result_entry.dart';

abstract class EmotionDetector with ChangeNotifier {
  Future<List<DetectionResultEntry>> determineEmotion(String base64EncodedImageFile);
}