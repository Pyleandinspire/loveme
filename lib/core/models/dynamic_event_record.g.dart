// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_event_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DynamicEventRecordAdapter extends TypeAdapter<DynamicEventRecord> {
  @override
  final int typeId = 6;

  @override
  DynamicEventRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DynamicEventRecord(
      eventId: fields[0] as String,
      title: fields[1] as String,
      narrativeText: fields[2] as String,
      localCgImagePath: fields[3] as String?,
      triggerAffection: fields[4] as int,
      choices: (fields[5] as List).cast<String>(),
      affectionChanges: (fields[6] as List).cast<int>(),
      createdAt: fields[7] as DateTime,
      playthroughNumber: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DynamicEventRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.eventId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.narrativeText)
      ..writeByte(3)
      ..write(obj.localCgImagePath)
      ..writeByte(4)
      ..write(obj.triggerAffection)
      ..writeByte(5)
      ..write(obj.choices)
      ..writeByte(6)
      ..write(obj.affectionChanges)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.playthroughNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamicEventRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
