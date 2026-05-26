// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaythroughHistoryAdapter extends TypeAdapter<PlaythroughHistory> {
  @override
  final int typeId = 13;

  @override
  PlaythroughHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaythroughHistory(
      id: fields[0] as String,
      characterId: fields[1] as String,
      characterName: fields[2] as String,
      finalAffection: fields[3] as int,
      endingTitle: fields[4] as String,
      cgImagePath: fields[5] as String?,
      completedAt: fields[6] as DateTime,
      playthroughNumber: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlaythroughHistory obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.characterId)
      ..writeByte(2)
      ..write(obj.characterName)
      ..writeByte(3)
      ..write(obj.finalAffection)
      ..writeByte(4)
      ..write(obj.endingTitle)
      ..writeByte(5)
      ..write(obj.cgImagePath)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.playthroughNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaythroughHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
