import 'package:hive/hive.dart';

part 'custom_character_record.g.dart';

@HiveType(typeId: 9)
class CustomCharacterRecord extends HiveObject {
  @HiveField(0)
  String customCharacterId;

  @HiveField(1)
  String baseCharacterId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String personality;

  @HiveField(4)
  String appearanceDescription;

  @HiveField(5)
  List<String> referenceImagePaths;

  @HiveField(6)
  String generatedAvatarPath;

  @HiveField(7)
  String generatedPortraitPath;

  @HiveField(8)
  DateTime createdAt;

  CustomCharacterRecord({
    required this.customCharacterId,
    required this.baseCharacterId,
    required this.name,
    required this.personality,
    required this.appearanceDescription,
    required this.referenceImagePaths,
    required this.generatedAvatarPath,
    required this.generatedPortraitPath,
    required this.createdAt,
  });
}
