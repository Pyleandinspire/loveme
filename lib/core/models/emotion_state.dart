import 'package:hive/hive.dart';

part 'emotion_state.g.dart';

@HiveType(typeId: 6)
class EmotionState extends HiveObject {
  @HiveField(0)
  String characterId;

  @HiveField(1)
  double happiness; // 0-100

  @HiveField(2)
  double sadness; // 0-100

  @HiveField(3)
  double anger; // 0-100

  @HiveField(4)
  double fear; // 0-100

  @HiveField(5)
  double surprise; // 0-100

  @HiveField(6)
  double disgust; // 0-100

  @HiveField(7)
  DateTime lastUpdated;

  EmotionState({
    required this.characterId,
    this.happiness = 50,
    this.sadness = 20,
    this.anger = 10,
    this.fear = 15,
    this.surprise = 30,
    this.disgust = 10,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  String get dominantEmotion {
    final emotions = {
      'happy': happiness,
      'sad': sadness,
      'angry': anger,
      'fearful': fear,
      'surprised': surprise,
      'disgusted': disgust,
    };

    return emotions.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  void updateEmotion(String emotion, double value) {
    switch (emotion) {
      case 'happy':
        happiness = happiness.clamp(0, 100);
        happiness = (happiness + value).clamp(0, 100);
        break;
      case 'sad':
        sadness = (sadness + value).clamp(0, 100);
        break;
      case 'angry':
        anger = (anger + value).clamp(0, 100);
        break;
      case 'fearful':
        fear = (fear + value).clamp(0, 100);
        break;
      case 'surprised':
        surprise = (surprise + value).clamp(0, 100);
        break;
      case 'disgusted':
        disgust = (disgust + value).clamp(0, 100);
        break;
    }
    lastUpdated = DateTime.now();
  }

  void decay() {
    // 自然衰减
    happiness = (happiness * 0.95).clamp(0, 100);
    sadness = (sadness * 0.95).clamp(0, 100);
    anger = (anger * 0.95).clamp(0, 100);
    fear = (fear * 0.95).clamp(0, 100);
    surprise = (surprise * 0.95).clamp(0, 100);
    disgust = (disgust * 0.95).clamp(0, 100);
    lastUpdated = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'characterId': characterId,
      'happiness': happiness,
      'sadness': sadness,
      'anger': anger,
      'fear': fear,
      'surprise': surprise,
      'disgust': disgust,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory EmotionState.fromJson(Map<String, dynamic> json) {
    return EmotionState(
      characterId: json['characterId'] ?? '',
      happiness: (json['happiness'] ?? 50).toDouble(),
      sadness: (json['sadness'] ?? 20).toDouble(),
      anger: (json['anger'] ?? 10).toDouble(),
      fear: (json['fear'] ?? 15).toDouble(),
      surprise: (json['surprise'] ?? 30).toDouble(),
      disgust: (json['disgust'] ?? 10).toDouble(),
      lastUpdated: json['lastUpdated'] is DateTime
          ? json['lastUpdated']
          : DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
    );
  }
}
