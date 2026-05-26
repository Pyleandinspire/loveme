import 'package:hive/hive.dart';
import 'dialogue.dart';
import 'memory_entry.dart';

part 'game_save.g.dart';

@HiveType(typeId: 1)
class GameSave extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? currentCharacterId;

  @HiveField(2)
  int affection;

  @HiveField(3)
  List<DialogueRecord> dialogueHistory;

  @HiveField(4)
  List<MemoryEntry> shortTermMemories;

  @HiveField(5)
  List<MemoryEntry> mediumTermMemories;

  @HiveField(6)
  List<MemoryEntry> longTermMemories;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime lastPlayedAt;

  @HiveField(9)
  int playthroughCount;

  @HiveField(10)
  List<String> unlockedScenes;

  @HiveField(11)
  Map<String, dynamic> characterStates;

  GameSave({
    required this.id,
    this.currentCharacterId,
    this.affection = 0,
    List<DialogueRecord>? dialogueHistory,
    List<MemoryEntry>? shortTermMemories,
    List<MemoryEntry>? mediumTermMemories,
    List<MemoryEntry>? longTermMemories,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    this.playthroughCount = 1,
    List<String>? unlockedScenes,
    Map<String, dynamic>? characterStates,
  })  : dialogueHistory = dialogueHistory ?? [],
        shortTermMemories = shortTermMemories ?? [],
        mediumTermMemories = mediumTermMemories ?? [],
        longTermMemories = longTermMemories ?? [],
        createdAt = createdAt ?? DateTime.now(),
        lastPlayedAt = lastPlayedAt ?? DateTime.now(),
        unlockedScenes = unlockedScenes ?? [],
        characterStates = characterStates ?? {};

  GameSave copyWith({
    String? id,
    String? currentCharacterId,
    int? affection,
    List<DialogueRecord>? dialogueHistory,
    List<MemoryEntry>? shortTermMemories,
    List<MemoryEntry>? mediumTermMemories,
    List<MemoryEntry>? longTermMemories,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    int? playthroughCount,
    List<String>? unlockedScenes,
    Map<String, dynamic>? characterStates,
  }) {
    return GameSave(
      id: id ?? this.id,
      currentCharacterId: currentCharacterId ?? this.currentCharacterId,
      affection: affection ?? this.affection,
      dialogueHistory: dialogueHistory ?? List.from(this.dialogueHistory),
      shortTermMemories:
          shortTermMemories ?? List.from(this.shortTermMemories),
      mediumTermMemories:
          mediumTermMemories ?? List.from(this.mediumTermMemories),
      longTermMemories:
          longTermMemories ?? List.from(this.longTermMemories),
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      playthroughCount: playthroughCount ?? this.playthroughCount,
      unlockedScenes: unlockedScenes ?? List.from(this.unlockedScenes),
      characterStates: characterStates ?? Map.from(this.characterStates),
    );
  }
}
