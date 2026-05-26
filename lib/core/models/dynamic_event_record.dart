import 'package:hive/hive.dart';

part 'dynamic_event_record.g.dart';

@HiveType(typeId: 11)
class DynamicEventRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String characterId;

  @HiveField(2)
  String eventType; // 'milestone', 'ending', etc.

  @HiveField(3)
  int affectionLevel;

  @HiveField(4)
  String title;

  @HiveField(5)
  String description;

  @HiveField(6)
  String? cgImagePath;

  @HiveField(7)
  String sceneDescription;

  @HiveField(8)
  List<String> dialogueTexts;

  @HiveField(9)
  List<DialogueOption> options;

  @HiveField(10)
  DateTime triggeredAt;

  @HiveField(11)
  String? chosenOptionId;

  @HiveField(12)
  int affectionChange;

  DynamicEventRecord({
    required this.id,
    required this.characterId,
    required this.eventType,
    required this.affectionLevel,
    required this.title,
    required this.description,
    this.cgImagePath,
    required this.sceneDescription,
    required this.dialogueTexts,
    required this.options,
    required this.triggeredAt,
    this.chosenOptionId,
    this.affectionChange = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'eventType': eventType,
      'affectionLevel': affectionLevel,
      'title': title,
      'description': description,
      'cgImagePath': cgImagePath,
      'sceneDescription': sceneDescription,
      'dialogueTexts': dialogueTexts,
      'options': options.map((o) => o.toJson()).toList(),
      'triggeredAt': triggeredAt.toIso8601String(),
      'chosenOptionId': chosenOptionId,
      'affectionChange': affectionChange,
    };
  }

  factory DynamicEventRecord.fromJson(Map<String, dynamic> json) {
    return DynamicEventRecord(
      id: json['id'] ?? '',
      characterId: json['characterId'] ?? '',
      eventType: json['eventType'] ?? '',
      affectionLevel: json['affectionLevel'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      cgImagePath: json['cgImagePath'],
      sceneDescription: json['sceneDescription'] ?? '',
      dialogueTexts: List<String>.from(json['dialogueTexts'] ?? []),
      options: (json['options'] as List<dynamic>?)
              ?.map((o) => DialogueOption.fromJson(o))
              .toList() ??
          [],
      triggeredAt: json['triggeredAt'] is DateTime
          ? json['triggeredAt']
          : DateTime.tryParse(json['triggeredAt'] ?? '') ?? DateTime.now(),
      chosenOptionId: json['chosenOptionId'],
      affectionChange: json['affectionChange'] ?? 0,
    );
  }
}

@HiveType(typeId: 12)
class DialogueOption extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String text;

  @HiveField(2)
  int affectionChange;

  @HiveField(3)
  String? nextDialogueId;

  DialogueOption({
    required this.id,
    required this.text,
    this.affectionChange = 0,
    this.nextDialogueId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'affectionChange': affectionChange,
      'nextDialogueId': nextDialogueId,
    };
  }

  factory DialogueOption.fromJson(Map<String, dynamic> json) {
    return DialogueOption(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      affectionChange: json['affectionChange'] ?? 0,
      nextDialogueId: json['nextDialogueId'],
    );
  }
}
