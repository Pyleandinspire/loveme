import 'package:hive/hive.dart';

part 'focus_record.g.dart';

@HiveType(typeId: 5)
class FocusRecord extends HiveObject {
  @HiveField(0)
  DateTime startTime;

  @HiveField(1)
  int durationMinutes;

  @HiveField(2)
  String taskLabel;

  @HiveField(3)
  bool isSuccess;

  @HiveField(4)
  String characterId;

  FocusRecord({
    required this.startTime,
    required this.durationMinutes,
    required this.taskLabel,
    required this.isSuccess,
    required this.characterId,
  });
}
