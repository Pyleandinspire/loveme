// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_game_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MiniGameRecordAdapter extends TypeAdapter<MiniGameRecord> {
  @override
  final int typeId = 2;

  @override
  MiniGameRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MiniGameRecord(
      gameType: fields[0] as String,
      wins: fields[1] as int,
      losses: fields[2] as int,
      highScore: fields[3] as int,
      lastPlayTime: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MiniGameRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.gameType)
      ..writeByte(1)
      ..write(obj.wins)
      ..writeByte(2)
      ..write(obj.losses)
      ..writeByte(3)
      ..write(obj.highScore)
      ..writeByte(4)
      ..write(obj.lastPlayTime);
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
