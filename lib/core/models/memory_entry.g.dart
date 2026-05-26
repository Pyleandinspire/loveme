// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemoryEntryAdapter extends TypeAdapter<MemoryEntry> {
  @override
  final int typeId = 3;

  @override
  MemoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemoryEntry(
      id: fields[0] as String,
      content: fields[1] as String,
      summary: fields[2] as String,
      timestamp: fields[3] as DateTime,
      type: fields[4] as String,
      metadata: (fields[5] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, MemoryEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.summary)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
