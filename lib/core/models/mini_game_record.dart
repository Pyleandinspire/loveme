import 'package:hive/hive.dart';

part 'mini_game_record.g.dart';

@HiveType(typeId: 2)
class MiniGameRecord extends HiveObject {
  @HiveField(0)
  String gameType;

  @HiveField(1)
  int wins;

  @HiveField(2)
  int losses;

  @HiveField(3)
  int highScore;

  @HiveField(4)
  DateTime lastPlayTime;

  MiniGameRecord({
    required this.gameType,
    this.wins = 0,
    this.losses = 0,
    this.highScore = 0,
    required this.lastPlayTime,
  });
}
