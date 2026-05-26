// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_save.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameSaveAdapter extends TypeAdapter<GameSave> {
  @override
  final int typeId = 1;

  @override
  GameSave read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameSave(
      id: fields[0] as String,
      currentCharacterId: fields[1] as String?,
      affection: fields[2] as int,
      dialogueHistory: (fields[3] as List?)?.cast<DialogueRecord>(),
      shortTermMemories: (fields[4] as List?)?.cast<MemoryEntry>(),
      mediumTermMemories: (fields[5] as List?)?.cast<MemoryEntry>(),
      longTermMemories: (fields[6] as List?)?.cast<MemoryEntry>(),
      createdAt: fields[7] as DateTime?,
      lastPlayedAt: fields[8] as DateTime?,
      playthroughCount: fields[9] as int,
      unlockedScenes: (fields[10] as List?)?.cast<String>(),
      characterStates: (fields[11] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameSave obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.currentCharacterId)
      ..writeByte(2)
      ..write(obj.affection)
      ..writeByte(3)
      ..write(obj.dialogueHistory)
      ..writeByte(4)
      ..write(obj.shortTermMemories)
      ..writeByte(5)
      ..write(obj.mediumTermMemories)
      ..writeByte(6)
      ..write(obj.longTermMemories)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastPlayedAt)
      ..writeByte(9)
      ..write(obj.playthroughCount)
      ..writeByte(10)
      ..write(obj.unlockedScenes)
      ..writeByte(11)
      ..write(obj.characterStates);
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
