// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmotionStateAdapter extends TypeAdapter<EmotionState> {
  @override
  final int typeId = 6;

  @override
  EmotionState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmotionState(
      characterId: fields[0] as String,
      happiness: fields[1] as double,
      sadness: fields[2] as double,
      anger: fields[3] as double,
      fear: fields[4] as double,
      surprise: fields[5] as double,
      disgust: fields[6] as double,
      lastUpdated: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, EmotionState obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.characterId)
      ..writeByte(1)
      ..write(obj.happiness)
      ..writeByte(2)
      ..write(obj.sadness)
      ..writeByte(3)
      ..write(obj.anger)
      ..writeByte(4)
      ..write(obj.fear)
      ..writeByte(5)
      ..write(obj.surprise)
      ..writeByte(6)
      ..write(obj.disgust)
      ..writeByte(7)
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
