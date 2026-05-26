import 'package:hive/hive.dart';

part 'emotion_state.g.dart';

@HiveType(typeId: 8)
class EmotionState extends HiveObject {
  @HiveField(0)
  int happy;

  @HiveField(1)
  int shy;

  @HiveField(2)
  int angry;

  @HiveField(3)
  int sad;

  @HiveField(4)
  int coquettish;

  @HiveField(5)
  DateTime lastUpdated;

  EmotionState({
    this.happy = 0,
    this.shy = 0,
    this.angry = 0,
    this.sad = 0,
    this.coquettish = 0,
    required this.lastUpdated,
  });

  Map<String, int> toMap() {
    return {
      'happy': happy,
      'shy': shy,
      'angry': angry,
      'sad': sad,
      'coquettish': coquettish,
    };
  }
}
