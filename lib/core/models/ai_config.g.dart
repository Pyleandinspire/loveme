// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AIConfigAdapter extends TypeAdapter<AIConfig> {
  @override
  final int typeId = 3;

  @override
  AIConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AIConfig(
      provider: fields[0] as String,
      apiKey: fields[1] as String,
      model: fields[2] as String,
      baseUrl: fields[3] as String?,
      updatedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AIConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.provider)
      ..writeByte(1)
      ..write(obj.apiKey)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.baseUrl)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
