// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AIConfigAdapter extends TypeAdapter<AIConfig> {
  @override
  final int typeId = 4;

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
      typingSpeed: fields[4] as int,
      theme: fields[5] as String,
      soundEnabled: fields[6] as bool,
      voiceInputEnabled: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AIConfig obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.provider)
      ..writeByte(1)
      ..write(obj.apiKey)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.baseUrl)
      ..writeByte(4)
      ..write(obj.typingSpeed)
      ..writeByte(5)
      ..write(obj.theme)
      ..writeByte(6)
      ..write(obj.soundEnabled)
      ..writeByte(7)
      ..write(obj.voiceInputEnabled);
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
