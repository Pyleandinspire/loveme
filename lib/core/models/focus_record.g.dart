// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FocusRecordAdapter extends TypeAdapter<FocusRecord> {
  @override
  final int typeId = 8;

  @override
  FocusRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FocusRecord(
      id: fields[0] as String,
      duration: fields[1] as int,
      completed: fields[2] as bool,
      startedAt: fields[3] as DateTime,
      completedAt: fields[4] as DateTime?,
      affectionReward: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FocusRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.completed)
      ..writeByte(3)
      ..write(obj.startedAt)
      ..writeByte(4)
      ..write(obj.completedAt)
      ..writeByte(5)
      ..write(obj.affectionReward);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
