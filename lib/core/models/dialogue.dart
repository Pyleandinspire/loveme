import 'package:hive/hive.dart';

part 'dialogue.g.dart';

@HiveType(typeId: 2)
class DialogueRecord extends HiveObject {
  @HiveField(0)
  String speaker;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  String? emotion;

  DialogueRecord({
    required this.speaker,
    required this.content,
    required this.timestamp,
    this.emotion,
  });

  Map<String, dynamic> toJson() {
    return {
      'speaker': speaker,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'emotion': emotion,
    };
  }

  factory DialogueRecord.fromJson(Map<String, dynamic> json) {
    return DialogueRecord(
      speaker: json['speaker'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] is DateTime
          ? json['timestamp']
          : DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      emotion: json['emotion'],
    );
  }
}
