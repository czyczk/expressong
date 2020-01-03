import 'package:flutter/foundation.dart';

import '../emotion_detector.dart';
import '../../models/emotion.dart';
import '../../models/detection_result_entry.dart';

class DummyEmotionDetector with ChangeNotifier implements EmotionDetector {
  final _alwaysHappy = true;

  @override
  Future<List<DetectionResultEntry>> determineEmotion(
      String base64EncodedImageFile) async {
    if (_alwaysHappy) {
      return Future.value([
        DetectionResultEntry(Emotion.Happy, 0.87654),
        DetectionResultEntry(Emotion.Angry, 0.54321),
        DetectionResultEntry(Emotion.Disgust, 0.123456)
      ]);
    } else {
      final emotions = Emotion.values;
      emotions.shuffle();
      final probabilities = [
        0.987654,
        0.876543,
        0.765432,
        0.654321,
        0.54321,
        0.4321,
        0.321
      ];
      final result = [];
      for (var i = 0; i < emotions.length; i++) {
        result.add(DetectionResultEntry(emotions[i], probabilities[i]));
      }

      return result;
    }
  }
}
