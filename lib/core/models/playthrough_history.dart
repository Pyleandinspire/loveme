import 'package:hive/hive.dart';

part 'playthrough_history.g.dart';

@HiveType(typeId: 13)
class PlaythroughHistory extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String characterId;

  @HiveField(2)
  String characterName;

  @HiveField(3)
  int finalAffection;

  @HiveField(4)
  String endingTitle;

  @HiveField(5)
  String? cgImagePath;

  @HiveField(6)
  DateTime completedAt;

  @HiveField(7)
  int playthroughNumber;

  PlaythroughHistory({
    required this.id,
    required this.characterId,
    required this.characterName,
    required this.finalAffection,
    required this.endingTitle,
    this.cgImagePath,
    required this.completedAt,
    required this.playthroughNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'characterName': characterName,
      'finalAffection': finalAffection,
      'endingTitle': endingTitle,
      'cgImagePath': cgImagePath,
      'completedAt': completedAt.toIso8601String(),
      'playthroughNumber': playthroughNumber,
    };
  }

  factory PlaythroughHistory.fromJson(Map<String, dynamic> json) {
    return PlaythroughHistory(
      id: json['id'] ?? '',
      characterId: json['characterId'] ?? '',
      characterName: json['characterName'] ?? '',
      finalAffection: json['finalAffection'] ?? 0,
      endingTitle: json['endingTitle'] ?? '',
      cgImagePath: json['cgImagePath'],
      completedAt: json['completedAt'] is DateTime
          ? json['completedAt']
          : DateTime.tryParse(json['completedAt'] ?? '') ?? DateTime.now(),
      playthroughNumber: json['playthroughNumber'] ?? 1,
    );
  }
}
