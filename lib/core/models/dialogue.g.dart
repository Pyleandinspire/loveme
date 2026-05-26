// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DialogueRecordAdapter extends TypeAdapter<DialogueRecord> {
  @override
  final int typeId = 2;

  @override
  DialogueRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DialogueRecord(
      speaker: fields[0] as String,
      content: fields[1] as String,
      timestamp: fields[2] as DateTime,
      emotion: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DialogueRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.speaker)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.emotion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DialogueRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
