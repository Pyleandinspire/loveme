import 'package:hive/hive.dart';

part 'focus_record.g.dart';

@HiveType(typeId: 8)
class FocusRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int duration; // 秒

  @HiveField(2)
  bool completed;

  @HiveField(3)
  DateTime startedAt;

  @HiveField(4)
  DateTime? completedAt;

  @HiveField(5)
  int affectionReward;

  FocusRecord({
    required this.id,
    required this.duration,
    required this.completed,
    required this.startedAt,
    this.completedAt,
    this.affectionReward = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
      'completed': completed,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'affectionReward': affectionReward,
    };
  }

  factory FocusRecord.fromJson(Map<String, dynamic> json) {
    return FocusRecord(
      id: json['id'] ?? '',
      duration: json['duration'] ?? 0,
      completed: json['completed'] ?? false,
      startedAt: json['startedAt'] is DateTime
          ? json['startedAt']
          : DateTime.tryParse(json['startedAt'] ?? '') ?? DateTime.now(),
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] is DateTime
              ? json['completedAt']
              : DateTime.tryParse(json['completedAt']))
          : null,
      affectionReward: json['affectionReward'] ?? 0,
    );
  }
}
