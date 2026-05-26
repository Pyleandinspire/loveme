// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_event_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DynamicEventRecordAdapter extends TypeAdapter<DynamicEventRecord> {
  @override
  final int typeId = 11;

  @override
  DynamicEventRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DynamicEventRecord(
      id: fields[0] as String,
      characterId: fields[1] as String,
      eventType: fields[2] as String,
      affectionLevel: fields[3] as int,
      title: fields[4] as String,
      description: fields[5] as String,
      cgImagePath: fields[6] as String?,
      sceneDescription: fields[7] as String,
      dialogueTexts: (fields[8] as List).cast<String>(),
      options: (fields[9] as List).cast<DialogueOption>(),
      triggeredAt: fields[10] as DateTime,
      chosenOptionId: fields[11] as String?,
      affectionChange: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DynamicEventRecord obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.characterId)
      ..writeByte(2)
      ..write(obj.eventType)
      ..writeByte(3)
      ..write(obj.affectionLevel)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.cgImagePath)
      ..writeByte(7)
      ..write(obj.sceneDescription)
      ..writeByte(8)
      ..write(obj.dialogueTexts)
      ..writeByte(9)
      ..write(obj.options)
      ..writeByte(10)
      ..write(obj.triggeredAt)
      ..writeByte(11)
      ..write(obj.chosenOptionId)
      ..writeByte(12)
      ..write(obj.affectionChange);
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

class DialogueOptionAdapter extends TypeAdapter<DialogueOption> {
  @override
  final int typeId = 12;

  @override
  DialogueOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DialogueOption(
      id: fields[0] as String,
      text: fields[1] as String,
      affectionChange: fields[2] as int,
      nextDialogueId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DialogueOption obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.affectionChange)
      ..writeByte(3)
      ..write(obj.nextDialogueId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DialogueOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
