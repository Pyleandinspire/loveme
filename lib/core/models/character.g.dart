// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 0;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      id: fields[0] as String,
      name: fields[1] as String,
      avatar: fields[2] as String,
      portrait: fields[3] as String,
      personality: fields[4] as String,
      description: fields[5] as String,
      backstory: fields[6] as String,
      traits: (fields[7] as Map).cast<String, int>(),
      appearanceDescription: fields[8] as String,
      referenceImagePaths: (fields[9] as List).cast<String>(),
      isCustom: fields[10] as bool,
      sharedMemories: (fields[11] as List).cast<SharedMemory>(),
    );
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatar)
      ..writeByte(3)
      ..write(obj.portrait)
      ..writeByte(4)
      ..write(obj.personality)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.backstory)
      ..writeByte(7)
      ..write(obj.traits)
      ..writeByte(8)
      ..write(obj.appearanceDescription)
      ..writeByte(9)
      ..write(obj.referenceImagePaths)
      ..writeByte(10)
      ..write(obj.isCustom)
      ..writeByte(11)
      ..write(obj.sharedMemories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SharedMemoryAdapter extends TypeAdapter<SharedMemory> {
  @override
  final int typeId = 10;

  @override
  SharedMemory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedMemory(
      key: fields[0] as String,
      value: fields[1] as String,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SharedMemory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedMemoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
