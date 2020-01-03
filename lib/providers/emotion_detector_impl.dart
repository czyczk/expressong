import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/detection_result_entry.dart';
import '../models/emotion.dart';
import './emotion_detector.dart';

class EmotionDetectorImpl with ChangeNotifier implements EmotionDetector {
  @override
  Future<List<DetectionResultEntry>> determineEmotion(
      String base64EncodedImageFile) async {
    final Map<String, String> header = {'Content-Type': 'application/json'};

    final response = await http.post(
      'http://emotion.free.idcfengye.com/test',
      headers: header,
      body: json.encode({
        'image': base64EncodedImageFile,
      }),
    );
    final probabilities = json.decode(response.body)['data'];
    final result = <DetectionResultEntry>[];
    result.add(DetectionResultEntry(Emotion.Angry, double.parse(probabilities[0])));
    result.add(DetectionResultEntry(Emotion.Disgust, double.parse(probabilities[1])));
    result.add(DetectionResultEntry(Emotion.Fear, double.parse(probabilities[2])));
    result.add(DetectionResultEntry(Emotion.Happy, double.parse(probabilities[3])));
    result.add(DetectionResultEntry(Emotion.Sad, double.parse(probabilities[4])));
    result.add(DetectionResultEntry(Emotion.Surprise, double.parse(probabilities[5])));
    result.add(DetectionResultEntry(Emotion.Neutral, double.parse(probabilities[6])));

    result.sort((a, b) => -a.probability.compareTo(b.probability));
    return result;
  }
}
