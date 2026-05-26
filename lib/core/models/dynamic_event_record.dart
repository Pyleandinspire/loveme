import 'package:hive/hive.dart';

part 'dynamic_event_record.g.dart';

@HiveType(typeId: 6)
class DynamicEventRecord extends HiveObject {
  @HiveField(0)
  String eventId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String narrativeText;

  @HiveField(3)
  String? localCgImagePath;

  @HiveField(4)
  int triggerAffection;

  @HiveField(5)
  List<String> choices;

  @HiveField(6)
  List<int> affectionChanges;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  int playthroughNumber;

  DynamicEventRecord({
    required this.eventId,
    required this.title,
    required this.narrativeText,
    this.localCgImagePath,
    required this.triggerAffection,
    required this.choices,
    required this.affectionChanges,
    required this.createdAt,
    required this.playthroughNumber,
  });
}
