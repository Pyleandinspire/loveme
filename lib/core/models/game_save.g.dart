// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_save.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameSaveAdapter extends TypeAdapter<GameSave> {
  @override
  final int typeId = 0;

  @override
  GameSave read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameSave(
      currentCharacterId: fields[0] as String,
      affection: fields[1] as int,
      dialogueHistory: (fields[2] as List).cast<DialogueRecord>(),
      lastPlayTime: fields[3] as DateTime,
      emotionState: (fields[4] as Map).cast<String, int>(),
      shortTermMemory: (fields[5] as List).cast<DialogueRecord>(),
      mediumTermMemory: (fields[6] as List).cast<String>(),
      longTermMemory: (fields[7] as List).cast<MemoryEntry>(),
      generatedEvents: (fields[8] as List).cast<DynamicEventRecord>(),
      playthroughNumber: fields[9] as int,
      focusHistory: (fields[10] as List).cast<FocusRecord>(),
      totalFocusMinutes: fields[11] as int,
      dailyAffectionGainedFromGames: fields[12] as int,
      dailyAffectionGainedFromFocus: fields[13] as int,
      lastInteractionTimestamp: fields[14] as DateTime?,
      lastGameContextTag: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GameSave obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.currentCharacterId)
      ..writeByte(1)
      ..write(obj.affection)
      ..writeByte(2)
      ..write(obj.dialogueHistory)
      ..writeByte(3)
      ..write(obj.lastPlayTime)
      ..writeByte(4)
      ..write(obj.emotionState)
      ..writeByte(5)
      ..write(obj.shortTermMemory)
      ..writeByte(6)
      ..write(obj.mediumTermMemory)
      ..writeByte(7)
      ..write(obj.longTermMemory)
      ..writeByte(8)
      ..write(obj.generatedEvents)
      ..writeByte(9)
      ..write(obj.playthroughNumber)
      ..writeByte(10)
      ..write(obj.focusHistory)
      ..writeByte(11)
      ..write(obj.totalFocusMinutes)
      ..writeByte(12)
      ..write(obj.dailyAffectionGainedFromGames)
      ..writeByte(13)
      ..write(obj.dailyAffectionGainedFromFocus)
      ..writeByte(14)
      ..write(obj.lastInteractionTimestamp)
      ..writeByte(15)
      ..write(obj.lastGameContextTag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSaveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
