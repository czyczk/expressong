import './emotion.dart';

class DetectionResultEntry {
  final Emotion emotion;
  final double probability;

  const DetectionResultEntry(this.emotion, this.probability);
}