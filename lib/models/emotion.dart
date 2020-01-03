enum Emotion {
  Angry,
  Disgust,
  Fear,
  Happy,
  Sad,
  Surprise,
  Neutral,
}

extension EmotionExtension on Emotion {
  String get displayText {
    switch (this) {
      case Emotion.Angry: {
        return '愤怒';
      }
      case Emotion.Disgust: {
        return '厌恶';
      }
      case Emotion.Fear: {
        return '害怕';
      }
      case Emotion.Happy: {
        return '开心';
      }
      case Emotion.Sad: {
        return '悲伤';
      }
      case Emotion.Surprise: {
        return '惊讶';
      }
      case Emotion.Neutral: {
        return '一般';
      }
      default:
        throw UnimplementedError('该情绪没有对应文本。');
    }
  }

  String get emoji {
    switch (this) {
      case Emotion.Angry: {
        return '😠';
      }
      case Emotion.Disgust: {
        return '😒';
      }
      case Emotion.Fear: {
        return '😰';
      }
      case Emotion.Happy: {
        return '😀';
      }
      case Emotion.Sad: {
        return '😭';
      }
      case Emotion.Surprise: {
        return '😱';
      }
      case Emotion.Neutral: {
        return '😶';
      }
      default:
        throw UnimplementedError('该情绪没有对应颜文字。');
    }
  }
}