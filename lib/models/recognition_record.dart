import './emotion.dart';

class RecognitionRecord {
  final String id;
  final DateTime time;
  final Emotion emotion;

  const RecognitionRecord(this.id, this.time, this.emotion);
}