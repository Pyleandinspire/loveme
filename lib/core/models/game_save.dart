import 'package:hive/hive.dart';
import 'dialogue.dart';
import 'memory_entry.dart';
import 'focus_record.dart';
import 'dynamic_event_record.dart';

part 'game_save.g.dart';

@HiveType(typeId: 0)
class GameSave extends HiveObject {
  @HiveField(0)
  String currentCharacterId;

  @HiveField(1)
  int affection;

  @HiveField(2)
  List<DialogueRecord> dialogueHistory;

  @HiveField(3)
  DateTime lastPlayTime;

  @HiveField(4)
  Map<String, int> emotionState;

  @HiveField(5)
  List<DialogueRecord> shortTermMemory;

  @HiveField(6)
  List<String> mediumTermMemory;

  @HiveField(7)
  List<MemoryEntry> longTermMemory;

  @HiveField(8)
  List<DynamicEventRecord> generatedEvents;

  @HiveField(9)
  int playthroughNumber;

  @HiveField(10)
  List<FocusRecord> focusHistory;

  @HiveField(11)
  int totalFocusMinutes;

  @HiveField(12)
  int dailyAffectionGainedFromGames;

  @HiveField(13)
  int dailyAffectionGainedFromFocus;

  @HiveField(14)
  DateTime? lastInteractionTimestamp;

  @HiveField(15)
  String? lastGameContextTag;

  GameSave({
    required this.currentCharacterId,
    this.affection = 0,
    this.dialogueHistory = const [],
    required this.lastPlayTime,
    this.emotionState = const {},
    this.shortTermMemory = const [],
    this.mediumTermMemory = const [],
    this.longTermMemory = const [],
    this.generatedEvents = const [],
    this.playthroughNumber = 1,
    this.focusHistory = const [],
    this.totalFocusMinutes = 0,
    this.dailyAffectionGainedFromGames = 0,
    this.dailyAffectionGainedFromFocus = 0,
    this.lastInteractionTimestamp,
    this.lastGameContextTag,
  });
}
