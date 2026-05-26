// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_game_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MiniGameRecordAdapter extends TypeAdapter<MiniGameRecord> {
  @override
  final int typeId = 5;

  @override
  MiniGameRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MiniGameRecord(
      id: fields[0] as String,
      gameType: fields[1] as String,
      won: fields[2] as bool,
      affectionChange: fields[3] as int,
      playedAt: fields[4] as DateTime,
      gameData: (fields[5] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, MiniGameRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gameType)
      ..writeByte(2)
      ..write(obj.won)
      ..writeByte(3)
      ..write(obj.affectionChange)
      ..writeByte(4)
      ..write(obj.playedAt)
      ..writeByte(5)
      ..write(obj.gameData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MiniGameRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
