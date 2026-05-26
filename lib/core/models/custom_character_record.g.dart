// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_character_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomCharacterRecordAdapter extends TypeAdapter<CustomCharacterRecord> {
  @override
  final int typeId = 9;

  @override
  CustomCharacterRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomCharacterRecord(
      customCharacterId: fields[0] as String,
      baseCharacterId: fields[1] as String,
      name: fields[2] as String,
      personality: fields[3] as String,
      appearanceDescription: fields[4] as String,
      referenceImagePaths: (fields[5] as List).cast<String>(),
      generatedAvatarPath: fields[6] as String,
      generatedPortraitPath: fields[7] as String,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CustomCharacterRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.customCharacterId)
      ..writeByte(1)
      ..write(obj.baseCharacterId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.personality)
      ..writeByte(4)
      ..write(obj.appearanceDescription)
      ..writeByte(5)
      ..write(obj.referenceImagePaths)
      ..writeByte(6)
      ..write(obj.generatedAvatarPath)
      ..writeByte(7)
      ..write(obj.generatedPortraitPath)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomCharacterRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
