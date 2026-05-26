// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmotionStateAdapter extends TypeAdapter<EmotionState> {
  @override
  final int typeId = 8;

  @override
  EmotionState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmotionState(
      happy: fields[0] as int,
      shy: fields[1] as int,
      angry: fields[2] as int,
      sad: fields[3] as int,
      coquettish: fields[4] as int,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EmotionState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.happy)
      ..writeByte(1)
      ..write(obj.shy)
      ..writeByte(2)
      ..write(obj.angry)
      ..writeByte(3)
      ..write(obj.sad)
      ..writeByte(4)
      ..write(obj.coquettish)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
