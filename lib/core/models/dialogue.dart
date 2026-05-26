import 'package:hive/hive.dart';

part 'dialogue.g.dart';

@HiveType(typeId: 1)
class DialogueRecord extends HiveObject {
  @HiveField(0)
  String speaker;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  int affectionChange;

  DialogueRecord({
    required this.speaker,
    required this.content,
    required this.timestamp,
    this.affectionChange = 0,
  });
}
