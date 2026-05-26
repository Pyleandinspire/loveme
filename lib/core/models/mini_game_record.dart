import 'package:hive/hive.dart';

part 'mini_game_record.g.dart';

@HiveType(typeId: 5)
class MiniGameRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String gameType; // 'blackjack', 'idiom', 'focus'

  @HiveField(2)
  bool won;

  @HiveField(3)
  int affectionChange;

  @HiveField(4)
  DateTime playedAt;

  @HiveField(5)
  Map<String, dynamic>? gameData;

  MiniGameRecord({
    required this.id,
    required this.gameType,
    required this.won,
    required this.affectionChange,
    required this.playedAt,
    this.gameData,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameType': gameType,
      'won': won,
      'affectionChange': affectionChange,
      'playedAt': playedAt.toIso8601String(),
      'gameData': gameData,
    };
  }

  factory MiniGameRecord.fromJson(Map<String, dynamic> json) {
    return MiniGameRecord(
      id: json['id'] ?? '',
      gameType: json['gameType'] ?? '',
      won: json['won'] ?? false,
      affectionChange: json['affectionChange'] ?? 0,
      playedAt: json['playedAt'] is DateTime
          ? json['playedAt']
          : DateTime.tryParse(json['playedAt'] ?? '') ?? DateTime.now(),
      gameData: json['gameData'],
    );
  }
}
